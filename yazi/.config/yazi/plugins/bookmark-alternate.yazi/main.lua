local function fail(s, ...)
	ya.notify({ title = "Bookmark Alternate", content = string.format(s, ...), timeout = 5, level = "error" })
end

local function fileExists(filename)
	local file = io.open(filename, "r")
	if file then
		file:close()
		return true -- File ada
	else
		return false -- File tidak ada
	end
end

local function jump(cwd)
	local child, err = Command("cat")
		:args({
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

local alt_backward = "/.cache/yazi/alternate-forward"
local alt_forward = "/.cache/yazi/alternate-backward"
local home = os.getenv("HOME")

-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃ COMMANDS                                                ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

local save_alternate = function()
	local cwd = tostring(state())
	local alternate_forward = home .. alt_forward
	local alternate_backward = home .. alt_backward

	local shell_value = os.getenv("SHELL"):match(".*/(.*)")

	local fzf_args =
		"fzf-tmux --preview 'bat $HOME/.cache/yazi/{}' --preview-window down:20%:nohidden -xC -w 60% -h 50%  --prompt='Save alternate> ' "

	local path_alternate = home .. "/.cache/yazi"
	local echocwd = Command("ls"):arg(path_alternate):stdout(Command.PIPED):spawn()

	local child, err = Command(shell_value)
		:args({
			"-c",
			fzf_args,
		})
		:stdin(echocwd:take_stdout())
		:stdout(Command.PIPED)
		:stderr(Command.INHERIT)
		:spawn()

	if not child then
		return fail("Spawn `rfzf` failed with error code %s. Do you have it installed?", err)
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
			os.execute('echo "' .. cwd .. '"  > ' .. alternate_backward)
		end

		if target == "alternate-forward" then
			os.execute('echo "' .. cwd .. '" > ' .. alternate_forward)
		end
	end
end

local toggle_alternate = function()
	local alternate_forward = home .. alt_forward
	local alternate_backward = home .. alt_backward

	-- Menggunakan file sebagai penanda toggle alternate
	local state_toggle = "/tmp/yazi-alternate"

	if fileExists(state_toggle) then
		jump(alternate_backward)
		os.execute("rm " .. state_toggle)
	else
		jump(alternate_forward)
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
