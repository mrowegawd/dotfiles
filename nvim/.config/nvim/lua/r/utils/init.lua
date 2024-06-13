local LazyUtil = require "lazy.core.util"

---@class r.util: LazyUtilCore
---@field config LazyVimConfig
---@field async r.utils.async
---@field ui r.utils.ui
---@field notes r.utils.notes
---@field qf r.utils.qf
---@field lsp r.utils.lsp
---@field root r.utils.root
---@field fold r.utils.fold
---@field colortbl r.utils.colortbl
---@field fzf_diffview r.utils.fzf_diffview
---@field fzflua r.utils.fzflua
---@field telescope r.utils.telescope
---@field toggle r.utils.toggle
---@field session r.utils.session
---@field format r.utils.format
---@field extras r.utils.extras
---@field buf r.utils.buf
---@field plugin r.utils.plugin
---@field terminal r.utils.terminal
---@field lazygit r.utils.lazygit
---@field lazydocker r.utils.lazydocker
---@field tiling r.utils.tiling
---@field uisec r.utils.uisec
---@field inject r.utils.inject
---@field platform r.utils.platform
---@field file r.utils.file
---@field neorg r.utils.neorg
---@field markdown r.utils.markdown
---@field maim r.utils.maim
---@field cmd r.utils.cmd
---@field map r.utils.map
---@field cmp r.utils.cmp
---@field todocomments r.utils.todocomments
local M = {}

---@type table<string, string|string[]>
local deprecated = {
  get_clients = "lsp",
  on_attach = "lsp",
  on_rename = "lsp",
  root_patterns = { "root", "patterns" },
  get_root = { "root", "get" },
  oat_term = { "terminal", "open" },
  toggle_diagnostics = { "toggle", "diagnostics" },
  toggle_number = { "toggle", "number" },
  fg = "ui",
}

setmetatable(M, {
  __index = function(t, k)
    if LazyUtil[k] then
      return LazyUtil[k]
    end

    local dep = deprecated[k]
    if dep then
      local mod = type(dep) == "table" and dep[1] or dep
      local key = type(dep) == "table" and dep[2] or k
      M.deprecate([[require("r.utils").]] .. k, [[require("r.utils").]] .. mod .. "." .. key)
      ---@diagnostic disable-next-line: no-unknown
      t[mod] = require("r.utils." .. mod) -- load here to prevent loops
      return t[mod][key]
    end
    ---@diagnostic disable-next-line: no-unknown
    t[k] = require("r.utils." .. k)
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

---@param fn fun()
function M.on_very_lazy(fn)
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
      fn()
    end,
  })
end

---@param name string
function M.opts(name)
  local plugin = require("lazy.core.config").spec.plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require "lazy.core.plugin"
  return Plugin.values(plugin, "opts", false)
end

function M.deprecate(old, new)
  M.warn(("`%s` is deprecated. Please use `%s` instead"):format(old, new), {
    title = "LazyVim",
    once = true,
    stacktrace = true,
    stacklevel = 6,
  })
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

---@param name string
---@param fn fun(name:string)
function M.on_load(name, fn)
  local Config = require "lazy.core.config"
  if Config.plugins[name] and Config.plugins[name]._.loaded then
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
  local modes = type(mode) == "string" and { mode } or mode

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
    vim.keymap.set(modes, lhs, rhs, opts)
  end
end

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

      if vim.tbl_contains({ "Outline", "gitcommit" }, vim.bo.filetype) then
        vim.keymap.set("n", "ss", "<Nop>", {
          buffer = vim.api.nvim_get_current_buf(),
        })

        vim.keymap.set("n", "sv", "<Nop>", {
          buffer = vim.api.nvim_get_current_buf(),
        })
      end
    end,
  })
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

function M.is_loaded(name)
  local Config = require "lazy.core.config"
  return Config.plugins[name] and Config.plugins[name]._.loaded
end

M.CREATE_UNDO = vim.api.nvim_replace_termcodes("<c-G>u", true, true, true)
function M.create_undo()
  if vim.api.nvim_get_mode().mode == "i" then
    vim.api.nvim_feedkeys(M.CREATE_UNDO, "n", false)
  end
end

--- Override the default title for notifications.
for _, level in ipairs { "info", "warn", "error" } do
  M[level] = function(msg, opts)
    opts = opts or {}
    opts.title = opts.title or "LazyVim"
    return LazyUtil[level](msg, opts)
  end
end

local cache = {} ---@type table<string, any>
---@generic T: fun()
---@param fn T
---@return T
function M.memoize(fn)
  return function(...)
    local key = vim.inspect { ... }
    if cache[key] == nil then
      cache[key] = fn(...)
    end
    return cache[key]
  end
end

return M
