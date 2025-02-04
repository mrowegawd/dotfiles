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
      -- icons = {
      --   breadcrumb = " ", -- symbol used in the command line area that shows your active key combo
      --   separator = " ", -- symbol used between a key and it's label
      --   mappings = false,
      -- },
      -- keys = {
      --   scroll_down = "<c-d>", -- binding to scroll down inside the popup
      --   scroll_up = "<c-u>", -- binding to scroll up inside the popup
      -- },
      -- plugins = {
      --   marks = true,
      --   registers = true,
      --   spelling = {
      --     enabled = true,
      --     suggestions = 20,
      --   },
      --   presets = {
      --     operators = false,
      --     motions = false,
      --     text_objects = false,
      --     windows = false,
      --     nav = false,
      --     z = false,
      --     g = false,
      --   },
      -- },
      spec = {
        {
          mode = { "n", "v" },
          { "<Leader>a", group = "add/qf/ql" },

          { "<Leader>c", group = "code/action" },
          { "<Leader>d", group = "debug" },
          { "<Leader>f", group = "fzflua" },

          { "<Leader>g", group = "git" },
          { "<Leader>gh", group = "hunks" },
          { "<Leader>gu", group = "git-toggle" },

          { "<Leader>o", group = "open/linking" },
          { "<Leader>r", group = "run/tasks" },
          { "<Leader>t", group = "testing" },
          { "<Leader>u", group = "toggle" },
          { "<Leader>s", "", group = "session" },

          { "<Leader>x", group = "diagnostics/quickfix/trouble", icon = { icon = "󱖫 ", color = "green" } },

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
          { "<Leader>ba", group = "projectionist" },

          { "<Localleader>n", group = "noice" },
          { "<Localleader>f", group = "telescope" },
          { "<Localleader>d", group = "database" },
          { "<Localleader>a", group = "note" },
          { "<Localleader>o", group = "open/misc" },
          { "<Localleader>r", group = "refactoring" },
          { "<Localleader>s", group = "snacks" },
        },
      },
    },
    confi = function(_, opts)
      local wk = require "which-key"
      wk.setup(opts)
    end,
  },
}
