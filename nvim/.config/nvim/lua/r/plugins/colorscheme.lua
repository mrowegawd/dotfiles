local colorscheme = RUtils.config.colorscheme

return {
  -- SONOKAI
  {
    "sainnhe/sonokai",
    lazy = false,
    priority = 1000,
    enabled = function()
      local sonokai_theme = { "sonokai" }
      if vim.tbl_contains(sonokai_theme, colorscheme) then
        return true
      end
      return false
    end,
    config = function()
      vim.g.sonokai_style = "shusia" -- default, atlantis, shusia, maia, ekspresso, andromeda
    end,
  },
  -- EVANGELION
  {
    "xero/evangelion.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local evangelion_theme = { "evangelion" }
      if vim.tbl_contains(evangelion_theme, colorscheme) then
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
      local neomodern_theme = { "darkforest", "daylight" }
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
  -- EVERFOREST
  {
    "neanias/everforest-nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local everforest_theme = { "everforest" }
      if vim.tbl_contains(everforest_theme, colorscheme) then
        return true
      end
      return false
    end,
    config = function()
      vim.cmd [[set background=light]]
      require("everforest").setup {
        background = "hard",
      }
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
  -- KANAGAWA
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local kanagawa_theme = { "kanagawa" }
      if vim.tbl_contains(kanagawa_theme, colorscheme) then
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
  -- NIGHTFOX
  {
    "EdenEast/nightfox.nvim",
    priority = 1000,
    enabled = function()
      local nightfoxtheme = { "duskfox", "nightfox", "dayfox", "nordfox", "carbonfox" }
      if vim.tbl_contains(nightfoxtheme, colorscheme) then
        return true
      end
    end,
    config = function()
      if vim.g.colorscheme == "dawnfox" then
        vim.cmd [[set background=light]]
      end

      require("nightfox").setup {
        options = {
          -- Compiled file's destination location
          compile_path = vim.fn.stdpath "cache" .. "/nightfox",
          compile_file_suffix = "_compiled", -- Compiled file suffix
          transparent = false, -- Disable setting background
          terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
          dim_inactive = false, -- Non focused panes set to alternative background
          module_default = true, -- Default enable value for modules
          colorblind = {
            enable = false, -- Enable colorblind support
            simulate_only = false, -- Only show simulated colorblind colors and not diff shifted
            severity = {
              protan = 0, -- Severity [0,1] for protan (red)
              deutan = 0, -- Severity [0,1] for deutan (green)
              tritan = 0, -- Severity [0,1] for tritan (blue)
            },
          },
          styles = { -- Style to be applied to different syntax groups
            comments = "italic", -- Value is any valid attr-list value `:help attr-list`
            conditionals = "NONE",
            constants = "NONE",
            functions = "NONE",
            keywords = "NONE",
            numbers = "NONE",
            operators = "NONE",
            strings = "NONE",
            types = "NONE",
            variables = "NONE",
          },
          inverse = { -- Inverse highlight for different types
            match_paren = false,
            visual = false,
            search = false,
          },
        },
        palettes = {},
        specs = {},
        groups = {},
      }
    end,
  },
  -- TOKYONIGHT
  {
    "folke/tokyonight.nvim",
    name = "tokyonight",
    lazy = false,
    priority = 1000,
    enabled = function()
      local colorstokyonight = { "tokyonight-night", "tokyonight-storm", "tokyonight-day" }
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
