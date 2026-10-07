local M = {}

local Log = require "utils.log"

---@param require_path string
---@return table<string, fun(...): any>
function M.reqcall(require_path)
  return setmetatable({}, {
    __index = function(_, k)
      return function(...)
        if not M.has(require_path) then
          ---@diagnostic disable-next-line: undefined-field
          Log.warn(string.format("module %s not found", require_path))
          return
        end
        return require(require_path)[k](...)
      end
    end,
  })
end

---@param name string
---@return boolean, any?
function M.require(name)
  local ok, module = pcall(require, name)

  if not ok then
    return false, nil
  end

  return true, module
end

---@param name string
---@return boolean, table|nil
function M.is_available(name)
  if not M.has(name) then
    return false, nil
  end

  local ok, pkg = pcall(require, name)
  return ok, pkg
end

---@param name string
---@return vim.pack.PlugData?
function M.get_plugin(name)
  local src_name = name:match "/" and name:match ".+/(.+)" or name

  for _, plugin in ipairs(vim.pack.get()) do
    if plugin.spec.name == src_name then
      return plugin
    end
  end
  return nil
end

---@param name string
---@param path string?
function M.get_plugin_path(name, path)
  local plugin = M.get_plugin(name)
  if not plugin then
    return nil
  end
  path = path and ("/" .. path) or ""
  return plugin.path .. path
end

---@param name string
function M.has(name)
  return M.get_plugin(name) ~= nil
end

--- Derives a Lua module name from a plugin's short name, like vim-pack.lua
--- does: "nui.nvim" -> "nui", "telescope.nvim" -> "telescope".
---@param name string
---@return string
local function derive_module_name(name)
  local short_name = name:match "/" and name:match ".+/(.+)" or name
  return short_name:gsub("%.nvim$", "")
end

--- Checks the plugin is installed (has a path) AND its module requires
--- successfully, in one call. Returns the loaded module on success.
---@param name string e.g. "nui.nvim" or "MunifTanjim/nui.nvim"
---@param module_name string? override the derived module name
---@return boolean ok, any mod_or_err
function M.get_plugin_module(name, module_name)
  local plugin = M.get_plugin(name)
  if not plugin then
    return false, string.format("plugin '%s' is not installed", name)
  end

  local mod_name = module_name or derive_module_name(name)
  local ok, mod = pcall(require, mod_name)
  if not ok then
    return false, mod
  end

  return true, mod
end

--- Same as get_plugin_module, but only returns true/false without the
--- module itself -- useful for simple conditional config.
---@param name string
---@param module_name string?
---@return boolean
function M.has_module(name, module_name)
  local ok = M.get_plugin_module(name, module_name)
  return ok
end

return M
