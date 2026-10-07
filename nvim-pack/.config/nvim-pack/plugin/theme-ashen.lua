if vim.g.colorscheme ~= "ashen" then
  return
end

local add = require("vim-pack").add

add {
  {
    src = "ficcdaf/ashen.nvim",
    setup = false,
  },
}

vim.cmd.colorscheme "ashen"
