local keymap, api = vim.keymap, vim.api

local Util = require "r.utils"

vim.opt.buflisted = false

-- Disable ctrl-i and ctrl-o
keymap.set("n", "<c-i>", "<Nop>", {
  buffer = api.nvim_get_current_buf(),
})
keymap.set("n", "<c-o>", "<Nop>", {
  buffer = api.nvim_get_current_buf(),
})

Util.cmd.augroup("ColorQuickFixLine", {
  event = { "BufRead", "WinEnter", "FocusGained", "VimEnter", "BufEnter" },
  command = function()
    if vim.bo.filetype ~= "qf" then
      vim.cmd [[execute 'hi! link QuickFixLine MyQuickFixLineLeave' ]]
      vim.cmd [[execute 'hi! link CursorLine MyCursorLine' ]]
    elseif vim.bo.filetype == "qf" then
      -- vim.cmd [[execute 'hi! link CursorLine MyQuickFixLineEnter' ]]
      vim.cmd [[execute 'hi! link QuickFixLine MyQuickFixLine' ]]
    end
  end,
})
