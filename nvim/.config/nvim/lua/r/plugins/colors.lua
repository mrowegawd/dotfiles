return {
  -- CCCPICK
  {
    "uga-rosa/ccc.nvim",
    cmd = { "CccPick", "CccHighlighterToggle" },
    keys = {
      { "<Leader>oP", "<cmd>CccPick<cr>", desc = "Open: pick color [ccc.nvim]" },
    },
    opts = {
      highlighter = {
        auto_enable = false,
        lsp = false,
      },
    },
  },
}
