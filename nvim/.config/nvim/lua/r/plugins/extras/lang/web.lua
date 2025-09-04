return {
  -- TREESITTER
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "css", "html", "http", "scss", "nginx", "htmldjango" } },
  },

  -- Formatter for html django
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "djlint" } },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = { formatters_by_ft = { htmldjango = { "djlint" } } },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        emmet_language_server = {},
        html = { filetypes = { "html", "htmldjango" } },
        -- cssls = {
        --   settings = {
        --     css = {
        --       lint = {
        --         unknownAtRules = "ignore",
        --       },
        --     },
        --     scss = {
        --       lint = {
        --         unknownAtRules = "ignore",
        --       },
        --     },
        --   },
        -- },
      },
    },
  },
}
