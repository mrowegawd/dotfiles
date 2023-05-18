local neozoom = false
local fmt, cmd, fn = string.format, vim.cmd, vim.fn

local M = {}
------------------------------DEFAULT COMMANDS---------------------------------
function M.default_commands()
    return {
        {
            ":Snippets",
            function()
                require("r.utils").EditSnippet()
            end,
            description = "Edit Snippets",
        },

        -- {
        --     ":Theme",
        --     function()
        --         om.ToggleTheme()
        --     end,
        --     description = "Toggle theme",
        -- },
        {
            ":Uuid",
            function()
                local uuid = vim.fn.system("uuidgen"):gsub("\n", ""):lower()
                local line = vim.fn.getline "."
                return vim.schedule(function()
                    vim.fn.setline(
                        ---@diagnostic disable-next-line: param-type-mismatch
                        ".",
                        vim.fn.strpart(line, 0, vim.fn.col ".")
                            .. uuid
                            .. vim.fn.strpart(line, vim.fn.col ".")
                    )
                end)
            end,
            description = "Generate a UUID and insert it into the buffer",
        },

        -----------------------------------------------------------------------
        -- PLUGINS
        -----------------------------------------------------------------------

        -- COPILOT ------------------------------------------------------------
        {
            itemgroup = "Copilot",
            commands = {
                {
                    ":CopilotToggle",
                    function()
                        return require("copilot.suggestion").toggle_auto_trigger()
                    end,
                    description = "Toggle on/off for buffer",
                },
            },
        },

        -- GIT ----------------------------------------------------------------
        {
            itemgroup = "Git",
            commands = {
                {
                    ":GitBranchList",
                    function()
                        return require("r.utils").ListBranches()
                    end,
                    description = "List the Git branches in this repo",
                },
            },
        },

        -- NEOGEN -------------------------------------------------------------
        {
            ":Neogen",
            description = "Generate annotation",
        },

        -- LAZY ---------------------------------------------------------------
        {
            itemgroup = "Lazy",
            icon = "",
            description = "Lazy commands",
            commands = {
                {
                    ":Lazy sync",
                    description = "Sync",
                },

                {
                    ":Lazy show",
                    description = "Show",
                },

                {
                    ":Lazy log",
                    description = "Log",
                },

                {
                    ":Lazy profile",
                    description = "Profile",
                },

                {
                    ":Lazy debug",
                    description = "Debug",
                },
            },
        },
    }
