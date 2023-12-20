local map = vim.keymap.set
local Util = require "r.utils"

local M = {}

local recursive_map = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.remap = true
  map(mode, lhs, rhs, opts)
end

M.nmap = function(...)
  recursive_map("n", ...)
end
M.imap = function(...)
  recursive_map("i", ...)
end

M.vmap = function(...)
  recursive_map("v", ...)
end

M.nnoremap = function(...)
  map("n", ...)
end
M.xnoremap = function(...)
  map("x", ...)
end
M.vnoremap = function(...)
  map("v", ...)
end
M.inoremap = function(...)
  map("i", ...)
end
M.onoremap = function(...)
  map("o", ...)
end
M.cnoremap = function(...)
  map("c", ...)
end
M.tnoremap = function(...)
  map("t", ...)
end

M.cabbrev = function(short, long)
  local cmdpos = #short + 1
  vim.api.nvim_set_keymap("ca", short, "", {
    expr = true,
    callback = function()
      if vim.fn.getcmdtype() == ":" and vim.fn.getcmdpos() == cmdpos then
        return long
      else
        return short
      end
    end,
  })
end

---@param method string
function M.has(buffer, method)
  method = method:find "/" and method or "textDocument/" .. method
  local clients = Util.lsp.get_clients { bufnr = buffer }
  for _, client in ipairs(clients) do
    if client.supports_method(method) then
      return true
    end
  end
  return false
end

function M.resolve(buffer, spec_maps)
  local Keys = require "lazy.core.handler.keys"
  if not Keys.resolve then
    return {}
  end
  -- local spec = M.get()
  local opts = Util.opts "nvim-lspconfig"
  if opts ~= nil then
    local clients = Util.lsp.get_clients { bufnr = buffer }
    for _, client in ipairs(clients) do
      if opts.servers ~= nil then
        local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
        vim.list_extend(spec_maps, maps)
      end
    end
  end
  return Keys.resolve(spec_maps)
end

function M.on_attach(_, buffer, spec_maps)
  local Keys = require "lazy.core.handler.keys"
  local keymaps = M.resolve(buffer, spec_maps)

  for _, keys in pairs(keymaps) do
    if not keys.has or M.has(buffer, keys.has) then
      local opts = Keys.opts(keys)
      opts.has = nil
      opts.silent = opts.silent ~= false
      opts.buffer = buffer
      map(keys.mode or "n", keys.lhs, keys.rhs, opts)
    end
  end
end

return M
