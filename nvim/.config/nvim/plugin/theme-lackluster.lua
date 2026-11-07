if vim.g.colorscheme ~= "lackluster" then
  return
end

local add = require("vim-pack").add
local coder = require "theme-pallete.lackluster-coder"

add {
  {
    src = "slugbyte/lackluster.nvim",
    opts = function()
      return coder.opts()
    end,
  },
}

vim.cmd.colorscheme "lackluster"
