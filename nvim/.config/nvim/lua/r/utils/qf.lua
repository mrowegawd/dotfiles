---@class r.utils.qf
local M = {}

-- example use; M.is_loclist() and "Location List" or "Quickfix List"
function M.is_loclist()
  return vim.fn.getloclist(0, { filewinid = 1 }).filewinid ~= 0
end

return M
