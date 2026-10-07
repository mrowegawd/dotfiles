if vim.g.colorscheme ~= "vscode" then
  return
end

local add = require("vim-pack").add

add {
  {
    src = "Mofiqul/vscode.nvim",
    opts = {
      group_overrides = {
        Normal = { bg = "#191919", fg = "#d4d4d4" },
        Directory = { bg = "NONE", fg = "#569cd6" },
      },
    },
  },
}

vim.cmd "colorscheme vscode"
