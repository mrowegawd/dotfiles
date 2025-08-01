return {
  -- QUICKER
  { -- bisa menggunakan range -> %s/, jangan lupa di 'write' setelah delete range
    "stevearc/quicker.nvim",
    event = "FileType qf",
    opts = {},
  },
  -- QFSILET
  {
    "mrowegawd/qfsilet",
    -- dir = "~/.local/src/nvim_plugins/qfsilet",
    event = "LazyFile", -- use `LazyFile` agar sign mark bisa di load dgn benar
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
    keys = {
      { "T" },
      { "qq" },
      { "ql" },
      { "<Leader>qf" },
      { "<Leader>fn" },
      { "<Leader>fN" },
      { "<Leader>fp" },
      { "<Leader>qc" },
      { "mf" },
      { "<Leader>wn" },
      { "<Leader>wp" },
      {
        "<Leader>qK",
        function()
          local _qf = RUtils.cmd.windows_is_opened { "qf" }
          if _qf.found then
            if RUtils.qf.is_loclist() then
              vim.cmd "lclose"
              vim.cmd "wincmd p"
              vim.cmd "aboveleft lopen"
            else
              vim.cmd "cclose"
              vim.cmd "wincmd p"
              vim.cmd "aboveleft copen"
            end
          end
        end,
        ft = "qf",
        desc = "Qf: force open above left [qfsilet]",
      },
      {
        "<Leader>qJ",
        function()
          local _qf = RUtils.cmd.windows_is_opened { "qf" }
          if _qf.found then
            if RUtils.qf.is_loclist() then
              vim.cmd "lclose"
              vim.cmd "wincmd p"
              vim.cmd "belowright lopen"
            else
              vim.cmd "cclose"
              vim.cmd "wincmd p"
              vim.cmd "belowright copen"
            end
          end
        end,
        ft = "qf",
        desc = "Qf: force open below right [qfsilet]",
      },
      -- {
      --   "<Leader>qJ",
      --   function()
      --     vim.cmd(RUtils.cmd.quickfix.copen)
      --     vim.cmd "wincmd p"
      --   end,
      --   desc = "Qf: force copen [qfsilet]",
      -- },
      -- {
      --   "<Leader>qL",
      --   function()
      --     vim.cmd(RUtils.cmd.quickfix.lopen)
      --     vim.cmd "wincmd p"
      --   end,
      --   desc = "Qf: force lopen [qfsilet]",
      -- },
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

          add_item_to_qf = "qq",
          add_item_to_loc = "ql",
        },
        todo = {
          add_local = "<Leader>fp",
          add_global = "<Leader>fn",
          add_message = "<Leader>fN",

          add_link_capture = "<leader>qc",
          goto_link_capture = "g<cr>",
        },
        marks = {
          toggle_mark = "T",
          fzf_marks = "<Leader>qf",
          next_mark = "<Leader>wn",
          prev_mark = "<Leader>wp",
        },
      },
    },
  },
}
