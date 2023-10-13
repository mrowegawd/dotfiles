return {
  -- NVIM-BQF
  {
    "kevinhwang91/nvim-bqf",
    dependencies = {
      "junegunn/fzf",
    },
    ft = { "qf" },
    opts = {
      preview = {
        auto_preview = false,
        show_title = true,
        wrap = false,
        buf_label = true,
        should_preview_cb = nil,
        win_height = 12,
        win_vheight = 12,
        delay_syntax = 80,
      },
      -- make `drop` and `tab drop` to become preferred
      func_map = {
        drop = "o",
        openc = "O",
        split = "<C-s>",
        vsplit = "<C-v>",
        tabdrop = "<C-t>",
        tabc = "",
        tab = "",
        ptogglemode = "p",
        ptoggleauto = "P",

        ptoggleitem = "",
        -- pscrollup = "<a-u>",
        -- pscrolldown = "<a-d>",
        prevfile = "",
        nextfile = "",
        sclear = "z<Tab>",
        filter = "zn",
        filterr = "zN",
        fzffilter = "<c-f>",
      },
      filter = {
        fzf = {
          action_for = {
            ["ctrl-s"] = "split",
            ["ctrl-t"] = "tab drop",
          },
          extra_opts = {
            "--bind",
            "ctrl-o:toggle-all",
            "--prompt",
            "> ",
          },
        },
      },
    },
  },
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                        MY PLUGINS                        │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    dir = "~/.local/src/nvim_plugins/qfsilet",
    event = "BufRead",
    keys = {
      { "<Localleader>ql", "<CMD>LoadQFProject<CR>", desc = "Qf(qfsilet): load project" },
      { "<Localleader>qL", "<CMD>LoadQFGlobal<CR>", desc = "Qf(qfsilet): load global" },
      { "<Localleader>qs", "<CMD>SaveQFProject<CR>", desc = "Qf(qfsilet): save project" },
      { "<Localleader>qS", "<CMD>SaveQFGlobal<CR>", desc = "Qf(qfsilet): save global" },
    },
    opts = {
      ext_note = "",
      signs = {
        priority = 10,
      },
      popup = {
        winhighlight = "Normal:Pmenu,FloatBorder:FzfLuaBorder",
      },
    },
  },
}
