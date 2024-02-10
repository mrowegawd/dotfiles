local Highlight = require "r.settings.highlights"

local col_bg_default = Highlight.get("Normal", "bg")
local col_fg_default = Highlight.get("Comment", "fg")
local col_cmd_default = Highlight.get("StatusLine", "bg")
local col_visual_default = Highlight.get("Visual", "bg")

local col_bg = Highlight.tint(col_bg_default, -0.1)
local col_fg = Highlight.tint(col_fg_default, 0.2)

local col_cmd = Highlight.tint(col_cmd_default, 0.3)
local col_cmd_fg = Highlight.tint(col_cmd_default, 0.8)
local col_visual = Highlight.tint(col_visual_default, -0.2)
local col_visual_fg = Highlight.tint(col_visual_default, 0.3)

local colors = {
  normal_bg = col_bg,
  normal_fg = col_fg,

  command_bg = col_cmd,
  command_fg = col_cmd_fg,

  visual_bg = col_visual,
  visual_fg = col_visual_fg,
}
return {
  normal = {
    c = { bg = colors.normal_bg, fg = colors.normal_fg, gui = "bold" },
  },
  insert = {
    c = { bg = colors.insert_bg, fg = colors.insert_fg, gui = "bold" },
  },
  visual = {
    c = { bg = colors.visual_bg, fg = colors.visual_fg, gui = "bold" },
  },
  replace = {
    c = { bg = colors.normal_bg, fg = colors.normal_fg, gui = "bold" },
  },
  command = {
    c = { bg = colors.command_bg, fg = colors.command_fg, gui = "bold" },
  },
  inactive = {},
}
