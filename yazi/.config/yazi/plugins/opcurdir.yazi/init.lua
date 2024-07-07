local state = ya.sync(function()
	return cx.active.current.cwd
end)

local function fail(s, ...)
	ya.notify({ title = "Fzf", content = string.format(s, ...), timeout = 5, level = "error" })
end

return {
	entry = function()
		local cwd = tostring(state())

		-- TODO: buat wezterm belum ada

		os.execute([[tmux select-pane -R]])

		local child, _ = Command("tmux")
			:args({
				"display-message",
				"-p",
				"'#{pane_current_command}'",
			})
			:stdin(Command.INHERIT)
			:stdout(Command.PIPED)
			:stderr(Command.INHERIT)
			:spawn()

		if not child then
			return fail("check pane_current_command went wrong", err)
		end

		local output, err = child:wait_with_output()
		if not output then
			return fail("No output! %s", err)
		elseif not output.status.success and output.status.code ~= 130 then
			return fail("`something went wrong %s", output.status.code)
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
	end,
}
