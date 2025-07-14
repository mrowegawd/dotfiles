return {
  -- QUICKER
  { -- bisa menggunakan range -> %s/, jangan lupa di 'write' setelah delete range
    "stevearc/quicker.nvim",
    event = "FileType qf",
    opts = { borders = { vert = "│" } },
  },
  -- QFSILET
  {
    "mrowegawd/qfsilet",
    event = "LazyFile", -- use `LazyFile` agar sign mark bisa di load dgn benar
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
    keys = {
      { "mm" },
      -- { "mt" },
      { "<Leader>fn" },
      { "<Leader>fN" },
      { "<Leader>fp" },
      -- { "mn" },
      { "mf" },
      { "<Leader>wn" },
      { "<Leader>wp" },
      {
        "<Leader>oq",
        "<CMD>SaveQf<CR>",
        desc = "OPEN: save qf [qfsilet]",
      },
      {
        "<Leader>oQ",
        "<CMD>LoadQf<CR>",
        desc = "OPEN: load qf [qfsilet]",
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
      theme_list = { enabled = false },
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
