local wezterm = require "wezterm"
local Color = require "colors"
local Util = require "utils"

local function turn_off_tab_bar(window, pane, process_names)
  local overrides = window:get_config_overrides() or {}
  process_names = process_names or {}
  for _, name in pairs(process_names) do
    if Util.get_foreground_process_name(pane, name) then
      overrides.enable_tab_bar = false
      window:set_config_overrides(overrides)
      return
    end
  end
end

---@diagnostic disable-next-line: unused-local
wezterm.on("update-right-status", function(window, pane)
  local statusline_fg = Color.statusline_fg

  local clock_fg = Color.red
  local bg = Color.bg

  turn_off_tab_bar(window, pane, { "ncmpcpp", "lazygit", "lazydocker", "btop" })

  -- local date = wezterm.strftime("%Y-%m-%d %H:%M")
  local date = wezterm.strftime "%H:%M"
  local username = os.getenv "USER" or os.getenv "LOGNAME" or os.getenv "USERNAME"

  local session = window:active_workspace()

  local SOLID_RIGHT_ARROW = utf8.char(0xe0bc)
  local right_arrow = SOLID_RIGHT_ARROW

  window:set_right_status(wezterm.format {
    { Attribute = { Intensity = "Bold" } },
    { Foreground = { Color = clock_fg } },
    { Background = { Color = bg } },
    { Text = "  " .. date .. " " },
    { Foreground = { Color = statusline_fg } },
    { Text = " Alt " },
    { Text = " 👨 " .. username .. " " },
    { Foreground = { Color = Color.bg } },
    { Background = { Color = Color.white } },
    { Text = right_arrow },
    { Text = " ❐ " .. session .. " " },
  })
end)

local SOLID_LEFT_ARROW = utf8.char(0xe0ba)
local SOLID_LEFT_MOST = utf8.char(0x2588)
local SOLID_RIGHT_ARROW = utf8.char(0xe0bc)

--stylua: ignore
local SUP_IDX = { "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹", "¹⁰",
  "¹¹", "¹²", "¹³", "¹⁴", "¹⁵", "¹⁶", "¹⁷", "¹⁸", "¹⁹", "²⁰" }
--stylua: ignore
local SUB_IDX = { "₁", "₂", "₃", "₄", "₅", "₆", "₇", "₈", "₉", "₁₀",
  "₁₁", "₁₂", "₁₃", "₁₄", "₁₅", "₁₆", "₁₇", "₁₈", "₁₉", "₂₀" }

local function basename_dir(s)
  local basename

  if not Util.is_os_windows() then
    local path = s:gsub("file://", "")
    -- Remove the trailing slash if it exists
    if path:sub(-1) == "/" then
      path = path:sub(1, -2)
    end
    -- Find the basename
    basename = path:match "([^/]+)$"
  end

  return basename
end

---@diagnostic disable-next-line: unused-local
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local edge_background = Color.bg
  local background = Color.bg
  local foreground = Color.statusline_fg
  local dim_foreground = Color.red_alt
  local zoom_foreground = Color.statusline_inactive_fg

  if tab.is_active then
    background = Color.active_bg
    foreground = Color.active_fg
    zoom_foreground = Color.yellow
  elseif hover then
    background = Color.active_fg
    foreground = Color.bg
  end

  local edge_foreground = background

  local left_arrow = SOLID_LEFT_ARROW
  if tab.tab_index == 0 then
    left_arrow = SOLID_LEFT_MOST
  end

  local zoomed = ""
  if tab.active_pane.is_zoomed then
    zoomed = "󰁌 "
  end

  local id = SUB_IDX[tab.tab_index + 1]
  local pid = SUP_IDX[tab.active_pane.pane_index + 1]

  local pane = tab.active_pane
  local cwd = pane.current_working_dir
  local pwd
  if cwd then
    local cwd_str = tostring(cwd)
    pwd = basename_dir(cwd_str)
  else
    pwd = "[None Directory]"
  end

  return {
    { Attribute = { Intensity = "Bold" } },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = left_arrow },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = id .. " " },
    { Text = pwd }, -- title
    { Foreground = { Color = zoom_foreground } },
    { Text = " " .. zoomed },
    { Foreground = { Color = dim_foreground } },
    { Text = pid },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_RIGHT_ARROW },
    { Attribute = { Intensity = "Normal" } },
  }
end)
