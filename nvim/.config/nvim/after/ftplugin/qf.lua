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

keymap.set("n", "gh", function()
  vim.cmd [[
            try
                execute "colder"
            catch /^Vim\%((\a\+)\)\=:E\%(380\|381\):/
                " execute "echo 'yo stop it'"
            endtry
            ]]
end, { silent = true, buffer = vim.api.nvim_get_current_buf(), desc = "Qf: colder" })
keymap.set("n", "gl", function()
  vim.cmd [[
            try
                execute "cnewer"
            catch /^Vim\%((\a\+)\)\=:E\%(380\|381\):/
                " execute "echo 'yo stop it'"
            endtry
            ]]
end, { silent = true, buffer = vim.api.nvim_get_current_buf(), desc = "Qf: cnewer" })
vim.keymap.set("n", "<c-d>", function()
  local pvs = require "bqf.preview.session"

  if pvs.validate() then
    return require("bqf.preview.handler").scroll(1)
  else
    return Util.cmd.feedkey("<C-d>", "n")
  end
end, { silent = true, buffer = vim.api.nvim_get_current_buf() })

vim.keymap.set("n", "<c-u>", function()
  local pvs = require "bqf.preview.session"

  if pvs.validate() then
    return require("bqf.preview.handler").scroll(-1)
  else
    return Util.cmd.feedkey("<C-u>", "n")
  end
end, { silent = true, buffer = vim.api.nvim_get_current_buf() })

Util.cmd.augroup("ColorQuickFixLine", {
  event = { "BufRead", "WinEnter", "FocusGained", "VimEnter", "BufEnter" },
  command = function()
    if vim.bo.filetype ~= "qf" then
      vim.cmd [[execute 'hi! link QuickFixLine MyQuickFixLineLeave' ]]
      return
    end
  end,
})
