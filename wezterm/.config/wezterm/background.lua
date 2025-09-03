local Util = require "utils"
local M = {}

function M.get_wallpaper()
  -- local wallpapers = {}
  -- local wallpapers_glob = os.getenv("HOME") .. "/Downloads/wezterm-walli3/**"
  -- for _, v in ipairs(wezterm.glob(wallpapers_glob)) do
  -- table.insert(wallpapers, wallpapers)
  -- end

  local wallpapers_glob = Util.cmd_call "cat /tmp/bg-windows | xargs"
  return {
    source = { File = { path = Util.get_random_entry(wallpapers_glob) } },
    height = "Cover",
    width = "Cover",
    horizontal_align = "Center",
    repeat_x = "Repeat",
    repeat_y = "Repeat",
    opacity = 1,
    hsb = { brightness = 0.030 },
  }
end

return M
