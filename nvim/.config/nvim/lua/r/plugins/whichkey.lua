return {
  -- WHICH-KEY
  {
    "folke/which-key.nvim",
    event = "LazyFile",
    opts = {
      defaults = {},
      plugins = { registers = false },
      sort = { "desc", "alphanum", "local", "group", "group", "mod" },
      -- sort = { "local", "order", "group", "alphanum", "mod" },
      keys = {
        scroll_down = "<c-d>",
        scroll_up = "<c-u>",
      },
      -- triggers = {
      --   { "<Leader>", mode = "nxso" },
      --   { "<Localleader>", mode = "nxso" },
      -- },
      icons = {
        rules = {
          { plugin = "fzf-lua", icon = "💊", name = "fzf" },
          { plugin = "orgmode", cat = "filetype", icon = "📓", name = "org" },
          { plugin = "diffview", cat = "filetype", icon = " ", name = "diffview" },

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
          { "<Leader>q", group = "session/quickfix" },
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
          { "<Leader>m", group = "zoom" },

          { "<Leader>x", group = "exec:diagnostics/quickfix/trouble/cmd", icon = { icon = "󱖫 ", color = "green" } },

          { "<Leader>w", group = "windows" },
          { "<leader>b", group = "buffer" },

          { "<Localleader>g", group = "grug-far" },

          { "<Localleader>a", group = "note" },
          { "<Localleader>c", group = "ai" },
          { "<Localleader>n", group = "noice-notification" },

          { "<Localleader>d", group = "database" },
          { "<Localleader>f", group = "telescope" },
          { "<Localleader>d", group = "notification" },
          { "<Localleader>o", group = "open/misc" },

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
