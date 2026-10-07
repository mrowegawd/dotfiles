if vim.g.colorscheme ~= "techbase" then
  return
end

local add = require("vim-pack").add

add {
  {
    src = "mcauley-penney/techbase.nvim",
    setup = false,
  },
}

vim.cmd.colorscheme "techbase"
