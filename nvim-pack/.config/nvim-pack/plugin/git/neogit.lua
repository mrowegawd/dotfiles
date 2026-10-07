local add = require("vim-pack").add

local UtilKey = require "utils.map"

add {
  {
    src = "NeogitOrg/neogit",
    lazy = true,
    opts = {
      kind = "vsplit",
      signs = {
        section = { "", "" },
        item = { "▸", "▾" },
        hunk = { "󰐕", "󰍴" },
      },
      mappings = {
        commit_view = {
          ["o"] = false,
          ["q"] = false,
          ["<Esc>"] = false,

          ["<Leader>oe"] = "GoToFile",
          ["<Leader>ov"] = "OpenFileInWorktree",
          ["<Leader>os"] = "OpenFileInWorktree",
          ["<Leader>ot"] = "OpenFileInWorktree",

          ["<Leader>qY"] = "OpenTree",

          ["<CR>"] = "GoToFile",
          ["<s-cr>"] = "PeekFile",
          ["<c-v>"] = "VSplitOpen",
          ["<c-x>"] = "SplitOpen",
          ["<c-t>"] = "TabOpen",

          ["g?"] = "HelpPopup",
        },

        commit_editor = {
          ["q"] = "Close",
          ["<c-c><c-c>"] = "Submit",
          ["<c-c><c-k>"] = "Abort",
          ["<m-p>"] = "PrevMessage",
          ["<m-n>"] = "NextMessage",
          ["<m-r>"] = "ResetMessage",
        },

        rebase_editor = {
          ["q"] = false,
          ["<Esc>"] = false,
        },
        status = { -- NeogitStatus
          ["<Esc>"] = false,
          ["q"] = false,
          ["<c-x>"] = false,
          ["Y"] = false,
          ["o"] = false,

          -- equal to fold mapping
          ["zM"] = "Depth1",
          ["zR"] = "Depth4",

          -- ["<C-n>"] = false,
          -- ["<c-p>"] = false,

          ["<Leader>oe"] = "GoToFile",
          ["<Leader>ov"] = "VSplitOpen",
          ["<Leader>os"] = "SplitOpen",
          ["<Leader>ot"] = "TabOpen",
          ["<c-s>"] = "SplitOpen", -- alternative to open
          ["<c-v>"] = "VSplitOpen",
          ["<c-t>"] = "TabOpen",

          ["<LocalLeader>qP"] = "PeekFile",
          ["<LocalLeader>qy"] = "YankSelected",
          ["<LocalLeader>qO"] = "OpenTree",

          ["<LocalLeader>qY"] = "OpenTree",

          ["<c-n>"] = "GoToNextHunkHeader",
          ["<c-p>"] = "GoToPreviousHunkHeader",

          ["R"] = "RefreshBuffer",
        },
        finder = {
          ["<Esc>"] = false,
          ["<c-c>"] = false,
          ["<esc>"] = false,
        },
        popup = {
          ["<Esc>"] = false,
          ["t"] = false,
          ["m"] = false,
          ["w"] = false,
          ["l"] = false,
          ["L"] = false,
          ["v"] = false,
          ["d"] = false,
          ["<esc>"] = false,
          ["?"] = false,
          ["b"] = false,
          ["B"] = false,
          ["M"] = false,
          ["Z"] = false,
          ["o"] = false,

          ["<LocalLeader>qot"] = "TagPopup",
          ["<LocalLeader>qom"] = "MergePopup",
          ["<LocalLeader>qoM"] = "MarginPopup",
          ["<LocalLeader>qor"] = "RemotePopup",
          ["<LocalLeader>qow"] = "WorktreePopup",
          ["<LocalLeader>qoR"] = "RevertPopup",
          ["<LocalLeader>qod"] = "DiffPopup",
          ["<LocalLeader>qob"] = "BranchPopup",
          ["<LocalLeader>qoB"] = "BisectPopup",
          ["<LocalLeader>qos"] = "StashPopup",

          ["<LocalLeader>ql"] = "LogPopup",

          ["g?"] = "HelpPopup",
        },
      },
      integrations = {
        diffview = true,
        telescope = false,
        fzf_lua = true,
      },
    },
  },
}

UtilKey.nnoremap("<Leader>gg", function()
  UtilKey.plugin_load_now "neogit"
  vim.cmd.Neogit()
  vim.cmd "wincmd ="
end)
