local LazyUtil = require "lazy.core.util"

---@class r.utils: LazyUtilCore
---@field buf r.utils.buf
---@field cmd r.utils.cmd
---@field cmp r.utils.cmp
---@field codecompanion r.utils.codecompanion
---@field codecompanion_fidget r.utils.codecompanion_fidget
---@field config LazyVimConfig
---@field deprecated r.utils.deprecated
---@field extras r.utils.extras
---@field file r.utils.file
---@field fold r.utils.fold
---@field format r.utils.format
---@field fzf_diffview r.utils.fzf_diffview
---@field fzflua r.utils.fzflua
---@field git r.utils.git
---@field hover_eldoc r.utils.hover_eldoc
---@field inject r.utils.inject
---@field json r.utils.json
---@field layout r.utils.layout
---@field logo r.utils.logo
---@field lsp r.utils.lsp
---@field fileexplorer r.utils.fileexplorer
---@field maim r.utils.maim
---@field map r.utils.map
---@field markdown r.utils.markdown
---@field mini r.utils.mini
---@field navigate_window r.utils.navigate_window
---@field notes r.utils.notes
---@field pick r.utils.pick
---@field platform r.utils.platform
---@field plugin r.utils.plugin
---@field qf r.utils.qf
---@field root r.utils.root
---@field sessions r.utils.sessions
---@field statuscolumn r.utils.statuscolumn
---@field terminal r.utils.terminal
---@field tmux r.utils.tmux
---@field todocomments r.utils.todocomments
---@field treesitter r.utils.treesitter
---@field uisec r.utils.uisec
---@field winui r.utils.winui
local M = {}
M.deprecated = require "r.utils.depcreated"

setmetatable(M, {
  __index = function(t, k)
    if LazyUtil[k] then
      return LazyUtil[k]
    end
    if M.deprecated[k] then
      return M.deprecated[k]()
    end
    ---@diagnostic disable-next-line: no-unknown
    t[k] = require("r.utils." .. k)
    M.deprecated.decorate(k, t[k])
    return t[k]
  end,
})

function M.is_win()
  return vim.uv.os_uname().sysname:find "Windows" ~= nil
end

---@param name string
function M.get_plugin(name)
  return require("lazy.core.config").spec.plugins[name]
end

---@param name string
---@param path string?
function M.get_plugin_path(name, path)
  local plugin = M.get_plugin(name)
  path = path and "/" .. path or ""
  return plugin and (plugin.dir .. path)
end

---@param plugin string
function M.has(plugin)
  return M.get_plugin(plugin) ~= nil
end

--- Checks if the extras is enabled:
--- * If the module was imported
--- * If the module was added by LazyExtras
--- * If the module is in the user's lazy imports
---@param extra string
function M.has_extra(extra)
  local Config = require "r.config"
  local modname = "r.plugins.extras." .. extra
  local LazyConfig = require "lazy.core.config"
  -- check if it was imported already
  if vim.tbl_contains(LazyConfig.spec.modules, modname) then
    return true
  end
  -- check if it was added by LazyExtras
  if vim.tbl_contains(Config.json.data.extras, modname) then
    return true
  end
  -- check if it's in the imports
  local spec = LazyConfig.options.spec
  if type(spec) == "table" then
    for _, s in ipairs(spec) do
      if type(s) == "table" and s.import == modname then
        return true
      end
    end
  end
  return false
end

---@param fn fun()
function M.on_very_lazy(fn)
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
      fn()
    end,
  })
end

--- This extends a deeply nested list with a key in a table
--- that is a dot-separated string.
--- The nested list will be created if it does not exist.
---@generic T
---@param t T[]
---@param key string
---@param values T[]
---@return T[]?
function M.extend(t, key, values)
  local keys = vim.split(key, ".", { plain = true })
  for i = 1, #keys do
    local k = keys[i]
    t[k] = t[k] or {}
    if type(t) ~= "table" then
      return
    end
    t = t[k]
  end
  return vim.list_extend(t, values)
end

---@param name string
function M.opts(name)
  local plugin = M.get_plugin(name)
  if not plugin then
    return {}
  end
  local Plugin = require "lazy.core.plugin"
  return Plugin.values(plugin, "opts", false)
end

---@param opts? LazyNotifyOpts
function M.deprecate(old, new, opts)
  M.warn(
    ("`%s` is deprecated. Please use `%s` instead"):format(old, new),
    vim.tbl_extend("force", {
      title = "RUtils",
      once = true,
      stacktrace = true,
      stacklevel = 6,
    }, opts or {})
  )
end

