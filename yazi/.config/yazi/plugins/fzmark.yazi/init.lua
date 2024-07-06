local function fail(s, ...)
	ya.notify({ title = "Fzf", content = string.format(s, ...), timeout = 5, level = "error" })
end

return {
	entry = function()
		ya.hide()

		local homeuser = os.getenv("HOME")
		local cwdmark = homeuser .. "/Dropbox/data.programming.forprivate/marked-pwd"

		local echocwd = Command("cat"):arg(cwdmark):stdout(Command.PIPED):spawn()

		local child, err = Command("fzf-tmux")
			:args({
				"--preview",
				"'eza --long --all --git --color=always --group-directories-first --icons {1}'",
				"--preview-window",
				"right:50%:hidden",
				"-xC",
				"-w",
				"60%",
				"-h",
				"50%",
			})
			:stdin(echocwd:take_stdout())
			:stdout(Command.PIPED)
			:stderr(Command.INHERIT)
			:spawn()

		if not child then
			return fail("Spawn `rfzf` failed with error code %s. Do you have it installed?", err)
		end

		local output, err = child:wait_with_output()
		if not output then
			return fail("No output! %s", err)
		elseif not output.status.success and output.status.code ~= 130 then
			return fail("`something went wrong %s", output.status.code)
		end

		local target = output.stdout:gsub("\n$", "")
		-- fail(target:match("[/\\]$"))
		if target ~= "" then
			-- ya.manager_emit(target:match("[/\\]$") and "cd" or "reveal", { target })
			ya.manager_emit("cd", { target })
		end
	end,
}
