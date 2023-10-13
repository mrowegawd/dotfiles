vim.opt.buflisted = false

local keymap, api = vim.keymap, vim.api

-- Disable ctrl-i and ctrl-o
keymap.set("n", "<c-i>", "<Nop>", {
  buffer = api.nvim_get_current_buf(),
})
keymap.set("n", "<c-o>", "<Nop>", {
  buffer = api.nvim_get_current_buf(),
})

-- keymap.set("n", "<c-n>", "<down><CR>zz<c-w>p", {
--     silent = true,
--     buffer = vim.api.nvim_get_current_buf(),
-- })
-- keymap.set("n", "<c-p>", "<UP><CR>zz<c-w>p", {
--     silent = true,
--     buffer = vim.api.nvim_get_current_buf(),
-- })

keymap.set("n", "<c-n>", function()
  local ft, _ = as.get_bo_buft()

  if ft == "Trouble" or ft == "lspsagafinder" then
    api.nvim_feedkeys("j", "n", true)
    return
  end

  if ft ~= "qf" then
    vim.cmd [[
        try
            execute "cnext"
        catch /^Vim\%((\a\+)\)\=:E553/
            " execute "echo 'stop it'"
        catch /^Vim\%((\a\+)\)\=:E\%(325\|776\|42\):/
        endtry
            ]]
  else
    vim.cmd "wincmd p"
  end
end, { silent = true })
keymap.set("n", "<c-p>", function()
  local ft, _ = as.get_bo_buft()

  if ft == "Trouble" or ft == "lspsagafinder" then
    api.nvim_feedkeys("k", "n", true)
    return
  end

  if ft ~= "qf" then
    vim.cmd [[
        try
            execute  "cprevious"
        catch /^Vim\%((\a\+)\)\=:E553/
            " execute "echo 'stop it'"
        catch /^Vim\%((\a\+)\)\=:E\%(325\|776\|42\):/
        endtry
            ]]
  else
    -- I got lazy convert this logic into lua, so I stole it yehahaa
    -- taken from: https://github.com/romainl/vim-qf/blob/master/autoload/qf/wrap.vim
    vim.cmd "wincmd p"
  end
end, { silent = true })

keymap.set("n", "gh", function()
  vim.cmd [[
            try
                execute "colder"
            catch /^Vim\%((\a\+)\)\=:E\%(380\|381\):/
                " execute "echo 'yo stop it'"
            endtry
            ]]
end, {
  silent = true,
  buffer = vim.api.nvim_get_current_buf(),
  desc = "Qf: colder",
})
keymap.set("n", "gl", function()
  vim.cmd [[
            try
                execute "cnewer"
            catch /^Vim\%((\a\+)\)\=:E\%(380\|381\):/
                " execute "echo 'yo stop it'"
            endtry
            ]]
end, {
  silent = true,
  buffer = vim.api.nvim_get_current_buf(),
  desc = "Qf: cnewer",
})

vim.keymap.set("n", "<c-d>", function()
  local pvs = require "bqf.preview.session"

  if pvs.validate() then
    return require("bqf.preview.handler").scroll(1)
  else
    return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-d>", true, true, true), "n", true)
  end
end, {
  silent = true,
  buffer = vim.api.nvim_get_current_buf(),
})
vim.keymap.set("n", "<c-u>", function()
  local pvs = require "bqf.preview.session"

  if pvs.validate() then
    return require("bqf.preview.handler").scroll(-1)
  else
    return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-u>", true, true, true), "n", true)
  end
end, {
  silent = true,
  buffer = vim.api.nvim_get_current_buf(),
})

as.augroup("ColorQuickFixLine", {
  event = { "BufRead", "WinEnter", "FocusGained", "VimEnter", "BufEnter" },
  command = function()
    if vim.bo.filetype ~= "qf" then
      vim.cmd [[ execute 'hi! link QuickFixLine MyQuickFixLineLeave' ]]
      vim.cmd [[execute 'hi! link CursorLine MyCursorline' ]]
      return
    end
    -- vim.cmd [[execute 'hi! link QuickFixLine MyQuickFixLineEnter' ]]
    vim.cmd [[execute 'hi! link CursorLine MyQuickFixLineEnter' ]]
  end,
})
