local map = vim.keymap.set

local lazy = require("utils.plugin").require_lazy

local Log = lazy "utils.log"

---@alias MapFn fun(lhs: string, rhs: string|function, opts?: MapOpts)

---@class utils.map
---@field lsp table
---@field noremap fun(mode: ModeKeys, lhs: string, rhs: string|function, opts?: MapOpts)
---@field remap fun(mode: ModeKeys, lhs: string, rhs: string|function, opts?: MapOpts)
---@field nnoremap MapFn
---@field xnoremap MapFn
---@field vnoremap MapFn
---@field inoremap MapFn
---@field onoremap MapFn
---@field cnoremap MapFn
---@field tnoremap MapFn
---@field snoremap MapFn
---@field nmap MapFn
---@field imap MapFn
---@field vmap MapFn
---@field [string] any
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

------ Flag untuk `nvim_feedkeys()`. Bisa digabung, mis. "nx" atau "mi".
---@alias ModeFeedKey
---| ""   # default (diperlakukan sebagai "n")
---| "m"  # remap keys (ikuti mapping)
---| "n"  # no remap
---| "t"  # handle sebagai typed input
---| "i"  # insert di depan typeahead
---| "x"  # execute sampai typeahead kosong
---| "!"  # (dengan x) jangan akhiri insert mode
---| "L"  # jangan pakai lowlevel input
---| string # kombinasi, mis. "nx", "mt"

local MODE_HL = {
  n = "GitSignsAdd",
  i = "GitSignsChange",
  x = "GitSignsDelete",
  v = "GitSignsDelete",
}

