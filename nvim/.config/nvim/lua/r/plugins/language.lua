vim.g.translator_target_lang = "id"

return {
  -- TRANSLATE.NVIM
  {
    "voldikss/vim-translator",
    cmd = "TranslateW",
    keys = {
      {
        "<Leader>ut",
        "<Plug>TranslateWV",
        desc = "Misc: translate on select visual mode [vim-translator]",
        mode = { "x" },
      },
    },
  },
}
