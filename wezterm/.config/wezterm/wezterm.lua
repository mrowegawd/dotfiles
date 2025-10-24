local Color = require "colors"
local Hyperlinks = require "hyperlinks"

local Key = require "keymaps.keys"
local wezterm = require "wezterm"

require "event"
require "statusline"

-- Link for checking mapping keys:
-- https://wezfurlong.org/wezterm/config/keys.html

-- Example configuration for wezterm.lua:
-- https://github.com/bew/dotfiles/blob/main/gui/wezterm/wezterm.lua

-- Example wezterm lua configurations:
-- https://github.com/wez/wezterm/discussions/628

local function font_with_fallback(name)
  return wezterm.font_with_fallback { name, "Fira Code Nerd Font" }
end

local config = wezterm.config_builder()

-- if Util.is_windows then
-- 	-- config.default_prog = { "pwsh", "-NoLogo", "-ExecutionPolicy", "RemoteSigned", "-NoProfileLoadTime" }
-- end

if wezterm.target_triple:find "windows" then
  config.launch_menu = {
    {
      label = " PowerShell V7",
      args = {
        "pwsh",
        "-NoLogo",
        "-ExecutionPolicy",
        "RemoteSigned",
        "-NoProfileLoadTime",
      },
      cwd = "~",
    },
    { label = " PowerShell V5", args = { "powershell" }, cwd = "~" },
    { label = "Command Prompt", args = { "cmd.exe" }, cwd = "~" },
    { label = " Git bash", args = { "sh", "-l" }, cwd = "~" },
  }

  -- ref: https://wezfurlong.org/wezterm/config/lua/WslDomain.html
  config.wsl_domains = {
    {
      name = "WSL:Ubuntu",
      distribution = "Ubuntu",
      username = "mr00x",
      default_cwd = "/home/mr00x",
      default_prog = { "zsh" },
    },
    {
      name = "WSL:Alpine",
      distribution = "Alpine",
      username = "sravioli",
      default_cwd = "/home/sravioli",
    },
  }
  -- config.default_prog = { "pwsh" }
  config.font_size = 7 -- pengaturan font agar mudah dibaca
  config.window_decorations = "RESIZE"
  wezterm.on("gui-startup", function(cmd)
    local screen = wezterm.gui.screens().active
    local _, _, window = wezterm.mux.spawn_window(cmd or {})
    local gui = window:gui_window()
    local width = 0.9 * screen.width
    local height = 0.9 * screen.height
    gui:set_inner_size(width, height)
    gui:set_position((screen.width - width) / 2, (screen.height - height) / 2)
  end)
  -- wezterm.on("gui-startup", function()
  -- 	local _, _, window = wezterm.mux.spawn_window({})
  -- 	window:gui_window():maximize()
  -- end)
else
  -- config.term = "wezterm"
  config.window_decorations = "RESIZE"
  config.font_size = 13.5 -- pengaturan font agar mudah dibaca
end

-- [1.0] alpha channel value with oating point numbers in the range 0.0
-- (meaning completely translucent/transparent) through to 1.0 (meaning
-- completely opaque)- Base
-- window_background_opacity = 0.7,
config.window_close_confirmation = "NeverPrompt"
config.exit_behavior = "Close"
config.cursor_blink_rate = 400
config.warn_about_missing_glyphs = false

-- default_prog = { "zsh", "-l" },

-- ├┤ BAR ├─────────────────────────────────────────────────────────────┤
config.show_new_tab_button_in_tab_bar = true
config.show_tab_index_in_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.show_tabs_in_tab_bar = true
config.switch_to_last_active_tab_when_closing_tab = false
config.tab_and_split_indices_are_zero_based = false
config.tab_bar_at_bottom = false
config.tab_max_width = 30
config.use_fancy_tab_bar = false -- disable ini membuat bar jadi polos

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- For Mac
config.set_environment_variables = {
  -- PATH = "/Users/quantong/.cargo/bin:" .. "/opt/homebrew/bin:" .. os.getenv("PATH"),
  PATH = os.getenv "PATH",
}

if not wezterm.target_triple:find "windows" then
  config.set_environment_variables = {
    PATH = wezterm.home_dir .. "/.asdf/shims:" .. wezterm.home_dir .. "/.fzf/bin:" .. os.getenv "PATH",
  }
  -- else
  -- 	config.set_environment_variables = {}
end

-- Dim window
config.inactive_pane_hsb = {
  saturation = 1,
  brightness = 0.8,
}

-- ├┤ FRAME ├───────────────────────────────────────────────────────────┤
config.window_frame = {
  -- active_titlebar_bg = Color.bg,
  -- font_size = 12.0,
  -- inactive_titlebar_bg = Color.bg,
  active_titlebar_bg = Color.bg,
  active_titlebar_fg = Color.bg,
  inactive_titlebar_bg = Color.bg,
  inactive_titlebar_fg = Color.bg,
}

-- ├┤ COLORS ├──────────────────────────────────────────────────────────┤
-- config.background = {
-- 	Background.get_wallpaper(),
-- }
config.colors = {
  background = Color.bg,
  foreground = Color.fg,
  cursor_bg = Color.cursor,
  cursor_border = Color.blue,
  split = Color.separator_fg,
  ansi = {
    Color.black,
    Color.red,
    Color.green,
    Color.yellow,
    Color.blue,
    Color.cyan,
    Color.magenta,
    Color.white,
  },

  copy_mode_active_highlight_bg = { Color = Color.red },
  compose_cursor = "orange",
  brights = {
    Color.black_alt,
    Color.red_alt,
    Color.green_alt,
    Color.yellow_alt,
    Color.blue_alt,
    Color.cyan_alt,
    Color.magenta_alt,
    Color.white_alt,
  },
  copy_mode_inactive_highlight_bg = { Color = "#52ad70" },
  tab_bar = {
    background = Color.bg,
    new_tab = { -- color tanda "+" pada tab bar
      fg_color = Color.statusline_inactive_fg,
      bg_color = Color.bg,
      intensity = "Half",
    },
  },
}

-- Make wezterm more fast
-- https://www.youtube.com/watch?v=VMdSJ8d5Aos
config.max_fps = 120
config.webgpu_power_preference = "LowPower" -- HighPerformance | LowPower

-- ├┤ HYPERLINKS-RULES ├────────────────────────────────────────────────┤
config.hyperlink_rules = Hyperlinks

-- ├┤ FONTS ├───────────────────────────────────────────────────────────┤
-- config.line_height = 1 -- (default is 1)
-- font_shaper = "Harfbuzz",

-- Download font: https://monaspace.githubnext.com/
config.harfbuzz_features = { "calt=0" }
config.adjust_window_size_when_changing_font_size = false
config.font = font_with_fallback "JetBrainsMono Nerd Font"
config.font_rules = {
  {
    intensity = "Normal",
    italic = true,
    font = wezterm.font("JetBrainsMono Nerd Font", { style = "Italic" }),
  },
}

-- ├┤ MAPPINGS ├────────────────────────────────────────────────────────┤
config.disable_default_key_bindings = true

-- Use same prefix with tmux: <c-space>
config.leader = { key = " ", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = Key
-- config.mouse_bindings = KeyMouse
-- config.key_tables = KeyTbl

return config
