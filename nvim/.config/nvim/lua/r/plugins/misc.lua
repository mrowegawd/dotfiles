return {
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
  {
    "azabiong/vim-highlighter",
    event = "LazyFile",
    init = function()
      vim.cmd [[
      let HiSet   = 't<CR>'
      let HiErase = 't<BS>'
      let HiClear = 't<C-L>'
      let HiFind  = 't<Tab>'
      let HiSetSL = 'T<CR>'
      ]]
    end,
    keys = {
      {
        "fn",
        "<CMD> Hi} <CR>",
        desc = "Misc(sq): search",
      },
      {
        "fp",
        "<CMD> Hi{ <CR>",
        desc = "Misc(sq): search",
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
  {
    "tris203/hawtkeys.nvim",
    enabled = false,
    config = true,
  },
}