end
function M.default_keymaps()
    return {
        -- BASIC

        {
            "<Leader>P",
            function()
                return vim.notify(fn.expand "%:p")
            end,
            description = "Check cwd curfile",
        },
        {
            "<Leader>cd",
            function()
                local filepath = vim.fn.expand "%:p:h" -- code

                cmd(fmt("cd %s", filepath))

                vim.notify(fmt("ROOT CHANGED: %s", filepath))
            end,
            description = "Change cur pwd to curfile",
        },
        { "vv", [[^vg_]], description = "Select text lines" },
        {
            "<Leader>n",
            function()
                require("notify").dismiss()
                return cmd.nohl()
            end,
            hide = true,
            description = "Clear searches",
        },
        { "n", "nzzzv", hide = true, description = "Search next" },
        { "N", "Nzzzv", hide = true, description = "Search prev" },
        {
            "g,",
            "g,zvzz",
            hide = true,
            description = "Go to new cursor positions in change list",
        },
        {
            "g;",
            "g;zvzz",
            hide = true,
            description = "Go to older positions in change list",
        },
        {
            "<Leader><TAB>",
            function()
                local ft, _ = as.get_bo_buft()
                if neozoom then
                    neozoom = false
                    return cmd "NeoZoomToggle"
                end

                local buf_fts = {
                    ["fugitive"] = "bd",
                    ["Trouble"] = "bd",
                    ["help"] = "bd",
                    ["norg"] = "bd",
                    ["org"] = "bd",
                    ["octo"] = "bd",

                    ["alpha"] = "q",
                    ["spectre_panel"] = "q",
                    ["OverseerForm"] = "q!",
                    ["orgagenda"] = "q",
                    ["markdown"] = "q",
                    ["NeogitStatus"] = "q",
                    ["neo-tree"] = "NeoTreeShowToggle",
                    ["DiffviewFileHistory"] = "DiffviewClose",
                    ["qf"] = require("r.utils").toggle_qf,
                }

                for ft_i, exec_msg in pairs(buf_fts) do
                    if ft == ft_i then
                        if type(exec_msg) == "string" then
                            -- vim.notify(exec_msg)
                            return cmd(exec_msg)
                        elseif type(exec_msg) == "function" then
                            -- vim.notify(type(exec_msg))
                            return exec_msg()
                        end
                    end
                end

                return as.smart_quit()
                -- return require("mini.bufremove").delete(0, false)
            end,
            description = "Quit from a tab or window",
        },
        {
            -- Allow moving the cursor through wrapped lines using j and k,
            -- note that I have line wrapping turned off but turned on only for Markdown
            "j",
            'v:count || mode(1)[0:1] == "no" ? "j" : "gj"',
            opts = { expr = true },
        },
        {
            "k",
            'v:count || mode(1)[0:1] == "no" ? "k" : "gk"',
            opts = { expr = true },
        },
        -- WINDOWS
        --
        {
            itemgroup = "Window-splits",
            description = "Windows; split, commands",
            icon = "",
            keymaps = {
                {
                    "<localleader>ws",
                    "<C-W>t <C-W>K",
                    description = "Windows: change two horizontally split windows to vertical splits",
                },
                {
                    "<localleader>wv",
                    "<C-W>t <C-W>H",
                    description = "Windows: change two vertically split windows to horizontal splits",
                },
            },
        },
        -- BUFFER AND TABS
        {
            itemgroup = "Buffertabs",
            description = "Buffer and tab commands",
            icon = as.ui.icons.misc.tab,
            keymaps = {
                -- BUFFERS
                {
                    "<Leader>O",
                    function()
                        return require("r.utils").Buf_only()
                    end,
                    description = "Buffer: BufOnly",
                },
                -- { -- NOTE: conflict dengan default org mappings, yang di setup org kan semua prefix nya <leader>o...
                --     "<Leader>o",
                --     "<cmd>bprevious <bar> bdelete #<cr>",
                --     description = "Buffer: del buffer without closing the window",
                -- },
                --
                {
                    "gH",
                    "<CMD>bfirst<CR>",
                    description = "Buffer: go to the first buffer",
                },
                {
                    "gL",
                    "<CMD>blast<CR>",
                    description = "Buffer: go to the last buffer",
                },
                {
                    "<c-w>b",
                    "<C-w><S-t>",
                    description = "Buffer: break buffer into new tab",
                },

                -- TABS
                { "tn", "<CMD>tabedit %<CR>", description = "Tab: new tab" },
                { "tl", "<CMD>tabn<CR>", description = "Tab: next tab" },
                { "th", "<CMD>tabp<CR>", description = "Tab: prev tab" },
                { "tH", "<CMD>tabfirst<CR>", description = "Tab; first tab" },
                { "tL", "<CMD>tabfirst<CR>", description = "Tab: last tab" },
                { "tc", "<CMD>tabc<CR>", description = "Tab: close tab" },
            },
        },
        -- MISC
        {
            itemgroup = "Misc",
            icon = as.ui.icons.misc.smiley,
            description = "General functionality",
            keymaps = {

                {
                    "<Leader>rs",
                    function()
                        local mymodes = {
                            ["norg"] = { "set spell!" },
                        }

                        if mymodes[vim.bo.filetype] then
                            for _, value in ipairs(mymodes[vim.bo.filetype]) do
                                return cmd(value)
                            end
                        else
                            require("r.utils").toggle_vi()
                            -- return vim.notify(
                            --     fmt(
                            --         "[!] This filetype %s, we dont use it ",
                            --         vim.bo.filetype
                            --     )
                            -- )
                        end
                    end,
                    description = "Misc: toggle spell",
                },
                {
                    "c<BS>",
                    function()
                        return require("r.utils").echo_base_colors_theme()
                    end,
                    description = "Misc: print out base color themes",
                },
            },
        },
    }
end

--------------------------------LSP MAPPINGS-----------------------------------
function M.lsp_commands()
    -- Only need to set these once!
    if vim.g.lsp_commands then
        return {}
    end

    local commands = {

        -- MASON --------------------------------------------------------------
        {
            ":Mason",
            description = "Mason: open",
            -- opts = { buffer = bufnr },
        },
        {
            ":MasonLog",
            description = "Mason: log",
            -- opts = { buffer = bufnr },
        },
        {
            ":MasonUpdate",
            description = "Mason: update",
            -- opts = { buffer = bufnr },
        },
        {
            ":MasonUninstallAll",
            description = "Mason: uninstall all packages",
            -- opts = { buffer = bufnr },
        },

        -- LSP --------------------------------------------------------------
        {
            ":Format",
            function()
                vim.lsp.buf.format(nil)
            end,
            description = "LSP: format buffer",
            -- opts = { buffer = bufnr },
        },
        {
            ":LspRestart",
            description = "LSP: restart any attached clients",
            -- opts = { buffer = bufnr },
        },
        {
            ":LspStart",
            description = "LSP: start the client manually",
            -- opts = { buffer = bufnr },
        },
        {
            ":LspInfo",
            description = "LSP: show attached clients",
            -- opts = { buffer = bufnr },
        },
        {
            ":LspLog",
            function()
                return vim.cmd("edit " .. vim.lsp.get_log_path())
            end,
            description = "LSP: show logs",
            -- opts = { buffer = bufnr },
        },

        -- NULL-LS ------------------------------------------------------------
        {
            ":NullLsLog",
            description = "Null-ls: log",
            -- opts = { buffer = bufnr },
        },

        -- CMP ----------------------------------------------------------------
        {
            ":CmpStatus",
            description = "Cmp: check status cmp",
            -- opts = { buffer = bufnr },
        },
    }

    vim.g.lsp_commands = true

    return {
        itemgroup = "LSP",
        commands = commands,
    }
