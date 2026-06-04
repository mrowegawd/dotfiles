return {
  { "zbirenbaum/copilot.lua", cmd = "Copilot", opts = { suggestion = { enabled = false } } },
  -- CODECOMPANION
  {
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionCmd", "CodeCompanionActions" },
    keys = { { "<Leader>qi", "", desc = "Show Info/Adapter/Model/Help", ft = { "codecompanion" } } },
    dependencies = { "nvim-lua/plenary.nvim", { "ravitemer/codecompanion-history.nvim" } },
    config = function()
      RUtils.codecompanion.setup()
    end,
  },
  -- RENDER-MARKDOWN
  {
    "MeanderingProgrammer/render-markdown.nvim",
    optional = true,
    ft = { "markdown", "codecompanion" },
    opts = { file_types = { "markdown", "codecompanion" } },
  },
}
