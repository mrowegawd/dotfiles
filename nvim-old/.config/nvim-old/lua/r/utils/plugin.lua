local Meta = require "lazy.core.meta"
local Plugin = require "lazy.core.plugin"

---@class r.utils.plugin
local M = {}

---@type string[]
M.core_imports = {}
M.handle_defaults = true

M.lazy_file_events = { "BufReadPost", "BufNewFile", "BufWritePre" }

---@type table<string, string>
M.deprecated_extras = {
  ["r.plugins.extras.formatting.conform"] = "`conform.nvim` is now the default **LazyVim** formatter.",
  ["r.plugins.extras.linting.nvim-lint"] = "`nvim-lint` is now the default **LazyVim** linter.",
  ["r.plugins.extras.ui.dashboard"] = "`dashboard.nvim` is now the default **LazyVim** starter.",
}

M.renamed_extras = {
  ["r.plugins.extras.lang.omnisharp"] = "lazyvim.plugins.extras.lang.dotnet",
  ["r.plugins.extras.formatting.biome"] = "lazyvim.plugins.extras.lang.typescript.biome",
  ["r.plugins.extras.lang.typescript.tsgo"] = "lazyvim.plugins.extras.lang.typescript.tsc",
}

M.deprecated_modules = {}

---@type table<string, string>
M.renames = {
  ["windwp/nvim-spectre"] = "nvim-pack/nvim-spectre",
  ["jose-elias-alvarez/null-ls.nvim"] = "nvimtools/none-ls.nvim",
  ["null-ls.nvim"] = "none-ls.nvim",
  ["glepnir/dashboard-nvim"] = "nvimdev/dashboard-nvim",
  ["markdown.nvim"] = "render-markdown.nvim",
}

function M.save_core()
  if vim.v.vim_did_enter == 1 then
    return
  end
  M.core_imports = vim.deepcopy(require("lazy.core.config").spec.modules)
end

function M.setup()
  M.fix_imports()
  M.fix_renames()
  M.lazy_file()
  table.insert(package.loaders, function(module)
    if M.deprecated_modules[module] then
      RUtils.warn(
        ("`%s` is no longer included by default in **LazyVim**.\nPlease install the `%s` extra if you still want to use it."):format(
          module,
          M.deprecated_modules[module]
        ),
        { title = "LazyVim" }
      )
      return function() end
    end
  end)
end

function M.extra_idx(name)
  local Config = require "lazy.core.config"
  for i, extra in ipairs(Config.spec.modules) do
    if extra == "r.plugins.extras." .. name then
      return i
    end
  end
end

-- Properly load file based plugins without blocking the UI
function M.lazy_file()
  -- Add support for the LazyFile event
  local Event = require "lazy.core.handler.event"

  Event.mappings.LazyFile = { id = "LazyFile", event = M.lazy_file_events }
  Event.mappings["User LazyFile"] = Event.mappings.LazyFile
end

function M.fix_imports()
  local defaults ---@type table<string, LazyVimDefault>
  Plugin.Spec.import = RUtils.inject.args(Plugin.Spec.import, function(_, spec)
    if M.handle_defaults and RUtils.config.json.loaded then
      -- extra disabled by defaults?
      defaults = defaults or RUtils.config.get_defaults()
      local def = defaults[spec.import]
      if def and def.enabled == false then
        return false
      end
    end
    local rename = M.renamed_extras[spec.import]
    if rename then
      RUtils.warn(
        ("The extra `%s` was renamed to `%s`.\nPlease update your config for `%s`"):format(
          spec.import,
          rename,
          spec.importing or "LazyVim"
        ),
        { title = "LazyVim" }
      )
      spec.import = rename
    end
    local dep = M.deprecated_extras[spec.import]
    if dep then
      dep = dep .. "\n" .. "Please remove the extra from `lazyvim.json` to hide this warning."
      RUtils.warn(dep, { title = "LazyVim", once = true, stacktrace = true, stacklevel = 6 })
      return false
    end

    local modname = spec.import
    if type(modname) == "string" and vim.startswith(modname, "r.utils.extras.") then
      M.single_import(spec)
    end
  end)
end

---@param spec LazySpecImport
function M.single_import(spec)
  local modname = spec.import
  if type(modname) ~= "string" then
    return
  end
  spec.name = modname
  spec.import = function()
    local modinfo = vim.loader.find(modname)[1]
    local modpath = modinfo and modinfo.modpath
    local mod, err = loadfile(modpath)
    if mod then
      local ret, foo = mod()
      if foo then
        return nil, "Spec module returned more than one value. Expected a single value."
      end
      return ret
    else
      return nil, err
    end
  end
end

function M.fix_renames()
  Meta.add = RUtils.inject.args(Meta.add, function(self, plugin)
    if type(plugin) == "table" then
      local name = plugin[1]
      if not name then
        return
      end
      if name:find "echasnovski" then
        M.renames[name] = name:gsub("echasnovski", "nvim-mini")
      end
      if M.renames[name] then
        RUtils.warn(
          ("Plugin `%s` was renamed to `%s`.\nPlease update your config for `%s`"):format(
            plugin[1],
            M.renames[plugin[1]],
            self.importing or "LazyVim"
          ),
          { title = "LazyVim" }
        )
        plugin[1] = M.renames[name]
      end
    end
  end)
end

return M
