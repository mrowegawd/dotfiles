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
          { "<leader>b", group = "buffer" },
          { "<leader>ba", group = "projectionist" },
          { "<Leader>d", group = "debug" },
          { "<Leader>f", group = "fzflua" },

          { "<Leader>g", group = "git" },
          { "<Leader>gf", group = "git-fzflua" },
          { "<Leader>gh", group = "hunks" },
          { "<Leader>o", group = "linking" },
          { "<Leader>gu", group = "git-toggle" },
          { "<Leader>gv", group = "git-visual" },

          { "<Leader>a", group = "add/qf/ql" },
          { "<Leader>c", group = "code" },
          { "<Leader>u", group = "toggle" },
          { "<Leader>t", group = "testing" },
          { "<Leader>r", group = "run/tasks" },
          { "<leader>x", group = "diagnostics/quickfix/trouble", icon = { icon = "󱖫 ", color = "green" } },

          { "<Localleader>d", group = "database" },
          { "<Localleader>n", group = "note" },
          { "<Localleader>o", group = "open/misc" },
          { "<Localleader>r", group = "refactoring" },

          { "<Localleader>N", group = "noice" },
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
