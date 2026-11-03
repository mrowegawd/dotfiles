if not vim.tbl_contains({ "ef-cherie", "ef-eagle", "ef-dream", "ef-rosa" }, vim.g.colorscheme) then
  return
end

local add = require("vim-pack").add
local coder = require "theme-pallete.ef-coder"

add {
  {
    src = "oonamo/ef-themes.nvim",
    opts = function()
      return {
        on_colors = function(colors, name)
          coder.apply(name, colors)
        end,
      }
    end,
  },
}

vim.cmd.colorscheme(vim.g.colorscheme)
