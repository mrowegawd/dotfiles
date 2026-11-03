local add = require("vim-pack").add

local lazy = require("utils.plugin").require_lazy

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

          ["<C-c>pp"] = "PeekFile",
          ["<C-c>y"] = "YankSelected",
          ["<C-c>ob"] = "OpenTree",

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

          ["<C-c>ot"] = "TagPopup",
          ["<C-c>om"] = "MergePopup",
          ["<C-c>oM"] = "MarginPopup",
          ["<C-c>or"] = "RemotePopup",
          ["<C-c>ow"] = "WorktreePopup",
          ["<C-c>oR"] = "RevertPopup",
          ["<C-c>od"] = "DiffPopup",
          ["<C-c>oc"] = "BranchPopup",
          ["<C-c>oB"] = "BisectPopup",
          ["<C-c>os"] = "StashPopup",

          ["<C-c>ol"] = "LogPopup",

          ["g?"] = "HelpPopup",
          ["<c-c>?"] = "HelpPopup",
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

local UtilKey = lazy "utils.map"
local UtilAugroup = lazy("utils.map").augroup

UtilKey.nnoremap("<Leader>gg", function()
  UtilKey.plugin_load_now "neogit"
  vim.cmd.Neogit()
  vim.cmd "wincmd ="
end)

local whichkey = lazy "which-key"

UtilAugroup("neogit", {
  event = "FileType",
  pattern = "NeogitStatus",
  command = function(ev)
    whichkey.add {
      { "<C-c>y", group = "help", buffer = ev.buf },
      { "<C-c>o", group = "open", buffer = ev.buf },
      { "<C-c>ot", group = "TagPopup", buffer = ev.buf },
      { "<C-c>om", name = "MergePopup", buffer = ev.buf },
      { "<C-c>oM", name = "MerginPopup", buffer = ev.buf },
      { "<C-c>ow", name = "WorktreePopup", buffer = ev.buf },
      { "<C-c>or", name = "RemotePopup", buffer = ev.buf },
      { "<C-c>oR", name = "RevertPopup", buffer = ev.buf },
      { "<C-c>od", name = "DiffPopup", buffer = ev.buf },
      { "<C-c>oc", name = "BranchPopup", buffer = ev.buf },
      { "<C-c>oB", name = "BisectPopup", buffer = ev.buf },
      { "<C-c>os", name = "StagsPopup", buffer = ev.buf },

      { "<C-c>ob", name = "Browse this worktree", buffer = ev.buf },

      { "<C-c>ol", name = "LogPopup", buffer = ev.buf },
      { "<C-c>?", name = "help", buffer = ev.buf },
    }
  end,
})
