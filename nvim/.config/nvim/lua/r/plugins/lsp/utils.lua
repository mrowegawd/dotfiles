local M = {}

function M.capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  -- capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

  return require("cmp_nvim_lsp").default_capabilities(capabilities)

  -- local capabilities = vim.lsp.protocol.make_client_capabilities()
  -- capabilities.textDocument.completion.completionItem.documentationFormat =
  --     { "markdown", "plaintext" }
  -- capabilities.textDocument.completion.completionItem.snippetSupport = true
  -- capabilities.textDocument.completion.completionItem.preselectSupport = true
  -- capabilities.textDocument.completion.completionItem.insertReplaceSupport =
  --     true
  -- capabilities.textDocument.completion.completionItem.labelDetailsSupport =
  --     true
  -- capabilities.textDocument.completion.completionItem.deprecatedSupport = true
  -- capabilities.textDocument.completion.completionItem.commitCharactersSupport =
  --     true
  -- capabilities.textDocument.completion.completionItem.tagSupport =
  --     { valueSet = { 1 } }
  -- capabilities.textDocument.completion.completionItem.resolveSupport =
  --     { properties = { "documentation", "detail", "additionalTextEdits" } }
  -- capabilities.textDocument.foldingRange =
  --     { dynamicRegistration = false, lineFoldingOnly = true }
  -- return capabilities
end

function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, bufnr)
    end,
  })
end

function M.opts(name)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require "lazy.core.plugin"
  return Plugin.values(plugin, "opts", false)
end

local function bool2str(bool)
  return bool and "on" or "off"
end

--- Toggle buffer semantic token highlighting for all language servers that support it
---@param bufnr? number the buffer to toggle the clients on
function M.toggle_buffer_semantic_tokens(bufnr)
  vim.b.semantic_tokens_enabled = vim.b.semantic_tokens_enabled == false

  for _, client in ipairs(vim.lsp.get_clients()) do
    if client.server_capabilities.semanticTokensProvider then
      vim.lsp.semantic_tokens[vim.b.semantic_tokens_enabled and "start" or "stop"](bufnr or 0, client.id)
      as.info(string.format("Buffer lsp semantic highlighting %s", bool2str(vim.b.semantic_tokens_enabled)))
    end
  end
end

local enabled = true
function M.toggle_diagnostics()
  enabled = not enabled
  if enabled then
    vim.diagnostic.enable()
    as.info("Enabled diagnostics", "Diagnostics")
  else
    vim.diagnostic.disable()
    as.info("Disabled diagnostics", "Diagnostics")
  end
end

return M
