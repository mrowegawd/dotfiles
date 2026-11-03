local add = require("vim-pack").add

local UtilKey = require "utils.map"

-- Plugin: azabiong/vim-highlighter
-- delete jika tidak dibutuhkan or commented
vim.g.HiSet = ""
vim.g.HiErase = ""
vim.g.HiClear = ""
vim.g.HiFind = ""
vim.g.HiSetSL = ""
vim.g.HiFindTool = "rg -H --color=never --no-heading --column --smart-case"

-- Surround selections, add quotes, etc.
add {
  {
    src = "azabiong/vim-highlighter",
    lazy = true,
    setup = false,
  },
}

local load_vim_highlighter = function()
  require("vim-pack").load_now "vim-highlighter"
end

UtilKey.noremap({ "n", "x" }, "<Leader>uh", function()
  load_vim_highlighter()
  local UtilCmd = require "utils.cmd"
  local ok, _ = UtilCmd.get_vim_mode()
  if ok then
    local word = UtilCmd.get_selection()
    vim.cmd(":Hi + " .. word)
    return
  end

  vim.cmd ":Hi + "
end, { desc = "Toggle: highlight word/selection [vim-highlighter]" })
