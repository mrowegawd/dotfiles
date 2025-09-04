return {
  recommended = function()
    return RUtils.extras.wants {
      ft = "toml",
      root = "*.toml",
    }
  end,
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      taplo = {},
    },
  },
}
