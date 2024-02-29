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

local ctrlN_and_ctrlP = { "neo-tree", "aerial" }

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

-- local function find_markdown()
--   local tbl_wins = {}
--   for _, winnr in ipairs(vim.fn.range(1, vim.fn.winnr "$")) do
--     if not vim.tbl_contains({ "incline" }, vim.fn.getwinvar(winnr, "&syntax")) then
--       local winbufnr = vim.fn.winbufnr(winnr)
--
--       if winbufnr > 0 then
--         local winft = vim.api.nvim_buf_get_option(winbufnr, "filetype")
--         if #winft > 0 then
--           table.insert(tbl_wins, winft)
--         end
--       end
--     end
--   end
--
--   local found = false
--   for _, x in pairs(tbl_wins) do
--     if x == "qf" then
--       found = true
--     end
--   end
--   return found
-- end

function M.goPreviousClosedFold()
  if vim.tbl_contains(ctrlN_and_ctrlP, vim.bo[0].filetype) then
    return Util.cmd.feedkey("<c-p>", "n")
  end

  -- if find_markdown() then
  if qf_is_opened() then
    if vim.bo[0].filetype ~= "qf" then
      vim.schedule(function()
        local _, err = pcall(function()
          vim.cmd "cprevious"
          vim.cmd "normal! zz"
        end)

        if err and string.match(err, "E553") then
          vim.cmd "clast"
        end
      end)
    else
      vim.schedule(function()
        vim.cmd "wincmd p"
      end)
      return
    end
  end
  -- end

  if vim.bo.filetype == "markdown" then
    vim.cmd [[MkdnPrevHeading]]
    return
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

  -- if find_markdown() then
  if qf_is_opened() then
    if vim.bo[0].filetype ~= "qf" then
      vim.schedule(function()
        local _, err = pcall(function()
          vim.cmd "cnext"
          vim.cmd "normal! zz"
        end)

        if err and string.match(err, "E553") then
          vim.cmd "cfirst"
        end
      end)
    else
      vim.schedule(function()
        vim.cmd "wincmd p"
      end)
      return
    end
  end
  -- end

  if vim.bo.filetype == "markdown" then
    vim.cmd [[MkdnNextHeading]]
    return
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
