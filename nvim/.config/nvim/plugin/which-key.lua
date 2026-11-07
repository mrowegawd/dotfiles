local add = require("vim-pack").add

add {
  {
    src = "folke/which-key.nvim",
    opts = {
      defaults = {},
      plugins = { registers = false },
      sort = { "desc", "alphanum", "local", "group", "group", "mod" },
      keys = {
        scroll_down = "<c-d>",
        scroll_up = "<c-u>",
      },
      icons = {
        rules = {
          { plugin = "fzf-lua", icon = "💊", name = "fzf" },
          { plugin = "orgmode", cat = "filetype", icon = "📓", name = "org" },
          { plugin = "org.nvim", icon = "📓", name = "org.nvim" },
          { plugin = "diffview", cat = "filetype", icon = " ", name = "diffview" },
          { plugin = "todo-comments.nvim", cat = "filetype", name = "TODO" },

          -- { pattern = "code_action",  icon = "󰌶 ", color = "yellow" }, -- bulb
          -- { pattern = "code action",  icon = "󰌶 ", color = "yellow" },
          -- { pattern = "codeaction",   icon = "󰌶 ", color = "yellow" },
          -- { pattern = "action",       icon = "󰓅 ", color = "yellow" }, -- bolt
          -- { pattern = "bulk.rename",  icon = "󰑕 ", color = "yellow" },
          -- { pattern = "bulk.replace", icon = "󰛔 ", color = "green"  },
          -- { pattern = "bulk.delete",  icon = "󰆴 ", color = "red"    },
          -- { pattern = "bulk.select",  icon = "󰒅 ", color = "cyan"   },
          -- { pattern = "bulk.move",    icon = "󰆏 ", color = "blue"   },
          -- { pattern = "bulk.copy",    icon = "󰆏 ", color = "blue"   },
          -- { pattern = "bulk",         icon = "󰒺 ", color = "orange" }, -- fallback

          { pattern = "bulk:", icon = "💡", color = "yellow" }, -- fast/batch
          { pattern = "org:", icon = "📓", name = "green" },
          { pattern = "note:", icon = "📓", name = "green" },
          { pattern = "open:", icon = "󰏌", color = "magenta" },
          { pattern = "debug:", icon = "󰃤 ", color = "red" },
          { pattern = "lsp:", icon = "📡", color = "cyan" },
          { pattern = "picker", icon = "💊" },
          { pattern = "buffer:", icon = "󰈙 ", color = "green" },
          { pattern = "git:", icon = " ", color = "orange" },
          { pattern = "qfmark:", icon = "󰁨 ", color = "yellow" },
          { pattern = "diagnostics:", icon = "🩺", color = "orange" },
          { pattern = "diagnostics", icon = "🩺", color = "orange" },
          { pattern = "refactoring:", icon = " ", color = "cyan" },
          { pattern = "exec:", icon = "󰆍 ", color = "red" },
          { pattern = "toggle:", icon = " ", color = "yellow" },
          { pattern = "test:", icon = " ", color = "yellow" },
          { pattern = "task:", icon = "󰜎", color = "red" },
          { pattern = "taskoverseer:", icon = "󰜎", color = "red" },
          { pattern = "jump:", icon = "󰁝 ", color = "cyan" },
          { pattern = "run", icon = "󰜎", color = "red" },
          { pattern = "action", icon = "⚡", color = "yellow" },
          { pattern = "insert", icon = "󰀧 ", color = "green" },
          { pattern = "help", icon = " ", color = "gray" },
          { pattern = "projects", icon = " ", color = "blue" },
          { pattern = "grug-far", icon = "🦴", color = "yellow" },
          { pattern = "grug far", icon = "🦴", color = "yellow" },
          { pattern = "org agenda", icon = "📓", name = "green" },
          { pattern = "db:", icon = "󰆼 ", color = "cyan" },
        },
      },
      spec = {
        {
          mode = { "n", "x" },
          { "<Leader>q", group = "quickfix", icon = { icon = "󰁨 ", color = "yellow" } },
          { "<Leader>d", group = "debug" },
          { "<Leader>f", group = "picker" },
          { "<Leader>i", group = "insert" },
          { "<Leader>j", group = "jump", icon = { icon = "󰁝 ", color = "cyan" } },
          { "<Leader>p", group = "projects" },
          { "<Leader>y", group = "surrounds", icon = { icon = "󰉢 ", color = "magenta" } },
          { "<Leader>l", group = "LSP", icon = { icon = "📡", color = "cyan" } },
          { "<Leader>o", group = "open", icon = { icon = "󰏌", color = "magenta" } },
          { "<Leader>h", group = "help" },
          { "<Leader>r", group = "run/tasks" },
          { "<Leader>t", group = "testing", icon = { icon = " ", color = "yellow" } },
          { "<Leader>u", group = "toggle" },
          { "<Leader>s", group = "session" },
          { "<Leader>m", group = "zoom" },
          { "<Leader>x", group = "exec", icon = { icon = "󰆍 ", color = "red" } },
          { "<Leader>w", group = "windows" },
          { "<leader>b", group = "buffer", icon = { icon = "󰈙 ", color = "green" } },

          { "<Leader>c", group = "code/action" },
          { "<Leader>cp", group = "peek/overlook" },
          { "<Leader>cb", group = "comment-box" },

          { "<Leader>g", group = "git" },
          { "<Leader>go", group = "open" },

          -- { "<Localleader>t", group = "terminals" },

          { "<Localleader>g", group = "grug-far", icon = { icon = "🦴", color = "yellow" } },
          { "<Localleader>a", group = "note", icon = { icon = "📓", name = "green" } },
          { "<Localleader>c", group = "ai" },
          { "<Localleader>n", group = "notify/notifications" },
          { "<Localleader>r", group = "refactoring" },
          { "<Localleader>d", group = "database", icon = { icon = "󰆼 ", color = "cyan" } },
          { "<Localleader>f", group = "telescope" },
          { "<Localleader>o", group = "open/misc" },

          { "<Localleader>s", group = "snacks" },
          { "<Localleader>w", group = "swap" },

          --- GLOBAL <C-c>..
          { "<C-c>g", group = "git:commands" },
          { "<C-c>u", group = "toggle:commands" },
          { "<C-c>l", group = "lsp:commands" },
          { "<C-c>o", group = "open", icon = { icon = "󰏌", color = "magenta" } },
          { "<C-c>x", group = "exec", icon = { icon = "󰆍 ", color = "red" } },
        },
      },
    },
  },
}
