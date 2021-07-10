local null_ls = require("null-ls")
-- local h = require("null-ls.helpers")
-- local methods = require("null-ls.methods")
-- local b = null_ls.builtins

local sources = {
    null_ls.builtins.diagnostics.shellcheck,
    null_ls.builtins.diagnostics.markdownlint,
    null_ls.builtins.diagnostics.selene
}

local M = {}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {"documentation", "detail", "additionalTextEdits"}
}

M.setup = function(on_attach)
    null_ls.setup(
        {
            -- debug = true,
            on_attach = on_attach,
            sources = sources,
            capabilities = capabilities
        }
    )
end

return M
