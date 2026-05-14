local function fail(s, ...)
  ya.notify { title = "Smart-Enter", content = string.format(s, ...), timeout = 5, level = "error" }
end

-- ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐
-- ╎ UTILS                                                    ╎
-- └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘

local EXT_MAP = {
  mp3 = "mp3",
  wav = "mp3",
  mp4 = "mp4",
  mkv = "mp4",
  avi = "mp4",
  gif = "mp4",
  pdf = "pdf",
  jpg = "jpg",
  png = "jpg",
  jpeg = "jpg",
  webp = "jpg",
  xlsx = "excel",
}

local function check_file_extension(filename)
  local ext = filename:match "%.([^%.]+)$"
  return (ext and EXT_MAP[ext:lower()]) or "open"
end

local hovered_item_is_dir = ya.sync(function(_)
  local h = cx.active.current.hovered
  return h and h.cha.is_dir
end)

local get_hovered_item_path = ya.sync(function(_)
  local h = cx.active.current.hovered
  return h and tostring(cx.active.current.hovered.url) or nil
end)

local function is_in_tmux()
  return os.getenv "TMUX" ~= nil
end

local function is_in_wezterm()
  return os.getenv "TERMINAL" == "wezterm"
end

local function get_cmd_output(cmd, args)
  local child, err = Command(cmd):arg(args):stdout(Command.PIPED):stderr(Command.INHERIT):output()
  if err or not child then
    fail("Command failed: %s %s — %s", cmd, table.concat(args, " "), tostring(err))
    return nil
  end
  return (child.stdout or ""):gsub("[\r\n]+$", "")
end

local function run(cmd)
  os.execute(cmd)
end

-- ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐
-- ╎ OPEN WITH TMUX                                           ╎
-- └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘

local function open_with_tmux(action, fpath, fpath_ext)
  if fpath_ext == "pdf" then
    run('nohup zathura "' .. fpath .. '" >/dev/null 2>&1 &')
    return
  end

  local yazi_pane_id = os.getenv "TMUX_PANE"

  -- Pindah ke pane kanan (nvim)
  if yazi_pane_id then
    run("tmux select-pane -t " .. yazi_pane_id .. " -R")
  else
    run "tmux select-pane -R"
  end

  local pane_cmd = get_cmd_output("tmux", { "display-message", "-p", "#{pane_current_command}" })
  if not pane_cmd then
    return
  end

  local open_mode
  if pane_cmd == "nvim" then
    if action == "vsplit" then
      open_mode = ":vsplit "
    elseif action == "split" then
      open_mode = ":sp "
    elseif action == "tab" then
      open_mode = ":tabe "
    else
      open_mode = ":e "
    end
    run([[tmux send-keys "]] .. open_mode .. fpath .. [[" Enter]])
  else
    run([[tmux send-keys "nvim ]] .. fpath .. [[" Enter]])
  end

  -- Back to yazi pane
  -- if yazi_pane_id then
  --   run("tmux select-pane -t " .. yazi_pane_id)
  -- end
end

-- ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐
-- ╎ OPEN WITH WEZTERM                                        ╎
-- └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘

local function open_with_wezterm(action, fpath, fpath_ext)
  if fpath_ext == "pdf" then
    local pane_right = get_cmd_output("wezterm", { "cli", "get-pane-direction", "right" })
    if not pane_right then
      return
    end

    local prog = get_cmd_output("sh", {
      "-c",
      "wezterm cli list | awk -v pane_id=" .. pane_right .. " '$3==pane_id { print $6 }'",
    })
    if not prog then
      return
    end

    if prog == "nvim" or prog == "zsh" then
      get_cmd_output("wezterm", { "cli", "activate-pane-direction", "right" })
      local new_pane = get_cmd_output("wezterm", {
        "cli",
        "split-pane",
        "--horizontal",
        "--pane-id",
        pane_right,
      })
      if not new_pane then
        return
      end
      get_cmd_output("wezterm", {
        "cli",
        "send-text",
        "--no-paste",
        'fancy-cat "' .. fpath .. '"\r',
        "--pane-id",
        new_pane,
      })
    end
    return
  end

  local current_pane_id = get_cmd_output("wezterm", { "cli", "get-pane-direction", "left" })
  if not current_pane_id then
    return
  end

  local prog = get_cmd_output("sh", {
    "-c",
    "wezterm cli list | awk -v pane_id=" .. current_pane_id .. " '$3==pane_id { print $6 }'",
  })
  if not prog then
    return
  end

  if prog ~= "nvim" then
    fail("Target pane is not nvim (got: %s)", prog)
    return
  end

  local open_mode
  if action == "vsplit" then
    open_mode = ":vsplit "
  elseif action == "split" then
    open_mode = ":sp "
  elseif action == "tab" then
    open_mode = ":tabe "
  else
    open_mode = ":e "
  end

  run(
    [[echo "]] .. open_mode .. fpath .. [[\r" | wezterm cli send-text --pane-id ]] .. current_pane_id .. [[ --no-paste]]
  )

  -- Back to yazi pane
  -- run([[wezterm cli activate-pane-direction --pane-id ]] .. current_pane_id .. [[ left]])
end

-- ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐
-- ╎ ENTRY                                                    ╎
-- └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘

return {
  entry = function(_, job)
    local action = job.args[1]

    if hovered_item_is_dir() then
      ya.emit("enter", { hovered = true })
      return
    end

    local fpath = get_hovered_item_path()
    if not fpath then
      return
    end

    fpath = tostring(fpath)
    local fpath_ext = check_file_extension(fpath)

    -- Handle media/binary file types langsung, tidak perlu terminal
    if fpath_ext == "jpg" then
      if action == "open" then
        run("feh --bg-scale " .. fpath)
      else
        run('nohup sxiv "' .. fpath .. '" >/dev/null 2>&1 &')
      end
      return
    end

    if fpath_ext == "mp3" then
      run('mpv --profile=pseudo-gui --really-quiet "' .. fpath .. '" >/dev/null 2>&1 &')
      return
    end

    if fpath_ext == "mp4" then
      run(
        'nohup mpv --profile=pseudo-gui --really-quiet --autofit=500x500 --geometry=-15-60 "'
          .. fpath
          .. '" >/dev/null 2>&1 &'
      )
      return
    end

    if fpath_ext == "excel" then
      run('open "' .. fpath .. '" >/dev/null 2>&1 &')
      return
    end

    if fpath_ext == "pdf" and action == "open" then
      run('nohup zathura "' .. fpath .. '" >/dev/null 2>&1 &')
      return
    end

    if is_in_tmux() then
      open_with_tmux(action, fpath, fpath_ext)
    elseif is_in_wezterm() then
      open_with_wezterm(action, fpath, fpath_ext)
    end
  end,
}
