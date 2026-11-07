if vim.g.colorscheme ~= "jellybeans" then
  return
end

local add = require("vim-pack").add
local coder = require "theme-pallete.jellybeans-coder"

add {
  {
    src = "wtfox/jellybeans.nvim",
    opts = function()
      return coder.opts()
    end,
  },
}

vim.cmd.colorscheme "jellybeans"
