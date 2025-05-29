return {
  -- TREESITTER
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "css", "html", "http", "scss", "nginx" } },
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
