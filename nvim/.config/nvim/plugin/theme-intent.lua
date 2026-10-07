if vim.g.colorscheme ~= "intent" then
  return
end

local add = require("vim-pack").add

add {
  {
    src = "GasimGasimzada/intent.nvim",
    setup = false,
  },
}

vim.cmd.colorscheme "intent"
