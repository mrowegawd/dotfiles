local map = vim.keymap.set

---@class r.utils.map
local M = {}

local recursive_map = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.remap = true
  map(mode, lhs, rhs, opts)
end

local function countSpaces(input)
  local spaceCount = 0

  -- Iterasi setiap karakter dalam string
  for i = 1, #input do
    local char = input:sub(i, i)
    if char == " " then
      spaceCount = spaceCount + 1
    end
  end

  return spaceCount
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
    local count_spaces = countSpaces(tbl.lhs)
    ---@diagnostic disable-next-line: undefined-field
    local lhs = tbl.lhs
    if count_spaces > 0 then
      ---@diagnostic disable-next-line: undefined-field
      lhs = "<space>" .. RUtils.cmd.strip_whitespace(tbl.lhs)
    end

    ---@diagnostic disable-next-line: undefined-field
    local map_desc = string.format("%-14s | %s", lhs, tbl.desc)
    col[#col + 1] = map_desc
  end

  local opts = {
    prompt = RUtils.fzflua.default_title_prompt(),
    winopts = {
      title = " Show Keymap Help for Current Buffer [" .. ft .. "] ",
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

local detect_duplicate_map = function(...)
  local args = { ... } -- Menyimpan argumen dalam sebuah table
  local key = args[1] -- Misalkan 'n' adalah default mode jika tidak ada argumen
  local key_alt = args[2] -- Mengambil argumen kedua sebagai key
  local opts = args[3] -- Mengambil argumen kedua sebagai key
  if opts and opts.unique == nil then
    -- if opts.desc then
    --   print(key .. " " .. opts.desc)
    -- end
    opts.unique = true
  end
  return key, key_alt, opts
end

M.nnoremap = function(...)
  local key, key_alt, opts = detect_duplicate_map(...)
  map("n", key, key_alt, opts)
end
M.xnoremap = function(...)
  local key, key_alt, opts = detect_duplicate_map(...)
  map("x", key, key_alt, opts)
end
M.vnoremap = function(...)
  local key, key_alt, opts = detect_duplicate_map(...)
  map("v", key, key_alt, opts)
end
M.inoremap = function(...)
  local key, key_alt, opts = detect_duplicate_map(...)
  map("i", key, key_alt, opts)
end
M.onoremap = function(...)
  local key, key_alt, opts = detect_duplicate_map(...)
  map("o", key, key_alt, opts)
end
M.cnoremap = function(...)
  local key, key_alt, opts = detect_duplicate_map(...)
  map("c", key, key_alt, opts)
end
M.tnoremap = function(...)
  local key, key_alt, opts = detect_duplicate_map(...)
  map("t", key, key_alt, opts)
end

M.cabbrev = function(short, long)
  vim.cmd.cnoreabbrev(short, long)
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
  local spec = vim.tbl_extend("force", {}, spec_maps)
  local opts = RUtils.opts "nvim-lspconfig"
  if opts ~= nil then
    local clients = RUtils.lsp.get_clients { bufnr = buffer }
    for _, client in ipairs(clients) do
      if opts.servers ~= nil then
        local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
        vim.list_extend(spec, maps)
      end
    end
  end
  return Keys.resolve(spec)
end
function M.on_attach(_, buffer, spec_maps)
  local Keys = require "lazy.core.handler.keys"
  local keymaps = M.resolve(buffer, spec_maps)

  for _, keys in pairs(keymaps) do
    local has = not keys.has or M.has(buffer, keys.has)
    local cond = not (keys.cond == false or ((type(keys.cond) == "function") and not keys.cond()))

    if has and cond then
      local opts = Keys.opts(keys)
      opts.cond = nil
      opts.has = nil
      opts.silent = opts.silent ~= false
      opts.buffer = buffer
      -- if opts.unique == nil then
      --   opts.unique = true
      -- end
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
