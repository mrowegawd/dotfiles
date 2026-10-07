if vim.g.colorscheme ~= "cendre" then
  return
end

local add = require("vim-pack").add

add {
  {
    src = "Aejkatappaja/cendre",
    module_name = "cendre",
    opts = function()
      return {
        background = "hard", -- "hard" | "medium" | "soft"
        italic_virtual_text = false,
      }
    end,
  },
}

vim.cmd.colorscheme "cendre"
