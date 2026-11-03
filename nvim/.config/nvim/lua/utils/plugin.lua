local M = {}

--- A proxy that calls `require(modname)` only when a field is accessed.
---@param modname string
---@return table
local function require_lazy(modname)
  local mod
  return setmetatable({}, {
    __index = function(_, key)
      mod = mod or require(modname)
      return mod[key]
    end,
  })
end
M.require_lazy = require_lazy

local Log = require_lazy "utils.log"

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                          PLUGIN REGISTRY (cached)                           ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

---@type table<string, vim.pack.PlugData>?
local installed

---@param name string "nui.nvim" atau "MunifTanjim/nui.nvim"
---@return string
local function short_name(name)
  return name:match "[^/]+$" or name
end

local function installed_set()
  if not installed then
    installed = {}
    for _, p in ipairs(vim.pack.get(nil, { info = false })) do
      installed[p.spec.name] = p
    end
  end
  return installed
end

--- Call this after `vim.pack.add`, `update`, or `del` to invalidate the cache.
function M.refresh()
  installed = nil
end

-- Automatically invalidate the cache whenever vim.pack changes a plugin.
-- See `:h PackChanged` for details.
vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("UtilsPluginCache", { clear = true }),
  callback = M.refresh,
})

---@param name string
---@return vim.pack.PlugData?
function M.get_plugin(name)
  return installed_set()[short_name(name)]
end

---@param name string
---@return boolean
function M.has(name)
  return M.get_plugin(name) ~= nil
end

---@param name string
---@param path string?
---@return string?
function M.get_plugin_path(name, path)
  local plugin = M.get_plugin(name)
  if not plugin then
    return nil
  end
  return plugin.path .. (path and ("/" .. path) or "")
end

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                               REQUIRE HELPERS                               ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

--- A proxy that calls `require(require_path)[k](...)` when invoked.
--- Checks module availability with `pcall(require)`, NOT M.has
--- (which checks installed plugins, not Lua modules).
---@param require_path string
---@return table<string, fun(...): any>
function M.reqcall(require_path)
  return setmetatable({}, {
    __index = function(_, k)
      return function(...)
        local ok, mod = pcall(require, require_path)
        if not ok then
          Log.warn(string.format("module %s not found", require_path))
          return
        end
        return mod[k](...)
      end
    end,
  })
end

---@param name string
---@return boolean ok, any mod_or_err
function M.require(name)
  local ok, mod_or_err = pcall(require, name)
  return ok, mod_or_err
end

--- "nui.nvim" -> "nui", "telescope.nvim" -> "telescope"
---@param name string
---@return string
local function derive_module_name(name)
  return (short_name(name):gsub("%.nvim$", ""))
end

--- Checks whether the plugin is installed AND its module can be required.
---@param name string e.g. "nui.nvim" or "MunifTanjim/nui.nvim"
---@param module_name string? override the module name (e.g. "nvim-lspconfig" -> "lspconfig")
---@return boolean ok, any mod_or_err
function M.get_plugin_module(name, module_name)
  if not M.has(name) then
    return false, string.format("plugin '%s' is not installed", name)
  end
  return pcall(require, module_name or derive_module_name(name))
end

--- Only checks whether the plugin is installed (does NOT load its module).
---@param name string
---@return boolean
function M.has_module(name)
  return M.has(name)
end

---@deprecated use get_plugin_module
---@param name string
---@return boolean, table|nil
function M.is_available(name)
  local ok, mod = M.get_plugin_module(name, name)
  return ok, ok and mod or nil
end

return M