-- delay notifications till vim.notify was replaced or after 500ms
function M.lazy_notify()
  local notifs = {}
  local function temp(...)
    table.insert(notifs, vim.F.pack_len(...))
  end

  local orig = vim.notify
  vim.notify = temp

  local timer = vim.uv.new_timer()
  if not timer then
    return
  end

  local check = assert(vim.uv.new_check())

  local replay = function()
    timer:stop()
    check:stop()
    if vim.notify == temp then
      vim.notify = orig -- put back the original notify if needed
    end
    vim.schedule(function()
      ---@diagnostic disable-next-line: no-unknown
      for _, notif in ipairs(notifs) do
        vim.notify(vim.F.unpack_len(notif))
      end
    end)
  end

  -- wait till vim.notify has been replaced
  check:start(function()
    if vim.notify ~= temp then
      replay()
    end
  end)
  -- or if it took more than 500ms, then something went wrong
  timer:start(500, 0, replay)
end

function M.is_loaded(name)
  local Config = require "lazy.core.config"
  return Config.plugins[name] and Config.plugins[name]._.loaded
end

---@param name string
---@param fn fun(name:string)
function M.on_load(name, fn)
  if M.is_loaded(name) then
    fn(name)
  else
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyLoad",
      callback = function(event)
        if event.data == name then
          fn(name)
          return true
        end
      end,
    })
  end
end

