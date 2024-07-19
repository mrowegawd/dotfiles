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

  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = {
  --     servers = {
  --       -- emmet_ls = {},
  --       html = {},
  --       -- cssls = {}, -- berat wkwkwkw
  --       -- cssls = {
  --       --   settings = {
  --       --     css = {
  --       --       lint = {
  --       --         unknownAtRules = "ignore",
  --       --       },
  --       --     },
  --       --     scss = {
  --       --       lint = {
  --       --         unknownAtRules = "ignore",
  --       --       },
  --       --     },
  --       --   },
  --       -- },
  --     },
  --   },
  -- },
}
