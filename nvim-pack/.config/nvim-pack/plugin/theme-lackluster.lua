if vim.g.colorscheme ~= "lackluster" then
  return
end

local add = require("vim-pack").add

add {
  {
    src = "slugbyte/lackluster.nvim",
    opts = function()
      return {
        tweak_background = {
          normal = "#050505",
        },
      }
    end,
  },
}

vim.cmd.colorscheme "lackluster"
