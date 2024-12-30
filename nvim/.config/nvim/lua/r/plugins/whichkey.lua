local Highlight = require "r.settings.highlights"
return {
  -- WHICH-KEY
  {
    "folke/which-key.nvim",
    event = "LazyFile",
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show { global = false }
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
    opts = {
      preset = "helix",
      defaults = {},
      icons = {
        breadcrumb = " ", -- symbol used in the command line area that shows your active key combo
        separator = " ", -- symbol used between a key and it's label
        mappings = false,
      },
      keys = {
        scroll_down = "<c-d>", -- binding to scroll down inside the popup
        scroll_up = "<c-u>", -- binding to scroll up inside the popup
      },
      plugins = {
        marks = true,
        registers = true,
        spelling = {
          enabled = true,
          suggestions = 20,
        },
        presets = {
          operators = false,
          motions = false,
          text_objects = false,
          windows = false,
          nav = false,
          z = false,
          g = false,
        },
      },
      spec = {
        {
          mode = { "n", "v" },
          { "<Leader>a", group = "add/qf/ql" },

          { "<Leader>b", group = "buffer" },
          { "<Leader>ba", group = "projectionist" },

          { "<Leader>c", group = "code" },
          { "<Leader>d", group = "debug" },
          { "<Leader>f", group = "fzflua" },

          { "<Leader>g", group = "git" },
          { "<Leader>gh", group = "hunks" },
          { "<Leader>gu", group = "git-toggle" },

          { "<Leader>o", group = "open/linking" },
          { "<Leader>r", group = "run/tasks" },
          { "<Leader>t", group = "testing" },
          { "<Leader>u", group = "toggle" },

          { "<Leader>x", group = "diagnostics/quickfix/trouble", icon = { icon = "󱖫 ", color = "green" } },

          { "<Localleader>n", group = "noice" },
          { "<Localleader>d", group = "database" },
          { "<Localleader>a", group = "note" },
          { "<Localleader>o", group = "open/misc" },
          { "<Localleader>r", group = "refactoring" },
          { "<Localleader>s", group = "snacks" },
        },
      },
    },
    confi = function(_, opts)
      Highlight.plugin("whichkey_hijackcol", {
        { WhichKeyBorder = { bg = { from = "FzfLuaBorder", attr = "fg" } } },
        { WhichKeyTitle = { bg = { from = "FzfLuaBorder", attr = "fg" } } },
      })
      local wk = require "which-key"
      wk.setup(opts)
    end,
  },
}
