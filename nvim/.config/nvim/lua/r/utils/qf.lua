local M = {}

-- example use; as.is_loclist() and "Location List" or "Quickfix List"
function M.is_loclist()
  return vim.fn.getloclist(0, { filewinid = 1 }).filewinid ~= 0
end

return M
