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
  -- COMMENT-BOX
  {
    "LudoPinelli/comment-box.nvim",
    event = "BufRead",
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
  -- SG.NVIM (disabled)
  {
    "sourcegraph/sg.nvim",
    enabled = false,
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
  -- HAWTKEYS (disabled)
  { -- use only when necessary.
    "tris203/hawtkeys.nvim",
    enabled = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = true,
  },
  -- ORPHANS
  {
    -- Easily identify abandoned neovim plugins
    "ZWindL/orphans.nvim",
    cmd = "Orphans",
    config = function()
      require("orphans").setup {}
    end,
  },
  -- KEYANALYZER
  {
    -- :KeyAnalyzer <prefix> [mode]
    -- example:
    -- :KeyAnalyzer <leader> 	  Show <leader> mappings
    -- :KeyAnalyzer <leader>b 	Show mappings starting with <leader>b*
    -- :KeyAnalyzer <C- 	      Show CTRL mappings
    -- :KeyAnalyzer <C- v 	    Show CTRL mappings in visual mode
    -- :KeyAnalyzer <M-         Show Alt/Meta/Option mappings
    -- :KeyAnalyzer <M-         Show Alt/Meta/Option mappings
    -- :KeyAnalyzer <C-M>x i 	  Show mappings starting with CTRL + M x in insert mode
    "meznaric/key-analyzer.nvim",
    cmd = "KeyAnalyzer",
    opts = {},
  },
  -- FEED
  {
    "neo451/feed.nvim",
    cmd = "Feed",
    config = function()
      require("feed").setup {
        feeds = {
          "neo451/feed.nvim/releases",
          "folke/snacks.nvim", -- defaults to subscribing to commits
          "https://dev.to/feed/tag/git",
        },
        search = { backend = { "fzf-lua" } },
      }
    end,
  },
}
