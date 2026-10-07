if vim.g.colorscheme ~= "catppuccin" then
  return
end

local add = require("vim-pack").add

add {
  {
    src = "catppuccin/nvim",
    module_name = "catppuccin",
    setup = false,
  },
}

vim.cmd.colorscheme "catppuccin"
