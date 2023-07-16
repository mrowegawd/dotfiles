return {
  -- NUI
  { "MunifTanjim/nui.nvim", lazy = true }, -- jangan di delete, karena di utils.init masih yang menggunakan
  { "nvim-lua/plenary.nvim" },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  -- VIM-LOG
  {
    "mtdl9/vim-log-highlighting",
    lazy = false,
  },
  -- SUDA
  {
    "lambdalisue/suda.vim",
    cmd = { "SudaWrite", "SudaRead" },
  },
  -- TASKWARRIOR SYNTAX
  {
    "framallo/taskwarrior.vim",
    ft = "taskrc",
  },
  -- NUMTOSTR COMMENT
  {
    "numToStr/Comment.nvim",
    keys = { "gcc", { "gc", mode = "v" } },
    config = true,
    -- opts = function()
    --   local commentstring_avail, commentstring = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
    --   return commentstring_avail
    --       and commentstring
    --       and {
    --         pre_hook = commentstring.create_pre_hook(),
    --
    --         mappings = { basic = true, extra = false },
    --       }
    --     or {}
    -- end,
  },
  -- MINI-SURROUND
  {
    "echasnovski/mini.surround",
    keys = function(_, keys)
      -- Populate the keys based on the user's options
      local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
      local opts = require("lazy.core.plugin").values(plugin, "opts", false)
      local mappings = {
        {
          opts.mappings.add,
          desc = "Add surrounding",
          mode = { "n", "v" },
        },
        { opts.mappings.delete, desc = "Delete surrounding" },
        { opts.mappings.find, desc = "Find right surrounding" },
        { opts.mappings.find_left, desc = "Find left surrounding" },
        { opts.mappings.highlight, desc = "Highlight surrounding" },
        { opts.mappings.replace, desc = "Replace surrounding" },
        {
          opts.mappings.update_n_lines,
          desc = "Update `MiniSurround.config.n_lines`",
        },
      }
      mappings = vim.tbl_filter(function(m)
        return m[1] and #m[1] > 0
      end, mappings)
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      mappings = {
        add = "<leader>ya", -- Add surrounding in Normal and Visual modes
        delete = "<leader>yd", -- Delete surrounding
        find = "<leader>yf", -- Find surrounding (to the right)
        find_left = "<leader>yF", -- Find surrounding (to the left)
        highlight = "<leader>yh", -- Highlight surrounding
        replace = "<leader>yr", -- Replace surrounding
        update_n_lines = "<leader>yn", -- Update `n_lines`
      },
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
  -- HLARGS
  {
    "m-demare/hlargs.nvim",
    event = "VeryLazy", --  "UIEnter"
    opts = {
      color = "#ef9062",
      use_colorpalette = true,
      colorpalette = {
        { fg = "#ef9062" },
        { fg = "#3AC6BE" },
        { fg = "#35D27F" },
        { fg = "#EB75D6" },
        { fg = "#E5D180" },
        { fg = "#8997F5" },
        { fg = "#D49DA5" },
        { fg = "#7FEC35" },
        { fg = "#F6B223" },
        { fg = "#F67C1B" },
        { fg = "#DE9A4E" },
        { fg = "#BBEA87" },
        { fg = "#EEF06D" },
        { fg = "#8FB272" },
      },
    },
  },
  -- SG.NVIM
  {
    "sourcegraph/sg.nvim",
    event = "VeryLazy",
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
  -- TREESJ
  {
    "Wansmer/treesj",
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    keys = { {
      "<leader>rj",
      "<cmd>TSJToggle<cr>",
      desc = "Misc(treesj): toggle split/join",
    } },
    -- depenkencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesj").setup {
        use_default_keymaps = false,
      }
    end,
  },
  -- STICKYBUF.NVIM
  {
    "stevearc/stickybuf.nvim",
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
