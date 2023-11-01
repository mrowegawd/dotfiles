local cmd = vim.cmd
local Util = require "r.utils"

return {
  -- BUFTERM (disabled)
  {
    "boltlessengineer/bufterm.nvim",
    cmd = { "BufTermEnter", "BufTermPrev", "BufTermNext" },
    enabled = false,
    keys = {
      {
        "<Leader>rr",
        function()
          -- this will add Terminal to the list (not starting job yet)
          local Terminal = require("bufterm.terminal").Terminal
          local ui = require "bufterm.ui"

          local lfrun = Terminal:new {
            cmd = "lfrun",
            buflisted = false,
            termlisted = false,
          }

          lfrun:spawn()
          return ui.toggle_float(lfrun.bufnr)
        end,
        desc = "Terminal(bufterm): open lfrun",
      },
    },
    dependencies = {
      { "akinsho/nvim-bufferline.lua" },
    },
    config = function()
      require("bufterm").setup {
        save_native_terms = true, -- integrate native terminals from `:terminal` command
        start_in_insert = true, -- start terminal in insert mode
        remember_mode = true, -- remember vi_mode of terminal buffer
        enable_ctrl_w = true, -- use <C-w> for window navigating in terminal mode (like vim8)
        terminal = { -- default terminal settings
          buflisted = false, -- whether to set 'buflisted' option
          fallback_on_exit = true, -- prevent auto-closing window on terminal exit
        },
      }
    end,
  },
  -- TOGGLETERM (disabled)
  {
    "akinsho/nvim-toggleterm.lua",
    enabled = false,
    event = "VeryLazy",
    opts = {
      size = 20,
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = false,
      shading_factor = 0.3, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
      start_in_insert = true,
      persist_size = true,
      direction = "horizontal",
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)
    end,
  },
  -- TT.NVIM
  {
    "distek/tt.nvim",
    keys = {
      {
        "<c-t>",
        function()
          if vim.bo.filetype == "qf" then
            Util.tiling.force_win_close({ "qf" }, false)

            cmd [[wincmd w]]
          end

          return require("tt.terminal"):Toggle()
        end,
        mode = { "n", "t", "v" },
        desc = "Terminal(tt.nvim): toggle",
      },
      {
        "<c-Delete>",
        function()
          if vim.bo.filetype == "qf" then
            Util.tiling.force_win_close({ "qf" }, false)

            cmd [[wincmd w]]
          end

          if vim.bo.filetype == "fzf" then
            return
          end

          return require("tt.termlist"):DeleteTermUnderCursor()
        end,
        mode = { "t", "n" },
        desc = "Terminal(tt.nvim): delete",
      },
      {
        "<c-Insert>",
        function()
          if vim.bo.filetype == "qf" then
            Util.tiling.force_win_close({ "qf" }, false)

            cmd [[wincmd w]]
          end

          if vim.bo.filetype == "fzf" then
            return
          end

          return require("tt.terminal"):NewTerminal()
        end,
        mode = { "t" },
        desc = "Terminal(tt.nvim): create new terminal",
      },
      {
        "<C-PageDown>",
        function()
          if vim.bo.filetype == "qf" then
            Util.tiling.force_win_close({ "qf" }, false)

            cmd [[wincmd w]]
          end

          if vim.bo.filetype == "fzf" then
            return
          end

          return require("tt.terminal"):FocusNext()
        end,
        mode = { "t" },
        desc = "Terminal(tt.nvim): next",
      },

      {
        "<C-PageUp>",
        function()
          if vim.bo.filetype == "qf" then
            Util.tiling.force_win_close({ "qf" }, false)

            cmd [[wincmd w]]
          end

          if vim.bo.filetype == "fzf" then
            return
          end

          return require("tt.terminal"):FocusPrevious()
        end,
        mode = { "t" },
        desc = "Terminal(tt.nvim): prev",
      },
    },
    opts = function()
      return {
        termlist = {
          winhighlight = "Normal:ColorColumn,WinBar:WinBar", -- See :h winhighlight - You can change winbar colors as well
          enabled = true,
          side = "right",
          width = 25,
        },
        terminal = {
          winhighlight = "Normal:PanelDarkBackground,WinBar:PanelDarkBackground", -- See :h winhighlight - You can change winbar colors as well
        },
        height = 15,
        -- fixed_height = true,
      }
    end,
  },
}
