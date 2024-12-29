return {
  -- STARTUPTIME
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },
  -- NUMB-NVIM
  {
    "nacro90/numb.nvim",
    event = "CmdlineEnter",
    config = true,
  },
  -- TABULARIZE
  {
    "godlygeek/tabular", -- tabularize lines of code
    cmd = "Tabularize",
  },
  -- UNDOTREE
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<Leader>uu", ":UndotreeToggle<cr>", desc = "Toggle: undotree [undotree]" },
    },
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
      "CBccline",
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
  {
    -- https://github.com/t9md/vim-quickhl (alternative)
    "azabiong/vim-highlighter",
    event = "LazyFile",
    cmd = { "Hi", "HI" },
    keys = {
      {
        "<c-Down>",
        "<CMD> Hi} <CR>",
        desc = "Misc: next highlighter [vim-highlighter]",
      },
      {
        "<c-Up>",
        "<CMD> Hi{ <CR>",
        desc = "Misc: prev [vim-highlighter]",
      },
      {
        "t<CR>",
        ":Hi + <CR>",
        desc = "Misc: highlight on cursor [vim-highlighter]",
      },
      {
        "t<BS>",
        ":Hi - <CR>",
        desc = "Misc: remove hi undercursor [vim-highlighter]",
      },
      -- "t<CR>",
      -- "t<BS>",
      -- "S<CR>",
      -- "t<Tab>",
    },
  },
  -- NREDIR
  {
    -- Redirect output of vim or external command into scratch buffer,
    "sbulav/nredir.nvim",
    cmd = { "Nredir" },
  },
  -- SG.NVIM
  {
    "sourcegraph/sg.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "SourcegraphSearch", "SourcegraphLogin" },
    -- You must do this first before using it:
    -- jika belum login, gunakan `:SourcegraphLogin`
    config = true,
  },
  -- NVIM-CHEAT
  {
    "RishabhRD/nvim-cheat.sh",
    cmd = { "Cheat", "CheatWithoutComments", "CheatList" },
    dependencies = {
      "RishabhRD/popfix",
    },
    config = function()
      vim.g.cheat_default_window_layout = "vertical_split"
    end,
  },
  -- HAWTKEYS
  { -- use only when necessary.
    "tris203/hawtkeys.nvim",
    enabled = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = true,
  },
}
