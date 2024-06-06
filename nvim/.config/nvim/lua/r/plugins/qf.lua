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
    },
  },
}
