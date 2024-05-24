---@class r.utils.toggle
local M = {}

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
    return RUtils.info("Set " .. option .. " to " .. vim.opt_local[option]:get(), { title = "Option" })
  end
  ---@diagnostic disable-next-line: no-unknown
  vim.opt_local[option] = not vim.opt_local[option]:get()
  if not silent then
    if vim.opt_local[option]:get() then
      RUtils.info("Enabled " .. option, { title = "Option" })
    else
      RUtils.warn("Disabled " .. option, { title = "Option" })
    end
  end
end

local nu = { number = true, relativenumber = true }
function M.number()
  if vim.opt_local.number:get() or vim.opt_local.relativenumber:get() then
    nu = { number = vim.opt_local.number:get(), relativenumber = vim.opt_local.relativenumber:get() }
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    RUtils.warn("Disabled line numbers", { title = "Option" })
  else
    vim.opt_local.number = nu.number
    vim.opt_local.relativenumber = nu.relativenumber
    RUtils.info("Enabled line numbers", { title = "Option" })
  end
end

function M.diagnostics()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end

function M.semantic_tokens(bufnr)
  vim.b.semantic_tokens_enabled = vim.b.semantic_tokens_enabled == false

  for _, client in ipairs(vim.lsp.get_clients()) do
    if client.server_capabilities.semanticTokensProvider then
      vim.lsp.semantic_tokens[vim.b.semantic_tokens_enabled and "start" or "stop"](bufnr or 0, client.id)
      RUtils.info(string.format("Buffer lsp semantic highlighting %s", bool2str(vim.b.semantic_tokens_enabled)))
    end
  end
end

---@param buf? number
---@param value? boolean
function M.inlay_hints(buf, value)
  -- vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { buf })

  local ih = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
  if type(ih) == "function" then
    ih(buf, value)
  elseif type(ih) == "table" and ih.enable then
    if value == nil then
      value = not ih.is_enabled { bufnr = buf or 0 }
    end
    ih.enable(value, { bufnr = buf })
  end
end

function M.codelens()
  vim.g.codelens_enabled = not vim.g.codelens_enabled
  if not vim.g.codelens_enabled then
    vim.lsp.codelens.clear()
  end
  RUtils.info(string.format("CodeLens %s", bool2str(vim.g.codelens_enabled)))
end

function M.buffer_autoformat(bufnr)
  bufnr = bufnr or 0
  local old_val = vim.b[bufnr].autoformat_enabled
  if old_val == nil then
    old_val = vim.g.autoformat_enabled
  end
  vim.b[bufnr].autoformat_enabled = not old_val
  RUtils.info(string.format("Buffer autoformatting %s", bool2str(vim.b[bufnr].autoformat_enabled)))
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
