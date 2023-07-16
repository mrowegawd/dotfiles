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

function M.toggle_diagnostics()
  vim.g.diagnostics_mode = (vim.g.diagnostics_mode - 1) % 4
  vim.diagnostic.config(as.diagnostics_mode[vim.g.diagnostics_mode])
  if vim.g.diagnostics_mode == 0 then
    vim.notify "diagnostics off"
  elseif vim.g.diagnostics_mode == 1 then
    vim.notify "only status diagnostics"
  elseif vim.g.diagnostics_mode == 2 then
    vim.notify "virtual text off"
  else
    vim.notify "all diagnostics on"
  end
end

function M.opts(name)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require "lazy.core.plugin"
  return Plugin.values(plugin, "opts", false)
end

return M