M.show_help_buf_keymap = function()
  local Fzf = lazy "fzf-lua"
  local sep = Fzf.utils.ansi_from_hl("Tabline", "|")
  local items = {}

  for _, mode in ipairs { "n", "i", "x" } do
    for _, m in ipairs(vim.api.nvim_buf_get_keymap(0, mode)) do
      local hl = MODE_HL[m.mode] or "GitSignsAdd"
      local lhs = (m.lhs:gsub(" ", "<space>"))
      local desc = Fzf.utils.ansi_from_hl(hl, m.desc or "<builtin>")
      local mode_str = Fzf.utils.ansi_from_hl(hl, m.mode)
      items[#items + 1] = string.format("%-14s %s mode:%s %s %s", lhs, sep, mode_str, sep, desc)
    end
  end

  table.sort(items)

  return Fzf.fzf_exec(items, {
    winopts = { title = "Keymaps For Curbuf (" .. vim.bo.filetype .. ")" },
    actions = {
      ["default"] = function()
        Log.info "Not implemented yet"
      end,
    },
  })
end

---@class MapOpts : vim.keymap.set.Opts
---@field force? boolean  -- paksa overwrite (unique=false); bukan opsi vim.keymap.set

---@param recursive boolean
local function make_mapper(recursive)
  ---@param mode ModeKeys
  ---@param lhs string
  ---@param rhs string | function
  ---@param opts? MapOpts
  return function(mode, lhs, rhs, opts)
    local o = vim.tbl_extend("keep", opts or {}, { remap = recursive })
    local force = o.force
    o.force = nil
    if o.unique == nil then
      o.unique = not force
    end
    map(mode, lhs, rhs, o)
  end
end

local noremap = make_mapper(false)
local remap = make_mapper(true)

M.noremap = noremap
M.remap = remap

-- nnoremap, xnoremap, vnoremap, inoremap, onoremap, cnoremap, tnoremap, snoremap
for _, mode in ipairs { "n", "x", "v", "i", "o", "c", "t", "s" } do
  M[mode .. "noremap"] = function(lhs, rhs, opts)
    return noremap(mode, lhs, rhs, opts)
  end
end

-- nmap, imap, vmap
for _, mode in ipairs { "n", "i", "v" } do
  M[mode .. "map"] = function(lhs, rhs, opts)
    return remap(mode, lhs, rhs, opts)
  end
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
      return vim.api.nvim_del_autocmd(cmd.id)
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
      local msg = "Incorrect keys: " .. table.concat(incorrect, ", ") .. string.format("Autocmd: %s", name)
      Log.error(msg)
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
  lazy("vim-pack").load_now(plugin_name)
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
---@param mode ModeFeedKey?
function M.feedkey_with_no_escape(key, mode)
  mode = mode or "n"
  vim.api.nvim_feedkeys(key, mode, false)
end

---@param key_plug string
function M.feedkey_plug(key_plug)
  if not key_plug:lower():find("<plug>", 1, true) then
    Log.warn 'Define `key_plug` using "<Plug>"'
    return
  end

  local keycode = vim.keycode(key_plug)
  M.feedkey_with_no_escape(keycode, "m")
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

function M.safe_set_cursor(win, line, col)
  local bufnr = vim.api.nvim_win_get_buf(win)
  local line_count = vim.api.nvim_buf_line_count(bufnr)

  -- Clamp line
  if line < 1 then
    line = 1
  end
  if line > line_count then
    line = line_count
  end

  -- Clamp col
  local text = vim.api.nvim_buf_get_lines(bufnr, line - 1, line, false)[1] or ""
  if col < 0 then
    col = 0
  end
  if col > #text then
    col = #text
  end

  vim.api.nvim_win_set_cursor(win, { line, col })
end

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
      M.safe_set_cursor(winid, pos, 0)
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
  -- if ft == "http" then
  --   local ok, kulala = pcall(require, "kulala")
  --   if not ok then
  --     return
  --   end
  --   return is_jump_prev and kulala.jump_prev() or kulala.jump_next()
  -- end

  -- markdown: jump between headings
  if ft == "markdown" then
    return lazy("utils.markdown").go_to_heading(nil, is_jump_prev and {} or nil)
  end

  -- default: scan-first fold jump
  jump_fold(winid, is_jump_prev and -1 or 1, vim.v.count1)
end

-- ├───────────────────────────┤ Search and Replace ├───────────────────────────┤

local function not_vscode()
  return vim.fn.exists "g:vscode" == 0
end

---@param confirmation? boolean
---@param visual? boolean
function M.search_replace_keymap(confirmation, visual)
  confirmation = confirmation or false

  local text = lazy("utils.cmd").get_selection()

  local function esc_pattern(s)
    s = vim.fn.escape(s, [[\/]])
    s = s:gsub("\n", [[\n]])
    return (s:gsub("<", "<lt>"))
  end

  local function esc_replace(s)
    s = vim.fn.escape(s, [[\/&~]])
    s = s:gsub("\n", [[\r]])
    return (s:gsub("<", "<lt>"))
  end

  local key = visual and "<Esc>" or ""

  key = key .. [[:%s/\V]]

  if not visual then
    key = key .. [[\<]]
  end

  key = key .. esc_pattern(text)

  if not visual then
    key = key .. [[\>]]
  end

  key = key .. "/" .. esc_replace(text)
  key = key .. (confirmation and "/gcI" or "/gI")

  M.feedkey(key)

  if not_vscode() then
    local key_move = confirmation and [[<Left><Left><Left><Left>]] or [[<Left><Left><Left>]]
    M.feedkey(key_move)
  end
end

-- ╓─────────────────────────────────────────────────────────────────────────────╖
-- ║                                     LSP                                     ║
-- ╙─────────────────────────────────────────────────────────────────────────────╜

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

---@class LspKeySpec
---@field [1] string                         lhs
---@field [2] string|function|false          rhs (false/vim.NIL = remove the key from the spec)
---@field mode? ModeKey|ModeKey[]
---@field has? string|string[]               LSP method that must be supported (e.g. "definition")
---@field enabled? boolean|fun(buf:integer):boolean
---@field desc? string

--- Keys that are NOT vim.keymap.set options.
local SKIP = { mode = true, id = true, ft = true, rhs = true, lhs = true, has = true, enabled = true }

---@param value string|table
---@param mode? ModeKey
function M.parse(value, mode)
  value = type(value) == "string" and { value } or value
  ---@diagnostic disable-next-line: param-type-mismatch
  local ret = vim.deepcopy(value)
  ret.lhs = ret[1] or ""
  ret.rhs = ret[2]

  -- format lama: { lhs, rhs, { desc = ... } }
  local legacy = ret[3]
  ret[1], ret[2], ret[3] = nil, nil, nil
  if type(legacy) == "table" then
    for k, v in pairs(legacy) do
      if ret[k] == nil then
        ret[k] = v
      end
    end
  end

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

--- Expand per-mode, dedupe by id (last one wins), keep the order.
---@param spec? (string|LspKeySpec)[]
---@return table[]
function M.lsp.resolve(spec)
  local by_id, order, seen = {}, {}, {}

  for _, value in ipairs(spec or {}) do
    value = type(value) == "string" and { value } or value

    local raw_mode = value.mode or "n"
    ---@type ModeKey[]
    local modes = type(raw_mode) == "table" and raw_mode or { raw_mode }

    for _, mode in ipairs(modes) do
      local keys = M.parse(value, mode)
      if keys.rhs == vim.NIL or keys.rhs == false then
        by_id[keys.id] = nil
      else
        if not seen[keys.id] then
          seen[keys.id] = true
          order[#order + 1] = keys.id
        end
        by_id[keys.id] = keys
      end
    end
  end

  local list = {}
  for _, id in ipairs(order) do
    if by_id[id] then
      list[#list + 1] = by_id[id]
    end
  end
  return list
end

---@param keys table
---@return vim.keymap.set.Opts
function M.opts(keys)
  local opts = {}
  for k, v in pairs(keys) do
    if type(k) ~= "number" and not SKIP[k] then
      opts[k] = v
    end
  end
  return opts
end

---@param buffer integer
---@param method string|string[]
---@return boolean
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
  for _, client in ipairs(vim.lsp.get_clients { bufnr = buffer }) do
    if client:supports_method(method, buffer) then
      return true
    end
  end
  return false
end

---@param k table
---@param buf integer
local function key_enabled(k, buf)
  local e = k.enabled
  if e == nil or e == true then
    return true
  end
  if type(e) == "function" then
    return e(buf) and true or false
  end
  return false
end

--- Set up LSP keymaps LAZILY: resolve once, attach buffer-local on LspAttach,
--- but only if the client actually supports `has`. Removed again on LspDetach
--- when it's no longer supported.
---@param spec (string|LspKeySpec)[]
---@return integer augroup
function M.lsp.setup_keymaps(spec)
  local keys = M.lsp.resolve(spec)
  local by_id = {}
  for _, k in ipairs(keys) do
    by_id[k.id] = k
  end

  ---@type table<integer, table<string, boolean>>
  local applied = {}

  local function apply(buf)
    if not vim.api.nvim_buf_is_valid(buf) then
      return
    end
    local done = applied[buf] or {}
    applied[buf] = done

    for _, k in ipairs(keys) do
      if not done[k.id] and (not k.has or M.has(buf, k.has)) and key_enabled(k, buf) then
        ---@class  vim.keymap.set.Opts
        local opts = M.opts(k)
        opts.buffer = buf
        opts.silent = opts.silent ~= false
        if opts.unique == nil then
          opts.unique = false
        end

        local ok, err = pcall(map, k.mode, k.lhs, k.rhs, opts)
        if ok then
          done[k.id] = true
        else
          Log.warn(("LSP keymap `%s` gagal: %s"):format(k.lhs, err))
        end
      end
    end
  end

  local function prune(buf)
    if not vim.api.nvim_buf_is_valid(buf) then
      applied[buf] = nil
      return
    end
    for id in pairs(applied[buf] or {}) do
      local k = by_id[id]
      if k and k.has and not M.has(buf, k.has) then
        pcall(vim.keymap.del, k.mode, k.lhs, { buffer = buf })
        applied[buf][id] = nil
      end
    end
  end

  local group = vim.api.nvim_create_augroup("Mr00x/LspKeymaps", { clear = true })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    desc = "Apply LSP keymaps (buffer-local)",
    callback = function(args)
      apply(args.buf)
    end,
  })

  vim.api.nvim_create_autocmd("LspDetach", {
    group = group,
    desc = "Prune LSP keymaps",
    callback = function(args)
      -- the client is still attached during this event, so wait until it's actually gone
      vim.schedule(function()
        prune(args.buf)
      end)
    end,
  })

  -- Buffers that already had a client attached before this setup ran (lazy-loaded plugin)
  for _, client in ipairs(vim.lsp.get_clients()) do
    for buf in pairs(client.attached_buffers) do
      apply(buf)
    end
  end

  return group
end

--- Jump to the next / previous diagnostic.
---@param dir integer|boolean  true or number > 0 = next, otherwise = prev
---@param severity? string|integer  e.g. "ERROR" or vim.diagnostic.severity.ERROR
function M.lsp.diagnostic_goto(dir, severity)
  local count = (dir == true or (type(dir) == "number" and dir > 0)) and 1 or -1

  ---@type vim.diagnostic.Severity?
  local sev
  if type(severity) == "string" then
    sev = vim.diagnostic.severity[severity:upper()]
  elseif type(severity) == "number" then
    sev = severity --[[@as vim.diagnostic.Severity]]
  end

  return function()
    vim.diagnostic.jump { severity = sev, float = false, count = count }
  end
end
return M
