local M = {}

local hover = {
  win = nil,
  buf = nil,
}

---@type LspHoverConfig
M.config = {
  layout = "split",

  split_max_height = 8,
  split_min_height = 1,
  split_position = "above",

  float_ratio = 0.25,
  float_width_ratio = 0.3,
  float_border = "rounded",
  float_padding = 2,

  auto_delay = 500, -- Show after 500ms of inactivity in insert mode
}

local function calc_float_height()
  return math.max(1, math.floor(vim.o.lines * M.config.float_ratio))
end

local function calc_split_height(line_count)
  return math.max(M.config.split_min_height, math.min(line_count, M.config.split_max_height))
end

---Open a sticky float in the top-right corner of the editor.
function M.open_float(bufnr)
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

function M.open_split(bufnr, height)
  return vim.api.nvim_open_win(bufnr, false, {
    split = M.config.split_position,
    win = -1,
    height = height,
    style = "minimal",
  })
end

---@param bufnr integer
---@param winid integer
---@param opts { title: string, symbol:string? }
local function setup_buffer(bufnr, winid, opts)
  opts = opts or {}

  if not vim.tbl_isempty(opts) then
    if opts.title then
      vim.api.nvim_buf_set_name(bufnr, opts.title .. (opts.symbol and opts.symbol or ""))
    end
  end

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
end

-- ┌─────────────────────────────────────────────────────────────────────────────┐
--                                       API
-- └─────────────────────────────────────────────────────────────────────────────┘

function M.close()
  if hover.win and vim.api.nvim_win_is_valid(hover.win) then
    pcall(vim.api.nvim_win_close, hover.win, true)
  end
  if hover.buf and vim.api.nvim_buf_is_valid(hover.buf) then
    pcall(vim.api.nvim_buf_delete, hover.buf, { force = true })
  end
  hover.win, hover.buf = nil, nil
end

---@param mode "float" | "split"
---@param lines table
function M.open(mode, lines, opts)
  M.close()

  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

  local winid
  if mode == "split" then
    winid = M.open_split(bufnr, calc_split_height(#lines))
  else
    winid = M.open_float(bufnr)
  end

  hover.buf, hover.win = bufnr, winid

  setup_buffer(bufnr, winid, opts)
  return opts
end

return M
