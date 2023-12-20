return {
  -- TRANSLATE.NVIM
  {
    "uga-rosa/translate.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<Leader>rs",
        "y<ESC>:Translate id<CR>",
        desc = "Translate: toggle translate it (visual)",
        mode = { "v" },
      },
    },
    config = function()
      require("translate").setup {
        default = {
          command = "google",
        },
        preset = {
          output = {
            insert = {
              base = "top",
              off = -1,
            },
          },
        },
      }
    end,
  },
}
