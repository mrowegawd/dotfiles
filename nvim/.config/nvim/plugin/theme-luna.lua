if vim.g.colorscheme ~= "luna" then
  return
end

local add = require("vim-pack").add
local coder = require "theme-pallete.luna-coder"

add {
  {
    src = "wtfox/luna.nvim",
    setup = false,
    on_setup = function()
      coder.setup()
    end,
  },
}

vim.cmd.colorscheme "luna"
