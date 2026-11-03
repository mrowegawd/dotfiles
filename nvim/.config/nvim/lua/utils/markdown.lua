local M = {}

local lazy = require("utils.plugin").require_lazy

local links = {
  style = "markdown",
  name_is_source = false,
  transform_implicit = false,
  transform_explicit = function(text)
    text = text:gsub("[ /]", "-")
    text = text:lower()
    text = os.date "%Y-%m-%d_" .. text
    return text
  end,
}

local transform_path = function(text)
  if type(links.transform_explicit) ~= "function" or not links.transform_explicit then
    return text
  else
    return (links.transform_explicit(text))
  end
end

local format_link = function(text, source, part)
  local replacement, path_text
  -- If the text starts with a hash, format the link as an anchor link
  if string.sub(text, 0, 1) == "#" and not source then
    path_text = string.gsub(text, "[^%a%s%d%-_]", "")
    text = string.gsub(text, "^#* *", "")
    path_text = string.gsub(path_text, "^ ", "")
    path_text = string.gsub(path_text, " ", "-")
    path_text = string.gsub(path_text, "%-%-", "-")
    path_text = "#" .. string.lower(path_text)
  elseif not source then
    path_text = transform_path(text)
    -- If no path_text, end here
    if not path_text then
      return
    end
    if not links.implicit_extension then
      path_text = path_text .. ".md"
    end
  else
    path_text = source
  end
  -- Format the replacement depending on the user's link style preference
  if links.style == "wiki" then
    replacement = (links.name_is_source and { "[[" .. text .. "]]" }) or { "[[" .. path_text .. "|" .. text .. "]]" }
  else
    replacement = { "[" .. text .. "]" .. "(" .. path_text .. ")" }
  end
  -- Return the requested part
  if part == nil then
    return replacement
  elseif part == 1 then
    return text
  elseif part == 2 then
    return path_text
  end
end

---@param cursor_row integer
---@param reverse? boolean
---@return boolean
local cursor_in_code_block = function(cursor_row, reverse)
  reverse = reverse or false
  local lines = reverse and vim.api.nvim_buf_get_lines(0, cursor_row - 1, -1, false)
    or vim.api.nvim_buf_get_lines(0, 0, cursor_row, false)
  local fences = 0
  for _, line_text in ipairs(lines) do
    local _, count = string.gsub(line_text, "^```", "```")
    fences = fences + count
  end
  if fences % 2 == 0 then
    return false
  end
  return true
end

function M.go_to_heading(anchor_text, reverse)
  local silent = true
  local wrap = false

  -- Taken from and credit: https://github.com/jakewvincent/mkdnflow.nvim/blob/0fa1e682e35d46cd1a0102cedd05b0283e41d18d/lua/mkdnflow/cursor.lua#L138

  -- Record which line we're on; chances are the link goes to something later,
  -- so we'll start looking from here onwards and then circle back to the beginning
  local position = vim.api.nvim_win_get_cursor(0)
  local starting_row, continue = position[1], true
  local in_fenced_code_block = cursor_in_code_block(starting_row, reverse)
  local row = (reverse and starting_row - 1) or starting_row + 1
  while continue do
    local line = (reverse and vim.api.nvim_buf_get_lines(0, row - 1, row, false))
      or vim.api.nvim_buf_get_lines(0, row - 1, row, false)
    -- If the line has contents, do the thing
    if line[1] then
      -- Are we in a code block?
      if string.find(line[1], "^```") then
        -- Flip the truth value
        in_fenced_code_block = not in_fenced_code_block
      end
      -- Does the line start with a hash?
      local has_heading = string.find(line[1], "^#")
      if has_heading and not in_fenced_code_block then
        if anchor_text == nil then
          -- Send the cursor to the heading
          vim.api.nvim_win_set_cursor(0, { row, 0 })
          continue = false
        else
          -- Format current heading to see if it matches our search term
          local heading_as_anchor = format_link(line[1], nil, 2)
          if anchor_text == heading_as_anchor then
            -- Set a mark
            vim.api.nvim_buf_set_mark(0, "`", position[1], position[2], {})
            -- Send the cursor to the row w/ the matching heading
            vim.api.nvim_win_set_cursor(0, { row, 0 })
            continue = false
          end
        end
      end
      row = (reverse and row - 1) or row + 1
      if row == starting_row + 1 then
        continue = false
        if anchor_text == nil then
          local message = "⬇️  Couldn't find a heading to go to!"
          if not silent then
            vim.api.nvim_echo({ { message, "WarningMsg" } }, true, {})
          end
        else
          local message = "⬇️  Couldn't find a heading matching " .. anchor_text .. "!"
          if not silent then
            vim.api.nvim_echo({ { message, "WarningMsg" } }, true, {})
          end
        end
      end
    else
      -- If the line does not have contents, start searching from the beginning
      if anchor_text ~= nil or wrap == true then
        row = (reverse and vim.api.nvim_buf_line_count(0)) or 1
        in_fenced_code_block = false
      else
        continue = false
        local place = (reverse and "beginning") or "end"
        local preposition = (reverse and "after") or "before"
        local message = "⬇️  There are no more headings " .. preposition .. " the " .. place .. " of the document!"
        if not silent then
          vim.api.nvim_echo({ { message, "WarningMsg" } }, true, {})
        end
      end
    end
  end

  -- open fold
  lazy("utils.cmd").force_foldopen()
end

return M
