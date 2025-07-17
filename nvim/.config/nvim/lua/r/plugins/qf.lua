return {
  -- QUICKER
  { -- bisa menggunakan range -> %s/, jangan lupa di 'write' setelah delete range
    "stevearc/quicker.nvim",
    event = "FileType qf",
    opts = { borders = { vert = "│" } },
  },
  -- QFSILET
  {
    -- "mrowegawd/qfsilet",
    dir = "~/.local/src/nvim_plugins/qfsilet",
    event = "LazyFile", -- use `LazyFile` agar sign mark bisa di load dgn benar
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
    keys = {
      { "mm" },
      { "<Leader>fn" },
      { "<Leader>fN" },
      { "<Leader>fp" },
      { "mf" },
      { "<Leader>wn" },
      { "<Leader>wp" },
      {
        "<Leader>qJ",
        function()
          vim.cmd(RUtils.cmd.quickfix.copen)
          vim.cmd "wincmd p"
        end,
        desc = "Qf: force copen [qfsilet]",
      },
      {
        "<Leader>qL",
        function()
          vim.cmd(RUtils.cmd.quickfix.lopen)
          vim.cmd "wincmd p"
        end,
        desc = "Qf: force lopen [qfsilet]",
      },
    },
    opts = {
      save_dir = RUtils.config.path.wiki_path .. "/orgmode/project-todo",
      extmarks = {
        qf_sigil = RUtils.config.icons.misc.marks,
        qf_sign_hl = { fg = "red" },
      },
      popup = {
        title_local = "TODO LIST",
        title_global = "MESSAGE BOX",
        winhighlight = "Normal:NormalBoxComment,FloatBorder:FloatBoxComment,EndOfBuffer:NormalBoxComment,Visual:VisualBoxComment",
        higroup_title = "FzfLuaPreviewTitle",
      },
      theme_list = {
        enabled = false,
        quickfix = {
          copen = RUtils.cmd.quickfix.copen,
          lopen = RUtils.cmd.quickfix.lopen,
        },
      },
      marks = {
        excluded = {
          buftypes = {},
          filetypes = {
            "DiffviewFiles",
            "NeogitCommitMessage",
            "NeogitPopup",
            "NeogitStatus",
            "NvimTree",
            "Outline",
            "TelescopePrompt",
            "TelescopeResults",
            "alpha",
            "calendar",
            "checkhealth",
            "dashboard",
            "fugitive",
            "fzf",
            "gitcommit",
            "help",
            "lazy",
            "lspinfo",
            "man",
            "mason",
            "neo-tree",
            "orgagenda",
            "sagafinder",
            "trouble",
          },
        },
      },
      keymap = {
        quickfix = {
          save_local = "<Leader>qs",
          load_local = "<Leader>qS",

          toggle_open_qf = "<Leader>qj",
          toggle_open_loclist = "<Leader>ql",

          add_item_to_qf = "<Leader>qy",
          add_item_to_loc = "<Leader>qo",
        },
        todo = {
          add_local = "<Leader>fp",
          add_global = "<Leader>fn",
          add_message = "<Leader>fN",

          add_link_capture = "mc",
          goto_link_capture = "g<cr>",
        },
        marks = {
          next_mark = "<Leader>wn",
          prev_mark = "<Leader>wp",
        },
      },
    },
  },
}
