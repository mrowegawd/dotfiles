return {
  -- WHICH-KEY
  {
    "folke/which-key.nvim",
    event = "LazyFile",
    opts = {
      setup = {
        show_help = true,
        plugins = { spelling = true },
        key_labels = { ["<leader>"] = "SPC" },
        triggers = "auto",
        window = {
          border = "single", -- none, single, double, shadow
          position = "bottom", -- bottom, top
          margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
          padding = { 1, 1, 1, 1 }, -- extra window padding [top, right, bottom, left]
          winblend = 0,
        },
        layout = {
          height = { min = 4, max = 25 }, -- min and max height of the columns
          width = { min = 20, max = 50 }, -- min and max width of the columns
          spacing = 3, -- spacing between columns
          align = "left", -- align columns left, center or right
        },
        triggers_blacklist = {
          i = { "j", "k", "h", "l", "t", "r" },
          v = { "j", "k", "h", "l", "t" },
          c = { "j", "k", "h", "l", "t" },
        },
      },
      defaults = {
        ["<leader>"] = {
          name = "<Leader>",
          a = { name = "+projectionist" },
          d = {
            name = "+debug",
            -- a = { name = "+run-launch" },
            -- t = { name = "+toggle" },
          },
          -- D = { name = "+database" },
          f = { name = "+fzflua" },
          -- u = { name = "+edgy" },
          g = {
            name = "+git",
            -- v = { name = "+diffview" },
            -- t = { name = "+toggle" },
            -- w = { name = "+git-worktree" },
          },
          l = { name = "+tlsp" },
          c = { name = "+change-dir" },
          -- v = { name = "+view" },
          s = { name = "+surround" },
          r = { name = "+run-misc" },
          -- p = { name = "+project" },
          -- -- y = { name = "+surround" },
          t = { name = "+testing" },
          o = { name = "+open-url" },
          -- l = { name = "+lang" },
        },

        ["<localleader>"] = {
          r = "open misc cmds",
          o = { name = "+open" },
          f = { name = "+note" },
          d = { name = "+database" },
        },
      },
    },
    config = function(_, opts)
      local wk = require "which-key"
      wk.setup(opts.setup)
      wk.register(opts.defaults, { mode = { "n", "v" } })
    end,
  },
}
