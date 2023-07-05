local neozoom = false
local fmt, cmd, fn = string.format, vim.cmd, vim.fn

local M = {}

--  ╭──────────────────────────────────────────────────────────╮
--  │                     Default Commands                     │
--  ╰──────────────────────────────────────────────────────────╯
function M.default_keymaps()
    return {
        --  ════════════════════════════════════════════════════════════
        --  BASIC
        --  ════════════════════════════════════════════════════════════
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
                require("notify").dismiss {}
                return cmd.nohl()
            end,
            hide = true,
            description = "Clear searches",
        },
        {
            "n",
            "nzzzv",
            hide = true,
            description = "Search next",
        },
        {
            "N",
            "Nzzzv",
            hide = true,
            description = "Search prev",
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
        --  ════════════════════════════════════════════════════════════
        --  WINDOWS
        --  ════════════════════════════════════════════════════════════
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
        --  ════════════════════════════════════════════════════════════
        --  BUFFER AND TABS
        --  ════════════════════════════════════════════════════════════
        {
            itemgroup = "Buffertabs",
            description = "Buffer and tab commands",
            icon = as.ui.icons.misc.tab,
            keymaps = {
                --  +----------------------------------------------------------+
                --  Buffers
                --  +----------------------------------------------------------+
                {
                    "<Leader>O",
                    function()
                        return require("r.utils").Buf_only()
                    end,
                    description = "Buffer: BufOnly",
                },
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

                --  +----------------------------------------------------------+
                --  Tabs
                --  +----------------------------------------------------------+
                { "tn", "<CMD>tabedit %<CR>", description = "Tab: new tab" },
                { "tl", "<CMD>tabn<CR>", description = "Tab: next tab" },
                { "th", "<CMD>tabp<CR>", description = "Tab: prev tab" },
                { "tH", "<CMD>tabfirst<CR>", description = "Tab; first tab" },
                { "tL", "<CMD>tabfirst<CR>", description = "Tab: last tab" },
                { "tc", "<CMD>tabc<CR>", description = "Tab: close tab" },
            },
        },
        --  ════════════════════════════════════════════════════════════
        --  MISC
        --  ════════════════════════════════════════════════════════════
        {
            itemgroup = "Misc",
            icon = as.ui.icons.misc.smiley,
            description = "General functionality",
            keymaps = {

                -- {
                --     ":SudaRead",
                --     description = "Sudovim: read file sudo",
                -- },
                -- {
                --     ":SudaWrite",
                --     description = "Sudovim: write file sudo",
                -- },
                {
                    "<leader>uh",
                    function()
                        return require("r.utils").toggle_inlayhints(function()
                            vim.lsp.buf.inlay_hint(0, nil)
                        end)
                    end,
                    description = "Misc: toogle inlayhints",
                },
                {
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
                        end
                    end,
                    description = "Misc: toggle spell",
                },
            },
        },
    }
end
function M.default_commands()
    return {

        --  ════════════════════════════════════════════════════════════
        --  MISC
        --  ════════════════════════════════════════════════════════════
        {
            itemgroup = "Misc",
            commands = {
                --  +----------------------------------------------------------+
                --  Basic
                --  +----------------------------------------------------------+
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
                    description = "Misc: Generate a UUID and insert it into the buffer",
                },

                --  +----------------------------------------------------------+
                --  Plugins
                --  +----------------------------------------------------------+
                {
                    ":Snippets",
                    function()
                        require("r.utils").EditSnippet()
                    end,
                    description = "Misc: edit Snippets",
                },

                {
                    ":Neogen",
                    description = "Generate annotation",
                },

                {
                    ":CBcatalog",
                    function()
                        return require("comment-box").catalog()
                    end,
                    description = "Comment-box: show catalog",
                },

                {
                    ":ShowPackageInfo",
                    "<cmd>lua require('package-info').show()<cr>",
                    description = "ShowPackageInfo: ShowPackageInfo",
                },
            },
        },

        --  ════════════════════════════════════════════════════════════
        --  PLUGINS
        --  ════════════════════════════════════════════════════════════

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

return M
