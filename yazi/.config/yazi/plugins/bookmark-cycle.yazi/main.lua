local function fail(s, ...)
  ya.notify { title = "Bookmark-Cycle", content = string.format(s, ...), timeout = 5, level = "error" }
end

local function notify(s, ...)
  ya.notify { title = "Bookmark-Cycle", content = string.format(s, ...), timeout = 2, level = "info" }
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

local function normalize_path(path)
  if home and path:sub(1, #home) == home then
    return "~" .. path:sub(#home + 1)
  end
  return path
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
    local normalize_path_v = normalize_path(v)
    local normalize_path_cwd = normalize_path(cwd)
    if normalize_path_v == normalize_path_cwd then
      notify("Already bookmarked:\n%s", normalize_path_cwd)
      return
    end
  end

  local normalize_cwd = normalize_path(cwd)
  table.insert(list, normalize_cwd)
  write_bookmarks(list)
  notify("Bookmark saved (%d total):\n%s", #list, normalize_cwd)
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
  local basename_target = normalize_path(target)
  notify("[%d/%d] %s", idx, #list, basename_target)
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

-- Buka fzf picker
-- <Enter>  = jump ke path
-- <ctrl-x> = hapus bookmark yang di-highlight (reload list)
-- <ctrl-s> = save cwd ke bookmark (reload list)
local function pick_bookmark()
  ensure_files()
  -- local shell_value = os.getenv("SHELL"):match ".*/(.*)"
  local shell_value = os.getenv "SHELL"
  local cwd = state()

  -- NOTE: Membuat bind fzf menggunakan escaping shell seperti ini teralu sulit:
  -- `local reload_cmd = string.format("awk 'NR>0{print NR\" \"$0}' %s", bookmark_file)`
  -- Untuk itu gunakan cara seperti `reload_script` dibawah untuk menghindari
  -- kesalahan ketika di input pada bind fzf (escaping hell)

  -- Buat temp script untuk delete (hindari escaping hell di fzf --bind)
  local reload_script = os.tmpname()
  local h = io.open(reload_script, "w")
  if h then
    h:write(string.format("#!/bin/sh\nawk 'NR>0{print NR\" \"$0}' %q\n", bookmark_file))
    h:close()
    os.execute("chmod +x " .. reload_script)
  end

  local delete_script = os.tmpname()
  local f = io.open(delete_script, "w")
  if f then
    f:write(string.format(
      [[#!/bin/sh
# $1 = selected line dari fzf format "N /path/to/dir"
path=$(echo "$1" | awk '{$1=""; print substr($0,2)}')
grep -vxF "$path" %q > %q.tmp && mv %q.tmp %q
awk 'NR>0{print NR" "$0}' %q
]],
      bookmark_file,
      bookmark_file,
      bookmark_file,
      bookmark_file,
      bookmark_file
    ))
    f:close()
    os.execute("chmod +x " .. delete_script)
  end

  -- Buat temp script untuk save cwd
  local save_script = os.tmpname()
  local g = io.open(save_script, "w")
  if g then
    g:write(string.format(
      [[#!/bin/sh
grep -qxF %q %q || echo %q >> %q
awk 'NR>0{print NR" "$0}' %q
]],
      cwd,
      bookmark_file,
      cwd,
      bookmark_file,
      bookmark_file
    ))
    g:close()
    os.execute("chmod +x " .. save_script)
  end

  local fzf_cmd = string.format(
    [[%s | fzf-tmux -xC -w 70%% -h 50%% \
      --prompt='Bookmarks> ' \
      --header='<enter> jump  <ctrl-s> save cwd  <ctrl-x> delete' \
      --bind='ctrl-x:execute-silent(%s {})+reload(%s)' \
      --bind='ctrl-s:execute-silent(%s)+reload(%s)']],
    reload_script,
    delete_script,
    reload_script,
    save_script,
    reload_script
  )

  local child, err = Command(shell_value)
    :arg({ "-c" })
    :arg(fzf_cmd)
    :stdin(Command.INHERIT)
    :stdout(Command.PIPED)
    :stderr(Command.INHERIT)
    :spawn()

  if not child then
    os.remove(delete_script)
    os.remove(save_script)
    os.remove(reload_script)
    return fail("Spawn fzf failed: %s", err)
  end

  local output, errc = child:wait_with_output()

  -- Cleanup temp scripts (selalu, apapun hasilnya)
  os.remove(delete_script)
  os.remove(save_script)
  os.remove(reload_script)

  if not output then
    return fail("No output: %s", errc)
  end
  if not output.status.success then
    return
  end -- ESC / cancel

  -- Output format: "[N] /path/to/dir"
  local selected = output.stdout:gsub("\n$", "")
  local path = selected:match "^%d+%s(.+)$"
  if not path or path == "" then
    return
  end

  -- Update index supaya cycle B lanjut dari sini
  local list = read_bookmarks()
  for i, v in ipairs(list) do
    if v == path then
      write_index(i)
      break
    end
  end

  jump_to(path)
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
    elseif action == "pick" then
      pick_bookmark()
    elseif action == "save" then
      save_bookmark()
    elseif action == "delete" then
      delete_bookmark()
    end
  end,
}
