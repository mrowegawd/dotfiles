local colorscheme = require("r.config").colorscheme

return {
  ---------------------------------------------------------------------------
  -- Consistent color
  ---------------------------------------------------------------------------
  -- NIGHT-OWL
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
