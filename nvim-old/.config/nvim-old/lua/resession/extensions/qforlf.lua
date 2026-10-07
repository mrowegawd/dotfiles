local M = {}

---@type QFBookListResults
local result = {
  quickfix = {},
  location = {},
}

local load_qf = false

M.on_save = function()
  local qflist = RUtils.qf.get_data_qf()
  local loclist = RUtils.qf.get_data_qf(true)

  --- QUICKFIX
  if qflist.quickfix.items and #qflist.quickfix.items > 0 then
    result.quickfix = {
      items = vim.deepcopy(qflist.quickfix.items),
      title = qflist.quickfix.title,
      context = (type(qflist.quickfix.context) == "table") and vim.deepcopy(qflist.quickfix.context)
        or qflist.quickfix.context,
    }
  end

  --- LOCLIST
  if loclist.location.items and #loclist.location.items > 0 then
    result.location = {
      items = vim.deepcopy(loclist.location.items),
      title = loclist.location.title,
      context = (type(loclist.location.context) == "table") and vim.deepcopy(loclist.location.context)
        or loclist.location.context,
    }
  end

  return result
end

---@param data QFBookListResults
M.on_pre_load = function(data)
  if load_qf then
    return
  end
  load_qf = true

  --- QUICKFIX
  if data.quickfix.items and #data.quickfix.items > 0 then
    local list_items = {
      items = data.quickfix.items,
      title = data.quickfix.title,
      context = (type(data.quickfix.context) == "table") and vim.deepcopy(data.quickfix.context)
        or data.quickfix.context,
    }
    RUtils.qf.save_to_qf(list_items)
  end

  --- LOCLIST
  if data.location.items and #data.location.items > 0 then
    local list_items = {
      items = data.location.items,
      title = data.location.title,
      context = (type(data.location.context) == "table") and vim.deepcopy(data.location.context)
        or data.location.context,
    }
    RUtils.qf.save_to_qf(list_items, true)
  end
end

---@param winid integer
---@param bufnr integer
M.is_win_supported = function(winid, bufnr)
  return vim.bo[bufnr].buftype == "quickfix"
end

---@param winid integer
M.save_win = function(winid)
  return {}
end

M.load_win = function(winid, config)
  -- vim.api.nvim_set_current_win(winid)
  -- if #result.location > 0 then
  --   vim.cmd "belowright lopen"
  -- end
  vim.api.nvim_win_close(winid, true)
  return vim.api.nvim_get_current_win()
end

return M
