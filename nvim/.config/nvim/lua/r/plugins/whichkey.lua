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
      plugins = { registers = false }, -- registers disabled
      keys = {
        scroll_down = "<c-d>",
        scroll_up = "<c-u>",
      },
      spec = {
        {
          mode = { "n", "v" },
          { "<Leader>a", group = "ai" },

          { "<Leader>q", group = "quickfix" },

          { "<Leader>A", group = "projectionist" },

          { "<Leader>c", group = "code/action" },
          { "<Leader>d", group = "debug" },
          { "<Leader>f", group = "fzflua" },

          { "<Leader>g", group = "git" },
          { "<Leader>gl", group = "lazygit" },

          { "<Leader>j", group = "jumpTo" },

          { "<Leader>gh", group = "hunks" },
          { "<Leader>gu", group = "toggle" },
          { "<Leader>go", group = "open" },

          { "<Leader>o", group = "open/linking" },
          { "<Leader>r", group = "run/tasks" },

          { "<Leader>t", group = "testing" },
          { "<Leader>tc", group = "coverage" },

          { "<Leader>u", group = "toggle" },
          { "<Leader>s", group = "session" },
          -- { "<Leader>z", group = "fold" },
          { "<Leader>x", group = "exec:diagnostics/quickfix/trouble", icon = { icon = "󱖫 ", color = "green" } },

          {
            "<leader>w",
            group = "windows",
            proxy = "<c-w>",
            expand = function()
              return require("which-key.extras").expand.win()
            end,
          },
          {
            "<leader>b",
            group = "buffer",
            expand = function()
              return require("which-key.extras").expand.buf()
            end,
          },

          { "<Localleader>a", group = "note" },
          { "<Localleader>af", group = "find" },
          { "<Localleader>afg", group = "orgmode/obsidian" },

          { "<Localleader>d", group = "database" },
          { "<Localleader>f", group = "telescope" },
          { "<Localleader>n", group = "noice" },
          { "<Localleader>o", group = "open/misc" },
          { "<Localleader>r", group = "refactoring" },
          { "<Localleader>s", group = "snacks" },
          { "<Localleader>w", group = "swap" },
        },
      },
    },
    confi = function(_, opts)
      local wk = require "which-key"
      wk.setup(opts)
    end,
  },
}
