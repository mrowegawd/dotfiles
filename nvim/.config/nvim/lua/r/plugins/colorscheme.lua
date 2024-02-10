local colorscheme = require("r.config").colorscheme
local Config = require("r.config").defaults

return {
  -- VSCODE_MODERN_THEME
  {
    "gmr458/vscode_modern_theme.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local vscode_modern_theme = { "vscode_modern" }
      if vim.tbl_contains(vscode_modern_theme, colorscheme) then
        return true
      end
      return false
    end,
    config = function()
      require("vscode_modern").setup {
        cursorline = true,
        transparent_background = false,
        nvim_tree_darker = true,
      }
    end,
  },
  -- KANAGAWA
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local kanagawatheme = { "kanagawa" }
      if vim.tbl_contains(kanagawatheme, colorscheme) then
        return true
      end
      return false
    end,
  },
  -- SELENIZED
  {
    "calind/selenized.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local selenizedtheme = { "selenized" }
      if vim.tbl_contains(selenizedtheme, colorscheme) then
        return true
      end
      return false
    end,
  },
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
    opts = {
      style = "multiplex", -- Choose between 'vulgaris' (regular), 'multiplex' (greener), and 'light'
    },
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
      -- on_highlights = function(highlights, _)
      -- local hl = require "r.settings.highlights"
      -- highlights.Normal = {
      --   bg = hl.tint(highlights.Normal.bg, 0.76),
      --   fg = highlights.Normal.fg,
      -- }
      -- highlights.helpCommand = {
      --   bg = "NONE",
      -- }
      -- end,
    },
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
  -- SEOUL256
  -- {
  --   "junegunn/seoul256.vim",
  --   lazy = false,
  --   priority = 1000,
  --   -- init = function()
  --   --   vim.g.seoul256_background = 256
  --   -- end,
  --   enabled = function()
  --     local seoul256theme = { "seoul256" }
  --     if vim.tbl_contains(seoul256theme, colorscheme) then
  --       return true
  --     end
  --     return false
  --   end,
  -- },
  -- GRUVBOX-MATERIAL
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    init = function()
      vim.g.gruvbox_material_better_performance = 1
    end,
    enabled = function()
      local gruvboxtheme = { "gruvbox-material" }
      if vim.tbl_contains(gruvboxtheme, colorscheme) then
        return true
      end
      return false
    end,
  },
  -- CATPPUCCIN
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    enabled = function()
      local catppuccintheme = { "catppuccin-latte", "catppuccin" }
      if vim.tbl_contains(catppuccintheme, colorscheme) then
        return true
      end
    end,
    opts = {
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      background = { -- :h background
        light = "latte",
        dark = "mocha",
      },
    },
  },
  -- TOKYONIGHT
  {
    "folke/tokyonight.nvim",
    name = "tokyonight",
    lazy = false,
    priority = 1000,
    enabled = function()
      local colorstokyonight = { "tokyonight", "tokyonight-night", "tokyonight-day", "tokyonight-storm" }
      if vim.tbl_contains(colorstokyonight, colorscheme) then
        return true
      end
    end,
    config = function()
      local tokyo_style = "strom"
      if Config.colorscheme == "tokyonight-night" then
        tokyo_style = "night"
      elseif Config.colorscheme == "tokyonight-day" then
        tokyo_style = "day"
      end

      local tokyonight = require "tokyonight"
      tokyonight.setup {
        style = tokyo_style,
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
  -- NORD
  {
    "shaunsingh/nord.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local nordtheme = { "nord" }
      if vim.tbl_contains(nordtheme, colorscheme) then
        return true
      end
    end,
  },
}