end
function M.lsp_keymaps_lspsaga(_, bufnr)
    -- Use lsp_keymaps_lspsaga when using telescope
    if
        #vim.tbl_filter(function(keymap)
            return (keymap.desc or ""):lower() == "rename symbol"
        end, vim.api.nvim_buf_get_keymap(bufnr, "n")) > 0
    then
        return {}
    end

    return {
        itemgroup = "LSP",
        icon = "",
        description = "LSP related functionality",
        keymaps = {

            -- GLANCE
            -- {
            --     "gd",
            --     "<CMD>Glance definitions<CR>",
            --     description = "Glance: definitions",
            --     opts = { buffer = bufnr },
            -- },
            -- {
            --     "gr",
            --     "<CMD>Glance references<CR>",
            --     description = "Glance: reference",
            --     opts = { buffer = bufnr },
            -- },
            -- {
            --     "gP",
            --     "<CMD>Glance references<CR>",
            --     description = "Glance: type definition",
            --     opts = { buffer = bufnr },
            -- },
            -- {
            --     "gi",
            --     "<CMD>Glance implementations<CR>",
            --     description = "Glance: implementations",
            --     opts = { buffer = bufnr },
            -- },
            -- TROUBLE
            -- {
            --     "<Leader>gd",
            --     "<CMD>Trouble lsp_definitions<CR>",
            --     description = "Trouble: definitions with Trouble",
            --     opts = { buffer = bufnr },
            -- },
            -- {
            --     "<Leader>gr",
            --     "<CMD>Trouble lsp_references<CR>",
            --     description = "Trouble: reference with Trouble",
            --     opts = { buffer = bufnr },
            -- },
            -- {
            --     "<Leader>gq",
            --     [[<CMD>TroubleToggle document_diagnostics<CR>]],
            --     description = "Trouble: find diagnostics on curbuf with Trouble",
            --     opts = { buffer = bufnr },
            -- },
            -- {
            --     "<Leader>gQ",
            --     [[<CMD>TroubleToggle workspace_diagnostics<CR>]],
            --     description = "Trouble: find all diagnostics workspaces with Trouble",
            --     opts = { buffer = bufnr },
            -- },
            -- LSP
            -- {
            --     "K",
            --     function()
            --         return vim.lsp.buf.hover()
            --     end,
            --     description = "LSP: hover",
            --     opts = { buffer = bufnr },
            -- },
            {
                "<c-s>",
                vim.lsp.buf.signature_help,
                description = "LSP: Show signature",
                mode = { "i" },
                -- opts = { buffer = bufnr },
            },
            {
                "<leader>gW",
                -- vim.lsp.buf.workspace_symbol,
                function()
                    require("utils.workspace").workspace_symbol_live()
                end,
                description = "LSP: Add workspace folder",
                -- opts = { buffer = bufnr },
            },
            -- {
            --     "ga",
            --     vim.lsp.buf.code_action,
            --     description = "LSP: code actions",
            --     opts = { buffer = bufnr },
            -- },

            -- LSPSAGA
            {
                "<leader>gd",
                "<CMD>Lspsaga goto_definition<CR>",
                description = "Lspsaga: definitions",
                -- opts = { buffer = bufnr },
            },
            {
                "<leader>gr",
                "<CMD>Lspsaga lsp_finder<CR>",
                description = "Lspsaga: reference",
                -- opts = { buffer = bufnr },
            },
            {
                "<leader>gt",
                "<CMD>Lspsaga goto_type_definition<CR>",
                description = "LSP: type definitions",
                -- opts = { buffer = bufnr },
            },
            {
                "<leader>gT",
                "<CMD>Lspsaga peek_type_definition<CR>",
                description = "LSP: peek type definitions",
                -- opts = { buffer = bufnr },
            },
            {
                "<leader>gP",
                "<CMD>Lspsaga peek_definition<CR>",
                description = "Lspsaga: peek definition",
                -- opts = { buffer = bufnr },
            },
            {
                "K",
                "<CMD>Lspsaga hover_doc<CR>",
                description = "Lspsaga: hover",
                -- opts = { buffer = bufnr },
            },
            {
                "<leader>gR",
                "<CMD>Lspsaga rename<CR>",
                description = "Lspsaga: rename",
                -- opts = { buffer = bufnr },
            },
            {
                "<leader>ga",
                "<CMD>Lspsaga code_action<CR>",
                description = "Lspsaga: code actions",
                -- opts = { buffer = bufnr },
            },
            {
                "<leader>go",
                "<CMD>Lspsaga outgoing_calls<CR>",
                description = "Lspsaga: outgoing calls",
                -- opts = { buffer = bufnr },
            },
            {
                "<leader>gi",
                "<CMD>Lspsaga incoming_calls<CR>",
                description = "Lspsaga: incoming calls",
                -- opts = { buffer = bufnr },
            },
        },

        -- table.insert(keymaps, {
        --     "FF",
        --     function()
        --         if vim.bo.filetype == "norg" then
        --             return require("null-ls-embedded").format_current()
        --         end
        --         return vim.lsp.buf.format { async = true }
        --     end,
        --     description = "Format document",
        --     mode = { "n", "v" },
        --     opts = { buffer = bufnr },
        -- })
    }
