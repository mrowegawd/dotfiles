local base_term = nil

return {
  -- ERGOTERM
  {
    "waiting-for-dev/ergoterm.nvim",
    cmd = "TermNew",
    keys = {
      -- { "<Localleader>t", mode = { "n", "t", "x" } },
      { "<a-f>", mode = { "n", "t", "x" } },
      { "<a-N>" },

      {
        "<Leader>oT",
        function()
          vim.cmd "TermSelect"
        end,
        desc = "Open: terminal select [ergoterm.nvim]",
      },
      {
        "<Leader>ot",
        function()
          vim.cmd "TermNew layout=right"
        end,
        desc = "Open: terminal right [ergoterm.nvim]",
      },
    },
    opts = {
      picker = { picker = "fzf-lua" },
      terminal_defaults = { float_winblend = 0 },
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

      RUtils.map.xnoremap("<Localleader>t", function()
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

      RUtils.map.xnoremap("<a-f>", function()
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

      RUtils.map.nnoremap("<a-N>", function()
        local t = open_term_with_singleton(true, "tab")
        if t then
          t:toggle()
        end
      end, { desc = "Terminal: terminal tab [ergoterm" })

      -- RUtils.map.tnoremap("<Localleader>T", function()
      --   RUtils.map.feedkey("<C-\\><C-n><c-a-l>", "t")
      --   vim.cmd [[TermSelect]]
      -- end, { desc = "Terminal: select term (terminal) [ergoterm]" })
      RUtils.map.nnoremap("<Localleader>T", function()
        vim.cmd [[TermSelect]]
      end, { desc = "Terminal: select term [ergoterm]" })
      RUtils.map.xnoremap("<Localleader>T", function()
        vim.cmd [[TermSelect]]
      end, { desc = "Terminal: select term (visual) [ergoterm]" })

      local function open_terminal_float()
        local function __open_term()
          if vim.g.open_terminal_in_filetree == nil or not vim.g.open_terminal_in_filetree then
            local t = open_term_with_singleton(true, "float")
            if t then
              t:toggle()
            end
          end
        end

        if vim.g.open_terminal_in_filetree then
          vim.ui.input({
            prompt = "Terminal filetree is opened, kill anyway? (y/n) ",
          }, function(input)
            if input == "y" then
              vim.g.open_terminal_in_filetree = false
              __open_term()
            end
          end)
        end

        __open_term()
      end

      RUtils.map.xnoremap("<a-T>", function()
        open_terminal_float()
      end, { desc = "Terminal: toggle (visual) [ergoterm]" })
      RUtils.map.nnoremap("<a-T>", function()
        open_terminal_float()
      end, { desc = "Terminal: toggle [ergoterm]" })
      RUtils.map.tnoremap("<a-T>", function()
        open_terminal_float()
      end, { desc = "Terminal: toggle [ergoterm]" })
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
        mode = { "n", "x", "t" },
      },
      {
        "<a-f>",
        function()
          vim.cmd [[FloatermToggle]]
        end,
        desc = "Terminal: toggle [floaterm]",
        mode = { "n", "x", "t" },
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
  },
}
