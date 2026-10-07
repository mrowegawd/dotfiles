if vim.g.colorscheme ~= "oxocarbon" then
  return
end

local add = require("vim-pack").add

add {
  {
    src = "nyoom-engineering/oxocarbon.nvim",
    setup = false,
  },
}

vim.cmd.colorscheme "oxocarbon"
