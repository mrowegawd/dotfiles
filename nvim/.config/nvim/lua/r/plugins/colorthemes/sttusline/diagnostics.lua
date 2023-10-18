local M = {}

M.sources = {

  nvim_lsp = function()
    local error_count, warning_count, info_count, hint_count
    local diagnostics = vim.diagnostic.get(0)
    local count = { 0, 0, 0, 0 }
    for _, diagnostic in ipairs(diagnostics) do
      if vim.startswith(vim.diagnostic.get_namespace(diagnostic.namespace).name, "vim.lsp") then
        count[diagnostic.severity] = count[diagnostic.severity] + 1
      end
    end
    error_count = count[vim.diagnostic.severity.ERROR]
    warning_count = count[vim.diagnostic.severity.WARN]
    info_count = count[vim.diagnostic.severity.INFO]
    hint_count = count[vim.diagnostic.severity.HINT]
    return error_count, warning_count, info_count, hint_count
  end,
}
---returns list of diagnostics count from all sources
---@param sources table list of sources
---@return table {{error_count, warning_count, info_count, hint_count}}
M.get_diagnostics = function(sources)
  local result = {}
  for index, source in ipairs(sources) do
    if type(source) == "string" then
      local error_count, warning_count, info_count, hint_count = M.sources[source]()
      result[index] = {
        error = error_count,
        warn = warning_count,
        info = info_count,
        hint = hint_count,
      }
    elseif type(source) == "function" then
      local source_result = source()
      source_result = type(source_result) == "table" and source_result or {}
      result[index] = {
        error = source_result.error or 0,
        warn = source_result.warn or 0,
        info = source_result.info or 0,
        hint = source_result.hint or 0,
      }
    end
  end
  return result
end

return M
