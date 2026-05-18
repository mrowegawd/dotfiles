return {
  -- WHICH-KEY
  {
    "folke/which-key.nvim",
    event = "LazyFile",
    -- keys = {
    --   {
    --     "<leader>?",
    --     function()
    --       require("which-key").show { global = false }
    --     end,
    --     desc = "Buffer Local Keymaps (which-key)",
    --   },
    -- },
    opts = {
      -- preset = "helix",
      defaults = {},
      plugins = { registers = false }, -- registers disabled
      sort = { "group", "order", "alphanum", "local", "mod" },
      keys = {
        scroll_down = "<c-d>",
        scroll_up = "<c-u>",
      },
      triggers = {
        -- { "<auto>", mode = "nxso" },
        { "<Leader>", mode = "nxso" },
        { "<Localleader>", mode = "nxso" },
      },
      icons = {
        rules = {
          { plugin = "fzf-lua", icon = "💊", name = "fzf" },
          { plugin = "orgmode", cat = "filetype", icon = "📓", name = "org" },
          { plugin = "diffview", cat = "filetype", icon = " ", name = "diffview" },

          -- { plugin = "overseer.nvim", "󰜎", color = "red" },
          { pattern = "note", icon = "📓" },
          { plugin = "todo-comments.nvim", cat = "filetype", name = "TODO" },
          { pattern = "help", icon = " ", colorh = "gray" },
          { pattern = "insert", icon = "󰀧 ", color = "green" },
          { pattern = "picker", icon = "💊" },
          { pattern = "projects", icon = " ", color = "blue" },
          { pattern = "run", icon = "󰜎", color = "red" },
          { pattern = "open", icon = "󰏌", color = "magenta" },
          { pattern = "lsp", icon = "📡", color = "cyan" },
          { pattern = "action", icon = "⚡", color = "yellow" },
          { pattern = "git", icon = " ", color = "orange" },
        },
      },
      spec = {
        {
          mode = { "n", "x" },
          { "<Leader>a", group = "mark" },

          { "<Leader>q", group = "quit/session" },
          -- { "<Leader>q", group = "quickfix" },

          { "<Leader>A", group = "projectionist" },

          { "<Leader>c", group = "code/action" },

          { "<Leader>d", group = "debug" },
          { "<Leader>f", group = "picker" },

          { "<Leader>i", group = "insert" },
          { "<Leader>j", group = "jumpTo" },
          { "<Leader>p", group = "projects" },

          { "<Leader>l", group = "LSP" },
          { "<Leader>lu", group = "toggle" },

          { "<Leader>g", group = "git" },
          { "<Leader>gh", group = "hunks" },
          { "<Leader>go", group = "open" },
          { "<Leader>gb", group = "buffer" },

          { "<Leader>h", group = "help" },

          { "<Leader>o", group = "open/linking" },
          { "<Leader>r", group = "run/tasks" },

          { "<Leader>t", group = "testing" },
          { "<Leader>tc", group = "coverage" },

          { "<Leader>u", group = "toggle" },
          { "<Leader>s", group = "search" },

          -- { "<Leader>s", group = "session" },

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

          { "<Localleader>g", group = "grug-far" },
          -- { "<Localleader>q", group = "qfbookmarks" },

          { "<Localleader>n", group = "note" },
          { "<Localleader>a", group = "ai" },

          { "<Localleader>d", group = "database" },
          { "<Localleader>f", group = "telescope" },
          { "<Localleader>d", group = "notification" },
          { "<Localleader>o", group = "open/misc" },

          -- { "<Localleader>r", group = "refactoring" },
          -- { "<Localleader>re", group = "extract" },

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
