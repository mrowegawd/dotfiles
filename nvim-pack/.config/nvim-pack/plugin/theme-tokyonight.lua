local tokyonight_themes = { "tokyonight", "tokyonight-night", "tokyonight-storm" }

if not vim.tbl_contains(tokyonight_themes, vim.g.colorscheme) then
  return
end

local add = require("vim-pack").add

add {
  {
    src = "folke/tokyonight.nvim",
    opts = function()
      return {
        style = "night",
        sidebars = {
          "NeogitStatus",
        },
        styles = {
          comments = { italic = true },
        },
        dim_inactive = false,
        transparent = false,
        on_colors = function() end,
        on_highlights = function(hl, _)
          if vim.g.colorscheme == "tokyonight-night" then
            hl.Normal = {
              bg = "#0A0A0A",
              fg = "#c0caf5",
            }
          end
        end,
      }
    end,
  },
}

for _, t in pairs(tokyonight_themes) do
  if vim.g.colorscheme == t then
    vim.cmd("colorscheme " .. t)
    break
  end
end
