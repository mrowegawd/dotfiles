local api, cmd, fn = vim.api, vim.cmd, vim.fn

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

local ft_disabled = { "neo-tree", "aerial" }

---@param winid number
---@param lnum number
---@return number
local function foldClosed(winid, lnum)
  return winCall(winid, function()
    return vim.fn.foldclosed(lnum)
  end)
end

local function qf_is_opened()
  local qf_opened = false
  for _, winnr in ipairs(fn.range(1, fn.winnr "$")) do
    if fn.getwinvar(winnr, "&syntax") == "qf" then
      qf_opened = true
    end
  end
  return qf_opened
end

function M.magic_prev_next_move(is_qf)
  is_qf = is_qf or false

  if vim.tbl_contains(ft_disabled, vim.bo[0].filetype) then
    return Util.cmd.feedkey("<c-p>", "n")
  end

  if vim.wo.diff then
    return Util.cmd.feedkey("[c", "n")
  end

  -- if qf_is_opened() then
  if vim.bo[0].filetype == "qf" then
    local cmd_msg_qf = "cnext"
    local cmd_msg_qf_end = "cfirst"

    if is_qf then
      cmd_msg_qf = "cprevious"
      cmd_msg_qf_end = "clast"
    end

    vim.schedule(function()
      local _, err = pcall(function()
        vim.cmd(cmd_msg_qf)
        vim.cmd "wincmd p"
        vim.cmd "normal! zz"
      end)

      if err and string.match(err, "E553") then
        vim.cmd(cmd_msg_qf_end)
        vim.cmd "wincmd p"
      end
    end)

    -- vim.schedule(function()
    -- end)
  end
  -- end

  if is_qf then
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
  else
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
end

function M.magic_prev_next_qf(is_next)
  is_next = is_next or false
  local cmd_msg

  if qf_is_opened() then
    cmd_msg = "cnewer"

    if is_next then
      cmd_msg = "colder"
    end

    if vim.bo[0].filetype ~= "qf" then
      vim.cmd "wincmd p"
    end

    vim.schedule(function()
      local _, err = pcall(function()
        vim.fn.execute(cmd_msg)
      end)

      -- TODO: how to get these errors msg?? #today
      if err and (string.match(err, "E380") or string.match(err, "E381")) then
        -- what to do
        return
      end
    end)
  else
    cmd_msg = "bnext"

    if is_next then
      cmd_msg = "bprev"
    end
    vim.cmd(cmd_msg)
  end
end

return M
