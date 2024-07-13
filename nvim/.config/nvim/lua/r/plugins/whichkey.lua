return {
  -- WHICH-KEY
  {
    "folke/which-key.nvim",
    event = "LazyFile",
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show { global = false }
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
    opts = {

      defaults = {},
      triggers = false,
      spec = {
        {
          mode = { "n", "v" },
          { "<Leader><tab>", group = "tabs" },
          { "<Leader>b", group = "buffer" },
          { "<Leader>d", group = "debug" },
          { "<Leader>f", group = "fzflua" },

          { "<Leader>g", group = "git" },
          { "<Leader>gf", group = "gitfzflua" },
          { "<Leader>gh", group = "hunks" },
          { "<Leader>gu", group = "gittoggle" },

          { "<Leader>a", group = "projectionist" },
          { "<Leader>c", group = "code" },
          { "<Leader>s", group = "fzfcustom" },
          { "<Leader>u", group = "toggle" },
          { "<Leader>t", group = "testing" },
          { "<Leader>r", group = "refactor" },
          { "<Leader>x", group = "diagnostics/quickfix" },

          { "<Localleader>d", group = "DB" },
          { "<Localleader>f", group = "note" },
          { "<Localleader>n", group = "noice" },
          { "<Localleader>o", group = "open/misc" },
        },
      },
    },
    confi = function(_, opts)
      local wk = require "which-key"
      wk.setup(opts)
    end,
  },
}
