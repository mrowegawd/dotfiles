if vim.g.colorscheme ~= "jellybeans" then
  return
end

local add = require("vim-pack").add

add {
  {
    src = "wtfox/jellybeans.nvim",
    setup = false,
  },
}

vim.cmd.colorscheme "jellybeans"
