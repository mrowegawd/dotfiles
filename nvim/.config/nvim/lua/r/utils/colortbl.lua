local Highlight = require "r.settings.highlights"

local normal_bg_darker = Highlight.get("WinSeparator", "fg")
local normal_bg = Highlight.get("Normal", "bg")

local normal_fg = Highlight.tint(Highlight.get("Normal", "bg"), 4.5)

-- Color property statusline designed to draw attention when viewed
local normal_fg_white = "white"
-- Color property statusline designed to be ignored when viewed
local normal_fg_blur = Highlight.get("Comment", "fg")

local normal_winbar_fg = Highlight.tint(Highlight.get("LineNr", "fg"), 0.3)

local error_fg = Highlight.get("Error", "fg")

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

local session = Highlight.tint(Highlight.get("DiagnosticSignWarn", "fg"), -0.2)
local disorent = Highlight.tint(bg, 1)
local notif = Highlight.tint(Highlight.get("Function", "fg"), 0.2)
local directory = Highlight.tint(Highlight.get("Directory", "fg"), 0.1)
local modified_fg = Highlight.tint(error_fg, 0.3)

local mode_insert_bg = Highlight.tint(error_fg, -0.1)
local mode_insert_bg_blur = Highlight.tint(mode_insert_bg, -0.2)
local mode_insert_bar = Highlight.darken(mode_insert_bg, 0.45, normal_bg)

if vim.g.colorscheme == "lackluster" then
  normal_fg = Highlight.tint(Highlight.get("Normal", "bg"), 7)
  directory = Highlight.tint(Highlight.get("Directory", "fg"), 0.2)
  mode_insert_bg_blur = Highlight.tint(mode_insert_bg, -0.3)
  modenc_bg = Highlight.get("KeywordBlur", "bg")
end

if vim.g.colorscheme == "base2tone_cave_dark" then
  normal_fg = Highlight.tint(Highlight.get("Normal", "bg"), 4)
  mode_bg_blur = Highlight.tint(mode_bg, -0.45)
  session = Highlight.tint(Highlight.get("DiagnosticSignWarn", "fg"), 0.2)
end

if vim.g.colorscheme == "onedark" then
  normal_fg = Highlight.tint(Highlight.get("Normal", "bg"), 3)
end

if vim.g.colorscheme == "sunburn" then
  session = Highlight.tint(Highlight.get("DiagnosticSignWarn", "fg"), 0.2)
end

if vim.g.colorscheme == "jellybeans" then
  session = Highlight.tint(Highlight.get("DiagnosticSignWarn", "fg"), 0.2)
end

if vim.g.colorscheme == "seoul256" then
  normal_fg = Highlight.tint(Highlight.get("Normal", "bg"), 3.5)
  mode_bg_blur = Highlight.tint(mode_bg, -0.5)
end

if vim.g.colorscheme == "ashen" then
  mode_insert_bg_blur = Highlight.tint(mode_insert_bg, -0.2)
  session = Highlight.tint(Highlight.get("DiagnosticSignWarn", "fg"), -0.05)
end

if vim.g.colorscheme == "nord" then
  normal_fg = Highlight.tint(Highlight.get("Normal", "bg"), 3)
  mode_bg_blur = Highlight.tint(mode_bg, -0.25)
  mode_insert_bg_blur = Highlight.tint(mode_insert_bg, -0.15)
  modenc_bg = Highlight.tint(Highlight.get("KeywordBlur", "bg"), 0.1)
  modenc_bg_blur = Highlight.tint(modenc_bg, -0.1)
  session = Highlight.tint(Highlight.get("DiagnosticSignWarn", "fg"), 0.3)
end

if vim.g.colorscheme == "oxocarbon" then
  session = Highlight.tint(Highlight.get("DiagnosticSignWarn", "fg"), 0.3)
end

if vim.g.colorscheme == "horizon" then
  mode_bg_blur = Highlight.tint(mode_bg, -0.5)
  mode_insert_bg_blur = Highlight.tint(mode_insert_bg, -0.3)
  session = Highlight.tint(Highlight.get("DiagnosticSignWarn", "fg"), 0.1)
end

if vim.g.colorscheme == "rose-pine-main" then
  mode_bg_blur = Highlight.tint(mode_bg, -0.25)
  modenc_bg = Highlight.tint(Highlight.get("KeywordBlur", "bg"), 0.05)
  modenc_bg_blur = Highlight.tint(modenc_bg, -0.15)
  session = Highlight.tint(Highlight.get("DiagnosticSignWarn", "fg"), 0.1)
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
  normal_fg = Highlight.tint(Highlight.get("Normal", "bg"), 4)
  directory = Highlight.tint(Highlight.get("Directory", "fg"), 0.2)
  mode_bg_blur = Highlight.tint(mode_bg, -0.3)
  modenc_bg = Highlight.get("KeywordBlur", "bg")
  modenc_bg_blur = Highlight.tint(modenc_bg, -0.15)
  session = Highlight.tint(Highlight.get("DiagnosticSignWarn", "fg"), 0.1)
end

if vim.g.colorscheme == "catppuccin-mocha" then
  mode_bg_blur = Highlight.tint(mode_bg, -0.43)
  session = Highlight.tint(Highlight.get("DiagnosticSignWarn", "fg"), 0.2)
end

if vim.g.colorscheme == "zenburned" then
  normal_fg = Highlight.tint(Highlight.get("Normal", "bg"), 2)
  mode_bg_blur = Highlight.tint(mode_bg, -0.2)
  mode_insert_bg_blur = Highlight.tint(mode_insert_bg, -0.12)
  directory = Highlight.tint(Highlight.get("Directory", "fg"), 0.5)
  session = Highlight.tint(Highlight.get("DiagnosticSignWarn", "fg"), 0.1)
  modenc_bg = Highlight.get("KeywordBlur", "bg")
  modenc_bg_blur = Highlight.tint(modenc_bg, -0.08)
  modified_fg = Highlight.tint(error_fg, -0.4)
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

  normal_bg = normal_bg,
  normal_bg_darker = normal_bg_darker,
  normal_fg = normal_fg,
  normal_fg_blur = normal_fg_blur,
  normal_fg_white = normal_fg_white,

  normal_winbar_fg = normal_winbar_fg,

  branch_fg = branch_fg,
  path_name = path_name,
  filename = filename,

  mode_bg = mode_bg,
  mode_bg_blur = mode_bg_blur,
  modenc_bg = modenc_bg,
  modenc_bg_blur = modenc_bg_blur,

  modified_fg = modified_fg,

  disorent = disorent,
  session = session,
  notif = notif,

  error_fg = error_fg,

  mode_insert_bg = mode_insert_bg,
  mode_insert_bg_blur = mode_insert_bg_blur,
  mode_insert_bar = mode_insert_bar,
  mode_term_bg = Highlight.get("Boolean", "fg"),
  mode_visual_bg = Highlight.get("visual", "bg"),

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
