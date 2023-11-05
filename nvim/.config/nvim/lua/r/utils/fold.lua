local api, cmd = vim.api, vim.cmd

local Util = require "r.utils"

local M = {}

---@param winid number
---@param f fun(): any
---@return any
local function winCall(winid, f)
  if winid == 0 or winid == api.nvim_get_current_win() then
    return f()
  else
    return api.nvim_win_call(winid, f)
  end
end

local ctrlN_and_ctrlP = { "neo-tree", "aerial" }

---@param winid number
---@param lnum number
---@return number
local function foldClosed(winid, lnum)
  return winCall(winid, function()
    return vim.fn.foldclosed(lnum)
  end)
end

function M.goPreviousClosedFold()
  if vim.tbl_contains(ctrlN_and_ctrlP, vim.bo[0].filetype) then
    return Util.cmd.feedkey("<c-p>", "n")
  end

  if vim.bo[0].filetype == "qf" then
    vim.cmd [[
        try
            execute  "cprev"
            execute "normal! zz"
        catch /^Vim\%((\a\+)\)\=:E553/
            " execute "echo 'stop it'"
        catch /^Vim\%((\a\+)\)\=:E\%(325\|776\|42\):/
        endtry
            ]]
    -- else
    -- I got lazy convert this logic into lua, so I stole it yehahaa
    -- taken from: https://github.com/romainl/vim-qf/blob/master/autoload/qf/wrap.vim
    return vim.cmd "wincmd p"
  end

  local count = vim.v.count1
  local curLnum = api.nvim_win_get_cursor(0)[1]
  local cnt = 0
  local lnum
  for i = curLnum - 1, 1, -1 do
    if foldClosed(0, i) == i then
      cnt = cnt + 1
      lnum = i
      if cnt == count then
        break
      end
    end
  end

  if lnum then
    cmd "norm! m`"
    api.nvim_win_set_cursor(0, { lnum, 0 })
  else
    cmd "norm! zk"
  end
end

function M.goNextClosedFold()
  if vim.tbl_contains(ctrlN_and_ctrlP, vim.bo[0].filetype) then
    return Util.cmd.feedkey("<c-n>", "n")
  end

  if vim.bo[0].filetype == "qf" then
    vim.cmd [[
        try
            execute "cnext"
            execute "normal! zz"
        catch /^Vim\%((\a\+)\)\=:E553/
            " execute "echo 'stop it'"
        catch /^Vim\%((\a\+)\)\=:E\%(325\|776\|42\):/
        endtry
            ]]
    return vim.cmd "wincmd p"
  end

  local count = vim.v.count1
  local curLnum = api.nvim_win_get_cursor(0)[1]
  local lineCount = api.nvim_buf_line_count(0)
  local cnt = 0
  local lnum
  for i = curLnum + 1, lineCount do
    if foldClosed(0, i) == i then
      cnt = cnt + 1
      lnum = i
      if cnt == count then
        break
      end
    end
  end

  if lnum then
    cmd "norm! m`"
    api.nvim_win_set_cursor(0, { lnum, 0 })
  else
    cmd "norm! zj"
  end
end

return M
