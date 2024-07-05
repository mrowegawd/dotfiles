local colorscheme = RUtils.config.colorscheme

return {
  -- LACKLUSTER.NVIM
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
  -- NEOMODERN
  {
    "cdmill/neomodern.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local neomodern_theme = { "iceclimber", "coffeecat", "darkforest", "campfire", "roseprime", "daylight" }
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
  -- DOOM-ONE
  {
    "NTBBloodbath/doom-one.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local doom_theme = { "doom-one" }
      if vim.tbl_contains(doom_theme, colorscheme) then
        return true
      end
      return false
    end,
    config = function()
      -- Add color to cursor
      vim.g.doom_one_cursor_coloring = false
      -- Set :terminal colors
      vim.g.doom_one_terminal_colors = true
      -- Enable italic comments
      vim.g.doom_one_italic_comments = false
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
      vim.g.doom_one_plugin_telescope = false
      vim.g.doom_one_plugin_neogit = true
      vim.g.doom_one_plugin_nvim_tree = true
      vim.g.doom_one_plugin_dashboard = true
      vim.g.doom_one_plugin_startify = true
      vim.g.doom_one_plugin_whichkey = true
      vim.g.doom_one_plugin_indent_blankline = true
      vim.g.doom_one_plugin_vim_illuminate = true
      vim.g.doom_one_plugin_lspsaga = false
    end,
  },
  -- FLEXOKI
  {
    "kepano/flexoki-neovim",
    name = "flexoki",
    lazy = false,
    priority = 1000,
    enabled = function()
      local flexoki_theme = { "flexoki-dark", "flexoki-light" }
      if vim.tbl_contains(flexoki_theme, colorscheme) then
        return true
      end
      return false
    end,
  },
  -- NEOVIM-AYU
  {
    "Shatur/neovim-ayu",
    lazy = false,
    priority = 1000,
    enabled = function()
      local ayu_theme = { "ayu-dark", "ayu-light" }
      if vim.tbl_contains(ayu_theme, colorscheme) then
        return true
      end
      return false
    end,
    config = function()
      require("ayu").setup {
        mirage = true,
        overrides = {},
        -- overrides = {
        --   Normal = { bg = "None" },
        --   ColorColumn = { bg = "None" },
        --   SignColumn = { bg = "None" },
        --   Folded = { bg = "None" },
        --   FoldColumn = { bg = "None" },
        --   CursorLine = { bg = "None" },
        --   CursorColumn = { bg = "None" },
        --   WhichKeyFloat = { bg = "None" },
        --   VertSplit = { bg = "None" },
        -- },
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
      vim.opt.background = "light"
      require("everforest").setup()
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
      local solarizedosaka = { "solarized-osaka-night" }
      if vim.tbl_contains(solarizedosaka, colorscheme) then
        return true
      end
      return false
    end,
    config = function(_, opts)
      require("solarized-osaka").setup(opts)
    end,
    opts = {
      transparent = false, -- Enable this to disable setting the background color
      terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
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
    init = function()
      vim.g.background = "light"
    end,
    enabled = function()
      local catppuccintheme = { "catppuccin-latte", "catppuccin-mocha" }
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
      style = "darker",
    },
  },
  -- TENDER
  {
    "jacoborus/tender.vim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local tendertheme = { "tender" }
      if vim.tbl_contains(tendertheme, colorscheme) then
        return true
      end
    end,
  },
}
