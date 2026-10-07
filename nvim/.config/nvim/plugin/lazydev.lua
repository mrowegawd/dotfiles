local add = require("vim-pack").add_on_file_type

add("lua", {
  {
    src = "folke/lazydev.nvim",
    -- cond = not vim.g.vscode,
    -- ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
      },
    },
    -- config = function(_, opts)
    --   require("lazydev").setup(opts)
    -- end,
  },
})
