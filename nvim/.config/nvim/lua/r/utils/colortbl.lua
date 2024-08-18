local Highlight = require "r.settings.highlights"

local error_fg = Highlight.get("ErrorMsg", "fg")
local keyword_fg = Highlight.get("Keyword", "fg")

local statusline_bg = Highlight.get("StatusLine", "bg")
local statusline_fg = Highlight.get("StatusLine", "fg")
local statuslinenc_bg = Highlight.get("StatusLineNC", "bg")
local statuslinenc_fg = Highlight.get("StatusLineNC", "fg")

local normal_fg = Highlight.get("Normal", "fg")
local normal_bg = Highlight.get("Normal", "bg")
local pmenusel_fg = Highlight.get("PmenuSel", "bg")
-- local winseparator = Highlight.get("WinSeparator", "fg")

local branch_fg = Highlight.tint(normal_fg, 4)
local separator_fg = Highlight.tint(keyword_fg, -0.2)
local separator_fg_alt = Highlight.tint(statusline_bg, 0.5)

local separator_trouble = Highlight.tint(normal_bg, 0.3)
local separator = Highlight.tint(normal_bg, 0.3)

local mode_bg = Highlight.tint(statusline_bg, 1)
local statusline_fgc = Highlight.tint(statusline_fg, 0.1)

if vim.tbl_contains(vim.g.lightthemes, vim.g.colorscheme) then
  separator_fg_alt = Highlight.tint(statusline_fg, 0.05)
  separator_trouble = Highlight.tint(normal_bg, -0.1)
  separator = Highlight.tint(normal_bg, -0.1)
  mode_bg = Highlight.tint(statusline_bg, 0.48)
  statusline_fgc = Highlight.tint(statusline_fg, 0.3)

  statuslinenc_bg = Highlight.tint(statuslinenc_bg, 0.08)

  separator_fg_alt = Highlight.tint(separator_fg_alt, 0.7)
end

---@class r.utils.colortbl
local M = {
  statusline_fg = statusline_fgc,
  statusline_bg = Highlight.tint(statusline_bg, 0.6),

  statuslinenc_bg = statuslinenc_bg,
  statuslinenc_fg = statuslinenc_fg,

  separator_fg_inactive = Highlight.tint(statusline_bg, -0.8),

  separator_fg = separator_fg,
  separator_fg_alt = separator_fg_alt,

  branch_fg = branch_fg,
  terminal_fg = pmenusel_fg,

  filename_fg = Highlight.tint(statusline_bg, 6),
  modified_fg = Highlight.tint(error_fg, 0.3),

  mode_bg = mode_bg,

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

  directory = Highlight.get("Directory", "fg"),

  separator_trouble = separator_trouble,
  separator = separator,

  diagnostic_warn = Highlight.get("DiagnosticSignWarn", "fg"),
  diagnostic_err = Highlight.get("DiagnosticSignError", "fg"),
  diagnostic_info = Highlight.get("DiagnosticSignInfo", "fg"),
  diagnostic_hint = Highlight.get("DiagnosticSignHint", "fg"),
}
return M
