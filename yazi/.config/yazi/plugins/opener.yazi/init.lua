local state = ya.sync(function()
	return cx.active.current.cwd
end)

local function fail(s, ...)
	ya.notify({ title = "Opener", content = string.format(s, ...), timeout = 5, level = "error" })
end

local function is_in_tmux()
	if os.getenv("TMUX") then
		return true
	end
	return false
end

local function open_with_tmux(action, cwd)
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

	child, err = child:wait_with_output()
	if not child then
		return fail("No output! %s", err)
	elseif not child.status.success and child.status.code ~= 130 then
		return fail("something went wrong %s", child.status.code)
	end
end

local function open_with_wezterm(action, cwd)
	local tbl_args = {
		"start",
		"--always-new-process",
		"--cwd",
		cwd,
		"--class",
		"if-select",
	}

	local _tblargs = {}

	if action == "lazygit" then
		local user = os.getenv("HOME")
		_tblargs = {
			"lazygit",
			"--use-config-file",
			user .. "/.config/lazygit/config.yml," .. user .. "/.config/lazygit/theme/fla.yml",
		}
	end

	if action == "lazydocker" then
		_tblargs = { "lazydocker" }
	end

	if #_tblargs > 0 then
		for _, v in ipairs(_tblargs) do
			table.insert(tbl_args, v)
		end
	end

	local child, err =
		Command("wezterm"):args(tbl_args):stdin(Command.INHERIT):stdout(Command.PIPED):stderr(Command.INHERIT):spawn()

	if not child then
		return fail(tostring(action) .. " not  open?", err)
	end
	local output, errc = child:wait_with_output()
	if not output then
		return fail("No output! %s", errc)
	elseif not output.status.success and output.status.code ~= 130 then
		return fail("something went wrong %s", output.status.code)
	end
end

return {
	entry = function(_, job)
		local action = job.args[1]

		local cwd = tostring(state())

		-- TODO: check juga jika berada di windows
		-- dengan command ini: ya.target_family() == "windows"
		if action == "terminal" then
			local termopen = os.getenv("TERMINAL")
			os.execute([[bspc rule -a \* -o state=floating center=true rectangle=1200x800+0+0 && ]] .. termopen)
			return
		end

		if action == "lazygit" and is_in_tmux() then
			action = action
				.. ' --use-config-file="$HOME/.config/lazygit/config.yml,$HOME/.config/lazygit/theme/fla.yml"'
		end

		if is_in_tmux() then
			open_with_tmux(action, cwd)
		else
			open_with_wezterm(action, cwd)
		end
	end,
}
