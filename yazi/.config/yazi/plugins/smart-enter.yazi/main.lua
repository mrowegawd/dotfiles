local function fail(s, ...)
  ya.notify { title = "Smart-Enter", content = string.format(s, ...), timeout = 5, level = "error" }
end

local function check_file_extension(filename)
  local pattern_mp3 = "%.mp3$"
  local pattern_wav = "%.wav$"
  local pattern_mp4 = "%.mp4$"
  local pattern_gif = "%.gif$"
  local pattern_pdf = "%.pdf$"
  local pattern_png = "%.png$"
  local pattern_jpg = "%.jpg$"
  local pattern_jpeg = "%.jpeg$"
  local pattern_webp = "%.webp$"
  local pattern_mkv = "%.mkv$"
  local pattern_avi = "%.avi$"
  local pattern_microsoft = "%.xlsx$"

  if string.match(filename, pattern_mp3) then
    return "mp3"
  elseif string.match(filename, pattern_wav) then
    return "mp3"
  elseif string.match(filename, pattern_mp4) then
    return "mp4"
  elseif string.match(filename, pattern_mkv) then
    return "mp4"
  elseif string.match(filename, pattern_avi) then
    return "mp4"
  elseif string.match(filename, pattern_gif) then
    return "mp4"
  elseif string.match(filename, pattern_pdf) then
    return "pdf"
  elseif string.match(filename, pattern_jpg) then
    return "jpg"
  elseif string.match(filename, pattern_png) then
    return "jpg"
  elseif string.match(filename, pattern_webp) then
    return "jpg"
  elseif string.match(filename, pattern_jpeg) then
    return "jpg"
  elseif string.match(filename, pattern_microsoft) then
    return "excel"
  else
    return "open"
  end
end

-- local get_current_directory = ya.sync(function(_)
-- 	return tostring(cx.active.current.cwd)
-- end)

-- Taken from https://github.com/hankertrix/augment-command.yazi/tree/main
local hovered_item_is_dir = ya.sync(function(_)
  local hovered_item = cx.active.current.hovered
  return hovered_item and hovered_item.cha.is_dir
end)

-- Function to get the hovered item path
local get_hovered_item_path = ya.sync(function(_)
  local hovered_item = cx.active.current.hovered
  if hovered_item then
    return tostring(cx.active.current.hovered.url)
  else
    return nil
  end
end)

local function is_in_tmux()
  if os.getenv "TMUX" then
    return true
  end
  return false
end

local function is_in_wezterm()
  if os.getenv "TERMINAL" == "wezterm" then
    return true
  end
  return false
end

local function get_output_string_cmd(cmd, arg)
  local child, _ = Command(cmd):arg(arg):stdin(Command.INHERIT):stdout(Command.PIPED):stderr(Command.INHERIT):output()

  if not child then
    return fail "OPEN_WITH_WEZTERM: Get pane_id went wrong"
  end
  return child.stdout:gsub("\n$", "")
end

local function get_output_string_cmd_pipe(cmd, arg)
  local child, _ = Command(cmd):arg(arg):stdin(Command.INHERIT):stdout(Command.PIPED):stderr(Command.INHERIT):spawn()

  local output, err = child:wait_with_output()
  if not output then
    return fail("No output! Command: %s, Args: %s, Error: %s", cmd, table.concat(arg, " "), err)
  elseif not output.status.success and output.status.code ~= 130 then
    return fail(
      "Command failed! Command: %s, Args: %s, Exit status code: %s",
      cmd,
      table.concat(arg, " "),
      output.status.code
    )
  end

  return tostring(output.stdout:gsub("'", ""))
end

local function open_with_tmux(action, fpath, fpath_ext)
  if fpath_ext == "pdf" then
    os.execute('nohup zathura "' .. fpath .. '" >/dev/null 2>&1 &')
    return
  end

  os.execute [[tmux select-pane -R]]

  local child, err = Command("tmux")
    :arg({ "display-message", "-p", "'#{pane_current_command}'" })
    :stdin(Command.INHERIT)
    :stdout(Command.PIPED)
    :stderr(Command.INHERIT)
    :spawn()

  if not child then
    return fail("check pane_current_command went wrong", err)
  end

  local output, _ = child:wait_with_output()
  if not output then
    return fail("No output! %s", err)
  elseif not output.status.success and output.status.code ~= 130 then
    return fail("something went wrong %s", output.status.code)
  end

  local pane_current_cmd = tostring(output.stdout:gsub("'", ""))
  pane_current_cmd = pane_current_cmd:gsub("\n$", "")

  if pane_current_cmd ~= "nvim" then
    local commandquit = [[tmux send-keys "nvim ]] .. fpath .. [[" Enter]]
    os.execute(commandquit)
  else
    local open_mode = ":e "
    if action == "vsplit" then
      open_mode = ":vsplit "
    elseif action == "split" then
      open_mode = ":sp "
    elseif action == "tab" then
      open_mode = ":tabe "
    end
    local command = [[tmux send-keys "]] .. open_mode .. fpath .. [[" Enter]]
    os.execute(command)
  end
