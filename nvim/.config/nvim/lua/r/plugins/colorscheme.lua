-- https://base46.vercel.app/
-- https://vimcolorschemes.com/i/trending

-- https://nvchad.com/themes
-- https://github.com/mbadolato/iTerm2-Color-Schemes
-- https://github.com/tinted-theming
-- https://base2t.one

return {
  -- NVIM-BASE46
  {
    "yardnsm/nvim-base46",
    lazy = false,
    priority = 1000,
    enabled = function()
      local base46_theme = {
        "base46-aylin",
        "base46-ayu_dark",
        "base46-chocolate",
        "base46-default-dark",
        "base46-doomchad",
        "base46-jabuti",
        "base46-jellybeans",
        "base46-kanagawa",
        "base46-material-darker",
        "base46-onenord",
        "base46-seoul256_dark",
        "base46-solarized_dark",
        "base46-zenburn",
      }
      if vim.tbl_contains(base46_theme, vim.g.colorscheme) then
        return true
      end
      return false
    end,
  },
  -- DARKEARTH
  {
    "ptdewey/darkearth-nvim",
    priority = 1000,
    enabled = function()
      local darkearth_theme = { "darkearth" }
      if vim.tbl_contains(darkearth_theme, vim.g.colorscheme) then
        return true
      end
      return false
    end,
  },
  -- ASHEN
  {
    "ficcdaf/ashen.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local ashen_theme = { "ashen" }
      if vim.tbl_contains(ashen_theme, vim.g.colorscheme) then
        return true
      end
      return false
    end,
  },
  -- ZENBURN
  {
    "phha/zenburn.nvim",
    lazy = false,
    as = "zenburn",
    priority = 1000,
    enabled = function()
      local zenbones_theme = { "zenburn" }
      if vim.tbl_contains(zenbones_theme, vim.g.colorscheme) then
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
      local rosepine_theme = { "rose-pine-dawn", "rose-pine-main", "rose-pine" }
      if vim.tbl_contains(rosepine_theme, vim.g.colorscheme) then
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
      if vim.tbl_contains(oxocarbon_theme, vim.g.colorscheme) then
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
      if vim.tbl_contains(lackluster_theme, vim.g.colorscheme) then
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
      if vim.tbl_contains(horizon_theme, vim.g.colorscheme) then
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
      if vim.tbl_contains(vscode_modern_theme, vim.g.colorscheme) then
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
  -- CATPPUCCIN
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    enabled = function()
      local catppuccintheme = { "catppuccin-mocha" }
      if vim.tbl_contains(catppuccintheme, vim.g.colorscheme) then
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
      if vim.tbl_contains(colorstokyonight, vim.g.colorscheme) then
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
