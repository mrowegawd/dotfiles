return {
  -- NVIM-HIGHLIGHT-COLORS
  {
    "brenoprata10/nvim-highlight-colors",
    keys = {
      {
        "<Leader>uc",
        function()
          local is_active = require("nvim-highlight-colors").is_active()
          if is_active then
            require("nvim-highlight-colors").turnOff()
            RUtils.info("Turn Off", { title = "nvim-highlight-colors" })
          else
            require("nvim-highlight-colors").turnOn()
            RUtils.info("Turn On", { title = "nvim-highlight-colors" })
          end
        end,
        desc = "Toggle: highlight colors [nvim-highlight-colors]",
      },
    },
    opts = {
      ---Render style
      ---@usage 'background'|'foreground'|'virtual'
      render = "virtual",

      ---Set virtual symbol (requires render to be set to 'virtual')
      virtual_symbol = "■",

      ---Highlight named colors, e.g. 'green'
      enable_named_colors = true,

      ---Highlight tailwind colors, e.g. 'bg-blue-500'
      enable_tailwind = false,

      ---Set custom colors
      ---Label must be properly escaped with '%' to adhere to `string.gmatch`
      --- :help string.gmatch
      custom_colors = {
        { label = "%-%-theme%-primary%-color", color = "#0f1219" },
        { label = "%-%-theme%-secondary%-color", color = "#5a5d64" },
      },
      -- exclude_buffer = function(bufnr)
      --   return vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr)) > 10000
      -- end,
    },
  },
  -- NVIM-COLORIZER (disabled)
  {
    "catgoose/nvim-colorizer.lua",
    enabled = false,
    event = "BufReadPre",
    opts = {},
  },
  -- CCCPICK (disabled)
  {
    "uga-rosa/ccc.nvim",
    enabled = false,
    cmd = { "CccPick", "CccHighlighterToggle" },
    ft = { "html", "css", "sass", "less", "javascript", "typescript", "javascriptreact", "typescriptreact", "lua" },
    opts = {},
  },
}
