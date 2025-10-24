local wezterm = require "wezterm"

local M = {}

function M.get_foreground_process_name(pane, name)
  local process_name_pane = pane:get_foreground_process_name()
  if process_name_pane then
    local get_process_name = string.match(process_name_pane, name)
    if get_process_name then
      return true
    end
  end

  return false
end

function M.cmd_call(params)
  local handle = io.popen(params)
  if handle == nil then
    return
  end
  local result = handle:read "*a"
  handle:close()
  return result:gsub("\n", "")
end
function M.get_random_entry(tbl)
  if tbl ~= "table" then
    return tbl
  end

  local keys = {}
  for key, _ in ipairs(tbl) do
    table.insert(keys, key)
  end
  local randomKey = keys[math.random(1, #keys)]
  return tbl[randomKey]
end

function M.is_file_exists(name)
  local f = io.open(name, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end
function M.is_os_windows()
  return string.find(wezterm.target_triple, "windows")
end

function M.tint(color, percent)
  assert(color and percent, "cannot alter a color without specifying a color and percentage")
  local r = tonumber(color:sub(2, 3), 16)
  local g = tonumber(color:sub(4, 5), 16)
  local b = tonumber(color:sub(6), 16)
  if not r or not g or not b then
    return "NONE"
  end
  local blend = function(component)
    component = math.floor(component * (1 + percent))
    return math.min(math.max(component, 0), 255)
  end
  return string.format("#%02x%02x%02x", blend(r), blend(g), blend(b))
end

---Merges two tables
---@param t1 table
---@param ... table[] one or more tables to merge
---@return table t1 modified t1 table
M.tbl_merge = function(t1, ...)
  local tables = { ... }

  for _, t2 in ipairs(tables) do
    for k, v in pairs(t2) do
      if type(v) == "table" then
        if type(t1[k] or false) == "table" then
          M.tbl_merge(t1[k] or {}, t2[k] or {})
        else
          t1[k] = v
        end
      else
        t1[k] = v
      end
    end
  end

  return t1
end

-- https://stackoverflow.com/questions/52922469/remove-specific-entry-from-lua-table
M.removebyKey = function(tab, val)
  for i, v in ipairs(tab) do
    if v.pane_id == val then
      tab[i] = nil
    end
  end
end

local separator = function()
  return "/"
end

local function remove_trailing(path)
  local p, _ = path:gsub(separator() .. "$", "")
  return p
end

function M.get_current_directory()
  local current_path
  if M.is_os_windows() then
    current_path = os.getenv "PWD"
  else
    current_path = io.popen("cd"):read()
  end
  return M.basename(current_path)
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
