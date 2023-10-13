return {
  -- TREESITTER
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "bash" })
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {},
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "beautysh", "shfmt" })
    end,
  },

  {
    "mfussenegger/nvim-dap",
    opts = {
      adapters = {
        "bash-debug-adapter",
      },
    },
  },
}
