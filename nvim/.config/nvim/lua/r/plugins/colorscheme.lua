local colorscheme = RUtils.config.colorscheme

return {
  {
    "ferdinandrau/lavish.nvim",
    priority = 1000,
    enabled = function()
      local lavish_theme = { "lavish", "lavish-dark" }
      if vim.tbl_contains(lavish_theme, colorscheme) then
        return true
      end
      return false
    end,
    config = function()
      vim.opt.background = "dark"
      require("lavish").apply()
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
  -- FLOW
  {
    "0xstepit/flow.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local flow_theme = { "flow" }
      if vim.tbl_contains(flow_theme, colorscheme) then
        return true
      end
      return false
    end,
    config = function()
      require("flow").setup {
        transparent = false, -- Set transparent background.
        fluo_color = "pink", --  Fluo color: pink, yellow, orange, or green.
        mode = "normal", -- Intensity of the palette: normal, dark, or bright. Notice that dark is ugly!
        aggressive_spell = false, -- Display colors for spell check.
      }
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
    config = function()
      local lackluster = require "lackluster"
      lackluster.setup {
        disable_plugin = {
          bufferline = true,
        },
      }
    end,
  },
  -- NEOMODERN
  {
    "cdmill/neomodern.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local neomodern_theme = { "iceclimber", "coffeecat", "darkforest", "roseprime", "daylight" }
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
  -- SWEETIE
  {
    "NTBBloodbath/sweetie.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local sweetie_theme = { "sweetie" }
      if vim.tbl_contains(sweetie_theme, colorscheme) then
        return true
      end
      return false
    end,
    init = function()
      --- Default configuration
      vim.g.sweetie = {
        -- Pop-up menu pseudo-transparency
        -- It requires `pumblend` option to have a non-zero value
        pumblend = {
          enable = true,
          transparency_amount = 20,
        },
        palette = {
          dark = {},
          light = {},
        },
        -- Override default highlighting groups options
        -- overrides = {
        --   Comment = { italic = false },
        --   CommentBold = { italic = false },
        --   Keyword = { italic = false },
        --   Boolean = { italic = false },
        --   Class = { italic = false },
        --   -- Optional, just if you use Java and you do not want some extra italics
        --   -- ["@type.java"] = { italic = false },
        --   -- ["@type.qualifier.java"] = { italic = false },
        -- },
        -- Custom plugins highlighting groups
        integrations = {
          lazy = true,
          neorg = true,
          neogit = true,
          neomake = true,
          telescope = true,
        },
        -- Enable custom cursor coloring even in terminal Neovim sessions
        cursor_color = true,
        -- Use sweetie's palette in `:terminal` instead of your default terminal colorscheme
        terminal_colors = true,
      }
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
      require("everforest").setup()
    end,
  },
  -- MELANGE
  {
    "savq/melange-nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local melangetheme = { "melange" }
      if vim.tbl_contains(melangetheme, colorscheme) then
        return true
      end
      return false
    end,
  },
  -- FAROUT
  {
    "thallada/farout.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local farout_theme = { "farout", "farout-night", "farout-day", "farout-moon", "farout-storm" }
      if vim.tbl_contains(farout_theme, colorscheme) then
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
  -- OXOCARBON
  {
    "nyoom-engineering/oxocarbon.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local oxocarbontheme = { "oxocarbon" }
      if vim.tbl_contains(oxocarbontheme, colorscheme) then
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
      local catppuccintheme = { "catppuccin-mocha", "catppuccin-latte" }
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
  -- PAPERCOLOR
  {
    "NLKNguyen/papercolor-theme",
    priority = 1000,
    enabled = function()
      local papercolortheme = { "PaperColor" }
      if vim.tbl_contains(papercolortheme, colorscheme) then
        return true
      end
    end,
  },
  -- NIGHTFOX
  {
    "EdenEast/nightfox.nvim",
    priority = 1000,
    enabled = function()
      local nightfoxtheme = { "dawnfox", "duskfox", "nightfox", "dayfox", "nordfox", "terafox" }
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
  -- ROSE-PINE
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    enabled = function()
      local material_theme = { "rose-pine-moon", "rose-pine-main", "rose-pine-dawn" }
      if vim.tbl_contains(material_theme, colorscheme) then
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
