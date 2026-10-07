return {
  { "zbirenbaum/copilot.lua", cmd = "Copilot", opts = { suggestion = { enabled = false } } },
  -- CODECOMPANION
  {
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
    dependencies = { "nvim-lua/plenary.nvim", { "ravitemer/codecompanion-history.nvim" } },
    config = function()
      RUtils.codecompanion.setup()
    end,
  },
}
