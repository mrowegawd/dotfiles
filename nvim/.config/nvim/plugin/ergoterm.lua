local add = require("vim-pack").add

local lazy = require("utils.plugin").require_lazy

local UtilKey = lazy "utils.map"

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
  lazy("vim-pack").load_now "ergoterm.nvim"
end

UtilKey.noremap({ "n", "x", "t" }, "<Localleader>tf", function()
  load_egoterm()
  vim.cmd "TermSelect"
end, { desc = "Terminal: term select [ergoterm.nvim]" })
UtilKey.noremap({ "n", "x", "t" }, "<Localleader>tt", function()
  load_egoterm()
  vim.cmd "TermNew layout=right"
end, { desc = "Terminal: open term right [ergoterm.nvim]" })
