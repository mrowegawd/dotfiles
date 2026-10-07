-- https://base46.vercel.app/
-- https://vimcolorschemes.com/i/trending

-- https://nvchad.com/themes
-- https://github.com/mbadolato/iTerm2-Color-Schemes
-- https://github.com/tinted-theming
-- https://base2t.one

return {
  -- LUNA
  {
    "wtfox/luna.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local luna_themes = { "luna" }
      if vim.tbl_contains(luna_themes, vim.g.colorscheme) then
        return true
      end
      return false
    end,
    opts = {},
  },
  -- CENDRE
  {
    "Aejkatappaja/cendre",
    lazy = false,
    priority = 1000,
    enabled = function()
      local candre_themes = { "cendre" }
      if vim.tbl_contains(candre_themes, vim.g.colorscheme) then
        return true
      end
      return false
    end,
    opts = {
      background = "hard", -- "hard" | "medium" | "soft"
      italic = false,
    },
  },
  -- INTENT
  {
    "GasimGasimzada/intent.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local intent_themes = { "intent" }
      if vim.tbl_contains(intent_themes, vim.g.colorscheme) then
        return true
      end
      return false
    end,
  },
  -- NIGHTFOX
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local nightfox_themes = { "nightfox" }
      if vim.tbl_contains(nightfox_themes, vim.g.colorscheme) then
        return true
      end
      return false
    end,
    opts = {
      groups = {
        nightfox = {
          Normal = { bg = "#0C1219" },
        },
      },
    },
  },
  -- KANAGAWA
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local kanagawa_themes = { "kanagawa", "kanagawa-lotus" }
      if vim.tbl_contains(kanagawa_themes, vim.g.colorscheme) then
        return true
      end
      return false
    end,
    opts = {
      theme = "dragon", -- Load "wave" theme
      background = { -- map the value of 'background' option to a theme
        dark = "wave", -- try "dragon" !
        light = "lotus",
      },
      overrides = function()
        return {
          Normal = { bg = vim.g.colorscheme == "kanagawa-lotus" and "#C8C093" or "#0B0B0B" },
        }
      end,
    },
  },
  -- Y9NIKA
  {
    "y9san9/y9nika.nvim", -- sangat-sangat minimal color highlight nya!
    lazy = false,
    priority = 1000,
    enabled = function()
      local y9nika_themes = { "y9nika" }
      if vim.tbl_contains(y9nika_themes, vim.g.colorscheme) then
        return true
      end
      return false
    end,
  },
  -- DARCUBOX
  {
    "Koalhack/darcubox-nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local darcubox_themes = { "darcubox" }
      if vim.tbl_contains(darcubox_themes, vim.g.colorscheme) then
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
    enabled = function()
      local gruvbox_material_themes = { "gruvbox-material" }
      -- TODO: gruvbox_material_background ini harus dibuat segeneric mungkin?
      vim.g.gruvbox_material_background = "medium"
      if vim.tbl_contains(gruvbox_material_themes, vim.g.colorscheme) then
        return true
      end
      return false
    end,
  },
  -- GRUVBOX.NVIM
  {
    "https://gitlab.com/motaz-shokry/gruvbox.nvim",
    name = "gruvbox",
    lazy = false,
    priority = 1000,
    enabled = function()
      local gruvboxnvim_themes = { "gruvbox" }
      if vim.tbl_contains(gruvboxnvim_themes, vim.g.colorscheme) then
        return true
      end
      return false
    end,
    opts = {
      variant = "hard", -- auto, hard, medium, soft, light
    },
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
      local techbase_themes = { "techbase" }
      if vim.tbl_contains(techbase_themes, vim.g.colorscheme) then
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
      local jellybeans_themes = { "jellybeans", "jellybeans-mono" }
      if vim.tbl_contains(jellybeans_themes, vim.g.colorscheme) then
        return true
      end
      return false
    end,
    opts = {
      italics = false,
    },
  },
  {
    "neanias/everforest-nvim",
    version = false,
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
    -- Optional; default configuration will be used if setup isn't called.
    enabled = function()
      local everforest_theme = { "jellybeans", "everforest" }
      if vim.tbl_contains(everforest_theme, vim.g.colorscheme) then
        return true
      end
      return false
    end,
    -- opts = {
    --   on_highlights =function()
    --       hl.Normal = { bg = "#0a0a0a" }
    --       -- hl.DiagnosticWarn = { fg = palette.none, bg = palette.none, sp = palette.yellow }
    --       -- hl.DiagnosticInfo = { fg = palette.none, bg = palette.none, sp = palette.blue }
    --       -- hl.DiagnosticHint = { fg = palette.none, bg = palette.none, sp = palette.green }
    --   end
    --
    -- },
    config = function()
      -- 03:12:07 AM msg_show.list_cmd   hi NormalNote NormalNote     xxx guifg=#a09986 guibg=#1b2023
      require("everforest").setup {
        on_highlights = function(hl, palette)
          hl.Normal = { bg = "#1b2023", fg = "#a09986" }
          --   -- hl.DiagnosticWarn = { fg = palette.none, bg = palette.none, sp = palette.yellow }
          --   -- hl.DiagnosticInfo = { fg = palette.none, bg = palette.none, sp = palette.blue }
          --   -- hl.DiagnosticHint = { fg = palette.none, bg = palette.none, sp = palette.green }
        end,
        -- Your config here
      }
    end,
  },
  -- NVIM-BASE46
  -- {
  --   "yardnsm/nvim-base46",
  --   lazy = false,
  --   priority = 1000,
  --   enabled = function()
  --     local base46_themes = {
  --       "base46-aylin",
  --       "base46-catppuccin",
  --       "base46-chocolate",
  --       "base46-doomchad",
  --       "base46-everforest",
  --       "base46-gruvchad",
  --       "base46-horizon",
  --       "base46-jabuti",
  --       "base46-palenight",
  --       -- "base46-jellybeans",
  --       "base46-material-darker",
  --       "base46-material-lighter",
  --       "base46-melange",
  --       "base46-onenord",
  --       -- "base46-oxocarbon",
  --       "base46-seoul256_dark",
  --       "base46-solarized_dark",
  --       "base46-vscode_dark",
  --       "base46-wombat",
  --     }
  --     if vim.tbl_contains(base46_themes, vim.g.colorscheme) then
  --       return true
  --     end
  --     return false
  --   end,
  -- },
  -- ASHEN
  {
    "ficcdaf/ashen.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local ashen_themes = { "ashen" }
      if vim.tbl_contains(ashen_themes, vim.g.colorscheme) then
        return true
      end
      return false
    end,
    opts = {
      plugins = {
        autoload = false,
      },
    },
  },
  -- ROSE PINE
  {
    "rose-pine/neovim",
    lazy = false,
    priority = 1000,
    name = "rose-pine",
    enabled = function()
      local rosepine_themes = { "rose-pine-dawn", "rose-pine", "rose-pine-moon" }
      if vim.tbl_contains(rosepine_themes, vim.g.colorscheme) then
        return true
      end
      return false
    end,
    opts = {
      styles = {
        bold = true,
        italic = false,
        transparency = false,
      },
      highlight_groups = {
        Normal = { bg = "#12171c" },
      },
    },
  },
  -- LACKLUSTER
  {
    "slugbyte/lackluster.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local lackluster_themes = { "lackluster", "lackluster-mint", "lackluster-hack", "lackluster-dark" }
      if vim.tbl_contains(lackluster_themes, vim.g.colorscheme) then
        return true
      end
      return false
    end,
    opts = {
      tweak_background = {
        normal = "#050505", -- main background
        -- normal = 'none',    -- transparent
        -- normal = '#a1b2c3',    -- hexcode
        -- normal = color.green,    -- lackluster color
        -- telescope = "default", -- telescope
        -- menu = "default", -- nvim_cmp, wildmenu ... (bad idea to transparent)
        -- popup = "default", -- lazy, mason, whichkey ... (bad idea to transparent)
      },
    },
  },
  -- VSCODE.NVIM
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local vscode_themes = { "vscode" }
      if vim.tbl_contains(vscode_themes, vim.g.colorscheme) then
        return true
      end
      return false
    end,
    opts = {
      highlights = {
        background = { bg = "#191919" }, -- "#050505"
      },
      color_overrides = {
        Normal = "#FFFFFF",
      },
      group_overrides = {
        Normal = { bg = "#1e1e1e", fg = "#d4d4d4" },
      },
    },
  },
  -- VSCODE-MODERN-THEME
  {
    "gmr458/vscode_modern_theme.nvim",
    lazy = false,
    priority = 1000,
    enabled = function()
      local vscode_modern_themes = { "vscode_modern" }
      if vim.tbl_contains(vscode_modern_themes, vim.g.colorscheme) then
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
      local tokyonight_themes = { "tokyonight", "tokyonight-night", "tokyonight-storm" }
      if vim.tbl_contains(tokyonight_themes, vim.g.colorscheme) then
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
      dim_inactive = false,
      transparent = false,
      on_colors = function() end,
      on_highlights = function(hl, _)
        if vim.g.colorscheme == "tokyonight-night" then
          hl.Normal = {
            bg = "#0A0A0A",
            fg = "#c0caf5",
          }
        end
      end,
    },
    config = function(_, opts)
      local tokyonight = require "tokyonight"
      tokyonight.setup(opts)
      tokyonight.load()
    end,
  },
}
