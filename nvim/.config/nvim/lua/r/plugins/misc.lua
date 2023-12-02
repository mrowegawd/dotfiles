return {
  -- NUI
  { "MunifTanjim/nui.nvim" }, -- jangan di delete, karena di utils.init masih yang menggunakan
  { "nvim-lua/plenary.nvim" },
  { "nvim-tree/nvim-web-devicons" },
  -- VIM-LOG
  { "mtdl9/vim-log-highlighting", lazy = false },
  -- SUDA
  { "lambdalisue/suda.vim", cmd = { "SudaWrite", "SudaRead" } },
  -- TASKWARRIOR SYNTAX
  { "framallo/taskwarrior.vim", ft = "taskrc" },
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
  -- HYPERSONIC.NVIM (make regex readable) (disabled)
  {
    "tomiis4/Hypersonic.nvim",
    cmd = { "Hypersonic" },
    enabled = false,
    config = true,
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
  -- GKEEP
  {
    -- Check and run: `python3 -m pip install gkeepapi keyring`
    "stevearc/gkeep.nvim",
    build = ":UpdateRemotePlugins",
    cmd = { "GkeepToggle" },
    -- event = "BufReadPre gkeep://*",
  },
  -- OUTPUT-PANEL
  {
    "mhanberg/output-panel.nvim",
    event = "VeryLazy",
    keys = { { "<Localleader>oo", "<cmd>OutputPanel<CR>", desc = "Misc(outputpanel): open" } },
    config = true,
  },
  -- NREDIR
  {
    -- Redirect output of vim or external command into scratch buffer,
    "sbulav/nredir.nvim",
    cmd = { "Nredir" },
  },
}
