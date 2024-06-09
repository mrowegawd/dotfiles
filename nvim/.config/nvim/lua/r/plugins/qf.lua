return {
  -- QFSILET
  {
    dir = "~/.local/src/nvim_plugins/qfsilet",
    event = "VimEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      save_dir = RUtils.config.path.home .. "/Dropbox/neorg/orgmode/project-todo",
      extmarks = {
        qf_sigil = RUtils.config.icons.misc.marks,
      },
      marks = {
        excluded = {
          buftypes = {},
          filetypes = {
            "DiffviewFiles",
            "NeogitCommitMessage",
            "calendar",
            "neo-tree",
            "NeogitPopup",
            "NeogitStatus",
            "NvimTree",
            "Outline",
            "TelescopePrompt",
            "TelescopeResults",
            "alpha",
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
