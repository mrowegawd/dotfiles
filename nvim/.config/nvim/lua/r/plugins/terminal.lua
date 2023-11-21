local cmd = vim.cmd
local Util = require "r.utils"

local term_count = 0

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
  -- TOGGLETERM
  {
    "akinsho/nvim-toggleterm.lua",
    opts = {
      size = 20,
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = false,
      shading_factor = 0.3, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
      start_in_insert = true,
      persist_size = true,
      open_mapping = [[<Localleader><Localleader>]],
      direction = "horizontal",
    },
    cmd = { "ToggleTerm", "TermExec" },
    keys = function()
      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit = Terminal:new {
        cmd = "lazygit",
        hidden = true,
        direction = "float",
        float_opts = { width = vim.o.columns, height = vim.o.lines },
      }
      local lrfun = Terminal:new { cmd = "lfrun", hidden = true, direction = "float" }

      -- Check and close the toggleterm
      local function close_term()
        for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
          local winbufnr = vim.fn.winbufnr(vim.api.nvim_win_get_number(winid))

          if winbufnr > 0 then
            local winft = vim.api.nvim_buf_get_option(winbufnr, "filetype")
            if winft == "toggleterm" then
              cmd "ToggleTerm"
            end
          end
        end
      end

      local function go_next_or_prev_toggleterm(is_next)
        is_next = is_next or false

        local terms = require "toggleterm.terminal"
        local total_term_spawned = #terms.get_all()

        if terms.get_focused_id() == nil then
          return cmd "ToggleTerm"
        end

        term_count = terms.get_focused_id()

        if is_next then
          if total_term_spawned == term_count then
            return
          end

          close_term()
          term_count = term_count + 1
        else
          if total_term_spawned == 0 then
            return
          end

          close_term()
          term_count = term_count - 1
        end

        cmd(string.format("%sToggleTerm", term_count))
        cmd "startinsert!"
      end

      return {
        { "<Localleader><Localleader>" },
        {
          "<F7>",
          function()
            lrfun:toggle()
          end,
          mode = { "n", "v", "t" },
          desc = "Terminal(toggleterm): lfrun",
        },
        {
          "<F8>",
          function()
            lazygit:toggle()
          end,
          mode = { "n", "v", "t" },
          desc = "Terminal(toggleterm): lazygit",
        },
        {
          "<C-PageUp>",
          function()
            go_next_or_prev_toggleterm()
          end,
          desc = "Terminal(toggleterm): prev",
          mode = { "n", "t", "v" },
        },
        {
          "<C-PageDown>",
          function()
            go_next_or_prev_toggleterm(true)
          end,
          desc = "Terminal(toggleterm): next",
          mode = { "n", "t", "v" },
        },
        {
          "<C-Insert>",
          function()
            local terms = require "toggleterm.terminal"
            local total_term_spawned = #terms.get_all()

            close_term()
            if total_term_spawned == term_count then
              term_count = term_count + 1
            else
              term_count = total_term_spawned
            end

            cmd(string.format("%sToggleTerm", term_count))
            cmd "startinsert!"
          end,
          desc = "Terminal(toggleterm): create new term",
          mode = { "n", "t", "v" },
        },
        {
          "<C-Delete>",
          function()
            if vim.bo[0].filetype == "toggleterm" then
              print "Not implemented yet"
            end
          end,
          desc = "Terminal(toggleterm): remove",
          mode = { "n", "t", "v" },
        },
      }
    end,
  },
  -- TT.NVIM (disabled)
  {
    "distek/tt.nvim",
    enabled = false,
    keys = {
      {
        "<localleader><localleader>",
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
