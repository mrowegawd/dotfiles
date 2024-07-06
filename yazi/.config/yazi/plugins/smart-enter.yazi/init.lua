return {
	entry = function()
		local h = cx.active.current.hovered
		if h.cha.is_dir then
			ya.manager_emit("enter" or "open", { hovered = true })
		else
			-- local hx_command = "'\\e : o " .. tostring(h.url) .. " \\r'"

			local fpath = tostring(h.url)

			os.execute([[tmux select-pane -R]])

			local command = [[tmux send-keys ":e ]] .. fpath .. [[" Enter]]
			os.execute(command)
		end
	end,
}
