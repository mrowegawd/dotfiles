local add_on_event = require("vim-pack").add_on_event

local UtilKey = require "utils.map"

--- Check whether the active window has vertically stacked neighbors
--- (result of :split, not :vsplit), so height resizing doesn't become a no-op.
---@param target_winid integer?
---@return boolean
local function win_has_vertical_neighbor(target_winid)
  target_winid = target_winid or vim.api.nvim_get_current_win()

  local function contains(node, winid)
    if node[1] == "leaf" then
      return node[2] == winid
    end
    for _, child in ipairs(node[2]) do
      if contains(child, winid) then
        return true
      end
    end
    return false
  end

  local function search(node, in_col_with_siblings)
    if node[1] == "leaf" then
      if node[2] == target_winid then
        return in_col_with_siblings
      end
      return nil
    end

    local is_col_multi = (node[1] == "col") and (#node[2] > 1)
    for _, child in ipairs(node[2]) do
      if contains(child, target_winid) then
        return search(child, in_col_with_siblings or is_col_multi)
      end
    end
    return nil
  end

  local layout = vim.fn.winlayout()
  return search(layout, false) or false
end

add_on_event("UIEnter", {
  {
    src = "mrjones2014/smart-splits.nvim",
    opts = {
      ignored_filetypes = { "nofile", "quickfix", "prompt" },
      ignored_buftypes = { "NvimTree" },
      default_amount = 4,
      move_cursor_same_row = false,
      cursor_follows_swapped_bufs = false,
      disable_multiplexer_nav_when_zoomed = true,
      kitty_password = nil,
    },
    on_setup = function()
      UtilKey.nnoremap("<a-h>", require("smart-splits").move_cursor_left)
      UtilKey.nnoremap("<a-j>", require("smart-splits").move_cursor_down)
      UtilKey.nnoremap("<a-k>", require("smart-splits").move_cursor_up)
      UtilKey.nnoremap("<a-l>", require("smart-splits").move_cursor_right)

      UtilKey.nnoremap("<a-H>", function()
        vim.cmd "vertical resize +4"
      end)
      UtilKey.nnoremap("<a-J>", function()
        if not win_has_vertical_neighbor() then
          return
        end
        vim.cmd "resize +2"
      end)
      UtilKey.nnoremap("<a-K>", function()
        if not win_has_vertical_neighbor() then
          return
        end
        vim.cmd "resize -2"
      end)
      UtilKey.nnoremap("<a-L>", function()
        vim.cmd "vertical resize -4"
      end)
    end,
  },
})
