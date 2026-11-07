local lazy = require("utils.plugin").require_lazy

local Log = lazy "utils.log"

local M = {}

local hover = {
  win = nil,
  buf = nil,
}

local auto_active = false
local auto_augroup = vim.api.nvim_create_augroup("LspHoverAuto", { clear = true })

---@class LspHoverConfig
---@field layout "split"|"float"
---@field split_max_height integer
---@field split_min_height integer
---@field split_position "above"|"below"
---@field float_ratio number
---@field float_width_ratio number
---@field float_border string
---@field float_padding integer
---@field auto_delay integer ms to wait before showing auto-hover

---@type LspHoverConfig
M.config = {
  layout = "split",

  split_max_height = 8,
  split_min_height = 1,
  split_position = "above",

  float_ratio = 0.25,
  float_width_ratio = 0.5,
  float_border = "rounded",
  float_padding = 2,

  auto_delay = 500, -- Show after 500ms of inactivity in insert mode
}

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                                   Helpers                                   ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

local function calc_split_height(line_count)
  return math.max(M.config.split_min_height, math.min(line_count, M.config.split_max_height))
end

local function calc_float_height()
  return math.max(1, math.floor(vim.o.lines * M.config.float_ratio))
end

local function is_open()
  return hover.win ~= nil and vim.api.nvim_win_is_valid(hover.win)
end

local function close()
  if hover.win and vim.api.nvim_win_is_valid(hover.win) then
    pcall(vim.api.nvim_win_close, hover.win, true)
  end
  if hover.buf and vim.api.nvim_buf_is_valid(hover.buf) then
    pcall(vim.api.nvim_buf_delete, hover.buf, { force = true })
  end
  hover.win, hover.buf = nil, nil
end

---Check if the character before the cursor is `(` or `,` (ignoring trailing whitespace).
---If so, we're probably typing function arguments.
---@return boolean
local function is_in_call_args()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] -- 0-based byte
  local left = line:sub(1, col)
  left = left:gsub("%s+$", "")
  local last = left:sub(-1)
  return last == "(" or last == ","
end

---Get the symbol name from the hover result, falling back to `<cword>`.
local function resolve_symbol(result, caller_win)
  local function extract(str)
    if type(str) ~= "string" then
      return nil
    end
    return str:match "([%w%._]+)%s*%("
  end

  local contents = result and result.contents
  local name
  if type(contents) == "table" then
    name = extract(contents.value) or extract(contents[1])
  else
    name = extract(contents)
  end
  if name then
    return name
  end

  if vim.api.nvim_get_current_win() ~= caller_win then
    vim.api.nvim_set_current_win(caller_win)
  end
  local cword = vim.fn.expand "<cword>"
  return cword ~= "" and cword or "unknown"
end

local function setup_buffer(bufnr, winid, symbol)
  vim.api.nvim_buf_set_name(bufnr, "LSP Hover --> " .. symbol)
  vim.api.nvim_set_option_value("filetype", "eldochover", { buf = bufnr })
  vim.api.nvim_set_option_value("modifiable", false, { buf = bufnr })
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = bufnr })
  vim.api.nvim_set_option_value("buftype", "nofile", { buf = bufnr })
  vim.api.nvim_set_option_value("swapfile", false, { buf = bufnr })

  if winid then
    vim.api.nvim_set_option_value("wrap", true, { win = winid })
    local winhighlight_note_panel = table.concat({
      "Normal:NormalNote",
      "NormalNC:NormalNote",
      "ColorColumn:NormalNote",
      "EndOfBuffer:NormalNote",
      "SignColumn:NormalNote",
      "NormalFloat:NormalNote",
      "FloatBorder:FloatBorderNote",
      "FloatTitle:FloatTitleNote",
      "FloatFooter:FloatFooterNote",
    }, ",")
    vim.wo[winid].winhighlight = winhighlight_note_panel
  end

  vim.schedule(function()
    vim.treesitter.language.register("markdown", "eldochover")
  end)
end

local function setup_keymaps(bufnr)
  vim.keymap.set("n", "q", close, { buffer = bufnr, desc = "Close LSP hover" })
end

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                                   Layout                                    ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

local function open_split(bufnr, height)
  return vim.api.nvim_open_win(bufnr, false, {
    split = M.config.split_position,
    win = -1,
    height = height,
    style = "minimal",
  })
end

---Open a sticky float in the top-right corner of the editor.
local function open_float(bufnr)
  local height = calc_float_height()
  local width = math.max(20, math.floor(vim.o.columns * M.config.float_width_ratio))
  local col = math.max(0, vim.o.columns - width - M.config.float_padding)
  return vim.api.nvim_open_win(bufnr, true, {
    relative = "editor",
    row = M.config.float_padding,
    col = col,
    width = width,
    height = height,
    style = "minimal",
    border = M.config.float_border,
  })
end

local function attach_render_markdown(bufnr)
  local ok, render = pcall(require, "render-markdown")
  if not ok then
    return
  end
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  local state_ok, state = pcall(require, "render-markdown.state")
  if state_ok and state.get then
    pcall(state.get, bufnr)
  end
  pcall(function()
    vim.api.nvim_buf_call(bufnr, function()
      render.buf_enable()
    end)
  end)
end

