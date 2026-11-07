local add = require("vim-pack").add

add {
  {
    src = "CoreyKaylor/diffbandit.nvim",
    opts = {
      git = {
        file_keys = {
          next = "gn",
          prev = "gp",
        },
        panel = {
          staged_indicator = {
            unstaged = "□",
            partial = "◧",
            staged = "▣",
          },
          keys = {
            toggle_stage = "<Leader>gs",
            focus_diff = "<CR>",
            focus_panel = "<Leader>op",
            focus_commit = "cc",
            file_actions = "<Leader>ca",
            toggle_amend = "<Leader>gA",
            refresh = "<C-c>R",
            toggle_panel = "<Leader>oo",
            close = "q",
          },
        },
      },
      folder = {
        keys = {
          open = "<CR>",
          alternate_open = "o",
          toggle_expand = "<TAB>",
          alternate_toggle_expand = "za",
          expand_all = "zR",
          collapse_all = "zM",
          next_diff = "]c",
          prev_diff = "[c",
          refresh = "<C-c>R",
          filter = "<C-c>F",
          close = "q",
        },
      },
      actions = {
        keys = {
          toggle_stage = "<Leader>gs",
          apply_left = ">>",
          apply_right = "<<",
          undo = "<Leader>gr",
        },
      },
      merge = {
        keys = {
          next_conflict = "<C-c><C-n>",
          prev_conflict = "<C-c><C-p>",
          accept_local = "<C-c>c1",
          accept_remote = "<C-c>c3",
          accept_both = "<C-c>c2",
          apply_non_conflicting = "gA",
          focus_panel = "<Leader>op",
          snap = "]s",
          toggle_panel = "<Leader>oo",
          toggle_local = "gzh",
          toggle_remote = "gzl",
          show_all = "gza",
          close = "q",
        },
      },
    },
  },
}
