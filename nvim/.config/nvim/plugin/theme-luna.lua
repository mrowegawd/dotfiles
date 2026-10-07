if vim.g.colorscheme ~= "luna" then
  return
end

local add = require("vim-pack").add

add {
  {
    src = "wtfox/luna.nvim",
    setup = false,
  },
}

vim.cmd.colorscheme "luna"
