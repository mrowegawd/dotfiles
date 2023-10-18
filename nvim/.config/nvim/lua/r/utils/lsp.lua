local Util = require "r.utils"

local M = {}

function M.get_clients(opts)
  local ret = {}
  if vim.lsp.get_clients then
    ret = vim.lsp.get_clients(opts)
  else
    ---@diagnostic disable-next-line: deprecated
    ret = vim.lsp.get_active_clients(opts)
    if opts and opts.method then
      ret = vim.tbl_filter(function(client)
        return client.supports_method(opts.method, { bufnr = opts.bufnr })
      end, ret)
    end
  end
  return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

---@param on_attach fun(client, buffer)
function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf ---@type number
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

---@param from string
---@param to string
function M.on_rename(from, to)
  local clients = M.get_clients()
  for _, client in ipairs(clients) do
    if client.supports_method "workspace/willRenameFiles" then
      ---@diagnostic disable-next-line: invisible
      local resp = client.request_sync("workspace/willRenameFiles", {
        files = {
          {
            oldUri = vim.uri_from_fname(from),
            newUri = vim.uri_from_fname(to),
          },
        },
      }, 1000, 0)
      if resp and resp.result ~= nil then
        vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
      end
    end
  end
end

---@return _.lspconfig.options
function M.get_config(server)
  local configs = require "lspconfig.configs"
  return rawget(configs, server)
end

---@param server string
---@param cond fun( root_dir, config): boolean
function M.disable(server, cond)
  local util = require "lspconfig.util"
  local def = M.get_config(server)
  ---@diagnostic disable-next-line: undefined-field
  def.document_config.on_new_config = util.add_hook_before(def.document_config.on_new_config, function(config, root_dir)
    if cond(root_dir, config) then
      config.enabled = false
    end
  end)
end

function M.formatter(opts)
  opts = opts or {}
  local filter = opts.filter or {}
  filter = type(filter) == "string" and { name = filter } or filter
  local ret = {
    name = "LSP",
    primary = true,
    priority = 1,
    format = function(buf)
      M.format(Util.merge(filter, { bufnr = buf }))
    end,
    sources = function(buf)
      local clients = M.get_clients(Util.merge(filter, { bufnr = buf }))
      local ret = vim.tbl_filter(function(client)
        return client.supports_method "textDocument/formatting" or client.supports_method "textDocument/rangeFormatting"
      end, clients)
      return vim.tbl_map(function(client)
        return client.name
      end, ret)
    end,
  }
  return Util.merge(ret, opts)
end

function M.format(opts)
  opts = vim.tbl_deep_extend("force", {}, opts or {}, require("r.utils").opts("nvim-lspconfig").format or {})
  local ok, conform = pcall(require, "conform")
  -- use conform for formatting with LSP when available,
  -- since it has better format diffing
  if ok then
    opts.formatters = {}
    opts.lsp_fallback = true
    conform.format(opts)
  else
    vim.lsp.buf.format(opts)
  end
end

M.sep = package.config:sub(1, 1)

-- Figures out full path of lualine installation
local source = debug.getinfo(1, "S").source
if source:sub(1, 1) == "@" then
  local base_start = source:find(table.concat({ "lualine.nvim", "lua", "lualine_require.lua" }, M.sep))
  if base_start then
    source = source:sub(2, base_start + 12 + 1 + 3) -- #lualine.nvim = 12 , #lua = 3.
    if source then
      M.plugin_dir = source
    end
  end
end

---require module module
---@param module string mogule arraived
---@return any the required module
function M.require(module)
  if package.loaded[module] then
    return package.loaded[module]
  end
  local pattern_dir = module:gsub("%.", M.sep)
  local pattern_path = pattern_dir .. ".lua"
  if M.plugin_dir then
    local path = M.plugin_dir .. pattern_path
    assert(M.is_valid_filename(module), "Invalid filename")
    local file_stat, dir_stat
    file_stat = vim.loop.fs_stat(path)
    if not file_stat then
      path = M.plugin_dir .. pattern_dir
      dir_stat = vim.loop.fs_stat(path)
      if dir_stat and dir_stat.type == "directory" then
        path = path .. M.sep .. "init.lua"
        file_stat = vim.loop.fs_stat(path)
      end
    end
    if file_stat and file_stat.type == "file" then
      local mod_result = dofile(path)
      package.loaded[module] = mod_result
      return mod_result
    end
  end

  pattern_path = table.concat { "lua/", module:gsub("%.", "/"), ".lua" }
  local paths = vim.api.nvim_get_runtime_file(pattern_path, false)
  if #paths <= 0 then
    pattern_path = table.concat { "lua/", module:gsub("%.", "/"), "/init.lua" }
    paths = vim.api.nvim_get_runtime_file(pattern_path, false)
  end
  if #paths > 0 then
    -- put entries from user config path in front
    local user_config_path = vim.fn.stdpath "config"
    table.sort(paths, function(a, b)
      return vim.startswith(a, user_config_path) or not vim.startswith(b, user_config_path)
    end)
    local mod_result = dofile(paths[1])
    package.loaded[module] = mod_result
    return mod_result
  end

  ---@diagnostic disable-next-line: redundant-return-value
  return require(module)
end

---requires modules when they are used
---@param modules table k-v table where v is module path and k is name that will
---                     be indexed
---@return table metatable where when a key is indexed it gets required and cached
function M.lazy_require(modules)
  return setmetatable({}, {
    __index = function(self, key)
      local loaded = rawget(self, key)
      if loaded ~= nil then
        return loaded
      end
      local module_location = modules[key]
      if module_location == nil then
        return nil
      end
      local module = M.require(module_location)
      rawset(self, key, module)
      return module
    end,
  })
end

return M
