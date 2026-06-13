return {
  -- ARBORIST
  {
    "arborist-ts/arborist.nvim",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
    },
    opts = {
      update_cadence = "manual",
      ignore = {
        "orgagenda",
        "org",
        "snacks_input",
        "image",
        "ergoterm",
        "cfg",
        "conf",
        "zsh",
        "tmux",
        "dircolors",
        "DiffviewFiles",
        "octo",
        "neo-tree",
      },
      disable = {
        indent = { "tsx" },
      },
      ensure_installed = { "lua" },
    },
    config = function(_, opts)
      require("arborist").setup(opts)
      require("nvim-treesitter-textobjects").setup()

      -- Select
      vim.keymap.set({ "x", "o" }, "af", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "if", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
      end)
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = "LazyFile",
    opts = {},
  },
}
