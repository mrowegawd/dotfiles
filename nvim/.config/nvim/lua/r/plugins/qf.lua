return {
  -- NVIM-BQF
  {
    "kevinhwang91/nvim-bqf",
    ft = { "qf" },
    config = function()
      local bqf = require "bqf"
      bqf.setup {
        preview = {
          auto_preview = false,
          show_title = true,
          wrap = false,
          buf_label = true,
          should_preview_cb = nil,
          win_height = 12,
          win_vheight = 12,
          delay_syntax = 80,
          -- should_preview_cb = function(bufnr, _)
          --     local ret = true
          --     local bufname = vim.api.nvim_buf_get_name(bufnr)
          --     local fsize = vim.fn.getfsize(bufname)
          --     if fsize > 100 * 1024 then
          --         -- skip file size greater than 100k
          --         ret = false
          --     elseif bufname:match "^fugitive://" then
          --         -- skip fugitive buffer
          --         ret = false
          --     end
          --     return ret
          -- end,
        },
        -- make `drop` and `tab drop` to become preferred
        func_map = {
          drop = "o",
          openc = "O",
          split = "<C-s>",
          vsplit = "<C-v>",
          tabdrop = "<C-t>",
          tabc = "",
          tab = "",
          ptogglemode = "p",
          ptoggleauto = "P",

          ptoggleitem = "",
          -- pscrollup = "<a-u>",
          -- pscrolldown = "<a-d>",
          prevfile = "",
          nextfile = "",
          sclear = "z<Tab>",
          filter = "zn",
          filterr = "zN",
          fzffilter = "<c-f>",
        },
        filter = {
          fzf = {
            action_for = {
              ["ctrl-s"] = "split",
              ["ctrl-t"] = "tab drop",
            },
            extra_opts = {
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
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                        MY PLUGINS                        │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    dir = "~/.local/src/nvim_plugins/qfsilet",
    event = "BufRead",
    keys = {
      { "<Localleader>ql", "<CMD>LoadQFProject<CR>", desc = "Qf(qfsilet): load project" },
      { "<Localleader>qL", "<CMD>LoadQFGlobal<CR>", desc = "Qf(qfsilet): load global" },
      { "<Localleader>qs", "<CMD>SaveQFProject<CR>", desc = "Qf(qfsilet): save project" },
      { "<Localleader>qS", "<CMD>SaveQFGlobal<CR>", desc = "Qf(qfsilet): save global" },
    },
    opts = {
      ext_note = "",
      signs = {
        priority = 10,
      },
      popup = {
        winhighlight = "Normal:Pmenu,FloatBorder:FzfLuaBorder",
      },
    },
  },
}
