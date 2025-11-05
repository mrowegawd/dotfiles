---@class r.utils.qf
local M = {
  copen = "belowright copen",
  lopen = "belowright lopen", -- :botright :topleft :aboveleft :belowright :leftabove :rightbelow
}

local results = {
  quickfix = {},
  location = {},
}

local Qfbookmark
local load = false

local function QfBookmarkUtil()
  if Qfbookmark and load then
    return Qfbookmark
  end

  if not RUtils.has "qfbookmark" then
    RUtils.error "QFBookLists not install!!!"
    return
  end

  Qfbookmark = require "qfbookmark.utils"
  load = true
  return Qfbookmark
end

---@param is_loc? boolean
function M.get_total_stack_qf(is_loc)
  is_loc = is_loc or false

  local qflists = {}

  if not is_loc then
    for i = 1, 10 do -- (n)vim keeps at most 10 quickfix lists in full
      local qflist = vim.fn.getqflist { nr = i, id = 0, title = true, items = true }
      if not vim.tbl_isempty(qflist.items) then
        qflists[#qflists + 1] = qflist
      end
    end
    return qflists
  end

  -- maksimal stack 10
  for i = 1, 10 do
    local loclist = vim.fn.getloclist(0, { all = "", nr = tonumber(i) })
    if not vim.tbl_isempty(loclist.items) then
      qflists[#qflists + 1] = loclist
    end
  end
  return qflists
end

---@param is_loc? boolean
function M.get_current_history_qf(is_loc)
  is_loc = is_loc or false

  if not is_loc then
    return vim.fn.getqflist({ nr = 0 }).nr
  end

  return vim.fn.getloclist(0, { nr = 0 }).nr
end

---@param is_loc? boolean
function M.get_current_idx_qf(is_loc)
  is_loc = is_loc or false

  if not is_loc then
    return vim.fn.getqflist({ idx = 0 }).idx
  end

  return vim.fn.getloclist(0, { idx = 0 }).idx
end

-- example use; M.is_loclist() and "Location List" or "Quickfix List"
---@param buf? integer
---@return boolean
function M.is_loclist(buf)
  return QfBookmarkUtil().is_loclist(buf)
end

---@param winnr integer
---@return boolean
function M.is_quickfix_win(winnr)
  return QfBookmarkUtil().is_quickfix_win(winnr)
end

---@param winnr integer
function M.is_loclist_win(winnr)
  local wininfo = vim.fn.getwininfo(vim.fn.win_getid(winnr))[1]
  return M.is_quickfix_win(winnr) and wininfo.loclist == 1
end

---@return integer
function M.get_qf_cursor_idx()
  return QfBookmarkUtil().get_current_qf_idx()
end

---@param is_loc? boolean
function M.get_title_qf(is_loc)
  return QfBookmarkUtil().get_title_qf(is_loc)
end

---@param is_loc? boolean
---@param context_name? string
---@return table
function M.get_list_qf(is_loc, context_name)
  return QfBookmarkUtil().get_list_qf(is_loc, context_name)
end

---@param is_loc? boolean
---@param context_name? string
---@return QFBookListResults
function M.get_data_qf(is_loc, context_name)
  return QfBookmarkUtil().get_data_qf(is_loc, context_name)
end

---@param list_items QFBookLists
---@param is_loc? boolean
---@param mode? string
---@param winid? integer
function M.save_to_qf(list_items, is_loc, mode, winid)
  QfBookmarkUtil().save_to_qf(list_items, is_loc, mode, winid)
end

---@param list_items QFBookLists
---@param is_loc? boolean
---@param mode? string
---@param winid? integer
function M.save_to_qf_and_auto_open_qf(list_items, is_loc, mode, winid)
  is_loc = is_loc or false
  M.save_to_qf(list_items, is_loc, mode, winid)

  if not is_loc then
    vim.cmd(M.copen)
    return
  end

  vim.cmd(M.lopen)
end

return M
