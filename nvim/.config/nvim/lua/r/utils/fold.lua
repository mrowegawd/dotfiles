---@class r.utils.fold
local M = {}

local fold_levels = { 0, 1, 2, 3, 99 }

local current_index = 1

function M.cycle_fold_level()
  current_index = current_index + 1
  if current_index > #fold_levels then
    current_index = 1
  end
  local new_level = fold_levels[current_index]
  vim.o.foldlevel = new_level
  -- if new_level == 0 then
  ---@diagnostic disable-next-line: undefined-field
  RUtils.info("Fold level set to: " .. new_level, { title = "Folds" })
  -- end
end

return M