---Open the content buffer in the requested layout and set it up.
---@param lines string[]
---@param symbol string
---@param layout? "split"|"float"
local function present(lines, symbol, layout)
  close()

  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

  local layout_kind = layout or M.config.layout
  local winid
  if layout_kind == "float" then
    winid = open_float(bufnr)
  else
    winid = open_split(bufnr, calc_split_height(#lines))
  end

  hover.buf, hover.win = bufnr, winid

  setup_buffer(bufnr, winid, symbol)
  setup_keymaps(bufnr)
  vim.api.nvim_set_option_value("winfixheight", true, { win = winid })

  vim.schedule(function()
    if not vim.api.nvim_buf_is_valid(bufnr) then
      return
    end
    pcall(vim.treesitter.start, bufnr, "markdown")
    attach_render_markdown(bufnr)
  end)
end

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                           Signature help → lines                            ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

---Format the LSP signature help result into Markdown lines.
---@param result table
---@return string[]|nil
local function format_signature(result)
  if not result or not result.signatures or vim.tbl_isempty(result.signatures) then
    return nil
  end

  local lines = {}
  local active_sig = (result.activeSignature or 0) + 1
  local active_param = result.activeParameter

  for i, sig in ipairs(result.signatures) do
    local label = sig.label or ""
    local marker = (i == active_sig) and "▶ " or "  "

    if i == active_sig and active_param ~= nil and sig.parameters and sig.parameters[active_param + 1] then
      -- Highlight the active parameter with backticks.
      local p = sig.parameters[active_param + 1]
      local ls, le = p.label[1], p.label[2]
      if type(ls) == "number" and type(le) == "number" then
        label = label:sub(1, ls) .. "**" .. label:sub(ls + 1, le) .. "**" .. label:sub(le + 1)
      end
    end

    table.insert(lines, marker .. "`" .. label .. "`")

    -- Show a short description for the active signature.
    local doc = sig.documentation
    if i == active_sig and doc then
      local text = type(doc) == "table" and doc.value or doc
      if type(text) == "string" and text ~= "" then
        for _, l in ipairs(vim.split(text, "\n", { plain = true })) do
          table.insert(lines, "   " .. l)
        end
      end
    end

    -- Show documentation for the active parameter.
    if i == active_sig and active_param ~= nil and sig.parameters and sig.parameters[active_param + 1] then
      local p = sig.parameters[active_param + 1]
      local pdoc = p.documentation
      if pdoc then
        local text = type(pdoc) == "table" and pdoc.value or pdoc
        if type(text) == "string" and text ~= "" then
          table.insert(lines, "")
          table.insert(lines, "**param:**")
          for _, l in ipairs(vim.split(text, "\n", { plain = true })) do
            table.insert(lines, "   " .. l)
          end
        end
      end
    end

    if i ~= #result.signatures then
      table.insert(lines, "")
    end
  end

  return lines
end

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                                 Public API                                  ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

---Show hover or signature help based on the cursor position.
---@param layout? "split"|"float"
function M.show(layout)
  local caller_win = vim.api.nvim_get_current_win()

  -- Show signature help when inside a function's argument list.
  if is_in_call_args() then
    local params = vim.lsp.util.make_position_params(0, "utf-16")
    vim.lsp.buf_request(0, "textDocument/signatureHelp", params, function(err, result)
      if err or not result then
        return
      end
      local lines = format_signature(result)
      if not lines or vim.tbl_isempty(lines) then
        return
      end
      present(lines, "signature", layout)
    end)
    return
  end

  -- Otherwise, show regular hover information.
  local params = vim.lsp.util.make_position_params(0, "utf-32")
  vim.lsp.buf_request(0, "textDocument/hover", params, function(err, result)
    if err or not result or not result.contents then
      return
    end
    local lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
    if vim.tbl_isempty(lines) then
      return
    end
    local symbol = resolve_symbol(result, caller_win)
    present(lines, symbol, layout)
    if vim.api.nvim_win_is_valid(caller_win) then
      vim.api.nvim_set_current_win(caller_win)
    end
  end)
end

---Legacy alias for split hover.
function M.hover_in_split()
  M.show "split"
end

---Legacy alias for float hover.
function M.hover_in_float()
  M.show "float"
end

---Toggle the hover window (for normal-mode keymaps).
---@param layout? "split"|"float"
function M.toggle(layout)
  if is_open() then
    close()
    return
  end
  M.show(layout)
end

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                             Auto (insert mode)                              ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

local function has_provider(method)
  local clients = vim.lsp.get_clients { bufnr = 0 }
  for _, c in ipairs(clients) do
    local caps = c.server_capabilities
    if caps then
      if method == "hover" and caps.hoverProvider then
        return true
      end
      if method == "signature" and caps.signatureHelpProvider then
        return true
      end
    end
  end
  return false
end

local function enable_auto()
  if auto_active then
    return
  end
  auto_active = true
  vim.o.updatetime = M.config.auto_delay

  vim.api.nvim_create_autocmd("CursorHoldI", {
    group = auto_augroup,
    callback = function()
      if is_in_call_args() then
        if has_provider "signature" then
          M.show "float"
        end
      else
        if has_provider "hover" then
          M.show "float"
        end
      end
    end,
    desc = "Auto LSP signature/hover in insert mode",
  })

  vim.api.nvim_create_autocmd({ "TextChangedI", "InsertLeave" }, {
    group = auto_augroup,
    callback = function()
      if is_open() then
        close()
      end
    end,
    desc = "Close auto popup when typing",
  })
end

local function disable_auto()
  auto_active = false
  vim.api.nvim_clear_autocmds { group = auto_augroup }
  if is_open() then
    close()
  end
end

function M.toggle_auto_hover()
  if auto_active then
    disable_auto()
    Log.info "LSP auto-hover: OFF"
  else
    enable_auto()
    Log.info "LSP auto-hover: ON"
  end
end

function M.is_auto_hover_enabled()
  return auto_active
end

M.close = close
M.is_open = is_open

return M
