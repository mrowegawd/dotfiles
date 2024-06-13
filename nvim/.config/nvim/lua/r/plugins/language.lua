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
}
