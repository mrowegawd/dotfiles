return {
  -- CRONEX
  {
    -- ex: (gunakan tanda kurung ya!) -> "* * * * *" bukan * * * * *
    -- dan juga format cronex adalah lewat diagnostic, check lewat trouble
    "fabridamicelli/cronex.nvim",
    ft = { "yaml", "yml", "tf", "cfg", "config", "conf", "crontab" },
    config = function()
      require("cronex").setup {
        -- Add *.crontab to supported file patterns
        file_patterns = { "*.yaml", "*.yml", "*.tf", "*.cfg", "*.config", "*.conf", "*.crontab" },

        -- Use custom extractor to support unquoted cron expressions
        extractor = {
          cron_from_line = require("cronex.cron_from_line").cron_from_line_crontab,
          extract = require("cronex.extract").extract,
        },
      }
    end,
  },
  -- BLOAT
  {
    "dundalek/bloat.nvim",
    cmd = "Bloat",
  },
  -- STARTUPTIME
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },
  -- COMMENT-BOX
  {
    "LudoPinelli/comment-box.nvim",
    event = "InsertEnter",
  },
  -- VIM-HIGHLIGHTER
  {
    -- https://github.com/t9md/vim-quickhl (alternative)
    "azabiong/vim-highlighter",
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
  -- NVIM-CHEAT (disabled)
  {
    "RishabhRD/nvim-cheat.sh",
    enabled = false,
    cmd = { "Cheat", "CheatWithoutComments", "CheatList" },
    dependencies = { "RishabhRD/popfix" },
    config = function()
      vim.g.cheat_default_window_layout = "vertical_split"
    end,
  },
  -- HAWTKEYS (disabled)
  {
    "tris203/hawtkeys.nvim", -- use only when necessary.
    enabled = false,
    cmd = { "Hawtkeys", "HawtkeysDupes" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = true,
  },
  -- ORPHANS (disabled)
  {
    -- Easily identify abandoned neovim plugins
    "ZWindL/orphans.nvim",
    enabled = false,
    cmd = "Orphans",
    config = function()
      require("orphans").setup {}
    end,
  },
  -- KEYANALYZER (disabled)
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
    enabled = false,
    opts = {},
  },
  -- FEED
  {
    "neo451/feed.nvim",
    cmd = "Feed",
    keys = {
      {
        "<Leader>oE",
        "<CMD>Feed<CR>",
        desc = "Open: feed [feed.nvim]",
      },
    },
    opts = {
      search = { backend = { "snacks.pick" } },
      -- zen = { enabled = true, width = 120 },
      feeds = {
        "neo451/feed.nvim/releases",
        "folke/snacks.nvim", -- defaults to subscribing to commits
        "https://dev.to/feed/tag/git",
        "https://dev.to/feed/tag/vim",
        "https://dev.to/feed/tag/rust",
        "https://dev.to/feed",
        "https://dev.to/feed/tag/python",
        "https://news.ycombinator.com/rss",
      },
      -- keys = {
      --   index = {
      --     -- { "q", "<cmd>Feed quit<cr>" },
      --     -- { "?", "<cmd>Feed hints<cr>" },
      --     { ".", "<cmd>Feed dot<cr>" },
      --     -- { "u", "<cmd>Feed undo<cr>" },
      --     -- { "<C-r>", "<cmd>Feed redo<cr>" },
      --     -- { "<M-CR>", "<cmd>Feed split<cr>" },
      --     -- { "b", "<cmd>Feed browser<cr>" },
      --     -- { "r", "<cmd>Feed refresh<cr>" },
      --     -- { "R", "<cmd>Feed update<cr>" },
      --     -- { "/", "<cmd>Feed search<cr>" },
      --     -- { "Y", "<cmd>Feed yank_url<cr>" },
      --     -- { "-", "<cmd>Feed untag<cr>" },
      --     -- { "+", "<cmd>Feed tag<cr>" },
      --     -- { "<cr>", "<cmd>Feed entry<cr>" },
      --   },
      --   -- entry = {
      --   --   { "q", "<cmd>Feed quit<cr>" },
      --   --   { "?", "<cmd>Feed hints<cr>" },
      --   --   { "Y", "<cmd>Feed yank_url<cr>" },
      --   --   { "b", "<cmd>Feed browser<cr>" },
      --   --   { "}", "<cmd>Feed next<cr>" },
      --   --   { "{", "<cmd>Feed prev<cr>" },
      --   --   { "/", "<cmd>Feed search<cr>" },
      --   --   { "-", "<cmd>Feed untag<cr>" },
      --   --   { "+", "<cmd>Feed tag<cr>" },
      --   --   { "f", "<cmd>Feed full<cr>" },
      --   --   { "r", "<cmd>Feed urlview<cr>" },
      --   -- },
      -- },
    },
  },
}
