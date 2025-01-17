return {
  recommended = {
    ft = { "gitcommit", "gitconfig", "gitrebase", "gitignore", "gitattributes" },
  },
  -- Treesitter git support
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "git_config", "git_rebase", "gitignore", "gitattributes" } },
  },
  -- cmp.setup.filetype({ "gitcommit", "NeogitPopup", "NeogitCommitMessage" }, { sources = vim.tbl_deep_extend("force", {}, tbl_custom_sources, { { name = "git" } }),
  -- })

  {
    "nvim-cmp",
    optional = true,
    dependencies = {
      { "petertriho/cmp-git", opts = {} },
    },
    ---@module 'cmp'
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, { name = "git" })
    end,
  },
}
