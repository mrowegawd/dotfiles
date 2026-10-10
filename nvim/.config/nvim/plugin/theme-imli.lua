if vim.g.colorscheme ~= "imli" then
  return
end

local add = require("vim-pack").add

add {
  {
    src = "hitaishi2222/imli-nvim",
    setup = false,
  },
}

vim.cmd.colorscheme "imli"
