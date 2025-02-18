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
		term_cmd = "tmux send-keys -t " .. pane_id
		term_cmd = term_cmd .. " '" .. cmds .. "' C-m "
	end
	os.execute(term_cmd)
end

local gen_cmd_ext = function(fpath_ext, fpath)
	if fpath_ext == "mp3" then
		os.execute("mpv --really-quiet '" .. fpath .. "'  >/dev/null 2>&1 &")
	end

	if fpath_ext == "pdf" then
		os.execute("zathura '" .. fpath .. "' >/dev/null 2>&1 &")
	end

	if fpath_ext == "mp4" then
		fail("adf")
		os.execute("mpv --really-quiet --autofit=1000x900 --geometry=-15-60 '" .. fpath .. "' >/dev/null 2>&1 &")
	end

	if fpath_ext == "jpg" then
		exec_os_cmd(3, "clear")
		exec_os_cmd(
			3,
			[[kitty +kitten icat --silent --scale-up --transfer-mode=memory --align left --stdin=no ]] .. fpath
		)
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

local function cad(cmd, args)
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
	local is_pane_at_bottom = get_output_string_cmd("tmux", { "display", "-p", "'#{pane_at_bottom}'" })

	if tonumber(is_pane_at_bottom) == 1 and (fpath_ext == "jpg") then
		-- fail("Please try to create a split pane manually.")
		-- fail("No pane available for preview! Aborting operation!")
		cad("tmux", { "split-window", "-vl", "20", "-c", "'#{pane_current_path}'" })
		cad("tmux", { "splitw", "-fv", ";", "swapp", "-t", "!", ";", "killp", "-t", "!" })
		cad("tmux", { "last-pane" })
	end

	gen_cmd_ext(fpath_ext, fpath)
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
	end
end

-- function M:peek()
-- 	local args = {
-- 		"-a",
-- 		"--oneline",
-- 		"--color=always",
-- 		"--icons=always",
-- 		"--group-directories-first",
-- 		"--no-quotes",
-- 		tostring(self.file.url),
-- 	}
--
-- 	if is_tree_view_mode() then
-- 		table.insert(args, "-T")
-- 	end
--
-- 	local child = Command("eza"):args(args):stdout(Command.PIPED):stderr(Command.PIPED):spawn()
--
-- 	local limit = self.area.h
-- 	local lines = ""
-- 	local num_lines = 1
-- 	local num_skip = 0
-- 	local empty_output = false
--
-- 	repeat
-- 		local line, event = child:read_line()
-- 		if event == 1 then
-- 			fail(tostring(event))
-- 		elseif event ~= 0 then
-- 			break
-- 		end
--
-- 		if num_skip >= self.skip then
-- 			lines = lines .. line
-- 			num_lines = num_lines + 1
-- 		else
-- 			num_skip = num_skip + 1
-- 		end
-- 	until num_lines >= limit
--
-- 	if num_lines == 1 and not is_tree_view_mode() then
-- 		empty_output = true
-- 	elseif num_lines == 2 and is_tree_view_mode() then
-- 		empty_output = true
-- 	end
--
-- 	child:start_kill()
-- 	if self.skip > 0 and num_lines < limit then
-- 		ya.manager_emit("peek", {
-- 			tostring(math.max(0, self.skip - (limit - num_lines))),
-- 			only_if = tostring(self.file.url),
-- 			upper_bound = "",
-- 		})
-- 	elseif empty_output then
-- 		ya.preview_widgets(self, {
-- 			ui.Paragraph(self.area, { ui.Line("No items") }):align(ui.Paragraph.CENTER),
-- 		})
-- 	else
-- 		ya.preview_widgets(self, { ui.Paragraph.parse(self.area, lines) })
-- 	end
-- end
--
-- function M:seek(units)
-- 	local h = cx.active.current.hovered
-- 	if h and h.url == self.file.url then
-- 		local step = math.floor(units * self.area.h / 10)
-- 		ya.manager_emit("peek", {
-- 			math.max(0, cx.active.preview.skip + step),
-- 			only_if = tostring(self.file.url),
-- 			force = true,
-- 		})
-- 	end
-- end

return M
