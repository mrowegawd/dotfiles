local M = {}

---@class PluginSpec
---@field src string GitHub repository in "user/repo" form
---@field module_name? string Module name used by require()
---@field version? string|table Version passed to vim.pack
---@field opts? table|fun():table Plugin setup options
---@field _opts? table Cached evaluated options
---@field _local_path? string Local checkout path, when available
---@field _loaded? boolean Whether a lazy plugin has been loaded
---@field on_setup? fun():nil Function called after successful setup
---@field setup? false Skip require/setup
---@field lazy? boolean Install but defer loading/setup until M.load_now()

---@type table<string, PluginSpec>
local specs = {}

---@type table<string, PluginSpec>
local lazy_specs = {}

---@type table<string, boolean>
local setup_done = {}

-- Debug access.
M.specs = specs
M.lazy_specs = lazy_specs

----------------------------------------------------------------------
-- Helpers
----------------------------------------------------------------------

---Derives the module name used by require() from a plugin spec.
---@param plugin PluginSpec
---@return string
local function module_name_of(plugin)
  if plugin.module_name then
    return plugin.module_name
  end

  local name = plugin.src:match "([^/]+)$" or plugin.src

  return name:gsub("%.nvim$", "")
end

---Derives the plugin/package name from a source.

---Example:
--- "stevearc/resession.nvim" -> "resession.nvim"
--- "folke/snacks.nvim" -> "snacks.nvim"
---@param src string
---@return string
local function short_name_of(src)
  return src:match "([^/]+)$" or src
end

----------------------------------------------------------------------
-- Spec registration
----------------------------------------------------------------------

---Merge two plugin specs.

---The first registration owns the canonical PluginSpec object.
---Later registrations can contribute opts and explicitly supplied fields.
---@param old PluginSpec
---@param new PluginSpec
---@return PluginSpec
local function merge_spec(old, new)
  -- Merge opts when both sides are normal tables.
  --
  -- Function opts cannot be safely merged with another opts table/function,
  -- so the newest value wins in that case.
  if old.opts ~= nil and new.opts ~= nil then
    if type(old.opts) == "table" and type(new.opts) == "table" then
      old.opts = vim.tbl_deep_extend("force", old.opts, new.opts)

      -- Previous cached options are no longer valid.
      old._opts = nil
    else
      old.opts = new.opts
      old._opts = nil
    end
  elseif new.opts ~= nil then
    old.opts = new.opts
    old._opts = nil
  end

  -- Copy explicitly supplied public fields.
  -- Internal runtime state must not be overwritten by a duplicate spec.
  for key, value in pairs(new) do
    if key ~= "opts" and key ~= "_opts" and key ~= "_local_path" and key ~= "_loaded" then
      old[key] = value
    end
  end

  -- Preserve local path if the existing spec already discovered one.
  if not old._local_path and new._local_path then
    old._local_path = new._local_path
  end

  return old
end

---Register a plugin spec and return its canonical spec.
---Multiple files may register the same plugin. The same canonical object
---is reused so setup state and options remain consistent.
---@param plugin PluginSpec
---@return string name
---@return PluginSpec spec
local function register_spec(plugin)
  local name = short_name_of(plugin.src)
  local existing = specs[name]

  if existing then
    existing = merge_spec(existing, plugin)
    specs[name] = existing
    return name, existing
  end

  specs[name] = plugin

  return name, plugin
end

----------------------------------------------------------------------
-- Options
----------------------------------------------------------------------

---@param plugin PluginSpec
---@return table
local function get_opts(plugin)
  if plugin._opts ~= nil then
    return plugin._opts
  end

  if plugin.opts == nil then
    plugin._opts = {}
  elseif type(plugin.opts) == "function" then
    plugin._opts = plugin.opts()
  else
    plugin._opts = plugin.opts
  end

  return plugin._opts
end

----------------------------------------------------------------------
-- Debug
----------------------------------------------------------------------

---@param plugin PluginSpec
---@param stage string
---@return fun()
local function debug_load(plugin, stage)
  local name = short_name_of(plugin.src)
  local start = vim.uv.hrtime()

  vim.notify(string.format("vim-pack: %s %s", name, stage))

  return function()
    local elapsed = (vim.uv.hrtime() - start) / 1e6

    vim.notify(string.format("vim-pack: %s %s %.2f ms", name, stage, elapsed))
  end
end

----------------------------------------------------------------------
-- Setup
----------------------------------------------------------------------

