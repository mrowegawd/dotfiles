return {
  -- TOGGLETERM
  {
    "akinsho/nvim-toggleterm.lua",
    opts = function()
      local function get_option(name_opt)
        return vim.api.nvim_get_option_value(name_opt, { scope = "local" })
      end

      local function win_height_term()
        local win_height = math.ceil(get_option "columns" * 0.4)
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
        direction = "vertical",
      }
    end,

    cmd = { "ToggleTerm", "TermExec" },
    keys = function()
      return {
        --   { "<a-f>", mode = { "n", "v", "t", "i" } },
        {
          "<Localleader>oc",
          function()
            RUtils.terminal.float_calcure()
          end,
          mode = { "n", "v", "t" },
          desc = "Terminal(toggleterm): calcure",
        },
        --     -- {
        --     --   "<F7>",
        --     --   function()
        --     --     lrfun:toggle()
        --     --   end,
        --     --   mode = { "n", "v", "t" },
        --     --   desc = "Terminal(toggleterm): lfrun",
        --     -- },
        --     -- {
        --     --   "<F8>",
        --     --   function()
        --     --     lazygit:toggle()
        --     --   end,
        --     --   mode = { "n", "v", "t" },
        --     --   desc = "Terminal(toggleterm): lazygit",
        --     -- },
        --     {
        --       "<F9>",
        --       function()
        --         lazydocker:toggle()
        --       end,
        --       mode = { "n", "v", "t" },
        --       desc = "Terminal(toggleterm): lazydocker",
        --     },
        --     {
        --       "<C-PageUp>",
        --       function()
        --         go_next_or_prev_toggleterm()
        --       end,
        --       desc = "Terminal(toggleterm): prev",
        --       mode = { "n", "t", "v" },
        --     },
        --     {
        --       "<C-PageDown>",
        --       function()
        --         go_next_or_prev_toggleterm(true)
        --       end,
        --       desc = "Terminal(toggleterm): next",
        --       mode = { "n", "t", "v" },
        --     },
        --     {
        --       "<C-Insert>",
        --       function()
        --         local terms = require "toggleterm.terminal"
        --         local total_term_spawned = #terms.get_all()
        --
        --         close_term()
        --         if total_term_spawned == term_count then
        --           term_count = term_count + 1
        --         else
        --           term_count = total_term_spawned
        --         end
        --
        --         cmd(string.format("%sToggleTerm", term_count))
        --         cmd "startinsert!"
        --       end,
        --       desc = "Terminal(toggleterm): create new term",
        --       mode = { "n", "t", "v" },
        --     },
        --     {
        --       "<C-Delete>",
        --       function()
        --         if vim.bo[0].filetype == "toggleterm" then
        --           print "Not implemented yet"
        --         end
        --       end,
        --       desc = "Terminal(toggleterm): remove",
        --       mode = { "n", "t", "v" },
        --     },
        --     {
        --       "<Leader>rl",
        --       "<CMD> ToggleTerm direction=vertical size=100 <CR>",
        --       desc = "Terminal(toggleterm): open left side",
        --       mode = { "n", "t", "v" },
        --     },
        --     {
        --       "<Leader>rt",
        --       "<CMD> ToggleTerm direction=tab <CR>",
        --       desc = "Terminal(toggleterm): open tab",
        --       mode = { "n", "t", "v" },
        --     },
        --     {
        --       "<Leader>rj",
        --       "<CMD> ToggleTerm direction=horizontal size=15<CR>",
        --       desc = "Terminal(toggleterm): open horizontal",
        --       mode = { "n", "t", "v" },
        --     },
      }
    end,
  },
  -- TERMIM.NVIM
  {
    "2kabhishek/termim.nvim",
    cmd = { "Fterm", "FTerm", "Sterm", "STerm", "Vterm", "VTerm" },
    keys = {
      {
        "<a-f>",
        function()
          RUtils.terminal.toggle_right_term()
        end,
        desc = "Terminal: new term split [termim.nvim]",
      },
      {
        "<a-N>",
        function()
          -- vim.cmd "wincmd L"
          vim.cmd.Fterm()
        end,
        desc = "Terminal: open new tabterm [termim.nvim]",
      },
    },
  },

  -- Edgy integration
  -- {
  --   "folke/edgy.nvim",
  --   optional = true,
  --   opts = function(_, opts)
  --     opts.right = opts.right or {}
  --     table.insert(opts.right, {
  --       title = "Clock Mode",
  --       -- ft = "terminal",
  --       pinned = true,
  --       width = 0.3,
  --       open = function()
  --         vim.cmd [[STerm tclock clock -S]]
  --       end,
  --
  --       -- filter = function(buf)
  --       --   return vim.bo[buf].buftype == "terminal"
  --       -- end,
  --     })
  --
  --     -- opts.bottom = opts.bottom or {}
  --     -- table.insert(opts.bottom, {
  --     --   title = "DB Query Result",
  --     --   ft = "dbout",
  --     -- })
  --   end,
  -- },
}
