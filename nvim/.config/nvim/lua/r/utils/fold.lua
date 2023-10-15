local api, cmd = vim.api, vim.cmd

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

---@param winid number
---@param lnum number
---@return number
local function foldClosed(winid, lnum)
  return winCall(winid, function()
    return vim.fn.foldclosed(lnum)
  end)
end

function M.goPreviousClosedFold()
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