---Runs require(...).setup(opts) and on_setup.
---A plugin is considered setup only after all setup steps succeed.
---Does NOT install or load plugins.
---@param plugins PluginSpec[]
local function apply_setup(plugins)
  for _, plugin in ipairs(plugins) do
    local name = short_name_of(plugin.src)

    if setup_done[name] then
      goto continue
    end

    -- local total_start = vim.uv.hrtime()
    -- local finish = debug_load(plugin, "setup")

    local mod

    --------------------------------------------------------------
    -- require
    --------------------------------------------------------------

    if plugin.setup ~= false then
      -- local start = vim.uv.hrtime()

      local ok, result = pcall(require, module_name_of(plugin))

      -- vim.notify(string.format("vim-pack: %s require %.2f ms", name, (vim.uv.hrtime() - start) / 1e6))

      if not ok then
        vim.notify(
          string.format("vim-pack: failed to require '%s': %s", module_name_of(plugin), result),
          vim.log.levels.ERROR
        )

        goto continue
      end

      mod = result
    end

    --------------------------------------------------------------
    -- opts
    --------------------------------------------------------------

    local opts

    if plugin.setup ~= false then
      -- local start = vim.uv.hrtime()

      opts = get_opts(plugin)

      -- vim.notify(string.format("vim-pack: %s opts %.2f ms", name, (vim.uv.hrtime() - start) / 1e6))
    end

    --------------------------------------------------------------
    -- setup
    --------------------------------------------------------------

    if plugin.setup ~= false and type(mod.setup) == "function" then
      -- local start = vim.uv.hrtime()

      local ok, err = pcall(mod.setup, opts)

      -- vim.notify(string.format("vim-pack: %s setup %.2f ms", name, (vim.uv.hrtime() - start) / 1e6))

      if not ok then
        vim.notify(string.format("vim-pack: failed to setup '%s': %s", plugin.src, err), vim.log.levels.ERROR)

        goto continue
      end
    end

    --------------------------------------------------------------
    -- on_setup
    --------------------------------------------------------------

    if plugin.on_setup then
      -- local start = vim.uv.hrtime()

      local ok, err = pcall(plugin.on_setup)

      -- vim.notify(string.format("vim-pack: %s on_setup %.2f ms", name, (vim.uv.hrtime() - start) / 1e6))

      if not ok then
        vim.notify(string.format("vim-pack: on_setup failed for '%s': %s", plugin.src, err), vim.log.levels.ERROR)

        goto continue
      end
    end

    setup_done[name] = true

    -- finish()

    -- vim.notify(string.format("vim-pack: %s total %.2f ms", name, (vim.uv.hrtime() - total_start) / 1e6))

    ::continue::
  end
end

----------------------------------------------------------------------
-- vim.pack
----------------------------------------------------------------------

---@param plugin PluginSpec
---@return string|vim.pack.Spec
local function to_pack_spec(plugin)
  local url = string.format("https://github.com/%s", plugin.src)

  if plugin.version then
    return {
      src = url,
      version = plugin.version,
    }
  end

  return url
end

---Installs plugins through vim.pack.add().
---@param plugins PluginSpec[]
---@param opts? { load?: boolean|fun(plug_data: table):nil }
local function install(plugins, opts)
  if #plugins == 0 then
    return
  end

  local sources = vim.iter(plugins):map(to_pack_spec):totable()

  vim.pack.add(sources, opts)
end

----------------------------------------------------------------------
-- Lazy
----------------------------------------------------------------------

---Registers plugins as lazy plugins.
---@param plugins PluginSpec[]
local function register_lazy(plugins)
  for _, plugin in ipairs(plugins) do
    local name, canonical = register_spec(plugin)

    lazy_specs[name] = canonical
  end
end

----------------------------------------------------------------------
-- Configure
----------------------------------------------------------------------

---Installs and configures plugins according to their lazy flag.
---@param plugins PluginSpec[]
local function configure(plugins)
  local eager = {}
  local deferred = {}

  for _, plugin in ipairs(plugins) do
    local name, canonical = register_spec(plugin)

    if canonical.lazy then
      table.insert(deferred, canonical)
      lazy_specs[name] = canonical
    else
      table.insert(eager, canonical)
    end
  end

  --------------------------------------------------------------
  -- Eager
  --------------------------------------------------------------

  if #eager > 0 then
    install(eager, {
      load = true,
    })

    apply_setup(eager)
  end

  --------------------------------------------------------------
  -- Lazy
  --------------------------------------------------------------

  if #deferred > 0 then
    install(deferred, {
      load = false,
    })

    register_lazy(deferred)
  end
end

----------------------------------------------------------------------
-- Public options API
----------------------------------------------------------------------

---@param name string
---@return table
function M.opts(name)
  local plugin = specs[name]

  if not plugin then
    return {}
  end

  return get_opts(plugin)
end

----------------------------------------------------------------------
-- Lazy loading
----------------------------------------------------------------------

---Loads and configures a plugin previously registered with lazy=true.

