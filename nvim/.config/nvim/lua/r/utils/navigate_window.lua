---@class r.utils.navigate_window
local M = {}

-- Taken from https://github.com/mrjones2014/smart-splits.nvim/blob/c088d64c6e0e3221d24ef1f9337b5fe15557ddcc/lua/smart-splits/api.lua#L4

local size = 3.5 -- to resize
local WinPosition = {
  start = 0,
  middle = 1,
  last = 2,
}

local Direction = {
  left = "left",
  right = "right",
  up = "up",
  down = "down",
}

--   AtEdgeBehavior = {
--     ---@type SmartSplitsAtEdgeBehavior
--     split = "split",
--     ---@type SmartSplitsAtEdgeBehavior
--     wrap = "wrap",
--     ---@type SmartSplitsAtEdgeBehavior
--     stop = "stop",
--   },
--   FloatWinBehavior = {
--     ---@type SmartSplitsFloatWinBehavior
--     previous = "previous",
--     ---@type SmartSplitsFloatWinBehavior
--     mux = "mux",
--   },
--   Multiplexer = {
--     ---@type SmartSplitsMultiplexerType
--     tmux = "tmux",
--     ---@type SmartSplitsMultiplexerType
--     wezterm = "wezterm",
--     ---@type SmartSplitsMultiplexerType
--     kitty = "kitty",
--     ---@type SmartSplitsMultiplexerType
--     zellij = "zellij",
--   },
-- }

-- local DirectionKeys = {
--   left = "h",
--   right = "l",
--   up = "k",
--   down = "j",
-- }
--
-- ---@enum DirectionKeysReverse
-- local DirectionKeysReverse = {
--   left = "l",
--   right = "h",
--   up = "j",
--   down = "k",
-- }
--
-- ---@enum WincmdResizeDirection
-- local WincmdResizeDirection = {
--   bigger = "+",
--   smaller = "-",
-- }
--
-- local is_resizing = false

---@return boolean
local function at_top_edge()
  return vim.fn.winnr() == vim.fn.winnr "k"
end

---@return boolean
local function at_bottom_edge()
  return vim.fn.winnr() == vim.fn.winnr "j"
end

---@return boolean
local function at_left_edge()
  return vim.fn.winnr() == vim.fn.winnr "h"
end

---@return boolean
local function at_right_edge()
  return vim.fn.winnr() == vim.fn.winnr "l"
end

function M.win_position(direction)
  if direction == Direction.left or direction == Direction.right then
    if at_left_edge() then
      return WinPosition.start
    end

    if at_right_edge() then
      return WinPosition.last
    end

    return WinPosition.middle
  end

  if at_top_edge() then
    return WinPosition.start
  end

  if at_bottom_edge() then
    return WinPosition.last
  end

  return WinPosition.middle
end

local function get_direction(minus_or_plus, curwinnr, win_position, posisi)
  local winid = vim.api.nvim_get_current_win()
  local ft_exclude = { "aerial", "Outline", "neo-tree" }

  if not posisi then
    return minus_or_plus
  end

  local exclude_win = RUtils.cmd.windows_is_opened(ft_exclude)
  local windows = vim.api.nvim_list_wins()
  if curwinnr > 1 then
    for _, win in ipairs(windows) do
      local config = vim.api.nvim_win_get_config(win)
      if win == winid then
        if config.split == "left" or config.split == "right" then
          if (config.split == "left" and posisi == "right") or (config.split == "right" and posisi == "left") then
            minus_or_plus = (win_position > 0) and "+" or "-"
            if exclude_win.found and not (vim.tbl_contains(ft_exclude, vim.bo[0].filetype)) then
              minus_or_plus = "-"
            end
          else
            minus_or_plus = (win_position > 0) and "-" or "+"
            if exclude_win.found and not (vim.tbl_contains(ft_exclude, vim.bo[0].filetype)) then
              minus_or_plus = "+"
            end
          end
        end
      end
    end
  end
  return minus_or_plus
end

function M.resize_plus_or_mines(position)
  local win_position = M.win_position(position)
  local curwinnr = vim.api.nvim_win_get_number(0)

  local minus_or_plus
  if position == "up" or position == "left" then
    minus_or_plus = (win_position > 0) and "+" or "-"
  elseif position == "down" or position == "right" then
    minus_or_plus = (win_position > 0) and "-" or "+"
  end
  if curwinnr > 1 then
    minus_or_plus = get_direction(minus_or_plus, curwinnr, win_position, position)
  end

  return minus_or_plus .. size
end

function M.check_split_or_vsplit(position)
  position = position or "none"
  local win_position = M.win_position(position)
  local winid = vim.api.nvim_get_current_win()

  local windows = vim.api.nvim_list_wins()
  if #windows > 1 then
    for _, win in ipairs(windows) do
      if win == winid then
        local config = vim.api.nvim_win_get_config(win)

        -- RUtils.warn(#vim.api.nvim_list_wins() > 1)
        -- RUtils.warn(win_position)

        -- RUtils.warn(vim.inspect(config))
        if config.split == "below" then
          return true
        end
        if config.split == "above" then
          return true
        end

        if position ~= "none" then
          if win_position == 0 then
            RUtils.warn(config.split)
            RUtils.warn "win position start"
          end

          if win_position == 2 then
            RUtils.warn "win position last"
          end
          --   if (config.split == "left") and (win_position == 0) and (#vim.api.nvim_list_wins() > 2) then
          --   end
          --   if (config.split == "right") and (win_position == 0) and (#vim.api.nvim_list_wins() > 2) then
          --     return true
          --   end
        end
      end
    end
  end

  return false
end

return M
