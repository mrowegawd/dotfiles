if vim.g.colorscheme ~= "zenburn" then
  return
end

local add = require("vim-pack").add

add {
  {
    src = "MadKuntilanak/zenburn.nvim",
    setup = false,
  },
}

vim.cmd "colorscheme zenburn"
