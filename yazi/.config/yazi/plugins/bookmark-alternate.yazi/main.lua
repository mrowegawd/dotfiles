local function fail(s, ...)
	ya.notify({ title = "Bookmark Alternate", content = string.format(s, ...), timeout = 5, level = "error" })
end

local function is_file_exists(filename)
	local file = io.open(filename, "r")
	if file then
		file:close()
		return true -- File ada
	end

	return false -- File tidak ada
end

local function jump(cwd)
	local child, err = Command("cat")
		:arg({
			cwd,
		})
		:stdin(Command.INHERIT)
		:stdout(Command.PIPED)
		:stderr(Command.INHERIT)
		:spawn()

	if not child then
		return fail("check went wrong", err)
	end

	local output, errc = child:wait_with_output()
	if not output then
		return fail("No output! error: %s", errc)
	else
		local target = output.stdout:gsub("\n$", "")
		if target ~= "" then
			ya.manager_emit("cd", { target })
		end
	end
end

local state = ya.sync(function()
	return cx.active.current.cwd
end)

local cwd_backward = "/.cache/yazi/alternate-backward"
local cwd_forward = "/.cache/yazi/alternate-forward"
local home = os.getenv("HOME")

-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃ COMMANDS                                                ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

local save_alternate = function()
	local cwd = tostring(state())
	local cwd_alternate_forward = home .. cwd_forward
	local cwd_alternate_backward = home .. cwd_backward

	local shell_value = os.getenv("SHELL"):match(".*/(.*)")

	local fzf_args =
		"fzf-tmux --preview 'bat $HOME/.cache/yazi/{}' --preview-window down:20%:nohidden -xC -w 60% -h 50%  --prompt='Save alternate> ' "

	local path_alternate = home .. "/.cache/yazi"
	local echocwd = Command("ls"):arg(path_alternate):stdout(Command.PIPED):spawn()

	local child, err = Command(shell_value)
		:arg({
			"-c",
			fzf_args,
		})
		:stdin(echocwd:take_stdout())
		:stdout(Command.PIPED)
		:stderr(Command.INHERIT)
		:spawn()

	if not child then
		return fail("Spawn `fzf` failed with error code %s. Do you have it installed?", err)
	end

	local output, errc = child:wait_with_output()
	if not output then
		return fail("No output! %s", errc)
	end
	if not output.status.success and output.status.code ~= 130 then
		return fail("something went wrong %s", output.status.code)
	end

	local target = output.stdout:gsub("\n$", "")
	if target ~= "" then
		if target == "alternate-backward" then
			os.execute('echo "' .. cwd .. '"  > ' .. cwd_alternate_backward)
			return
		end
		os.execute('echo "' .. cwd .. '" > ' .. cwd_alternate_forward)
	end
end

local toggle_alternate = function()
	local cwd_alternate_forward = home .. cwd_forward
	local cwd_alternate_backward = home .. cwd_backward

	if not is_file_exists(cwd_alternate_backward) then
		os.execute("mkdir -p " .. home .. "/.cache/yazi")
		os.execute("touch " .. cwd_alternate_backward)
	end

	if not is_file_exists(cwd_alternate_forward) then
		os.execute("mkdir -p " .. home .. "/.cache/yazi")
		os.execute("touch " .. cwd_alternate_forward)
	end

	-- Menggunakan file sebagai penanda toggle alternate
	local state_toggle = "/tmp/yazi-alternate"

	if is_file_exists(state_toggle) then
		jump(cwd_alternate_backward)
		os.execute("rm " .. state_toggle)
	else
		jump(cwd_alternate_forward)
		os.execute("touch " .. state_toggle)
	end
end

return {
	entry = function(_, job)
		local action = job.args[1]
		if not action then
			return
		end

		if action == "toggle" then
			toggle_alternate()
			return
		end

		if action == "save" then
			save_alternate()
			return
		end
	end,
}
