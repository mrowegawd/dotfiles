return {
  -- TREESITTER
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "css", "html", "http", "scss" })
      end
    end,
  },
  -- NVIM-LSPCONFIG
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- emmet_language_server = dots.languages.web.emmet == "olrtg" and {} or nil,
        -- emmet_ls = {},
        html = {},
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
