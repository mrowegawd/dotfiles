local state = ya.sync(function()
	return cx.active.current.cwd
end)

local function fail(s, ...)
	ya.notify({ title = "Opcurdir", content = string.format(s, ...), timeout = 5, level = "error" })
end

local function is_in_tmux()
	if os.getenv("TMUX") then
		return true
	end
	return false
end

local function is_in_wezterm()
	if os.getenv("TERMINAL") == "wezterm" then
		return true
	end
	return false
end

local function send_command(prefix_cmd, tbl_cmds)
	local child, err =
		Command(prefix_cmd):args(tbl_cmds):stdin(Command.INHERIT):stdout(Command.PIPED):stderr(Command.INHERIT):spawn()

	if not child then
		return fail("check pane_current_command went wrong", err)
	end

	local output, _ = child:wait_with_output()
	if not output then
		return fail("No output! %s", err)
	elseif not output.status.success and output.status.code ~= 130 then
		return fail("something went wrong %s", output.status.code)
	end
	return output
end

local function open_with_tmux(cwd)
	os.execute([[tmux select-pane -R]])

	local output = send_command("tmux", { "display-message", "-p", "'#{pane_current_command}'" })
	if output == nil then
		fail("OPEN_WITH_TMUX", "something went wrong, check your command")
		return
	end
	local pane_current_cmd = tostring(output.stdout:gsub("'", ""))
	pane_current_cmd = pane_current_cmd:gsub("\n$", "")

	if pane_current_cmd == "nvim" then
		local commandquit = [[tmux send-keys ":qa!" Enter]]
		os.execute(commandquit)
	end

	os.execute("sleep 0.3")

	local command = [[tmux send-keys "cd ]] .. cwd .. [[" Enter]]
	os.execute(command)

	os.execute("sleep 0.5")

	local openeditor = [[tmux send-keys "nvim" Enter]]
	os.execute(openeditor)
end

local function open_with_wezterm(cwd)
	local output = send_command("wezterm", { "cli", "get-pane-direction", "right" })
	if output == nil then
		fail("OPEN_WITH_WEZTERM", "something went wrong, check your command")
		return
	end

	local pane_id_right = output.stdout:gsub("\n$", "")

	local wezterm_list = Command("wezterm"):args({ "cli", "list" }):stdout(Command.PIPED):spawn()
	local child, err = Command("awk")
		:args({
			"-v",
			"pane_id=" .. tostring(pane_id_right),
			"$3==pane_id { print $6 }",
		})
		:stdin(wezterm_list:take_stdout())
		:stdout(Command.PIPED)
		:stderr(Command.INHERIT)
		:output()

	if err then
		fail("OPEN_WITH_WEZTERM", "something went wrong during pipe command")
		return
	end

	local current_program_name = child.stdout:gsub("\n$", "")

	if current_program_name == "nvim" then
		os.execute('echo ":qa!" | wezterm cli send-text --pane-id ' .. pane_id_right .. " --no-paste")
		os.execute("sleep 0.5")
	end

	local cd_cmd = "echo 'cd " .. cwd .. "' | wezterm cli send-text --pane-id " .. pane_id_right
	os.execute(cd_cmd)

	-- This line will output an error `$` but it works
	local send_enter_key = "wezterm cli send-text --pane-id " .. pane_id_right .. " --no-paste $'\r'"
	os.execute(send_enter_key)

	local open_nvim = "echo 'nvim' | wezterm cli send-text --pane-id " .. pane_id_right
	os.execute(open_nvim)
	os.execute("sleep 0.5")
	os.execute(send_enter_key)

	local jump_to_pane = "wezterm cli activate-pane-direction --pane-id " .. pane_id_right .. " right"
	os.execute(jump_to_pane)
end

return {
	entry = function()
		local cwd = tostring(state())

		if is_in_tmux() then
			open_with_tmux(cwd)
		elseif is_in_wezterm() then
			open_with_wezterm(cwd)
		else
			fail("only support for tmux or wezterm terminal")
		end
	end,
}
