local Util = require "utils"
-- local wezterm = require "wezterm"

---@class ColorSpec
---@field color string
---@field xrdb? string
---@field regex_str_from_file? string

---@class OptsBaseColors
---@field fg ColorSpec
---@field bg ColorSpec
---@field black ColorSpec
---@field black_alt ColorSpec
---@field red ColorSpec
---@field red_alt ColorSpec
---@field green ColorSpec
---@field green_alt ColorSpec
---@field yellow ColorSpec
---@field yellow_alt ColorSpec
---@field blue ColorSpec
---@field blue_alt ColorSpec
---@field magenta ColorSpec
---@field magenta_alt ColorSpec
---@field cyan ColorSpec
---@field cyan_alt ColorSpec
---@field white ColorSpec
---@field white_alt ColorSpec
---@field cursor ColorSpec
---@field tab_active_fg ColorSpec
---@field tab_active_bg ColorSpec
---@field statusline_fg ColorSpec
---@field statusline_bg ColorSpec
---@field session_fg ColorSpec
---@field session_bg ColorSpec
---@field statusline_bg_message ColorSpec
---@field statusline_inactive_fg ColorSpec
---@field separator_fg ColorSpec
---@field keyword ColorSpec

---@class BaseColors
---@field fg string
---@field bg string
---@field black string
---@field black_alt string
---@field red string
---@field red_alt string
---@field green string
---@field green_alt string
---@field yellow string
---@field yellow_alt string
---@field blue string
---@field blue_alt string
---@field magenta string
---@field magenta_alt string
---@field cyan string
---@field cyan_alt string
---@field white string
---@field white_alt string
---@field cursor string
---@field tab_active_fg string
---@field tab_active_bg string
---@field session_fg string
---@field session_bg string
---@field statusline_fg string
---@field statusline_bg string
---@field statusline_bg_message string
---@field statusline_inactive_fg string
---@field separator_fg string
---@field keyword string

local local_file_color = false
local MASTER_THEME_FILE = "/tmp/master-colors-themes"
if Util.is_file_exists(MASTER_THEME_FILE) then
  local_file_color = true
end

---@param opts_color ColorSpec
---@return string
local function get_color_from_xrdb_or_file(opts_color)
  local cl

  if opts_color.regex_str_from_file and #opts_color.regex_str_from_file > 0 then
    if local_file_color then
      cl = Util.cmd_call(
        "grep -i "
          .. opts_color.regex_str_from_file
          .. " <"
          .. MASTER_THEME_FILE
          .. " | cut -d':' -f2 | head -1 | xargs"
      )
    end
  end

  if opts_color.xrdb and #opts_color.xrdb > 0 then
    cl = Util.cmd_call("xrdb -query | grep -i " .. opts_color.xrdb .. " | cut -d':' -f2 | head -1 | xargs")
  end

  if cl then
    return cl
  end

  return opts_color.color
end

---@type OptsBaseColors
local __base_colors = {
  fg = { color = "#dcd7ba", xrdb = "foreground" },
  bg = { color = "#1f1f28", xrdb = "background" },

  black = { color = "#090618", xrdb = ".color0" },
  black_alt = { color = "#727169", xrdb = ".color8" },
  red = { color = "#c34043", xrdb = ".color1" },
  red_alt = { color = "#e82424", xrdb = ".color9" },
  green = { color = "#76946a", xrdb = ".color2" },
  green_alt = { color = "#98bb6c", xrdb = ".color10" },
  yellow = { color = "#c0a36e", xrdb = ".color3" },
  yellow_alt = { color = "#e6c384", xrdb = ".color11" },
  blue = { color = "#7e9cd8", xrdb = ".color4" },
  blue_alt = { color = "#7fb4ca", xrdb = ".color12" },
  magenta = { color = "#957fb8", xrdb = ".color5" },
  magenta_alt = { color = "#938aa9", xrdb = ".color13" },
  cyan = { color = "#6a9589", xrdb = ".color4" },
  cyan_alt = { color = "#7aa89f", xrdb = ".color14" },
  white = { color = "#c8c093", xrdb = ".color7" },
  white_alt = { color = "#dcd7ba", xrdb = ".color15" },
  cursor = { color = "#df5476", xrdb = "cursor" },

  tab_active_fg = { color = "#df5476", regex_str_from_file = "tmux_tab_active_fg" },
  tab_active_bg = { color = "#7c2f42", regex_str_from_file = "tmux_tab_active_bg" },

  keyword = { color = "#7c2f42", regex_str_from_file = "tmux_keyword" },

  session_fg = { color = "#df5476", regex_str_from_file = "tmux_session_fg" },
  session_bg = { color = "#7c2f42", regex_str_from_file = "tmux_session_bg" },

  statusline_fg = { color = "#df5476", regex_str_from_file = "tmux_statusline_fg" },
  statusline_bg = { color = "#df5476", regex_str_from_file = "tmux_statusline_bg" },
  statusline_bg_message = { color = "#df5476", regex_str_from_file = "tmux_message_bg" },

  statusline_inactive_fg = { color = "#6e659e", regex_str_from_file = "tmux_border_inactive_status_fg" },

  separator_fg = { color = "#484349", regex_str_from_file = "tmux_border_inactive" },
}

local base_colors = {}

if Util.is_os_windows() then
  for i, _ in pairs(__base_colors) do
    base_colors[i] = __base_colors[i].color
  end
else
  for i, _ in pairs(__base_colors) do
    base_colors[i] = get_color_from_xrdb_or_file(__base_colors[i])
  end
end

-- wezterm.log_info(base_colors)

---@return BaseColors
return base_colors
