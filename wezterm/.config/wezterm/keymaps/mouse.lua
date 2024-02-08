local wezterm = require("wezterm")
local act = wezterm.action

return {
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "NONE",
			action = act({ CompleteSelection = "PrimarySelection" }),
		},
		{
			event = { Up = { streak = 1, button = "Right" } },
			mods = "NONE",
			action = act({ CompleteSelection = "Clipboard" }),
		},
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "CTRL",
			action = "OpenLinkAtMouseCursor",
		},

}
