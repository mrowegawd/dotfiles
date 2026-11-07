if vim.g.colorscheme ~= "catppuccin" then
  return
end

local add = require("vim-pack").add
local coder = require "theme-pallete.catppuccin-coder"

add {
  {
    src = "catppuccin/nvim",
    module_name = "catppuccin",
    on_setup = function()
      coder.setup()
    end,
  },
}

vim.cmd.colorscheme "catppuccin"
