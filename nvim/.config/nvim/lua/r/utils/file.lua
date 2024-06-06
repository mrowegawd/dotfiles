local plenary_path = require "plenary.path"

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

return M
