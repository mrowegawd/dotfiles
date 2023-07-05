--  ╭──────────────────────────────────────────────────────────╮
--  │                       LSP Commands                       │
--  ╰──────────────────────────────────────────────────────────╯
function M.lsp_keymaps()
    if vim.g.lsp_keymaps then
        return {}
    end

    local keymaps = {
        itemgroup = "LSP",
        icon = "",
        description = "LSP related functionality",
        keymaps = {
            --  +----------------------------------------------------------+
            --  LSP Stuff
            --  +----------------------------------------------------------+
            {
                "K",
                function()
                    return vim.lsp.buf.hover()
                end,
                description = "LSP: hover",
            },
            {
                "gR",
                function()
                    return vim.lsp.buf.rename()
                end,
                description = "LSP: rename",
            },

            -- {
            --     "<leader>gR",
            --     function()
            --         return fmt(":IncRename %s", fn.expand "<cword>")
            --     end,
            --     description = "INC-RENAME: incremental rename",
            -- opts = { buffer = bufnr },
            -- },
            {
                "<c-y>",
                vim.lsp.buf.signature_help,
                description = "LSP: Show signature",
                mode = { "i" },
            },

            {
                "gd",
                "<CMD>FzfLua lsp_definitions<CR>",
                description = "Fzflua: definitions",
            },

            {
                "ga",
                "<CMD>FzfLua lsp_code_actions<CR>",
                description = "Fzflua: code actions",
            },

            {
                "gr",
                "<CMD>FzfLua lsp_finder<CR>",
                description = "Fzflua: finder",
            },

            {
                "gt",
                "<CMD>FzfLua lsp_typedefs<CR>",
                description = "Fzflua: type definitions",
            },

            {
                "<leader>gw",
                "<CMD>FzfLua lsp_document_symbols<CR>",
                description = "LSP: document symbols on curbuf",
            },

            {
                "<leader>gW",
                "<CMD>FzfLua lsp_live_workspace_symbols<CR>",
                description = "LSP: document symbols all",
            },

            {
                "gP",
                function()
                    require("goto-preview").goto_preview_definition {}
                end,
                description = "Goto_Preview: Preview definitions",
            },

            --  +----------------------------------------------------------+
            --  Diagnostics
            --  +----------------------------------------------------------+
            {
                "<leader>gq",
                function()
                    if #vim.diagnostic.get() > 0 then
                        return vim.diagnostic.setqflist()
                    else
                        as.info("Document its clean..", "Diagnostic")
                    end
                end,
                description = "Diagnostic: sending to qf",
            },

            {
                "dP",
                function()
                    vim.diagnostic.open_float { focusable = true }
                end,
                description = "Diagnostic: open float preview",
            },

            {
                "dp",
                vim.diagnostic.goto_prev,
                description = "Diagnostic: prev item",
            },

            {
                "dn",
                vim.diagnostic.goto_next,
                description = "Diagnostic: next item",
                --
            },
        },
    }

    vim.g.lsp_keymaps = true

    return keymaps
end
function M.lsp_commands()
    -- Only need to set these once!
    if vim.g.lsp_commands then
        return {}
    end

    local commands = {

        --  +----------------------------------------------------------+
        --  Mason
        --  +----------------------------------------------------------+
        {
            ":Mason",
            description = "Mason: open",
        },
        {
            ":MasonLog",
            description = "Mason: log",
        },
        {
            ":MasonUpdate",
            description = "Mason: update",
        },
        {
            ":MasonUninstallAll",
            description = "Mason: uninstall all packages",
        },

        --  +----------------------------------------------------------+
        --  LSP
        --  +----------------------------------------------------------+
        {
            ":LspFormat",
            function()
                vim.lsp.buf.format { bufnr = 0, async = false }
            end,
            description = "LSP: format buffer",
        },
        {
            ":LspRestart",
            description = "LSP: restart any attached clients",
        },
        {
            ":LspStart",
            description = "LSP: start the client manually",
        },
        {
            ":LspInfo",
            description = "LSP: show attached clients",
        },
        {
            ":LspLog",
            function()
                return cmd("edit " .. vim.lsp.get_log_path())
            end,
            description = "LSP: show logs",
        },

        --  +----------------------------------------------------------+
        --  Null-ls
        --  +----------------------------------------------------------+
        {
            ":NullLsLog",
            description = "Null-ls: log",
        },

        --  +----------------------------------------------------------+
        --  Cmp
        --  +----------------------------------------------------------+
        {
            ":CmpStatus",
            description = "Cmp: check status cmp",
        },
    }

    vim.g.lsp_commands = true

    return {
        itemgroup = "LSP",
        commands = commands,
    }
end
