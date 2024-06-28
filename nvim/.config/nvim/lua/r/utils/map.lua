local map = vim.keymap.set

---@class r.utils.map
local M = {}

local recursive_map = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.remap = true
  map(mode, lhs, rhs, opts)
end

M.show_help_buf_keymap = function()
  local ft = vim.bo[0].ft
  local tbl_maps = vim.api.nvim_buf_get_keymap(0, "n")

  local col = {}
  for _, tbl in pairs(tbl_maps) do
    if tbl.desc == nil then -- remove nil desc
      tbl.desc = "<builtin>"
    end
    ---@diagnostic disable-next-line: undefined-field
    local map_desc = string.format("%-14s | %s", RUtils.cmd.strip_whitespace(tbl.lhs), tbl.desc)
    col[#col + 1] = map_desc
  end

  local opts = {
    prompt = "  ",
    winopts = {
      title = "Show Keymap Help [" .. ft .. "]",
    },
    actions = {
      ["default"] = function(_, _)
        print "not implemented yet"
      end,
    },
  }

  -- print(vim.inspect(tbl_map_help))
  return require("fzf-lua").fzf_exec(col, opts)
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

---@param method string|string[]
function M.has(buffer, method)
  if type(method) == "table" then
    for _, m in ipairs(method) do
      if M.has(buffer, m) then
        return true
      end
    end
    return false
  end
  method = method:find "/" and method or "textDocument/" .. method
  local clients = RUtils.lsp.get_clients { bufnr = buffer }
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
  local opts = RUtils.opts "nvim-lspconfig"
  if opts ~= nil then
    local clients = RUtils.lsp.get_clients { bufnr = buffer }
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

function M.type_no_escape(text)
  vim.api.nvim_feedkeys(text, "n", false)
end
function M.type_escape(text)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(text, true, true, true), "n", false)
end
function M.escape(text, additional_char)
  if not additional_char then
    additional_char = ""
  end
  return vim.fn.escape(text, "/" .. additional_char)
end
function M.getVisualSelection()
  vim.cmd 'noau normal! "vy"'
  local text = vim.fn.getreg "v"
  vim.fn.setreg("v", {})
  text = string.gsub(text, "\n", "")
  if #text > 0 then
    return text
  else
    return ""
  end
end

function M.feedkey(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

return M
