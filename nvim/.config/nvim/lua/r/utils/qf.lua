---@class r.utils.qf
local M = {}

-- example use; M.is_loclist() and "Location List" or "Quickfix List"
function M.is_loclist(buf)
  buf = buf or 0
  return vim.fn.getloclist(buf, { filewinid = 1 }).filewinid ~= 0
end

function M.get_qf_cursor_idx()
  local cur_list = {}
  local count = vim.v.count
  if count == 0 then
    count = 1
  end
  if count > #cur_list then
    count = #cur_list
  end

  local item = api.nvim_win_get_cursor(0)[1]
  for _ = item, item + count - 1 do
    table.remove(cur_list, item)
  end

  return vim.fn.getqflist()[item]
end

return M
