local api, fmt, L = vim.api, string.format, vim.log.levels

---@class r.utils.cmd
local M = {}

function M.quit_return()
  vim.cmd "wincmd p"
  local win_id = vim.api.nvim_get_current_win()
  vim.cmd "wincmd p"
  vim.cmd "bdelete"
  vim.fn.win_gotoid(win_id)
end

---@param wins table
function M.windows_is_opened(wins)
  wins = wins or {}

  vim.validate {
    wins = { wins, "table" },
  }

  local ft_wins = {
    "incline",
  }

  if #wins > 0 then
    for _, x in pairs(wins) do
      ft_wins[#ft_wins + 1] = x
    end
  end

  local outline_tbl = { found = false, winbufnr = 0, winnr = 0, winid = 0 }
  for _, winnr in ipairs(vim.fn.range(1, vim.fn.winnr "$")) do
    local winbufnr = vim.fn.winbufnr(winnr)
    if
        winbufnr > 0
        and (
          vim.tbl_contains(ft_wins, vim.api.nvim_get_option_value("filetype", { buf = winbufnr }))
          or vim.tbl_contains(ft_wins, vim.api.nvim_get_option_value("buftype", { buf = winbufnr }))
        )
    then
      local winid = vim.fn.win_findbuf(winbufnr)[1] -- example winid: 1004, 1005
      outline_tbl = { found = true, winbufnr = winbufnr, winnr = winnr, winid = winid }
    end
  end

  return outline_tbl
end

function M.get_option(name_opt)
  return vim.api.nvim_get_option_value(name_opt, { scope = "local" })
end

function M.foreach(callback, list)
  for k, v in pairs(list) do
    callback(v, k)
  end
end

function M.pcall(msg, func, ...)
  local args = { ... }
  if type(msg) == "function" then
    local arg = func
    args, func, msg = { arg, unpack(args) }, msg, nil
  end
  return xpcall(func, function(err)
    msg = debug.traceback(msg and fmt("%s:\n%s\n%s", msg, vim.inspect(args), err) or err)
    vim.schedule(function()
      vim.notify(msg, L.ERROR, { title = "ERROR" })
    end)
  end, unpack(args))
end

function M.fold(callback, list, accum)
  accum = accum or {}
  for k, v in pairs(list) do
    accum = callback(accum, v, k)
    assert(accum ~= nil, "The accumulator must be returned on each iteration")
  end
  return accum
end

function M.get_term_id()
  local term_idx = nil
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(bufnr)
    term_idx = vim.fn.fnamemodify(name, ":t")
    print(name)

    -- if name == term_name then
    -- term_idx = bufnr
    -- else
  end

  -- local t_idx = vim.fn.termopen(term_idx)
  return term_idx
  -- vim.fn.chansend(--[[  ]]t_idx, { "echo 'hello world'", "" })
end

function M.falsy(item)
  if not item then
    return true
  end
  local item_type = type(item)
  if item_type == "boolean" then
    return not item
  end
  if item_type == "string" then
    return item == ""
  end
  if item_type == "number" then
    return item <= 0
  end
  if item_type == "table" then
    return vim.tbl_isempty(item)
  end
  return item ~= nil
end

function M.tryrange(lower, upper)
  local result = {}
  for i = lower, upper do
    table.insert(result, i)
  end
  return result
end

function M.tryjoin(tbl, delimiter)
  delimiter = delimiter or ""
  local result = ""
  local len = #tbl
  for i, item in ipairs(tbl) do
    if i == len then
      result = result .. item
    else
      result = result .. item .. delimiter
    end
  end
  return result
end

function M.rm_duplicates_tbl(arr)
  local newArray = {}
  local checkerTbl = {}
  for _, element in ipairs(arr) do
    -- [[if there is not yet a value at the index of element, then it will
    -- be nil, which will operate like false in an if statement
    -- ]]
    if not checkerTbl[element] then
      checkerTbl[element] = true
      table.insert(newArray, element)
    end
  end
  return newArray
end

function M.normalize_return(str)
  ---@diagnostic disable-next-line: redefined-local
  local str_slice = string.gsub(str, "\n", "")
  local res = vim.split(str_slice, "\n")
  if res[1] then
    return res[1]
  end

  return str_slice
end

function M.check_tbl_element(tbl, element)
  for _, x in pairs(tbl) do
    if x == element then
      return true
    end
  end
  return false
end

function M.remove_duplicates_tbl(old_tbl)
  local new_tbl = {}
  for _, x in pairs(old_tbl) do
    if not M.check_tbl_element(new_tbl, x) then
      table.insert(new_tbl, x)
    end
  end

  return new_tbl
end

local rstrip_whitespace = function(str)
  str = string.gsub(str, "%s+$", "")
  return str
end

function M.lstrip_whitespace(str, limit)
  if limit ~= nil then
    local num_found = 0
    while num_found < limit do
      str = string.gsub(str, "^%s", "")
      num_found = num_found + 1
    end
  else
    str = string.gsub(str, "^%s+", "")
  end
  return str
end

function M.strip_whitespace(str)
  return rstrip_whitespace(M.lstrip_whitespace(str))
end

function M.p_table(map)
  return setmetatable(map, {
    __index = function(tbl, key)
      if not key then
        return
      end
      for k, v in pairs(tbl) do
        if key:match(k) then
          return v
        end
      end
    end,
  })
end

function M.del_buffer_autocmd(augroup, bufnr)
  local cmds_found, cmds = pcall(vim.api.nvim_get_autocmds, { group = augroup, buffer = bufnr })
  if cmds_found then
    vim.tbl_map(function(cmd)
      vim.api.nvim_del_autocmd(cmd.id)
    end, cmds)
  end
end

function M.create_command(name, rhs, opts)
  opts = opts or {}
  api.nvim_create_user_command(name, rhs, opts)
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
      vim.notify(msg, "error", { title = fmt("Autocmd: %s", name) })
    end)
  end
