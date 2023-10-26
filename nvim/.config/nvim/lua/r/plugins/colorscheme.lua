local colorscheme = require("r.config").colorscheme

return {
  ---------------------------------------------------------------------------
  -- Consistent color
  ---------------------------------------------------------------------------
  -- NANO-THEME
  {
    "ronisbr/nano-theme.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    enabled = function()
      local nanotheme = { "nano-theme" }
      if vim.tbl_contains(nanotheme, colorscheme) then
        return true
      end
      return false
    end,
    init = function()
      vim.o.background = "light" -- or "dark".
    end,
  },
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
      vim.g.gruvbox_material_background = "medium"
      vim.g.gruvbox_material_better_performance = 1
    end,
    enabled = function()
      if colorscheme == "gruvbox-material" then
        return true
      end
      return false
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
        dim_inactive = false, -- dims inactive windows
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
