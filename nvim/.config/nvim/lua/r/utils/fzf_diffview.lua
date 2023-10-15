local validate = vim.validate
local uv = vim.uv

local M = {}

local File = require "r.utils.file"

function M.split_string(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

function M.path_join(...)
  return table.concat(vim.tbl_flatten { ... }, "/")
end

local is_windows = uv.os_uname().version:match "Windows"

local function dirname(path)
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

local function is_fs_root(path)
  if is_windows then
    return path:match "^%a:$"
  else
    return path == "/"
  end
end

local function iterate_parents(path)
  local function it(_, v)
    if v and not is_fs_root(v) then
      v = dirname(v)
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

local function search_ancestors(startpath, func)
  validate { func = { func, "f" } }
  if func(startpath) then
    return startpath
  end
  local guard = 100
  for path in iterate_parents(startpath) do
    -- Prevent infinite recursion if our algorithm breaks
    guard = guard - 1
    if guard == 0 then
      return
    end

    if func(path) then
      return path
    end
  end
end

local function find_first_ancestor_dir_or_file(startpath, pattern)
  return search_ancestors(startpath, function(path)
    if File.is_file(M.path_join(path, pattern)) or File.is_dir(M.path_join(path, pattern)) then
      return path
    end
  end)
end

local escape_chars = function(x)
  x = x or ""
  return (
    x:gsub("%%", "%%%%")
      :gsub("^%^", "%%^")
      :gsub("%$$", "%%$")
      :gsub("%(", "%%(")
      :gsub("%)", "%%)")
      :gsub("%.", "%%.")
      :gsub("%[", "%%[")
      :gsub("%]", "%%]")
      :gsub("%*", "%%*")
      :gsub("%+", "%%+")
      :gsub("%-", "%%-")
      :gsub("%?", "%%?")
  )
end

function M.git_relative_path(bufnr)
  local abs_filename = File.absolute_path(bufnr)
  local git_dir = find_first_ancestor_dir_or_file(abs_filename, ".git")

  if git_dir and git_dir ~= "" then
    git_dir = escape_chars(git_dir .. "/")
    return string.gsub(abs_filename, git_dir, "")
  else
    -- try with current cwd (normally a git repo)
    git_dir = escape_chars(vim.fn.getcwd() .. "/")
    return string.gsub(abs_filename, git_dir, "")
  end
end

return M
