-- local term_count = 1

return {
  -- ERGOTERM
  {
    "waiting-for-dev/ergoterm.nvim",
    opts = {
      picker = {
        picker = "fzf-lua",
      },
    },
    config = function(_, opts)
      require("ergoterm").setup(opts)

      local terms = require "ergoterm.terminal"

      local base = terms.Terminal:new {
        name = "base",
        cmd = "zsh",
        layout = "below",
        -- dir = "git_dir",
      }

      RUtils.map.vnoremap("<Localleader>t", function()
        base:toggle()
      end, { desc = "toggle base terminal" })
      RUtils.map.nnoremap("<Localleader>t", function()
        base:toggle()
      end, { desc = "toggle base terminal" })
      RUtils.map.tnoremap("<Localleader>t", function()
        base:toggle()
      end, { desc = "toggle base terminal" })

      RUtils.map.vnoremap("<a-f>", function()
        base:toggle()
      end, { desc = "toggle base terminal" })
      RUtils.map.nnoremap("<a-f>", function()
        base:toggle()
      end, { desc = "toggle base terminal" })
      RUtils.map.tnoremap("<a-f>", function()
        base:toggle()
      end, { desc = "toggle base terminal" })
    end,
  },
  -- FLOATERM (disabled)
  {
    "nvzone/floaterm",
    cmd = "FloatermToggle",
    enabled = false,
    dependencies = "nvzone/volt",
    opts = { mappings = { sidebar = nil, term = nil } },
    keys = {
      {
        "<Localleader>t",
        function()
          vim.cmd [[FloatermToggle]]
        end,
        desc = "Terminal: toggle [floaterm]",
        mode = { "n", "v", "t" },
      },
      {
        "<a-f>",
        function()
          vim.cmd [[FloatermToggle]]
        end,
        desc = "Terminal: toggle [floaterm]",
        mode = { "n", "v", "t" },
      },
    },
  },
  -- TOGGLETERM
  {
    "akinsho/nvim-toggleterm.lua",
    cmd = { "ToggleTerm", "TermExec" },
    opts = function()
      return {
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
    -- keys = function()
    --   return {
    --     {
    --       "<a-f>",
    --       function()
    --         local function win_width_term()
    --           local win_height = vim.o.columns - 2
    --           local win_width = vim.o.lines - 2
    --
    --           local width = math.floor(0.6 * win_height)
    --           local height = math.floor(1 * win_width)
    --
    --           if width < 80 then
    --             width = 90
    --           end
    --
    --           return width, height
    --         end
    --
    --         local width, height = win_width_term()
    --
    --         local Terminal = require("toggleterm.terminal").Terminal
    --         local terminal_open = Terminal:new {
    --           cmd = "zsh",
    --           direction = "horizontal", -- horizontal, vertical
    --           float_opts = {
    --             border = "single",
    --             width = width,
    --             height = height,
    --             col = 100,
    --             row = 100,
    --           },
    --           -- function to run on opening the terminal
    --           on_open = function(term)
    --             local ol = vim.opt_local
    --             ol.signcolumn = "no"
    --             -- vim.cmd "startinsert!"
    --             vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
    --           end,
    --           -- function to run on closing the terminal
    --           on_close = function()
    --             vim.cmd "startinsert!"
    --           end,
    --         }
    --         terminal_open:toggle()
    --       end,
    --       desc = "Terminal: toggle term float [toggleterm]",
    --     },
    --     {
    --       "<a-N>",
    --       function()
    --         -- vim.cmd(string.format("%sToggleTerm direction=vertical size=100", count))
    --         -- vim.cmd "2ToggleTerm direction=tab"
    --
    --         local terms = require "toggleterm.terminal"
    --         local total_term_spawned = #terms.get_all()
    --
    --         -- close_term()
    --         if total_term_spawned == term_count then
    --           term_count = term_count + 1
    --         else
    --           term_count = total_term_spawned
    --         end
    --
    --         vim.cmd(string.format("%sToggleTerm direction=tab", term_count))
    --         vim.cmd "startinsert!"
    --       end,
    --       desc = "Terminal: new tab term [toggleterm]",
    --     },
    --   }
    -- end,
  },
}
