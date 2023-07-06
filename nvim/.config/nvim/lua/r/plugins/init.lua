return {
    -- NUI
    "MunifTanjim/nui.nvim",
    -- PLENARY
    "nvim-lua/plenary.nvim",
    -- NVIM-WEB-DEVICONS
    {
        "nvim-tree/nvim-web-devicons",
        -- dependencies = { "DaikyXendo/nvim-material-icon" },
        -- config = function()
        --     require("nvim-web-devicons").setup {
        --         override = require("nvim-material-icon").get_icons(),
        --     }
        -- end,
    },
    -- VIM-HIGHLIGHTER
    {
        "azabiong/vim-highlighter", -- map ex: f<enter> `highlighte the word`
        keys = {
            "f<CR>",
            "f<BS>",
            "f<C-L>",
            "f<Tab>",
        },
        setup = function()
            vim.g.HiSet = "f<CR>"
            vim.g.HiErase = "f<BS>"
            vim.g.HiClear = "f<C-L>"
            vim.g.HiFind = "f<Tab>"
        end,
    },
    -- VIM-LOG
    {
        "mtdl9/vim-log-highlighting",
        lazy = false,
    },
    -- SUDA
    {
        "lambdalisue/suda.vim",
        cmd = { "SudaWrite", "SudaRead" },
    },
    -- NUMTOSTR COMMENT
    {
        "numToStr/Comment.nvim",
        keys = {
            { "gc", mode = { "n", "v" } },
            { "gcc", mode = { "n", "v" } },
            { "gbc", mode = { "n", "v" } },
        },
        opts = function()
            local commentstring_avail, commentstring = pcall(
                require,
                "ts_context_commentstring.integrations.comment_nvim"
            )
            return commentstring_avail
                    and commentstring
                    and { pre_hook = commentstring.create_pre_hook() }
                or {}
        end,
    },
    -- NUMB-NVIM
    {
        "nacro90/numb.nvim",
        event = "CmdlineEnter",
        config = true,
    },
    -- VIM-MATCHUP
    -- {
    --     "andymass/vim-matchup",
    --     event = { "BufReadPost" },
    --     config = function()
    --         vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
    --     end,
    -- },
    -- COMMENT-BOX
    {
        "LudoPinelli/comment-box.nvim",
        cmd = {
            "CBlcbox",
            "CBllbox",
            "CBlcbox",
            "CBlrbox",
            "CBclbox",
            "CBccbox",
            "CBcrbox",
            "CBrlbox",
            "CBrcbox",
            "CBalbox",
            "CBacbox",
            "CBarbox",
        },
        config = function()
            as.command(":CBcatalog", function()
                return require("comment-box").catalog()
            end, { desc = "Comment-box: show catalog" })
        end,
    },
    -- HYPERSONIC.NVIM (make regex readable)
    {
        "tomiis4/Hypersonic.nvim",
        cmd = { "Hypersonic" },
        config = true,
    },
    -- HLARGS
    {
        "m-demare/hlargs.nvim",
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
        opts = {
            scrolloff_on_enter = 7,
            exclude_buftypes = { "terminal" },
        },
    },
    -- UNDOTREE
    {
        "mbbill/undotree",
        cmd = "UndotreeToggle",
        init = function()
            vim.g.undotree_SplitWidth = 35
            vim.g.undotree_DiffpanelHeight = 7
            vim.g.undotree_WindowLayout = 2 -- Tree on the left, diff on the bottom

            vim.g.undotree_TreeNodeShape = "◉"
            vim.g.undotree_SetFocusWhenToggle = 1
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

    -- ALpha
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        -- priority = 5, -- Load after persisted.nvim
        config = function()
            local alpha = require "alpha"

            -- Get ascii generator:
            -- https://lachlanarthur.github.io/Braille-ASCII-Art/
            local one_punch_man = {
                [[]],
                [[                 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⡤⠤⠤⠤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠖⠈⠉⠉⠁⠒⠤⡀⠀⠀ ]],
                [[                 ⠀⠀⠀⠀⠀⠀⠀⠀⢀⡤⠾⠿⠶⠀⠀⠀⠀⠀⠈⠑⢦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡔⠁⠀⠀⠀⠀⠀⠀⠀⠈⢆⠀ ]],
                [[                 ⠀⠀⠀⠀⠀⠀⠀⣰⣯⣍⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡜⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡄ ]],
                [[                 ⠀⠀⠀⠀⠀⠀⡸⠥⠤⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢣ ]],
                [[                 ⠀⠀⠀⠀⠀⢠⣯⠭⠭⠭⠤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡌⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸ ]],
                [[                 ⠀⠀⠀⠀⠀⣼⣛⣛⣛⣒⡀⠀⠀⠤⠤⠤⠤⠤⠀⠀⠤⠤⠤⠄⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⢀⣀⡀⡀⠀⡀⠀⠀⠀⢸ ]],
                [[                 ⠀⠀⠀⠀⠀⢹⡤⠤⠄⠀⠀⠀⡔⠒⠛⠗⢲⠀⢀⠐⠚⠍⢑⡆⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⢰⠁⠀⡐⣧⣎⠀⠀⠀⠀⢸ ]],
                [[                 ⠀⠀⠀⠀⢰⣏⣙⣶⣒⣈⡁⠀⠈⠒⠂⠒⠁⠀⢸⠈⠒⠒⠊⠀⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠁⠀⠀⠈⠒⠊⠀⠃⠀⠑⠀⠀⠀⢸ ]],
                [[                 ⠀⠀⠀⠀⣿⠉⣹⡍⠀⠀⠀⠀⣀⠀⠀⠀⠀⠀⠈⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢣⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸ ]],
                [[                 ⠀⠀⠀⠀⠸⣝⣟⣅⡀⠀⠀⠀⣀⠀⠀⠀⠀⠀⠀⠃⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇ ]],
                [[                 ⠀⠀⠀⠀⠀⠙⢌⣁⡤⠤⠶⠤⠀⠀⠀⠀⠀⢀⣀⡀⠀⠀⠀⢀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀ ]],
                [[                 ⠀⠀⠀⠀⠀⠀⠀⠀⢹⣈⣉⣉⣉⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡼⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢱⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠃⠀ ]],
                [[                 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⡭⠥⠄⠀⠀⠀⠀⠀⠀⠀⠀⢀⡼⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⠤⣀⠀⠀⠀⢀⡠⠔⠁⠀⠀ ]],
                [[                 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⡶⢭⣁⠀⠀⠀⠀⠀⢀⡤⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠁⠀⠀⠀⠀  ]],
                [[                 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡧⠀⣈⡛⠒⠒⠒⠋⢹⠤⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
                [[                 ⠀⠀⠀⠀⠀⠀⠀⢀⡠⢴⠷⡏⠉⠉⠀⠀⠀⠀⠀⢸⣆⠈⢧⡙⡖⢤⠐⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
                [[                 ⠀⠀⠀⢀⣀⣖⣚⣻⣛⣿⣏⢻⣄⡀⠀⠀⠀⠀⠀⢈⡼⢦⡀⢳⣿⣶⣤⡄⠑⢢⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
                [[                 ⠀⠀⣼⣁⣀⣉⣙⣿⣿⣿⣷⢸⡀⠈⠉⠓⣲⡶⣾⡍⠀⠀⣳⢄⣛⣟⣛⣠⣶⣻⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
                [[                 ⠀⢠⣟⣿⣿⢷⣶⣮⡭⢽⡒⣿⣗⣤⣀⣀⣻⠙⠁⢇⣴⣾⣿⣿⣷⣿⣾⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
                [[                 ⣰⢻⣧⣍⡹⣽⣿⣧⡗⡤⣠⣥⣿⣿⣿⡾⣧⣘⣣⠼⢹⣿⣿⣿⣿⣿⣿⢻⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
                [[                 ⣯⣽⣿⣿⢚⣻⣿⣷⣿⣫⣟⣻⣿⣿⣿⣷⡇⢸⣿⡄⢸⣿⣿⣿⣿⣿⣿⡿⣟⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
                [[                 ⣾⣶⣿⣾⣯⣥⣿⣿⣟⣿⣯⣿⣿⣿⣿⣿⣿⣇⣸⣿⣃⣸⣿⣿⣿⣿⣿⣷⣿⣿⣿⣾⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
                [[]],
            }

            local header = {
                type = "text",
                val = one_punch_man,
                opts = {
                    position = "center",
                    hl = "AlphaHeader",
                },
            }

            -- io.popen 'fd --max-depth 1 . $HOME"/.local/share/nvim/lazy" | head -n -2 | wc -l | tr -d "\n" '
            -- io.popen 'fd -d 2 . $HOME"/.local/share/nvim/site/pack/deps" | head -n -2 | wc -l | tr -d "\n" '
            --
            -- local plugins = ""
            -- if handle ~= nil then
            --     plugins = handle:read "*a"
            --     handle:close()
            -- end

            local thingy =
                io.popen 'echo "$(date +%a) $(date +%d) $(date +%b)" | tr -d "\n"'

            local date = ""
            if thingy ~= nil then
                date = thingy:read "*a"
                thingy:close()
            end

            local function get_installed_plugins()
                local ok, lazy = pcall(require, "lazy")
                if not ok then
                    return 0
                end
                return lazy.stats().count
            end

            local plugin_count = {
                type = "text",
                val = "└─  "
                    .. get_installed_plugins()
                    .. " plugins in total ─┘",
                opts = {
                    position = "center",
                    hl = "AlphaHeader",
                },
            }

            local heading = {
                type = "text",
                val = "┌─   Today is " .. date .. " ─┐",
                opts = {
                    position = "center",
                    hl = "AlphaHeader",
                },
            }

            local footer = {
                type = "text",
                val = "-GiTMoX-",
                opts = {
                    position = "center",
                    hl = "AlphaFooter",
                },
            }

            local function button(sc, txt, keybind)
                local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")

                local opts = {
                    position = "center",
                    text = txt,
                    shortcut = sc,
                    cursor = 5,
                    width = 24,
                    align_shortcut = "right",
                    hl_shortcut = "AlphaButtons",
                    hl = "AlphaButtons",
                }
                if keybind then
                    opts.keymap =
                        { "n", sc_, keybind, { noremap = true, silent = true } }
                end

                return {
                    type = "button",
                    val = txt,
                    on_press = function()
                        local key = vim.api.nvim_replace_termcodes(
                            sc_,
                            true,
                            false,
                            true
                        )
                        vim.api.nvim_feedkeys(key, "normal", false)
                    end,
                    opts = opts,
                }
            end

            local buttons = {
                type = "group",
                val = {
                    button("o", "   Recents", ":FzfLua oldfiles<CR>"),
                    button("f", "   Explore", ":FzfLua files<CR>"),
                    button("g", "   Ripgrep", ":FzfLua live_grep<CR>"),
                    button(
                        "s",
                        "   Sessions",
                        "<CMD>lua require('nvim-possession').list()<CR>"
                    ),
                    button("q", "   Quit", "<cmd>qa<cr>"),
                },
                opts = {
                    spacing = 1,
                },
            }

            local section = {
                header = header,
                buttons = buttons,
                plugin_count = plugin_count,
                heading = heading,
                footer = footer,
            }

            local options = {
                layout = {
                    { type = "padding", val = 1 },
                    section.header,
                    { type = "padding", val = 1 },
                    section.heading,
                    section.plugin_count,
                    { type = "padding", val = 1 },
                    -- section.top_bar,
                    section.buttons,
                    -- section.bot_bar,
                    { type = "padding", val = 1 },
                    section.footer,
                },
                opts = {
                    margin = 20,
                },
            }

            alpha.setup(options)
        end,
    },

    --  ╭──────────────────────────────────────────────────────────╮
    --  │                        MY PLUGINS                        │
    --  ╰──────────────────────────────────────────────────────────╯
    {
        dir = "~/.local/src/nvim_plugins/jumpj",
        enabled = false,
        event = "BufRead",
        config = function()
            require("jumpj").setup {}
        end,
    },
}
