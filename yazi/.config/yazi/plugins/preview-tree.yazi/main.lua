local M = {}

local function fail(s, ...)
	ya.notify({ title = "Preview tree", content = string.format(s, ...), timeout = 5, level = "error" })
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

-- Function to get file extension
local get_file_extension = function(filename)
	local pattern_mp3 = "%.mp3$"
	local pattern_wav = "%.wav$"
	local pattern_mp4 = "%.mp4$"
	local pattern_gif = "%.gif$"
	local pattern_pdf = "%.pdf$"
	local pattern_png = "%.png$"
	local pattern_jpg = "%.jpg$"
	local pattern_jpeg = "%.jpeg$"
	local pattern_webp = "%.webp$"
	local pattern_mkv = "%.mkv$"
	local pattern_avi = "%.avi$"

	if string.match(filename, pattern_mp3) then
		return "mp3"
	elseif string.match(filename, pattern_wav) then
		return "mp3"
	elseif string.match(filename, pattern_mp4) then
		return "mp4"
	elseif string.match(filename, pattern_mkv) then
		return "mp4"
	elseif string.match(filename, pattern_avi) then
		return "mp4"
	elseif string.match(filename, pattern_gif) then
		return "mp4"
	elseif string.match(filename, pattern_pdf) then
		return "pdf"
	elseif string.match(filename, pattern_jpg) then
		return "jpg"
	elseif string.match(filename, pattern_png) then
		return "jpg"
	elseif string.match(filename, pattern_webp) then
		return "jpg"
	elseif string.match(filename, pattern_jpeg) then
		return "jpg"
	else
		return "none"
	end
end

-- Function to get the hovered item path
local get_hovered_item_path = ya.sync(function(_)
	local hovered_item = cx.active.current.hovered
	if hovered_item then
		return tostring(cx.active.current.hovered.url)
	else
		return nil
	end
end)

local exec_os_cmd = function(pane_id, cmds)
	local term_cmd
	if is_in_tmux() then
		term_cmd = "tmux send-keys -t " .. pane_id .. " "
		term_cmd = term_cmd .. " '" .. cmds .. "' C-m "
	elseif is_in_wezterm() then
		term_cmd = "wezterm cli send-text --no-paste "
		term_cmd = term_cmd .. '"' .. cmds .. '"\r ' .. " --pane-id " .. pane_id
	end

	os.execute(term_cmd)
end

local gen_cmd_ext = function(pane_id, fpath_ext, fpath)
	if fpath_ext == "mp3" then
		os.execute("mpv --really-quiet '" .. fpath .. "'  >/dev/null 2>&1 &")
	end

	if fpath_ext == "pdf" then
		os.execute("zathura '" .. fpath .. "' >/dev/null 2>&1 &")
	end

	if fpath_ext == "mp4" then
		os.execute("mpv --really-quiet --autofit=1000x900 --geometry=-15-60 '" .. fpath .. "' >/dev/null 2>&1 &")
	end

	if fpath_ext == "jpg" then
		if os.getenv("TERMINAL") == "st" then
			os.execute('sxiv "' .. fpath .. '" >/dev/null 2>&1 &')
		else
			exec_os_cmd(pane_id, "clear")
			exec_os_cmd(
				pane_id,
				[[kitty +kitten icat --silent --scale-up --transfer-mode=memory --align left --stdin=no ]] .. fpath
			)
		end
	end
end

local function get_output_string_cmd(cmd, args)
	local child, _ =
		Command(cmd):args(args):stdin(Command.INHERIT):stdout(Command.PIPED):stderr(Command.INHERIT):spawn()

	local output, err = child:wait_with_output()
	if not output then
		return fail("No output! Command: %s, Args: %s, Error: %s", cmd, table.concat(args, " "), err)
	elseif not output.status.success and output.status.code ~= 130 then
		return fail(
			"Command failed! Command: %s, Args: %s, Exit status code: %s",
			cmd,
			table.concat(args, " "),
			output.status.code
		)
	end

	return tostring(output.stdout:gsub("'", ""))
end

local function send_text_cmds(cmd, args)
	local child, _ =
		Command(cmd):args(args):stdin(Command.INHERIT):stdout(Command.PIPED):stderr(Command.INHERIT):spawn()

	local output, err = child:wait_with_output()
	if not output then
		return fail("No output! Command: %s, Args: %s, Error: %s", cmd, table.concat(args, " "), err)
	elseif not output.status.success and output.status.code ~= 130 then
		return fail(
			"Command failed! Command: %s, Args: %s, Exit status code: %s",
			cmd,
			table.concat(args, " "),
			output.status.code
		)
	end
end

local function open_with_tmux(fpath_ext, fpath)
	if fpath_ext == "jpg" and os.getenv("TERMINAL") == "st" then
		gen_cmd_ext(3, fpath_ext, fpath)
		return
	end

	if fpath_ext ~= "jpg" then
		fail("Only image files can be previewed")
		return
	end

	local is_pane_at_bottom = get_output_string_cmd("tmux", { "display", "-p", "'#{pane_at_bottom}'" })
	local list_panes = get_output_string_cmd("sh", { "-c", "tmux list-panes | wc -l" })
	-- local pane_id = get_output_string_cmd("tmux", { "display", "-p", "'#{pane_index}'" })

	if tonumber(list_panes) < 3 or (tonumber(list_panes) == 2) then
		send_text_cmds("tmux", { "split-window", "-vl", "20", "-c", "'#{pane_current_path}'" })
		send_text_cmds("tmux", { "splitw", "-fv", ";", "swapp", "-t", "!", ";", "killp", "-t", "!" })
		send_text_cmds("tmux", { "resize-pane", "-D", "10" })
		send_text_cmds("tmux", { "last-pane" })
	end

	gen_cmd_ext(3, fpath_ext, fpath)
end

local function open_with_wezterm(fpath_ext, fpath)
	local pane_id = get_output_string_cmd("wezterm", { "cli", "get-pane-direction", "down" })

	if #pane_id == 0 and (fpath_ext == "jpg") then
		pane_id = get_output_string_cmd("wezterm", { "cli", "split-pane", "--bottom" })
		fail(pane_id)
	end

	gen_cmd_ext(pane_id, fpath_ext, fpath)
	send_text_cmds("tmux", { "last-pane" })
end

-- function M:setup()
-- 	toggle_view_mode()
-- end

function M:entry(_)
	local fpath = get_hovered_item_path()
	if fpath == nil then
		fail("This file is unknown format?")
		return
	end

	local fpath_ext = get_file_extension(tostring(fpath))

	if is_in_tmux() then
		open_with_tmux(fpath_ext, fpath)
	elseif is_in_wezterm() then
		open_with_wezterm(fpath_ext, fpath)
	end
end

return M
