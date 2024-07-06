local state = ya.sync(function()
	return cx.active.current.cwd
end)

local function fail(s, ...)
	ya.notify({ title = "Opener", content = string.format(s, ...), timeout = 5, level = "error" })
end

return {
	entry = function(_, args)
		local action = args[1]

		local cwd = tostring(state())

		local child, err
		if action == "terminal" then
			local termenv = os.getenv("TERMINAL")
			if termenv == "kitty" then
				child, err = Command(termenv):stdout(Command.PIPED):spawn()
			else
				child, err = Command(termenv):args({ "-c", cwd }):stdout(Command.PIPED):spawn()
			end
		else
			child, err = Command("tmux")
				:args({
					"popup",
					"-d",
					cwd,
					"-h",
					"80%",
					"-w",
					"90%",
					"-E",
					action,
				})
				:stdin(Command.INHERIT)
				:stdout(Command.PIPED)
				:stderr(Command.INHERIT)
				:spawn()
		end

		if not child then
			return fail(tostring(action) .. " not  open?", err)
		end

		local output, err = child:wait_with_output()
		if not output then
			return fail("No output! %s", err)
		elseif not output.status.success and output.status.code ~= 130 then
			return fail("`something went wrong %s", output.status.code)
		end
	end,
}
