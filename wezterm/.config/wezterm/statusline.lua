local wezterm = require "wezterm"
---@type BaseColors
local Color = require "colors"

local Util = require "utils"

local SOLID_LEFT_ARROW = utf8.char(0xe0ba)
-- local SOLID_LEFT_MOST = utf8.char(0x2588)
local SOLID_RIGHT_ARROW = utf8.char(0xe0bc)

local username = os.getenv "USER" or os.getenv "LOGNAME" or os.getenv "USERNAME"
local date = wezterm.strftime "%H:%M"

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

  local calendar = wezterm.strftime "%A, %d-%b-%Y"

  window:set_right_status(wezterm.format {
    { Attribute = { Intensity = "Bold" } },
    { Foreground = { Color = statusline_fg } },
    { Text = "  " .. calendar .. " " },
    { Foreground = { Color = clock_fg } },
    { Background = { Color = bg } },
    { Text = "  " .. date .. " " },
    { Foreground = { Color = statusline_fg } },
    { Text = " Alt " },
    { Text = " 👨 " .. username .. " " },
  })
end)

-- local function active_tab_for_gui_window(gui_window)
--   for _, item in ipairs(gui_window:mux_window():tabs_with_info()) do
--     if item.is_active then
--       return item.tab
--     end
--   end
-- end

wezterm.on("update-status", function(window, pane)
  local session = window:active_workspace()
  local basename_session = session:match "([^/]+)$"

  local left_arrow = SOLID_LEFT_ARROW

  -- TODO: perbaiki utk detect pada tab index di posisi pertama
  -- Attempt: cara ini salah
  -- local tab_idx = pane:tab():active_pane():pane_id()
  -- wezterm.log_info(pane_id)
  --
  -- Attempt 2: cara juga salah
  -- local tab_idx = active_tab_for_gui_window(window)
  -- wezterm.log_info(pane_id:tab_id())

  -- local tab_id = active_tab_for_gui_window(window)
  -- wezterm.log_info(tab_id:tab_id())

  local left_arrow_color = Color.bg
  -- if tab_id == 0 then
  --   left_arrow_color = Color.tab_active_bg
  -- end

  window:set_left_status(wezterm.format {
    { Foreground = { Color = Color.session_fg } },
    { Background = { Color = Color.session_bg } },
    { Text = " ❐ " .. basename_session .. " " },
    { Foreground = { Color = left_arrow_color } },
    { Text = left_arrow },
  })
end)

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

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local dim_fg = Color.red_alt
  local zoom_fg = Color.statusline_inactive_fg

  local foreground = Color.statusline_fg
  local background = Color.bg

  local edge_fg = background
  local edge_bg = background

  if tab.is_active then
    foreground = Color.tab_active_fg
    background = Color.tab_active_bg
    edge_fg = background
    edge_bg = Color.bg
    zoom_fg = Color.yellow
  elseif hover then
    background = Color.keyword
    edge_fg = background
    edge_bg = Color.bg
  end

  local left_arrow = SOLID_LEFT_ARROW
  -- if tab.tab_index == 0 then
  --   left_arrow = SOLID_LEFT_MOST
  -- end

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
    { Background = { Color = edge_bg } },
    { Foreground = { Color = edge_fg } },
    { Text = left_arrow },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = id .. " " },
    { Text = pwd }, -- title
    { Foreground = { Color = zoom_fg } },
    { Text = " " .. zoomed },
    { Foreground = { Color = dim_fg } },
    { Text = pid },
    { Background = { Color = edge_bg } },
    { Foreground = { Color = edge_fg } },
    { Text = SOLID_RIGHT_ARROW },
    { Attribute = { Intensity = "Normal" } },
  }
end)
