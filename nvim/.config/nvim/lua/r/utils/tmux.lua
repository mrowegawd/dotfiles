---@class r.utils.tmux
local M = {}

local PATH_PANE_COLLECT_JSON = "/tmp/tmux-main-layout-workspaces.json"
M.is_tmux = os.getenv "TMUX"
M.is_terminal = os.getenv "TERMINAL"

function M.is_pane_alive(pane_id)
  if not pane_id or pane_id == "" then
    return false
  end
  local result = vim.system({ "tmux", "list-panes", "-a", "-F", "#{pane_id}" }, { text = true }):wait()
  if result.code ~= 0 then
    return false
  end
  for line in result.stdout:gmatch "[^\n]+" do
    if vim.trim(line) == pane_id then
      return true
    end
  end
  return false
end

function M.tmux_cmd(io_cmd)
  local handle = io.popen(io_cmd)
  if not handle then
    RUtils.warn("Something went wrong when running `" .. io_cmd .. "`")
    return nil
  end
  local out = handle:read "*a"
  handle:close()
  if not out or out == "" then
    return nil
  end
  return out:gsub("%s+$", "")
end

function M.get_json_field(session_name, window_id, field)
  if not RUtils.file.exists(PATH_PANE_COLLECT_JSON) then
    RUtils.warn("JSON not found: " .. PATH_PANE_COLLECT_JSON)
    return nil
  end

  local result = M.tmux_cmd(
    string.format(
      "jq -r --arg s %q --arg w %q --arg f %q '.[$s][$w][$f] // empty' %s",
      session_name,
      window_id,
      field,
      PATH_PANE_COLLECT_JSON
    )
  )

  if not result or result == "" or result == "null" then
    return nil
  end
  return result
end

function M.get_pane_process(pane_id)
  local result = vim
    .system({ "tmux", "display-message", "-p", "-t", pane_id, "#{pane_current_command}" }, { text = true })
    :wait()
  if result.code ~= 0 then
    return ""
  end
  return vim.trim(result.stdout)
end

-- Tunggu sampai proses di pane BUKAN target_proc lagi (mode close)
-- atau SUDAH menjadi target_proc (mode jump)
function M.wait_for_process(pane_id, target_proc, is_close)
  for _ = 1, 20 do
    local proc = M.get_pane_process(pane_id)
    if is_close then
      if proc ~= target_proc then
        return
      end
    else
      if proc == target_proc then
        return
      end
    end
    os.execute "sleep 0.15"
  end
end

return M
