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

  {
    "mason-org/mason.nvim",
    optional = true,
    opts = { ensure_installed = { "taplo" } },
  },
}
