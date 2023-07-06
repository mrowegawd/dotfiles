local highlight = as.highlight

return {
    -- GITHUB NOTIFICATIONS
    { "rlch/github-notifications.nvim" },
    -- GIT CONFLICT
    {
        "akinsho/git-conflict.nvim", --- hanya untuk viewer untuk git log, namun bisa di kombinasi dengan fugitive
        version = "*",
        cmd = {
            "GitConflictChooseOurs",
            "GitConflictChooseTheirs",
            "GitConflictChooseBoth",
            "GitConflictChooseNone",
            "GitConflictNextConflict",
            "GitConflictPrevConflict",
            "GitConflictListQf",
        },
        config = function()
            require("git-conflict").setup {
                default_mappings = true, -- disable buffer local mapping created by this plugin
                default_commands = true, -- disable commands created by this plugin
                disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
                highlights = { -- They must have background color, otherwise the default color will be used
                    incoming = "DiffText",
                    current = "DiffAdd",
                },
            }
        end,
    },
    -- GITLINKER
    {
        "ruifm/gitlinker.nvim", -- generate shareable file permalinks
        event = "BufReadPre",
        opts = {
            mappings = "<leader>hy",
        },
        config = function(_, opts)
            require("gitlinker").setup(opts)
        end,
    },
    -- OCTO
    {
        "pwntester/octo.nvim",
        cmd = "Octo",
        dependencies = {
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require("octo").setup()
        end,
    },
    -- FUGITIVE
    {
        "tpope/vim-fugitive",
        event = "BufRead",
        -- cmd = {
        --     "Git",
        --     "GBrowse",
        --     "Gdiffsplit",
        --     "Gvdiffsplit",
        --     "Gclog",
        --     -- "0Gclog",
        -- },
        dependencies = {
            "tpope/vim-rhubarb",
            "idanarye/vim-merginal", -- fugitive dependencies, UI git branches
        },
    },
    -- GIT ADVANCED SEARCH
    {
        "aaronhallaert/advanced-git-search.nvim",
        dependencies = {
            "sindrets/diffview.nvim",
            "ibhagwan/fzf-lua",
            "tpope/vim-fugitive",
            "tpope/vim-rhubarb",
        },
        init = function()
            vim.api.nvim_create_user_command(
                "DiffCommitLine",
                "lua require('advanced_git_search.fzf').diff_commit_line()",
                { range = true }
            )
        end,
        config = function()
            require("advanced_git_search.fzf").setup {
                diff_plugin = "diffview",
                git_flags = {},
                git_diff_flags = {},
                show_builtin_git_pickers = false,
            }
        end,
    },
    -- GITSIGNS
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        opts = {
            -- Experimental ------------------------------------------------------------------------------
            _extmark_signs = true,
            _signs_staged_enable = false,
            signs = {
                add = {
                    hl = "GitSignsAdd",
                    text = "▎",
                    -- numhl = "GitSignsAddNr",
                    -- linehl = "GitSignsAddLn",
                },
                change = {
                    hl = "GitSignsChange",
                    text = "▎", -- "▍"
                    -- numhl = "GitSignsChangeNr",
                    -- linehl = "GitSignsChangeLn",
                },
                delete = {
                    hl = "GitSignsDelete",
                    text = "▎",
                    -- numhl = "GitSignsDeleteNr",
                    -- linehl = "GitSignsDeleteLn",
                },
                topdelete = {
                    hl = "GitSignsDelete",
                    text = "▎",
                    -- numhl = "GitSignsDeleteNr",
                    -- linehl = "GitSignsDeleteLn",
                },
                changedelete = {
                    hl = "GitSignsChange",
                    text = "▎",
                    -- numhl = "GitSignsChangeNr",
                    -- linehl = "GitSignsChangeLn",
                },
                untracked = {
                    hl = "GitSignsAdd",
                    text = "▎",
                    -- numhl = "GitSignsAddNr",
                    -- linehl = "GitSignsAddLn",
                },
            },
            -- on_attach = nil,
            on_attach = function(bufnr)
                require("r.mappings.utils.git").signs(
                    bufnr,
                    package.loaded.gitsigns
                )
            end,
        },
    },
    -- GIT ADVANCED SEARCH
    {
        "aaronhallaert/advanced-git-search.nvim",
        dependencies = {
            "ibhagwan/fzf-lua",
            "tpope/vim-fugitive",
            "tpope/vim-rhubarb",
            -- DIFFVIEW
            {
                "sindrets/diffview.nvim",
                cmd = {
                    "DiffviewLog",
                    "DiffviewOpen",
                    "DiffviewClose",
                    "DiffviewRefresh",
                    "DiffviewFocusFiles",
                    "DiffviewFileHistory",
                    "DiffviewToggleFiles",
                },
                dependencies = {
                    "nvim-lua/plenary.nvim",
                },
                -- Dont mess me up >_>, (`<c-i>` `<c-o>`)
                init = function()
                    require("r.utils").disable_ctrl_i_and_o(
                        "NoDiffview",
                        { "DiffviewFiles", "DiffviewFileHistory" }
                    )
                end,
                config = function()
                    local diffview = require "diffview"
                    local actions = require "diffview.actions"

                    local cb = require("diffview.config").diffview_callback

                    diffview.setup {
                        enhanced_diff_hl = true,
                        git_cmd = { "git" },
                        hg_cmd = { "chg" },
                        hooks = {
                            diff_buf_read = function()
                                local opt = vim.opt_local
                                opt.wrap, opt.list, opt.relativenumber =
                                    false, false, false
                                opt.colorcolumn = ""
                            end,
                        },
                        key_bindings = {
                            disable_defaults = true, -- Disable the default key bindings
                            -- The `view` bindings are active in the diff buffers, only when the current
                            -- tabpage is a Diffview.
                            view = {
                                ["<tab>"] = actions.select_next_entry, -- Open the diff for the next file
                                ["<s-tab>"] = actions.select_prev_entry, -- Open the diff for the previous file

                                ["gf"] = actions.goto_file, -- Open the file in a new split in previous tabpage
                                ["<C-s>"] = actions.goto_file_split, -- Open the file in a new split
                                ["<C-t>"] = actions.goto_file_tab, -- Open the file in a new tabpage

                                ["<space>E"] = actions.focus_files, -- Bring focus to the files panel
                                ["<space>e"] = actions.toggle_files, -- Toggle the files panel.

                                ["<F4>"] = actions.cycle_layout,
                                ["<space><tab>"] = "<Cmd>DiffviewClose<CR>",
                            },
                            file_panel = {

                                ["<c-u>"] = actions.scroll_view(-0.25),
                                ["<c-d>"] = actions.scroll_view(0.25),

                                ["j"] = actions.next_entry,
                                ["k"] = actions.prev_entry,
                                ["<down>"] = actions.next_entry,
                                ["<up>"] = actions.prev_entry,
                                ["<c-n>"] = actions.select_next_entry,
                                ["<c-p>"] = actions.select_prev_entry,
                                ["<cr>"] = actions.select_entry,
                                ["<2-LeftMouse>"] = actions.select_entry,

                                ["<tab>"] = actions.select_next_entry,
                                ["<s-tab>"] = actions.select_prev_entry,

                                -- ["-"] = actions.toggle_stage_entry, -- Stage / unstage the selected entry.
                                -- ["S"] = actions.stage_all, -- Stage all entries.
                                -- ["U"] = actions.unstage_all, -- Unstage all entries.
                                -- ["X"] = actions.restore_entry, -- Restore entry to the state on the left side.
                                -- ["R"] = actions.refresh_files, -- Update stats and entries in the file list.

                                ["H"] = actions.listing_style, -- Toggle between 'list' and 'tree' views
                                ["f"] = actions.toggle_flatten_dirs, -- Flatten empty subdirectories in tree listing style.

                                ["o"] = actions.goto_file_edit,
                                ["<c-t>"] = actions.goto_file_tab,
                                ["<c-s>"] = actions.goto_file_split,

                                ["<F4>"] = actions.cycle_layout,
                                ["L"] = actions.open_commit_log,
                                ["R"] = actions.refresh_files,

                                ["<space>E"] = actions.focus_files,
                                ["<space>e"] = actions.toggle_files,

                                ["gf"] = "",
                                ["<space><tab>"] = "<Cmd>DiffviewClose<CR>",
                            },
                            file_history_panel = {
                                ["?"] = actions.options, -- Open the option panel

                                ["<c-u>"] = actions.scroll_view(-0.25),
                                ["<c-d>"] = actions.scroll_view(0.25),

                                ["zR"] = actions.open_all_folds,
                                ["zM"] = actions.close_all_folds,
                                ["zo"] = actions.open_fold,
                                ["zc"] = actions.close_fold,
                                ["za"] = actions.toggle_fold,
                                ["<tab>"] = actions.toggle_fold,
                                ["<s-tab>"] = actions.toggle_fold,

                                ["j"] = actions.next_entry,
                                ["k"] = actions.prev_entry,
                                ["<down>"] = actions.next_entry,
                                ["<up>"] = actions.prev_entry,
                                ["<c-n>"] = actions.select_next_entry,
                                ["<c-p>"] = actions.select_prev_entry,
                                ["<cr>"] = actions.select_entry,
                                ["<2-LeftMouse>"] = actions.select_entry,

                                ["o"] = actions.goto_file_edit,
                                ["<c-t>"] = actions.goto_file_tab,
                                ["<c-s>"] = actions.goto_file_split,

                                ["<F4>"] = actions.cycle_layout,
                                ["L"] = actions.open_commit_log,
                                ["D"] = actions.open_in_diffview, -- Open the entry under the cursor in a diffview
                                ["y"] = actions.copy_hash, -- Copy the commit hash of the entry under the cursor

                                ["<space>E"] = actions.focus_files,
                                ["<space>e"] = actions.toggle_files,

                                ["gf"] = "",
                            },
                            option_panel = {
                                ["<tab>"] = cb "select",
                            },
                        },
                    }
                end,
            },
        },
        init = function()
            vim.api.nvim_create_user_command(
                "DiffCommitLine",
                "lua require('advanced_git_search.fzf').diff_commit_line()",
                { range = true }
            )
        end,
        config = function()
            require("advanced_git_search.fzf").setup {
                diff_plugin = "diffview",
                git_flags = {},
                git_diff_flags = {},
                show_builtin_git_pickers = false,
            }
        end,
    },
    -- NEOGIT (disabled)
    {
        "TimUntersberger/neogit",
        cmd = "Neogit",
        enabled = false,
        init = function()
            require("r.utils").disable_ctrl_i_and_o(
                "NoNeogit",
                { "NeogitStatus" }
            )
        end,
        keys = {
            {
                "<leader>hl",
                "<CMD>Neogit<CR>",
                desc = "Git(neogit): open",
            },
            {
                "<Leader>hC",
                "<CMD>Neogit commit<CR>",
                desc = "Git(neogit): commit",
            },
        },
        config = function()
            local neogit = require "neogit"

            neogit.setup {
                disable_signs = false,
                disable_hint = false,
                disable_commit_confirmation = true,
                disable_builtin_notifications = true,
                disable_insert_on_commit = false,
                integrations = { diffview = true },
                signs = {
                    section = { "", "" }, -- "", ""
                    item = { "▸", "▾" },
                    hunk = { "樂", "" },
                },
            }

            highlight.plugin(
                "neogit",
                { -- NOTE: highlights must be set AFTER neogit's setup
                    { NeogitDiffAdd = { link = "DiffAdd" } },
                    { NeogitDiffDelete = { link = "DiffDelete" } },
                    { NeogitDiffAddHighlight = { link = "DiffAdd" } },
                    { NeogitDiffDeleteHighlight = { link = "DiffDelete" } },
                    { NeogitDiffContextHighlight = { link = "NormalFloat" } },
                    { NeogitHunkHeader = { link = "TabLine" } },
                    { NeogitHunkHeaderHighlight = { link = "DiffText" } },
                }
            )
        end,
    },
}
