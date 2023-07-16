local highlight = as.highlight

local col_bg_default = highlight.get("Normal", "bg")
local col_fg_default = highlight.get("Comment", "fg")
local col_cmd_default = highlight.get("StatusLine", "bg")
local col_visual_default = highlight.get("Visual", "bg")

local col_bg = highlight.tint(col_bg_default, -0.1)
local col_fg = highlight.tint(col_fg_default, -0.3)

local col_cmd = highlight.tint(col_cmd_default, 0.3)
local col_cmd_fg = highlight.tint(col_cmd_default, 0.8)
local col_visual = highlight.tint(col_visual_default, -0.2)
local col_visual_fg = highlight.tint(col_visual_default, 0.3)

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
    -- a = { bg = colors.yellow, fg = colors.black, gui = "bold" },
    -- b = { bg = colors.lightgray, fg = colors.white },
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
