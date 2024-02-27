return {
  -- CCC
  {
    "uga-rosa/ccc.nvim",
    cmd = { "CccPick", "CccConvert", "CccHighlighterToggle" },
    config = function()
      local ccc = require "ccc"
      ccc.setup {
        highlighter = {
          auto_enable = true,
          excludes = {
            "dart",
            "lazy",
            "orgagenda",
            "org",
            "NeogitStatus",
            "toggleterm",
          },
        },
      }
    end,
  },
}
