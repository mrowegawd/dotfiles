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
          ["<Esc>"] = false,
          ["o"] = false,
          ["q"] = false,

          ["<Leader>oe"] = "GoToFile",
          ["<Leader>ov"] = "OpenFileInWorktree",
          ["<Leader>os"] = "OpenFileInWorktree",
          ["<Leader>ot"] = "OpenFileInWorktree",

          ["<Leader>qY"] = "OpenTree",

          ["<s-cr>"] = "PeekFile",
          ["<C-v>"] = "VSplitOpen",
          ["<C-s>"] = "SplitOpen",
          ["<C-t>"] = "TabOpen",
          ["<CR>"] = "GoToFile",

          ["g?"] = "HelpPopup",
        },

        commit_editor = {
          ["q"] = "Close",
          ["<C-x><C-x>"] = "Submit",
          ["<C-x><C-k>"] = "Abort",
          ["<m-p>"] = "PrevMessage",
          ["<m-n>"] = "NextMessage",
          ["<m-r>"] = "ResetMessage",
        },

        rebase_editor = {
          ["<Esc>"] = false,
          ["q"] = false,
        },
        status = { -- NeogitStatus
          ["<Esc>"] = false,
          ["<C-x>"] = false,
          ["q"] = false,
          ["Y"] = false,
          ["o"] = false,

          -- equal to fold mapping
          ["zM"] = "Depth1",
          ["zR"] = "Depth4",
          ["zO"] = "Depth4",

          ["<Leader>oe"] = "GoToFile",
          ["<Leader>ov"] = "VSplitOpen",
          ["<Leader>os"] = "SplitOpen",
          ["<Leader>ot"] = "TabOpen",
          ["<C-s>"] = "SplitOpen", -- alternative to open
          ["<C-v>"] = "VSplitOpen",
          ["<C-t>"] = "TabOpen",

          ["<C-a>pp"] = "PeekFile",
          ["<C-a>y"] = "YankSelected",
          ["<C-a>ob"] = "OpenTree",

          ["<C-n>"] = "GoToNextHunkHeader",
          ["<C-p>"] = "GoToPreviousHunkHeader",

          ["R"] = "RefreshBuffer",
          ["<C-x>R"] = "RefreshBuffer",
        },
        finder = {
          ["<Esc>"] = false,
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

          ["<C-x>ot"] = "TagPopup",
          ["<C-x>om"] = "MergePopup",
          ["<C-x>oM"] = "MarginPopup",
          ["<C-x>or"] = "RemotePopup",
          ["<C-x>ow"] = "WorktreePopup",
          ["<C-x>oR"] = "RevertPopup",
          ["<C-x>od"] = "DiffPopup",
          ["<C-x>oc"] = "BranchPopup",
          ["<C-x>oB"] = "BisectPopup",
          ["<C-x>os"] = "StashPopup",

          ["<C-x>ol"] = "LogPopup",

          ["g?"] = "HelpPopup",
          ["<C-x>?"] = "HelpPopup",
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
      { "<C-x>y", name = "yank selected", buffer = ev.buf },
      { "<C-x>o", group = "open", buffer = ev.buf },
      { "<C-x>ot", group = "TagPopup", buffer = ev.buf },
      { "<C-x>om", name = "MergePopup", buffer = ev.buf },
      { "<C-x>oM", name = "MerginPopup", buffer = ev.buf },
      { "<C-x>ow", name = "WorktreePopup", buffer = ev.buf },
      { "<C-x>or", name = "RemotePopup", buffer = ev.buf },
      { "<C-x>oR", name = "RevertPopup", buffer = ev.buf },
      { "<C-x>od", name = "DiffPopup", buffer = ev.buf },
      { "<C-x>oc", name = "BranchPopup", buffer = ev.buf },
      { "<C-x>oB", name = "BisectPopup", buffer = ev.buf },
      { "<C-x>os", name = "StagsPopup", buffer = ev.buf },

      { "<C-x>ob", name = "Browse this worktree", buffer = ev.buf },

      { "<C-x>ol", name = "LogPopup", buffer = ev.buf },
      { "<C-x>?", name = "help", buffer = ev.buf },
    }
  end,
})
