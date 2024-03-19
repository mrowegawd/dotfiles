local Highlight = require "r.settings.highlights"
local Config = require "r.config"

return {
  -- NVIM-BQF
  {
    "kevinhwang91/nvim-bqf",
    ft = { "qf" },
    dependencies = {
      {
        "junegunn/fzf",
        build = function()
          vim.fn["fzf#install"]()
        end,
      },
    },

    opts = function()
      Highlight.plugin("NvimBqfC", {
        { BqfPreviewFloat = { link = "NormalFloat" } },
      })
      return {
        preview = {
          auto_preview = false,
          show_title = true,
          wrap = true,
          winblend = 0,
          win_height = 25,
          win_vheight = 25,
          buf_label = true,
          should_preview_cb = nil,
        },
        -- make `drop` and `tab drop` to become preferred
        func_map = {
          drop = "",
          openc = "",
          split = "<C-s>",
          vsplit = "<C-v>",
          tabdrop = "<C-t>",
          tabc = "",
          tab = "",
          ptogglemode = "p",
          ptoggleauto = "P",
          ptoggleitem = "",
          pscrollup = "<a-Up>",
          pscrolldown = "<a-Down>",
          prevfile = "",
          nextfile = "",
          sclear = "z<Tab>",
          filter = "zn",
          filterr = "zN",
          fzffilter = "zf",
        },
        filter = {
          fzf = {
            action_for = {
              ["ctrl-s"] = "split",
              ["ctrl-t"] = "tab drop",
            },
            extra_opts = {
              "+i",
              "--bind",
              "ctrl-o:toggle-all",
              "--prompt",
              "> ",
            },
          },
        },
      }
    end,
  },
  -- QFSILET
  {
    dir = "~/.local/src/nvim_plugins/qfsilet",
    event = "BufReadPre",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      save_dir = Config.path.home .. "/Dropbox/neorg/orgmode/project-todo",
    },
  },
}
