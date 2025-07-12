local function fail(s, ...)
	ya.notify({ title = "Fzf", content = string.format(s, ...), timeout = 5, level = "error" })
end

-- local state = ya.sync(function()
-- 	return cx.active.current.cwd
-- end)

local function is_in_tmux()
	if os.getenv("TMUX") then
		return true
	end
	return false
end

local function is_in_terminal()
	return os.getenv("TERMINAL")
end

local function open_with_tmux(cwd_bookmark)
	local echocwd = Command("cat"):arg(cwd_bookmark):stdout(Command.PIPED):spawn()

	local child, err = Command("fzf-tmux")
		:arg({
			-- "--preview",
			-- "'eza --tree --long --all --git --color=always --group-directories-first --icons {1}'",
			-- "--preview-window",
			-- "right:50%:nohidden",
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
		return fail("Open with tmux: no output! %s", err)
	elseif not output.status.success and output.status.code ~= 130 then
		return fail("Open with tmux: something went wrong %s", output.status.code)
	end

	return output
end

local function open_with_wezterm(cwd_bookmark)
	local echocwd = Command("cat"):arg(cwd_bookmark):stdout(Command.PIPED):spawn()

	local child, err = Command("fzf-tmux")
		:arg({
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

	-- local cwd = tostring(state())
	-- local args = {
	-- 	"start",
	-- 	"--always-new-process",
	-- 	"--cwd",
	-- 	cwd,
	-- 	"--class",
	-- 	"if-select",
	-- 	"bash",
	-- 	"-c",
	-- 	"cat ~/Dropbox/data.programming.forprivate/marked-pwd | fzf-tmux -xC -w 60% -h 50%",
	-- }
	-- local child, err =
	-- 	Command("wezterm"):arg(args):stdin(Command.INHERIT):stdout(Command.PIPED):stderr(Command.INHERIT):spawn()

	if not child then
		return fail("Spawn `rfzf` failed with error code %s. Do you have it installed?", err)
	end

	local output, err = child:wait_with_output()
	if not output then
		fail("Open with tmux: no output! %s", err)
		return nil
	elseif not output.status.success and output.status.code ~= 130 then
		fail("Open with tmux: something went wrong %s", output.status.code)
		return nil
	end

	return output
end

return {
	entry = function()
		ui.hide()

		local homeuser = os.getenv("HOME")
		local path_bookmark_cwd = homeuser .. "/Dropbox/data.programming.forprivate/marked-pwd"

		local output
		if is_in_tmux() then
			output = open_with_tmux(path_bookmark_cwd)
		elseif is_in_terminal() == "wezterm" then
			output = open_with_wezterm(path_bookmark_cwd)
		else
			output = open_with_tmux(path_bookmark_cwd)
		end

		if output then
			local target = output.stdout:gsub("\n$", "")
			-- fail(target:match("[/\\]$"))
			if target ~= "" then
				-- ya.manager_emit(target:match("[/\\]$") and "cd" or "reveal", { target })
				ya.manager_emit("cd", { target })
			end
		end
	end,
}
