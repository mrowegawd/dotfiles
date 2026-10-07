local map = vim.keymap.set

local Log = require "utils.log"

local M = { lsp = {} }

---@alias ModeKey
---| "n"
---| "i"
---| "x"
---| "o"
---| "v"
---| "t"
---| "c"
---| "s"

--- | ---- | ------------------------------- |
--- | `m`  | Remap keys (ikuti mapping)      |
--- | `n`  | No remap                        |
--- | `t`  | Handle sebagai typed input      |
--- | `i`  | Insert di depan typeahead       |
--- | `x`  | Execute sampai typeahead kosong |

---@alias ModeKeys ModeKey | ModeKey[]

---@param mode ModeKeys
---@param lhs string
---@param rhs string | function
---@param opts? vim.keymap.set.Opts
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
      lhs = "<space>" .. require("utils.cmd").strip_whitespaces(tbl.lhs)
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

  -- local opts = RUtils.fzflua.open_center_height_small_but_wide {
  local opts = {
    winopts = { title = "Keymaps For Curbuf (" .. ft .. ")" },
    actions = {
      ["default"] = function(_, _)
        Log.info "Not implemented yet"
      end,
    },
  }

  -- sort alphabetically
  table.sort(col)

  -- return RUtils.fzflua.setup_fzflua().fzf_exec(col, opts)
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
  local args = { ... }
  local key = args[1]
  local key_alt = args[2]
  local opts = args[3]
  local force_map = args[4] or false
  if not force_map then
    if opts and opts.unique == nil then
      opts.unique = true
    end
  else
    opts.unique = false
  end
  return key, key_alt, opts
end

---@param mode ModeKeys
---@param lhs string
---@param rhs string | function
---@param opts? vim.keymap.set.Opts
---@param force_map? boolean
local function noremap(mode, lhs, rhs, opts, force_map)
  local _, _, map_opts = detect_duplicate_map(lhs, rhs, opts, force_map)

  map_opts = map_opts or {}
  map_opts.remap = false

  map(mode, lhs, rhs, map_opts)
end

M.noremap = noremap

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
M.snoremap = function(...)
  local key, key_alt, opts = detect_duplicate_map(...)
  map("s", key, key_alt, opts)
end

M.cabbrev = function(short, long)
  vim.cmd.cnoreabbrev(short, long)
end

-- ╓─────────────────────────────────────────────────────────────────────────────╖
-- ║                                   AUGROUP                                   ║
-- ╙─────────────────────────────────────────────────────────────────────────────╜

---@param callback function
---@param list table
---@param accum table
---@return table
function M.fold(callback, list, accum)
  accum = accum or {}
  for k, v in pairs(list) do
    accum = callback(accum, v, k)
    assert(accum ~= nil, "The accumulator must be returned on each iteration")
  end
  return accum
end

---@param augroup_name string
---@param bufnr integer
function M.delete_augroup_name(augroup_name, bufnr)
  local cmds_found, cmds = pcall(vim.api.nvim_get_autocmds, { group = augroup_name, buffer = bufnr })
  if cmds_found then
    vim.tbl_map(function(cmd)
      vim.api.nvim_del_autocmd(cmd.id)
    end, cmds)
  end
end

local autocmd_keys = {
  "event",
  "buffer",
  "pattern",
  "desc",
  "command",
  "group",
  "once",
  "nested",
}

---@param name string
local function validate_autocmd(name, command)
  local incorrect = M.fold(function(accum, _, key)
    if not vim.tbl_contains(autocmd_keys, key) then
      table.insert(accum, key)
    end
    return accum
  end, command, {})

  if #incorrect > 0 then
    vim.schedule(function()
      local msg = "Incorrect keys: " .. table.concat(incorrect, ", ")
      ---@diagnostic disable-next-line: param-type-mismatch
      vim.notify(msg, "error", { title = string.format("Autocmd: %s", name) })
    end)
  end
end

function M.augroup(group_name, ...)
  local name = "Mr00x/" .. group_name
  local commands = { ... }
  assert(name ~= "User", "The name of an augroup CANNOT be User")
  assert(#commands > 0, string.format("You must specify at least one autocommand for %s", name))
  local id = vim.api.nvim_create_augroup(name, { clear = true })
  for _, autocmd in ipairs(commands) do
    validate_autocmd(name, autocmd)
    local is_callback = type(autocmd.command) == "function"
    vim.api.nvim_create_autocmd(autocmd.event, {
      group = name,
      pattern = autocmd.pattern,
      desc = autocmd.desc,
      callback = is_callback and autocmd.command or nil,
      command = not is_callback and autocmd.command or nil,
      once = autocmd.once,
      nested = autocmd.nested,
      buffer = autocmd.buffer,
    })
  end
  return id
end

-- ╓─────────────────────────────────────────────────────────────────────────────╖
-- ║                                    MISC                                     ║
-- ╙─────────────────────────────────────────────────────────────────────────────╜

---@param plugin_name string
function M.plugin_load_now(plugin_name)
  require("vim-pack").load_now(plugin_name)
end

function M.escape(text, additional_char)
  if not additional_char then
    additional_char = ""
  end
  return vim.fn.escape(text, "/" .. additional_char)
end

---@param key string
---@param mode? ModeFeedKey
function M.feedkey(key, mode)
  mode = mode or "n"
  if mode == "" then
    mode = "n"
  end

  -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
  local tc = vim.api.nvim_replace_termcodes(key, true, false, true)
  vim.api.nvim_feedkeys(tc, mode, false)
end

---@param key string
function M.feedkey_with_no_escape(key)
  vim.api.nvim_feedkeys(key, "n", false)
end

---@param au_name string
---@param tbl_ft table<string>
function M.disable_ctrl_i_and_o(au_name, tbl_ft)
  M.augroup(au_name, {
    event = "FileType",
    pattern = tbl_ft,
    desc = "Disable mapping C-o and C-i",
    command = function()
      vim.keymap.set("n", "<c-i>", "<Nop>", {
        buffer = vim.api.nvim_get_current_buf(),
      })
      vim.keymap.set("n", "<c-o>", "<Nop>", {
        buffer = vim.api.nvim_get_current_buf(),
      })
    end,
  })
end
--
-- ---@param is_next? boolean
-- function M.go_prev_or_next_buffer(is_next)
--   is_next = is_next or false
--
--   local cmd_msg
--
--   if is_next then
--     cmd_msg = "bnext"
--   else
--     cmd_msg = "bprev"
--   end
--
--   local is_buf_winfixbuf = vim.api.nvim_get_option_value("winfixbuf", { scope = "local" })
--   if not is_buf_winfixbuf then
--     vim.cmd(cmd_msg)
--     -- else
--     --   RUtils.warn("Cannot use " .. cmd_msg .. ", `winfixbuf` is enabled")
--   end
-- end
--
-- ╓─────────────────────────────────────────────────────────────────────────────╖
-- ║                                 MAGIC JUMP                                  ║
-- ╙─────────────────────────────────────────────────────────────────────────────╜

local ft_disabled = { "neo-tree", "aerial" }
local config = {
  -- Number of lines to scan ahead/behind before deciding where to jump.
  scan_size = 8,

  -- Number of lines to move when nothing interesting is found in scan window.
  fallback_lines = 6,

  -- Center viewport after every jump (`zz`).
  -- false = natural movement; viewport only nudges when cursor is near the edge.
  center_on_jump = false,
}

-- ├────────────────────────────────┤ Helpers ├─────────────────────────────┤

---@param winid number
---@param f fun(): any
local function win_call(winid, f)
  if winid == 0 or winid == vim.api.nvim_get_current_win() then
    return f()
  end
  return vim.api.nvim_win_call(winid, f)
end

--- True when `lnum` is hidden inside a closed fold (NOT the fold header).
--- foldclosed(header) == header; foldclosed(hidden) == header < hidden.
---@param lnum number
---@return boolean
local function is_hidden(lnum)
  local fc = vim.fn.foldclosed(lnum)
  return fc ~= -1 and fc ~= lnum
end

--- True when `lnum` is a fold header (first line of an open or closed fold).
---@param lnum number
---@return boolean
local function is_fold_header(lnum)
  if lnum <= 1 then
    return vim.fn.foldlevel(lnum) > 0
  end
  return vim.fn.foldlevel(lnum) > vim.fn.foldlevel(lnum - 1)
end

--- True when `lnum` is the header of a CLOSED fold specifically.
---@param lnum number
---@return boolean
local function is_closed_fold_header(lnum)
  return vim.fn.foldclosed(lnum) == lnum
end

---@param lnum number
---@return number
local function fold_level_at(lnum)
  return vim.fn.foldlevel(lnum)
end

-- ├────────────────┤ Scroll adjustment (no center by default) ├────────────────┤

local function adjust_viewport()
  if config.center_on_jump then
    vim.cmd "normal! zz"
    return
  end
  -- Nudge only when cursor lands very close to the window edge
  local row = vim.fn.winline()
  local height = vim.api.nvim_win_get_height(0)
  if row <= 2 then
    vim.cmd "normal! zt"
  elseif row >= height - 2 then
    vim.cmd "normal! zb"
  end
end

-- ├───────────┤ Scan: normal case (cursor on a visible open line) ├────────┤

--- Scan up to scan_size lines in `dir` direction.
--- Returns the first line matching one of the three priorities, or nil.
---@param cur  number
---@param dir  number
---@param last number
---@return number?
local function scan(cur, dir, last)
  local cur_lvl = fold_level_at(cur)
  local stop = dir > 0 and math.min(cur + config.scan_size, last) or math.max(cur - config.scan_size, 1)

  -- Pass 1: any visible fold header (open or closed) in range
  do
    local i = cur + dir
    while (dir > 0 and i <= stop) or (dir < 0 and i >= stop) do
      if not is_hidden(i) and is_fold_header(i) then
        return i
      end
      i = i + dir
    end
  end

  -- Pass 2: foldlevel drops → exiting a nested block
  do
    local i = cur + dir
    while (dir > 0 and i <= stop) or (dir < 0 and i >= stop) do
      if not is_hidden(i) and fold_level_at(i) < cur_lvl then
        return i
      end
      i = i + dir
    end
  end

  -- Pass 3: foldlevel rises → entering a nested block (if, for, fn, etc.)
  do
    local i = cur + dir
    while (dir > 0 and i <= stop) or (dir < 0 and i >= stop) do
      if not is_hidden(i) and fold_level_at(i) > cur_lvl then
        return i
      end
      i = i + dir
    end
  end

  return nil
end

-- ├──────┤ Scan: closed-header case (cursor is ON a closed fold header) ├──────┤

--- When sitting on a closed fold header, look for the next/prev visible
--- fold header within scan_size lines. Skips hidden lines automatically.
--- Returns nil if no header found within the window (caller does fallback).
---@param cur  number
---@param dir  number
---@param last number
---@return number?
local function scan_next_header(cur, dir, last)
  local stop = dir > 0 and math.min(cur + config.scan_size, last) or math.max(cur - config.scan_size, 1)

  local i = cur + dir
  while (dir > 0 and i <= stop) or (dir < 0 and i >= stop) do
    -- Accept both open fold headers and closed fold headers;
    -- reject lines hidden inside a closed fold.
    if not is_hidden(i) and is_fold_header(i) then
      return i
    end
    -- When scanning past a closed fold, skip its hidden interior
    -- by jumping directly to the line after the fold's last line.
    if is_closed_fold_header(i) then
      local fe = vim.fn.foldclosedend(i)
      if fe ~= -1 then
        i = dir > 0 and fe + 1 or i - 1
      else
        i = i + dir
      end
    else
      i = i + dir
    end
  end

  return nil
end

-- ├───────────────────────────────┤ Core jump ├────────────────────────────┤

---@param winid number
---@param dir   number
---@param count number
local function jump_fold(winid, dir, count)
  local cur = win_call(winid, function()
    return vim.api.nvim_win_get_cursor(winid)[1]
  end) --[[@as number]]

  local last = win_call(winid, function()
    return vim.api.nvim_buf_line_count(0)
  end) --[[@as number]]

  win_call(winid, function()
    local pos = cur

    for _ = 1, count do
      local dest

      if is_hidden(pos) then
        -- Cursor somehow landed on a hidden line (edge case).
        -- Escape upward to the fold header first.
        local fc = vim.fn.foldclosed(pos)
        if fc ~= -1 then
          pos = fc
        end
      end

      if is_closed_fold_header(pos) then
        -- Cursor is ON a closed fold header → look for the next/prev header
        -- within scan_size; do NOT enter the fold's hidden interior.
        dest = scan_next_header(pos, dir, last)
      else
        -- Normal visible line → full priority scan
        dest = scan(pos, dir, last)
      end

      if dest then
        pos = dest
      else
        -- Nothing found in scan window → plain line move (fallback)
        local fallback = pos + dir * config.fallback_lines
        pos = math.max(1, math.min(fallback, last))
        -- Make sure fallback doesn't land on a hidden line
        while is_hidden(pos) and pos >= 1 and pos <= last do
          pos = pos + dir
        end
      end
    end

    if pos ~= cur then
      vim.cmd "normal! m`" -- save original position to jumplist
      vim.api.nvim_win_set_cursor(winid, { pos, 0 })
      adjust_viewport()
    end
  end)
end

-- ├───────────────────────────┤ Public: magic_jump ├───────────────────────────┤

---@param is_jump_prev? boolean
function M.magic_jump(is_jump_prev)
  is_jump_prev = is_jump_prev or false
  local winid = vim.api.nvim_get_current_win()
  local ft = vim.bo[0].filetype

  -- Disabled filetypes: delegate to a simpler motion
  if vim.tbl_contains(ft_disabled, ft) then
    return M.feedkey(is_jump_prev and "<c-p>" or "<c-n>")
  end

  -- http (kulala plugin)
  if ft == "http" then
    local ok, kulala = pcall(require, "kulala")
    if not ok then
      return
    end
    return is_jump_prev and kulala.jump_prev() or kulala.jump_next()
  end

  -- markdown: jump between headings
  if ft == "markdown" then
    return require("utils.markdown").go_to_heading(nil, is_jump_prev and {} or nil)
  end

  -- default: scan-first fold jump
  jump_fold(winid, is_jump_prev and -1 or 1, vim.v.count1)
end

-- ├───────────────────────────┤ Search and Replace ├───────────────────────────┤

local function not_vscode()
  return vim.fn.exists "g:vscode" == 0
end

function M.search_replace_keymap(confirmation, visual)
  confirmation = confirmation or false
  visual = visual or false
  local key = [[:%s/\v]]
  local search_string = ""
  if visual then
    local selection_str = require("utils.cmd").get_visual_selection()
    if selection_str then
      search_string = selection_str.selection
    end
  else
    key = key .. [[<]]
    search_string = vim.fn.expand "<cword>"
  end
  key = key .. M.escape(search_string, "[]")
  if not visual then
    key = key .. [[>]]
  end
  key = key .. "/" .. M.escape(search_string, "&")
  if confirmation then
    key = key .. [[/gcI]]
  else
    key = key .. [[/gI]]
  end
  M.feedkey(key)

  if not_vscode() then
    local key_move = [[<Left><Left><Left>]]
    if confirmation then
      key_move = key_move .. [[<Left>]]
    end
    M.feedkey(key_move)
  end
end

-- ╓─────────────────────────────────────────────────────────────────────────────╖
-- ║                                     LSP                                     ║
-- ╙─────────────────────────────────────────────────────────────────────────────╜

---@alias lazyvim.util.cmp.Action fun():boolean?
---@type table<string, lazyvim.util.cmp.Action>
M.actions = {
  -- Native Snippets
  snippet_forward = function()
    if vim.snippet.active { direction = 1 } then
      vim.schedule(function()
        vim.snippet.jump(1)
      end)
      return true
    end
  end,
  snippet_stop = function()
    if vim.snippet then
      vim.snippet.stop()
    end
  end,
}

---@param value string|LazyKeysSpec
---@param mode? string
---@return LazyKeys
function M.parse(value, mode)
  value = type(value) == "string" and { value } or value --[[@as LazyKeysSpec]]
  local ret = vim.deepcopy(value) --[[@as LazyKeys]]
  ret.lhs = ret[1] or ""
  ret.rhs = ret[2]
  ---@diagnostic disable-next-line: no-unknown
  ret[1] = nil
  ---@diagnostic disable-next-line: no-unknown
  ret[2] = nil
  ret.mode = mode or "n"
  ret.id = vim.api.nvim_replace_termcodes(ret.lhs, true, true, true)

  if ret.ft then
    local ft = type(ret.ft) == "string" and { ret.ft } or ret.ft --[[@as string[] ]]
    ret.id = ret.id .. " (" .. table.concat(ft, ", ") .. ")"
  end

  if ret.mode ~= "n" then
    ret.id = ret.id .. " (" .. ret.mode .. ")"
  end
  return ret
end

---@param spec? (string|LazyKeysSpec)[]
function M.lsp.resolve(spec)
  ---@type LazyKeys[]
  local values = {}

  for _, value in ipairs(spec or {}) do
    value = type(value) == "string" and { value } or value --[[@as LazyKeysSpec]]

    local mode = value.mode or "n"
    local modes = type(mode) == "table" and mode or { mode }

    for _, mode in ipairs(modes) do
      local keys = M.parse(value, mode)

      if keys.rhs == vim.NIL or keys.rhs == false then
        values[keys.id] = nil
      else
        values[keys.id] = keys
      end
    end
  end

  return values
end

local skip = { mode = true, id = true, ft = true, rhs = true, lhs = true }

---@param keys LazyKeys
function M.opts(keys)
  local opts = {} ---@type LazyKeysBase
  ---@diagnostic disable-next-line: no-unknown
  for k, v in pairs(keys) do
    if type(k) ~= "number" and not skip[k] then
      ---@diagnostic disable-next-line: no-unknown
      opts[k] = v
    end
  end
  return opts
end

---@class snacks.keymap.set.Opts: vim.keymap.set.Opts
---@field ft? string|string[] Filetype(s) to set the keymap for.
---@field lsp? vim.lsp.get_clients.Filter Set for buffers with LSP clients matching this filter.
---@field enabled? boolean|fun(buf?:number): boolean condition to enable the keymap.
---@param filter vim.lsp.get_clients.Filter
---@param spec LazyKeysLspSpec[]
function M.lsp.set_keymaps(filter, spec)
  for _, keys in pairs(M.lsp.resolve(spec)) do
    ---@cast keys LazyKeysLsp
    local filters = {} ---@type vim.lsp.get_clients.Filter[]
    if keys.has then
      local methods = type(keys.has) == "string" and { keys.has } or keys.has --[[@as string[] ]]
      for _, method in ipairs(methods) do
        method = method:find "/" and method or ("textDocument/" .. method)
        filters[#filters + 1] = vim.tbl_extend("force", vim.deepcopy(filter), { method = method })
      end
    else
      filters[#filters + 1] = filter
    end

    for _, f in ipairs(filters) do
      local opts = M.opts(keys)
      ---@cast opts snacks.keymap.set.Opts
      opts.lsp = f
      opts.enabled = keys.enabled

      local key, key_alt, copts = detect_duplicate_map(keys.lhs, keys.rhs, keys[3])
      map(keys.mode or "n", key, key_alt, copts)
    end
  end
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
--
-- local function remove_duplicates_lsp(lsp_items)
--   if (lsp_items.lsp_items and #lsp_items.items == 0) or not lsp_items.items then
--     return lsp_items
--   end
--
--   local look_up = {}
--
--   local function check_tbl_element(new_tbl, element_1, element_2, element_3, element_4)
--     for _, x in pairs(new_tbl) do
--       if x.text == element_1 and x.lnum == element_2 and x.col == element_3 and x.filename == element_4 then
--         return true
--       end
--     end
--     return false
--   end
--
--   for _, x in pairs(lsp_items.items) do
--     if not check_tbl_element(look_up, x.text, x.lnum, x.col, x.filename) then
--       table.insert(look_up, x)
--     end
--   end
--
--   if #look_up > 0 then
--     lsp_items.items = vim.deepcopy(look_up)
--   end
--
--   return lsp_items
-- end
--
-- -- ---@return LazyKeysLsp[]
-- -- function M.resolve(buffer, spec_maps)
-- --   local Keys = require "lazy.core.handler.keys"
-- --   if not Keys.resolve then
-- --     return {}
-- --   end
-- --   local spec = vim.tbl_extend("force", {}, spec_maps)
-- --   local opts = RUtils.opts "nvim-lspconfig"
-- --   if opts ~= nil then
-- --     local clients = vim.lsp.get_clients { bufnr = buffer }
-- --     for _, client in ipairs(clients) do
-- --       if opts.servers ~= nil then
-- --         local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
-- --         vim.list_extend(spec, maps)
-- --       end
-- --     end
-- --   end
-- --   return Keys.resolve(spec)
-- -- end
--
-- function M.on_attach(_, buffer, spec_maps)
--   local Keys = require "lazy.core.handler.keys"
--   local keymaps = M.resolve(buffer, spec_maps)
--
--   for _, keys in pairs(keymaps) do
--     local has = not keys.has or M.has(buffer, keys.has)
--     local cond = not (keys.cond == false or ((type(keys.cond) == "function") and not keys.cond()))
--
--     if has and cond then
--       local opts = Keys.opts(keys)
--       ---@cast opts snacks.keymap.set.Opts
--       opts.cond = nil
--       opts.has = nil
--       opts.silent = opts.silent ~= false
--       opts.buffer = buffer
--       if opts.unique == nil then
--         opts.unique = true
--       end
--       map(keys.mode or "n", keys.lhs, keys.rhs, opts)
--     end
--   end
-- end
--
-- -- ---@param curpos { pos: integer, col: integer, line: string, buf: integer }
-- -- ---@return string | nil
-- -- local function get_extracted_strings(curpos)
-- --   local word_under_cursor
-- --
-- --   -- Ambil karakter di posisi kursor (bisa nil kalau di ujung baris)
-- --   local char_at_cursor = curpos.line:sub(curpos.col + 1, curpos.col + 1)
-- --
-- --   -- Ambil bagian sebelum dan sesudah kursor
-- --   local before = curpos.line:sub(1, curpos.col):match "[_%w%.:]+$"
-- --   local after = curpos.line:sub(curpos.col + 1):match "^[%w_%.:]+" or ""
-- --
-- --   -- Jika kursor berada di titik pemisah seperti '.', maka abaikan `after`
-- --   if char_at_cursor == "." or char_at_cursor == ":" then
-- --     word_under_cursor = before
-- --   else
-- --     word_under_cursor = (before or "") .. after
-- --   end
-- --
-- --   if not word_under_cursor or word_under_cursor == "" then
-- --     RUtils.warn "No string found under cursor."
-- --     return
-- --   end
-- --
-- --   return word_under_cursor
-- -- end
--
-- ---@param items {bufnr: integer, filename: string, lnum:integer}
-- local function all_item_locations_equal(items)
--   if #items == 0 then
--     return false
--   end
--   for i = 2, #items do
--     local item = items[i]
--     if item.bufnr ~= items[1].bufnr or item.filename ~= items[1].filename or item.lnum ~= items[1].lnum then
--       return false
--     end
--   end
--   return true
-- end
--
-- -- ---@param yield any
-- -- ---@param open_mode? "vsplit" | "split" | "tabnew" | "none"
-- -- function M.lsp.wrap_location_method(yield, open_mode)
-- --   open_mode = open_mode or "none"
-- --   return function()
-- --     local from = RUtils.get_curpos_under_cursor()
-- --     if not from then
-- --       return
-- --     end
-- --
-- --     local target_strings = get_extracted_strings(from)
-- --     if not target_strings then
-- --       return
-- --     end
-- --
-- --     yield {
-- --       ---@param t vim.lsp.LocationOpts.OnList
-- --       on_list = function(t)
-- --         local curpos = RUtils.get_curpos_under_cursor()
-- --         if not vim.deep_equal(from, curpos) then
-- --           -- We have moved the cursor since fetching locations, so abort
-- --           RUtils.warn("Request definition abort process,\nyour cursor postion has been changed!", { title = "LSP" })
-- --           return
-- --         end
-- --
-- --         if open_mode ~= "none" then
-- --           vim.cmd(open_mode)
-- --         end
-- --
-- --         RUtils.info("`" .. target_strings .. "`", { title = t.title })
-- --
-- --         if all_item_locations_equal(t.items) then
-- --           -- Mostly copied from neovim source
-- --           local item = t.items[1]
-- --           local b = item.bufnr or vim.fn.bufadd(item.filename)
-- --
-- --           -- Save position in jumplist
-- --           vim.cmd "normal! m'"
-- --           -- Push a new item into tagstack
-- --           local tagname = vim.fn.expand "<cword>"
-- --           local tagstack = { { tagname = tagname, from = from } }
-- --           local winid = vim.api.nvim_get_current_win()
-- --           vim.fn.settagstack(vim.fn.win_getid(winid), { items = tagstack }, "t")
-- --
-- --           vim.bo[b].buflisted = true
-- --           vim.api.nvim_win_set_buf(winid, b)
-- --           pcall(vim.api.nvim_win_set_cursor, winid, { item.lnum, item.col - 1 })
-- --           vim._with({ win = winid }, function()
-- --             -- Open folds under the cursor
-- --             vim.cmd "normal! zv"
-- --           end)
-- --         else
-- --           local items = t.items
-- --           if #t.items == 3 or #t.items == 2 then
-- --             if not vim.deep_equal(t.items[1], t.items[2]) then
-- --               items[#items + 1] = t.items[1]
-- --             end
-- --           end
-- --
-- --           local list_items = { items = items, title = t.title .. ": " .. target_strings, context = t.context }
-- --           if t.context and type(t.context) == "string" then
-- --             list_items["context"] = t.context
-- --           end
-- --           list_items = remove_duplicates_lsp(list_items)
-- --           RUtils.qf.save_to_qf_and_auto_open_qf(list_items)
-- --         end
-- --       end,
-- --     }
-- --   end
-- -- end
--
-- -- function M.lsp.wrap_references_to_send_qf()
-- --   local from = RUtils.get_curpos_under_cursor()
-- --   if not from then
-- --     return
-- --   end
-- --
-- --   local target_strings = get_extracted_strings(from)
-- --   if not target_strings then
-- --     return
-- --   end
-- --
-- --   vim.lsp.buf.references(nil, {
-- --     on_list = function(t)
-- --       local curpos = RUtils.get_curpos_under_cursor()
-- --
-- --       -- if all_item_locations_equal(t.items) then
-- --       if not vim.islist(t.items) or type(t.items) ~= "table" or #t.items == 0 then
-- --         RUtils.warn("No results request references for `" .. from.line .. "`", { title = "LSP" })
-- --         return
-- --       end
-- --
-- --       local qf_win = require("qfbookmark.utils").windows_is_opened "qf"
-- --       if qf_win.found then
-- --         pcall(vim.api.nvim_win_close, qf_win.winnr, true)
-- --       end
-- --
-- --       local items = t.items
-- --       if #t.items == 3 or #t.items == 2 then
-- --         if not vim.deep_equal(t.items[1], t.items[2]) then
-- --           items[#items + 1] = t.items[1]
-- --         end
-- --       end
-- --
-- --       RUtils.info("`" .. target_strings .. "`", { title = "LSP " .. t.title })
-- --
-- --       -- RUtils.info(vim.inspect(t.context))
-- --       -- Info ----- notify.info RUtils { method: textDocument/references, id: 13 }
-- --
-- --       -- How to get
-- --       -- getqflist({'all': 1})          " dapatkan semua field
-- --       -- getqflist({'items': 1})        " hanya items
-- --       -- getqflist({'context': 1})      " hanya context
-- --       -- getqflist({'id': id, 'items': 1, 'context': 1}) " berdasarkan id tertentu
-- --       --
-- --       --
-- --       -- Kalau kamu mau melihat context quickfix saat ini:
-- --       -- vim.notify(vim.inspect(vim.fn.getqflist({ context = 1 }).context))
-- --       --
-- --       -- Kalau kamu mau melihat semua field (termasuk items, title, context, dll):
-- --       -- vim.notify(vim.inspect(vim.fn.getqflist({ all = 1 })))
-- --       --
-- --       local set_jump = false
-- --
-- --       if not vim.deep_equal(from, curpos) then
-- --         if #t.items > 1 then
-- --           local bufname = vim.api.nvim_buf_get_name(t.context.bufnr)
-- --           vim.cmd("topleft vsplit " .. bufname)
-- --           local win_id = vim.api.nvim_get_current_win()
-- --
-- --           local target_width = 80
-- --
-- --           -- Check current window width
-- --           local cur_width = vim.api.nvim_win_get_width(win_id)
-- --           if cur_width ~= target_width then
-- --             vim.cmd "wincmd ="
-- --             vim.api.nvim_win_set_width(win_id, target_width)
-- --           end
-- --         end
-- --         set_jump = true
-- --       end
-- --
-- --       local list_items =
-- --         { items = items, title = "LSP " .. t.title .. ": " .. RUtils.lstrip_whitespace(target_strings) }
-- --       if t.context and type(t.context) == "table" then
-- --         if t.context.method and t.context.bufnr then
-- --           list_items["context"] = { name = t.context.method, bufnr = t.context.bufnr }
-- --         end
-- --       end
-- --
-- --       list_items = remove_duplicates_lsp(list_items)
-- --       RUtils.qf.save_to_qf_and_auto_open_qf(list_items)
-- --
-- --       if vim.bo.filetype == "qf" then
-- --         vim.cmd "wincmd p"
-- --       end
-- --       if set_jump then
-- --         pcall(vim.api.nvim_win_set_cursor, 0, { from.pos, from.col - 1 })
-- --         vim.cmd "normal! m'"
-- --       end
-- --     end,
-- --   })
-- -- end
--
---@param next integer
---@param severity vim.diagnostic.Severity | nil
function M.lsp.diagnostic_goto(next, severity)
  local go = next and 1 or -1
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    vim.diagnostic.jump { severity = severity, float = false, count = go }
  end
end

-- local is_set_toggle_words = false
-- function M.lsp.toggle_words()
--   local is_enabled = Snacks.words.enabled
--
--   if is_enabled and is_set_toggle_words then
--     Snacks.words.disable()
--     is_set_toggle_words = false
--   else
--     Snacks.words.enable()
--     is_set_toggle_words = true
--   end
--   RUtils.info(tostring(not is_enabled), { title = "Toggle Jump Scope Highlight" })
-- end

return M
