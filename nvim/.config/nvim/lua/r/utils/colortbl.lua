local Highlight = require "r.settings.highlights"

local normal_bg = Highlight.get("Normal", "bg")

-- Color property statusline designed to be ignored when viewed
local normal_fg_blur = Highlight.get("Comment", "fg")

local normal_winbar_active_fg = Highlight.tint(Highlight.get("LineNr", "fg"), 0.3)
local normal_winbar_fg = Highlight.get("LineNr", "fg")

local error_fg = Highlight.get("KeywordMatch", "fg")

-- Statusline
local fg = Highlight.get("StatusLine", "fg")
local bg = Highlight.get("StatusLine", "bg")

local mode_bg = Highlight.get("Keyword", "fg")
local modenc_bg = Highlight.get("KeywordBlur", "bg")
local modenc_bg_blur = Highlight.tint(modenc_bg, -0.18)

local normal_fg_white = Highlight.tint(Highlight.get("StatusLine", "fg"), 3)

local filepath = Highlight.tint(Highlight.get("StatusLine", "fg"), 0.6)
local filepath_winbar_active_fg_filename = Highlight.tint(Highlight.get("StatusLine", "fg"), 0.8)
local filepath_winbar_active_fg = Highlight.tint(Highlight.get("LineNr", "fg"), 1)
local filepath_winbar_fg = Highlight.tint(Highlight.get("LineNr", "fg"), 0.2)

local branch_fg = Highlight.tint(Highlight.get("GitSignsAdd", "fg"), 0.2)

local session = Highlight.tint(Highlight.get("DiagnosticSignWarn", "fg"), -0.2)
local disorent = Highlight.tint(bg, 1)
local notif = Highlight.tint(Highlight.get("Function", "fg"), 0.2)
local directory = Highlight.tint(Highlight.get("Directory", "fg"), 0.1)
local modified_fg = Highlight.tint(error_fg, 0.3)

local mode_insert_bg = Highlight.tint(error_fg, -0.1)

if vim.g.colorscheme == "lackluster" then
  directory = Highlight.tint(Highlight.get("Directory", "fg"), 0.2)
  modenc_bg = Highlight.get("KeywordBlur", "bg")
end

if vim.g.colorscheme == "rose-pine-dawn" then
  branch_fg = Highlight.tint(Highlight.get("GitSignsAdd", "fg"), 0.1)
  fg = Highlight.tint(Highlight.get("StatusLine", "fg"), 0.19)
  filepath = Highlight.tint(Highlight.get("StatusLine", "fg"), -0.4)
  filepath_winbar_active_fg = Highlight.tint(Highlight.get("LineNr", "fg"), -0.2)
  filepath_winbar_active_fg_filename = Highlight.tint(Highlight.get("LineNr", "fg"), -0.5)
  filepath_winbar_fg = Highlight.tint(Highlight.get("LineNr", "fg"), -0.05)
  session = Highlight.tint(Highlight.get("DiagnosticSignWarn", "fg"), 0.2)
  normal_fg_white = Highlight.tint(Highlight.get("StatusLine", "fg"), -0.4)
end

if
  vim.tbl_contains({
    "base46-aylin",
    "base46-chocolate",
    "base46-default-dark",
    "base46-doomchad",
    "base46-jabuti",
    "base46-kanagawa",
    "base46-material-darker",
    "base46-onenord",
    "base46-seoul256_dark",
    "base46-zenburn",
  }, vim.g.colorscheme)
then
  filepath = Highlight.tint(Highlight.get("StatusLine", "fg"), 0.8)
end

if vim.g.colorscheme == "base46-jabuti" then
  normal_winbar_active_fg = Highlight.tint(Highlight.get("LineNr", "fg"), 0.15)
end

if vim.g.colorscheme == "base46-seoul256_dark" then
  filepath_winbar_active_fg = Highlight.tint(Highlight.get("LineNr", "fg"), 0.4)
end

