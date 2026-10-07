return {
  -- ERGOTERM
  {
    "waiting-for-dev/ergoterm.nvim",
    cmd = "TermNew",
    keys = {
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
