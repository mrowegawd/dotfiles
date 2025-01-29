local colorscheme = RUtils.config.colorscheme
-- https://nvchad.com/themes
-- https://github.com/mbadolato/iTerm2-Color-Schemes
-- https://github.com/tinted-theming

return {
  -- OLDWORLD
  {
    "dgox16/oldworld.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local oldworld_theme = { "oldworld" }
      if vim.tbl_contains(oldworld_theme, colorscheme) then
        return true
      end
      return false
    end,
  },
  -- ROSE PINE
  {
    "rose-pine/neovim",
    lazy = false,
    priority = 1000,
    name = "rose-pine",
    enabled = function()
      local rosepine_theme = { "rose-pine" }
      if vim.tbl_contains(rosepine_theme, colorscheme) then
        return true
      end
      return false
    end,
    opts = {
      variant = "main", -- auto, main, moon, or dawn
    },
  },
  -- CHOCOLATIER
  {
    "qaptoR-nvim/chocolatier.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local chocolatier_theme = { "chocolatier" }
      if vim.tbl_contains(chocolatier_theme, colorscheme) then
        return true
      end
      return false
    end,
  },
  -- OXOCARBON
  {
    "nyoom-engineering/oxocarbon.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local oxocarbon_theme = { "oxocarbon" }
      if vim.tbl_contains(oxocarbon_theme, colorscheme) then
        return true
      end
      return false
    end,
  },
  -- BASE16.NVIM
  {
    "RRethy/base16-nvim",
    lazy = false,
    priority = 1000,
    version = false,
    enabled = function()
      local base16_theme = {
        "base16-atelier-estuary",
        "base16-ayu-dark",
        "base16-ayu-dark",
        "base16-gotham",
        "base16-icy",
      }
      if vim.tbl_contains(base16_theme, colorscheme) then
        return true
      end
      return false
    end,
  },
  -- MIDNIGHT
  {
    "dasupradyumna/midnight.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local midnight_theme = { "midnight" }
      if vim.tbl_contains(midnight_theme, colorscheme) then
        return true
      end
      return false
    end,
  },
  -- ONEDARK
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local onedark_theme = { "onedark" }
      if vim.tbl_contains(onedark_theme, colorscheme) then
        return true
      end
      return false
    end,
    opts = {
      style = "darker",
    },
  },
  -- SUNBURN
  {
    "loganswartz/sunburn.nvim",
    lazy = false,
    priority = 1000,
    dependencies = { "loganswartz/polychrome.nvim" },
    enabled = function()
      local sunburn_theme = { "sunburn" }
      if vim.tbl_contains(sunburn_theme, colorscheme) then
        return true
      end
      return false
    end,
  },
  -- JELLYBEANS
  {
    "kabouzeid/nvim-jellybeans",
    dependencies = "rktjmp/lush.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local jellybeans_theme = { "jellybeans" }
      if vim.tbl_contains(jellybeans_theme, colorscheme) then
        return true
      end
      return false
    end,
  },
  -- ONE-MONOKAI
  {
    "cpea2506/one_monokai.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local onemonokai_theme = { "one_monokai" }
      if vim.tbl_contains(onemonokai_theme, colorscheme) then
        return true
      end
      return false
    end,
  },
  -- LACKLUSTER
  {
    "slugbyte/lackluster.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local lackluster_theme = { "lackluster", "lackluster-mint", "lackluster-hack", "lackluster-dark" }
      if vim.tbl_contains(lackluster_theme, colorscheme) then
        return true
      end
      return false
    end,
  },
  -- NEOMODERN
  {
    "cdmill/neomodern.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local neomodern_theme = { "darkforest", "daylight", "coffeecat" }
      if vim.tbl_contains(neomodern_theme, colorscheme) then
        return true
      end
      return false
    end,
  },
  -- HORIZON
  {
    "akinsho/horizon.nvim",
    version = "*",
    lazy = false,
    priority = 1000,
    enabled = function()
      local horizon_theme = { "horizon" }
      if vim.tbl_contains(horizon_theme, colorscheme) then
        return true
      end
      return false
    end,
  },
  -- VSCODE-MODERN-THEME
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
      local catppuccintheme = { "catppuccin-mocha" }
      if vim.tbl_contains(catppuccintheme, colorscheme) then
        return true
      end
    end,
    opts = {
      flavour = "latte", -- latte, frappe, macchiato, mocha
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
      local colorstokyonight = { "tokyonight-night", "tokyonight-storm" }
      if vim.tbl_contains(colorstokyonight, colorscheme) then
        return true
      end
    end,
    opts = {
      style = "night",
      sidebars = {
        "NeogitStatus",
      },
      styles = {
        comments = { italic = true },
      },
      dim_inactive = false, -- dims inactive windows
      transparent = false, -- true
      on_colors = function() end,
      on_highlights = function() end,
    },
    config = function(_, opts)
      local tokyonight = require "tokyonight"
      tokyonight.setup(opts)
      tokyonight.load()
    end,
  },
}
