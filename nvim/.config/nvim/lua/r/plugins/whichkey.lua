return {
  -- WHICH-KEY
  {
    "folke/which-key.nvim",
    event = "LazyFile",
    opts = {
      plugins = { marks = false, registers = false },
      show_help = false, -- show a help message in the command line for using WhichKey
      show_keys = false, -- show the currently pressed key and its label as a message in the command line
      window = {
        border = "single", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]. When between 0 and 1, will be treated as a percentage of the screen size.
        padding = { 1, 2, 1, 2 }, -- extra window padding [top, right, bottom, left]
        winblend = 0, -- value between 0-100 0 for fully opaque and 100 for fully transparent
        zindex = 1000, -- positive value to position WhichKey above other floating windows.
      },
      triggers_blacklist = {
        i = { "j", "k", "h", "l", "t", "r" },
        v = { "j", "k", "h", "l", "t" },
        c = { "j", "k", "h", "l", "t" },
      },
    },
    config = function(_, opts)
      local wk = require "which-key"
      wk.setup(opts)
      wk.register {
        mode = { "n", "v" },
        ["z"] = { name = "+fold" },
        ["t"] = { name = "t" },
        ["r"] = { name = "r" },
        ["<leader>"] = {
          name = "<Leader>",
          a = { name = "+projectionist" },
          b = { name = "+buffer" },
          d = {
            name = "+debug",
          },
          f = { name = "+fzflua" },
          u = { name = "+toggle" },
          R = { name = "+translate" },
          g = {
            name = "+git",
            h = { name = "+hunks" },
            f = { name = "+gitfzf" },
            u = { name = "+toggle" },
            v = { name = "+line_or_visual_or_clipboard" },
            t = { name = "+git_toggle" },
          },
          l = { name = "+tlsp" },
          c = { name = "+changedir" },
          s = { name = "+surround" },
          r = { name = "+refactor" },
          -- p = { name = "+project" },
          t = { name = "+testing" },
          o = { name = "+open/browse" },
          x = { name = "+diagnostic/quickfix/trouble" },
        },
        ["<localleader>"] = {
          name = "<Localleader>",
          r = "open misc cmds",
          o = { name = "+open" },
          f = { name = "+note" },
          d = { name = "+database" },
          n = { name = "+noice" },
        },
      }
    end,
  },
}
