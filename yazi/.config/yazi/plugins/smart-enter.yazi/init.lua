local function check_file_extension(filename)
	local pattern_mp3 = "%.mp3$"
	local pattern_mp4 = "%.mp4$"
	local pattern_gif = "%.gif$"
	local pattern_pdf = "%.pdf$"
	local pattern_png = "%.png$"
	local pattern_jpg = "%.jpg$"
	local pattern_jpeg = "%.jpeg$"
	local pattern_webp = "%.webp$"

	if string.match(filename, pattern_mp3) then
		return "mp3"
	elseif string.match(filename, pattern_mp4) then
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

return {
	entry = function(_, args)
		local action = args[1]

		local h = cx.active.current.hovered
		if h.cha.is_dir then
			ya.manager_emit("enter" or "open", { hovered = true })
		else
			-- local hx_command = "'\\e : o " .. tostring(h.url) .. " \\r'"

			local fpath = tostring(h.url)
			local fpath_ext = check_file_extension(fpath)

			if fpath_ext == "mp3" then
				os.execute("mpv '" .. fpath .. "'  >/dev/null 2>&1 &")
			end

			if fpath_ext == "pdf" then
				os.execute("zathura '" .. fpath .. "' >/dev/null 2>&1 &")
			end

			if fpath_ext == "mp4" then
				os.execute("mpv --autofit=1000x900 --geometry=-15-60 '" .. fpath .. "' >/dev/null 2>&1 &")
			end

			if fpath_ext == "jpg" then
				os.execute("sxiv '" .. fpath .. "' >/dev/null 2>&1 &")
			end

			if fpath_ext == "none" then
				os.execute([[tmux select-pane -R]])

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
	end,
}
