return {
  -- NVIM-BQF (disabled)
  {
    "kevinhwang91/nvim-bqf",
    enabled = false,
    event = "FileType qf",
    opts = {
      preview = {
        auto_preview = false,
        win_height = 20,
      },
      func_map = {
        open = "",
        openc = "",
        drop = "",
        split = "",
        vsplit = "",
        tab = "",
        tabb = "",
        tabc = "",
        tabdrop = "",
        ptogglemode = "zp",
        ptoggleitem = "p",
        ptoggleauto = "<a-p>",
        pscrollup = "<C-u>",
        pscrolldown = "<C-d>",
        pscrollorig = "zo",
        prevfile = "",
        nextfile = "",
        prevhist = "",
        nexthist = "",
        lastleave = "",
        stoggleup = "",
        stoggledown = "<Tab>",
        stogglevm = "<Tab>",
        stogglebuf = "",
        sclear = "",
        filter = "",
        filterr = "",
        fzffilter = "",
      },
    },
  },
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
      { "tt" },
      { "ty" },

      { "<Leader>fN" },
      { "<Leader>fn" },
      { "<Leader>fp" },

      { "<Leader>qq" }, -- save
      { "<Leader>qy" }, -- load

      { "<Leader>qb" }, -- mark
      { "<Leader>qf" }, -- select mark fzf
      { "<Leader>qc" }, -- copy

      { "<a-k>" }, -- move win to above
      { "<a-j>" }, -- move win to bottom
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
          copen = RUtils.qf.copen,
          lopen = RUtils.qf.lopen,
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
          save_local = "<Leader>qq",
          load_local = "<Leader>qy",

          toggle_open_qf = "<Leader>qj",
          toggle_open_loclist = "<Leader>ql",

          add_item_to_qf = "tt",
          add_item_to_loc = "ty",
        },
        todo = {
          add_local = "<Leader>fp",
          add_global = "<Leader>fn",
          add_message = "<Leader>fN",

          add_link_capture = "<leader>qc",
          goto_link_capture = "g<cr>",
        },
        marks = {
          toggle_mark = "<Leader>qb",
          fzf_marks = "<Leader>qf",
          next_mark = "<Leader>qn",
          prev_mark = "<Leader>qp",
        },
      },
    },
  },
}
