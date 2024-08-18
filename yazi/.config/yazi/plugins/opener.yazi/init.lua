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

		if action == "terminal" then
			local termopen = os.getenv("TERMINAL")
			os.execute([[bspc rule -a \* -o state=floating center=true rectangle=1200x800+0+0 && ]] .. termopen)
			return
		end

		local child, err = Command("tmux")
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

		if not child then
			return fail(tostring(action) .. " not  open?", err)
		end

		local output, errc = child:wait_with_output()
		if not output then
			return fail("No output! %s", errc)
		elseif not output.status.success and output.status.code ~= 130 then
			return fail("`something went wrong %s", output.status.code)
		end
	end,
}
