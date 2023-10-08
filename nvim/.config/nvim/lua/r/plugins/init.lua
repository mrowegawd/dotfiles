return {
  -- NUI
  { "MunifTanjim/nui.nvim", lazy = true }, -- jangan di delete, karena di utils.init masih yang menggunakan
  { "nvim-lua/plenary.nvim", lazy = true },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  -- VIM-LOG
  { "mtdl9/vim-log-highlighting", lazy = false },
  -- SUDA
  { "lambdalisue/suda.vim", cmd = { "SudaWrite", "SudaRead" } },
  -- TASKWARRIOR SYNTAX
  { "framallo/taskwarrior.vim", ft = "taskrc" },
  -- NVIM-TS-COMMENTSTRING
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    opts = {
      enable_autocmd = false,
    },
  },
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
  -- HYPERSONIC.NVIM (make regex readable)
  {
    "tomiis4/Hypersonic.nvim",
    cmd = { "Hypersonic" },
    config = true,
  },
  -- SG.NVIM (disabled)
  {
    "sourcegraph/sg.nvim",
    event = "VeryLazy",
    enabled = false,
    opts = {},
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  -- NEOZOOM
  {
    "nyngwang/NeoZoom.lua",
    keys = {
      { "<Leader>rm", "<CMD>NeoZoomToggle<CR>", desc = "Misc(neozoom): toggle" },
    },
    opts = {
      scrolloff_on_enter = 7,
      exclude_buftypes = { "terminal" },
    },
  },
  -- UNDOTREE
  {
    "mbbill/undotree",
    keys = {
      { "<Leader>ru", "<CMD>UndotreeToggle<CR>", desc = "Misc(undotreetoggle): show" },
    },
    init = function()
      vim.g.undotree_SplitWidth = 35
      vim.g.undotree_DiffpanelHeight = 7
      vim.g.undotree_WindowLayout = 2 -- Tree on the left, diff on the bottom

      vim.g.undotree_TreeNodeShape = "◉"
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  },
  -- GKEEP
  {
    -- Check and run: `python3 -m pip install gkeepapi keyring`
    "stevearc/gkeep.nvim",
    build = ":UpdateRemotePlugins",
    cmd = "GkeepToggle",
    event = "BufReadPre gkeep://*",
  },
  -- OUTPUT-PANEL
  {
    "mhanberg/output-panel.nvim",
    event = "VeryLazy",
    keys = { { "<leader>rO", "<cmd>OutputPanel<CR>", desc = "Misc(outputpanel): open" } },
    config = true,
  },
  -- STICKYBUF.NVIM
  {
    "stevearc/stickybuf.nvim",
    enabled = false,
    event = "VeryLazy",
    config = function()
      require("stickybuf").setup()
    end,
  },
  -- NREDIR
  {
    -- Redirect output of vim or external command into scratch buffer,
    -- awesome plugin!
    "sbulav/nredir.nvim",
    cmd = { "Nredir" },
  },
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                        MY PLUGINS                        │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    dir = "~/.local/src/nvim_plugins/nvim-ui-conf",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
  },
}
