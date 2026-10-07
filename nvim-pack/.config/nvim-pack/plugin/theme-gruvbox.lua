if vim.g.colorscheme ~= "gruvbox" then
  return
end

local add = require("vim-pack").add

add {
  {
    src = "motaz-shokry/gruvbox.nvim",
    opts = function()
      return {
        variant = "hard", -- auto, hard, medium, soft, light
      }
    end,
  },
}

vim.cmd.colorscheme "gruvbox"
