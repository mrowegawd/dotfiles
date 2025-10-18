-- https://base46.vercel.app/
-- https://vimcolorschemes.com/i/trending

-- https://nvchad.com/themes
-- https://github.com/mbadolato/iTerm2-Color-Schemes
-- https://github.com/tinted-theming
-- https://base2t.one

return {
  -- RASMUS
  {
    "kvrohit/rasmus.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local rasmus_themes = { "rasmus" }
      if vim.tbl_contains(rasmus_themes, vim.g.colorscheme) then
        return true
      end
      return false
    end,
  },
  -- ZENBURN
  {
    "phha/zenburn.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local zenburn_themes = { "zenburn" }
      if vim.tbl_contains(zenburn_themes, vim.g.colorscheme) then
        return true
      end
      return false
    end,
  },
  -- XENO
  {
    "kyza0d/xeno.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local xeno_themes = { "xenos" }
      if vim.tbl_contains(xeno_themes, vim.g.colorscheme) then
        return true
      end
      return false
    end,
    config = function()
      require("xeno").new_theme("xenos", {
        base = "#1a1a1a",
        accent = "#7aa2f7",
      })
    end,
  },
  -- MINIMAL
  {
    "Yazeed1s/minimal.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local minimal_themes = { "minimal" }
      if vim.tbl_contains(minimal_themes, vim.g.colorscheme) then
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
      local oxocarbon_themes = { "oxocarbon" }
      if vim.tbl_contains(oxocarbon_themes, vim.g.colorscheme) then
        return true
      end
      return false
    end,
  },
  -- NEOGOTHAM
  {
    "https://gitlab.com/shmerl/neogotham.git",
    lazy = false,
    priority = 1000,
    enabled = function()
      local neogotham_theme = { "neogotham" }
      if vim.tbl_contains(neogotham_theme, vim.g.colorscheme) then
        return true
      end
      return false
    end,
  },
  -- TECHBASE
  {
    "mcauley-penney/techbase.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local techbase_theme = { "techbase" }
      if vim.tbl_contains(techbase_theme, vim.g.colorscheme) then
        return true
      end
      return false
    end,
  },
  -- KANSO.NVIM
  {
    "webhooked/kanso.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local kanso_theme = { "kanso-ink", "kanso-zen", "kanso-pearl" }
      if vim.tbl_contains(kanso_theme, vim.g.colorscheme) then
        return true
      end
      return false
    end,
  },
  -- JELLYBEANS
  {
    "wtfox/jellybeans.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local jellybeans_theme = { "jellybeans", "jellybeans-mono" }
      if vim.tbl_contains(jellybeans_theme, vim.g.colorscheme) then
        return true
      end
      return false
    end,
    opts = {},
  },
  -- NVIM-BASE46
  {
    "yardnsm/nvim-base46",
    lazy = false,
    priority = 1000,
    enabled = function()
      local base46_theme = {
        "base46-aylin",
        "base46-catppuccin",
        "base46-chocolate",
        "base46-doomchad",
        "base46-everforest",
        "base46-gruvchad",
        "base46-horizon",
        "base46-jabuti",
        -- "base46-jellybeans",
        "base46-kanagawa",
        "base46-material-darker",
        "base46-material-lighter",
        "base46-melange",
        "base46-onenord",
        -- "base46-oxocarbon",
        "base46-seoul256_dark",
        "base46-solarized_dark",
        "base46-vscode_dark",
        "base46-wombat",
        "base46-zenburn",
      }
      if vim.tbl_contains(base46_theme, vim.g.colorscheme) then
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
  -- ROSE PINE
  {
    "rose-pine/neovim",
    lazy = false,
    priority = 1000,
    name = "rose-pine",
    enabled = function()
      local rosepine_theme = { "rose-pine-dawn", "rose-pine" }
      if vim.tbl_contains(rosepine_theme, vim.g.colorscheme) then
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
    opts = {
      cursorline = true,
      transparent_background = false,
      nvim_tree_darker = true,
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
