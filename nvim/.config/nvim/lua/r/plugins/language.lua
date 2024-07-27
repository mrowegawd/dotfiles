vim.g.translator_target_lang = "id"

return {
  -- TRANSLATE.NVIM
  {
    "voldikss/vim-translator",
    keys = {
      { "<Localleader>ot", "<Plug>TranslateW", desc = "Misc: translate on cursor [vim-translator]" },
      {
        "<Localleader>ot",
        "<Plug>TranslateWV",
        desc = "Misc: translate on select visual mode [vim-translator]",
        mode = { "v" },
      },
    },
  },
}
