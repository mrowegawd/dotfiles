local cmd = vim.cmd
local term_count = 0

return {
  -- TOGGLETERM
  {
    "akinsho/nvim-toggleterm.lua",
    opts = function()
      local function win_height_term()
        local win_height = math.ceil(vim.api.nvim_get_option "lines" * 0.5)
        return win_height - 4
      end
      return {
        size = win_height_term,
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = false,
        shading_factor = 0.3, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
        start_in_insert = true,
        persist_size = true,
        -- open_mapping = [[<a-f>]],
        direction = "horizontal",
      }
    end,
    cmd = { "ToggleTerm", "TermExec" },
    keys = function()
      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit = Terminal:new {
        cmd = "lazygit",
        hidden = true,
        direction = "float",
        float_opts = { width = vim.o.columns, height = vim.o.lines },
      }
      local lazydocker = Terminal:new {
        cmd = "lazydocker",
        hidden = true,
        direction = "float",
        float_opts = { width = vim.o.columns, height = vim.o.lines },
      }

      local lrfun = Terminal:new { cmd = "lfrun", hidden = true, direction = "float" }
      -- local taskwarrior = Terminal:new { cmd = "taskwarrior-tui", hidden = true, direction = "float" }

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
          if total_term_spawned == 1 then
            return
          end

          close_term()
          term_count = term_count - 1
        end

        cmd(string.format("%sToggleTerm", term_count))
        cmd "startinsert!"
      end

      return {
        -- { "<a-f>", mode = { "n", "v", "t", "i" } },
        -- {
        --   "<F5>",
        --   function()
        --     taskwarrior:toggle()
        --   end,
        --   mode = { "n", "v", "t" },
        --   desc = "Terminal(toggleterm): taskwarrior",
        -- },
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
          "<F9>",
          function()
            lazydocker:toggle()
          end,
          mode = { "n", "v", "t" },
          desc = "Terminal(toggleterm): lazydocker",
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
        {
          "<Leader>rl",
          "<CMD> ToggleTerm direction=vertical size=100 <CR>",
          desc = "Terminal(toggleterm): open left side",
          mode = { "n", "t", "v" },
        },
        {
          "<Leader>rt",
          "<CMD> ToggleTerm direction=tab <CR>",
          desc = "Terminal(toggleterm): open tab",
          mode = { "n", "t", "v" },
        },
        {
          "<Leader>rj",
          "<CMD> ToggleTerm direction=horizontal size=15<CR>",
          desc = "Terminal(toggleterm): open horizontal",
          mode = { "n", "t", "v" },
        },
      }
    end,
  },
  -- NVIM-TERMINAL
  {
    "s1n7ax/nvim-terminal",
    keys = {
      {
        "<a-f>",
        function()
          if not vim.bo.buftype == "terminal" then
            vim.cmd.Normal()
          end
          ---@diagnostic disable-next-line: undefined-global
          return NTGlobal["terminal"]:toggle()
        end,
        mode = { "n", "v", "t", "i" },
      },
      {
        "<a-1>",
        function()
          if not vim.bo.buftype == "terminal" then
            vim.cmd.Normal()
          end
          ---@diagnostic disable-next-line: undefined-global
          return NTGlobal["terminal"]:open(1)
        end,
        mode = { "n", "v", "t", "i" },
      },
      {
        "<a-2>",
        function()
          if not vim.bo.buftype == "terminal" then
            vim.cmd.Normal()
          end
          ---@diagnostic disable-next-line: undefined-global
          return NTGlobal["terminal"]:open(2)
        end,
        mode = { "n", "v", "t", "i" },
      },
      {
        "<a-3>",
        function()
          if not vim.bo.buftype == "terminal" then
            vim.cmd.Normal()
          end

          ---@diagnostic disable-next-line: undefined-global
          return NTGlobal["terminal"]:open(3)
        end,
        mode = { "n", "v", "t", "i" },
      },
      {
        "<a-4>",
        function()
          if not vim.bo.buftype == "terminal" then
            vim.cmd.Normal()
          end
          ---@diagnostic disable-next-line: undefined-global
          return NTGlobal["terminal"]:open(4)
        end,
        mode = { "n", "v", "t", "i" },
      },
      {
        "<a-5>",
        function()
          if not vim.bo.buftype == "terminal" then
            vim.cmd.Normal()
          end
          ---@diagnostic disable-next-line: undefined-global
          return NTGlobal["terminal"]:open(5)
        end,
        mode = { "n", "v", "t", "i" },
      },
    },
    opts = {
      -- keymap to disablesb all the default keymaps
      disable_default_keymaps = false,

      -- keymap to toggle open and close terminal window
      toggle_keymap = "<a-f>",

      terminals = {
        -- keymaps to open nth terminal
        -- { keymap = "<a-1>" },
        { keymap = "<a-2>" },
        { keymap = "<a-3>" },
        { keymap = "<a-4>" },
        { keymap = "<a-5>" },
      },
    },
    config = function(_, opts)
      vim.o.hidden = true
      require("nvim-terminal").setup(opts)
    end,
  },
}
