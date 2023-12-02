local colorscheme = require("r.config").colorscheme

return {
  -- BAMBOO.NVIM
  {
    "ribru17/bamboo.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local bambootheme = { "bamboo" }
      if vim.tbl_contains(bambootheme, colorscheme) then
        return true
      end
      return false
    end,
    opts = {},
  },
  -- FLESH-AND-BLOOD
  {
    "sainttttt/flesh-and-blood",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    enabled = function()
      local fleshtheme = { "flesh-and-blood", "hybrid" }
      if vim.tbl_contains(fleshtheme, colorscheme) then
        return true
      end
      return false
    end,
    opts = {},
  },
  -- SOLARIZED-OSAKA
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local solarizedosaka = { "solarized-osaka" }
      if vim.tbl_contains(solarizedosaka, colorscheme) then
        return true
      end
      return false
    end,
    opts = {
      transparent = false, -- Enable this to disable setting the background color
      terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
      style = "storm", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
      styles = {
        -- Style to be applied to different syntax groups
        -- Value is any valid attr-list value for `:help nvim_set_hl`
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        -- Background styles. Can be "dark", "transparent" or "normal"
        sidebars = "dark", -- style for sidebars, see below
        floats = "dark", -- style for floating windows
      },
      sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
      day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
      hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
      dim_inactive = false, -- dims inactive windows
      lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold
      on_highlights = function(highlights, _)
        local hl = require "r.config.highlights"
        highlights.Normal = {
          bg = hl.tint(highlights.Normal.bg, 0.76),
          fg = highlights.Normal.fg,
        }
        highlights.helpCommand = {
          bg = "NONE",
        }
      end,
    },
  },
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
      require("everforest").setup {
        background = "medium",
      }
    end,
  },
  -- NIGHTFOX.NVIM
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local nightfoxtheme = { "dawnfox", "terafox" }
      if vim.tbl_contains(nightfoxtheme, colorscheme) then
        return true
      end
      return false
    end,
    opts = function()
      return {
        styles = { -- Style to be applied to different syntax groups
          comments = "italic", -- Value is any valid attr-list value `:help attr-list`
          -- conditionals = "NONE",
          -- constants = "NONE",
          -- functions = "NONE",
          keywords = "bold",
          -- numbers = "NONE",
          -- operators = "NONE",
          -- strings = "NONE",
          types = "italic,bold",
          -- variables = "NONE",
        },
      }
    end,
  },
  -- SEOUL256
  {
    "junegunn/seoul256.vim",
    lazy = false,
    priority = 1000,
    -- init = function()
    --   vim.g.seoul256_background = 256
    -- end,
    enabled = function()
      local seoul256theme = { "seoul256" }
      if vim.tbl_contains(seoul256theme, colorscheme) then
        return true
      end
      return false
    end,
  },
  -- GRUVBOX.NVIM
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local gruvboxtheme = { "gruvbox" }
      if vim.tbl_contains(gruvboxtheme, colorscheme) then
        return true
      end
      return false
    end,
    opts = {},
  },
  -- TOKYONIGHT
  {
    "folke/tokyonight.nvim",
    name = "tokyonight",
    lazy = false,
    priority = 1000,
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
          -- functions = { italic = true },
          -- variables = { italic = true },
        },
        dim_inactive = false, -- dims inactive windows
        transparent = false, -- true
      }

      tokyonight.load()
    end,
  },
  -- ONEDARK.NVIM
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local onedarktheme = { "onedark" }
      if vim.tbl_contains(onedarktheme, colorscheme) then
        return true
      end
    end,
    opts = {
      style = "warmer",
    },
  },
  -- OXOCARBON
  {
    "shaunsingh/oxocarbon.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local oxocarbontheme = { "oxocarbon" }
      if vim.tbl_contains(oxocarbontheme, colorscheme) then
        return true
      end
    end,
  },
}
