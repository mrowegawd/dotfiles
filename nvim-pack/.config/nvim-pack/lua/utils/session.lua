local M = {}

function M.last_session_name()
  local cwd = vim.uv.cwd() or ""
  local safe = cwd:gsub("[^%w%-_]", "_"):gsub("_+", "_"):gsub("^_", ""):gsub("_$", "")
  return "last__" .. safe
end

return M
