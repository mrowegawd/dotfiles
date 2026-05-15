return {
  -- CCCPICK
  {
    "uga-rosa/ccc.nvim",
    cmd = { "CccPick", "CccHighlighterToggle" },
    keys = {
      { "<Leader>uC", "<cmd>CccPick<cr>", desc = "Toggle: pick color [ccc.nvim]" },
      { "<Leader>uc", vim.cmd.CccHighlighterToggle, desc = "Toggle: ccc [ccc.nvim]" },
    },
    opts = {
      highlighter = {
        auto_enable = false,
        lsp = false,
      },
    },
  },
}
