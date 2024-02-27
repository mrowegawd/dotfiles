local wezterm = require("wezterm")
local act = wezterm.action
-- local mux = wezterm.mux

local scrollback_lines = 5000 -- default is 3500

local function edit_in_new_tab(window, pane, text)
	if not text then
		return nil
	end
	local path = os.tmpname()
	local f = io.open(path, "w+")
	if not f then
		wezterm.log_error("could not open temp file for writing")
		return
	end
	f:write(text)
	f:flush()
	f:close()
	local args = {
		"zsh",
		"-ic",
		'nvim "$0"; ' .. 'wezterm cli activate-pane --pane-id "$1"',
		path,
		tostring(pane:pane_id()),
	}
	window:perform_action(act.SpawnCommandInNewTab({ args = args }), pane)
	wezterm.sleep_ms(1000)
	os.remove(path)
end

wezterm.on("trigger-nvim-with-scrollback", function(window, pane)
	local scrollback = pane:get_lines_as_text(scrollback_lines)
	edit_in_new_tab(window, pane, scrollback)
end)

-- wezterm.on("update-right-status", function(window, pane)
-- 	local date = wezterm.strftime("%Y-%m-%d %H:%M:%S")
--
-- 	-- Make it italic and underlined
-- 	window:set_right_status(wezterm.format({
-- 		{ Attribute = { Underline = "Single" } },
-- 		{ Attribute = { Italic = true } },
-- 		{ Text = "Hello " .. date },
-- 	}))
-- end)

-- wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
-- 	local zoomed = ""
-- 	if tab.active_pane.is_zoomed then
-- 		zoomed = "[Z] "
-- 	end
--
-- 	local index = ""
-- 	if #tabs > 1 then
-- 		index = string.format("[%d/%d] ", tab.tab_index + 1, #tabs)
-- 	end
--
-- 	return zoomed .. index .. tab.active_pane.title
-- end)

wezterm.on("open-uri", function(window, pane, uri)
	local found_URL, _ = string.find(uri, "http")

	local direction = "Up"
	local nvim_pane = pane:tab():get_pane_direction(direction)

	if not (found_URL == 1) then
		if nvim_pane == nil then
			window:perform_action(
				act.SplitPane({
					direction = direction,
					command = { args = { "nvim", uri } },
				}),
				pane
			)
		else
			window:perform_action(act.SendString(":e " .. uri .. "\r\n"), nvim_pane)
		end

		-- prevent the default action from opening in a browser
		return false
		-- prevent the default action from opening in a browser
		-- otherwise, by not specifying a return value, we allow later
		-- handlers and ultimately the default action to caused the
		-- URI to be opened in the browser
	end
end)

if not wezterm.target_triple:find("windows") then
	local cache_dir = os.getenv("HOME") .. "/.cache"
	local window_size_cache_path = cache_dir .. "wezterm-window_size_cache.txt"

	-- Mengatasi window saat resize dimana pengaturan size nya berubah
	-- Taken from: https://github.com/wez/wezterm/issues/256#issuecomment-1501101484
	---@diagnostic disable-next-line: unused-local
	wezterm.on("window-resized", function(window, pane)
		local window_size_cache_file = io.open(window_size_cache_path, "r")
		if window_size_cache_file == nil then
			local tab_size = pane:tab():get_size()
			local cols = tab_size["cols"]
			local rows = tab_size["rows"] + 2 -- Without adding the 2 here, the window doesn't maximize
			local contents = string.format("%d,%d", cols, rows)
			window_size_cache_file = assert(io.open(window_size_cache_path, "w"))
			window_size_cache_file:write(contents)
			window_size_cache_file:close()
		end
	end)
end

-- wezterm.on("gui-startup", function()
-- 	local _, _, window = mux.spawn_window({})
-- 	window:gui_window():maximize()
-- end)

return {}
