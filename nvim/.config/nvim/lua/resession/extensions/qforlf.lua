local M = {}

local result = {
  quickfix = {},
  location = {},
}

M.on_save = function()
  local data_qf = RUtils.qf.get_data_qf()
  local data_loc = RUtils.qf.get_data_qf(true)

  if data_qf.quickfix.items and #data_qf.quickfix.items > 0 then
    result.quickfix.items = data_qf.quickfix.items
    result.quickfix.title = RUtils.qf.get_title_qf()
  end

  if data_loc.location.items and #data_loc.location.items > 0 then
    result.location.items = data_loc.location.items
    result.location.title = RUtils.qf.get_title_qf(true)
  end

  return result
end

M.on_pre_load = function(data)
  if data.quickfix.items and #data.quickfix.items > 0 then
    RUtils.qf.save_to_qf(data.quickfix.items, data.quickfix.title)
  end

  if data.location.items and #data.location.items > 0 then
    RUtils.qf.save_to_qf(data.quickfix.items, data.location.title, true)
  end
end

M.is_win_supported = function(winid, bufnr)
  return vim.bo[bufnr].buftype == "quickfix"
end

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
