return {
  -- QFSILET
  {
    dir = "~/.local/src/nvim_plugins/qfsilet",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      save_dir = RUtils.config.path.wiki_path .. "/orgmode/project-todo",
      extmarks = {
        qf_sigil = RUtils.config.icons.misc.marks,
        qf_sign_hl = { fg = "red" },
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
            "calendar",
            "checkhealth",
            "dashboard",
            "fzf",
            "gitcommit",
            "help",
            "lazy",
            "lspinfo",
            "make",
            "man",
            "markdown",
            "mason",
            "neo-tree",
            "neorg",
            "norg",
            "org",
            "orgagenda",
            "sagafinder",
            "trouble",
          },
        },
      },
      keymap = {
        todo = {
          add_todo = "mt",
        },
      },
    },
  },
}
