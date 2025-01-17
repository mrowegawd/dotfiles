local ccc_filetypes =
  { "html", "css", "sass", "less", "javascript", "typescript", "javascriptreact", "typescriptreact", "lua" }

return {
  -- NVIM-HIGHLIGHT-COLORS
  {
    "brenoprata10/nvim-highlight-colors",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-highlight-colors").setup {
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
      }
    end,
  },
  -- CCCPICK
  {
    "uga-rosa/ccc.nvim",
    cmd = { "CccPick", "CccHighlighterToggle" },
    ft = ccc_filetypes,
    opts = {},
  },
}
