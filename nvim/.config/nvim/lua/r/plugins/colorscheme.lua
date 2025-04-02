local colorscheme = RUtils.config.colorscheme
-- https://nvchad.com/themes
-- https://base46.vercel.app/
-- https://github.com/mbadolato/iTerm2-Color-Schemes
-- https://github.com/tinted-theming
-- https://base2t.one
return {
  -- EF-THEMES-EMACS
  {
    -- https://protesilaos.com/emacs/ef-themes-pictures
    -- https://github.com/oonamo/ef-themes.nvim
    "oonamo/ef-themes.nvim",
    priority = 1000,
    lazy = false,
    enabled = function()
      local ef_theme = {
        "ef-theme",
        "ef-cyprus",
        "ef-owl",
        "ef-arbutus",
        "ef-day",
        "ef-eagle",
        "ef-melissa-light",
        "ef-melissa-dark",
      }
      if vim.tbl_contains(ef_theme, colorscheme) then
        return true
      end
      return false
    end,
  },
  -- SEOUL256
  {
    "junegunn/seoul256.vim",
    priority = 1000,
    lazy = false,
    enabled = function()
      local seoul256_theme = { "seoul256", "seoul256-light" }
      if vim.tbl_contains(seoul256_theme, colorscheme) then
        return true
      end
      return false
    end,
    config = function()
      vim.g.seoul256_background = 234
    end,
  },
  -- ONEDARK
  {
    "olimorris/onedarkpro.nvim",
    priority = 1000,
    lazy = false,
    enabled = function()
      local onedark_theme = { "onedark", "onedark_dark", "onedark_vivid" }
      if vim.tbl_contains(onedark_theme, colorscheme) then
        return true
      end
      return false
    end,
  },
  -- EF-THEMES
  {
    "shaunsingh/nord.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local ef_theme = { "nord" }
      if vim.tbl_contains(ef_theme, colorscheme) then
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
      if vim.tbl_contains(ashen_theme, colorscheme) then
        return true
      end
      return false
    end,
  },
  -- ZENBURN
  {
    "zenbones-theme/zenbones.nvim",
    dependencies = "rktjmp/lush.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local zenbones_theme = { "zenburned", "rosebones" }
      if vim.tbl_contains(zenbones_theme, colorscheme) then
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
      if vim.tbl_contains(rosepine_theme, colorscheme) then
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
