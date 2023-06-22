local neozoom = false
local fmt, cmd, fn = string.format, vim.cmd, vim.fn

local M = {}
------------------------------DEFAULT COMMANDS---------------------------------
function M.default_commands()
    return {

        {
            ":TestFunct",
            function()
                require("r.utils").YoungTest()
            end,
            description = "Test func",
        },

        {
            itemgroup = "Misc",
            commands = {
                {
                    ":InfoBaseColorsTheme",
                    function()
                        return require("r.utils").infoBaseColorsTheme()
                    end,
                    description = "Misc: base color (untuk theme bspwm)",
                },

                {
                    ":InfoOption",
                    function()
                        return require("r.utils").infoFoldPreview()
                    end,
                    description = "Misc: echo options",
                },
                {
                    ":ToggleSemantic",
                    function()
                        require("r.utils").toggle_buffer_semantic_tokens(
                            vim.api.nvim_get_current_buf()
                        )
                    end,
                    description = "Misc: toggle semantics tokens",
                },
                {
                    ":Snippets",
                    function()
                        require("r.utils").EditSnippet()
                    end,
                    description = "Misc: edit Snippets",
                },

                -- NEOGEN -------------------------------------------------------------
                {
                    ":Neogen",
                    description = "Generate annotation",
                },
            },
        },

        {
            ":Uuid",
            function()
                local uuid = fn.system("uuidgen"):gsub("\n", ""):lower()
                local line = fn.getline "."
                return vim.schedule(function()
                    fn.setline(
                        ---@diagnostic disable-next-line: param-type-mismatch
                        ".",
                        fn.strpart(line, 0, fn.col ".")
                            .. uuid
                            .. fn.strpart(line, fn.col ".")
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
                local filepath = fn.expand "%:p:h" -- code
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
                    ["qf"] = require("r.utils").toggle_kil_loc_qf,
                }

                local wins = vim.api.nvim_tabpage_list_wins(0)
                -- Both neo-tree and aerial will auto-quit if there is only a single window left
                if #wins <= 1 then
                    return as.smart_quit()
                end

                local sidebar_fts = { aerial = true, ["neo-tree"] = true }

                for _, winid in ipairs(wins) do
                    if vim.api.nvim_win_is_valid(winid) then
                        local bufnr = vim.api.nvim_win_get_buf(winid)
                        local filetype = vim.api.nvim_get_option_value(
                            "filetype",
                            { buf = bufnr }
                        )

                        -- If any visible windows are not sidebars, early return
                        if not sidebar_fts[filetype] then
                            for ft_i, exec_msg in pairs(buf_fts) do
                                if ft == ft_i then
                                    if type(exec_msg) == "string" then
                                        return cmd(exec_msg)
                                    elseif type(exec_msg) == "function" then
                                        return exec_msg()
                                    end
                                else
                                    return as.smart_quit()
                                    -- return require("mini.bufremove").delete(0, false)
                                end
                            end

                        -- If the visible window is a sidebar
                        else
                            -- only count filetypes once, so remove a found sidebar from the detection
                            sidebar_fts[filetype] = nil
                        end
                    end
                end

                if #vim.api.nvim_list_tabpages() > 1 then
                    vim.cmd.tabclose()
                else
                    vim.cmd.qall()
                end
            end,
            description = "Magic quit windows or tabs",
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
        {
            itemgroup = "Window-splits",
            description = "Windows; split, commands",
            icon = "",
            keymaps = {
                {
                    -- "<localleader>ws",
                    "<c-w>J",
                    "<C-W>t <C-W>K",
                    description = "Windows: change two horizontally split windows to vertical splits",
                },
                {
                    "<c-w>L",
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
                    "<leader>uh",
                    function()
                        vim.lsp.buf.inlay_hint(0, nil)
                    end,
                    description = "Misc: toogle inlayhints",
                },
                {
                    -- TODO: apakah ini ditaruh di category lsp?
                    "<leader>ud",
                    function()
                        require("r.utils").toggle_diagnostics()
                    end,
                    description = "Misc: toogle diagnostics",
                },
                {
                    "<Leader>us",
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
                return cmd("edit " .. vim.lsp.get_log_path())
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
            {
                "<leader>gR",
                function()
                    return vim.lsp.buf.rename()
                end,
                description = "LSP: rename",
                -- opts = { buffer = bufnr },
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

            -- Diagnostic
            -- {
            --     "<leader>gQ",
            --     "<CMD>Trouble workspace_diagnostics<CR>",
            --     description = "Trouble: workspaces",
            --     -- opts = { buffer = bufnr },
            -- },
            {
                -- "<CMD>Trouble document_diagnostics<CR>",
                "<leader>gq",
                function()
                    if #vim.diagnostic.get() > 0 then
                        return vim.diagnostic.setqflist()
                    else
                        as.info("Document its clean..", "Diagnostic")
                    end
                end,
                description = "Diagnostic: sending to qf",
                -- opts = { buffer = bufnr },
            },
            {
                "dP",
                vim.diagnostic.open_float,
                description = "Diagnostic: open float preview",
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
                --
            },
        },
    }

    vim.g.lsp_keymaps = true

    return keymaps
end

return M