if vim.g.colorscheme == "base46-zenburn" then
  filepath_winbar_active_fg = Highlight.tint(Highlight.get("LineNr", "fg"), 0.7)
end

if vim.g.colorscheme == "base46-doomchad" then
  normal_winbar_active_fg = Highlight.tint(Highlight.get("LineNr", "fg"), 0.15)
end

if vim.g.colorscheme == "base46-chocolate" then
  filepath = Highlight.tint(Highlight.get("StatusLine", "fg"), 1.3)
  normal_winbar_active_fg = Highlight.tint(Highlight.get("LineNr", "fg"), 0.15)
end

if vim.g.colorscheme == "jellybeans" then
  session = Highlight.tint(Highlight.get("DiagnosticSignWarn", "fg"), 0.2)
  filepath = Highlight.tint(Highlight.get("StatusLine", "fg"), 0.8)
end

if vim.g.colorscheme == "ashen" then
  session = Highlight.tint(Highlight.get("DiagnosticSignWarn", "fg"), -0.05)
  filepath_winbar_fg = Highlight.tint(Highlight.get("LineNr", "fg"), 0.3)
  filepath = Highlight.tint(Highlight.get("StatusLine", "fg"), 0.8)
end

if vim.g.colorscheme == "nord" then
  modenc_bg = Highlight.tint(Highlight.get("KeywordBlur", "bg"), 0.1)
  modenc_bg_blur = Highlight.tint(modenc_bg, -0.1)
  filepath_winbar_active_fg = Highlight.tint(Highlight.get("LineNr", "fg"), 0.8)
  fg = Highlight.tint(Highlight.get("StatusLine", "fg"), 0.1)
  session = Highlight.tint(Highlight.get("DiagnosticSignWarn", "fg"), 0.3)
end

if vim.g.colorscheme == "tokyonight-night" then
  session = Highlight.tint(Highlight.get("DiagnosticSignWarn", "fg"), 0.1)
  modenc_bg = Highlight.tint(Highlight.get("KeywordBlur", "bg"), 0.05)
  modenc_bg_blur = Highlight.tint(modenc_bg, -0.15)
end

if vim.g.colorscheme == "tokyonight-storm" then
  session = Highlight.tint(Highlight.get("DiagnosticSignWarn", "fg"), 0.1)
  modenc_bg = Highlight.tint(Highlight.get("KeywordBlur", "bg"), 0.1)
  modenc_bg_blur = Highlight.tint(modenc_bg, -0.1)
end

if vim.g.colorscheme == "vscode_modern" then
  directory = Highlight.tint(Highlight.get("Directory", "fg"), 0.2)
  modenc_bg = Highlight.get("KeywordBlur", "bg")
  modenc_bg_blur = Highlight.tint(modenc_bg, -0.15)
  session = Highlight.tint(Highlight.get("DiagnosticSignWarn", "fg"), 0.1)
  filepath = Highlight.tint(Highlight.get("StatusLine", "fg"), 1)
end

---@class r.utils.colortbl
local M = {
  statusline_fg = fg,
  statusline_bg = bg,

  normal_bg = normal_bg,
  normal_fg_blur = normal_fg_blur,
  normal_fg_white = normal_fg_white,

  normal_winbar_active_fg = normal_winbar_active_fg,
  normal_winbar_fg = normal_winbar_fg,

  branch_fg = branch_fg,

  filepath = filepath,
  filepath_winbar_active_fg = filepath_winbar_active_fg,
  filepath_winbar_active_fg_filename = filepath_winbar_active_fg_filename,
  filepath_winbar_fg = filepath_winbar_fg,

  mode_bg = mode_bg,
  modenc_bg = modenc_bg,
  modenc_bg_blur = modenc_bg_blur,

  modified_fg = modified_fg,

  disorent = disorent,
  session = session,
  notif = notif,

  error_fg = error_fg,

  mode_insert_bg = mode_insert_bg,
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
