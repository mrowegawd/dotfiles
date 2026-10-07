if vim.g.colorscheme ~= "kanagawa" then
  return
end

local add = require("vim-pack").add

add {
  {
    src = "rebelot/kanagawa.nvim",
    opts = {
      theme = "dragon", -- Load "wave" theme
      background = { -- map the value of 'background' option to a theme
        dark = "wave", -- try "dragon" !
        light = "lotus",
      },
      overrides = function()
        return {
          Normal = { bg = vim.g.colorscheme == "kanagawa-lotus" and "#C8C093" or "#0B0B0B" },
        }
      end,
    },
  },
}

vim.cmd.colorscheme "kanagawa"
