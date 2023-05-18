if not as.use_navigator_ray_x then
    return {}
end

-- NOTE: config lsp with navigator ray-x belum selesai (tak perlu terburu-buru)
-- Troubleshooting:
-- 1. fitur last edit disappear, setelah formatting kah? fix it?

-- local fn, fmt, icons = vim.fn, string.format,
local icons = as.ui.icons

return {
    { "yioneko/nvim-vtsls" },
    -- MASON
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        build = ":MasonUpdate",
    },
    -- LSPCONFIG
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
            {
                "folke/neodev.nvim",
                ft = "lua",
                opts = { library = { plugins = { "nvim-dap-ui" } } },
            },
        },
    },
    -- MASON-LSPCONFIG
    {
        "williamboman/mason-lspconfig.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
            "glepnir/lspsaga.nvim",
            "b0o/SchemaStore.nvim",
        },
        config = function()
            require("mason").setup()

            -- local servers = require("r.plugins.lsp.servers").servers

            local ensure_installed = {}

            -- for server, _ in pairs(servers) do
            --     ensure_installed[#ensure_installed + 1] = server
            -- end

            local mason_lspconfig = require "mason-lspconfig"

            mason_lspconfig.setup { ensure_installed = ensure_installed }
            mason_lspconfig.setup_handlers {}
            --
            --     -- Taken from https://www.reddit.com/r/neovim/comments/131l9cw/theres_another_typescript_lsp_that_wraps_the/
            --     -- better than `tsserver`?
            --     vtsls = function()
            --         require("lspconfig.configs").vtsls =
            --             require("vtsls").lspconfig
            --         require("lspconfig").vtsls.setup(
            --             require("r.plugins.lsp.servers").setup "vtsls"
            --         )
            --     end,
            --
            --     function(name)
            --         local config = require("r.plugins.lsp.servers").setup(name)
            --         if config then
            --             require("lspconfig")[name].setup(config)
            --         end
            --     end,
            -- }
        end,
    },
    -- NAVIGATOR
    {
        "ray-x/navigator.lua",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "ray-x/guihua.lua", build = { "cd lua/fzy && make" } },
        },
        config = function()
            local navigator = require "navigator"
            navigator.setup {
                debug = false, -- log output
                width = 0.75, -- value of cols
                height = 0.38, -- listview height
                preview_height = 0.38,
                preview_lines = 40, -- total lines in preview screen
                preview_lines_before = 5, -- lines before the highlight line
                default_mapping = false,
                keymaps = {
                    -- LSP
                    {
                        key = "gr",
                        func = require("navigator.reference").async_ref,
                        desc = "reference",
                    },
                    {
                        key = "K",
                        func = vim.lsp.buf.hover,
                        desc = "hover",
                    },
                    {
                        key = "gd",
                        func = require("navigator.definition").definition,
                        desc = "definition",
                    },
                    {
                        mode = "i",
                        key = "<c-s>",
                        func = vim.lsp.signature_help,
                        desc = "signature_help",
                    },
                    {
                        key = "g0",
                        func = require("navigator.symbols").document_symbols,
                        desc = "document_symbols",
                    },
                    {
                        key = "gW",
                        func = require("navigator.workspace").workspace_symbol_live,
                        desc = "workspace_symbol_live",
                    },
                    {
                        key = "gD",
                        func = vim.lsp.buf.declaration,
                        desc = "declaration",
                    },
                    {
                        key = "gt",
                        func = vim.lsp.buf.type_definition,
                        desc = "type_definition",
                    },
                    {
                        key = "gP",
                        func = require("navigator.definition").definition_preview,
                        desc = "definition_preview",
                    },

                    -- DIAGNOSTIC
                    {
                        key = "gL",
                        func = require("navigator.diagnostics").show_buf_diagnostics,
                        desc = "show_diagnostics",
                    },
                    {
                        key = "dp",
                        func = vim.diagnostic.goto_prev,
                        desc = "diagnostic prev",
                    },
                    {
                        key = "dn",
                        func = vim.diagnostic.goto_next,
                        desc = "diagnostic next",
                    },
                }, -- e.g keymaps={{key = "GR", func = vim.lsp.buf.references}, } this replace gr default mapping
                external = nil, -- true: enable for goneovim multigrid otherwise false

                border = "single", -- border style, can be one of 'none', 'single', 'double', "shadow"
                lines_show_prompt = 10, -- when the result list items number more than lines_show_prompt,
                -- fuzzy finder prompt will be shown
                combined_attach = "both", -- both: use both customized attach and navigator default attach, mine: only use my attach defined in vimrc
                -- on_attach = function(client, bufnr)
                --     -- your on_attach will be called at end of navigator on_attach
                -- end,
                ts_fold = false,
                treesitter_analysis = true, -- treesitter variable context
                treesitter_navigation = true, -- bool|table
                treesitter_analysis_max_num = 100, -- how many items to run treesitter analysis
                treesitter_analysis_condense = true, -- short format of function
                treesitter_analysis_depth = 3, -- max depth
                transparency = 0, -- 0 ~ 100 blur the main window, 100: fully transparent, 0: opaque,  set to nil to disable it
                lsp_signature_help = true, -- if you would like to hook ray-x/lsp_signature plugin in navigator
                -- setup here. if it is nil, navigator will not init signature help
                signature_help_cfg = { debug = false }, -- if you would like to init ray-x/lsp_signature plugin in navigator, pass in signature help
                ctags = {
                    cmd = "ctags",
                    tagfile = ".tags",
                    options = "-R --exclude=.git --exclude=node_modules --exclude=test --exclude=vendor --excmd=number",
                },
                lsp = {
                    enable = true, -- if disabled make sure add require('navigator.lspclient.mapping').setup() in you on_attach
                    code_action = {
                        delay = 3000, -- how long the virtual text will be shown
                        enable = true,
                        sign = true,
                        sign_priority = 40,
                        virtual_text = true,
                        virtual_text_icon = true,
                    },
                    rename = {
                        enable = true,
                        style = "floating-preview", -- 'floating' | 'floating-preview' | 'inplace-preview'
                        show_result = true,
                        confirm = "<S-CR>",
                        cancel = "<S-ESC>",
                    },
                    document_highlight = true, -- highlight reference a symbol
                    code_lens_action = {
                        enable = true,
                        sign = true,
                        sign_priority = 40,
                        virtual_text = true,
                        virtual_text_icon = true,
                    },
                    diagnostic = {
                        enable = true,
                        underline = true,
                        virtual_text = { spacing = 3, source = true }, -- show virtual for diagnostic message
                        update_in_insert = false, -- update diagnostic message in insert mode
                        severity_sort = { reverse = true },
                    },
                    definition = { enable = true },
                    call_hierarchy = { enable = true },
                    implementation = { enable = true },
                    workspace = { enable = true },
                    hover = {
                        enable = true,
                        keymaps = {
                            ["<C-k>"] = {
                                go = function()
                                    local w = vim.fn.expand "<cWORD>"
                                    w = w:gsub("*", "")
                                    vim.cmd("GoDoc " .. w)
                                end,
                                python = function()
                                    local w = vim.fn.expand "<cWORD>"
                                    local setup = {
                                        "pydoc",
                                        w,
                                    }
                                    return vim.fn.jobstart(setup, {
                                        on_stdout = function(_, data, _)
                                            if
                                                not data
                                                or (
                                                    #data == 1
                                                    and vim.fn.empty(
                                                            data[1]
                                                        )
                                                        == 1
                                                )
                                            then
                                                return
                                            end
                                            local close_events = {
                                                "CursorMoved",
                                                "CursorMovedI",
                                                "BufHidden",
                                                "InsertCharPre",
                                            }
                                            local config = {
                                                close_events = close_events,
                                                focusable = true,
                                                border = "single",
                                                width = 80,
                                                zindex = 100,
                                            }
                                            vim.lsp.util.open_floating_preview(
                                                data,
                                                "python",
                                                config
                                            )
                                        end,
                                    })
                                end,
                                default = function()
                                    local w = vim.fn.expand "<cword>"
                                    print("default " .. w)
                                    vim.lsp.buf.workspace_symbol(w)
                                end,
                            },
                        },
                    }, -- bind hover action to keymap; there are other options e.g. noice, lspsaga provides lsp hover

                    format_on_save = true, -- {true|false} set to false to disasble lsp code format on save (if you are using prettier/efm/formater etc)
                    -- table: {enable = {'lua', 'go'}, disable = {'javascript', 'typescript'}} to enable/disable specific language
                    -- enable: a whitelist of language that will be formatted on save
                    -- disable: a blacklist of language that will not be formatted on save
                    -- function: function(bufnr) return true end to enable/disable lsp format on save
                    format_options = { async = false }, -- async: disable by default, I saw something unexpected
                    disable_nulls_codeaction_sign = true, -- do not show nulls codeactions (as it will alway has a valid action)
                    disable_format_cap = {}, -- a list of lsp disable file format (e.g. if you using efm or vim-codeformat etc), empty by default
                    disable_lsp = {}, -- a list of lsp server disabled for your project, e.g. denols and tsserver you may
                    -- only want to enable one lsp server
                    display_diagnostic_qf = true, -- always show quickfix if there are diagnostic errors
                    diagnostic_load_files = false, -- lsp diagnostic errors list may contains uri that not opened yet set to true
                    -- to load those files
                    diagnostic_virtual_text = true, -- show virtual for diagnostic message
                    diagnostic_update_in_insert = false, -- update diagnostic message in insert mode
                    diagnostic_scrollbar_sign = { "▃", "▆", "█" }, -- set to nil to disable, set to {'╍', 'ﮆ'} to enable diagnostic status in scroll bar area
                    tsserver = {
                        -- filetypes = {'typescript'} -- disable javascript etc,
                        -- set to {} to disable the lspclient for all filetype
                    },
                    neodev = false,
                    lua_ls = {
                        -- sumneko_root_path = sumneko_root_path,
                        -- sumneko_binary = sumneko_binary,
                        -- cmd = {'lua-language-server'}
                    },
                    servers = {}, -- you can add additional lsp server so navigator will load the default for you
                },
                mason = true, -- set to true if you would like use the lsp installed by williamboman/mason
                mason_disabled_for = {}, -- disable mason for specified lspclients
                icons = {
                    icons = true, -- set to false to use system default ( if you using a terminal does not have nerd/icon)
                    -- Code action
                    code_action_icon = "🏏", -- "",
                    -- code lens
                    code_lens_action_icon = "👓",
                    -- Diagnostics
                    diagnostic_head = "🐛",
                    diagnostic_err = icons.diagnostics.error,
                    diagnostic_warn = icons.diagnostics.warn,
                    diagnostic_info = [[👩]],
                    diagnostic_hint = [[💁]],

                    diagnostic_head_severity_1 = "🈲",
                    diagnostic_head_severity_2 = "☣️",
                    diagnostic_head_severity_3 = "👎",
                    diagnostic_head_description = "👹",
                    diagnostic_virtual_text = "🦊",
                    diagnostic_file = "🚑",
                    -- Values
                    value_changed = "📝",
                    value_definition = "🐶🍡", -- it is easier to see than 🦕
                    side_panel = {
                        section_separator = "",
                        line_num_left = "",
                        line_num_right = "",
                        inner_node = "├○",
                        outer_node = "╰○",
                        bracket_left = "⟪",
                        bracket_right = "⟫",
                    },
                    -- Treesitter
                    match_kinds = {
                        var = " ", -- "👹", -- Vampaire
                        method = "ƒ ", --  "🍔", -- mac
                        ["function"] = " ", -- "🤣", -- Fun
                        parameter = "  ", -- Pi
                        associated = "🤝",
                        namespace = "🚀",
                        type = " ",
                        field = "🏈",
                        module = "📦",
                        flag = "🎏",
                    },
                    treesitter_defult = "🌲",
                    doc_symbols = "",
                },
            }
        end,
    },
    -- NULL-LS
    {
        "jay-babu/mason-null-ls.nvim", -- Automatically install null-ls servers
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "nvim-lua/plenary.nvim",
            "jose-elias-alvarez/null-ls.nvim",
            -- "LostNeophyte/null-ls-embedded", -- error deprecated warn (treesitter)
        },

        config = function()
            local nls = require "null-ls"
            nls.setup {
                debounce = 150,
                save_after_format = false,
                sources = {

                    -- Lua
                    nls.builtins.formatting.stylua,
                    -- nls.builtins.diagnostics.luacheck,

                    -- JSON
                    -- nls.builtins.formatting.fixjson.with({ filetypes = { "jsonc" } }),

                    -- SH / Bash shell
                    nls.builtins.formatting.shfmt,
                    -- nls.builtins.diagnostics.shellcheck,

                    -- Fish shell
                    -- nls.builtins.formatting.fish_indent,

                    -- Markdown
                    nls.builtins.diagnostics.markdownlint,

                    -- Js / Typescript
                    -- nls.builtins.formatting.prettierd.with {
                    --     filetypes = { "markdown" }, -- only runs `deno fmt` for markdown
                    -- },
                    nls.builtins.formatting.prettierd,
                    -- nls.builtins.formatting.eslint_d,

                    -- Selene
                    -- nls.builtins.diagnostics.selene.with {
                    --     condition = function(utils)
                    --         return utils.root_has_file { "selene.toml" }
                    --     end,
                    -- },

                    -- GIT stuff
                    -- nls.builtins.code_actions.gitsigns,

                    -- PYTHON
                    nls.builtins.formatting.isort,
                    nls.builtins.formatting.black,
                    nls.builtins.diagnostics.flake8,

                    -- NOTE: error dengan warning deprecated treesitter
                    -- require("null-ls-embedded").nls_source.with {
                    --     filetypes = { "norg", "org", "markdown", "md" },
                    -- },

                    nls.builtins.formatting.trim_whitespace.with {
                        filetypes = { "norg", "org", "markdown", "md" },
                    },

                    nls.builtins.formatting.trim_newlines.with {
                        filetypes = { "norg", "org", "markdown", "md" },
                    },

                    -- nls.builtins.hover.dictionary,
                },
                -- on_attach = options.on_attach,
                root_dir = require("null-ls.utils").root_pattern(
                    ".null-ls-root",
                    ".neoconf.json",
                    ".git"
                ),
            }

            require("mason-null-ls").setup {
                automatic_installation = true,
                automatic_setup = true,
            }
        end,
    },
    -- AERIAL
    {
        "stevearc/aerial.nvim",
        event = "VeryLazy",
        -- cmd = "AerialToggle",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("aerial").setup {
                attach_mode = "global",
                backends = { "lsp", "treesitter", "markdown", "man" },
                layout = { min_width = 28 },

                show_guides = true,
                manage_folds = false,
                guides = {
                    mid_item = "├ ",
                    last_item = "└ ",
                    nested_top = "│ ",
                    whitespace = "  ",
                },
                filter_kind = false,

                keymaps = {
                    ["[y"] = "actions.prev",
                    ["O"] = "actions.jump",
                    ["o"] = false,
                    ["]y"] = "actions.next",
                    ["[Y"] = "actions.prev_up",
                    ["]Y"] = "actions.next_up",
                    ["{"] = false,
                    ["}"] = false,
                    ["[["] = false,
                    ["]]"] = false,
                },
            }
        end,
    },
    -- TROUBLE
    {
        "folke/trouble.nvim",
        cmd = { "TroubleToggle", "Trouble" },
        init = function()
            require("legendary").keymaps {
                {
                    itemgroup = "Todo Trouble",
                    description = "Searching trouble!",
                    icon = as.ui.icons.misc.tag,
                    keymaps = {

                        {
                            "<Leader>tt",
                            "<CMD>TroubleToggle<CR>",
                            description = "Trouble: toggle",
                        },
                    },
                },
            }
        end,
        config = function()
            require("trouble").setup {
                auto_open = false,
                use_diagnostic_signs = true, -- en
                action_keys = {
                    -- map to {} to remove a mapping, for example:
                    -- close = {},
                    close = "q", -- close the list
                    cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
                    refresh = "r", -- manually refresh
                    jump = { "<cr>", "<tab>" }, -- jump to the diagnostic or open / close folds
                    open_split = { "<c-s>" }, -- open buffer in new split
                    open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
                    open_tab = { "<c-t>" }, -- open buffer in new tab
                    jump_close = { "o" }, -- jump to the diagnostic and close the list
                    toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
                    toggle_preview = "P", -- toggle auto_preview
                    hover = "K", -- opens a small popup with the full multiline message
                    preview = "p", -- preview the diagnostic location
                    close_folds = { "zM", "zm" }, -- close all folds
                    open_folds = { "zR", "zr" }, -- open all folds
                    toggle_fold = { "zA", "za" }, -- toggle fold of current file
                    previous = "k", -- previous item
                    next = "j", -- next item
                },
            }
        end,
    },
}
