return {
  -- CHATGPT
  {
    "jackMort/ChatGPT.nvim",
    enabled = false,
    cmd = { "ChatGPT", "ChatGPTActAs" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = true,
  },
}