end
function M.lsp_keymaps()
    if vim.g.lsp_keymaps then
        return {}
    end

    local keymaps = {
        itemgroup = "LSP",
        icon = "",
        description = "LSP related functionality",
        keymaps = {
            {
                "K",
                function()
                    return vim.lsp.buf.hover()
                end,
                description = "LSP: hover",
                -- opts = { buffer = bufnr },
            },
            -- { -- we use `IncRename` now
            --     "<leader>gR",
            --     function()
            --         return vim.lsp.buf.rename()
            --     end,
            --     description = "LSP: rename",
            -- opts = { buffer = bufnr },
            -- },

            -- {
            --     "<leader>gR",
            --     function()
            --         return fmt(":IncRename %s", fn.expand "<cword>")
            --     end,
            --     description = "INC-RENAME: incremental rename",
            -- opts = { buffer = bufnr },
            -- },
            {
                "<c-s>",
                vim.lsp.buf.signature_help,
                description = "LSP: Show signature",
                mode = { "i" },
                -- opts = { buffer = bufnr },
            },

            {
                "gd",
                "<CMD>FzfLua lsp_definitions<CR>",
                description = "Fzflua: definitions",
                -- opts = { buffer = bufnr },
            },

            {
                "ga",
                "<CMD>FzfLua lsp_code_actions<CR>",
                description = "Fzflua: code actions",
                -- opts = { buffer = bufnr },
            },

            {
                "<leader>gr",
                "<CMD>FzfLua lsp_finder<CR>",
                description = "Fzflua: finder",
                -- opts = { buffer = bufnr },
            },

            {
                "gt",
                "<CMD>FzfLua lsp_typedefs<CR>",
                description = "Fzflua: type definitions",
                -- opts = { buffer = bufnr },
            },

            {
                "<leader>gw",
                "<CMD>FzfLua lsp_document_symbols<CR>",
                description = "LSP: document symbols on curbuf",
                -- opts = { buffer = bufnr },
            },

            {
                "<leader>gW",
                "<CMD>FzfLua lsp_live_workspace_symbols<CR>",
                description = "LSP: document symbols all",
                -- opts = { buffer = bufnr },
            },
            {
                "<leader>go",
                "<CMD>FzfLua outgoing_calls<CR>",
                description = "Lspsaga: outgoing calls",
                -- opts = { buffer = bufnr },
            },
            {
                "<leader>gi",
                "<CMD>FzfLua lsp_incoming_calls<CR>",
                description = "Lspsaga: incoming calls",
                -- opts = { buffer = bufnr },
            },

            -- Diagnostic
            {
                "<leader>gQ",
                "<CMD>Trouble workspace_diagnostics<CR>",
                description = "Trouble: workspaces",
                -- opts = { buffer = bufnr },
            },
            {
                "<leader>gq",
                "<CMD>Trouble document_diagnostics<CR>",
                description = "Trouble: document",
                -- opts = { buffer = bufnr },
            },
            {
                "dP",
                vim.diagnostic.open_float,
                description = "Diagnostic: open preview",
                -- opts = { buffer = bufnr },
            },
            {
                "dp",
                vim.diagnostic.goto_prev,
                description = "Diagnostic: prev item",
                -- opts = { buffer = bufnr },
            },
            {
                "dn",
                vim.diagnostic.goto_next,
                description = "Diagnostic: next item",
                -- opts = { buffer = bufnr },
            },
        },
    }

    vim.g.lsp_keymaps = true

    return keymaps
end

return M
