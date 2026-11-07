local add_on_event = require("vim-pack").add_on_event

local lazy = require("utils.plugin").require_lazy

local UtilKey = lazy "utils.map"
local Isfloat = lazy("utils.cmd").is_float

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

local function get_win_position(direction)
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

  local exclude_win = lazy("utils.window").windows_is_opened(ft_exclude)
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

---@param position "down"|"left"|"right"|"up"|"down"
local function resize_plus_or_mines(position)
  local win_position = get_win_position(position)
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

add_on_event("UIEnter", {
  { src = "smart-splits-nvim/backend-tmux", setup = false },
  { src = "adriankarlen/smart-splits-backend-herdr", setup = false },
  {
    src = "mrjones2014/smart-splits.nvim",
    opts = function()
      return {
        ignored_filetypes = { "nofile", "quickfix", "prompt", "Trouble" },
        ignored_buftypes = { "NvimTree" },
        swap = { move_cursor = true },
        move = { same_row = false },
        resize = { amount = 4 },
        kitty_password = nil,
        mux = { backend = "smart-splits-backend-" .. (vim.env.HERDR_ENV and "herdr" or "tmux") },
      }
    end,
    on_setup = function()
      local function smart_split()
        return lazy "smart-splits"
      end

      local cmds = {
        --stylua: ignore
        { "<a-h>", function() smart_split().move_cursor_left() end, "left" },
        --stylua: ignore
        { "<a-j>", function() smart_split().move_cursor_down() end, "down", },
        --stylua: ignore
        { "<a-k>", function() smart_split().move_cursor_up() end, "up" },
        --stylua: ignore
        { "<a-l>", function() smart_split().move_cursor_right() end, "right", },

        {
          "<a-H>",
          function()
            if vim.w.is_overlook_popup or Isfloat() then
              vim.cmd("vertical resize " .. resize_plus_or_mines "left")
              return
            end
            smart_split().resize_left()
          end,
          "resize win left",
        },
        {
          "<a-J>",
          function()
            if vim.w.is_overlook_popup or Isfloat() then
              vim.cmd("resize " .. resize_plus_or_mines "down")
              return
            end
            smart_split().resize_down()
          end,
          "resize win down",
        },
        {
          "<a-K>",
          function()
            if vim.w.is_overlook_popup or Isfloat() then
              vim.cmd("resize " .. resize_plus_or_mines "up")
              return
            end
            smart_split().resize_up()
          end,
          "resize win up",
        },
        {
          "<a-L>",
          function()
            if vim.w.is_overlook_popup or Isfloat() then
              vim.cmd("vertical resize " .. resize_plus_or_mines "right")
              return
            end
            smart_split().resize_right()
          end,
          "resize win right",
        },
      }

      for _, cmd in ipairs(cmds) do
        UtilKey.nnoremap(cmd[1], function()
          cmd[2]()
        end, { desc = ("Window: %s [smart-split]"):format(cmd[3]) })
      end
    end,
  },
})
