local plenary_path = require "plenary.path"
local uv = vim.uv

---@class r.utils.file
local M = {}

--- Returns if the path exists on disk
---@param filename string
---@return string|boolean
function M.exists(filename)
  local stat = vim.uv.fs_stat(filename)
  return stat and stat.type or false
end

--- Returns if the path is a directory
---@param filename string
---@return boolean
function M.is_dir(filename)
  return M.exists(filename) == "directory"
end

function M.is_file(filename)
  return M.exists(filename) == "file"
end

function M.sanitize(path)
  if RUtils.is_win() then
    path = path:sub(1, 1):upper() .. path:sub(2)
    path = path:gsub("\\", "/")
  end
  return path
end

function M.is_fs_root(path)
  if RUtils.is_win() then
    return path:match "^%a:$"
  else
    return path == "/"
  end
end

function M.dirname(path)
  local strip_dir_pat = "/([^/]+)$"
  local strip_sep_pat = "/$"
  if not path or #path == 0 then
    return
  end
  local result = path:gsub(strip_sep_pat, ""):gsub(strip_dir_pat, "")
  if #result == 0 then
    if is_windows then
      return path:sub(1, 2):upper()
    else
      return "/"
    end
  end
  return result
end

function M.iterate_parents(path)
  local function it(_, v)
    if v and not M.is_fs_root(v) then
      v = M.dirname(v)
    else
      return
    end
    if v and uv.fs_realpath(v) then
      return v, path
    else
      return
    end
  end

  return it, path, path
end

function M.is_absolute(filename)
  if RUtils.is_win() then
    return filename:match "^%a:" or filename:match "^\\\\"
  else
    return filename:match "^/"
  end
end

function M.absolute_path(bufnr)
  return vim.fn.expand("#" .. bufnr .. ":p")
end

function M.create_dir(path)
  local p = plenary_path.new(path)
  if not p:exists() then
    p:mkdir()
  end
end

local separator = function()
  return "/"
end

local function remove_trailing(path)
  local p, _ = path:gsub(separator() .. "$", "")
  return p
end

function M.basename(path)
  path = remove_trailing(path)
  local i = path:match("^.*()" .. separator())
  if not i then
    return path
  end
  return path:sub(i + 1, #path)
end

-- Traverse the path calling cb along the way.
function M.traverse_parents(path, cb)
  path = uv.fs_realpath(path)
  local dir = path
  -- Just in case our algo is buggy, don't infinite loop.
  for _ = 1, 100 do
    dir = RUtils.file.dirname(dir)
    if not dir then
      return
    end
    -- If we can't ascend further, then stop looking.
    if cb(dir, path) then
      return dir, path
    end
    if RUtils.file.is_fs_root(dir) then
      break
    end
  end
end

function M.path_join(...)
  return table.concat(vim.tbl_flatten { ... }, "/")
end

function M.is_descendant(root, path)
  if not path then
    return false
  end

  local function cb(dir, _)
    return dir == root
  end

  local dir, _ = M.traverse_parents(path, cb)

  return dir == root
end

-- local path_separator = RUtils.is_win() and ";" or ":"

return M
