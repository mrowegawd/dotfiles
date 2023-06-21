local neozoom = false
local cmd = vim.cmd

return {
    -- NUI
    {
        "MunifTanjim/nui.nvim",
    },
    -- PLENARY
    {
        "nvim-lua/plenary.nvim",
    },
    -- NVIM-WEB-DEVICONS
    {
        "nvim-tree/nvim-web-devicons",
        dependencies = { "DaikyXendo/nvim-material-icon" },
        config = function()
            require("nvim-web-devicons").setup {
                override = require("nvim-material-icon").get_icons(),
            }
        end,
    },
    -- LEGENDARY
    {
        "mrjones2014/legendary.nvim", -- A command palette for keymaps, commands and autocmds
        -- event = "VeryLazy",
        init = function()
            require("legendary").keymaps {
                {
                    "<Leader>fk",
                    require("legendary").find,
                    hide = true,
                    description = "Open Legendary",
                    mode = { "n", "v" },
                },
            }
        end,
        dependencies = {
            "kkharji/sqlite.lua",
        },
        config = function()
            local legendary = require "legendary"

            legendary.setup {
                -- select_prompt = "Legendary",
                select_prompt = " legendary.nvim ",
                include_builtin = false,
                include_legendary_cmds = true,
                which_key = { auto_register = false },

                keymaps = require("r.mappings").default_keymaps(),
                commands = require("r.mappings").default_commands(),

                default_opts = {
                    keymaps = { silent = true, noremap = true },
                },
                -- Log level, one of 'trace', 'debug', 'info', 'warn', 'error', 'fatal'
                log_level = "warn",
            }
        end,
    },
    -- CLOSE-BUFFERS
    -- {
    --     "kazhala/close-buffers.nvim",
    --     cmd = { "BDelete" },
    --     keys = {
    --         { "<leader>qq", "<Cmd>BDelete this<CR>", desc = "buffer delete" },
    --     },
    -- },
    -- VIM-HIGHLIGHTER
    {
        "azabiong/vim-highlighter", -- map ex: f<enter> `highlighte the word`
        event = "BufRead",
        -- cmd = { "Hi", "HI" },
        config = function()
            vim.g.HiSet = "f<CR>"
            vim.g.HiErase = "f<BS>"
            vim.g.HiClear = "f<C-L>"
            vim.g.HiFind = "f<Tab>"
        end,
    },
    -- VIM-LOG
    {
        "mtdl9/vim-log-highlighting",
        ft = "log",
    },
    -- SUDA
    {
        "lambdalisue/suda.vim",
        cmd = { "SudaRead", "SudaWrite" },
        init = function()
            require("legendary").keymaps {
                {
                    itemgroup = "Misc",
                    commands = {
                        {
                            ":SudaRead",
                            description = "Sudovim: read file sudo",
                        },
                        {
                            ":SudaWrite",
                            description = "Sudovim: write file sudo",
                        },
                    },
                },
            }
        end,
    },
    -- NUMTOSTR COMMENT
    {
        "numToStr/Comment.nvim",
        keys = {
            { "gc", mode = { "n", "v" } },
            { "gcc", mode = { "n", "v" } },
            { "gbc", mode = { "n", "v" } },
        },
        dependencies = {
            {
                "JoosepAlviste/nvim-ts-context-commentstring",
            },
        },
        config = function()
            require("Comment").setup {
                pre_hook = require(
                    "ts_context_commentstring.integrations.comment_nvim"
                ).create_pre_hook(),
            }
        end,
    },
    -- VIM-STARTUPTIME (disabled)
    { -- Dont forget to check this https://github.com/neovim/neovim/pull/15436 is merged
        "dstein64/vim-startuptime",
        cmd = { "StartupTime" },
        enabled = false,
        init = function()
            require("legendary").keymaps {
                {
                    itemgroup = "Misc",
                    commands = {
                        {
                            ":StartupTime",
                            description = "StartupTime: profile Neovim's startup time",
                        },
                    },
                },
            }
        end,
        config = function()
            vim.g.startuptime_tries = 10
        end,
    },
    -- TREESJ
    -- {
    --     "Wansmer/treesj",
    --     keys = { "<space>m", "<space>j", "<space>s" },
    --     dependencies = { "nvim-treesitter/nvim-treesitter" },
    --     config = function()
    --         require("treesj").setup {}
    --     end,
    -- },
    -- HELPFUL.VIM
    { "tweekmonster/helpful.vim", cmd = "HelpfulVersion", ft = "help" },
    -- NUMB-NVIM
    {
        "nacro90/numb.nvim",
        event = "CmdlineEnter",
        config = function()
            local numb = require "numb"

            numb.setup {
                show_numbers = true, -- Enable 'number' for the window while peeking
                show_cursorline = true, -- Enable 'cursorline' for the window while peeking
            }
        end,
    },
    -- ZENMODE
    {
        "folke/zen-mode.nvim",
        cmd = "ZenMode",
        config = function()
            require("zen-mode").setup {
                plugins = {
                    gitsigns = true,
                    tmux = true,
                    kitty = { enabled = false, font = "+2" },
                },
            }
        end,
    },
    -- VIM-MATCHUP
    {
        "andymass/vim-matchup",
        event = { "BufReadPost" },
        config = function()
            vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
        end,
    },
    -- HYPERSONIC.NVIM (make regex readable)
    {
        "tomiis4/Hypersonic.nvim",
        cmd = { "Hypersonic" },
        config = function()
            require("hypersonic").setup()
        end,
    },
    -- HLARGS
    {
        "m-demare/hlargs.nvim",
        enabled = true,
        event = "UIEnter",
        opts = {
            color = "#ef9062",
            use_colorpalette = true,
            colorpalette = {
                { fg = "#ef9062" },
                { fg = "#3AC6BE" },
                { fg = "#35D27F" },
                { fg = "#EB75D6" },
                { fg = "#E5D180" },
                { fg = "#8997F5" },
                { fg = "#D49DA5" },
                { fg = "#7FEC35" },
                { fg = "#F6B223" },
                { fg = "#F67C1B" },
                { fg = "#DE9A4E" },
                { fg = "#BBEA87" },
                { fg = "#EEF06D" },
                { fg = "#8FB272" },
            },
            -- disable = function(_, bufnr)
            --     if vim.b.semantic_tokens then
            --         return true
            --     end
            --     local clients = vim.lsp.get_active_clients { bufnr = bufnr }
            --     for _, c in pairs(clients) do
            --         local caps = c.server_capabilities
            --         if
            --             c.name ~= "null-ls"
            --             and caps.semanticTokensProvider
            --             and caps.semanticTokensProvider.full
            --         then
            --             vim.b.semantic_tokens = true
            --             return vim.b.semantic_tokens
            --         end
            --     end
            -- end,
        },
    },
    -- NEOZOOM
    {
        "nyngwang/NeoZoom.lua",
        cmd = "NeoZoomToggle",
        init = function()
            require("legendary").keymaps {
                {
                    itemgroup = "Misc",
                    keymaps = {
                        {
                            "<a-m>",
                            function()
                                if neozoom then
                                    neozoom = false
                                else
                                    neozoom = true
                                end
                                return cmd "NeoZoomToggle"
                            end,
                            description = "Neozoom: toggle",
                        },
                    },
                },
            }
        end,
        config = function()
            require("neo-zoom").setup {
                scrolloff_on_enter = 7,
                exclude_buftypes = { "terminal" },
            }
        end,
    },
    -- UNDOTREE
    {
        "mbbill/undotree",
        cmd = "UndotreeToggle",
        enabled = false,
        init = function()
            require("legendary").keymaps {
                {
                    itemgroup = "Misc",
                    keymaps = {
                        {
                            "<Leader>m",
                            "<CMD>UndotreeToggle<CR>",
                            description = "Undotree: toggle",
                        },
                    },
                },
            }
        end,
        config = function()
            vim.g.undotree_SplitWidth = 35
            vim.g.undotree_DiffpanelHeight = 7
            vim.g.undotree_WindowLayout = 2 -- Tree on the left, diff on the bottom

            vim.g.undotree_TreeNodeShape = "◉"
            vim.g.undotree_SetFocusWhenToggle = 1
        end,
    },
    -- POMODORO-CLOCK
    {
        "jackMort/pommodoro-clock.nvim",
        cmd = {
            "PomodoroStop",
            "PomodoroStart",
            "PomodoroShortBreak",
            "PomodoroLongBreak",
        },
        init = function()
            require("legendary").keymaps {
                {
                    itemgroup = "Misc",
                    commands = {
                        {
                            ":PomodoroStart",
                            function()
                                return require("pommodoro-clock").start "work"
                            end,
                            description = "Pomodoro: start",
                        },

                        {
                            ":PomodoroLongBreak",
                            function()
                                return require("pommodoro-clock").start "long_break"
                            end,
                            description = "Pomodoro: long break",
                        },

                        {
                            ":PomodoroShortBreak",
                            function()
                                return require("pommodoro-clock").start "short_break"
                            end,
                            description = "Pomodoro: short break",
                        },

                        {
                            ":PomodoroStop",
                            function()
                                return require("pommodoro-clock").close()
                            end,
                            description = "Pomodoro: stop",
                        },
                    },
                },
            }
        end,
        config = function()
            require("pommodoro-clock").setup {}
        end,
    },
    -- BEACON
    {
        "rainbowhxch/beacon.nvim",
        event = "VeryLazy",
        opts = {
            minimal_jump = 20,
            ignore_buffers = { "terminal", "nofile", "neorg://Quick Actions" },
            ignore_filetypes = {
                "qf",
                "dap_watches",
                "dap_scopes",
                "neo-tree",
                "NeogitCommitMessage",
                "NeogitPopup",
                "NeogitStatus",
            },
        },
    },
    -- GKEEP
    {
        -- Check and run: `python3 -m pip install gkeepapi keyring`
        "stevearc/gkeep.nvim",
        build = ":UpdateRemotePlugins",
        event = "BufReadPre gkeep://*",
    },

    ---------------------------------------------------------------------
    -- MY PLUGINS
    ---------------------------------------------------------------------
    {
        dir = "~/.local/src/nvim_plugins/jumpj",
        enabled = false,
        event = "BufRead",
        config = function()
            require("jumpj").setup {}
        end,
    },
}
