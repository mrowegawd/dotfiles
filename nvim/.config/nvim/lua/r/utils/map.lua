local map = vim.keymap.set

---@class r.utils.map
local M = {
  lsp = {},
}

---@alias ModeKey "n" | "i" | "x" | "o" | "v"

---@param mode ModeKey
---@param lhs string
---@param rhs string | function
---@param opts vim.keymap.set.Opts
local recursive_map = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.remap = true
  map(mode, lhs, rhs, opts)
end

local function count_spaces(input)
  local spaceCount = 0

  -- Iterasi setiap karakter dalam string
  for i = 1, #input do
    local char = input:sub(i, i)
    if char == " " then
      spaceCount = spaceCount + 1
    end
  end

  return spaceCount
end
M.show_help_buf_keymap = function()
  local Fzf = require "fzf-lua"

  local ft = vim.bo.filetype
  local tbl_maps_normal = vim.api.nvim_buf_get_keymap(0, "n")
  local tbl_maps_insert = vim.api.nvim_buf_get_keymap(0, "i")
  -- local tbl_maps_visual = vim.api.nvim_buf_get_keymap(0, "v")

  local function merge_multiple_tables(...)
    local result = {}
    for _, tbl in ipairs { ... } do
      for k, v in pairs(tbl) do
        result[k] = v
      end
    end
    return result
  end

  local tbl_maps = merge_multiple_tables(tbl_maps_normal, tbl_maps_insert)

  local col = {}

  for _, tbl in pairs(tbl_maps) do
    if tbl.desc == nil then -- remove nil desc
      tbl.desc = "<builtin>"
    end

    local c_spaces = count_spaces(tbl.lhs)

    local lhs = tbl.lhs
    if c_spaces > 0 then
      lhs = "<space>" .. RUtils.cmd.strip_whitespace(tbl.lhs)
    end

    local mode_color = "GitSignsAdd"
    if tbl.mode == "i" then
      mode_color = "GitSignsChange"
    elseif tbl.mode == "v" then
      mode_color = "GitSignsDelete"
    end

    local mode = Fzf.utils.ansi_from_hl(mode_color, tbl.mode)
    local icon_separator = Fzf.utils.ansi_from_hl("Tabline", "|")
    local desc = Fzf.utils.ansi_from_hl(mode_color, tbl.desc)

    local map_desc = string.format("%-14s %s mode:%s %s %s", lhs, icon_separator, mode, icon_separator, desc)
    col[#col + 1] = map_desc
  end

  local opts = RUtils.fzflua.open_center_height_small_but_wide {
    winopts = { title = "Keymaps For Curbuf (" .. ft .. ")" },
    actions = {
      ["default"] = function(_, _)
        RUtils.info "Not implemented yet"
      end,
    },
  }

  -- sort alphabetically
  table.sort(col)

  return require("fzf-lua").fzf_exec(col, opts)
end

M.nmap = function(...)
  recursive_map("n", ...)
end
M.imap = function(...)
  recursive_map("i", ...)
end

M.vmap = function(...)
  recursive_map("v", ...)
end

local detect_duplicate_map = function(...)
  local args = { ... } -- Menyimpan argumen dalam sebuah table
  local key = args[1] -- Misalkan 'n' adalah default mode jika tidak ada argumen
  local key_alt = args[2] -- Mengambil argumen kedua sebagai key
  local opts = args[3] -- Mengambil argumen kedua sebagai key
  if opts and opts.unique == nil then
    -- if opts.desc then
    --   print(key .. " " .. opts.desc)
    -- end
    opts.unique = true
  end
  return key, key_alt, opts
end

M.nnoremap = function(...)
  local key, key_alt, opts = detect_duplicate_map(...)
  map("n", key, key_alt, opts)
end
M.xnoremap = function(...)
  local key, key_alt, opts = detect_duplicate_map(...)
  map("x", key, key_alt, opts)
end
M.vnoremap = function(...)
  local key, key_alt, opts = detect_duplicate_map(...)
  map("v", key, key_alt, opts)
end
M.inoremap = function(...)
  local key, key_alt, opts = detect_duplicate_map(...)
  map("i", key, key_alt, opts)
end
M.onoremap = function(...)
  local key, key_alt, opts = detect_duplicate_map(...)
  map("o", key, key_alt, opts)
end
M.cnoremap = function(...)
  local key, key_alt, opts = detect_duplicate_map(...)
  map("c", key, key_alt, opts)
end
M.tnoremap = function(...)
  local key, key_alt, opts = detect_duplicate_map(...)
  map("t", key, key_alt, opts)
end

M.cabbrev = function(short, long)
  vim.cmd.cnoreabbrev(short, long)
end

---@param method string|string[]
function M.has(buffer, method)
  if type(method) == "table" then
    for _, m in ipairs(method) do
      if M.has(buffer, m) then
        return true
      end
    end
    return false
  end
  method = method:find "/" and method or "textDocument/" .. method
  local clients = vim.lsp.get_clients { bufnr = buffer }
  for _, client in ipairs(clients) do
    if client:supports_method(method) then
      return true
    end
  end
  return false
end

---@return LazyKeysLsp[]
function M.resolve(buffer, spec_maps)
  local Keys = require "lazy.core.handler.keys"
  if not Keys.resolve then
    return {}
  end
  local spec = vim.tbl_extend("force", {}, spec_maps)
  local opts = RUtils.opts "nvim-lspconfig"
  if opts ~= nil then
    local clients = vim.lsp.get_clients { bufnr = buffer }
    for _, client in ipairs(clients) do
      if opts.servers ~= nil then
        local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
        vim.list_extend(spec, maps)
      end
    end
  end
  return Keys.resolve(spec)
end

function M.on_attach(_, buffer, spec_maps)
  local Keys = require "lazy.core.handler.keys"
  local keymaps = M.resolve(buffer, spec_maps)

  for _, keys in pairs(keymaps) do
    local has = not keys.has or M.has(buffer, keys.has)
    local cond = not (keys.cond == false or ((type(keys.cond) == "function") and not keys.cond()))

    if has and cond then
      local opts = Keys.opts(keys)
      opts.cond = nil
      opts.has = nil
      opts.silent = opts.silent ~= false
      opts.buffer = buffer
      -- if opts.unique == nil then
      --   opts.unique = true
      -- end
      map(keys.mode or "n", keys.lhs, keys.rhs, opts)
    end
  end
end

function M.escape(text, additional_char)
  if not additional_char then
    additional_char = ""
  end
  return vim.fn.escape(text, "/" .. additional_char)
end

function M.getVisualSelection()
  vim.cmd 'noau normal! "vy"'
  local text = vim.fn.getreg "v"
  vim.fn.setreg("v", {})
  text = string.gsub(text, "\n", "")
  if #text > 0 then
    return text
  else
    return ""
  end
end

---@param key string
---@param mode? ModeKey
function M.feedkey(key, mode)
  mode = mode or "n"
  if mode == "" then
    mode = "n"
  end
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

---@param key string
function M.feedkey_with_no_escape(key)
  vim.api.nvim_feedkeys(key, "n", false)
end

---@param cmd string
function M.wrap_fold_cmd(cmd)
  local _, err = pcall(function()
    vim.cmd(cmd)
  end)
  if err and (string.match(err, "E490") or string.match(err, "No fold found")) then
    RUtils.warn "No fold found"
  end
end

---@param au_name string
---@param tbl_ft table<string>
function M.disable_ctrl_i_and_o(au_name, tbl_ft)
  local augroup = vim.api.nvim_create_augroup(au_name, { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = tbl_ft,
    group = augroup,
    callback = function()
      vim.keymap.set("n", "<c-i>", "<Nop>", {
        buffer = vim.api.nvim_get_current_buf(),
      })
      vim.keymap.set("n", "<c-o>", "<Nop>", {
        buffer = vim.api.nvim_get_current_buf(),
      })
    end,
  })
end

---@param items {bufnr: integer, filename: string, lnum:integer}
local function all_item_locations_equal(items)
  if #items == 0 then
    return false
  end
  for i = 2, #items do
    local item = items[i]
    if item.bufnr ~= items[1].bufnr or item.filename ~= items[1].filename or item.lnum ~= items[1].lnum then
      return false
    end
  end
  return true
end

---@param yield any
---@param open_mode? "vsplit" | "split" | "newtab" | "none"
function M.lsp.wrap_location_method(yield, open_mode)
  open_mode = open_mode or "none"

  return function()
    local from = vim.fn.getpos "."
    yield {
      ---@param t vim.lsp.LocationOpts.OnList
      on_list = function(t)
        local curpos = vim.fn.getpos "."
        if not vim.deep_equal(from, curpos) then
          -- We have moved the cursor since fetching locations, so abort
          return
        end

        if open_mode ~= "none" then
          vim.cmd(open_mode)
        end

        if all_item_locations_equal(t.items) then
          -- Mostly copied from neovim source
          local item = t.items[1]
          local b = item.bufnr or vim.fn.bufadd(item.filename)

          -- Save position in jumplist
          vim.cmd "normal! m'"
          -- Push a new item into tagstack
          local tagname = vim.fn.expand "<cword>"
          local tagstack = { { tagname = tagname, from = from } }
          local winid = vim.api.nvim_get_current_win()
          vim.fn.settagstack(vim.fn.win_getid(winid), { items = tagstack }, "t")

          vim.bo[b].buflisted = true
          vim.api.nvim_win_set_buf(winid, b)
          pcall(vim.api.nvim_win_set_cursor, winid, { item.lnum, item.col - 1 })
          vim._with({ win = winid }, function()
            -- Open folds under the cursor
            vim.cmd "normal! zv"
          end)
        else
          vim.fn.setloclist(0, {}, " ", { title = t.title, items = t.items })
          vim.cmd.lopen()
        end
      end,
    }
  end
end

---@param next integer
---@param severity vim.diagnostic.Severity | nil
function M.lsp.diagnostic_goto(next, severity)
  local go = next and 1 or -1
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    vim.diagnostic.jump { severity = severity, float = false, count = go }
  end
end

local is_set_toggle_words = false
function M.lsp.toggle_words()
  local notify_msg
  local is_enabled = Snacks.words.enabled

  if is_enabled and is_set_toggle_words then
    Snacks.words.disable()
    is_set_toggle_words = false
    notify_msg = "LSP Document Highlight: OFF"
  else
    Snacks.words.enable()
    is_set_toggle_words = true
    notify_msg = "LSP Document Highlight: ON"
  end
  RUtils.info(notify_msg)
end

---@param is_next? boolean
function M.go_prev_or_next_buffer(is_next)
  is_next = is_next or false

  local cmd_msg

  if is_next then
    cmd_msg = "bnext"
  else
    cmd_msg = "bprev"
  end

  vim.cmd(cmd_msg)
end

---@param winid number
---@param f fun(): any
---@return any
local function win_call(winid, f)
  if winid == 0 or winid == vim.api.nvim_get_current_win() then
    return f()
  else
    return vim.api.nvim_win_call(winid, f)
  end
end

local ft_disabled = { "neo-tree", "aerial" }

---@param winid number
---@param lnum number
---@return number
local function fold_closed(winid, lnum)
  return win_call(winid, function()
    return vim.fn.foldclosed(lnum)
  end)
end

---@param is_jump_prev boolean
---@param is_toggle boolean
local function go_next_or_prev_fold(is_jump_prev, is_toggle)
  is_toggle = is_toggle or false
  local count = vim.v.count1
  local cnt = 0
  local lnum
  if is_jump_prev then
    local curLnum = vim.api.nvim_win_get_cursor(0)[1]
    for i = curLnum - 1, 1, -1 do
      if fold_closed(0, i) == i then
        cnt = cnt + 1
        lnum = i
        if cnt == count then
          break
        end
      end
    end

    if lnum then
      vim.cmd "norm! m`"
      vim.api.nvim_win_set_cursor(0, { lnum, 0 })

      if is_toggle then
        if vim.fn.foldclosed(vim.fn.line ".") ~= -1 then
          vim.cmd "normal! zMzvzz"
        end
      end
    else
      vim.cmd "norm! zk"
    end
  else
    local curLnum = vim.api.nvim_win_get_cursor(0)[1]
    local lineCount = vim.api.nvim_buf_line_count(0)
    for i = curLnum + 1, lineCount do
      if fold_closed(0, i) == i then
        cnt = cnt + 1
        lnum = i
        if cnt == count then
          break
        end
      end
    end

    if lnum then
      vim.cmd "norm! m`"
      vim.api.nvim_win_set_cursor(0, { lnum, 0 })

      if is_toggle then
        if vim.fn.foldclosed(vim.fn.line ".") ~= -1 then
          vim.cmd "normal! zMzvzz"
        end
      end
    else
      vim.cmd "norm! zj"
    end
  end
end

---@param is_jump_prev? boolean
function M.magic_jump(is_jump_prev)
  is_jump_prev = is_jump_prev or false

  if vim.tbl_contains(ft_disabled, vim.bo[0].filetype) then
    if is_jump_prev then
      return RUtils.map.feedkey("<c-p>", "n")
    end
    return RUtils.map.feedkey("<c-n>", "n")
  end

  if vim.wo.diff then
    if is_jump_prev then
      return RUtils.map.feedkey("[c", "n")
    else
      return RUtils.map.feedkey("]c", "n")
    end
  end

  if vim.bo.filetype == "http" then
    local ok, kulala = pcall(require, "kulala")
    if not ok then
      return
    end

    if is_jump_prev then
      return kulala.jump_prev()
    end

    return kulala.jump_next()
  end

  if vim.bo[0].filetype == "markdown" then
    if is_jump_prev then
      return RUtils.markdown.go_to_heading(nil, {})
    end
    return RUtils.markdown.go_to_heading(nil)
  end

  go_next_or_prev_fold(is_jump_prev, false)
end

return M
