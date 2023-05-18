if as.use_navigator_ray_x then
    return {}
end

local highlight = as.highlight

local fn, fmt, icons, cmd = vim.fn, string.format, as.ui.icons, vim.cmd

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
    -- NVIM-NAVIC
    {
        "SmiteshP/nvim-navic", -- show winbar
        enabled = false,
        opts = function()
            require("nvim-navic").setup {
                highlight = false,
                -- icons = require("lspkind").symbol_map,
                -- depth_limit_indicator = ui.icons.misc.ellipsis,
                lsp = { auto_attach = true },
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
    -- TROUBLE.NVIM
    {
        "folke/trouble.nvim",
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
    -- NVIM-NAVBUDDY (disabled)
    {
        "SmiteshP/nvim-navbuddy",
        event = "BufReadPre",
        enabled = false,
        init = function()
            require("legendary").keymaps {
                {
                    itemgroup = "LSP",
                    keymaps = {
                        {
                            "gO",
                            "<CMD>Navbuddy<CR>",
                            description = "Navbuddy: open",
                        },
                    },
                },
            }
        end,
        dependencies = {
            "neovim/nvim-lspconfig",
            "SmiteshP/nvim-navic",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            local navbuddy = require "nvim-navbuddy"
            local actions = require "nvim-navbuddy.actions"
            navbuddy.setup {
                window = {
                    border = "single", -- "rounded", "double", "solid", "none"
                    -- or an array with eight chars building up the border in a clockwise fashion
                    -- starting with the top-left corner. eg: { "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" }.
                    size = { height = "50%", width = "90%" }, -- Or table format example: { height = "40%", width = "100%"}
                    position = "50%", -- Or table format example: { row = "100%", col = "0%"}
                    scrolloff = nil, -- scrolloff value within navbuddy window
                    sections = {
                        left = {
                            size = "20%",
                            border = nil, -- You can set border style for each section individually as well.
                        },
                        mid = {
                            size = "40%",
                            border = nil,
                        },
                        right = {
                            -- No size option for right most section. It fills to
                            -- remaining area.
                            border = nil,
                            preview = "leaf", -- Right section can show previews too.
                            -- Options: "leaf", "always" or "never"
                        },
                    },
                },
                node_markers = {
                    enabled = true,
                    icons = {
                        leaf = "  ",
                        leaf_selected = " → ",
                        branch = " ",
                    },
                },
                icons = {
                    [1] = " ", -- File
                    [2] = " ", -- Module
                    [3] = " ", -- Namespace
                    [4] = " ", -- Package
                    [5] = " ", -- Class
                    [6] = " ", -- Method
                    [7] = " ", -- Property
                    [8] = " ", -- Field
                    [9] = " ", -- Constructor
                    [10] = "練", -- Enum
                    [11] = "練", -- Interface
                    [12] = " ", -- Function
                    [13] = " ", -- Variable
                    [14] = " ", -- Constant
                    [15] = " ", -- String
                    [16] = " ", -- Number
                    [17] = "◩ ", -- Boolean
                    [18] = " ", -- Array
                    [19] = " ", -- Object
                    [20] = " ", -- Key
                    [21] = "ﳠ ", -- Null
                    [22] = " ", -- EnumMember
                    [23] = " ", -- Struct
                    [24] = " ", -- Event
                    [25] = " ", -- Operator
                    [26] = " ", -- TypeParameter
                    [255] = " ", -- Macro
                },
                use_default_mappings = true, -- If set to false, only mappings set
                -- by user are set. Else default
                -- mappings are used for keys
                -- that are not set by user
                mappings = {
                    ["<esc>"] = actions.close, -- Close and cursor to original location
                    ["q"] = actions.close,

                    ["j"] = actions.next_sibling, -- down
                    ["k"] = actions.previous_sibling, -- up

                    ["h"] = actions.parent, -- Move to left panel
                    ["l"] = actions.children, -- Move to right panel
                    ["0"] = actions.root, -- Move to first panel

                    ["v"] = actions.visual_name, -- Visual selection of name
                    ["V"] = actions.visual_scope, -- Visual selection of scope

                    ["y"] = actions.yank_name, -- Yank the name to system clipboard "+
                    ["Y"] = actions.yank_scope, -- Yank the scope to system clipboard "+

                    ["i"] = actions.insert_name, -- Insert at start of name
                    ["I"] = actions.insert_scope, -- Insert at start of scope

                    ["a"] = actions.append_name, -- Insert at end of name
                    ["A"] = actions.append_scope, -- Insert at end of scope

                    ["r"] = actions.rename, -- Rename currently focused symbol

                    ["d"] = actions.delete, -- Delete scope

                    ["f"] = actions.fold_create, -- Create fold of current scope
                    ["F"] = actions.fold_delete, -- Delete fold of current scope

                    ["c"] = actions.comment, -- Comment out current scope

                    ["<enter>"] = actions.select, -- Goto selected symbol
                    ["o"] = actions.select,

                    ["J"] = actions.move_down, -- Move focused node down
                    ["K"] = actions.move_up, -- Move focused node up

                    ["t"] = actions.telescope { -- Fuzzy finder at current level.
                        layout_config = {
                            -- All options that can be
                            height = 0.60, -- passed to telescope.nvim's
                            width = 0.60, -- default can be passed here.
                            prompt_position = "top",
                            preview_width = 0.50,
                        },
                        -- theme = "ivy",
                        -- layout_strategy = "vertical",
                    },
                },
                lsp = {
                    auto_attach = true, -- If set to true, you don't need to manually use attach function
                    preference = nil, -- list of lsp server names in order of preference
                },
                source_buffer = {
                    follow_node = true, -- Keep the current node in focus on the source buffer
                    highlight = true, -- Highlight the currently focused node
                    reorient = "smart", -- "smart", "top", "mid" or "none"
                    scrolloff = nil, -- scrolloff value when navbuddy is open
                },
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
    -- SYMBOLSOUTLINE
    {
        "enddeadroyal/symbols-outline.nvim",
        enabled = function()
            if as.use_search_telescope then
                return false
            end
            return true
        end,
        cmd = "SymbolsOutline",
        branch = "bugfix/symbol-hover-misplacement",
        init = function()
            require("r.utils").disable_ctrl_i_and_o("NoOutline", { "Outline" })

            require("legendary").keymaps {
                {
                    itemgroup = "LSP",
                    keymaps = {
                        {
                            "go",
                            "<CMD>SymbolsOutline<CR>",
                            description = "SymbolsOutline: toggle",
                        },
                        {
                            "gO",
                            function()
                                require("r.utils.tiling").force_win_close(
                                    { "Outline" },
                                    false
                                )
                                return cmd.SymbolsOutline()
                            end,
                            description = "SymbolsOutline: focus toggle",
                        },
                    },
                },
            }
        end,
        config = function()
            require("symbols-outline").setup {
                highlight_hovered_item = true,
                show_guides = false,
                position = "right",
                border = "single",
                relative_width = true,
                width = 25,
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
    -- INCRENAME
    {
        "smjonas/inc-rename.nvim",
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
}
