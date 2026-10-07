local add = require("vim-pack").add

local UtilKey = require "utils.map"

-- Navigation with jump motions.
add {
  {
    src = "waiting-for-dev/ergoterm.nvim",
    lazy = true,
    opts = function()
      return {
        picker = { picker = "fzf-lua" },
        terminal_defaults = { float_winblend = 0 },
      }
    end,
  },
}

local load_egoterm = function()
  require("vim-pack").load_now "ergoterm.nvim"
end

UtilKey.nnoremap("<Leader>oT", function()
  load_egoterm()
  vim.cmd "TermSelect"
end, { desc = "Open: terminal select [ergoterm.nvim]" })
UtilKey.nnoremap("<Leader>ot", function()
  load_egoterm()
  vim.cmd "TermNew layout=right"
end, { desc = "Open: terminal right [ergoterm.nvim]" })
