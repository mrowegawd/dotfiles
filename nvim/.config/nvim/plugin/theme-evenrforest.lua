if vim.g.colorscheme ~= "everforest" then
  return
end

local add = require("vim-pack").add

add {
  {
    src = "neanias/everforest-nvim",
    setup = false,
    on_setup = function()
      -- 03:12:07 AM msg_show.list_cmd   hi NormalNote NormalNote     xxx guifg=#a09986 guibg=#1b2023
      require("everforest").setup {
        on_highlights = function(hl, palette)
          hl.Normal = { bg = "#1b2023", fg = "#a09986" }
          --   -- hl.DiagnosticWarn = { fg = palette.none, bg = palette.none, sp = palette.yellow }
          --   -- hl.DiagnosticInfo = { fg = palette.none, bg = palette.none, sp = palette.blue }
          --   -- hl.DiagnosticHint = { fg = palette.none, bg = palette.none, sp = palette.green }
        end,
        -- Your config here
      }
    end,
  },
}

vim.cmd.colorscheme "everforest"
