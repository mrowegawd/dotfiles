---@class r.utils.fileexplorer
local M = {}

local home = os.getenv "HOME"
local bookmark_file = home .. "/.cache/yazi/bookmarks"
local index_file = home .. "/.cache/yazi/bookmark-index"

function M.ensure_files()
  os.execute("mkdir -p " .. home .. "/.cache/yazi")
  local f = io.open(bookmark_file, "a")
  if f then
    f:close()
  end
  local g = io.open(index_file, "a")
  if g then
    g:close()
  end
end

---@return table
function M.read_bookmarks()
  local list = {}
  local f = io.open(bookmark_file, "r")
  if not f then
    return list
  end
  for line in f:lines() do
    local trimmed = line:match "^%s*(.-)%s*$"
    if trimmed and trimmed ~= "" then
      table.insert(list, trimmed)
    end
  end
  f:close()
  return list
end

---@param path string
---@return string| nil
function M.normalize_path(path)
  if not path then
    RUtils.warn "Path required!"
    return nil
  end

  if home and path:sub(1, #home) == home then
    return "~" .. path:sub(#home + 1)
  end
  return path
end

---@param list table
function M.write_bookmarks(list)
  local f = io.open(bookmark_file, "w")
  if not f then
    return
  end
  for _, v in ipairs(list) do
    f:write(v .. "\n")
  end
  f:close()
end

---@return integer
function M.read_index()
  local f = io.open(index_file, "r")
  if not f then
    return 0
  end
  local n = tonumber(f:read "*l") or 0
  f:close()
  return n
end

---@param n integer
function M.write_index(n)
  local f = io.open(index_file, "w")
  if not f then
    return
  end
  f:write(tostring(n) .. "\n")
  f:close()
end

---@param path string
function M.jump_to(path)
  if path then
    vim.cmd("Neotree " .. path)
  end
end

return M
