---@class r.utils.qf
local M = {}

-- example use; M.is_loclist() and "Location List" or "Quickfix List"
function M.is_loclist(buf)
  buf = buf or 0
  return vim.fn.getloclist(buf, { filewinid = 1 }).filewinid ~= 0
end

return M
