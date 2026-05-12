local function fail(s, ...)
  ya.notify { title = "Bookmark", content = string.format(s, ...), timeout = 5, level = "error" }
end

local function notify(s, ...)
  ya.notify { title = "Bookmark", content = string.format(s, ...), timeout = 2, level = "info" }
end

local home = os.getenv "HOME"
local bookmark_file = home .. "/.cache/yazi/bookmarks"
local index_file = home .. "/.cache/yazi/bookmark-index"

-- ──────────────────────────────────────────────────────────────
-- Helpers
-- ──────────────────────────────────────────────────────────────

local function ensure_files()
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

local function read_bookmarks()
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

local function write_bookmarks(list)
  local f = io.open(bookmark_file, "w")
  if not f then
    return
  end
  for _, v in ipairs(list) do
    f:write(v .. "\n")
  end
  f:close()
end

local function read_index()
  local f = io.open(index_file, "r")
  if not f then
    return 0
  end
  local n = tonumber(f:read "*l") or 0
  f:close()
  return n
end

local function write_index(n)
  local f = io.open(index_file, "w")
  if not f then
    return
  end
  f:write(tostring(n) .. "\n")
  f:close()
end

local function jump_to(path)
  ya.emit("cd", { path })
end

local state = ya.sync(function()
  return tostring(cx.active.current.cwd)
end)

-- ──────────────────────────────────────────────────────────────
-- Commands
-- ──────────────────────────────────────────────────────────────

-- Save cwd ke bookmark list (tanpa duplikat)
local function save_bookmark()
  ensure_files()
  local cwd = state()
  local list = read_bookmarks()

  for _, v in ipairs(list) do
    if v == cwd then
      notify("Already bookmarked:\n%s", cwd)
      return
    end
  end

  table.insert(list, cwd)
  write_bookmarks(list)
  notify("Bookmark saved (%d total):\n%s", #list, cwd)
end

-- Cycle ke bookmark berikutnya
local function cycle_bookmark()
  ensure_files()
  local list = read_bookmarks()

  if #list == 0 then
    fail "No bookmarks yet. Use save to add one."
    return
  end

  local idx = read_index()
  idx = (idx % #list) + 1 -- next, wrap around
  write_index(idx)

  local target = list[idx]
  notify("[%d/%d] %s", idx, #list, target)
  jump_to(target)
end

-- Cycle ke bookmark sebelumnya
local function cycle_bookmark_prev()
  ensure_files()
  local list = read_bookmarks()

  if #list == 0 then
    fail "No bookmarks yet. Use save to add one."
    return
  end

  local idx = read_index()
  idx = idx - 1
  if idx < 1 then
    idx = #list
  end
  write_index(idx)

  local target = list[idx]
  notify("[%d/%d] %s", idx, #list, target)
  jump_to(target)
end

-- Buka fzf picker, pilih bookmark lalu jump
local function pick_bookmark()
  ensure_files()
  local list = read_bookmarks()

  if #list == 0 then
    fail "No bookmarks yet. Use save to add one."
    return
  end

  local shell_value = os.getenv("SHELL"):match ".*/(.*)"

  -- Tulis list ke temp file supaya bisa di-pipe ke fzf
  local tmp = "/tmp/yazi-bookmarks-list"
  local tf = io.open(tmp, "w")
  if not tf then
    return fail "Cannot write tmp file"
  end
  for i, v in ipairs(list) do
    tf:write(string.format("[%d] %s\n", i, v))
  end
  tf:close()

  local fzf_cmd = string.format("cat %s | fzf-tmux -xC -w 70%% -h 50%% --prompt='Bookmark> ' --ansi", tmp)

  local child, err = Command(shell_value)
    :arg({ "-c", fzf_cmd })
    :stdin(Command.INHERIT)
    :stdout(Command.PIPED)
    :stderr(Command.INHERIT)
    :spawn()

  if not child then
    return fail("Spawn fzf failed: %s", err)
  end

  local output, errc = child:wait_with_output()
  if not output then
    return fail("No output: %s", errc)
  end
  if not output.status.success then
    return -- user cancel (ESC)
  end

  local selected = output.stdout:gsub("\n$", "")
  -- Parse index dari "[N] /path"
  local n = tonumber(selected:match "^%[(%d+)%]")
  if not n then
    return
  end

  local target = list[n]
  if not target then
    return
  end

  write_index(n)
  jump_to(target)
end

-- Hapus satu bookmark via fzf
local function delete_bookmark()
  ensure_files()
  local list = read_bookmarks()

  if #list == 0 then
    fail "No bookmarks to delete."
    return
  end

  local shell_value = os.getenv("SHELL"):match ".*/(.*)"

  local tmp = "/tmp/yazi-bookmarks-del"
  local tf = io.open(tmp, "w")
  if not tf then
    return fail "Cannot write tmp file"
  end
  for i, v in ipairs(list) do
    tf:write(string.format("[%d] %s\n", i, v))
  end
  tf:close()

  local fzf_cmd = string.format("cat %s | fzf-tmux -xC -w 70%% -h 50%% --prompt='Delete bookmark> ' --ansi", tmp)

  local child, err = Command(shell_value)
    :arg({ "-c", fzf_cmd })
    :stdin(Command.INHERIT)
    :stdout(Command.PIPED)
    :stderr(Command.INHERIT)
    :spawn()

  if not child then
    return fail("Spawn fzf failed: %s", err)
  end

  local output, errc = child:wait_with_output()
  if not output then
    return fail("No output: %s", errc)
  end
  if not output.status.success then
    return
  end

  local selected = output.stdout:gsub("\n$", "")
  local n = tonumber(selected:match "^%[(%d+)%]")
  if not n then
    return
  end

  local removed = table.remove(list, n)

  -- Reset index kalau sekarang out of range
  local idx = read_index()
  if idx > #list then
    write_index(#list)
  end

  write_bookmarks(list)
  notify("Deleted: %s", removed)
end

-- ──────────────────────────────────────────────────────────────
-- Entry
-- ──────────────────────────────────────────────────────────────

return {
  entry = function(_, job)
    local action = job.args[1]
    if not action then
      return
    end

    if action == "cycle" then
      cycle_bookmark()
    elseif action == "cycle-prev" then
      cycle_bookmark_prev()
    elseif action == "pick" then
      pick_bookmark()
    elseif action == "save" then
      save_bookmark()
    elseif action == "delete" then
      delete_bookmark()
    end
  end,
}
