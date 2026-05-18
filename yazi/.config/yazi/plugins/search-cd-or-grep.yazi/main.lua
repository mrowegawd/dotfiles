--- search-cd-or-grep.yazi/init.lua

local function fail(msg)
  ya.notify { title = "Search-cd-or-grep", content = msg, level = "error", timeout = 3 }
end

local SHELL = os.getenv "SHELL"

local state = ya.sync(function()
  ---@diagnostic disable-next-line: undefined-global
  return cx.active.current.cwd
end)

local function shell_output(cmd)
  local handle = io.popen(cmd)
  if not handle then
    return nil
  end
  local result = handle:read "*a"
  handle:close()
  return result
end

local function has_bin(bin)
  return shell_output("command -v " .. bin .. " 2>/dev/null") ~= ""
end

local M = {}

function M:entry(_, args)
  local cwd = tostring(state())

  local cmd1 = "cd directory"
  local cmd2 = "grep string"

  local fzf_cmd =
    string.format("echo -n '%s\n%s' | fzf-tmux -xC -w 30%% -h 20%% --prompt='Select command> ' --ansi", cmd1, cmd2)

  local child, err =
    Command(SHELL):arg({ "-c", fzf_cmd }):stdin(Command.INHERIT):stdout(Command.PIPED):stderr(Command.INHERIT):spawn()

  if not child then
    return fail "Failed to spawn fzf for mode selection"
  end

  local mode_output, err = child:wait_with_output()
  if not mode_output or mode_output.status.code ~= 0 then
    return -- user cancel
  end

  local mode = mode_output.stdout:gsub("%s+$", "")

  if mode == cmd1 then
    M:_cd_mode(cwd)
  elseif mode == cmd2 then
    M:_grep_mode(cwd)
  end
end

function M:_cd_mode(cwd)
  local list_cmd
  if has_bin "fd" then
    list_cmd = string.format("fd --hidden --no-ignore --follow . %q 2>/dev/null", cwd)
  else
    list_cmd = string.format("find %q -mindepth 1 -not -path '*/\\.git/*' 2>/dev/null", cwd)
  end

  local fzf_cmd = list_cmd .. " | fzf-tmux -xC -w 80% -h 80% --ansi"

  local child, err =
    Command(SHELL):arg({ "-c", fzf_cmd }):stdin(Command.INHERIT):stdout(Command.PIPED):stderr(Command.INHERIT):spawn()

  if not child then
    return fail "Failed to spawn fzf for cd mode"
  end

  local output, _ = child:wait_with_output()
  if not output or output.status.code ~= 0 then
    return -- user cancel
  end

  local selected = output.stdout:gsub("%s+$", "")
  if selected == "" then
    return
  end
  local cmd_info_dir = string.format("test -d %s && echo dir || echo file", selected)

  local target_dir
  local check_dir = Command(SHELL):arg({ "-c", cmd_info_dir }):stdout(Command.PIPED):spawn()

  if check_dir then
    local check_out = check_dir:wait_with_output()
    if check_out and check_out.stdout:match "^dir" then
      target_dir = selected
    end

    local cmd_dirname = string.format("dirname %s", selected)
    local parent = Command(SHELL):arg({ "-c", cmd_dirname }):stdout(Command.PIPED):spawn()
    if parent then
      local parent_out = parent:wait_with_output()
      target_dir = parent_out and parent_out.stdout:gsub("%s+$", "") or cwd
    end
  end

  if target_dir and target_dir ~= "" then
    ya.emit("cd", { target_dir })
  end
end

function M:_grep_mode(cwd)
  local grep_bin = has_bin "rg" and "rg" or "grep"

  local fzf_cmd
  if grep_bin == "rg" then
    local safe_cwd = string.format("%q", cwd)

    fzf_cmd = [[fzf-tmux -xC -w 80% -h 80% ]]
      .. [[--ansi ]]
      .. [[--disabled ]]
      .. [[--prompt="Grep > " ]]
      .. [[--delimiter=":" ]]
      .. [[--bind="start:reload:rg --hidden --no-ignore --line-number --color=always -- '' ]]
      .. safe_cwd
      .. [[ 2>/dev/null || true" ]]
      .. [[--bind="change:reload:rg --hidden --no-ignore --line-number --color=always -- {q} ]]
      .. safe_cwd
      .. [[ 2>/dev/null || true" ]]
      .. [[--preview="bat --color=always --highlight-line {2} {1} 2>/dev/null || cat {1}" ]]
      .. [[--preview-window="right:50%,+{2}+3/3"]]
  else
    fzf_cmd = string.format(
      "grep -rn --include='*' --hidden . %q 2>/dev/null | fzf"
        .. " --prompt='Grep > '"
        .. " --height=80%%"
        .. " --layout=reverse"
        .. " --border=rounded"
        .. " --ansi"
        .. " --delimiter=':'",
      cwd
    )
  end

  local child = Command(SHELL):arg({ "-c", fzf_cmd }):stdout(Command.PIPED):stderr(Command.INHERIT):spawn()

  if not child then
    return fail "Failed to spawn fzf for grep mode"
  end

  local output, _ = child:wait_with_output()
  if not output or output.status.code ~= 0 then
    return -- user cancel
  end

  local selected = output.stdout:gsub("%s+$", "")
  if selected == "" then
    return
  end

  local filepath = selected:match "^([^:]+):"
  local filepath_line = selected:match ":(%d+):"

  if not filepath then
    filepath = selected
  end

  if not filepath:match "^/" then
    filepath = cwd .. "/" .. filepath
  end

  local parent = Command("sh"):arg({ "-c", string.format("dirname %q", filepath) }):stdout(Command.PIPED):spawn()

  if parent then
    local parent_out = parent:wait_with_output()
    local target_dir = parent_out and parent_out.stdout:gsub("%s+$", "")
    if target_dir and target_dir ~= "" then
      ya.emit("cd", { target_dir })

      local plugin_name = "smart-enter"
      local args_cmd
      if filepath_line then
        args_cmd = "vsplit .. " .. tostring(filepath) .. " " .. tostring(filepath_line)
      else
        args_cmd = "vsplit .. " .. tostring(filepath)
      end

      ya.emit("plugin", { plugin_name, args_cmd })
    end
  end
end

return M
