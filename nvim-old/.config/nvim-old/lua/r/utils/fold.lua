-- =============================================================================
-- Fold: State-aware fold level cycling
-- Strategy: Option 1 + Option 3
--   - `zb`  → cycle fold level (state stored, increases/decreases depth)
--   - `zf`  → focus fold at cursor, rest respects current cycle level
--   - `zM`  → close all, but keep previous level (restorable)
--   - `zR`  → open all temporarily, level state is not reset
-- =============================================================================

---@class r.utils.fold
local M = {}

-- ├─────────────────────────────────┤ State ├──────────────────────────────┤

--- Currently active level (used as base fold depth)
--- nil = never set yet, will be inferred from current vim.wo.foldlevel
M._current_level = nil

--- Level before zM is called (for restore)
M._level_before_zm = nil

--- Cycle order: 1 → 2 → 3 → 99 (all open) → 0 (all closed) → back to 1
M._cycle_sequence = { 1, 2, 3, 99, 0 }

-- ├────────────────────────────────┤ Helpers ├─────────────────────────────┤

--- Infer current level from vim if state does not exist
local function get_current_level()
  if M._current_level == nil then
    M._current_level = 0 -- vim.wo.foldlevel
  end
  return M._current_level
end

--- Set foldlevel + update internal state
local function set_level(level)
  M._current_level = level
  vim.wo.foldlevel = level
end

--- Find index of a value in a table
local function index_of(tbl, val)
  for i, v in ipairs(tbl) do
    if v == val then
      return i
    end
  end
  return nil
end

-- ├─────────────────────────┤ Core: cycle fold level ├─────────────────────────┤

--- zb → cycle to next level in sequence
function M.cycle_fold_level()
  local current = get_current_level()
  local seq = M._cycle_sequence
  local idx = index_of(seq, current)

  local next_level
  if idx == nil or idx >= #seq then
    -- If outside sequence, start from beginning
    next_level = seq[1]
  else
    next_level = seq[idx + 1]
  end

  set_level(next_level)
  vim.schedule(function()
    vim.cmd "normal! zz"
  end)

  -- Short feedback in cmdline
  local label = next_level == 99 and "ALL OPEN" or next_level == 0 and "ALL CLOSED" or ("LEVEL " .. next_level)
  RUtils.echo("fold", "Fold: " .. label)
end

-- ├─────────────────────┤ Core: focus current fold (zf) ├──────────────────┤

---@param cmd string
local function wrap_fold_cmd(cmd)
  local _, err = pcall(function()
    vim.cmd(cmd)
  end)
  if err and (string.match(err, "E490") or string.match(err, "No fold found")) then
    ---@diagnostic disable-next-line: undefined-field
    RUtils.warn "No fold found"
  end
end

--- zf → open fold at cursor, rest closed according to current level
--- If cursor is not inside a closed fold, just re-apply level
function M.focus_current()
  local current = get_current_level()

  -- Close everything first according to current level
  if current == 99 then
    vim.cmd "normal! zR"
  elseif current == 0 then
    vim.cmd "normal! zM"
  else
    vim.wo.foldlevel = current
  end

  -- Open fold at cursor (zv = open just enough to see cursor line)
  wrap_fold_cmd "normal! zvzz"

  -- If cursor is too close to bottom of window, scroll for comfort
  local row = vim.fn.winline()
  local height = vim.api.nvim_win_get_height(0)
  if row > height * 0.75 then
    vim.cmd "normal! zb"
  end
end

-- ├───────────────────┤ Core: zM override (respect state) ├────────────────┤

--- zM → close all BUT save current level so it can be restored
function M.close_all()
  M._level_before_zm = get_current_level()
  set_level(0)
  vim.cmd "normal! zM"
  -- RUtils.echo("fold", "Fold: ALL CLOSED (level saved)")
end

--- zR → open all TEMPORARILY, level state is not reset
--- Use zb/cycle to return to previous level
function M.open_all()
  -- Open everything without changing _current_level
  -- so next cycle still continues from the same position
  vim.cmd "normal! zR"
  -- RUtils.echo("fold", "Fold: ALL OPEN (level state preserved)")
end

--- (Optional) Restore level before zM
function M.restore_level()
  if M._level_before_zm ~= nil then
    set_level(M._level_before_zm)
    RUtils.echo("fold", "Fold: RESTORED level " .. M._level_before_zm)
    M._level_before_zm = nil
  else
    RUtils.echo("fold", "Fold: no saved level")
  end
end

return M