end

local function open_with_wezterm(action, fpath, fpath_ext)
  if fpath_ext == "pdf" then
    local get_pane_id_right = get_output_string_cmd("wezterm", { "cli", "get-pane-direction", "right" })
    local wezterm_list = Command("wezterm"):arg({ "cli", "list" }):stdout(Command.PIPED):spawn()
    local child, _ = Command("awk")
      :arg({
        "-v",
        "pane_id=" .. get_pane_id_right,
        "$3==pane_id { print $6 }",
      })
      :stdin(wezterm_list:take_stdout())
      :stdout(Command.PIPED)
      :stderr(Command.INHERIT)
      :output()

    local current_program_name = child.stdout:gsub("\n$", "")

    if current_program_name == "nvim" or current_program_name == "zsh" then
      get_output_string_cmd("wezterm", { "cli", "activate-pane-direction", "right" })
      local jd =
        get_output_string_cmd("wezterm", { "cli", "split-pane", "--horizontal", "--pane-id", get_pane_id_right })

      get_output_string_cmd(
        "wezterm",
        { "cli", "send-text", "--no-paste", 'fancy-cat "' .. fpath .. '"\r', "--pane-id", jd }
      )
    end
    return
  end

  local current_pane_id = get_output_string_cmd("wezterm", { "cli", "get-pane-direction", "left" })
  -- original command: wezterm cli list | awk -v pane_id=79 '$3==pane_id { print $6 }'
  local current_program_name = get_output_string_cmd_pipe(
    "sh",
    { "-c", "wezterm cli list | awk -v pane_id=" .. current_pane_id .. " '$3==pane_id { print $6 }'" }
  )

  -- local wezterm_list = Command("wezterm"):arg({ "cli", "list" }):stdout(Command.PIPED):spawn()
  -- fail(wezterm_list:take_stdout())
  -- local child, _ = Command("awk")
  -- 	:arg({
  -- 		"-v",
  -- 		"pane_id=" .. tostring(current_pane_id),
  -- 		"$3==pane_id { print $6 }",
  -- 	})
  -- 	:stdin(wezterm_list:take_stdout())
  -- 	:stdout(Command.PIPED)
  -- 	:stderr(Command.INHERIT)
  -- 	:output()

  if not current_program_name then
    fail "Something went wrong [[current_program_name]] is nil"
    return
  end

  current_program_name = current_program_name:gsub("\n$", "")

  if current_program_name ~= "nvim" then
    fail "not implemented yet"
    --  --  "$pane_id" --no-paste $'\r'
    --  local commandquit = [[tmux send-keys "nvim ]] .. fpath .. [[" Enter]]
    --  os.execute(commandquit)
    return
  end

  local open_mode = ":e "
  if action == "vsplit" then
    open_mode = ":vsplit "
  elseif action == "split" then
    open_mode = ":sp "
  elseif action == "tab" then
    open_mode = ":tabe "
  end

  local command = [[echo "]]
    .. open_mode
    .. " "
    .. fpath
    .. [[\r" | wezterm cli send-text --pane-id ]]
    .. tostring(current_pane_id)
    .. [[ --no-paste]]

  local move_cursor_to_target_pane = [[wezterm cli activate-pane-direction --pane-id ]] .. current_pane_id .. [[ left]]

  os.execute(command)
  os.execute(move_cursor_to_target_pane)
end

return {
  entry = function(_, job)
    local action = job.args[1]

    if hovered_item_is_dir() then
      ya.manager_emit("enter" or "open", { hovered = true })
    else
      local fpath = tostring(get_hovered_item_path())
      local fpath_ext = check_file_extension(fpath)

      if fpath_ext == "jpg" then
        os.execute('nohup sxiv "' .. fpath .. '" >/dev/null 2>&1 &')
        return
      end

      if fpath_ext == "mp3" then
        os.execute('mpv --profile=pseudo-gui --really-quiet "' .. fpath .. '"  >/dev/null 2>&1 &')
        return
      end

      if fpath_ext == "mp4" then
        os.execute(
          'nohup mpv --profile=pseudo-gui --really-quiet --autofit=1000x900 --geometry=-15-60 "'
            .. fpath
            .. '" >/dev/null 2>&1 &'
        )
        return
      end

      if fpath_ext == "excel" then
        os.execute('open "' .. fpath .. '" >/dev/null 2>&1 &')
        return
      end

      if action == "open" and fpath_ext == "jpg" then
        os.execute("feh --bg-scale " .. fpath)
        return
      end

      if action == "open" and fpath_ext == "pdf" then
        os.execute('nohup zathura "' .. fpath .. '" >/dev/null 2>&1 &')
        return
      end

      if is_in_tmux() then
        open_with_tmux(action, fpath, fpath_ext)
      elseif is_in_wezterm() then
        open_with_wezterm(action, fpath, fpath_ext)
      end
    end
  end,
}