-- Wrapper around vim.keymap.set that will
-- not create a keymap if a lazy key handler exists.
-- It will also set `silent` to true by default.
function M.safe_keymap_set(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  local modes = type(mode) == "string" and { mode } or mode

  ---@param m string
  modes = vim.tbl_filter(function(m)
    return not (keys.have and keys:have(lhs, m))
  end, modes)

  -- do not create the keymap if a lazy keys handler exists
  if #modes > 0 then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      ---@diagnostic disable-next-line: no-unknown
      opts.remap = nil
    end
    Snacks.keymap.set(modes, lhs, rhs, opts)
  end
end

---@generic T
---@param list T[]
---@return T[]
function M.dedup(list)
  local ret = {}
  local seen = {}
  for _, v in ipairs(list) do
    if not seen[v] then
      table.insert(ret, v)
      seen[v] = true
    end
  end
  return ret
end

M.CREATE_UNDO = vim.api.nvim_replace_termcodes("<c-G>u", true, true, true)
function M.create_undo()
  if vim.api.nvim_get_mode().mode == "i" then
    vim.api.nvim_feedkeys(M.CREATE_UNDO, "n", false)
  end
end

--- Gets a path to a package in the Mason registry.
--- Prefer this to `get_package`, since the package might not always be
--- available yet and trigger errors.
---@param pkg string
---@param path? string
---@param opts? { warn?: boolean }
function M.get_pkg_path(pkg, path, opts)
  pcall(require, "mason") -- make sure Mason is loaded. Will fail when generating docs
  local root = vim.env.MASON or (vim.fn.stdpath "data" .. "/mason")
  opts = opts or {}
  opts.warn = opts.warn == nil and true or opts.warn
  path = path or ""
  local ret = vim.fs.normalize(root .. "/packages/" .. pkg .. "/" .. path)
  if opts.warn then
    vim.schedule(function()
      if not require("lazy.core.config").headless() and not vim.loop.fs_stat(ret) then
        M.warn(
          ("Mason package path not found for **%s**:\n- `%s`\nYou may need to force update the package."):format(
            pkg,
            path
          )
        )
      end
    end)
  end
  return ret
end

--- Override the default title for notifications.
for _, level in ipairs { "info", "warn", "error" } do
  M[level] = function(msg, opts)
    opts = opts or {}
    opts.title = opts.title or "Nvim Notify"
    return LazyUtil[level](msg, opts)
  end
end

local cache = {} ---@type table<(fun()), table<string, any>>
---@generic T: fun()
---@param fn T
---@return T
function M.memoize(fn)
  return function(...)
    local key = vim.inspect { ... }
    cache[fn] = cache[fn] or {}
    if cache[fn][key] == nil then
      cache[fn][key] = fn(...)
    end
    return cache[fn][key]
  end
end

-- Safe wrapper around snacks to prevent errors when LazyVim is still installing
function M.statuscolumnc()
  return package.loaded.snacks and require("snacks.statuscolumn").get() or ""
end

local _defaults = {} ---@type table<string, boolean>

-- Determines whether it's safe to set an option to a default value.
--
-- It will only set the option if:
-- * it is the same as the global value
-- * it's current value is a default value
-- * it was last set by a script in $VIMRUNTIME
---@param option string
---@param value string|number|boolean
---@return boolean was_set
function M.set_default(option, value)
  local l = vim.api.nvim_get_option_value(option, { scope = "local" })
  local g = RUtils.config._options[option] or vim.api.nvim_get_option_value(option, { scope = "global" })

  _defaults[("%s=%s"):format(option, value)] = true
  local key = ("%s=%s"):format(option, l)

  local source = ""
  if l ~= g and not _defaults[key] then
    -- Option does not match global and is not a default value
    -- Check if it was set by a script in $VIMRUNTIME
    local info = vim.api.nvim_get_option_info2(option, { scope = "local" })
    ---@param e vim.fn.getscriptinfo.ret
    local scriptinfo = vim.tbl_filter(function(e)
      return e.sid == info.last_set_sid
    end, vim.fn.getscriptinfo())
    source = scriptinfo[1] and scriptinfo[1].name or ""
    local by_rtp = #scriptinfo == 1 and vim.startswith(scriptinfo[1].name, vim.fn.expand "$VIMRUNTIME")
    if not by_rtp then
      if vim.g.lazyvim_debug_set_default then
        RUtils.warn(
          ("Not setting option `%s` to `%q` because it was changed by a plugin."):format(option, value),
          { title = "RUtils", once = true }
        )
      end
      return false
    end
  end

  if vim.g.lazyvim_debug_set_default then
    RUtils.info({
      ("Setting option `%s` to `%q`"):format(option, value),
      ("Was: %q"):format(l),
      ("Global: %q"):format(g),
      source ~= "" and ("Last set by: %s"):format(source) or "",
      "buf: " .. vim.api.nvim_buf_get_name(0),
    }, { title = "LazyVim", once = true })
  end

  vim.api.nvim_set_option_value(option, value, { scope = "local" })
  return true
end

---@return string
function M.get_lines_under_cusor()
  return vim.fn.expand "<cWORD>"
end

---@return { pos: integer, col: integer, line: string, buf: integer} | nil
function M.get_curpos_under_cursor()
  local pos, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  local buf = vim.api.nvim_get_current_buf()
  return { pos = pos, col = col, line = line, buf = buf }
end

---@param name_opt string
---@param scope? string
function M.get_option(name_opt, scope)
  scope = scope or "local"
  return vim.api.nvim_get_option_value(name_opt, { scope = scope })
end

---@param callback function
---@param tbl table
function M.foreach(callback, tbl)
  for k, v in pairs(tbl) do
    callback(v, k)
  end
end

---@param tbl table
---@param element any
---@return boolean
function M.check_tbl_element(tbl, element)
  for _, x in pairs(tbl) do
    if x == element then
      return true
    end
  end
  return false
end

---@param old_tbl table
---@return table
function M.remove_duplicates_table(old_tbl)
  local new_tbl = {}
  for _, element in pairs(old_tbl) do
    if not M.check_tbl_element(new_tbl, element) then
      table.insert(new_tbl, element)
    end
  end

  return new_tbl
end

---@param str string
---@return string
function M.rstrip_whitespace(str)
  str = string.gsub(str, "%s+$", "")
  return str
end

---@param str string
---@param limit? integer
---@return string
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

---@param str string
---@return string
function M.strip_whitespaces(str)
  if str then
    return M.rstrip_whitespace(M.lstrip_whitespace(str))
  end
  return ""
end

---@param tbl table
---@param delimiter string
---@return string
function M.tryjoin_table_with_delimeter(tbl, delimiter)
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

---@param command string
---@param on_stdout function
function M.run_jobstart(command, on_stdout)
  vim.fn.jobstart(command, {
    on_stdout = on_stdout,
    on_stderr = on_stdout,
    stdout_buffered = false,
    stderr_buffered = false,
  })
end

---@param item any
---@return any
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

---@param name string
---@param rhs string | function
---@param opts? vim.api.keyset.user_command
function M.create_command(name, rhs, opts)
  opts = opts or {}
  vim.api.nvim_create_user_command(name, rhs, opts)
end

---@param opts? { strict: boolean, exit_from_visual: boolean }
---@return { line: string, selection: string, csrow: integer, cscol: integer, cerow:integer, cecol: integer } | nil
function M.get_visual_selection(opts)
  -- vim.cmd 'noau normal! "vy"'
  -- local text = vim.fn.getreg "v"
  -- vim.fn.setreg("v", {})
  -- text = string.gsub(text, "\n", "")
  -- if #text > 0 then
  --   return text
  -- else
  --   return ""
  -- end

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
    if not opts.exit_from_visual then
      -- exit visual mode
      RUtils.map.feedkey "<Esc>"
    end
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

--- Executes a command and returns the output
--- @param command string
--- @return string -- returns empty string upon error
function M.execute_io_open(command)
  local handle = io.popen(command)

  if handle == nil then
    return ""
  end

  local output = handle:read "*a"
  handle:close()

  return output
end

return M
