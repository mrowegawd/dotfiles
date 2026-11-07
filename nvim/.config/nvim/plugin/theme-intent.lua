if vim.g.colorscheme ~= "intent" then
  return
end

local add = require("vim-pack").add

vim.g.intent_italic_params = false
vim.g.intent_cursorline = false
vim.g.intent_terminal = false

add {
  {
    src = "MadKuntilanak/intent.nvim",
    setup = false,
  },
}

vim.cmd.colorscheme "intent"
