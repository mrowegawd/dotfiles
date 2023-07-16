local fmt, api, L, fn = string.format, vim.api, vim.log.levels, vim.fn

local namespace = {
  ui = {
    winbar = { enable = true },
    statuscolumn = { enable = true },
    foldtext = { enable = false },
  },

  -- some vim mappings require a mixture of commandline commands and function
  -- calls this table is place to store lua functions to be called in those
  -- mappings
  mappings = { enable = true },
}

-- This table is a globally accessible store to facilitating accessing
-- helper functions and variables throughout my config
_G.as = as or namespace

as.home = os.getenv "HOME"
as.dropbox_path = fmt("%s/Dropbox", as.home, "Dropbox")
as.wiki_path = fmt("%s/neorg", as.dropbox_path)
as.snippet_path = as.dropbox_path .. "/friendly-snippets"

as.colorscheme = "kanagawa"
as.master_win = 1
as.term_count = 1
as.toggle_number = 1
as.colorcolumn_width = 80
as.isInlayActive = true
as.diagnostics_mode = 3 -- set the visibility of diagnostics in the UI (0=off, 1=only show in status line, 2=virtual text off, 3=all on)

as.use_search_telescope = false -- if false, use fzflua
as.use_lsp_native = true -- if true use native lsp, else use coc

as.vimgrep_arguments = {
  "rg",
  "--hidden",
  "--follow",
  "--no-ignore-vcs",
  "-g",
  "!{node_modules,.git,__pycache__,.pytest_cache}",
  "--color=never",
  "--no-heading",
  "--with-filename",
  "--line-number",
  "--column",
  "--smart-case",
}

function as.fold(callback, list, accum)
  accum = accum or {}
  for k, v in pairs(list) do
    accum = callback(accum, v, k)
    assert(accum ~= nil, "The accumulator must be returned on each iteration")
  end
  return accum
end

---@generic T
---@param callback fun(item: T, key: string | number, list: T[]): T
---@param list T[]
---@return T[]
function as.map(callback, list)
  return as.fold(function(accum, v, k)
    accum[#accum + 1] = callback(v, k, accum)
    return accum
  end, list, {})
end

function as.falsy(item)
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

function as.command(name, rhs, opts)
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
  local incorrect = as.fold(function(accum, _, key)
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

--- Returns if the path exists on disk
---@param filename string
---@return string|boolean
function as.exists(filename)
  local stat = vim.uv.fs_stat(filename)
  return stat and stat.type or false
end

--- Returns if the path is a directory
---@param filename string
---@return boolean
function as.is_dir(filename)
  return as.exists(filename) == "directory"
end

function as.is_file(filename)
  return as.exists(filename) == "file"
end

function as.absolute_path(bufnr)
  return fn.expand("#" .. bufnr .. ":p")
end

---@param plugin string
function as.has(plugin)
  return require("lazy.core.config").plugins[plugin] ~= nil
end

-- example use; as.is_loclist() and "Location List" or "Quickfix List"
function as.is_loclist()
  return fn.getloclist(0, { filewinid = 1 }).filewinid ~= 0
end

---@return string, string
function as.get_bo_buft()
  local bufnr = api.nvim_get_current_buf()
  local buftype = api.nvim_get_option_value("buftype", { buf = bufnr })
  local filetype = api.nvim_get_option_value("filetype", { buf = bufnr })
  return filetype, buftype
end

function as.tryrange(lower, upper)
  local result = {}
  for i = lower, upper do
    table.insert(result, i)
  end
  return result
end
function as.tryjoin(tbl, delimiter)
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
function as.rm_duplicates_tbl(arr)
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

function as.foreach(callback, list)
  for k, v in pairs(list) do
    callback(v, k)
  end
end
function as.p_table(map)
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
function as.augroup(name, ...)
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
function as.safe_require(module, opts)
  opts = opts or { silent = false }
  local ok, result = pcall(require, module)
  if not ok and not opts.silent then
    vim.notify(result, L.ERROR, { title = fmt("Error requiring: %s", module) })
  end
  return ok, result
end

function as.try(func, ...)
  local args = { ... }

  return xpcall(function()
    return func(unpack(args))
  end, function(err)
    local lines = {}
    table.insert(lines, err)
    table.insert(lines, debug.traceback("", 3))

    as.error(table.concat(lines, "\n"))
    return err
  end)
end
function as.require(mod)
  local ok, ret = as.try(require, mod)
  return ok and ret
end

function as.warn(msg, name)
  vim.notify(msg, L.WARN, { title = name or "init.lua" })
end
function as.error(msg, name)
  vim.notify(msg, L.ERROR, { title = name or "init.lua" })
end
function as.info(msg, name)
  vim.notify(msg, L.INFO, { title = name or "init.lua" })
end

--- Call the given function and use `vim.notify` to notify of any errors
--- this function is a wrapper around `xpcall` which allows having a single
--- error handler for all errors
---@param msg string
---@param func function
---@param ... any
---@return boolean, any
---@overload fun(func: function, ...): boolean, any
function as.pcall(msg, func, ...)
  local args = { ... }
  if type(msg) == "function" then
    local arg = func --[[@as any]]
    ---@diagnostic disable-next-line: cast-local-type
    args, func, msg = { arg, unpack(args) }, msg, nil
  end
  return xpcall(func, function(err)
    msg = debug.traceback(msg and fmt("%s:\n%s", msg, err) or err)
    vim.schedule(function()
      vim.notify(msg, L.ERROR, { title = "ERROR" })
    end)
  end, unpack(args))
end

function _G.CustomFoldText()
  local level = "+-" .. string.rep("-", vim.v.foldlevel - 1) .. " "
  local nlines = (vim.v.foldend - vim.v.foldstart) + 1
  local align = string.rep(" ", 5 - (vim.v.foldlevel - 1) - string.len(tostring(nlines)))

  local fold_text = tostring(fn.getline(vim.v.foldstart))
  if vim.startswith(fold_text, "\\documentclass") then
    fold_text = "Preamble"
  elseif vim.startswith(fold_text, "\\appendix") then
    fold_text = "Appendix"
  elseif vim.startswith(fold_text, "\\begin") then
    -- Note: we only fold abstract and frame environments
    if string.match(fold_text, "abstract") then
      fold_text = "Abstract"
    else
      -- Assumes that we have something like `\frametitle{Foo}`
      -- in next line to the \begin{frame} line
      local frame_title = string.match(tostring(fn.getline(vim.v.foldstart + 1)), "{(.*.)}")
      fold_text = "Frame - " .. frame_title
    end
  end
  return string.format("%s%s%s lines: %s", level, align, nlines, fold_text)
end

function as.status_dap()
  local ok, dap = pcall(require, "dap")

  if not ok then
    return ""
  end

  return dap.status()
end
