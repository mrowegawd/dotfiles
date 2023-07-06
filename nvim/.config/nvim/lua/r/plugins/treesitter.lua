local highlight = as.highlight

return {
    -- TREESITTER
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        dependencies = {
            { "nvim-treesitter/nvim-treesitter-textobjects" },
            { "JoosepAlviste/nvim-ts-context-commentstring" },
            {
                "windwp/nvim-ts-autotag",
                ft = {
                    "typescriptreact",
                    "javascript",
                    "javascriptreact",
                    "html",
                    "tsx",
                    "vue",
                },
                config = function()
                    require("nvim-ts-autotag").setup()
                end,
            },
            { "HiPhish/nvim-ts-rainbow2" },
            { "mfussenegger/nvim-treehopper" },
            -- { "David-Kunz/markid" },
        },
        opts = function()
            -- local queries = require "nvim-treesitter.query"
            -- local parsers = require "nvim-treesitter.parsers"
            local disable_max_size = 2000000 -- 2MB

            local function should_disable(_, bufnr)
                local size =
                    vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr or 0))
                -- size will be -2 if it doesn't fit into a number
                if size > disable_max_size or size == -2 then
                    return true
                end
                return false
            end

            return {
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
                    "graphql",
                    "html",
                    "http",
                    "java",
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
                    "query",
                    "regex",

                    "scss",
                    "sql",
                    "svelte",
                    "teal",
                    "vhs",
                    "vim",
                    "vue",
                    "ruby",
                    "wgsl",
                    "yaml",
                    "json",
                },

                auto_install = true,
                highlight = {
                    enable = true,
                    disable = function(_, bufnr)
                        return vim.api.nvim_buf_line_count(bufnr) > 10000
                    end,
                    additional_vim_regex_highlighting = {
                        "orgmode",
                        "org",
                        "markdown",
                    },
                },

                indent = {
                    enable = true,
                    disable = function(lang, bufnr)
                        -- if
                        --     vim.tbl_contains({ "python", "org" }, vim.bo.buftype)
                        -- then -- or lang == "python" then
                        --     return true
                        -- else
                        return should_disable(lang, bufnr)
                        -- end
                    end,
                },
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
                    enable = false, -- TODO: nanti di check ini
                    keymaps = {
                        init_selection = ";gn",
                        node_incremental = ";gi",
                        scope_incremental = ";gs",
                        node_decremental = ";gr",
                    },
                },

                -- vim-matchup
                -- matchup = {
                --     enable = true, -- mandatory, false will disable the whole extension
                --     disable = { "c", "ruby", "orgagenda" }, -- optional, list of language that will be disabled
                --     -- [options]
                -- },

                rainbow = {
                    enable = true,
                    extended_mode = true,
                    -- disable = { "tsx", "jsx", "html", "lua" },
                    -- query = { "rainbow-parens" },
                    -- strategy = require("ts-rainbow").strategy.global,
                },

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

                autotag = {
                    enable = true,
                },

                -- nvim-treesitter-textobjects
                textobjects = {
                    select = {
                        enable = true,
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
        end,
        config = function(_, opts)
            local ok, orgmode = pcall(require, "orgmode")
            if ok then
                orgmode.setup_ts_grammar()
            end

            require("nvim-treesitter.configs").setup(opts)

            vim.keymap.set(
                { "o", "x" },
                "m",
                [[:<C-U>lua require('tsht').nodes()<CR>]],
                { desc = "Treesitter: jump nodes" }
            )

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

            -- local function set_ts_win_defaults()
            --     local parser_name = parsers.get_buf_lang()
            --     if
            --         parsers.has_parser(parser_name)
            --         and not should_disable(parser_name, 0)
            --     then
            --         local oky, has_folds =
            --             pcall(queries.get_query, parser_name, "folds")
            --         if
            --             oky and has_folds
            --             -- and vim.api.nvim_win_get_config(0).relative == ""
            --         then
            --             if vim.wo.foldmethod == "manual" then
            --                 vim.api.nvim_win_set_var(
            --                     0,
            --                     "ts_prev_foldmethod",
            --                     vim.wo.foldmethod
            --                 )
            --                 vim.api.nvim_win_set_var(
            --                     0,
            --                     "ts_prev_foldexpr",
            --                     vim.wo.foldexpr
            --                 )
            --                 vim.wo.foldmethod = "expr"
            --                 vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
            --             end
            --             return
            --         end
            --     end
            --     if vim.wo.foldexpr == "nvim_treesitter#foldexpr()" then
            --         local ok, prev_foldmethod =
            --             pcall(vim.api.nvim_win_get_var, 0, "ts_prev_foldmethod")
            --         if ok and prev_foldmethod then
            --             vim.api.nvim_win_del_var(0, "ts_prev_foldmethod")
            --             vim.wo.foldmethod = prev_foldmethod
            --         end
            --         local ok2, prev_foldexpr =
            --             pcall(vim.api.nvim_win_get_var, 0, "ts_prev_foldexpr")
            --         if ok2 and prev_foldexpr then
            --             vim.api.nvim_win_del_var(0, "ts_prev_foldexpr")
            --             vim.wo.foldexpr = prev_foldexpr
            --         end
            --     end
            -- end
            --
            -- local aug = vim.api.nvim_create_augroup("moxTSConfig", {})
            -- vim.api.nvim_create_autocmd(
            --     { "WinEnter", "BufWinEnter", "BufReadPre" },
            --     {
            --         desc = "Set treesitter defaults on win enter",
            --         pattern = "*",
            --         callback = set_ts_win_defaults,
            --         group = aug,
            --     }
            -- )
        end,
    },
    -- PLAYGROUND
    {
        "nvim-treesitter/playground",
        cmd = { "TSPlaygroundToggle" },
        dependencies = { "nvim-treesitter" },
    },
    -- NVIM-AUTOPAIRS
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        dependencies = { "hrsh7th/nvim-cmp" },
        config = function()
            local npairs = require "nvim-autopairs"
            local cmp_autopairs = require "nvim-autopairs.completion.cmp"
            require("cmp").event:on(
                "confirm_done",
                cmp_autopairs.on_confirm_done { map_char = { tex = "" } }
            )
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
                    "vim",
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