---Supports both:
---  - vim.pack-managed plugins
---  - local development plugins
---@param short_name string
function M.load_now(short_name)
  local plugin = lazy_specs[short_name]

  if not plugin then
    vim.notify(string.format("vim-pack: '%s' was not registered as a lazy plugin", short_name), vim.log.levels.ERROR)

    return
  end

  if plugin._loaded then
    return
  end

  --------------------------------------------------------------
  -- Activate plugin
  --------------------------------------------------------------

  if plugin._local_path then
    vim.opt.runtimepath:prepend(plugin._local_path)
  else
    local ok, err = pcall(vim.cmd.packadd, short_name)

    if not ok then
      vim.notify(string.format("vim-pack: failed to packadd '%s': %s", short_name, err), vim.log.levels.ERROR)

      return
    end
  end

  --------------------------------------------------------------
  -- Setup
  --------------------------------------------------------------

  local setup_ok = apply_setup { plugin }

  if setup_ok then
    plugin._loaded = true
  end
end

----------------------------------------------------------------------
-- Local / Remote
----------------------------------------------------------------------

---Adds plugins from a local checkout when available,
---otherwise installs them remotely.

---Local plugins are searched in:
--- ~/<name>
--- ~/.local/src/nvim_plugins/<name>

---lazy=true defers setup until M.load_now().
---@param plugins PluginSpec[]
function M.add_local_or_remote(plugins)
  local eager_local = {}
  local lazy_local = {}

  local eager_remote = {}
  local lazy_remote = {}

  for _, plugin in ipairs(plugins) do
    local name, canonical = register_spec(plugin)

    local local_path = vim
      .iter({
        "~/" .. name,
        "~/.local/src/nvim_plugins/" .. name,
      })
      :map(vim.fs.normalize)
      :find(function(path)
        return vim.fn.isdirectory(path) == 1
      end)

    if local_path then
      canonical._local_path = local_path

      if canonical.lazy then
        table.insert(lazy_local, canonical)
      else
        table.insert(eager_local, canonical)
      end
    else
      if canonical.lazy then
        table.insert(lazy_remote, canonical)
      else
        table.insert(eager_remote, canonical)
      end
    end

    if canonical.lazy then
      lazy_specs[name] = canonical
    end
  end

  --------------------------------------------------------------
  -- Local eager
  --------------------------------------------------------------

  for _, plugin in ipairs(eager_local) do
    if plugin._local_path then
      vim.opt.runtimepath:prepend(plugin._local_path)
    end
  end

  --------------------------------------------------------------
  -- Remote eager
  --------------------------------------------------------------

  if #eager_remote > 0 then
    install(eager_remote, {
      load = true,
    })
  end

  --------------------------------------------------------------
  -- Remote lazy
  --------------------------------------------------------------

  if #lazy_remote > 0 then
    install(lazy_remote, {
      load = false,
    })
  end

  --------------------------------------------------------------
  -- Setup eager plugins
  --------------------------------------------------------------

  if #eager_local > 0 then
    apply_setup(eager_local)
  end

  if #eager_remote > 0 then
    apply_setup(eager_remote)
  end
end

----------------------------------------------------------------------
-- Event helpers
----------------------------------------------------------------------

---@param event vim.api.keyset.events|vim.api.keyset.events[]
---@param pattern? string|string[]
---@param plugins PluginSpec[]
---@param on_local? boolean
local function add_on_event(event, pattern, plugins, on_local)
  vim.api.nvim_create_autocmd(event, {
    pattern = pattern,
    once = true,
    callback = function()
      if on_local then
        M.add_local_or_remote(plugins)
      else
        configure(plugins)
      end
    end,
  })
end

----------------------------------------------------------------------
-- Public add API
----------------------------------------------------------------------

---@param plugins PluginSpec[]
function M.add(plugins)
  configure(plugins)
end

---@param event vim.api.keyset.events|vim.api.keyset.events[]
---@param plugins PluginSpec[]
function M.add_on_event(event, plugins)
  add_on_event(event, nil, plugins)
end

---@param event vim.api.keyset.events|vim.api.keyset.events[]
---@param pattern string|string[]
---@param plugins PluginSpec[]
function M.add_on_event_and_pattern(event, pattern, plugins)
  add_on_event(event, pattern, plugins)
end

---@param event vim.api.keyset.events|vim.api.keyset.events[]
---@param plugins PluginSpec[]
function M.add_remote_or_local_on_event(event, plugins)
  add_on_event(event, nil, plugins, true)
end

---@param patterns string|string[]
---@param plugins PluginSpec[]
function M.add_on_file_type(patterns, plugins)
  add_on_event("FileType", patterns, plugins)
end

----------------------------------------------------------------------
-- PackChanged
----------------------------------------------------------------------

---@param plugin_name string
---@param cmd string|fun():nil
function M.on_plugin_update(plugin_name, cmd)
  vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(args)
      if args.data.spec.name ~= plugin_name then
        return
      end

      if args.data.kind ~= "install" and args.data.kind ~= "update" then
        return
      end

      if type(cmd) == "string" then
        vim.system({ cmd }, {
          cwd = args.data.path,
        })
      else
        local ok, err = pcall(cmd)

        if not ok then
          vim.notify(
            string.format("vim-pack: on_plugin_update failed for '%s': %s", plugin_name, err),
            vim.log.levels.ERROR
          )
        end
      end
    end,
  })
end

return M
