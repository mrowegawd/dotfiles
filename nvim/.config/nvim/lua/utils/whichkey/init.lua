local M = {}

M.base_mode = { "n", "x" }

M.base_mapping_clue = {
  { "<Leader>q", group = "quickfix", icon = { icon = "󰁨 ", color = "yellow" } },
  { "<Leader>f", group = "picker" },
  { "<Leader>i", group = "insert" },
  { "<Leader>j", group = "jump", icon = { icon = "󰁝 ", color = "cyan" } },
  { "<Leader>p", group = "peek" },
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

  { "<Leader>a", group = "ai" },
  { "<Leader>ax", group = "exec" },
  { "<Leader>as", group = "set" },
  { "<Leader>ao", group = "open" },

  { "<Leader>c", group = "code/action" },
  { "<Leader>cp", group = "peek/overlook" },

  { "<Leader>d", group = "debug" },
  { "<Leader>db", group = "breakpoint" },
  { "<Leader>du", group = "toggle" },

  { "<Leader>cb", group = "comment-box" },
  { "<Leader>cbs", group = "box sub title" },
  { "<Leader>cbb", group = "box sub" },
  { "<Leader>cbt", group = "box title" },
  { "<Leader>cbT", group = "box big comment" },
  { "<Leader>cbL", group = "line with text" },
  { "<Leader>cbl", group = "line only" },

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

  { "<Localleader>s", group = "session" },
  { "<Localleader>w", group = "swap" },

  --- GLOBAL <C-x>..
  { "<C-x>g", group = "git:commands" },
  { "<C-x>u", group = "toggle:commands" },
  { "<C-x>l", group = "lsp:commands" },
  { "<C-x>o", group = "open", icon = { icon = "󰏌", color = "magenta" } },
  { "<C-x>e", group = "exec", icon = { icon = "󰆍 ", color = "red" } },
}

return M
