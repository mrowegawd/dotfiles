local highlight = as.highlight

return {
    -- TREESITTER
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        init = function()
            require("legendary").keymaps {
                {
                    itemgroup = "Misc",
                    keymaps = {
                        {

                            "m",
                            [[:<C-U>lua require('tsht').nodes()<CR>]],
                            description = "Treesitter: jump nodes",
                            mode = { "o", "x" },
                        },
                    },
                },
            }
            -- vim.cmd [[
            --     omap     <silent> m :<C-U>lua require('tsht').nodes()<CR>
            --     xnoremap <silent> m :lua require('tsht').nodes()<CR>
            -- ]]
        end,
        dependencies = {
            { "nvim-treesitter/nvim-treesitter-textobjects" },
            { "JoosepAlviste/nvim-ts-context-commentstring" },
            { "mfussenegger/nvim-treehopper" },
            -- { "David-Kunz/markid" },
            -- { "HiPhish/nvim-ts-rainbow2" },
        },
        config = function()
            local ok, orgmode = pcall(require, "orgmode")
            if ok then
                orgmode.setup_ts_grammar()
            end
            -- require("nvim-treesitter.install").compilers = { "gcc-12" }
            require("nvim-treesitter.configs").setup {
                -- end,
                ensure_installed = {
                    "bash",
                    "c",
                    "cmake",
                    -- "comment", -- comments are slowing down TS bigtime, so disable for now
                    "cpp",
                    "css",
                    "diff",
                    "fish",
                    "gitignore",
                    "go",
                    "graphql",
                    "html",
                    "http",
                    "java",
                    "javascript",
                    "jsdoc",
                    "jsonc",
                    "latex",
                    "lua",
                    "kotlin",
                    "dart",
                    "markdown",
                    "markdown_inline",
                    "meson",
                    "ninja",
                    "nix",
                    "norg",
                    "org",
                    "php",
                    "python",
                    "query",
                    "regex",
                    "rust",
                    "scss",
                    "sql",
                    "svelte",
                    "teal",
                    "toml",
                    "tsx",
                    "typescript",
                    "vhs",
                    "vim",
                    "vue",
                    "wgsl",
                    "yaml",
                    -- "wgsl",
                    "json",
                    -- "markdown",
                },

                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = { "orgmode" },
                },
                indent = { enable = true, disable = { "python", "org" } },
                context_commentstring = {
                    enable = true,
                    enable_autocmd = false,
                },
                -- incremental_selection = {
                --     enable = true,
                --     disable = { "help" },
                --     keymaps = {
                --         init_selection = "<CR>", -- maps in normal mode to init the node/scope selection
                --         node_incremental = "<CR>", -- increment to the upper named parent
                --         node_decremental = "<C-CR>", -- decrement to the previous node
                --     },
                -- },

                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = ";gn",
                        node_incremental = ";gi",
                        scope_incremental = ";gs",
                        node_decremental = ";gr",
                    },
                },

                -- rainbow = {
                --     enable = true,
                --     disable = { "tsx", "jsx", "html", "lua" },
                --     query = { "rainbow-parens" },
                --     strategy = require("ts-rainbow").strategy.global,
                -- },

                -- "David-Kunz/markid"
                -- https://github.com/David-Kunz/markid#installation
                -- markid = { enable = true }, --> for markid plugin

                -- "nvim-treesitter/nvim-treesitter-refactor"
                -- refactor = {
                --     smart_rename = {
                --         enable = true,
                --         client = {
                --             smart_rename = "<leader>cr",
                --         },
                --     },
                --     navigation = {
                --         enable = true,
                --         keymaps = {
                --             -- goto_definition = "gd",
                --             -- list_definitions = "gnD",
                --             -- list_definitions_toc = "gO",
                --             -- goto_next_usage = "<a-*>",
                --             -- goto_previous_usage = "<a-#>",
                --         },
                --     },
                -- },

                -- "nvim-treesitter/playground"
                playground = {
                    enable = true,
                    disable = {},
                    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
                    persist_queries = true, -- Whether the query persists across vim sessions
                    keybindings = {
                        toggle_query_editor = "o",
                        toggle_hl_groups = "i",
                        toggle_injected_languages = "t",
                        toggle_anonymous_nodes = "a",
                        toggle_language_display = "I",
                        focus_language = "f",
                        unfocus_language = "F",
                        update = "R",
                        goto_node = "<cr>",
                        show_help = "?",
                    },
                },

                query_linter = {
                    enable = true,
                    use_virtual_text = true,
                    lint_events = { "BufWrite", "CursorHold" },
                },

                -- nvim-treesitter-textobjects
                textobjects = {
                    select = {
                        enable = false,
                        lookahead = true,
                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                        },
                    },
                    move = {
                        enable = false,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            ["]f"] = "@function.outer",
                            ["]c"] = "@class.outer",
                        },
                        goto_next_end = {
                            ["]F"] = "@function.outer",
                            ["]C"] = "@class.outer",
                        },
                        goto_previous_start = {
                            ["[f"] = "@function.outer",
                            ["[c"] = "@class.outer",
                        },
                        goto_previous_end = {
                            ["[F"] = "@function.outer",
                            ["[C"] = "@class.outer",
                        },
                    },
                    lsp_interop = {
                        enable = false,
                        peek_definition_code = {
                            ["gD"] = "@function.outer",
                        },
                    },
                },
            }

            -- Howt to custom queries, check https://github.com/nvim-treesitter/nvim-treesitter/blob/master/queries/python/folds.scm)
            -- vim.treesitter.query.set(
            --     "lua",
            --     "folds",
            --     [[[(table_constructor)] @fold]]
            -- )
            -- vim.treesitter.query.set("markdown", "folds", [[[(section)] @fold]])
            -- vim.treesitter.query.set(
            --     "python",
            --     "folds",
            --     [[[(class_definition)] @fold]]
            -- )
        end,
    },
    -- PLAYGROUND
    {
        "nvim-treesitter/playground",
        cmd = { "TSPlaygroundToggle" },
        init = function()
            require("legendary").keymaps {
                {
                    itemgroup = "Misc",
                    commands = {
                        {
                            ":TSPlayground",
                            description = "Playground: treesitter playground",
                        },
                    },
                },
            }
        end,
        dependencies = { "nvim-treesitter" },
    },
    -- NVIM-TS-AUTOTAG
    {
        "windwp/nvim-ts-autotag",
        ft = {
            "typescriptreact",
            "javascript",
            "javascriptreact",
            "html",
            "vue",
        },
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = true,
    },
    -- NVIM-AUTOPAIRS
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            local npairs = require "nvim-autopairs"
            npairs.setup {
                -- check_ts = true,
                -- ts_config = {
                --     lua = { "string", "comment" }, -- it will not add a pair on that treesitter node
                -- },

                close_triple_quotes = true,
                check_ts = true,
                ts_config = {
                    lua = { "string" },
                    dart = { "string" },
                    javascript = { "template_string" },
                },
                disable_filetype = {
                    "TelescopePrompt",
                    "spectre_panel",
                    "neo-tree-popup",
                },

                -- fast_wrap = { map = "<c-e>" },
                fast_wrap = { map = nil },
                highlight = "PmenuSel",
                highlight_grey = "LineNr",
            }
        end,
    },
    -- NVIM-TREESITTER-CONTEXT (disabled)
    {
        "nvim-treesitter/nvim-treesitter-context",
        enabled = false,
        init = function()
            highlight.plugin("treesitter-context", {
                { ContextBorder = { link = "WinSeparator" } },
                { TreesitterContext = { inherit = "Normal" } },
                { TreesitterContextLineNumber = { inherit = "LineNr" } },
            })
        end,
        opts = {
            multiline_threshold = 4,
            separator = { "─", "ContextBorder" }, -- alternatives: ▁ ─ ▄
            mode = "cursor",
        },
    },
}
