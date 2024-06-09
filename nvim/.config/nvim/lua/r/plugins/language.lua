vim.g.translator_target_lang = "id"

return {
  -- TRANSLATE.NVIM
  {
    "voldikss/vim-translator",
    keys = {
      { "<Leader>RS", "<Plug>TranslateW", desc = "Misc: translate on cursor [vim-translator]" },
      {
        "<Leader>RS",
        "<Plug>TranslateWV",
        desc = "Misc: translate on select visual mode [vim-translator]",
        mode = { "v" },
      },
    },
  },
  -- VIM-GRAMMAROUS (disabled)
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