end

function M.augroup(name, ...)
  local commands = { ... }
  assert(name ~= "User", "The name of an augroup CANNOT be User")
  assert(#commands > 0, fmt("You must specify at least one autocommand for %s", name))
  local id = api.nvim_create_augroup(name, { clear = true })
  for _, autocmd in ipairs(commands) do
    validate_autocmd(name, autocmd)
    local is_callback = type(autocmd.command) == "function"
    api.nvim_create_autocmd(autocmd.event, {
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

function M.feedkey(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), mode, false)
end

function M.get_visual_selection(opts)
  opts = opts or {}
  -- Adapted from fzf-lua:
  -- https://github.com/ibhagwan/fzf-lua/blob/6ee73fdf2a79bbd74ec56d980262e29993b46f2b/lua/fzf-lua/utils.lua#L434-L466
  -- this will exit visual mode
  -- use 'gv' to reselect the text
  local _, csrow, cscol, cerow, cecol
  local mode = vim.fn.mode()
  if opts.strict and not vim.endswith(string.lower(mode), "v") then
    return
  end

  if mode == "v" or mode == "V" or mode == "" then
    -- if we are in visual mode use the live position
    _, csrow, cscol, _ = unpack(vim.fn.getpos ".")
    _, cerow, cecol, _ = unpack(vim.fn.getpos "v")
    if mode == "V" then
      -- visual line doesn't provide columns
      cscol, cecol = 0, 999
    end
    -- exit visual mode
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
  else
    -- otherwise, use the last known visual position
    _, csrow, cscol, _ = unpack(vim.fn.getpos "'<")
    _, cerow, cecol, _ = unpack(vim.fn.getpos "'>")
  end

  -- Swap vars if needed
  if cerow < csrow then
    csrow, cerow = cerow, csrow
    cscol, cecol = cecol, cscol
  elseif cerow == csrow and cecol < cscol then
    cscol, cecol = cecol, cscol
  end

  local lines = vim.fn.getline(csrow, cerow)
  assert(type(lines) == "table")
  if vim.tbl_isempty(lines) then
    return
  end

  -- When the whole line is selected via visual line mode ("V"), cscol / cecol will be equal to "v:maxcol"
  -- for some odd reason. So change that to what they should be here. See ':h getpos' for more info.
  local maxcol = vim.api.nvim_get_vvar "maxcol"
  if cscol == maxcol then
    cscol = string.len(lines[1])
  end
  if cecol == maxcol then
    cecol = string.len(lines[#lines])
  end

  ---@type string
  local selection
  local n = #lines
  if n <= 0 then
    selection = ""
  elseif n == 1 then
    selection = string.sub(lines[1], cscol, cecol)
  elseif n == 2 then
    selection = string.sub(lines[1], cscol) .. "\n" .. string.sub(lines[n], 1, cecol)
  else
    selection = string.sub(lines[1], cscol)
        .. "\n"
        .. table.concat(lines, "\n", 2, n - 1)
        .. "\n"
        .. string.sub(lines[n], 1, cecol)
  end

  return {
    lines = lines,
    selection = selection,
    csrow = csrow,
    cscol = cscol,
    cerow = cerow,
    cecol = cecol,
  }
end

function M.run_jobstart(command, on_stdout)
  vim.fn.jobstart(command, {
    on_stdout = on_stdout,
    on_stderr = on_stdout,
    stdout_buffered = false,
    stderr_buffered = false,
  })
end

function M.start()
  coroutine.wrap(function()
    print "test"
  end)()
end

--- Executes a command and returns the output
--- @param command string
--- @return string returns empty string upon error
M.execute_io_open = function(command)
  local handle = io.popen(command)

  if handle == nil then
    return ""
  end

  local output = handle:read "*a"
  handle:close()

  return output
end

------------------------------------------------------------------------------------------------------------------------
--  Lazy Requires
------------------------------------------------------------------------------------------------------------------------
--- source: https://github.com/tjdevries/lazy-require.nvim

--- Require on index.
---
--- Will only require the module after the first index of a module.
--- Only works for modules that export a table.
function M.reqidx(require_path)
  return setmetatable({}, {
    __index = function(_, key)
      return require(require_path)[key]
    end,
    __newindex = function(_, key, value)
      require(require_path)[key] = value
    end,
  })
end

--- Require when an exported method is called.
---
--- Creates a new function. Cannot be used to compare functions,
--- set new values, etc. Only useful for waiting to do the require until you actually
--- call the code.
---
--- ```lua
--- -- This is not loaded yet
--- local lazy_mod = lazy.require_on_exported_call('my_module')
--- local lazy_func = lazy_mod.exported_func
---
--- -- ... some time later
--- lazy_func(42)  -- <- Only loads the module now
---
--- ```
---@param require_path string
---@return table<string, fun(...): any>
function M.reqcall(require_path)
  return setmetatable({}, {
    __index = function(_, k)
      return function(...)
        return require(require_path)[k](...)
      end
    end,
  })
end

return M
