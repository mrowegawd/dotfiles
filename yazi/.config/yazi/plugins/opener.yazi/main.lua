---@diagnostic disable-next-line: undefined-global
local WIN = ya.target_family() == "windows"

---@diagnostic disable-next-line: undefined-global
local state = ya.sync(function()
  ---@diagnostic disable-next-line: undefined-global
  return cx.active.current.cwd
end)

local function get_rectangle(scale, mode)
  scale = scale or 60
  mode = mode or "center"

  -- ambil resolusi aktif dari xrandr
  local handle = io.popen "xrandr | awk '/\\*/ {print $1}' | head -n1"
  if not handle then
    return nil
  end

  local res = handle:read "*a"
  handle:close()

  local w, h = res:match "(%d+)x(%d+)"
  w = tonumber(w)
  h = tonumber(h)

  if not w or not h then
    return nil
  end

  local win_w = math.floor(w * scale / 100)
  local win_h = math.floor(h * scale / 100)

  local x, y = 0, 0

  if mode == "center" then
    x = math.floor((w - win_w) / 2)
    y = math.floor((h - win_h) / 2)
  elseif mode == "br" or mode == "bottom-right" then
    x = w - win_w - 20
    y = h - win_h - 40
  elseif mode == "tr" or mode == "top-right" then
    x = w - win_w - 20
    y = 40
  else
    x = math.floor((w - win_w) / 2)
    y = math.floor((h - win_h) / 2)
  end

  return string.format("%dx%d+%d+%d", win_w, win_h, x, y)
end

local function fail(s, ...)
  ---@diagnostic disable-next-line: undefined-global
  ya.notify { title = "Opener", content = string.format(s, ...), timeout = 5, level = "error" }
end

local function is_in_tmux()
  if os.getenv "TMUX" then
    return true
  end
  return false
end

local function get_actions(action)
  local actions = {}
  if action == "lazygit" then
    if not WIN then
      local user = os.getenv "HOME"
      actions = {
        "lazygit",
        "--use-config-file",
        user .. "/.config/lazygit/config.yml," .. user .. "/.config/lazygit/theme/fla.yml",
      }
    else
      actions = { "lazygit" }
    end
  end

  if action == "lazydocker" then
    actions = { "lazydocker" }
  end
  return actions
end

local function open_with_tmux(action, cwd)
  local actions = get_actions(action)
  local args = {
    "popup",
    "-S",
    "bg=#1f1f1f,fg=#cccccc",
    "-s",
    "bg=#1f1f1f",
    "-b",
    "rounded",
    "-d",
    cwd,
    "-h",
    "80%",
    "-w",
    "90%",
    "-E",
  }

  for _, v in pairs(actions) do
    table.insert(args, v)
  end

  local child, err =
    ---@diagnostic disable-next-line: undefined-global
    Command("tmux"):arg(args):stdin(Command.INHERIT):stdout(Command.PIPED):stderr(Command.INHERIT):spawn()

  if not child then
    return fail(tostring(action) .. " not  open?", err)
  end

  child, err = child:wait_with_output()
  if not child then
    return fail("No output! %s", err)
  elseif not child.status.success and child.status.code ~= 130 then
    return fail("something went wrong %s", child.status.code)
  end
end

local function open_with_wezterm(action, cwd)
  local actions = get_actions(action)
  local args = {
    "start",
    "--always-new-process",
    "--cwd",
    cwd,
    "--class",
    "if-select",
  }

  for _, v in pairs(actions) do
    table.insert(args, v)
  end

  local child, err =
    ---@diagnostic disable-next-line: undefined-global
    Command("wezterm"):arg(args):stdin(Command.INHERIT):stdout(Command.PIPED):stderr(Command.INHERIT):spawn()

  if not child then
    return fail(tostring(action) .. " not  open?", err)
  end
  local output, errc = child:wait_with_output()
  if not output then
    return fail("No output! %s", errc)
  elseif not output.status.success and output.status.code ~= 130 then
    return fail("something went wrong %s", output.status.code)
  end
end

return {
  entry = function(_, job)
    local action = job.args[1]

    local cwd = tostring(state())

    -- TODO: check juga jika berada di windows
    -- dengan command ini: ya.target_family() == "windows"
    if action == "terminal" then
      local termopen = os.getenv "TERMINAL"

      local rect = get_rectangle(60, "br")

      if rect then
        os.execute("bspc rule -a \\* -o state=floating rectangle=" .. rect .. " && " .. termopen)
      end

      return
    end

    if is_in_tmux() then
      open_with_tmux(action, cwd)
    else
      open_with_wezterm(action, cwd)
    end
  end,
}
