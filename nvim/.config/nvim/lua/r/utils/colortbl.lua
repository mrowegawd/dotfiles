local Highlight = require "r.settings.highlights"

local normal_fg = Highlight.get("Normal", "fg")

-- Statusline
local fg = Highlight.tint(Highlight.get("StatusLine", "fg"), -0.25)
local bg = Highlight.get("StatusLine", "bg")
local nc_fg = Highlight.get("StatusLineNC", "fg")
local nc_bg = Highlight.get("StatusLineNC", "bg")

local mode_bg = Highlight.get("Keyword", "fg")
local mode_bg_blur = Highlight.tint(mode_bg, -0.55)
local modenc_bg = Highlight.get("KeywordBlur", "bg")
local modenc_bg_blur = Highlight.tint(modenc_bg, -0.18)

local branch_fg = Highlight.tint(Highlight.get("GitSignsAdd", "fg"), 0.2)
local path_name = Highlight.tint(Highlight.get("StatusLine", "fg"), -0.05)
local filename = Highlight.tint(Highlight.get("StatusLine", "fg"), 0.14)

local error_fg = Highlight.get("Error", "fg")
local error_fgnc = Highlight.darken(error_fg, 0.4, Highlight.get("Normal", "bg"))

local keywordnc_fg = Highlight.tint(mode_bg, -0.2)

local session = Highlight.tint(Highlight.get("DiagnosticSignWarn", "fg"), -0.2)
local disorent = Highlight.tint(bg, 1)
local notif = Highlight.tint(Highlight.get("Function", "fg"), 0.2)
local directory = Highlight.tint(Highlight.get("Directory", "fg"), 0.1)

if vim.g.colorscheme == "lackluster" then
  modenc_bg = Highlight.get("KeywordBlur", "bg")
  directory = Highlight.tint(Highlight.get("Directory", "fg"), 0.2)
end

if vim.g.colorscheme == "nord" then
  mode_bg_blur = Highlight.tint(mode_bg, -0.25)
  session = Highlight.tint(Highlight.get("DiagnosticSignWarn", "fg"), 0.1)
  modenc_bg = Highlight.tint(Highlight.get("KeywordBlur", "bg"), 0.05)
  modenc_bg_blur = Highlight.tint(modenc_bg, -0.05)
end

-- if vim.g.colorscheme == "rose-pine-dawn" then
--   modenc_bg = Highlight.tint(modenc_bg, 0.01)
--   modenc_bg_blur = Highlight.tint(modenc_bg, 0.03)
-- end
if vim.g.colorscheme == "rose-pine-main" then
  mode_bg_blur = Highlight.tint(mode_bg, -0.25)
  session = Highlight.tint(Highlight.get("DiagnosticSignWarn", "fg"), 0.1)
  modenc_bg = Highlight.tint(Highlight.get("KeywordBlur", "bg"), 0.05)
  modenc_bg_blur = Highlight.tint(modenc_bg, -0.15)
end

if vim.g.colorscheme == "tokyonight-night" then
  session = Highlight.tint(Highlight.get("DiagnosticSignWarn", "fg"), 0.1)
  modenc_bg = Highlight.tint(Highlight.get("KeywordBlur", "bg"), 0.05)
  modenc_bg_blur = Highlight.tint(modenc_bg, -0.15)
end

if vim.g.colorscheme == "tokyonight-storm" then
  mode_bg_blur = Highlight.tint(mode_bg, -0.3)
  session = Highlight.tint(Highlight.get("DiagnosticSignWarn", "fg"), 0.1)
  modenc_bg = Highlight.tint(Highlight.get("KeywordBlur", "bg"), 0.1)
  modenc_bg_blur = Highlight.tint(modenc_bg, -0.1)
end

if vim.g.colorscheme == "vscode_modern" then
  mode_bg_blur = Highlight.tint(mode_bg, -0.3)
  directory = Highlight.tint(Highlight.get("Directory", "fg"), 0.2)
  session = Highlight.tint(Highlight.get("DiagnosticSignWarn", "fg"), 0.1)
  modenc_bg = Highlight.get("KeywordBlur", "bg")
  modenc_bg_blur = Highlight.tint(modenc_bg, -0.15)
end

if vim.g.colorscheme == "zenburned" then
  mode_bg_blur = Highlight.tint(mode_bg, -0.2)
  directory = Highlight.tint(Highlight.get("Directory", "fg"), 0.5)
  session = Highlight.tint(Highlight.get("DiagnosticSignWarn", "fg"), 0.1)
  modenc_bg = Highlight.get("KeywordBlur", "bg")
  modenc_bg_blur = Highlight.tint(modenc_bg, -0.08)
end

if vim.tbl_contains(vim.g.lightthemes, vim.g.colorscheme) then
  branch_fg = Highlight.tint(normal_fg, -1)

  modenc_bg = Highlight.tint(bg, -0.04)

  nc_bg = Highlight.tint(nc_bg, 0.08)
  disorent = Highlight.tint(bg, -0.3)
end

---@class r.utils.colortbl
local M = {
  statusline_fg = fg,
  statusline_bg = bg,

  statuslinenc_fg = nc_fg,
  statuslinenc_bg = nc_bg,

  branch_fg = branch_fg,
  path_name = path_name,
  filename = filename,

  mode_bg = mode_bg,
  mode_bg_blur = mode_bg_blur,
  modenc_bg = modenc_bg,
  modenc_bg_blur = modenc_bg_blur,

  keywordnc_fg = keywordnc_fg,

  modified_fg = Highlight.tint(error_fg, 0.3),

  disorent = disorent,
  session = session,
  notif = notif,

  error_fg = error_fg,

  mod_ins = error_fg,
  mode_ins_bar = Highlight.tint(error_fg, -0.4),
  mod_insnc = error_fgnc,
  mod_vis = Highlight.get("visual", "bg"),
  mod_term = Highlight.get("Boolean", "fg"),

  diff_add = Highlight.get("GitSignsAdd", "fg"),
  diff_change = Highlight.get("GitSignsChange", "fg"),
  diff_delete = Highlight.get("GitSignsDelete", "fg"),

  directory = directory,

  diagnostic_warn = Highlight.get("DiagnosticSignWarn", "fg"),
  diagnostic_err = Highlight.get("DiagnosticSignError", "fg"),
  diagnostic_info = Highlight.get("DiagnosticSignInfo", "fg"),
  diagnostic_hint = Highlight.get("DiagnosticSignHint", "fg"),
}
return M
