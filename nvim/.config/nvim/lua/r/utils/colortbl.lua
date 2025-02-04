local Highlight = require "r.settings.highlights"

local normal_fg = Highlight.get("Normal", "fg")
local normal_bg = Highlight.get("Normal", "bg")

local statusline_fg = Highlight.get("StatusLine", "fg")
local statusline_bg = Highlight.get("StatusLine", "bg")
local statuslinenc_fg = Highlight.get("StatusLineNC", "fg")
local statuslinenc_bg = Highlight.get("StatusLineNC", "bg")

local branch_fg = Highlight.tint(Highlight.get("GitSignsAdd", "fg"), 0.2)

local error_fg = Highlight.get("Error", "fg")
local error_fgnc = Highlight.darken(error_fg, 0.4, Highlight.get("Normal", "bg"))

local keyword = Highlight.get("Keyword", "fg")
local keyword_blur = Highlight.tint(statusline_bg, 0.15)

local keywordnc = Highlight.get("KeywordBlur", "bg")
local keywordnc_blur = Highlight.tint(keywordnc, -0.2)

local separator = Highlight.tint(normal_bg, 0.3)
local separator_fg_alt = Highlight.tint(statusline_bg, 0.6)

local mode_bg = Highlight.tint(statusline_bg, 1)
local disorent = Highlight.tint(statusline_bg, 1)

if vim.tbl_contains({ "zenburned" }, vim.g.colorscheme) then
  keywordnc = Highlight.get("KeywordBlur", "bg")
  keywordnc_blur = Highlight.tint(keywordnc, -0.05)
end

if vim.tbl_contains(vim.g.lightthemes, vim.g.colorscheme) then
  separator_fg_alt = Highlight.tint(separator_fg_alt, 0.7)

  branch_fg = Highlight.tint(normal_fg, -1)

  keywordnc = Highlight.tint(statusline_bg, -0.04)
  separator = Highlight.tint(normal_bg, -0.1)

  mode_bg = Highlight.tint(statusline_bg, 0.48)

  statuslinenc_bg = Highlight.tint(statuslinenc_bg, 0.08)
  disorent = Highlight.tint(statusline_bg, -0.3)
end

local directory = Highlight.get("Keyword", "fg")

---@class r.utils.colortbl
local M = {
  statusline_fg = statusline_fg,
  statusline_bg = statusline_bg,

  statuslinenc_fg = statuslinenc_fg,
  statuslinenc_bg = statuslinenc_bg,

  branch_fg = branch_fg,

  keyword = keyword,
  keyword_blur = keyword_blur,
  keywordnc = keywordnc,
  keywordnc_blur = keywordnc_blur,

  filename_fg = Highlight.tint(statusline_bg, 6),
  modified_fg = Highlight.tint(error_fg, 0.3),

  mode_bg = mode_bg,

  disorent = disorent,

  error_fg = error_fg,

  norm_bg = statusline_bg,

  mod_ins = error_fg,
  mode_ins_bar = Highlight.tint(error_fg, -0.4),
  mod_insnc = error_fgnc,
  mod_vis = Highlight.get("visual", "bg"),
  mod_term = Highlight.get("Boolean", "fg"),

  diff_add = Highlight.get("GitSignsAdd", "fg"),
  diff_change = Highlight.get("GitSignsChange", "fg"),
  diff_delete = Highlight.get("GitSignsDelete", "fg"),

  directory = directory,

  separator_fg = separator,
  separator_fg_alt = separator_fg_alt,
  separator_fg_inactive = Highlight.tint(statusline_bg, -0.8),

  diagnostic_warn = Highlight.get("DiagnosticSignWarn", "fg"),
  diagnostic_err = Highlight.get("DiagnosticSignError", "fg"),
  diagnostic_info = Highlight.get("DiagnosticSignInfo", "fg"),
  diagnostic_hint = Highlight.get("DiagnosticSignHint", "fg"),
}
return M
