local Highlight = require "r.settings.highlights"

local error_fg = Highlight.get("Error", "fg")
local statusline_bg = Highlight.get("StatusLine", "bg")
local statusline_fg = Highlight.get("StatusLine", "fg")
local normal_fg = Highlight.get("Normal", "fg")
local normal_bg = Highlight.get("Normal", "bg")

local branch_fg = Highlight.tint(normal_fg, 4)
local separator_fg = Highlight.tint(error_fg, -0.2)
local separator_fg_alt = Highlight.tint(statusline_bg, 0.5)

if vim.g.background and vim.g.background == "light" then
  branch_fg = Highlight.tint(normal_fg, 0.5)

  separator_fg = Highlight.tint(error_fg, 0.2)
  separator_fg_alt = Highlight.tint(statusline_bg, -0.05)
end

return {
  statusline_fg = Highlight.tint(statusline_fg, 0.8),
  statusline_bg = statusline_bg,

  separator_fg = separator_fg,
  separator_fg_alt = separator_fg_alt,

  branch_fg = branch_fg,

  filename_fg = Highlight.tint(statusline_bg, 6),
  modified_fg = Highlight.tint(error_fg, 0.3),

  mode_bg = Highlight.tint(statusline_bg, 1),

  disorent = Highlight.tint(statusline_bg, 0.5),

  error_fg = error_fg,

  norm_fg = normal_fg,
  norm_bg = normal_bg,

  mod_ins = error_fg,
  mod_vis = Highlight.get("visual", "bg"),
  mod_term = Highlight.get("Boolean", "fg"),

  diff_add = Highlight.get("GitSignsAdd", "fg"),
  diff_delete = Highlight.get("GitSignsChange", "fg"),
  diff_change = Highlight.get("GitSignsDelete", "fg"),

  diagnostic_warn = Highlight.get("DiagnosticSignWarn", "fg"),
  diagnostic_err = Highlight.get("DiagnosticSignError", "fg"),
  diagnostic_info = Highlight.get("DiagnosticSignInfo", "fg"),
  diagnostic_hint = Highlight.get("DiagnosticSignHint", "fg"),
}
