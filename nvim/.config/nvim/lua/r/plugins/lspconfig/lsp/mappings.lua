--  ╭──────────────────────────────────────────────────────────╮
--  │                       LSP Commands                       │
--  ╰──────────────────────────────────────────────────────────╯
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
