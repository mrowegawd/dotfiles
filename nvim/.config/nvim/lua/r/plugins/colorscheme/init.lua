-- local highlight = as.high:Wight

return {
    ---------------------------------------------------------------------------
    -- Consistent color
    ---------------------------------------------------------------------------
    -- DOOM-ONE
    {
        "NTBBloodbath/doom-one.nvim",
        lazy = false,

        enabled = function()
            if as.colorscheme == "doom-one" then
                return true
            end
            return false
        end,
        init = function()
            vim.g.doom_one_cursor_coloring = false
            -- Set :terminal colors
            vim.g.doom_one_terminal_colors = true
            -- Enable italic comments
            vim.g.doom_one_italic_comments = true
            -- Enable TS support
            vim.g.doom_one_enable_treesitter = true
            -- Color whole diagnostic text or only underline
            vim.g.doom_one_diagnostics_text_color = false
            -- Enable transparent background
            vim.g.doom_one_transparent_background = false

            -- Pumblend transparency
            vim.g.doom_one_pumblend_enable = false
            vim.g.doom_one_pumblend_transparency = 20

            -- Plugins integration
            vim.g.doom_one_plugin_neorg = true
            vim.g.doom_one_plugin_barbar = false
            vim.g.doom_one_plugin_telescope = true
            vim.g.doom_one_plugin_neogit = true
            vim.g.doom_one_plugin_nvim_tree = true
            vim.g.doom_one_plugin_dashboard = true
            vim.g.doom_one_plugin_startify = true
            vim.g.doom_one_plugin_whichkey = true
            vim.g.doom_one_plugin_indent_blankline = true
            vim.g.doom_one_plugin_vim_illuminate = true
            vim.g.doom_one_plugin_lspsaga = true
        end,
    },
    -- GRUVBOX
    {
        "ellisonleao/gruvbox.nvim",
        lazy = false,
        priority = 1000,
        enabled = function()
            if as.colorscheme == "gruvbox" then
                return true
            end
            return false
        end,
        init = function()
            vim.o.background = "dark"
        end,
        config = function()
            require("gruvbox").setup {
                overrides = {
                    GruvboxGreenSign = { bg = "NONE" },
                    GruvboxRedSign = { bg = "NONE" },
                    GruvboxYellowSign = { bg = "NONE" },
                    GruvboxAquaSign = { bg = "NONE" },
                    GruvboxBlueSign = { bg = "NONE" },
                },
            }
        end,
    },
    -- GRUVBOX-MATERIAL
    {
        "sainnhe/gruvbox-material",
        lazy = false,
        init = function()
            vim.g.gruvbox_material_background = "hard"
        end,
        enabled = function()
            if as.colorscheme == "gruvbox-material" then
                return true
            end
            return false
        end,
    },
    -- KANAGAWA
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        name = "kanagawa",
        enabled = function()
            if as.colorscheme == "kanagawa" then
                return true
            end
            return false
        end,
        init = function() end,
        opts = {
            compile = false, -- enable compiling the colorscheme
            undercurl = true, -- enable undercurls
            commentStyle = { italic = true },
            functionStyle = {},
            keywordStyle = { italic = true },
            statementStyle = { bold = true },
            typeStyle = {},
            transparent = false, -- do not set background color
            dimInactive = false, -- dim inactive window `:h hl-NormalNC`
            terminalColors = true, -- define vim.g.terminal_color_{0,17}
            theme = "wave", -- Load "wave" theme when 'background' option is not set
            -- background = { -- map the value of 'background' option to a theme
            --     dark = "lotus", -- try "dragon" !
            --     light = "lotus",
            -- },
        },
        config = function(_, opts)
            local kanagawa = require "kanagawa"
            kanagawa.setup(opts)
        end,
    },
    -- MATERIAL
    {
        "marko-cerovac/material.nvim",
        lazy = false,
        enabled = function()
            if as.colorscheme == "material" then
                return true
            end
            return false
        end,
        init = function()
            vim.g.material_style = "darker"
        end,
        config = function()
            local material = require "material"

            material.setup {
                contrast = {
                    terminal = false, -- Enable contrast for the built-in terminal
                    sidebars = false, -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
                    floating_windows = false, -- Enable contrast for floating windows
                    cursor_line = false, -- Enable darker background for the cursor line
                    non_current_windows = false, -- Enable darker background for non-current windows
                    filetypes = {}, -- Specify which filetypes get the contrasted (darker) background
                },

                styles = { -- Give comments style such as bold, italic, underline etc.
                    comments = { italic = true },
                    strings = { --[[ bold = true ]]
                    },
                    keywords = { --[[ underline = true ]]
                    },
                    functions = { bold = true },
                    variables = {},
                    operators = {},
                    types = {},
                },

                plugins = { -- Uncomment the plugins that you use to highlight them
                    "dap",
                    "gitsigns",
                    "indent-blankline",
                    "neogit",
                    "nvim-tree",
                    -- "telescope",
                    "trouble",
                    -- "dashboard",
                    -- "hop",
                    -- "lspsaga",
                    -- "mini",
                    -- "nvim-cmp",
                    -- "nvim-navic",
                    -- "sneak",
                    -- "which-key",
                    -- Available plugins:
                },

                disable = {
                    colored_cursor = false, -- Disable the colored cursor
                    borders = false, -- Disable borders between verticaly split windows
                    background = false, -- Prevent the theme from setting the background (NeoVim then uses your terminal background)
                    term_colors = false, -- Prevent the theme from setting terminal colors
                    eob_lines = false, -- Hide the end-of-buffer lines
                },

                high_visibility = {
                    lighter = true, -- Enable higher contrast text for lighter style
                    darker = false, -- Enable higher contrast text for darker style
                },

                lualine_style = "default", -- Lualine style ( can be 'stealth' or 'default' )
                async_loading = true, -- Load parts of the theme asyncronously for faster startup (turned on by default)
                custom_colors = nil, -- If you want to everride the default colors, set this to a function
                custom_highlights = {
                    -- Basic
                    WinSeparator = { fg = "#343434", bg = "NONE" },
                    Pmenu = { bg = "#171717" },
                    -- PmenuThumb = { bg = "#B0BEC5" },
                    NormalFloat = { bg = "#171717" },
                    -- -- FloatBorder = { bg = "#191919" },
                    PmenuSel = { bg = "#640202", fg = "NONE" },
                    -- CmpItemAbbrMatch = { fg = "#1a1a1a", bg = "NONE" },

                    -- QuickFixLine = { bg = "#640202", fg = "NONE" },
                    --
                    -- -- Telescope
                    -- TelescopeNormal = { bg = "#191919" },
                    -- TelescopePromptBorder = { bg = "#191919" },
                    -- TelescopePromptPrefix = { bg = "#191919" },
                    -- TelescopePromptCounter = { bg = "NONE" },
                    -- TelescopeSelection = { bg = "#640202", fg = "NONE" },
                    -- TelescopeMatching = { bg = "NONE", fg = "#ffe779" },
                    -- TelescopeSelectionCaret = { bg = "#191919" },
                }, -- Overwrite highlights with your own
            }
        end,
    },
    -- CATPPUCCIN
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        -- priority = 1000,
        enabled = function()
            if
                as.colorscheme == "catppuccin"
                or as.colorscheme == "catppuccin-latte"
            then
                return true
            end

            return false
        end,
        config = function()
            require("catppuccin").setup {
                flavour = "mocha", -- latte, frappe, macchiato, mocha
                background = { -- :h background
                    light = "latte",
                    dark = "mocha",
                },
                transparent_background = false,
                show_end_of_buffer = false, -- show the '~' characters after the end of buffers
                term_colors = false,
                dim_inactive = {
                    enabled = false,
                    shade = "dark",
                    percentage = 0.15,
                },
                no_italic = false, -- Force no italic
                no_bold = false, -- Force no bold
                -- no_underline = false,
                styles = {
                    comments = { "italic" },
                    conditionals = { "italic" },
                    loops = {},
                    functions = {},
                    keywords = {},
                    strings = {},
                    variables = {},
                    numbers = {},
                    booleans = {},
                    properties = {},
                    types = {},
                    operators = {},
                },
                color_overrides = {},
                -- custom_highlights = function(col)
                --     return {
                --         TelescopeMatching = { fg = "#ffffc7", bg = "NONE" },
                --         -- ["@constant.builtin"] = {
                --         --     fg = col.peach,
                --         --     style = {},
                --         -- },
                --         -- ["@comment"] = {
                --         --     fg = col.surface2,
                --         --     style = { "italic" },
                --         -- },
                --     }
                -- end,
                integrations = {
                    cmp = false,
                    gitsigns = true,
                    nvimtree = true,
                    telescope = true,
                    notify = false,
                    mini = false,
                    -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
                    native_lsp = {
                        enabled = true,
                        virtual_text = {
                            errors = { "italic" },
                            hints = { "italic" },
                            warnings = { "italic" },
                            information = { "italic" },
                        },
                        underlines = {
                            errors = { "undercurl" },
                            hints = { "undercurl" },
                            warnings = { "undercurl" },
                            information = { "undercurl" },
                        },
                    },
                },
            }
        end,
    },
    -- TOKYONIGHT
    {
        "folke/tokyonight.nvim",
        name = "tokyonight",
        lazy = false,

        enabled = function()
            if as.colorscheme == "tokyonight" then
                return true
            end
            return false
        end,
        config = function()
            local tokyonight = require "tokyonight"
            tokyonight.setup {
                style = "storm",
                -- priority = 1000,
                sidebars = {
                    --     "qf",
                    --     "vista_kind",
                    --     "terminal",
                    --     -- "packer",
                    --     "spectre_panel",
                    "NeogitStatus",
                    --     -- "help",
                    --     "startuptime",
                    --     "Outline",
                },
                styles = {
                    -- Style to be applied to different syntax groups
                    -- Value is any valid attr-list value for `:help nvim_set_hl`
                    comments = { italic = true },
                    -- keywords = { italic = true },
                    functions = {},
                    variables = {},
                    -- Background styles. Can be "dark", "transparent" or "normal"
                    -- sidebars = "dark", -- style for sidebars, see below
                    -- floats = "dark", -- style for floating windows
                },
                transparent = false, -- true
                -- on_highlights = function(hl, c)
                -- hl.WinSeparator = {
                --     fg = "#626262",
                --     bg = "#222638",
                -- }

                -- make the current line cursor orange
                -- hl.CursorLineNr = { fg = c.orange, bold = true }

                -- Taken from readme tokyonight, 'borderless telescope'
                -- local prompt = "#2d3149"
                -- hl.TelescopeNormal = {
                --     bg = c.bg_dark,
                --     fg = c.fg_dark,
                -- }
                -- hl.TelescopeBorder = {
                --     bg = c.bg_dark,
                --     fg = c.bg_dark,
                -- }
                -- hl.TelescopePromptNormal = {
                --     bg = prompt,
                -- }
                -- hl.TelescopePromptBorder = {
                --     bg = prompt,
                --     fg = prompt,
                -- }
                -- hl.TelescopePromptTitle = {
                --     bg = c.fg_gutter,
                --     fg = c.orange,
                -- }
                -- hl.TelescopePreviewTitle = {
                --     bg = c.bg_dark,
                --     fg = c.bg_dark,
                -- }
                -- hl.TelescopeResultsTitle = {
                --     bg = c.bg_dark,
                --     fg = c.bg_dark,
                -- }
                -- end,
            }

            tokyonight.load()
        end,
    },
    ---------------------------------------------------------------------------
    -- Not recommended colorscheme
    ---------------------------------------------------------------------------
    -- OXOCARBON
    { "shaunsingh/oxocarbon.nvim", lazy = false, enabled = true },
    -- KYNTELL
    {
        "romgrk/kyntell.vim",
        lazy = false,
        enabled = function()
            if as.colorscheme == "kyntell" then
                return true
            end
            return false
        end,
    },
}
