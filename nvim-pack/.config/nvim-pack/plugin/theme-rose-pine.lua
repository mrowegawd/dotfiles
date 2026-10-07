if vim.g.colorscheme ~= "rose-pine" then
  return
end

local add = require("vim-pack").add

add {
  {
    src = "rose-pine/neovim",
    module_name = "rose-pine",
    opts = {
      styles = {
        bold = true,
        italic = false,
        transparency = false,
      },
      highlight_groups = {
        Normal = { bg = "#12171c" },
      },
    },
  },
}

vim.cmd.colorscheme "rose-pine"
