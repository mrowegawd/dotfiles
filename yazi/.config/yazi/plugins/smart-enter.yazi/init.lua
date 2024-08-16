local function fail(s, ...)
	ya.notify({ title = "Smart-Enter", content = string.format(s, ...), timeout = 5, level = "error" })
end

local function check_file_extension(filename)
	local pattern_mp3 = "%.mp3$"
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

-- local get_current_directory = ya.sync(function(_)
-- 	return tostring(cx.active.current.cwd)
-- end)

-- Taken from https://github.com/hankertrix/augment-command.yazi/tree/main
local hovered_item_is_dir = ya.sync(function(_)
	local hovered_item = cx.active.current.hovered
	return hovered_item and hovered_item.cha.is_dir
end)

-- Function to get the hovered item path
local get_hovered_item_path = ya.sync(function(_)
	local hovered_item = cx.active.current.hovered
	if hovered_item then
		return tostring(cx.active.current.hovered.url)
	else
		return nil
	end
end)

return {
	entry = function(_, args)
		local action = args[1]

		if hovered_item_is_dir() then
			ya.manager_emit("enter" or "open", { hovered = true })
		else
			local fpath = tostring(get_hovered_item_path())
			local fpath_ext = check_file_extension(fpath)

			if fpath_ext == "mp3" then
				os.execute("mpv --really-quiet '" .. fpath .. "'  >/dev/null 2>&1 &")
			end

			if fpath_ext == "pdf" then
				os.execute("zathura '" .. fpath .. "' >/dev/null 2>&1 &")
			end

			if fpath_ext == "mp4" then
				os.execute(
					"mpv --really-quiet --autofit=1000x900 --geometry=-15-60 '" .. fpath .. "' >/dev/null 2>&1 &"
				)
			end

			if fpath_ext == "jpg" then
				os.execute("sxiv '" .. fpath .. "' >/dev/null 2>&1 &")
			end

			if fpath_ext == "none" then
				os.execute([[tmux select-pane -R]])

				local child, err = Command("tmux")
					:args({
						"display-message",
						"-p",
						"'#{pane_current_command}'",
					})
					:stdin(Command.INHERIT)
					:stdout(Command.PIPED)
					:stderr(Command.INHERIT)
					:spawn()

				if not child then
					return fail("check pane_current_command went wrong", err)
				end

				local output, _ = child:wait_with_output()
				if not output then
					return fail("No output! %s", err)
				elseif not output.status.success and output.status.code ~= 130 then
					return fail("`something went wrong %s", output.status.code)
				end

				local pane_current_cmd = tostring(output.stdout:gsub("'", ""))
				pane_current_cmd = pane_current_cmd:gsub("\n$", "")

				if pane_current_cmd ~= "nvim" then
					local commandquit = [[tmux send-keys "nvim ]] .. fpath .. [[" Enter]]
					os.execute(commandquit)
				else
					local open_mode = ":e "
					if action == "vsplit" then
						open_mode = ":vsplit "
					elseif action == "split" then
						open_mode = ":split "
					end
					local command = [[tmux send-keys "]] .. open_mode .. fpath .. [[" Enter]]
					os.execute(command)
				end
			end
		end
	end,
}
