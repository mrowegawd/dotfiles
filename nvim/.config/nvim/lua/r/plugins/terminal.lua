-- local term_count = 1

local base_term = nil

return {
  -- ERGOTERM
  {
    "waiting-for-dev/ergoterm.nvim",
    cmd = "TermNew",
    keys = {
      { "<Localleader>t", mode = { "n", "t", "v" } },
      { "<a-f>", mode = { "n", "t", "v" } },
      { "<a-T>", mode = { "n", "t", "v", desc = "Terminal: open" } },
      { "<a-N>" },
    },
    opts = {
      picker = {
        picker = "fzf-lua",
      },
    },
    config = function(_, opts)
      require("ergoterm").setup(opts)

      local open_term_with_singleton = function(is_new, direction)
        direction = direction or "below"
        is_new = is_new or false

        if is_new then
          local terms = require "ergoterm"
          local term = terms.Terminal:new {
            name = "base",
            cmd = "zsh",
            layout = direction,
          }
          return term
        end

        if not base_term and not is_new then
          local terms = require "ergoterm"
          base_term = terms.Terminal:new {
            name = "basec",
            cmd = "zsh",
            layout = direction,
          }
        end

        return base_term
      end

      RUtils.map.vnoremap("<Localleader>t", function()
        local t = open_term_with_singleton(true, "float")
        if t then
          t:toggle()
        end
      end, { desc = "Terminal: new float (visual) [ergoterm]" })
      RUtils.map.nnoremap("<Localleader>t", function()
        local t = open_term_with_singleton(true, "float")
        if t then
          t:toggle()
        end
      end, { desc = "Terminal: new float [ergoterm]" })
      RUtils.map.tnoremap("<Localleader>t", function()
        local t = open_term_with_singleton(true, "float")
        if t then
          t:toggle()
        end
      end, { desc = "Terminal: new float (terminal) [ergoterm]" })

      RUtils.map.vnoremap("<a-f>", function()
        local t = open_term_with_singleton()
        if t then
          t:toggle()
        end
      end, { desc = "Terminal: toggle (visual) [ergoterm]" })
      RUtils.map.nnoremap("<a-f>", function()
        local t = open_term_with_singleton()
        if t then
          t:toggle()
        end
      end, { desc = "Terminal: toggle (visual) [ergoterm]" })
      RUtils.map.tnoremap("<a-f>", function()
        local t = open_term_with_singleton()
        if t then
          t:toggle()
        end
      end, { desc = "Terminal: toggle (visual) [ergoterm]" })

      RUtils.map.vnoremap("<a-T>", function()
        local t = open_term_with_singleton(true, "float")
        if t then
          t:toggle()
        end
      end, { desc = "Terminal: toggle (visual) [ergoterm]" })
      RUtils.map.nnoremap("<a-T>", function()
        local t = open_term_with_singleton(true, "float")
        if t then
          t:toggle()
        end
      end, { desc = "Terminal: toggle [ergoterm]" })
      RUtils.map.tnoremap("<a-T>", function()
        local t = open_term_with_singleton(true, "float")
        if t then
          t:toggle()
        end
      end, { desc = "Terminal: toggle [ergoterm]" })

      RUtils.map.nnoremap("<a-N>", function()
        local t = open_term_with_singleton(true, "tab")
        if t then
          t:toggle()
        end
      end, { desc = "Terminal: terminal tab [ergoterm" })

      RUtils.map.tnoremap("<Localleader>T", function()
        RUtils.map.feedkey("<C-\\><C-n><c-a-l>", "t")
        vim.cmd [[TermSelect]]
      end, { desc = "Terminal: select term (terminal) [ergoterm]" })
      RUtils.map.nnoremap("<Localleader>T", function()
        vim.cmd [[TermSelect]]
      end, { desc = "Terminal: select term [ergoterm]" })
      RUtils.map.vnoremap("<Localleader>T", function()
        vim.cmd [[TermSelect]]
      end, { desc = "Terminal: select term (visual) [ergoterm]" })
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
