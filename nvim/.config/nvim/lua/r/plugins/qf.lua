return {
  -- NVIM-BQF
  {
    "kevinhwang91/nvim-bqf",
    ft = { "qf" },
    dependencies = {
      "junegunn/fzf",
    },
    opts = {
      preview = {
        auto_preview = false,
        show_title = true,
        wrap = true,
        buf_label = true,
        should_preview_cb = nil,
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
        pscrollup = "<c-u>",
        pscrolldown = "<c-d>",
        prevfile = "",
        nextfile = "",
        sclear = "z<Tab>",
        filter = "zn",
        filterr = "zN",
        fzffilter = "zf",
      },
      filter = {
        fzf = {
          action_for = {
            ["ctrl-s"] = "split",
            ["ctrl-t"] = "tab drop",
          },
          extra_opts = {
            "+i",
            "--bind",
            "ctrl-o:toggle-all",
            "--prompt",
            "> ",
          },
        },
      },
    },
  },
  -- QFSILET
  {
    dir = "~/.local/src/nvim_plugins/qfsilet",
    event = "LazyFile",
    opts = {
      ext_note = "",
      signs = {
        priority = 10,
      },
    },
  },
}
