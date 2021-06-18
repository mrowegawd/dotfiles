local null_ls = require("null-ls")
-- local h = require("null-ls.helpers")
-- local methods = require("null-ls.methods")
local b = null_ls.builtins

local sources = {
    b.formatting.prettierd.with(
        {
            command = "./node_modules/.bin/prettier"
        }
    ),
    b.formatting.trim_whitespace.with({filetypes = {"tmux", "fish", "teal"}}),
    b.formatting.black,
    b.formatting.isort,
    b.formatting.lua_format.with(
        {
            command = "luafmt",
            args = {"--stdin"},
            to_stdin = true
        }
    )

    -- b.formatting.eslint_d,
    -- b.diagnostics.teal,
    -- b.code_actions.gitsigns
    -- b.diagnostics.write_good,
    -- b.diagnostics.markdownlint,
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
