return {
  -- WHICH-KEY (disabled)
  {
    "folke/which-key.nvim",
    enabled = false,
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
  -- MINI.CLUE
  {
    "echasnovski/mini.clue",
    event = "VeryLazy",
    opts = function()
      local miniclue = require "mini.clue"

      return {
        window = {
          delay = vim.o.timeoutlen,
          -- Keys to scroll inside the clue window
          scroll_down = "<C-d>",
          scroll_up = "<C-u>",
        },
        triggers = {
          -- Leader triggers
          { mode = "n", keys = "<Leader>" },
          { mode = "x", keys = "<Leader>" },
          { mode = "n", keys = "<localleader>" },
          { mode = "x", keys = "<localleader>" },

          -- Built-in completion
          { mode = "i", keys = "<C-x>" },

          -- `g` key
          { mode = "n", keys = "g" },
          { mode = "x", keys = "g" },

          -- `d` key (diagnostic)
          { mode = "n", keys = "d" },
          { mode = "x", keys = "d" },

          -- Marks
          { mode = "n", keys = "m" },
          { mode = "x", keys = "m" },

          { mode = "n", keys = "r" },
          { mode = "x", keys = "r" },

          -- Registers
          -- -- { mode = "n", keys = '"' },
          -- -- { mode = "x", keys = '"' },
          -- -- { mode = "i", keys = "<C-r>" },
          -- -- { mode = "c", keys = "<C-r>" },

          -- Window commands
          { mode = "n", keys = "<C-w>" },

          -- `t` key
          { mode = "n", keys = "t" },
          { mode = "x", keys = "t" },

          -- `s` key
          { mode = "n", keys = "s" },
          { mode = "x", keys = "s" },

          -- `z` key
          { mode = "n", keys = "z" },
          { mode = "x", keys = "z" },
        },

        clues = {
          -- { mode = "n", keys = "<Leader>c", desc = "+AI" },
          -- { mode = "x", keys = "<Leader>c", desc = "+AI" },
          -- { mode = "n", keys = "<Leader>b", desc = "+Buffer" },
          { mode = "n", keys = "<Leader>d", desc = "+Debug" },
          { mode = "x", keys = "<Leader>d", desc = "+Debug" },
          { mode = "n", keys = "<Leader>a", desc = "+Projectionist" },
          -- { mode = "n", keys = "<Leader>D", desc = "+Database" },
          { mode = "n", keys = "<Leader>f", desc = "+FZFlua" },

          { mode = "n", keys = "<Leader>t", desc = "+Testing" },
          { mode = "n", keys = "<Leader>t", desc = "+Testing" },
          -- { mode = "n", keys = "<Leader>u", desc = "+Edgy" },
          --
          -- { mode = "n", keys = "<Leader>j", desc = "+Harpoon" },
          -- { mode = "n", keys = "<Leader>j", desc = "+Harpoon" },
          --
          { mode = "n", keys = "<Leader>g", desc = "+Git" },
          { mode = "x", keys = "<Leader>g", desc = "+Git" },
          -- { mode = "n", keys = "<Leader>gf", desc = "+FZFgit" },
          -- { mode = "n", keys = "<Leader>gv", desc = "+Diffview" },
          -- { mode = "x", keys = "<Leader>gv", desc = "+Diffview" },
          -- { mode = "n", keys = "<Leader>gt", desc = "+Toggle" },
          --
          -- { mode = "n", keys = "<Leader>l", desc = "+Language" },
          -- { mode = "x", keys = "<Leader>l", desc = "+Language" },
          -- { mode = "n", keys = "gc", desc = "+Coi" },

          -- { mode = "n", keys = "<Leader>lg", desc = "+Annotation" },
          -- { mode = "n", keys = "<Leader>lx", desc = "+Swap Next" },
          -- { mode = "n", keys = "<Leader>lxf", desc = "+Function" },
          -- { mode = "n", keys = "<Leader>lxp", desc = "+Parameter" },
          -- { mode = "n", keys = "<Leader>lxc", desc = "+Class" },
          -- { mode = "n", keys = "<Leader>lX", desc = "+Swap Previous" },
          -- { mode = "n", keys = "<Leader>lXf", desc = "+Function" },
          -- { mode = "n", keys = "<Leader>lXp", desc = "+Parameter" },
          -- { mode = "n", keys = "<Leader>lXc", desc = "+Class" },
          -- { mode = "n", keys = "<Leader>p", desc = "+Project" },
          -- { mode = "n", keys = "<Leader>q", desc = "+Quit/Session" },
          -- { mode = "x", keys = "<Leader>q", desc = "+Quit/Session" },
          --
          -- { mode = "n", keys = "<Leader>r", desc = "+TaskOrRun" },
          -- { mode = "x", keys = "<Leader>r", desc = "+TaskOrRun" },
          --
          -- { mode = "n", keys = "<Leader>s", desc = "+Sessions" },
          -- { mode = "x", keys = "<Leader>s", desc = "+Sessions" },
          --
          -- { mode = "n", keys = "<Leader>t", desc = "+Testing" },
          -- -- { mode = "n", keys = "<Leader>tN", desc = "+Neotest" },
          --
          -- -- { mode = "n", keys = "<Leader>to", desc = "+Overseer" },
          -- -- { mode = "n", keys = "<Leader>v", desc = "+View" },
          -- { mode = "n", keys = "<Leader>z", desc = "+System" },
          -- { mode = "n", keys = "<Leader>y", desc = "+Surround" },
          --
          -- { mode = "n", keys = "<Localleader>o", desc = "+Open" },
          -- { mode = "n", keys = "<Localleader>q", desc = "+QF" },
          -- { mode = "n", keys = "<Localleader>f", desc = "+Note" },

          -- Submodes
          -- { mode = "n", keys = "<Leader>tNF", postkeys = "<Leader>tN" },
          -- { mode = "n", keys = "<Leader>tNL", postkeys = "<Leader>tN" },
          -- { mode = "n", keys = "<Leader>tNa", postkeys = "<Leader>tN" },
          -- { mode = "n", keys = "<Leader>tNf", postkeys = "<Leader>tN" },
          -- { mode = "n", keys = "<Leader>tNl", postkeys = "<Leader>tN" },
          -- { mode = "n", keys = "<Leader>tNn", postkeys = "<Leader>tN" },
          -- { mode = "n", keys = "<Leader>tNN", postkeys = "<Leader>tN" },
          -- { mode = "n", keys = "<Leader>tNo", postkeys = "<Leader>tN" },
          -- { mode = "n", keys = "<Leader>tNs", postkeys = "<Leader>tN" },
          -- { mode = "n", keys = "<Leader>tNS", postkeys = "<Leader>tN" },

          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows {
            submode_move = false,
            submode_navigate = false,
            submode_resize = true,
          },
          miniclue.gen_clues.z(),
        },
      }
    end,
  },
}
