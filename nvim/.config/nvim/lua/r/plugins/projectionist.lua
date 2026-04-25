return {
  -- OTHER.NVIM
  {
    "rgroli/other.nvim",
    keys = {
      { "<Leader>AA", "<CMD>Other<CR>", desc = "Alternate: edit [other.nvim]" },
      { "<Leader>AV", "<Cmd>OtherVSplit`<CR>", desc = "Alternate: vsplit [other.nvim]" },
      { "<Leader>AS", "<Cmd>OtherSplit<CR>", desc = "Alternate: split test [other.nvim]" },
      { "<Leader>AT", "<Cmd>OtherTabNew<CR>", desc = "Alternate: tab test [other.nvim]" },
    },
    config = function()
      require("other-nvim").setup {
        mappings = {
          {
            pattern = "/src/(.*)/(.*).py$",
            target = "/tests/test_%2.py",
            context = "source", -- optional
          },
          {
            pattern = "/tests/(.*).py$",
            target = "/src/*/%1.py",
            context = "tests",
          },
        },
      }
    end,
  },
}
