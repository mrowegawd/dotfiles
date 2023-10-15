local api, cmd = vim.api, vim.cmd

local Util = require "r.utils"

local M = {}

local function is_vim_list_open()
  for _, win in ipairs(api.nvim_list_wins()) do
    local buf = api.nvim_win_get_buf(win)
    local location_list = vim.fn.getloclist(0, { filewinid = 0 })
    local is_loc_list = location_list.filewinid > 0
    if vim.bo[buf].filetype == "qf" or is_loc_list then
      return true
    end
  end
  return false
end

-- Usage: toggle_list "quickfix" or "location"
local function toggle_list(list_type, kill)
  if kill then
    return cmd [[q]]
  end

  local is_location_target = list_type == "location"
  local cmd_ = is_location_target and { "lclose", "lopen" } or { "cclose", "copen" }
  local is_open = is_vim_list_open()
  if is_open then
    return vim.cmd[cmd_[1]]()
  end
  local list = is_location_target and vim.fn.getloclist(0) or vim.fn.getqflist()
  if vim.tbl_isempty(list) then
    local msg_prefix = (is_location_target and "Location" or "QuickFix")
    return Util.info(msg_prefix .. " List is Empty.", vim.log.levels.WARN)
  end

  local winnr = vim.fn.winnr()
  cmd[cmd_[2]]()
  if vim.fn.winnr() ~= winnr then
    cmd.wincmd "p"
  end
end

function M.toggle_qf()
  toggle_list "quickfix"
end

function M.toggle_loc()
  toggle_list "location"
end

function M.kill_loc_qf()
  toggle_list("none", true)
end

local function bool2str(bool)
  return bool and "on" or "off"
end

function M.option(option, silent, values)
  if values then
    if vim.opt_local[option]:get() == values[1] then
      ---@diagnostic disable-next-line: no-unknown
      vim.opt_local[option] = values[2]
    else
      ---@diagnostic disable-next-line: no-unknown
      vim.opt_local[option] = values[1]
    end
    return Util.info("Set " .. option .. " to " .. vim.opt_local[option]:get(), { title = "Option" })
  end
  ---@diagnostic disable-next-line: no-unknown
  vim.opt_local[option] = not vim.opt_local[option]:get()
  if not silent then
    if vim.opt_local[option]:get() then
      Util.info("Enabled " .. option, { title = "Option" })
    else
      Util.warn("Disabled " .. option, { title = "Option" })
    end
  end
end

local nu = { number = true, relativenumber = true }
function M.number()
  if vim.opt_local.number:get() or vim.opt_local.relativenumber:get() then
    nu = { number = vim.opt_local.number:get(), relativenumber = vim.opt_local.relativenumber:get() }
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    Util.warn("Disabled line numbers", { title = "Option" })
  else
    vim.opt_local.number = nu.number
    vim.opt_local.relativenumber = nu.relativenumber
    Util.info("Enabled line numbers", { title = "Option" })
  end
end

local enabled = true
function M.diagnostics()
  enabled = not enabled
  if enabled then
    vim.diagnostic.enable()
    Util.info("Enabled diagnostics", { title = "Diagnostics" })
  else
    vim.diagnostic.disable()
    Util.warn("Disabled diagnostics", { title = "Diagnostics" })
  end
end

function M.semantic_tokens(bufnr)
  vim.b.semantic_tokens_enabled = vim.b.semantic_tokens_enabled == false

  for _, client in ipairs(vim.lsp.get_clients()) do
    if client.server_capabilities.semanticTokensProvider then
      vim.lsp.semantic_tokens[vim.b.semantic_tokens_enabled and "start" or "stop"](bufnr or 0, client.id)
      Util.info(string.format("Buffer lsp semantic highlighting %s", bool2str(vim.b.semantic_tokens_enabled)))
    end
  end
end

function M.inlay_hints(bufnr)
  vim.b.semantic_tokens_enabled = vim.b.semantic_tokens_enabled == false

  for _, client in ipairs(vim.lsp.get_clients()) do
    if client.server_capabilities.semanticTokensProvider then
      vim.lsp.semantic_tokens[vim.b.semantic_tokens_enabled and "start" or "stop"](bufnr or 0, client.id)
      Util.info(string.format("Buffer lsp semantic highlighting %s", bool2str(vim.b.semantic_tokens_enabled)))
    end
  end
end

function M.codelens()
  vim.g.codelens_enabled = not vim.g.codelens_enabled
  if not vim.g.codelens_enabled then
    vim.lsp.codelens.clear()
  end
  Util.info(string.format("CodeLens %s", bool2str(vim.g.codelens_enabled)))
end

function M.buffer_autoformat(bufnr)
  bufnr = bufnr or 0
  local old_val = vim.b[bufnr].autoformat_enabled
  if old_val == nil then
    old_val = vim.g.autoformat_enabled
  end
  vim.b[bufnr].autoformat_enabled = not old_val
  Util.info(string.format("Buffer autoformatting %s", bool2str(vim.b[bufnr].autoformat_enabled)))
end

function M.background()
  vim.go.background = vim.go.background == "light" and "dark" or "light"
  vim.notify(string.format("background=%s", vim.go.background))
end

setmetatable(M, {
  __call = function(m, ...)
    return m.option(...)
  end,
})

return M
