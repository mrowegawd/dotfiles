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
          --{ "<Leader><tab>", group = "tabs" },
          { "s", group = "tabs" },
          {
            "<leader>b",
            group = "buffer",
            expand = function()
              return require("which-key.extras").expand.buf()
            end,
          },
          { "<Leader>d", group = "debug" },
          { "<Leader>f", group = "fzflua" },

          { "<Leader>g", group = "git" },
          { "<Leader>gf", group = "gitfzflua" },
          { "<Leader>gh", group = "hunks" },
          { "<Leader>o", group = "linking" },
          { "<Leader>gu", group = "gittoggle" },
          { "<Leader>gv", group = "gitvisual" },

          { "<Leader>a", group = "projectionist" },
          { "<Leader>c", group = "code" },
          { "<Leader>u", group = "toggle" },
          { "<Leader>t", group = "testing" },
          { "<Leader>r", group = "refactor" },
          { "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },

          { "<Localleader>d", group = "DB" },
          { "<Localleader>f", group = "note" },
          { "<Localleader>n", group = "noice" },
          { "<Localleader>o", group = "open/misc" },
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
