if vim.g.colorscheme ~= "vscode" then
  return
end

local add = require("vim-pack").add
local coder = require "theme-pallete.vscode_coder"

add {
  {
    src = "Mofiqul/vscode.nvim",
    opts = {
      color_overrides = coder.color_overrides or {},
      group_overrides = coder.group_overrides or {},
    },
  },
}

vim.cmd "colorscheme vscode"
