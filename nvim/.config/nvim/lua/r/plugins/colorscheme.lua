local colorscheme = require("r.config").colorscheme

return {
  ---------------------------------------------------------------------------
  -- Consistent color
  ---------------------------------------------------------------------------
  {
    "oxfist/night-owl.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    enabled = function()
      local mintheme = { "night-owl" }
      if vim.tbl_contains(mintheme, colorscheme) then
        return true
      end
      return false
    end,
    opts = {},
  },
  -- CARET.NVIM
  {
    "projekt0n/caret.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    enabled = function()
      if colorscheme == "caret" then
        return true
      end
      return false
    end,
    config = function()
      require("caret").setup {}
    end,
  },
  -- DOOM-ONE
  {
    "NTBBloodbath/doom-one.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    enabled = function()
      if colorscheme == "doom-one" then
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
  -- MIN-THEME
  {
    "datsfilipe/min-theme.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    enabled = function()
      local mintheme = { "min-theme" }
      if vim.tbl_contains(mintheme, colorscheme) then
        return true
      end
      return false
    end,
    config = function()
      require("min-theme").setup {
        theme = "dark", -- String: 'dark' or 'light', determines the colorscheme used (obs: if your config sets vim.o.background, this will do nothing)
        transparent = false, -- Boolean: Sets the background to transparent
        italics = {
          comments = true, -- Boolean: Italicizes comments
          keywords = true, -- Boolean: Italicizes keywords
          functions = true, -- Boolean: Italicizes functions
          strings = true, -- Boolean: Italicizes strings
          variables = true, -- Boolean: Italicizes variables
        },
        -- overrides = {}, -- A dictionary of group names, can be a function returning a dictionary or a table.
      }
    end,
  },
  -- SOLARIZED
  {
    "maxmx03/solarized.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    enabled = function()
      local solarized = { "solarized" }
      if vim.tbl_contains(solarized, colorscheme) then
        return true
      end
      return false
    end,
    config = function()
      require("solarized").setup()
    end,
  },
  -- DARCUBOX
  {
    "dotsilas/darcubox-nvim",
    enabled = function()
      local colordarcubox = { "darcubox" }
      if vim.tbl_contains(colordarcubox, colorscheme) then
        return true
      end
      return false
    end,
    config = true,
  },
  -- MIASMA
  {
    "xero/miasma.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local colormiasma = { "miasma" }
      if vim.tbl_contains(colormiasma, colorscheme) then
        return true
      end
      return false
    end,
  },
  -- GITHUB-NVIM-THEME
  {
    "projekt0n/github-nvim-theme",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    enabled = function()
      local colorgithub = { "github_dark_dimmed", "github_dark", "github_dark_high_contrast" }
      if vim.tbl_contains(colorgithub, colorscheme) then
        return true
      end
      return false
    end,
    config = function()
      require("github-theme").setup {}
    end,
  },
  -- GRUVBOX
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      if colorscheme == "gruvbox" then
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
  -- DARCULA-DARK
  {
    "xiantang/darcula-dark.nvim",
    lazy = false,
    priority = 1000,
    requires = { "nvim-treesitter/nvim-treesitter" },
    enabled = function()
      local colordarkuladark = { "darcula-dark" }
      if vim.tbl_contains(colordarkuladark, colorscheme) then
        return true
      end
      return false
    end,
  },
  -- EVERFOREST
  {
    "neanias/everforest-nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local coloreverforest = { "everforest" }
      if vim.tbl_contains(coloreverforest, colorscheme) then
        return true
      end
      return false
    end,
    config = function()
      require("everforest").setup {}
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
      if colorscheme == "gruvbox-material" then
        return true
      end
      return false
    end,
  },
  -- KANAGAWA
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      if colorscheme == "kanagawa" then
        return true
      end
      return false
    end,
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
      theme = "dragon", -- Load "wave" theme when 'background' option is not set
      background = { -- map the value of 'background' option to a theme
        dark = "dragon", -- try "dragon" !
        -- light = "lotus",
      },
      -- overrides = function(colors)
      --   local theme = colors.theme
      --   return {
      --     -- TreesitterContextSeparator = { fg = { from = "Normal", attr = "bg", alter = -0.1 } },
      --     -- Folded = { fg = { from = "Normal", attr = "bg", alter = -0.1 } },
      --     Folded = { link = "Directory" },
      --     -- NormalFloat = { bg = "none" },
      --     -- FloatBorder = { bg = "none" },
      --     -- FloatTitle = { bg = "none" },
      --   }
      -- end,
    },
  },
  -- MATERIAL
  {
    "marko-cerovac/material.nvim",
    lazy = false,
    enabled = function()
      local colormaterial = { "material-darker", "material-oceanic", "material" }
      if vim.tbl_contains(colormaterial, colorscheme) then
        return true
      end
      return false
    end,
    init = function() end,
    config = function()
      vim.g.material_style = "darker"

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
        -- custom_highlights = {
        -- Basic
        -- WinSeparator = { fg = "#343434", bg = "NONE" },
        -- Pmenu = { bg = "#171717" },
        -- PmenuThumb = { bg = "#B0BEC5" },
        -- NormalFloat = { bg = "#171717" },
        -- -- FloatBorder = { bg = "#191919" },
        -- PmenuSel = { bg = "#640202", fg = "NONE" },
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
        -- }, -- Overwrite highlights with your own
      }
    end,
  },
  -- CATPPUCCIN
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    enabled = function()
      local colorscattppuccin = { "catppuccin", "catppuccin-latte" }
      if vim.tbl_contains(colorscattppuccin, colorscheme) then
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
      local colorstokyonight = { "tokyonight", "tokyonight-night" }
      if vim.tbl_contains(colorstokyonight, colorscheme) then
        return true
      end
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
          comments = { italic = true },
          functions = {},
          variables = {},
        },
        transparent = false, -- true
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
      if colorscheme == "kyntell" then
        return true
      end
      return false
    end,
  },
}
