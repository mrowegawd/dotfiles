return {
  { "lambdalisue/suda.vim", cmd = { "SudaWrite", "SudaRead" } }, -- sudo
  { "dstein64/vim-startuptime", cmd = "StartupTime" },
  -- NUMB-NVIM
  {
    "nacro90/numb.nvim",
    event = "CmdlineEnter",
    config = true,
  },
  -- UNDOTREE
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = { { "<leader>u", "<Cmd>UndotreeToggle<CR>", desc = "undotree: toggle" } },
    config = function()
      vim.g.undotree_TreeNodeShape = "◦" -- Alternative: '◉'
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
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
  -- VIM-HIGHLIGHTER
  -- https://github.com/t9md/vim-quickhl (alternative)
  {
    "azabiong/vim-highlighter",
    event = "LazyFile",
    keys = {
      {
        "<c-Down>",
        "<CMD> Hi} <CR>",
        desc = "Misc(vim-highlighter): next",
      },
      {
        "<c-Up>",
        "<CMD> Hi{ <CR>",
        desc = "Misc(vim-highlighter): prev",
      },
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
  -- NVIM-CHEAT
  {
    "RishabhRD/nvim-cheat.sh",
    cmd = { "Cheat", "CheatWithoutComments", "CheatList", "CheatListWithoutComments" },
    dependencies = {
      "RishabhRD/popfix",
    },
    config = function()
      vim.g.cheat_default_window_layout = "vertical_split"
    end,
  },
}
