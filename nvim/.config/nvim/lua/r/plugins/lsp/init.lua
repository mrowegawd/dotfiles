if as.use_navigator_ray_x then
    return {}
end

local highlight = as.highlight

local fn, fmt, icons, cmd = vim.fn, string.format, as.ui.icons, vim.cmd

local set_icons = function(icons_name)
    return icons_name .. " "
end

return {
    -- NVIM-VTSLS (js/ts server)
    { "yioneko/nvim-vtsls" },
    -- GUIHUA
    { "ray-x/guihua.lua", build = { "cd lua/fzy && make" } },
    -- MASON
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        build = ":MasonUpdate",
    },
    -- NVIM-LSPCONFIG
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

            local servers = require("r.plugins.lsp.servers").servers

            local ensure_installed = {}

            for server, _ in pairs(servers) do
                ensure_installed[#ensure_installed + 1] = server
            end

            local mason_lspconfig = require "mason-lspconfig"

            mason_lspconfig.setup { ensure_installed = ensure_installed }
            mason_lspconfig.setup_handlers {

                -- Taken from https://www.reddit.com/r/neovim/comments/131l9cw/theres_another_typescript_lsp_that_wraps_the/
                -- better than `tsserver`?
                vtsls = function()
                    require("lspconfig.configs").vtsls =
                        require("vtsls").lspconfig
                    require("lspconfig").vtsls.setup(
                        require("r.plugins.lsp.servers").setup "vtsls"
                    )
                end,

                function(name)
                    local config = require("r.plugins.lsp.servers").setup(name)
                    if config then
                        require("lspconfig")[name].setup(config)
                    end
                end,
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
            local diagnostics = nls.builtins.diagnostics

            -- Ruff settings
            local ruff_severities = {
                ["E"] = vim.diagnostic.severity.ERROR,
                ["F8"] = vim.diagnostic.severity.ERROR,
                ["F"] = vim.diagnostic.severity.WARN,
                ["W"] = vim.diagnostic.severity.WARN,
                ["D"] = vim.diagnostic.severity.INFO,
                ["B"] = vim.diagnostic.severity.INFO,
            }
            local ruff = diagnostics.ruff.with {
                diagnostics_postprocess = function(diagnostic)
                    local code = string.sub(diagnostic.code, 1, 2)
                    if code ~= "F8" then
                        code = string.sub(code, 1, 1)
                    end
                    local new_severity = ruff_severities[code]
                    if new_severity then
                        diagnostic.severity = new_severity
                    end
                end,
            }

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
                    -- nls.builtins.diagnostics.flake8,
                    nls.builtins.diagnostics.pylint,
                    ruff,
                    nls.builtins.formatting.isort,
                    nls.builtins.formatting.black,

                    -- NOTE: ini error dengan warning deprecated treesitter di neorg
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
    -- LSP-INLAYHINTS
    {
        "lvimuser/lsp-inlayhints.nvim",
        dependencies = "neovim/nvim-lspconfig",
        init = function()
            as.augroup("InlayHintsSetup", {
                event = "LspAttach",
                command = function(args)
                    local id = vim.tbl_get(args, "data", "client_id")
                    if not id then
                        return
                    end
                    local client = vim.lsp.get_client_by_id(id)
                    require("lsp-inlayhints").on_attach(client, args.buf)
                end,
            })
        end,
        opts = {
            inlay_hints = {
                highlight = "Comment",
                labels_separator = " ⏐ ",
                parameter_hints = { prefix = "" },
                type_hints = { prefix = "=> ", remove_colon_start = true },
            },
        },
    },
    -- TROUBLE.NVIM (disabled)
    {
        "folke/trouble.nvim",
        enabled = false,
        cmd = { "TroubleToggle", "Trouble" },
        init = function()
            require("legendary").keymaps {
                {
                    itemgroup = "LSP",
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
                    close = { "q", "<leader><Tab>" }, -- close the list
                    cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
                    refresh = "r", -- manually refresh
                    jump = "<tab>", -- jump to the diagnostic or open / close folds
                    open_split = { "<c-s>" }, -- open buffer in new split
                    open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
                    open_tab = { "<c-t>" }, -- open buffer in new tab
                    jump_close = { "o", "<cr>" }, -- jump to the diagnostic and close the list
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
    -- LSPSAGA
    {
        "glepnir/lspsaga.nvim",
        event = "VeryLazy",
        enabled = function()
            if as.use_search_telescope then
                return true
            end
            return false
        end,
        init = function()
            require("legendary").keymaps {
                {
                    itemgroup = "Misc",
                    keymaps = {
                        {
                            "gO",
                            "<CMD>Lspsaga outline<CR>",
                            description = "Outline: Lspsaga",
                        },
                    },
                },
            }
        end,
        dependencies = {
            { "nvim-tree/nvim-web-devicons" },
            { "nvim-treesitter/nvim-treesitter" },
        },
        config = function()
            -- NOTE: lspsaga kadang error highlight NormalFloat bg nya hilang,
            -- kyk issue ini: https://github.com/nvimdev/lspsaga.nvim/issues/1049
            -- tapi bakal di refactor ulang sama author nya, check berkala ya!

            local lspsaga = require "lspsaga"

            lspsaga.setup {
                ui = {
                    border = "single",
                    title = true,
                    winblend = 0,
                    expand = "",
                    collapse = "",
                    code_action = "💡",
                    incoming = " ",
                    outgoing = " ",
                    actionfix = " ",
                    hover = " ",
                    theme = "arrow",
                    lines = { "┗", "┣", "┃", "━" },
                    kind = {},
                },
                diagnostic = {
                    on_insert = false,
                    insert_winblend = 0,
                    show_code_action = true,
                    show_source = true,
                    jump_num_shortcut = true,
                    max_width = 0.7,
                    max_height = 0.6,
                    max_show_width = 0.9,
                    max_show_height = 0.6,
                    text_hl_follow = false,
                    border_follow = true,
                    extend_relatedInformation = false,
                    keys = {
                        exec_action = "o",
                        quit = "q",
                        expand_or_jump = "<CR>",
                        quit_in_show = { "q", "<ESC>" },
                    },
                },
                code_action = {
                    num_shortcut = true,
                    show_server_name = false,
                    extend_gitsigns = false,
                    keys = {
                        quit = "q",
                        exec = "<CR>",
                    },
                },
                lightbulb = {
                    enable = false,
                    enable_in_insert = true,
                    sign = true,
                    sign_priority = 40,
                    virtual_text = true,
                },
                preview = {
                    lines_above = 0,
                    lines_below = 10,
                },
                scroll_preview = {
                    scroll_down = "<C-d>",
                    scroll_up = "<C-u>",
                },
                request_timeout = 2000,
                finder = {
                    max_height = 0.5,
                    min_width = 30,
                    force_max_height = false,
                    keys = {
                        jump_to = "p",
                        edit = { "o", "<CR>" },
                        vsplit = "<c-v>",
                        split = "<c-s>",
                        tabe = "<c-t>",
                        quit = {
                            "q",
                            "<ESC>",
                            "<leader><TAB>",
                            "<c-l>",
                            "<c-h>",
                        },
                        close_in_preview = "<ESC>",
                    },
                },
                definition = {
                    width = 0.6,
                    height = 0.5,
                    edit = "o",
                    vsplit = "<C-v>",
                    split = "<C-s>",
                    tabe = "<C-t>",
                    quit = "q",
                },
                rename = {
                    quit = "<C-c>",
                    exec = "<CR>",
                    mark = "x",
                    confirm = "<CR>",
                    in_select = true,
                },
                symbol_in_winbar = {
                    enable = false,
                    ignore_patterns = {},
                    separator = " ",
                    hide_keyword = true,
                    show_file = true,
                    folder_level = 2,
                    respect_root = false,
                    color_mode = true,
                },
                outline = {
                    win_position = "right",
                    win_with = "",
                    win_width = 30,
                    auto_preview = true,
                    auto_refresh = true,
                    auto_close = true,
                    custom_sort = nil,
                    preview_width = 0.4,
                    close_after_jump = false,
                    keys = {
                        expand_or_jump = "o",
                        quit = "q",
                    },
                },
                callhierarchy = {
                    show_detail = false,
                    keys = {
                        edit = "e",
                        vsplit = "s",
                        split = "i",
                        tabe = "t",
                        jump = "o",
                        quit = "q",
                        expand_collapse = "u",
                    },
                },
                beacon = {
                    enable = true,
                    frequency = 7,
                },
                server_filetype_map = {},
            }

            highlight.plugin("lspsagaHiCustom", {
                { SagaBorder = { link = "DiffAdd" } },
                { SagaNormal = { link = "Pmenu" } },
            })
        end,
    },
    -- GLANCE (disabled)
    {
        "DNLHC/glance.nvim",
        cmd = { "Glance" },
        enabled = false,
        opts = function()
            local actions = require("glance").actions
            return {
                -- height = 18, -- Height of the window
                -- zindex = 100,

                preview_win_opts = { relativenumber = false, wrap = false },
                theme = { enable = true, mode = "darken" },
                folds = {
                    fold_closed = "",
                    fold_open = "",
                    folded = true, -- Automatically fold list on startup
                },
                -- Taken from https://github.com/DNLHC/glance.nvim#hooks
                -- Don't open glance when there is only one result and it is
                -- located in the current buffer, open otherwise
                hooks = {
                    ---@diagnostic disable-next-line: unused-local
                    before_open = function(results, open, jump, method)
                        local uri = vim.uri_from_bufnr(0)
                        if #results == 1 then
                            local target_uri = results[1].uri
                                or results[1].targetUri

                            if target_uri == uri then
                                jump(results[1])
                            else
                                open(results)
                            end
                        else
                            open(results)
                        end
                    end,
                },
                mappings = {
                    list = {
                        ["<C-u>"] = actions.preview_scroll_win(5),
                        ["<C-d>"] = actions.preview_scroll_win(-5),
                        ["<c-v>"] = actions.jump_vsplit,
                        ["<c-s>"] = actions.jump_split,
                        ["<c-t>"] = actions.jump_tab,
                        ["<c-n>"] = actions.next_location,
                        ["<c-p>"] = actions.previous_location,
                        ["h"] = actions.close_fold,
                        ["l"] = actions.open_fold,
                        ["p"] = actions.enter_win "preview",
                        ["<C-l>"] = "",
                        ["<C-h>"] = "",
                        ["<C-j>"] = "",
                        ["<C-k>"] = "",
                    },
                    preview = {
                        ["q"] = actions.close,
                        ["p"] = actions.enter_win "list",
                        ["<c-n>"] = actions.next_location,
                        ["<c-p>"] = actions.previous_location,
                        ["C-l"] = "",
                        ["<C-h>"] = "",
                        ["<C-j>"] = "",
                        ["<C-k>"] = "",
                    },
                },
            }
        end,
    },
    -- AERIAL
    {
        "stevearc/aerial.nvim",
        event = "VeryLazy",
        enabled = false,
        init = function()
            require("r.utils").disable_ctrl_i_and_o("NoAerial", { "aerial" })

            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "aerial" },
                callback = function()
                    vim.keymap.set("n", "zM", function()
                        local aerial = require "aerial"
                        return aerial.tree_close_all()
                    end, {
                        buffer = vim.api.nvim_get_current_buf(),
                    })
                    vim.keymap.set("n", "zO", function()
                        local aerial = require "aerial"
                        return aerial.tree_open_all()
                    end, {
                        buffer = vim.api.nvim_get_current_buf(),
                    })
                end,
            })

            require("legendary").keymaps {
                {
                    itemgroup = "LSP",
                    keymaps = {
                        {
                            "go",
                            "<CMD>AerialToggle<CR>",
                            description = "Aerial: toggle",
                        },
                        {
                            "gO",
                            function()
                                require("r.utils.tiling").force_win_close(
                                    { "Outline" },
                                    false
                                )
                                return cmd.AerialToggle()
                            end,
                            description = "Aerial: focus toggle",
                        },
                    },
                },
            }
        end,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("aerial").setup {
                attach_mode = "global",
                backends = { "lsp", "treesitter", "markdown", "man" },
                layout = { min_width = 28 },
                -- fold code from tree (overwrites treesitter foldexpr)
                manage_folds = false,
                -- link_tree_to_folds = true,
                -- link_folds_to_tree = true,
                show_guides = true,
                guides = {
                    -- mid_item = "├ ",
                    -- last_item = "└ ",
                    -- nested_top = "│ ",
                    -- whitespace = "  ",
                    mid_item = " ",
                    last_item = " ",
                    nested_top = " ",
                    whitespace = " ",
                },
                filter_kind = false,
                icons = {
                    Array = icons.kind.Array,
                    Boolean = icons.kind.Boolean,
                    Class = icons.kind.Class,
                    Constant = icons.kind.Constant,
                    Constructor = icons.kind.Constructor,
                    Enum = icons.kind.Enum,
                    EnumMember = icons.kind.EnumMember,
                    Event = icons.kind.Event,
                    Field = icons.kind.Field,
                    File = icons.kind.File,
                    Function = icons.kind.Function,
                    Interface = icons.kind.Interface,
                    Key = icons.kind.Keyword,
                    Method = icons.kind.Method,
                    Module = icons.kind.Module,
                    Namespace = icons.kind.Namespace,
                    Null = icons.kind.Null,
                    Number = icons.kind.Number,
                    Object = icons.kind.Object,
                    Operator = icons.kind.Operator,
                    Package = icons.kind.Package,
                    Property = icons.kind.Property,
                    String = icons.kind.String,
                    Struct = icons.kind.Struct,
                    TypeParameter = icons.kind.TypeParameter,
                    Variable = icons.kind.Variable,
                    Collapsed = " ",
                },

                keymaps = {
                    ["[y"] = "actions.prev",
                    ["O"] = "actions.jump",
                    ["o"] = "actions.jump",
                    ["]y"] = "actions.next",
                    ["[Y"] = "actions.prev_up",
                    ["]Y"] = "actions.next_up",
                    ["{"] = false,
                    ["}"] = false,
                    ["[["] = false,
                    ["]]"] = false,
                    ["zM"] = false,
                    ["zO"] = false,
                },
            }
        end,
    },
    -- SYMBOLSOUTLINE
    {
        "enddeadroyal/symbols-outline.nvim",
        enabled = false,
        cmd = "SymbolsOutline",
        branch = "bugfix/symbol-hover-misplacement",
        init = function()
            require("r.utils").disable_ctrl_i_and_o("NoOutline", { "Outline" })

            -- require("legendary").keymaps {
            --     {
            --         itemgroup = "LSP",
            --         keymaps = {
            --             {
            --                 "go",
            --                 "<CMD>SymbolsOutline<CR>",
            --                 description = "SymbolsOutline: toggle",
            --             },
            --             {
            --                 "gO",
            --                 function()
            --                     require("r.utils.tiling").force_win_close(
            --                         { "Outline" },
            --                         false
            --                     )
            --                     return cmd.SymbolsOutline()
            --                 end,
            --                 description = "SymbolsOutline: focus toggle",
            --             },
            --         },
            --     },
            -- }
        end,
        config = function()
            require("symbols-outline").setup {
                highlight_hovered_item = true,
                show_guides = false,
                position = "right",
                border = "single",
                relative_width = true,
                width = 30,
                auto_close = false,
                auto_preview = false,
                show_numbers = false,
                show_relative_numbers = false,
                show_symbol_details = true,
                preview_bg_highlight = "Pmenu",
                winblend = 0,
                autofold_depth = nil,
                auto_unfold_hover = false,
                fold_markers = { "", "" },
                wrap = false,
                keymaps = { -- These keymaps can be a string or a table for multiple keys
                    close = { "<Esc>", "q", "<leader><TAB>" },
                    goto_location = "<Cr>",
                    focus_location = "o",
                    hover_symbol = "<C-space>",
                    toggle_preview = "P",
                    rename_symbol = "r",
                    code_actions = "a",
                    show_help = "?",
                    fold = "h",
                    unfold = "l",
                    fold_all = "zM",
                    unfold_all = "zO",
                    fold_reset = "R",
                },
                lsp_blacklist = {},
                symbol_blacklist = {},
                symbols = {
                    Module = { icon = icons.kind.Module, hl = "@namespace" },

                    Class = { icon = icons.kind.Class, hl = "@type" },
                    Method = { icon = icons.kind.Method, hl = "@method" },
                    Property = { icon = icons.kind.Property, hl = "@method" },
                    Field = { icon = icons.kind.Field, hl = "@field" },
                    Constructor = {
                        icon = icons.kind.Constructor,
                        hl = "@constructor",
                    },
                    Enum = { icon = icons.kind.Enum, hl = "@type" },
                    Interface = { icon = icons.kind.Interface, hl = "@type" },
                    Function = { icon = icons.kind.Function, hl = "@function" },
                    Variable = { icon = icons.kind.Variable, hl = "@constant" },
                    Constant = { icon = icons.kind.Constant, hl = "@constant" },
                    String = { icon = icons.kind.String, hl = "@string" },
                    Number = { icon = icons.kind.Number, hl = "@number" },
                    Boolean = { icon = icons.kind.Boolean, hl = "@boolean" },
                    Array = { icon = icons.kind.Array, hl = "@constant" },
                    Object = { icon = icons.kind.Object, hl = "@type" },
                    Key = { icon = icons.kind.Keyword, hl = "@type" },
                    EnumMember = { icon = icons.kind.EnumMember, hl = "@field" },
                    Struct = { icon = icons.kind.Struct, hl = "@type" },
                    Event = { icon = icons.kind.Event, hl = "@type" },
                    Operator = { icon = icons.kind.Operator, hl = "@operator" },

                    Null = { icon = icons.kind.Null, hl = "@type" },
                    File = { icon = icons.kind.File, hl = "@text.uri" },
                    Namespace = {
                        icon = icons.kind.Namespace,
                        hl = "@namespace",
                    },
                    Package = { icon = icons.kind.Package, hl = "@namespace" },
                    TypeParameter = {
                        icon = icons.kind.TypeParameter,
                        hl = "@parameter",
                    },
                    Component = {
                        icon = icons.kind.Component,
                        hl = "@function",
                    },
                    Fragment = { icon = icons.kind.Fragment, hl = "@constant" },
                },
            }
        end,
    },
    -- DROPBAR
    {
        "Bekaboo/dropbar.nvim",
        enabled = true,
        event = "BufRead",
        init = function()
            require("legendary").keymaps {
                {
                    itemgroup = "LSP",
                    keymaps = {
                        {
                            "go",
                            function()
                                return require("dropbar.api").pick()
                            end,
                            description = "Dropbar: pick",
                        },
                    },
                },
            }
        end,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("dropbar").setup {
                general = {
                    enable = function(buf, win)
                        local fname = vim.api.nvim_buf_get_name(
                            vim.api.nvim_get_current_buf()
                        )
                        if fname:match "orgagenda" then
                            return false
                        end

                        return not vim.api.nvim_win_get_config(win).zindex
                            and vim.bo[buf].buftype == ""
                            and vim.api.nvim_buf_get_name(buf) ~= ""
                            and not vim.wo[win].diff
                    end,
                    update_events = {
                        win = {
                            "CursorMoved",
                            "CursorMovedI",
                            "WinEnter",
                            "WinLeave",
                            "WinResized",
                            "WinScrolled",
                        },
                        buf = {
                            "BufModifiedSet",
                            "FileChangedShellPost",
                            "TextChanged",
                            "TextChangedI",
                        },
                        global = {
                            "DirChanged",
                            "VimResized",
                        },
                    },
                },
                icons = {
                    kinds = {
                        use_devicons = true,
                        symbols = {
                            Array = set_icons(icons.kind.Array),
                            Boolean = set_icons(icons.kind.Boolean),
                            BreakStatement = "󰙧 ",
                            Call = "󰃷 ",
                            CaseStatement = "󱃙 ",
                            Class = set_icons(icons.kind.Class),
                            Color = " ",
                            Constant = set_icons(icons.kind.Constant),
                            Constructor = set_icons(icons.kind.Constructor),
                            ContinueStatement = "→ ",
                            Copilot = " ",
                            Declaration = "󰙠 ",
                            Delete = "󰩺 ",
                            DoStatement = "󰑖 ",
                            Enum = set_icons(icons.kind.Enum),
                            EnumMember = set_icons(icons.kind.Enum),
                            Event = set_icons(icons.kind.Event),
                            Field = set_icons(icons.kind.Field),
                            File = set_icons(icons.kind.File),
                            Folder = set_icons(icons.kind.Folder),
                            ForStatement = "󰑖 ",
                            Function = set_icons(icons.kind.Function),
                            Identifier = "󰀫 ",
                            IfStatement = "󰇉 ",
                            Interface = set_icons(icons.kind.Interface),
                            Keyword = set_icons(icons.kind.Keyword),
                            List = " ",
                            og = "󰦪 ",
                            Lsp = " ",
                            Macro = "󰁌 ",
                            MarkdownH1 = "󰉫 ",
                            MarkdownH2 = "󰉬 ",
                            MarkdownH3 = "󰉭 ",
                            MarkdownH4 = "󰉮 ",
                            MarkdownH5 = "󰉯 ",
                            MarkdownH6 = "󰉰 ",
                            Method = set_icons(icons.kind.Method),
                            Module = set_icons(icons.kind.Module),
                            Namespace = set_icons(icons.kind.Namespace),
                            Null = set_icons(icons.kind.Null),
                            Number = set_icons(icons.kind.Number),
                            Object = set_icons(icons.kind.Object),
                            Operator = set_icons(icons.kind.Operator),
                            Package = set_icons(icons.kind.Package),
                            Property = set_icons(icons.kind.Property),
                            Reference = set_icons(icons.kind.Reference),
                            Regex = " ",
                            Repeat = "󰑖 ",
                            Scope = " ",
                            Snippet = "󰩫 ",
                            Specifier = "󰦪 ",
                            Statement = " ",
                            String = set_icons(icons.kind.String),
                            Struct = set_icons(icons.kind.Struct),
                            SwitchStatement = "󰺟 ",
                            Text = set_icons(icons.kind.Text),
                            Type = " ",
                            TypeParameter = " ",
                            Unit = set_icons(icons.kind.Unit),
                            Value = set_icons(icons.kind.Value),
                            Variable = set_icons(icons.kind.Variable),
                            WhileStatement = "󰑖 ",
                        },
                    },
                    ui = {
                        bar = {
                            separator = set_icons(icons.misc.arrow_right),
                            extends = "…",
                        },
                        menu = {
                            separator = " ",
                            indicator = " ",
                        },
                    },
                },
                bar = {
                    sources = function(_, _)
                        local sources = require "dropbar.sources"

                        local function get_hl_color(group, attr)
                            return vim.fn.synIDattr(
                                vim.fn.synIDtrans(vim.fn.hlID(group)),
                                attr
                            )
                        end

                        local get_symbols = function(buf, cursor, symbols)
                            local path = false
                            if symbols == nil then
                                symbols = sources.path.get_symbols(buf, cursor)
                                path = true
                            end
                            for _, symbol in ipairs(symbols) do
                                -- get correct icon color
                                local icon_fg =
                                    get_hl_color(symbol.icon_hl, "fg#")
                                symbol.icon_hl = "DropbarSymbol"
                                    .. symbol.icon_hl

                                -- set name highlight
                                if not path then
                                    symbol.name_hl = symbol.icon_hl
                                end

                                local icon_string = ""
                                if icon_fg == "" then
                                    icon_string = "hi "
                                        .. symbol.icon_hl
                                        .. " guisp=#665c54 gui=underline guibg=NONE"
                                else
                                    icon_string = "hi "
                                        .. symbol.icon_hl
                                        .. " guisp=#665c54 gui=underline guibg=NONE guifg="
                                        .. icon_fg
                                end

                                vim.cmd(icon_string)
                            end
                            return symbols
                        end
                        return {
                            sources.path,
                            {
                                get_symbols = function(buf, win, cursor)
                                    if vim.bo[buf].ft == "markdown" then
                                        return sources.markdown.get_symbols(
                                            buf,
                                            win,
                                            cursor
                                        )
                                    end
                                    for _, source in ipairs {
                                        sources.lsp,
                                        sources.treesitter,
                                    } do
                                        -- local symbols =
                                        --     source.get_symbols(buf, win, cursor)
                                        -- if not vim.tbl_isempty(symbols) then
                                        --     return symbols
                                        -- end

                                        return get_symbols(
                                            buf,
                                            cursor,
                                            source.get_symbols(buf, win, cursor)
                                        )
                                    end
                                    return {}
                                end,
                            },
                        }
                    end,
                    padding = {
                        left = 1,
                        right = 1,
                    },
                    pick = {
                        pivots = "abcdefghijklmnopqrstuvwxyz",
                    },
                    truncate = true,
                },
                menu = {
                    -- When on, preview the symbol under the cursor on CursorMoved
                    preview = false,
                    -- When on, automatically set the cursor to the closest previous/next
                    -- clickable component in the direction of cursor movement on CursorMoved
                    quick_navigation = true,
                    entry = {
                        padding = {
                            left = 1,
                            right = 1,
                        },
                    },
                    ---@type table<string, string|function|table<string, string|function>>
                    keymaps = {
                        ["<LeftMouse>"] = function()
                            local api = require "dropbar.api"
                            local menu = api.get_current_dropbar_menu()
                            if not menu then
                                return
                            end
                            local mouse = vim.fn.getmousepos()
                            if mouse.winid ~= menu.win then
                                local parent_menu =
                                    api.get_dropbar_menu(mouse.winid)
                                if parent_menu and parent_menu.sub_menu then
                                    parent_menu.sub_menu:close()
                                end
                                if vim.api.nvim_win_is_valid(mouse.winid) then
                                    vim.api.nvim_set_current_win(mouse.winid)
                                end
                                return
                            end
                            menu:click_at(
                                { mouse.line, mouse.column },
                                nil,
                                1,
                                "l"
                            )
                        end,
                        ["<CR>"] = function()
                            local menu =
                                require("dropbar.api").get_current_dropbar_menu()
                            if not menu then
                                return
                            end
                            local cursor = vim.api.nvim_win_get_cursor(menu.win)
                            local component =
                                menu.entries[cursor[1]]:first_clickable(
                                    cursor[2]
                                )
                            if component then
                                menu:click_on(component, nil, 1, "l")
                            end
                        end,
                        ["<c-c>"] = function()
                            local api = require "dropbar.api"
                            local menu = api.get_current_dropbar_menu()
                            if not menu then
                                return
                            end
                            vim.cmd "q"
                        end,
                        ["<esc>"] = function()
                            local api = require "dropbar.api"
                            local menu = api.get_current_dropbar_menu()
                            if not menu then
                                return
                            end
                            vim.cmd "q"
                        end,
                        ["l"] = function()
                            local menu =
                                require("dropbar.api").get_current_dropbar_menu()
                            if not menu then
                                return
                            end
                            local cursor = vim.api.nvim_win_get_cursor(menu.win)
                            local component =
                                menu.entries[cursor[1]]:first_clickable(
                                    cursor[2]
                                )
                            if component then
                                vim.cmd "silent noautocmd update"
                                menu:click_on(component, nil, 1, "l")
                            end
                        end,
                        ["h"] = function()
                            local menu =
                                require("dropbar.api").get_current_dropbar_menu()
                            if not menu then
                                return
                            end
                            vim.cmd "q"
                        end,
                        ["P"] = function()
                            local menu =
                                require("dropbar.api").get_current_dropbar_menu()
                            if not menu then
                                return
                            end

                            -- vim.notify "not yet implemented"

                            local cursor = vim.api.nvim_win_get_cursor(menu.win)
                            local component =
                                menu.entries[cursor[1]]:first_clickable(
                                    cursor[2]
                                )

                            local row = component.entry.idx
                            local col = component.entry.padding.left + 1

                            col = col
                                + component:bytewidth()
                                + component.entry.separator:bytewidth()

                            print(tostring(row) .. " " .. tostring(col))
                            print(vim.inspect(component))
                        end,
                    },
                },
                sources = {
                    path = {
                        ---@type string|fun(buf: integer): string
                        relative_to = function(_)
                            return vim.fn.getcwd()
                        end,
                        ---Can be used to filter out files or directories
                        ---based on their name
                        ---@type fun(name: string): boolean
                        filter = function(_)
                            return true
                        end,
                    },
                    treesitter = {
                        -- Lua pattern used to extract a short name from the node text
                        -- Be aware that the match result must not be nil!
                        name_pattern = string.rep("[#~%w%._%->!]*", 4, "%s*"),
                        -- The order matters! The first match is used as the type
                        -- of the treesitter symbol and used to show the icon
                        -- Types listed below must have corresponding icons
                        -- in the `icons.kinds.symbols` table for the icon to be shown
                        valid_types = {
                            "array",
                            "boolean",
                            "break_statement",
                            "call",
                            "case_statement",
                            "class",
                            "constant",
                            "constructor",
                            "continue_statement",
                            "delete",
                            "do_statement",
                            "enum",
                            "enum_member",
                            "event",
                            "for_statement",
                            "function",
                            "if_statement",
                            "interface",
                            "keyword",
                            "list",
                            "macro",
                            "method",
                            "module",
                            "namespace",
                            "null",
                            "number",
                            "operator",
                            "package",
                            "property",
                            "reference",
                            "repeat",
                            "scope",
                            "specifier",
                            "string",
                            "struct",
                            "switch_statement",
                            "type",
                            "type_parameter",
                            "unit",
                            "value",
                            "variable",
                            "while_statement",
                            "declaration",
                            "field",
                            "identifier",
                            "object",
                            "statement",
                            "text",
                        },
                    },
                    lsp = {
                        request = {
                            -- Times to retry a request before giving up
                            ttl_init = 60,
                            interval = 1000, -- in ms
                        },
                    },
                    markdown = {
                        parse = {
                            -- Number of lines to update when cursor moves out of the parsed range
                            look_ahead = 200,
                        },
                    },
                },
            }
        end,
    },
    -- INCRENAME
    {
        "smjonas/inc-rename.nvim",
        enabled = false,
        opts = { hl_group = "Visual", preview_empty_name = true },
        keys = {
            {
                "<leader>gR",
                function()
                    return fmt(":IncRename %s", fn.expand "<cword>")
                end,
                expr = true,
                silent = false,
                desc = "lsp: incremental rename",
            },
        },
    },
    -- ILLUMINATE
    {
        "RRethy/vim-illuminate",
        event = "BufReadPost",
        opts = { delay = 200 },
        init = function()
            require("legendary").keymaps {
                {
                    itemgroup = "FZFLua",
                    keymaps = {
                        {
                            "<a-q>",
                            function()
                                require("illuminate").goto_next_reference(nil)
                            end,
                            description = "Lsp: Hi Symbol",
                        },
                        {
                            "<a-Q>",
                            function()
                                require("illuminate").goto_prev_reference(nil)
                            end,
                            description = "Lsp: Hi Symbol",
                        },
                    },
                },
            }
        end,
        config = function()
            require("illuminate").configure {
                filetypes_denylist = {
                    "NeogitStatus",
                    "Outline",
                    "TelescopePrompt",
                    "Trouble",
                    "alpha",
                    "dirvish",
                    "fugitive",
                    "gitcommit",
                    "lazy",
                    "neo-tree",
                    "orgagenda",
                    "qf",
                },
            }
        end,
    },
}
