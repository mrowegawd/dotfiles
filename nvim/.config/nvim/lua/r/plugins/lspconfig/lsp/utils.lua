local M = {}

local icons = as.ui.icons

function M.capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
    }
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

function M.lspmappings(_, bufnr)
    vim.keymap.set(
        "n",
        "K",
        vim.lsp.buf.hover,
        { desc = "LSP: hover", buffer = bufnr }
    )
    vim.keymap.set(
        "n",
        "gR",
        vim.lsp.buf.rename,
        { desc = "LSP: rename", buffer = bufnr }
    )

    -- {
    --     "<leader>gR",
    --     function()
    --         return fmt(":IncRename %s", fn.expand "<cword>")
    --     end,
    --     description = "INC-RENAME: incremental rename",
    -- opts = { buffer = bufnr },
    -- },

    vim.keymap.set(
        "i",
        "<c-y>",
        vim.lsp.buf.signature_help,
        { desc = "LSP: show signature", buffer = bufnr }
    )

    vim.keymap.set(
        "n",
        "gd",
        "<CMD>FzfLua lsp_definitions<CR>",
        { desc = "LSP(fzflua): definitions", buffer = bufnr }
    )

    vim.keymap.set(
        "n",
        "ga",
        "<CMD>FzfLua lsp_code_actions<CR>",
        { desc = "LSP(fzflua): code actions", buffer = bufnr }
    )

    vim.keymap.set(
        "n",
        "gr",
        "<CMD>FzfLua lsp_finder<CR>",
        { desc = "LSP(fzflua): finder", buffer = bufnr }
    )

    vim.keymap.set(
        "n",
        "gt",
        "<CMD>FzfLua lsp_typedefs<CR>",
        { desc = "LSP(fzflua): type definitions", buffer = bufnr }
    )

    vim.keymap.set(
        "n",
        "<leader>gw",
        "<CMD>FzfLua lsp_document_symbols<CR>",
        { desc = "LSP: document symbols on curbuf", buffer = bufnr }
    )

    vim.keymap.set(
        "n",
        "<leader>gW",
        "<CMD>FzfLua lsp_live_workspace_symbols<CR>",
        { desc = "LSP: document symbols all", buffer = bufnr }
    )

    vim.keymap.set("n", "gP", function()
        require("goto-preview").goto_preview_definition {}
    end, { desc = "LSP(goto-preview): preview definitions", buffer = bufnr })

    --  +----------------------------------------------------------+
    --  Diagnostics
    --  +----------------------------------------------------------+

    vim.keymap.set("n", "<leader>gq", function()
        if #vim.diagnostic.get() > 0 then
            return vim.diagnostic.setqflist()
        else
            as.info("Document its clean..", "Diagnostic")
        end
    end, { desc = "Diagnostic: sending to qf", buffer = bufnr })

    vim.keymap.set("n", "dP", function()
        vim.diagnostic.open_float { focusable = true }
    end, { desc = "Diagnostic: open float preview", buffer = bufnr })

    vim.keymap.set(
        "n",
        "dp",
        vim.diagnostic.goto_prev,
        { desc = "Diagnostic: prev item", buffer = bufnr }
    )

    vim.keymap.set(
        "n",
        "dn",
        vim.diagnostic.goto_next,
        { desc = "Diagnostic: next item", buffer = bufnr }
    )

    vim.keymap.set("n", "<leader>ud", function()
        require("r.utils").toggle_diagnostics()
    end, { desc = "LSP: toogle diagnostics", buffer = bufnr })

    --  +----------------------------------------------------------+
    --  MISC
    --  +----------------------------------------------------------+

    vim.keymap.set("n", "<leader>uh", function()
        return require("r.utils").toggle_inlayhints(function()
            vim.lsp.inlay_hint(0, nil)
        end)
    end, { desc = "LSP: toogle inlayhints", buffer = bufnr })

    vim.keymap.set("n", "<leader>uH", function()
        return require("r.utils").toggle_buffer_semantic_tokens(
            vim.api.nvim_get_current_buf()
        )
    end, { desc = "LSP: toogle semantic token", buffer = bufnr })
end

return M
