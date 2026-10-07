local add = require("vim-pack").add

local UtilKey = require "utils.map"

add {
  {
    src = "voldikss/vim-translator",
    setup = false,
    lazy = true,
  },
}

vim.g.translator_target_lang = "idn"

UtilKey.noremap({ "n", "o", "x" }, "gt", function()
  UtilKey.plugin_load_now "vim-translator"
  vim.api.nvim_feedkeys(
    vim.keycode "<Plug>TranslateWV",
    "m",
    false
  )
end, { desc = "Misc: use translator [vim-translator]" })
