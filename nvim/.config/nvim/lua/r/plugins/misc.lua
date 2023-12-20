return {
  { "MunifTanjim/nui.nvim" },
  { "nvim-lua/plenary.nvim" },
  { "nvim-tree/nvim-web-devicons" },
  { "lambdalisue/suda.vim", cmd = { "SudaWrite", "SudaRead" } }, -- sudo

  -- NUMB-NVIM
  {
    "nacro90/numb.nvim",
    event = "CmdlineEnter",
    config = true,
  },
  -- COMMENT-BOX
  {
    "LudoPinelli/comment-box.nvim",
    cmd = {
      "CBlcbox",
      "CBllbox",
      "CBlcbox",
      "CBlrbox",
      "CBclbox",
      "CBccbox",
      "CBcrbox",
      "CBrlbox",
      "CBrcbox",
      "CBalbox",
      "CBacbox",
      "CBarbox",
      "CBcatalog",
    },
  },
  -- SG.NVIM
  {
    "sourcegraph/sg.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    -- You must do this first before using it:
    -- jika belum login, gunakan `:SourcegraphLogin`
    keys = {
      {
        "<Localleader>og",
        "<CMD> lua require('sg.extensions.telescope').fuzzy_search_results() <CR>",
        desc = "Misc(sq): search",
      },
    },
    opts = {},
  },
  -- GKEEP (disabled)
  -- {
  --   -- Check and run: `python3 -m pip install gkeepapi keyring`
  --   "stevearc/gkeep.nvim",
  --   enabled = false,
  --   build = ":UpdateRemotePlugins",
  --   cmd = { "GkeepToggle" },
  --   -- event = "BufReadPre gkeep://*",
  -- },
  -- NREDIR
  {
    -- Redirect output of vim or external command into scratch buffer,
    "sbulav/nredir.nvim",
    cmd = { "Nredir" },
  },
}
