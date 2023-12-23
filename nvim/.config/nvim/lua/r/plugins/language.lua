return {
  -- TRANSLATE.NVIM
  {
    "voldikss/vim-translator",
    event = "VeryLazy",
    keys = { "<Plug>TranslateW", "<Plug>TranslateWV" },
    init = function()
      vim.g.translator_target_lang = "id"
      vim.api.nvim_set_keymap("n", "<Leader>rs", "<Plug>TranslateW", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("v", "<Leader>rs", "<Plug>TranslateWV", { noremap = true, silent = true })
    end,
  },
  -- VIM-GRAMMAROUS
  {
    "rhysd/vim-grammarous",
    cmd = { "GrammarousCheck" },
    ft = { "markdown", "txt" },
    enabled = false,
    config = function()
      local lazy = require "lazy"
      lazy.load { plugins = "vim-grammarous" }
    end,
  },
}
