if vim.g.colorscheme ~= "everforest" then
  return
end

local add = require("vim-pack").add
local coder = require "theme-pallete.everforest-coder"

add {
  {
    src = "neanias/everforest-nvim",
    setup = false,
    on_setup = function()
      require("everforest").setup(coder.setup)
    end,
  },
}

vim.cmd.colorscheme "everforest"
