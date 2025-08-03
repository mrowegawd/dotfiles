local UIPallette = require("r.utils").uisec

local H = require "r.settings.highlights"

local dark_green = H.tint(UIPallette.palette.green, 0.3)
local dark_yellow = H.tint(UIPallette.palette.bright_yellow, 0.3)
local dark_red = H.tint(UIPallette.palette.dark_red, 0.3)

local base_cl = {
  Directory = { fg = { from = "Directory", attr = "fg" }, bg = "NONE" },
  CurSearch = {
    fg = { from = "Dark_yellow", attr = "fg", alter = -1 },
    bg = { from = "Dark_yellow", attr = "fg", alter = 0.15 },
    bold = true,
  },
  Search = {
    fg = { from = "CurSearch", attr = "fg", alter = -0.15 },
    bg = { from = "CurSearch", attr = "bg", alter = -0.35 },
    bold = false,
  },
  blink_cmp_label_match_fg_alter = 0.8,
  cmpdocnormal_fg_alter = 0.3,
  comment_fg_alter = 0.65,
  cursor_fg = "#c7063c",
  cursorline_alter = 0.04,
  cursorline_fg_alter = "Keyword",
  dapstopped_bg_alter = 0.25,
  float_border_fg_alter = 0,
  float_title_bg_alter = -0.3,
  float_title_fg_alter = -0.1,
  fzflua_buf_linenr_bg_alter = 0.5,
  fzflua_cursorline_bg_alter = -0.05,
  fzflua_dir_part_fg = 1,
  fzflua_file_part_fg = -0.1,
  fzflua_headertext_fg_alter = -0.45,
  fzflua_normal_bg_alter = 0,
  fzflua_sel_bg_alter = -0.02,
  linenr_fg_alter = 0.06,
  lsp_reference_read_bg_alter = { from = "LspReferenceRead", attr = "bg", alter = -0.2 },
  lsp_reference_text_bg_alter = { from = "LspReferenceText", attr = "bg" },
  lsp_reference_write_bg_alter = { from = "LspReferenceWrite", attr = "bg", alter = -0.2 },
  my_code_usage_bg_alter = -0.5,
  my_code_usage_fg_alter = 0.1,
  nontext_fg_alter = 1.5,
  normal_float_bg_alter = 0,
  normal_float_fg_alter = -0.01,
  pmenu_bg_alter = 0.55,
  pmenu_fg_alter = -0.1,
  pmenu_sel_bg_alter = 0.2,
  quickfixline_alter = 0.7,
  noice_cmdline_fg_alter = 1.6,
  quickfixline_linenr_fg_alter = 0.6,
  snacks_indent_scope_fg_alter = 0.2,
  statusline_bg_alter = 0.18,
  statusline_fg_alter = 1,
  tabline_bg_alter = 0.42,
  tabline_fg_alter = 0.8,
  trouble_indent_fg_alter = 0.9,
  visual_bg_alter = -0.1,
  winseparator_alter = 0.8,

  fold_fg = 0.5,
  fold_bg = -0.05,

  render_markdown_code_bg_alter = 0.25,
  code_block_fg_alter = 0.12, -- for Org file (better to leave it as is)
  render_markdown_code_inline_fg_alter = 0.1,
  render_markdown_code_inline_bg_alter = 0.12,

  snacks_notifier_info_fg_info = 2,
  snacks_notifier_border_info_fg_info = 1.1,
  snacks_notifier_title_info_fg_info = 0.3,

  snacks_notifier_warn_fg_info = 1,
  snacks_notifier_border_warn_fg_info = 0.3,

  snacks_notifier_error_fg_info = 0.5,
  snacks_notifier_border_error_fg_info = 0.3,
}

local function reset_base_alter(themes, alter_base)
  for _, theme in pairs(themes) do
    if theme == RUtils.config.colorscheme then
      for key_alter, val_alter in pairs(alter_base) do
        for key, _ in pairs(base_cl) do
          if key == key_alter then
            base_cl[key] = val_alter
          end
        end
      end
    end
  end

  local variable_map = {
    CurSearch = "CurSearch",
    Directory = "Directory",
    Search = "Search",
    blink_cmp_label_match_fg_alter = "blink_cmp_label_match_fg_alter",
    cmpdocnormal_fg_alter = "cmpdocnormal_fg_alter",
    comment_fg_alter = "comment_fg_alter",
    cursor_fg = "cursor_fg",
    cursorline_alter = "cursorline_alter",
    cursorline_fg_alter = "cursorline_fg_alter",
    dapstopped_bg_alter = "dapstopped_bg_alter",
    float_border_fg_alter = "float_border_fg_alter",
    float_title_bg_alter = "float_title_bg_alter",
    float_title_fg_alter = "float_title_fg_alter",
    fold_bg = "fold_bg",
    fold_fg = "fold_fg",
    fzflua_buf_linenr_bg_alter = "fzflua_buf_linenr_bg_alter",
    fzflua_cursorline_bg_alter = "fzflua_cursorline_bg_alter",
    fzflua_dir_part_fg = "fzflua_dir_part_fg",
    fzflua_file_part_fg = "fzflua_file_part_fg",
    fzflua_headertext_fg_alter = "fzflua_headertext_fg_alter",
    fzflua_normal_bg_alter = "fzflua_normal_bg_alter",
    fzflua_sel_bg_alter = "fzflua_sel_bg_alter",
    linenr_fg_alter = "linenr_fg_alter",
    lsp_reference_read_bg_alter = "lsp_reference_read_bg_alter",
    lsp_reference_text_bg_alter = "lsp_reference_text_bg_alter",
    lsp_reference_write_bg_alter = "lsp_reference_write_bg_alter",
    my_code_usage_bg_alter = "my_code_usage_bg_alter",
    my_code_usage_fg_alter = "my_code_usage_fg_alter",
    noice_cmdline_fg_alter = "noice_cmdline_fg_alter",
    nontext_fg_alter = "nontext_fg_alter",
    normal_float_bg_alter = "normal_float_bg_alter",
    normal_float_fg_alter = "normal_float_fg_alter",
    pmenu_bg_alter = "pmenu_bg_alter",
    pmenu_fg_alter = "pmenu_fg_alter",
    pmenu_sel_bg_alter = "pmenu_sel_bg_alter",
    quickfixline_alter = "quickfixline_alter",
    quickfixline_linenr_fg_alter = "quickfixline_linenr_fg_alter",
    snacks_indent_scope_fg_alter = "snacks_indent_scope_fg_alter",
    statusline_bg_alter = "statusline_bg_alter",
    statusline_fg_alter = "statusline_fg_alter",
    tabline_bg_alter = "tabline_bg_alter",
    tabline_fg_alter = "tabline_fg_alter",
    trouble_indent_fg_alter = "trouble_indent_fg_alter",
    visual_bg_alter = "visual_bg_alter",
    winseparator_alter = "winseparator_alter",

    render_markdown_code_bg_alter = "render_markdown_code_bg_alter",
    code_block_fg_alter = "code_block_fg_alter",
    render_markdown_code_inline_fg_alter = "render_markdown_code_inline_fg_alter",
    render_markdown_code_inline_bg_alter = "render_markdown_code_inline_bg_alter",

    snacks_notifier_info_fg_info = "snacks_notifier_info_fg_info",
    snacks_notifier_border_info_fg_info = "snacks_notifier_border_info_fg_info",
    snacks_notifier_title_info_fg_info = "snacks_notifier_title_info_fg_info",

    snacks_notifier_warn_fg_info = "snacks_notifier_warn_fg_info",
    snacks_notifier_border_warn_fg_info = "snacks_notifier_border_warn_fg_info",

    snacks_notifier_error_fg_info = "snacks_notifier_error_fg_info",
    snacks_notifier_border_error_fg_info = "snacks_notifier_border_error_fg_info",
  }

  for key, var_name in pairs(variable_map) do
    _G[var_name] = base_cl[key]
  end
end

reset_base_alter({ "ashen" }, {
  code_block_fg_alter = 0.4,
  cursor_fg = "#b4b4b4",
  cursorline_alter = 0.1,
  fzflua_headertext_fg_alter = -0.6,
  lsp_reference_read_bg_alter = { from = "Normal", attr = "bg", alter = 0.4 },
  lsp_reference_text_bg_alter = { from = "LspReferenceText", attr = "bg", alter = 0.1 },
  lsp_reference_write_bg_alter = { from = "LspReferenceWrite", attr = "bg", alter = 0.1 },
  my_code_usage_bg_alter = -0.4,
  my_code_usage_fg_alter = 0.01,
  noice_cmdline_fg_alter = 1.8,
  nontext_fg_alter = 3.2,
  pmenu_bg_alter = 2,
  quickfixline_linenr_fg_alter = 1,
  render_markdown_code_bg_alter = 1.2,
  render_markdown_code_inline_bg_alter = 0.15,
  render_markdown_code_inline_fg_alter = 0.05,
  statusline_bg_alter = 1.1,
  tabline_bg_alter = 0.3,
  tabline_fg_alter = 0.8,
  statusline_fg_alter = 2.8,
  trouble_indent_fg_alter = 2,
  winseparator_alter = 1.4,
})
reset_base_alter({ "base46-aylin" }, {
  cmpdocnormal_fg_alter = 0.1,
  cursor_fg = "#b3276f",
  cursorline_alter = 0.06,
  winseparator_alter = 0.35,
})
reset_base_alter({ "base46-catppuccin" }, {
  cursor_fg = "#c7063c",
  cursorline_alter = 0.06,
  dapstopped_bg_alter = 0.2,
  my_code_usage_bg_alter = -0.7,
  my_code_usage_fg_alter = -0.35,
  render_markdown_code_bg_alter = 0.3,
  statusline_bg_alter = 0.2,
  statusline_fg_alter = 1.56,
  visual_bg_alter = -0.3,
  winseparator_alter = 0.5,
})
reset_base_alter({ "base46-chocolate" }, {
  cursor_fg = "#c8bAA4",
  cursorline_alter = 0.11,
  my_code_usage_bg_alter = -0.63,
  my_code_usage_fg_alter = -0.28,
  trouble_indent_fg_alter = 0.7,
  winseparator_alter = 0.38,

  render_markdown_code_bg_alter = 0.28,
})
reset_base_alter({ "base46-doomchad" }, {
  cursor_fg = "#81A1C1",
  cursorline_alter = 0.35,
  cursorline_fg_alter = "WinSeparator",
  dapstopped_bg_alter = 0.2,
  fzflua_dir_part_fg = 0.7,
  fzflua_headertext_fg_alter = -0.35,
  my_code_usage_bg_alter = -0.6,
  my_code_usage_fg_alter = -0.32,
  nontext_fg_alter = 1,
  pmenu_bg_alter = 0.4,
  render_markdown_code_bg_alter = 0.2,
  tabline_bg_alter = 0.25,
  tabline_fg_alter = 0.4,
  trouble_indent_fg_alter = 0.5,
  winseparator_alter = 0.2,
})
reset_base_alter({ "base46-everforest" }, {
  cursor_fg = "#e69875",
  cursorline_alter = 0.35,
  cursorline_fg_alter = "WinSeparator",
  fzflua_dir_part_fg = 0.7,
  my_code_usage_fg_alter = -0.35,
  noice_cmdline_fg_alter = 1.3,
  nontext_fg_alter = 1,
  pmenu_bg_alter = 0.25,
  quickfixline_alter = 0.4,
  render_markdown_code_bg_alter = 0.13,
  snacks_indent_scope_fg_alter = 0.15,
  tabline_bg_alter = 0.15,
  tabline_fg_alter = 0.5,
  trouble_indent_fg_alter = 0.4,
  winseparator_alter = 0.15,
})
reset_base_alter({ "base46-gruvchad" }, {
  cmpdocnormal_fg_alter = 0.1,
  cursor_fg = "#dfdfe0",
  cursorline_alter = 0.1,
  dapstopped_bg_alter = 0.2,
  nontext_fg_alter = 1.25,
  render_markdown_code_bg_alter = 0.35,
  statusline_bg_alter = 0.2,
  statusline_fg_alter = 1.3,
  winseparator_alter = 0.4,
})
reset_base_alter({ "base46-horizon" }, {
  cursor_fg = "#b3276f",
  cursorline_alter = 0.4,
  cursorline_fg_alter = "WinSeparator",
  dapstopped_bg_alter = 0.2,
  noice_cmdline_fg_alter = 0.7,
  nontext_fg_alter = 1.9,
  render_markdown_code_bg_alter = 0.35,
  statusline_bg_alter = 0.35,
  statusline_fg_alter = 1.5,
  tabline_bg_alter = 0.4,
  tabline_fg_alter = 0.9,
  trouble_indent_fg_alter = 1.2,
  winseparator_alter = 0.5,
})
reset_base_alter({ "base46-jabuti" }, {
  comment_fg_alter = 0.45,
  cursor_fg = "#c0cbe3",
  cursorline_alter = 0.07,
  fzflua_headertext_fg_alter = -0.45,
  noice_cmdline_fg_alter = 0.6,
  nontext_fg_alter = 1.25,
  pmenu_bg_alter = 0.32,
  quickfixline_alter = 0.5,
  render_markdown_code_bg_alter = 0.18,
  statusline_bg_alter = 0.17,
  statusline_fg_alter = 1,
  tabline_bg_alter = 0.16,
  tabline_fg_alter = 0.5,
  trouble_indent_fg_alter = 0.6,
  winseparator_alter = 0.25,
})
reset_base_alter({ "base46-jellybeans" }, {
  cursor_fg = "#ffa560",
  cursorline_alter = 0.85,
  cursorline_fg_alter = "WinSeparator",
  dapstopped_bg_alter = 0.2,
  my_code_usage_bg_alter = -0.72,
  my_code_usage_fg_alter = -0.4,
  noice_cmdline_fg_alter = 0.6,
  nontext_fg_alter = 2.5,
  pmenu_bg_alter = 1.3,
  render_markdown_code_bg_alter = 0.9,
  render_markdown_code_inline_bg_alter = 0.15,
  render_markdown_code_inline_fg_alter = 0.05,
  statusline_bg_alter = 0.8,
  statusline_fg_alter = 2.2,
  tabline_bg_alter = 0.3,
  tabline_fg_alter = 0.65,
  trouble_indent_fg_alter = 1.5,
  winseparator_alter = 1,

  -- {
  --   ["@markup.quote.markdown"] = {
  --     fg = { from = "@markup.quote.markdown", attr = "fg", alter = -0.1 },
  --     bg = { from = "@markup.quote.markdown", attr = "bg", alter = 0.05 },
  --   },
  -- },
})
reset_base_alter({ "base46-kanagawa" }, {
  cmpdocnormal_fg_alter = 0.1,
  cursor_fg = "#b3276f",
  cursorline_alter = 0.75,
  cursorline_fg_alter = "WinSeparator",
  dapstopped_bg_alter = 0.2,
  noice_cmdline_fg_alter = 0.6,
  nontext_fg_alter = 1.8,
  pmenu_bg_alter = 0.65,
  render_markdown_code_bg_alter = 0.38,
  render_markdown_code_inline_bg_alter = 0.2,
  snacks_indent_scope_fg_alter = 0.22,
  statusline_bg_alter = 0.35,
  statusline_fg_alter = 1.6,
  tabline_bg_alter = 0.25,
  tabline_fg_alter = 0.68,
  trouble_indent_fg_alter = 1,
  winseparator_alter = 0.51,
})
reset_base_alter({ "base46-material-darker" }, {
  comment_fg_alter = 0.6,
  cursor_fg = "#16afca",
  cursorline_alter = 0.07,
  dapstopped_bg_alter = 0.2,
  fzflua_cursorline_bg_alter = -0.1,
  noice_cmdline_fg_alter = 0.6,
  render_markdown_code_bg_alter = 0.3,
  render_markdown_code_inline_bg_alter = 0.15,
  statusline_bg_alter = 0.25,
  statusline_fg_alter = 1.4,
  tabline_bg_alter = 0.25,
  tabline_fg_alter = 0.68,
  visual_bg_alter = -0.2,
  winseparator_alter = 0.4,
})
reset_base_alter({ "base46-material-lighter" }, {
  CurSearch = {
    fg = { from = "Dark_red", attr = "fg", alter = 1 },
    bg = { from = "Dark_red", attr = "fg", alter = -0.1 },
    bold = true,
  },
  Search = {
    fg = { from = "CurSearch", attr = "fg", alter = 0.15 },
    bg = { from = "CurSearch", attr = "bg", alter = -0.15 },
    bold = false,
  },
  blink_cmp_label_match_fg_alter = 0.6,
  cmpdocnormal_fg_alter = 0.1,
  comment_fg_alter = -0.19,
  cursor_fg = "#dfdfe0",
  cursorline_alter = -0.12,
  dapstopped_bg_alter = 0.2,
  float_border_fg_alter = -0.15,
  fzflua_cursorline_bg_alter = 0.08,
  fzflua_dir_part_fg = 0.1,
  fzflua_file_part_fg = -0.4,
  fzflua_headertext_fg_alter = -0.2,
  fzflua_sel_bg_alter = 0.01,
  linenr_fg_alter = -0.04,
  lsp_reference_read_bg_alter = { from = "LspReferenceRead", attr = "bg", alter = 0.26 },
  lsp_reference_text_bg_alter = { from = "LspReferenceText", attr = "bg" },
  lsp_reference_write_bg_alter = { from = "LspReferenceWrite", attr = "bg", alter = 0.26 },
  my_code_usage_bg_alter = 3.5,
  my_code_usage_fg_alter = 0.7,
  nontext_fg_alter = -0.45,
  pmenu_fg_alter = -0.2,
  pmenu_sel_bg_alter = -0.05,
  quickfixline_alter = -0.1,
  snacks_indent_scope_fg_alter = 0.7,
  trouble_indent_fg_alter = 0.5,
  winseparator_alter = -0.16,
})
reset_base_alter({ "base46-melange" }, {
  cursor_fg = "#ece1d7",
  cursorline_alter = 0.05,
  dapstopped_bg_alter = 0.15,
  my_code_usage_bg_alter = -0.68,
  my_code_usage_fg_alter = -0.38,
  noice_cmdline_fg_alter = 0.6,
  pmenu_bg_alter = 0.3,
  quickfixline_alter = 0.5,
  render_markdown_code_bg_alter = 0.23,
  statusline_bg_alter = 0.2,
  statusline_fg_alter = 1,
  tabline_bg_alter = 0.18,
  tabline_fg_alter = 0.4,
  trouble_indent_fg_alter = 0.7,
  winseparator_alter = 0.32,
})
reset_base_alter({ "base46-onenord" }, {
  cmpdocnormal_fg_alter = 0.3,
  cursor_fg = "#3879C5",
  cursorline_alter = 0.07,
  dapstopped_bg_alter = 0.2,
  fzflua_dir_part_fg = 0.75,
  fzflua_file_part_fg = 0.02,
  fzflua_headertext_fg_alter = -0.35,
  my_code_usage_bg_alter = -0.62,
  my_code_usage_fg_alter = -0.38,
  noice_cmdline_fg_alter = 0.4,
  nontext_fg_alter = 1.2,
  pmenu_bg_alter = 0.25,
  quickfixline_alter = 0.5,
  render_markdown_code_bg_alter = 0.14,
  statusline_bg_alter = 0.1,
  statusline_fg_alter = 0.76,
  tabline_bg_alter = 0.16,
  tabline_fg_alter = 0.45,
  trouble_indent_fg_alter = 0.4,
  winseparator_alter = 0.17,
})
reset_base_alter({ "base46-oxocarbon" }, {
  comment_fg_alter = 0.9,
  cursor_fg = "#ffffff",
  cursorline_alter = 0.5,
  cursorline_fg_alter = "WinSeparator",
  dapstopped_bg_alter = 0.2,
  fzflua_cursorline_bg_alter = -0.1,
  my_code_usage_bg_alter = -0.72,
  my_code_usage_fg_alter = -0.4,
  noice_cmdline_fg_alter = 0.4,
  nontext_fg_alter = 2.7,
  pmenu_bg_alter = 1.4,
  quickfixline_alter = 1.4,
  quickfixline_linenr_fg_alter = 0.4,
  render_markdown_code_bg_alter = 0.85,
  render_markdown_code_inline_bg_alter = 0.16,
  statusline_bg_alter = 0.75,
  statusline_fg_alter = 2.2,
  tabline_bg_alter = 0.27,
  tabline_fg_alter = 0.6,
  trouble_indent_fg_alter = 1.65,
  winseparator_alter = 0.92,
  --   ["@markup.quote.markdown"] = {
  --     inherit = "@markup.quote.markdown",
  --     fg = { from = "@markup.quote.markdown", attr = "fg", alter = -0.05 },
  --     bg = { from = "@markup.quote.markdown", attr = "bg", alter = 0.1 },
  --   },
  -- },
})
reset_base_alter({ "base46-rosepine" }, {
  comment_fg_alter = 0.7,
  cursor_fg = "#e0def4",
  cursorline_alter = 0.8,
  cursorline_fg_alter = "WinSeparator",
  dapstopped_bg_alter = 0.2,
  noice_cmdline_fg_alter = 0.6,
  nontext_fg_alter = 2.2,
  pmenu_bg_alter = 0.7,
  quickfixline_alter = 1,
  render_markdown_code_bg_alter = 0.55,
  statusline_bg_alter = 0.5,
  statusline_fg_alter = 2.2,
  tabline_bg_alter = 0.3,
  tabline_fg_alter = 0.7,
  trouble_indent_fg_alter = 1.4,
  visual_bg_alter = 0.2,
  winseparator_alter = 0.7,
  -- {
  --   ["@markup.quote.markdown"] = {
  --     inherit = "@markup.quote.markdown",
  --     fg = { from = "@markup.quote.markdown", attr = "fg", alter = -0.05 },
  --     bg = { from = "@markup.quote.markdown", attr = "bg", alter = 0.1 },
  --   },
  -- },
})
reset_base_alter({ "base46-seoul256_dark" }, {
  comment_fg_alter = 0.4,
  cursor_fg = "#d75f87",
  cursorline_alter = 0.03,
  dapstopped_bg_alter = 0.2,
  fold_bg = -0.026,
  fold_fg = 0.32,
  fzflua_cursorline_bg_alter = -0.06,
  fzflua_dir_part_fg = 0.6,
  fzflua_file_part_fg = 0.1,
  fzflua_headertext_fg_alter = -0.3,
  linenr_fg_alter = 0.05,
  my_code_usage_bg_alter = -0.1,
  my_code_usage_fg_alter = -0.37,
  noice_cmdline_fg_alter = 0.4,
  nontext_fg_alter = 0.8,
  pmenu_bg_alter = 0.15,
  pmenu_sel_bg_alter = 0.1,
  quickfixline_alter = 0.15,
  render_markdown_code_bg_alter = 0.02,
  render_markdown_code_inline_bg_alter = 0.04,
  statusline_bg_alter = 0.06,
  statusline_fg_alter = 0.76,
  tabline_bg_alter = 0.04,
  tabline_fg_alter = 0.45,
  trouble_indent_fg_alter = 0.2,
  winseparator_alter = 0.07,

  snacks_notifier_info_fg_info = 1,
  snacks_notifier_border_info_fg_info = 0.5,
  snacks_notifier_title_info_fg_info = 0.3,

  snacks_notifier_warn_fg_info = 1,
  snacks_notifier_border_warn_fg_info = -0.05,

  snacks_notifier_error_fg_info = 0.5,
  snacks_notifier_border_error_fg_info = -0.05,
})
reset_base_alter({ "base46-solarized_dark" }, {
  cursor_fg = "#708284",
  cursorline_alter = 0.07,
  dapstopped_bg_alter = 0.2,
  fold_fg = 0.6,
  fzflua_cursorline_bg_alter = -0.08,
  fzflua_dir_part_fg = 0.75,
  fzflua_headertext_fg_alter = -0.28,
  my_code_usage_bg_alter = -0.62,
  my_code_usage_fg_alter = -0.35,
  noice_cmdline_fg_alter = 0.6,
  pmenu_bg_alter = 0.4,
  render_markdown_code_bg_alter = 0.12,
  snacks_indent_scope_fg_alter = 0.12,
  statusline_bg_alter = 0.1,
  statusline_fg_alter = 1.2,
  tabline_bg_alter = 0.25,
  tabline_fg_alter = 0.6,
  trouble_indent_fg_alter = 0.6,
  winseparator_alter = 0.22,
})
reset_base_alter({ "base46-vscode_dark" }, {
  cmpdocnormal_fg_alter = 0.1,
  cursor_fg = "#dfdfe0",
  cursorline_alter = 0.12,
  dapstopped_bg_alter = 0.2,
  fold_fg = 0.6,
  noice_cmdline_fg_alter = 0.6,
  nontext_fg_alter = 1.8,
  pmenu_bg_alter = 0.65,
  render_markdown_code_bg_alter = 0.38,
  statusline_bg_alter = 0.32,
  statusline_fg_alter = 1.5,
  tabline_bg_alter = 0.25,
  winseparator_alter = 0.52,
})
reset_base_alter({ "base46-wombat" }, {
  cursor_fg = "#bbbbbb",
  cursorline_alter = 0.52,
  cursorline_fg_alter = "WinSeparator",
  dapstopped_bg_alter = 0.15,
  noice_cmdline_fg_alter = 0.6,
  render_markdown_code_bg_alter = 0.4,
  statusline_bg_alter = 0.3,
  statusline_fg_alter = 1.3,
  tabline_bg_alter = 0.25,
  tabline_fg_alter = 0.6,
  visual_bg_alter = -0.15,
  winseparator_alter = 0.45,
})
reset_base_alter({ "base46-zenburn" }, {
  comment_fg_alter = 0.45,
  cursor_fg = "#f3eadb",
  cursorline_alter = 0.02,
  dapstopped_bg_alter = 0.15,
  fzflua_cursorline_bg_alter = -0.12,
  fzflua_dir_part_fg = 0.6,
  fzflua_headertext_fg_alter = -0.35,
  my_code_usage_bg_alter = -0.58,
  my_code_usage_fg_alter = -0.35,
  noice_cmdline_fg_alter = 0.3,
  nontext_fg_alter = 0.8,
  pmenu_bg_alter = 0.2,
  quickfixline_alter = 0.2,
  render_markdown_code_bg_alter = 0.07,
  render_markdown_code_inline_bg_alter = 0.04,
  snacks_indent_scope_fg_alter = 0.11,
  statusline_bg_alter = 0.06,
  statusline_fg_alter = 0.8,
  tabline_bg_alter = 0.1,
  tabline_fg_alter = 0.45,
  trouble_indent_fg_alter = 0.2,
  fold_fg = 0.35,
  winseparator_alter = 0.1,

  snacks_notifier_info_fg_info = 1,
  snacks_notifier_border_info_fg_info = 0.5,
  snacks_notifier_title_info_fg_info = 0.3,

  snacks_notifier_warn_fg_info = 1,
  snacks_notifier_border_warn_fg_info = -0.05,

  snacks_notifier_error_fg_info = 0.5,
  snacks_notifier_border_error_fg_info = -0.05,
})
reset_base_alter({ "lackluster" }, {
  Directory = { fg = "#7788aa", bg = "NONE" },
  cursor_fg = "#deeeed",
  cursorline_alter = 0.27,
  fzflua_dir_part_fg = 0.72,
  fzflua_file_part_fg = 0.25,
  fzflua_headertext_fg_alter = -0.28,
  lsp_reference_read_bg_alter = { from = "Function", attr = "fg", alter = -0.6 },
  lsp_reference_text_bg_alter = { from = "Normal", attr = "bg", alter = 1.2 },
  lsp_reference_write_bg_alter = { from = "Function", attr = "fg", alter = -0.6 },
  my_code_usage_bg_alter = -0.5,
  my_code_usage_fg_alter = -0.1,
  nontext_fg_alter = 3.5,
  pmenu_bg_alter = 2,
  trouble_indent_fg_alter = 2.5,
  visual_bg_alter = 0.05,
  noice_cmdline_fg_alter = 0.3,
  winseparator_alter = 1.5,
  fold_bg = -0.15,
  fold_fg = 0.47,
  statusline_bg_alter = 1.5,
  statusline_fg_alter = 3.3,
  tabline_bg_alter = 0.2,
  tabline_fg_alter = 0.5,

  render_markdown_code_bg_alter = 1.35,
  render_markdown_code_inline_bg_alter = 0.35,
})
reset_base_alter({ "rose-pine-dawn" }, {
  CurSearch = {
    fg = { from = "Dark_red", attr = "fg", alter = 1 },
    bg = { from = "Dark_red", attr = "fg", alter = -0.1 },
    bold = true,
  },
  Search = {
    fg = { from = "CurSearch", attr = "fg", alter = 0.15 },
    bg = { from = "CurSearch", attr = "bg", alter = -0.15 },
    bold = false,
  },
  blink_cmp_label_match_fg_alter = 0.6,
  cmpdocnormal_fg_alter = 0.1,
  comment_fg_alter = -0.15,
  cursor_fg = "#dfdfe0",
  cursorline_alter = -0.1,
  dapstopped_bg_alter = 0.2,
  float_title_bg_alter = 0.2,
  float_title_fg_alter = 1,
  fzflua_buf_linenr_bg_alter = -0.2,
  fzflua_cursorline_bg_alter = 0.08,
  fzflua_dir_part_fg = 0.2,
  fzflua_file_part_fg = -0.2,
  fzflua_headertext_fg_alter = -0.3,
  fzflua_sel_bg_alter = 0.01,
  linenr_fg_alter = -0.04,
  lsp_reference_read_bg_alter = { from = "LspReferenceRead", attr = "bg", alter = 0.26 },
  lsp_reference_text_bg_alter = { from = "LspReferenceText", attr = "bg" },
  lsp_reference_write_bg_alter = { from = "LspReferenceWrite", attr = "bg", alter = 0.26 },
  my_code_usage_bg_alter = 3.5,
  my_code_usage_fg_alter = 0.7,
  nontext_fg_alter = -0.45,
  pmenu_bg_alter = -0.12,
  pmenu_sel_bg_alter = 0.1,
  quickfixline_alter = -0.1,
  snacks_indent_scope_fg_alter = 0.7,
  snacks_notifier_border_info_fg_info = -0.3,
  snacks_notifier_info_fg_info = -0.5,
  snacks_notifier_title_info_fg_info = -0.05,
  trouble_indent_fg_alter = -0.45,
  winseparator_alter = -0.13,

  render_markdown_code_bg_alter = -0.075,
  code_block_fg_alter = 0.1,
  render_markdown_code_inline_fg_alter = -0.05,
  render_markdown_code_inline_bg_alter = 0.4,

  snacks_notifier_warn_fg_info = -0.5,
  snacks_notifier_border_warn_fg_info = -0.1,

  snacks_notifier_error_fg_info = -0.5,
  snacks_notifier_border_error_fg_info = -0.1,
})
reset_base_alter({ "tokyonight-night" }, {
  cursor_fg = "#9e0e06",
  cursorline_alter = 0.1,
  fold_bg = -0.1,
  fold_fg = 0.68,
  linenr_fg_alter = 0.05,
  fzflua_headertext_fg_alter = -0.5,
  noice_cmdline_fg_alter = 0.6,
  nontext_fg_alter = 2.2,
  comment_fg_alter = 0.8,
  pmenu_bg_alter = 0.65,
  render_markdown_code_bg_alter = 0.52,
  statusline_bg_alter = 0.4,
  statusline_fg_alter = 1.85,
  tabline_bg_alter = 0.35,
  tabline_fg_alter = 0.82,
  winseparator_alter = 0.6,

  -- {
  --   ["@markup.quote.markdown"] = {
  --     inherit = "@markup.quote.markdown",
  --     fg = { from = "@markup.quote.markdown", attr = "fg", alter = -0.15 },
  --   },
  -- },
})
reset_base_alter({ "tokyonight-storm" }, {
  cmpdocnormal_fg_alter = 0.15,
  comment_fg_alter = 0.5,
  cursor_fg = "#b3276f",
  cursorline_alter = 0.05,
  dapstopped_bg_alter = 0.2,
  fzflua_headertext_fg_alter = -0.5,
  noice_cmdline_fg_alter = 0.6,
  nontext_fg_alter = 1.2,
  pmenu_bg_alter = 0.25,
  render_markdown_code_bg_alter = 0.13,
  tabline_bg_alter = 0.15,
  tabline_fg_alter = 0.55,
  trouble_indent_fg_alter = 0.5,
  winseparator_alter = 0.25,
})
reset_base_alter({ "vscode_modern" }, {
  Directory = { fg = "#569cd6", bg = "NONE" },
  cmpdocnormal_fg_alter = 0.1,
  cursor_fg = "#fa1919",
  cursorline_alter = 0.1,
  dapstopped_bg_alter = 0.2,
  fold_bg = -0.1,
  fzflua_dir_part_fg = 0.8,
  fzflua_headertext_fg_alter = -0.3,
  linenr_fg_alter = 0.1,
  lsp_reference_read_bg_alter = { from = "LspReferenceRead", attr = "bg", alter = -0.1 },
  lsp_reference_text_bg_alter = { from = "LspReferenceText", attr = "bg", alter = -0.2 },
  lsp_reference_write_bg_alter = { from = "LspReferenceWrite", attr = "bg", alter = -0.1 },
  noice_cmdline_fg_alter = 0.6,
  nontext_fg_alter = 1.8,
  render_markdown_code_bg_alter = 0.4,
  snacks_indent_scope_fg_alter = 0.15,
  statusline_bg_alter = 0.4,
  statusline_fg_alter = 1.4,
  tabline_bg_alter = 0.2,
  tabline_fg_alter = 0.65,
  winseparator_alter = 0.38,
})

local general_overrides = function()
  H.all {
    -- ╔═════════════════════════════════════════════════════════╗
    -- ║                          BASE                           ║
    -- ╚═════════════════════════════════════════════════════════╝
    { FoldColumn = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 0.4 } } },
    { FoldColumn1 = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 1 } } },
    { ColorColumn = { bg = { from = "Normal", attr = "bg", alter = -0.1 } } },
    { ErrorMsg = { bg = "NONE" } },

    { Directory = Directory },

    { EndOfBuffer = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 0.2 } } },
    { SignColumn = { bg = "NONE" } },
    { NonText = { fg = { from = "Normal", attr = "bg", alter = nontext_fg_alter } } },
    { WinSeparator = { fg = { from = "Normal", attr = "bg", alter = winseparator_alter }, bg = "NONE" } },
    { LineNr = { bg = "NONE", fg = { from = "WinSeparator", attr = "fg", alter = linenr_fg_alter }, bold = true } },
    { LineNrAbove = { link = "LineNr" } },
    { LineNrBelow = { link = "LineNr" } },
    { Comment = { fg = { from = "LineNr", attr = "fg", alter = comment_fg_alter }, italic = true } },
    { Type = { italic = true, bold = true } },
    { ["@comment"] = { inherit = "Comment" } },

    { WinBar = { bg = { from = "ColorColumn" }, fg = { from = "Normal", attr = "bg", alter = 1 } } },
    { WinBarNC = { bg = { from = "ColorColumn", attr = "bg" }, fg = { from = "WinBar", attr = "fg" } } },

    { CursorLine = { bg = H.darken(H.get(cursorline_fg_alter, "fg"), cursorline_alter, H.get("Normal", "bg")) } },
    {
      CursorLineNr = {
        fg = { from = "Keyword", attr = "fg" },
        bg = { from = "CursorLine", attr = "bg" },
        bold = true,
      },
    },
    {
      Visual = {
        bg = H.tint(H.darken(H.get("String", "fg"), 0.3, H.get("Normal", "bg")), visual_bg_alter),
        fg = "NONE",
      },
    },

    {
      StatusLine = {
        fg = { from = "Normal", attr = "bg", alter = statusline_fg_alter },
        bg = { from = "Normal", attr = "bg", alter = statusline_bg_alter },
        reverse = false,
      },
    },
    {
      TabLine = {
        fg = { from = "StatusLine", attr = "bg", alter = tabline_fg_alter },
        bg = { from = "StatusLine", attr = "bg", alter = tabline_bg_alter },
        reverse = false,
      },
    },

    {
      Pmenu = {
        fg = { from = "Normal", attr = "fg", alter = pmenu_fg_alter },
        bg = { from = "Normal", attr = "bg", alter = pmenu_bg_alter },
        reverse = false,
      },
    },
    { PmenuThumb = { bg = { from = "Pmenu", attr = "bg", alter = 0.2 } } },
    {
      PmenuSel = {
        fg = "NONE",
        bg = { from = "Pmenu", attr = "bg", alter = pmenu_sel_bg_alter },
        bold = true,
        reverse = false,
      },
    },

    {
      NormalFloat = {
        fg = { from = "Pmenu", attr = "fg", alter = normal_float_fg_alter },
        bg = { from = "Pmenu", attr = "bg", alter = normal_float_bg_alter },
        reverse = false,
      },
    },
    {
      FloatBorder = {
        fg = { from = "Pmenu", attr = "bg", alter = float_border_fg_alter },
        bg = { from = "NormalFloat", attr = "bg" },
      },
    },
    {
      FloatTitle = {
        fg = { from = "NormalFloat", attr = "bg", alter = float_title_fg_alter },
        bg = { from = "Keyword", attr = "fg", alter = float_title_bg_alter },
        bold = true,
      },
    },

    {
      NormalBoxComment = {
        fg = { from = "Keyword", attr = "fg", alter = 3 },
        bg = { from = "Keyword", attr = "fg", alter = -0.65 },
      },
    },
    {
      FloatBoxComment = {
        fg = { from = "NormalBoxComment", attr = "bg", alter = 0.45 },
        bg = { from = "NormalBoxComment", attr = "bg" },
      },
    },
    {
      VisualBoxComment = {
        fg = { from = "Normal", attr = "fg", alter = normal_float_fg_alter },
        bg = { from = "Keyword", attr = "fg", alter = -0.2 },
      },
    },

    { Dark_red = { fg = dark_red } },
    { Dark_yellow = { fg = dark_yellow } },

    { CurSearch = CurSearch },
    { Search = Search },
    { IncSearch = { inherit = "CurSearch" } },
    { Cursor = { bg = cursor_fg, reverse = false } },
    { TermCursor = { inherit = "Cursor" } },
    { Substitute = { inherit = "Search" } },

    {
      Folded = {
        fg = { from = "StatusLine", attr = "bg", alter = fold_fg },
        bg = { from = "StatusLine", attr = "bg", alter = fold_bg },
      },
    },
    {
      FoldedBackup = {
        fg = { from = "Normal", attr = "bg", alter = 1.5 },
        bg = { from = "Normal", attr = "bg", alter = 0.7 },
      },
    },
    { FoldedMarkdown = { fg = { from = "Normal", attr = "bg" }, bg = "NONE" } },
    { FoldedSign = { inherit = "Folded", bg = "NONE" } },

    -- ╔═════════════════════════════════════════════════════════╗
    -- ║                           QF                            ║
    -- ╚═════════════════════════════════════════════════════════╝
    {
      QuickFixLine = {
        fg = "NONE",
        bg = { from = "Normal", attr = "bg", alter = quickfixline_alter },
        bold = true,
        underline = false,
        reverse = false,
      },
    },
    { QuickFixLineNr = { fg = { from = "WinSeparator", attr = "fg", alter = quickfixline_linenr_fg_alter } } },
    { qfSeparator1 = { fg = { from = "QuickFixLineNr", attr = "fg", alter = -0.25 } } },
    { qfSeparator2 = { link = "qfSeparator1" } },
    { Delimiter = { link = "qfSeparator1" } },
    { QuickFixFileName = { bg = "NONE" } },
    { qfFileName = { bg = "NONE" } },

    -- ╔═════════════════════════════════════════════════════════╗
    -- ║                          SPELL                          ║
    -- ╚═════════════════════════════════════════════════════════╝
    { SpellBad = { undercurl = true, bg = "NONE", fg = "NONE", sp = "green" } },
    { SpellRare = { undercurl = true } },

    -- ╔═════════════════════════════════════════════════════════╗
    -- ║                     SEMANTIC TOKENS                     ║
    -- ╚═════════════════════════════════════════════════════════╝
    { ["@lsp.type.parameter"] = { italic = true, bold = true, fg = { from = "Normal" } } },
    { ["@lsp.type.selfKeyword"] = { fg = { from = "ErrorMsg", attr = "fg", alter = 0.2 } } },
    { ["@lsp.type.comment"] = { fg = "NONE" } },

    -- { ["@lsp.typemod.function.declaration"] = { fg = { from = "Identifier", attr = "fg" }, bold = true } },
    -- { ["@lsp.typemod.function.defaultLibrary"] = { link = "Special" } },

    -- { ['@lsp.typemod.method'] = { link = '@method' } },
    -- { ["@lsp.typemod.variable.global"] = { bold = true, inherit = "@constant.builtin", }, },
    -- { ["@lsp.typemod.variable.defaultLibrary"] = { italic = true } },
    -- { ["@lsp.typemod.variable.readonly.typescript"] = { clear = true } },
    -- { ["@lsp.type.type.lua"] = { clear = true } },
    -- { ["@lsp.typemod.number.injected"] = { link = "@number" } },
    -- { ["@lsp.typemod.operator.injected"] = { link = "@operator" } },
    -- { ["@lsp.typemod.keyword.injected"] = { link = "@keyword" } },
    -- { ["@lsp.typemod.string.injected"] = { link = "@string" } },
    -- { ["@lsp.typemod.variable.injected"] = { link = "@variable" } },

    -- ╔═════════════════════════════════════════════════════════╗
    -- ║                           LSP                           ║
    -- ╚═════════════════════════════════════════════════════════╝
    -- { ["@punctuation.bracket"] = { fg = "yellow" } },

    { LspKindText = { link = "@markup" } },
    { LspKindBoolean = { link = "@boolean" } },
    { LspKindVariable = { link = "@variable" } },
    { LspKindConstant = { link = "@constant" } },
    { LspKindModule = { link = "@module" } },
    { LspKindPackage = { link = "@module" } },
    { LspKindKeyword = { link = "@lsp.type.keyword" } },
    { LspKindFunction = { link = "@function" } },
    { LspKindStruct = { link = "@lsp.type.struct" } },
    { LspKindArray = { link = "@punctuation.bracket" } },
    { LspKindOperator = { link = "@operator" } },
    { LspKindObject = { link = "@constant" } },
    { LspKindString = { link = "@string" } },
    { LspKindField = { link = "@variable.member" } },
    { LspKindNumber = { link = "@number" } },
    { LspKindProperty = { link = "@property" } },
    { LspKindReference = { fg = H.tint(H.darken(dark_green, 0.6, H.get("Boolean", "fg")), 0.05) } },
    { LspKindEvent = { link = "Special" } },
    { LspKindFile = { link = "Normal" } },
    { LspKindFolder = { link = "Directory" } },
    { LspKindInterface = { link = "@lsp.type.interface" } },
    { LspKindKey = { link = "@variable.member" } },
    { LspKindMethod = { link = "@function.method" } },
    { LspKindNamespace = { link = "@module" } },
    { LspKindNull = { link = "@constant.builtin" } },
    { LspKindUnit = { link = "@lsp.type.struct" } },
    { LspKindEnum = { link = "@lsp.type.enum" } },
    { LspKindEnumMember = { link = "@lsp.type.enumMember" } },
    { LspKindConstructor = { link = "@constructor" } },
    { LspKindTypeParameter = { link = "@lsp.type.typeparameter" } },
    { LspKindValue = { link = "@string" } },
    { LspInlayHint = { link = "@string" } },

    { LspKindSnippet = { fg = { from = "Keyword", attr = "fg" }, f } },
    {
      LspReferenceText = {
        bg = lsp_reference_text_bg_alter,
        fg = "NONE",
        underline = false,
        reverse = false,
        undercurl = false,
      },
    },
    {
      LspReferenceWrite = {
        bg = lsp_reference_write_bg_alter,
        underline = false,
        reverse = false,
        undercurl = false,
      },
    },

    {
      LspReferenceRead = {
        bg = lsp_reference_read_bg_alter,
        underline = false,
        reverse = false,
        undercurl = false,
      },
    },

    -- ╔═════════════════════════════════════════════════════════╗
    -- ║                       TREESITTER                        ║
    -- ╚═════════════════════════════════════════════════════════╝
    { ["@keyword.return"] = { italic = true, fg = { from = "Keyword" } } },
    -- { ['@type.qualifier'] = { inherit = '@keyword', italic = true } },
    -- { ["@variable"] = { fg =  { from = "Directory", attr = "fg", alter = -0.1 } } },
    { ["@parameter"] = { italic = true, bold = true, fg = "NONE" } },
    -- { ["@error"] = { fg = "fg", bg = "NONE" } },
    -- { ["@text.diff.add"] = { link = "DiffAdd" } },
    -- { ["@text.diff.delete"] = { link = "DiffDelete" } },

    -- ───────────────────────────────── LUA ────────────────────────────
    -- { ["@lsp.type.function.lua"] = { fg = { from = "Identifier", attr = "fg" }, bold = true } },
    -- { ["@function.call.lua"] = { fg = { from = "Identifier", attr = "fg"}, bold = true } },
    -- { ['@lsp.type.variable.lua'] = { italic = true, fg = "green" } },

    -- ───────────────────────────────── ZSH ─────────────────────────────
    -- { ["zshFunction"] = { fg = { from = "Identifier", attr = "fg" }, bold = true } },

    -- ──────────────────────────────── BASH ─────────────────────────────
    -- { ["@function.bash"] = { fg = { from = "Identifier", attr = "fg" }, bold = true } },
    -- { ["@function.call.bash"] = { fg = { from = "Identifier", attr = "fg" }, bold = true } },

    -- ──────────────────────────────── RUST ─────────────────────────────
    -- { ["@lsp.type.function.rust"] = { fg = { from = "Identifier", attr = "fg" }, bold = true } },

    -- ╔═════════════════════════════════════════════════════════╗
    -- ║                       DIFF COLOR                        ║
    -- ╚═════════════════════════════════════════════════════════╝
    -- These highlights are syntax groups that are set in diff.vim
    -- { GitSignsAdd = { bg = { from = "ColorColumn"} } },
    -- { diffBDiffer = { link = 'WarningMsg' } },
    -- { diffCommon = { link = 'WarningMsg' } },
    -- { diffDiffer = { link = 'WarningMsg' } },
    {
      diffFile = {
        fg = { from = "Directory", attr = "fg", alter = -0.15 },
        bg = { from = "Directory", attr = "fg", alter = -0.68 },
      },
    },
    -- { diffIdentical = { link = 'WarningMsg' } },
    -- { diffIndexLine = { link = 'Number' } },
    -- { diffIsA = { link = 'WarningMsg' } },
    -- { diffNoEOL = { link = 'WarningMsg' } },
    -- { diffOnly = { link = 'WarningMsg' } },

    -- Setting darken: gunakan paramater (setting_color, ukuran, base_color)
    {
      -- "ukuran" -> semakin tinggi semakin terang, sebaliknya semakin kecil semakin gelap
      diffAdd = {
        fg = H.darken(dark_green, 0.7, H.get("Normal", "bg")),
        bg = H.darken(dark_green, 0.1, H.get("Normal", "bg")),
        reverse = false,
      },
    },
    {
      diffChange = {
        fg = H.darken(dark_yellow, 0.55, H.get("Normal", "bg")),
        bg = H.darken(dark_yellow, 0.1, H.get("Normal", "bg")),
        bold = true,
        reverse = false,
      },
    },
    {
      diffDelete = {
        fg = H.darken(dark_red, 0.7, H.get("Normal", "bg")),
        bg = H.darken(dark_red, 0.1, H.get("Normal", "bg")),
        reverse = false,
      },
    },
    {
      diffText = {
        fg = H.darken(dark_yellow, 0.8, H.get("Normal", "bg")),
        bg = H.darken(dark_yellow, 0.25, H.get("Normal", "bg")),
        bold = true,
        reverse = false,
      },
    },

    { diffAdded = { inherit = "DiffAdd" } },
    { diffChanged = { inherit = "DiffChange" } },
    { diffRemoved = { inherit = "DiffDelete" } },

    { GitSignsAdd = { bg = "NONE", fg = dark_green } },
    { GitSignsChange = { bg = "NONE", fg = dark_yellow } },
    { GitSignsDelete = { bg = "NONE", fg = dark_red } },

    {
      GitSignsAddInline = {
        fg = { from = "diffAdded", attr = "bg", alter = 3 },
        bg = { from = "diffAdded", attr = "bg", alter = 1 },
      },
    },
    {
      GitSignsChangeDelete = {
        fg = { from = "diffChanged", attr = "bg", alter = 3 },
        bg = "NONE",
      },
    },
    {
      GitSignsDeleteInline = {
        fg = { from = "diffDelete", attr = "bg", alter = 3 },
        bg = { from = "diffDelete", attr = "bg", alter = 1 },
      },
    },

    { MiniDiffSignAdd = { bg = "NONE", fg = dark_green } },
    { MiniDiffSignChange = { bg = "NONE", fg = dark_yellow } },
    { MiniDiffSignDelete = { bg = "NONE", fg = dark_red } },

    { NeogitDiffAdd = { link = "diffAdd" } },
    { NeogitDiffAddHighlight = { link = "diffAdd" } },
    { NeogitDiffDelete = { link = "diffDelete" } },
    { NeogitDiffDeleteHighlight = { link = "diffDelete" } },

    { DiffText = { link = "diffText" } },

    -- ╔═════════════════════════════════════════════════════════╗
    -- ║                       DEBUG COLOR                       ║
    -- ╚═════════════════════════════════════════════════════════╝
    { debugPC = { bg = { from = "Boolean", attr = "fg", alter = -0.6 }, fg = "NONE", bold = true } },

    -- ╔═════════════════════════════════════════════════════════╗
    -- ║                       DIAGNOSTIC                        ║
    -- ╚═════════════════════════════════════════════════════════╝
    { DiagnosticSignError = { bg = "NONE" } },
    { DiagnosticSignWarn = { bg = "NONE" } },
    { DiagnosticSignInfo = { bg = "NONE" } },
    { DiagnosticSignHint = { bg = "NONE" } },

    { DiagnosticError = { fg = { from = "DiagnosticSignError", attr = "fg" }, bg = "NONE", italic = true } },
    { DiagnosticsErrorNumHl = { fg = { from = "DiagnosticError", attr = "fg" }, bg = "NONE" } },
    { DiagnosticWarn = { fg = { from = "DiagnosticSignWarn", attr = "fg" }, bg = "NONE", italic = true } },
    { DiagnosticsWarnNumHl = { fg = { from = "DiagnosticSignWarn", attr = "fg" }, bg = "NONE" } },
    { DiagnosticHint = { fg = { from = "DiagnosticSignHint", attr = "fg" }, bg = "NONE", italic = true } },
    { DiagnosticsHintNumHl = { fg = { from = "DiagnosticHint", attr = "fg" }, bg = "NONE" } },
    { DiagnosticInfo = { fg = { from = "DiagnosticSignInfo", attr = "fg" }, bg = "NONE", italic = true } },
    { DiagnosticsInfoNumHl = { fg = { from = "DiagnosticInfo", attr = "fg" }, bg = "NONE" } },

    { DiagnosticFloatingWarn = { fg = { from = "DiagnosticWarn", attr = "fg" }, bg = "NONE", bold = true } },
    { DiagnosticFloatingInfo = { fg = { from = "DiagnosticInfo", attr = "fg" }, bg = "NONE", bold = true } },
    { DiagnosticFloatingHint = { fg = { from = "DiagnosticHint", attr = "fg" }, bg = "NONE", bold = true } },
    { DiagnosticFloatingError = { fg = { from = "DiagnosticError", attr = "fg" }, bg = "NONE", bold = true } },
    { DiagnosticFloatTitle = { bg = { from = "NormalFloat", attr = "bg" }, bold = true } },
    { DiagnosticFloatTitleIcon = { bg = { from = "NormalFloat", attr = "bg" }, fg = { from = "@character" } } },

    { DiagnosticVirtualTextWarn = { link = "DiagnosticWarn" } },
    { DiagnosticVirtualTextInfo = { link = "DiagnosticInfo" } },
    { DiagnosticVirtualTextHint = { link = "DiagnosticHint" } },
    { DiagnosticVirtualTextError = { link = "DiagnosticError" } },

    {
      DiagnosticUnderlineWarn = {
        sp = { from = "DiagnosticWarn", attr = "fg" },
        underline = true,
        undercurl = false,
      },
    },
    {
      DiagnosticUnderlineHint = {
        sp = { from = "DiagnosticHint", attr = "fg" },
        underline = true,
        undercurl = false,
      },
    },
    {
      DiagnosticUnderlineError = {
        sp = { from = "DiagnosticError", attr = "fg" },
        underline = true,
        undercurl = false,
      },
    },
    {
      DiagnosticUnderlineInfo = {
        sp = { from = "DiagnosticInfo", attr = "fg" },
        underline = true,
        undercurl = false,
      },
    },

    -- ╔═════════════════════════════════════════════════════════╗
    -- ║                   CREATED HIGHLIGHTS                    ║
    -- ╚═════════════════════════════════════════════════════════╝
    { YankInk = { bg = { from = "DiffDelete", attr = "bg", alter = 0.5 } } },
    { InactiveBorderColorLazy = { fg = { from = "WinSeparator", attr = "fg", alter = 0.2 } } },
    {
      MyCodeUsage = {
        fg = H.tint(H.get("String", "fg"), my_code_usage_fg_alter),
        bg = H.tint(H.darken(H.get("String", "fg"), 0.7, H.get("Normal", "bg")), my_code_usage_bg_alter),
        -- bg = { from = "Normal", attr = "bg", alter = my_code_usage_bg_alter },
        italic = true,
      },
    },

    {
      KeywordMatch = {
        fg = { from = "DiagnosticError", attr = "fg" },
      },
    },
    {
      KeywordMatchFuzzy = {
        fg = { from = "KeywordMatch", attr = "fg", alter = -0.1 },
      },
    },

    -- HEIRLINE
    { StatusLineFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 4 } } },
    { StatusLineFontNotice = { fg = { from = "Function", attr = "fg", alter = 0.2 } } },

    -- WINBAR
    { StatusLineFontWhite = { fg = { from = "Keyword", attr = "fg" } } },
    { WinbarFilepath = { fg = { from = "Tabline", attr = "bg", alter = 0.38 } } },

    -- ╔═════════════════════════════════════════════════════════╗
    -- ║                      PLUGIN COLORS                      ║
    -- ╚═════════════════════════════════════════════════════════╝
    --  ───────────────────────────────[ BEACON ]──────────────────────────────
    { BeaconDefault = { bg = cursor_fg } },

    --  ───────────────────────────────[ NOICE ]───────────────────────────────
    { NoiceCmdline = { fg = { from = "StatusLine", attr = "fg", alter = noice_cmdline_fg_alter }, bg = "NONE" } },
    {
      LspSignatureActiveParameter = {
        fg = H.darken(dark_yellow, 0.8, H.get("Normal", "fg")),
        bg = H.darken(dark_yellow, 0.25, H.get("Normal", "bg")),
        bold = true,
      },
    },

    --  ───────────────────────────────[ BLINK ]───────────────────────────────
    {
      BlinkCmpLabelDeprecated = {
        fg = { from = "Keyword", attr = "fg", alter = -0.3 },
        strikethrough = true,
        italic = true,
      },
    },
    { BlinkCmpGhostText = { fg = { from = "StatusLine", attr = "fg", alter = -0.1 }, bg = "NONE" } },
    {
      BlinkCmpDocSeparator = {
        fg = { from = "FloatBorder", attr = "fg" },
        bg = { from = "Pmenu", attr = "bg" },
      },
    },
    { BlinkCmpLabelMatch = { fg = { from = "CurSearch", attr = "bg", alter = blink_cmp_label_match_fg_alter } } },
    { BlinkCmpLabelKind = { fg = { from = "Pmenu", attr = "bg", alter = 0.7 } } },

    --  ────────────────────────────────[ CMP ]────────────────────────────────
    { CmpGhostText = { link = "BlinkCmpGhostText" } },
    {
      CmpItemIconWarningMsg = {
        fg = { from = "WarningMsg", attr = "fg" },
        bg = { from = "NormalFloat", attr = "bg" },
      },
    },

    -- ╭────────────╮
    -- │ CMPITEMABR │
    -- ╰────────────╯
    {
      CmpItemAbbr = {
        fg = { from = "Keyword", attr = "fg", alter = -0.3 },
        bg = "NONE",
      },
    },

    { CmpItemAbbrMatchFuzzy = { inherit = "BlinkCmpLabelMatch" } },

    -- ╭─────────╮
    -- │ CMPITEM │
    -- ╰─────────╯
    { CmpItemAbbrDefault = { fg = { from = "CmpItemAbbr", attr = "fg" } } },

    -- ╭────────╮
    -- │ CMPDOC │
    -- ╰────────╯
    {
      CmpDocNormal = {
        fg = { from = "Keyword", attr = "fg", alter = cmpdocnormal_fg_alter },
        bg = { from = "Pmenu", attr = "bg" },
      },
    },
    {
      CmpDocFloatBorder = {
        fg = { from = "FloatBorder", attr = "fg" },
        bg = { from = "Pmenu", attr = "bg" },
      },
    },

    -- ╭─────────╮
    -- │ CMPKIND │
    -- ╰─────────╯
    {
      CmpItemKindArray = {
        inherit = "LspKindArray",
        fg = { from = "LspKindArray", attr = "fg", alter = 0.1 },
        bg = { from = "LspKindArray", attr = "fg", alter = -0.65 },
      },
    },
    {
      CmpItemKindFunction = {
        inherit = "LspKindFunction",
        fg = { from = "LspKindFunction", attr = "fg", alter = 0.1 },
        bg = { from = "LspKindFunction", attr = "fg", alter = -0.65 },
      },
    },
    {
      CmpItemKindBoolean = {
        inherit = "LspKindBoolean",
        fg = { from = "LspKindBoolean", attr = "fg", alter = 0.1 },
        bg = { from = "LspKindBoolean", attr = "fg", alter = -0.65 },
      },
    },
    {
      CmpItemKindVariable = {
        inherit = "LspKindVariable",
        fg = { from = "LspKindVariable", attr = "fg", alter = 0.1 },
        bg = { from = "LspKindVariable", attr = "fg", alter = -0.65 },
      },
    },
    {
      CmpItemKindMethod = {
        inherit = "LspKindMethod",
        fg = { from = "LspKindMethod", attr = "fg", alter = 0.1 },
        bg = { from = "LspKindMethod", attr = "fg", alter = -0.65 },
      },
    },
    {
      CmpItemKindModule = {
        inherit = "LspKindModule",
        fg = { from = "LspKindModule", attr = "fg", alter = 0.1 },
        bg = { from = "LspKindModule", attr = "fg", alter = -0.65 },
      },
    },
    {
      CmpItemKindText = {
        inherit = "LspKindText",
        fg = { from = "LspKindText", attr = "fg", alter = 0.1 },
        bg = { from = "LspKindText", attr = "fg", alter = -0.65 },
      },
    },
    -- {
    --   CmpItemKindClass = {
    --     fg = { from = "LspKindClass", attr = "fg", alter = 0.1 },
    --     bg = { from = "LspKindClass", attr = "fg", alter = -0.65 },
    --   },
    -- },
    -- {
    --   CmpItemKindColor = {
    --     inherit = "LspKindColor",
    --     bg = { from = "LspKindColor", attr = "fg", alter = -0.5 },
    --   },
    -- },
    {
      CmpItemKindConstant = {
        inherit = "LspKindConstant",
        fg = { from = "LspKindConstant", attr = "fg", alter = 0.1 },
        bg = { from = "LspKindConstant", attr = "fg", alter = -0.65 },
      },
    },
    {
      CmpItemKindStruct = {
        inherit = "LspKindStruct",
        fg = { from = "LspKindStruct", attr = "fg", alter = 0.1 },
        bg = { from = "LspKindStruct", attr = "fg", alter = -0.65 },
      },
    },
    {
      CmpItemKindSnippet = {
        inherit = "LspKindSnippet",
        fg = { from = "LspKindSnippet", attr = "fg", alter = 0.1 },
        bg = { from = "LspKindSnippet", attr = "fg", alter = -0.5 },
      },
    },
    {
      CmpItemKindString = {
        inherit = "LspKindString",
        fg = { from = "LspKindString", attr = "fg", alter = 0.1 },
        bg = { from = "LspKindString", attr = "fg", alter = -0.5 },
      },
    },
    {
      CmpItemKindNumber = {
        inherit = "LspKindNumber",
        fg = { from = "LspKindNumber", attr = "fg", alter = 0.1 },
        bg = { from = "LspKindNumber", attr = "fg", alter = -0.5 },
      },
    },
    {
      CmpItemKindPackage = {
        inherit = "LspKindPackage",
        fg = { from = "LspKindPackage", attr = "fg", alter = 0.1 },
        bg = { from = "LspKindPackage", attr = "fg", alter = -0.5 },
      },
    },
    {
      CmpItemKindObject = {
        inherit = "LspKindObject",
        fg = { from = "LspKindObject", attr = "fg", alter = 0.1 },
        bg = { from = "LspKindObject", attr = "fg", alter = -0.5 },
      },
    },
    {
      CmpItemKindNamespace = {
        inherit = "LspKindNamespace",
        fg = { from = "LspKindNamespace", attr = "fg", alter = 0.1 },
        bg = { from = "LspKindNamespace", attr = "fg", alter = -0.5 },
      },
    },
    {
      CmpItemKindEvent = {
        inherit = "LspKindEvent",
        fg = { from = "LspKindEvent", attr = "fg", alter = 0.1 },
        bg = { from = "LspKindEvent", attr = "fg", alter = -0.5 },
      },
    },
    {
      CmpItemKindField = {
        inherit = "LspKindField",
        fg = { from = "LspKindField", attr = "fg", alter = 0.1 },
        bg = { from = "LspKindField", attr = "fg", alter = -0.5 },
      },
    },
    {
      CmpItemKindFile = {
        inherit = "LspKindFile",
        fg = { from = "LspKindFile", attr = "fg", alter = 0.1 },
        bg = { from = "LspKindFile", attr = "fg", alter = -0.5 },
      },
    },
    {
      CmpItemKindFolder = {
        inherit = "LspKindFolder",
        fg = { from = "LspKindFolder", attr = "fg", alter = 0.1 },
        bg = { from = "LspKindFolder", attr = "fg", alter = -0.5 },
      },
    },
    {
      CmpItemKindInterface = {
        inherit = "LspKindInterface",
        fg = { from = "LspKindInterface", attr = "fg", alter = 0.1 },
        bg = { from = "LspKindInterface", attr = "fg", alter = -0.5 },
      },
    },
    {
      CmpItemKindUnit = {
        inherit = "LspKindUnit",
        fg = { from = "LspKindUnit", attr = "fg", alter = 0.1 },
        bg = { from = "LspKindUnit", attr = "fg", alter = -0.5 },
      },
    },
    {
      CmpItemKindKey = {
        inherit = "LspKindKey",
        fg = { from = "LspKindKey", attr = "fg", alter = 0.1 },
        bg = { from = "LspKindKey", attr = "fg", alter = -0.5 },
      },
    },
    {
      CmpItemKindKeyword = {
        inherit = "LspKindKeyword",
        fg = { from = "LspKindKeyword", attr = "fg", alter = 0.1 },
        bg = { from = "LspKindKeyword", attr = "fg", alter = -0.5 },
      },
    },
    {
      CmpItemKindNull = {
        inherit = "LspKindNull",
        fg = { from = "LspKindNull", attr = "fg", alter = 0.1 },
        bg = { from = "LspKindNull", attr = "fg", alter = -0.5 },
      },
    },
    {
      CmpItemKindOperator = {
        inherit = "LspKindOperator",
        fg = { from = "LspKindOperator", attr = "fg", alter = 0.1 },
        bg = { from = "LspKindOperator", attr = "fg", alter = -0.65 },
      },
    },
    {
      CmpItemKindProperty = {
        inherit = "LspKindProperty",
        fg = { from = "LspKindProperty", attr = "fg", alter = 0.1 },
        bg = { from = "LspKindProperty", attr = "fg", alter = -0.65 },
      },
    },
    {
      CmpItemKindReference = {
        inherit = "LspKindReference",
        fg = { from = "LspKindReference", attr = "fg", alter = 0.1 },
        bg = { from = "LspKindReference", attr = "fg", alter = -0.5 },
      },
    },
    {
      CmpItemKindValue = {
        inherit = "LspKindValue",
        fg = { from = "LspKindValue", attr = "fg", alter = 0.1 },
        bg = { from = "LspKindValue", attr = "fg", alter = -0.5 },
      },
    },
    {
      CmpItemKindEnum = {
        inherit = "LspKindEnum",
        fg = { from = "LspKindEnum", attr = "fg", alter = 0.1 },
        bg = { from = "LspKindEnum", attr = "fg", alter = -0.5 },
      },
    },
    {
      CmpItemKindEnumMember = {
        inherit = "LspKindEnumMember",
        fg = { from = "LspKindEnumMember", attr = "fg", alter = 0.1 },
        bg = { from = "LspKindEnumMember", attr = "fg", alter = -0.5 },
      },
    },
    {
      CmpItemKindConstructor = {
        inherit = "LspKindConstructor",
        fg = { from = "LspKindConstructor", attr = "fg", alter = 0.1 },
        bg = { from = "LspKindConstructor", attr = "fg", alter = -0.5 },
      },
    },
    {
      CmpItemKindTypeParameter = {
        inherit = "LspKindTypeParameter",
        fg = { from = "LspKindTypeParameter", attr = "fg", alter = 0.1 },
        bg = { from = "LspKindTypeParameter", attr = "fg", alter = -0.5 },
      },
    },
    { CmpItemKindCopilot = { bg = "NONE", fg = "#118c74" } },
    { CmpItemKindDefault = { bg = "NONE", fg = "#6172b0" } },
    { CmpItemKindCodeium = { bg = "NONE", fg = "#118c74" } },
    { CmpItemKindTabNine = { bg = "NONE", fg = "#118c74" } },

    --  ──────────────────────────────[ AERIALS ]──────────────────────────────
    { AerialGuide = { fg = { from = "WinSeparator", attr = "fg", alter = 0.04 } } },
    { AerialBoolean = { link = "LspKindBoolean" } },
    { AerialBooleanIcon = { link = "LspKindBoolean" } },

    { AerialVariable = { link = "LspKindVariable" } },
    { AerialVariableIcon = { link = "LspKindVariable" } },

    { AerialInterface = { link = "LspKindInterface" } },
    { AerialInterfaceIcon = { link = "LspKindInterface" } },

    { AerialKey = { link = "LspKindKey" } },
    { AerialKeyIcon = { link = "LspKindKey" } },

    { AerialLine = { link = "LspInlayHint" } },

    { AerialMethod = { link = "LspKindMethod" } },
    { AerialMethodIcon = { link = "LspKindMethod" } },

    { AerialModule = { link = "LspKindModule" } },
    { AerialModuleIcon = { link = "LspKindModule" } },

    { AerialNamespace = { link = "LspKindNamespace" } },
    { AerialNamespaceIcon = { link = "LspKindNamespace" } },

    { AerialText = { link = "LspKindText" } },
    { AerialTextIcon = { link = "LspKindText" } },

    { AerialFunction = { link = "LspKindFunction" } },
    { AerialFunctionIcon = { link = "LspKindFunction" } },

    { AerialArray = { link = "LspKindArray" } },
    { AerialArrayIcon = { link = "LspKindArray" } },

    { AerialObject = { link = "LspKindObject" } },
    { AerialObjectIcon = { link = "LspKindObject" } },

    { AerialString = { link = "LspKindString" } },
    { AerialStringIcon = { link = "LspKindString" } },

    { AerialNumber = { link = "LspKindNumber" } },
    { AerialNumberIcon = { link = "LspKindNumber" } },

    { AerialField = { link = "LspKindField" } },
    { AerialFieldIcon = { link = "LspKindField" } },

    { AerialConstant = { link = "LspKindConstant" } },
    { AerialConstantIcon = { link = "LspKindConstant" } },

    { AerialPackage = { link = "LspKindPackage" } },
    { AerialPackageIcon = { link = "LspKindPackage" } },

    { AerialProperty = { link = "LspKindProperty" } },
    { AerialPropertyIcon = { link = "LspKindProperty" } },

    { AerialNull = { link = "LspKindNull" } },
    { AerialNullIcon = { link = "LspKindNull" } },

    { AerialOperator = { link = "LspKindOperator" } },
    { AerialOperatorIcon = { link = "LspKindOperator" } },

    { AerialReference = { link = "LspKindReference" } },
    { AerialReferenceIcon = { link = "LspKindReference" } },

    { AerialSnippet = { link = "LspKindSnippet" } },
    { AerialSnippetIcon = { link = "LspKindSnippet" } },

    { AerialStruct = { link = "LspKindStruct" } },
    { AerialStructIcon = { link = "LspKindStruct" } },

    { AerialTypeParameter = { link = "LspKindTypeParameter" } },
    { AerialTypeParameterIcon = { link = "LspKindTypeParameter" } },

    { AerialUnit = { link = "LspKindUnit" } },
    { AerialUnitIcon = { link = "LspKindUnit" } },

    { AerialValue = { link = "LspKindValue" } },
    { AerialValueIcon = { link = "LspKindValue" } },

    { AerialEnum = { link = "LspKindEnum" } },
    { AerialEnumIcon = { link = "LspKindEnum" } },

    { AerialEnumMember = { link = "LspKindEnumMember" } },
    { AerialEnumMemberIcon = { link = "LspKindEnumMember" } },

    { AerialConstructor = { link = "LspKindConstructor" } },
    { AerialConstructorIcon = { link = "LspKindConstructor" } },

    --  ────────────────────────[ TREESITTER CONTEXT ]─────────────────────
    {
      LspInlayhint = {
        bg = { from = "Normal", attr = "bg", alter = -0.4 },
        fg = { from = "Directory", attr = "fg", alter = -0.3 },
      },
    },
    { TreesitterContextSeparator = { fg = { from = "WinSeparator", attr = "fg", alter = -0.1 } } },
    { TreesitterContext = { bg = { from = "ColorColumn" } } },
    {
      TreesitterContextSeparator = {
        fg = { from = "WinSeparator", attr = "fg", alter = 0.05 },
        bg = { from = "ColorColumn", attr = "bg" },
      },
    },

    --  ──────────────────────────────[ FZFLUA ]───────────────────────────
    -- ╭─────────╮
    -- │ PRPOMPT │
    -- ╰─────────╯
    { FzfLuaNormal = { bg = { from = "Pmenu", attr = "bg", alter = fzflua_normal_bg_alter } } },
    { FzfLuaBorder = { fg = { from = "FzfLuaNormal", attr = "bg" }, bg = { from = "FzfLuaNormal", attr = "bg" } } },
    { FzfLuaHeaderText = { fg = { from = "Keyword", attr = "fg", alter = fzflua_headertext_fg_alter } } },
    {
      FzfLuaBufLineNr = {
        fg = { from = "FzfLuaNormal", attr = "bg", alter = fzflua_buf_linenr_bg_alter },
        bg = "NONE",
      },
    },
    {
      FzfLuaTitle = {
        fg = { from = "FzfLuaNormal", attr = "bg", alter = 1.4 },
        bg = { from = "FzfLuaNormal", attr = "bg", alter = 0.2 },
        bold = true,
      },
    },

    -- { FzfLuaFilePart = { fg = { from = "Directory", attr = "fg", alter = fzflua_file_part_fg }, reverse = false } },
    { FzfLuaFilePart = { fg = { from = "Keyword", attr = "fg", alter = fzflua_file_part_fg }, reverse = false } },
    -- { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = fzflua_dir_part_fg } } },
    -- { FzfLuaDirPart = { fg = { from = "FzfLuaNormal", attr = "bg", alter = fzflua_dir_part_fg } } },
    { FzfLuaDirPart = { fg = { from = "FzfLuaNormal", attr = "bg", alter = fzflua_dir_part_fg } } },

    { FzfLuaFzfMatch = { fg = { from = "BlinkCmpLabelMatch", attr = "fg" }, bg = "NONE" } },
    { FzfLuaFzfMatchFuzzy = { fg = { from = "FzfLuaFzfMatch", attr = "fg", alter = -0.25 }, bg = "NONE" } },

    { FzfLuaSel = { bg = { from = "PmenuSel", attr = "bg", alter = fzflua_sel_bg_alter }, fg = "NONE", bold = true } },
    { FzfLuaCursorLine = { bg = { from = "FzfLuaSel", attr = "bg", alter = fzflua_cursorline_bg_alter } } },
    {
      FzfLuaCursorLineNr = {
        fg = { from = "Keyword", attr = "fg" },
        bg = { from = "FzfLuaCursorLine", attr = "bg" },
      },
    },

    -- ╭─────────╮
    -- │ PREVIEW │
    -- ╰─────────╯
    {
      FzfLuaPreviewNormal = {
        inherit = "FzfLuaNormal",
        bg = { from = "FzfLuaNormal", attr = "bg", alter = -0.03 },
      },
    },
    { FzfLuaPreviewBorder = { inherit = "FzfLuaBorder" } },
    { FzfLuaPreviewTitle = { inherit = "FzfLuaTitle" } },
    { FzfLuaScrollBorderFull = { inherit = "PmenuThumb" } },

    --  ─────────────────────────────[ TELESCOPE ]─────────────────────────────
    { TelescopeNormal = { inherit = "FzfLuaNormal" } },
    { TelescopeBorder = { inherit = "FzfLuaBorder" } },
    { TelescopeMatching = { link = "FzfLuaFzfMatch" } },
    { TelescopeTitle = { inherit = "FzfLuaTitle" } },

    { TelescopeSelection = { bg = { from = "FzfLuaSel", attr = "bg" }, bold = true } },
    { TelescopeSelectionCaret = { bg = "NONE", fg = "green" } },

    -- ╭────────╮
    -- │ Prompt │
    -- ╰────────╯
    { TelescopePromptNormal = { inherit = "FzfLuaNormal" } },
    { TelescopePromptTitle = { inherit = "FzfLuaPreviewTitle" } },
    { TelescopePromptBorder = { inherit = "FzfLuaBorder" } },
    { TelescopePromptPrefix = { fg = { from = "FzfLuaBorder", attr = "fg" }, bg = "NONE" } },
    { TelescopePromptCounter = { fg = { from = "FzfLuaBorder", attr = "fg" } } },

    -- ╭─────────╮
    -- │ Preview │
    -- ╰─────────╯
    { TelescopePreviewNormal = { inherit = "FzfLuaNormal" } },
    { TelescopePreviewTitle = { inherit = "FzfLuaPreviewTitle" } },
    { TelescopePreviewBorder = { inherit = "FzfLuaBorder" } },

    -- ╭─────────╮
    -- │ Results │
    -- ╰─────────╯
    {
      TelescopeResultsNormal = {
        fg = { from = "FzfLuaFilePart", attr = "fg" },
        bg = { from = "FzfLuaNormal", attr = "bg" },
      },
    },
    { TelescopeResultsTitle = { inherit = "FzfLuaPreviewTitle" } },
    { TelescopeResultsBorder = { inherit = "FzfLuaBorder" } },
    { MiniAnimateCursor = { fg = "red", bg = "red" } },

    --  ──────────────────────────────[ SNACKS ]───────────────────────────
    -- ╭───────────────╮
    -- │ SNACKS PICKER │
    -- ╰───────────────╯
    { SnacksPickerFile = { link = "FzfLuaFilePart" } },
    { SnacksPickerDir = { link = "FzfLuaDirPart" } },
    { SnacksPickerMatch = { link = "FzfLuaFzfMatch" } },
    { SnacksPickerManSection = { link = "FzfLuaFzfMatchFuzzy" } },
    { SnacksPickerCursorLine = { link = "FzfLuaCursorLine" } },
    { SnacksPickerPreviewCursorLine = { link = "FzfLuaCursorLine" } },
    { SnacksPickerBorder = { link = "FzfLuaBorder" } },

    { SnacksPickerList = { inherit = "NormalFloat" } },
    { SnacksPickerPrompt = { bg = { from = "NormalFloat", attr = "bg" } } },
    { SnacksPickerListBorder = { bg = { from = "NormalFloat", attr = "bg" } } },
    { SnacksPickerInput = { bg = { from = "NormalFloat", attr = "bg" } } },
    { SnacksPickerListCursorLine = { link = "FzfLuaSel" } },

    -- ╭──────────────────╮
    -- │ SNACKS DASHBOARD │
    -- ╰──────────────────╯
    { SnacksDashboardTitle = { fg = { from = "Keyword", attr = "fg" }, bg = "NONE", bold = true } },
    { SnacksDashboardDesc = { fg = { from = "Keyword", attr = "fg" }, bg = "NONE", bold = true } },

    { SnacksDashboardTerminal = { fg = { from = "NonText", attr = "fg" }, bg = "NONE", bold = false } },
    { SnacksDashboardFooter = { fg = { from = "NonText", attr = "fg" }, bg = "NONE", bold = true } },

    -- ╭───────────────╮
    -- │ SNACKS INDENT │
    -- ╰───────────────╯
    { SnacksIndentScope = { fg = H.darken(dark_yellow, snacks_indent_scope_fg_alter, H.get("Normal", "bg")) } },

    -- ╭─────────────────╮
    -- │ SNACKS NOTIFIER │
    -- ╰─────────────────╯
    -- INFO
    {
      SnacksNotifierInfo = {
        fg = { from = "FzfLuaNormal", attr = "bg", alter = snacks_notifier_info_fg_info },
        bg = { from = "Normal", attr = "bg" },
      },
    },
    {
      SnacksNotifierBorderInfo = {
        fg = { from = "FzfLuaNormal", attr = "bg", alter = snacks_notifier_border_info_fg_info },
        bg = { from = "SnacksNotifierInfo", attr = "bg" },
      },
    },
    {
      SnacksNotifierTitleInfo = {
        fg = { from = "SnacksNotifierInfo", attr = "bg" },
        bg = { from = "SnacksNotifierBorderInfo", attr = "fg", alter = snacks_notifier_title_info_fg_info },
        bold = true,
      },
    },
    -- WARN
    {
      SnacksNotifierWarn = {
        fg = { from = "diffChange", attr = "fg", alter = snacks_notifier_warn_fg_info },
        bg = { from = "Normal", attr = "bg" },
      },
    },
    {
      SnacksNotifierBorderWarn = {
        fg = { from = "diffChange", attr = "fg", alter = snacks_notifier_border_warn_fg_info },
        bg = { from = "SnacksNotifierWarn", attr = "bg" },
      },
    },
    {
      SnacksNotifierTitleWarn = {
        fg = { from = "SnacksNotifierWarn", attr = "bg" },
        bg = { from = "SnacksNotifierBorderWarn", attr = "fg" },
        bold = true,
      },
    },
    -- ERROR
    {
      SnacksNotifierError = {
        fg = { from = "diffDelete", attr = "fg", alter = snacks_notifier_error_fg_info },
        bg = { from = "Normal", attr = "bg" },
      },
    },
    {
      SnacksNotifierBorderError = {
        fg = { from = "diffDelete", attr = "fg", alter = snacks_notifier_border_error_fg_info },
        bg = { from = "SnacksNotifierError", attr = "bg" },
      },
    },
    {
      SnacksNotifierTitleError = {
        fg = { from = "SnacksNotifierError", attr = "bg" },
        bg = { from = "SnacksNotifierBorderError", attr = "fg" },
        bold = true,
      },
    },

    -- ╭─────────────╮
    -- │ SNACKS MISC │
    -- ╰─────────────╯
    { SnacksNotifierHistory = { link = "NormalFloat" } },

    --  ──────────────────────────────[ ORGMODE ]──────────────────────────────
    { ["@org.agenda.scheduled"] = { fg = H.darken("#3f9f31", 0.8, H.get("Normal", "bg")) } },
    { ["@org.agenda.scheduled_past"] = { fg = H.darken(dark_yellow, -0.6, H.get("Normal", "bg")) } },

    { ["@org.headline.level1.org"] = { fg = "#4d85c3", bold = true, italic = true } },
    { ["@org.headline.level2.org"] = { fg = "#389674", bold = true, italic = true } },
    { ["@org.headline.level3.org"] = { fg = "#b0be1e", bold = true, italic = true } },
    { ["@org.headline.level4.org"] = { fg = "#8594c8", bold = true, italic = true } },
    { ["@org.headline.level5.org"] = { fg = "#f76328", bold = true, italic = true } },
    { ["@org.headline.level6.org"] = { fg = "#fccf3e", bold = true, italic = true } },

    {
      ["@org.agenda.today"] = {
        fg = { from = "@org.headline.level2.org", attr = "fg" },
        -- bg = { from = "LineNr", attr = "fg", alter = 0.1 },
        bold = true,
        italic = true,
      },
    },
    { ["@org.timestamp.active"] = { inherit = "PreProc" } },
    { ["@org.bullet"] = { inherit = "Identifier" } },
    { ["@org.checkbox.halfchecked"] = { inherit = "PreProc" } },
    { ["@org.properties"] = { inherit = "Constant" } },
    { ["@org.drawer"] = { inherit = "Constant" } },
    { ["@org.plan"] = { inherit = "Constant" } },
    { ["@org.latex"] = { inherit = "Statement" } },
    { ["@org.hyperlinks"] = { inherit = "Underlined" } },
    { ["@org.code"] = { inherit = "String" } },

    { ["@org.block"] = { inherit = "Comment" } },
    { ["@org.checkbox"] = { inherit = "Comment" } },
    { ["@org.checkbox.checked"] = { inherit = "Comment" } },
    { ["@org.comment"] = { inherit = "Comment" } },
    { ["@org.directive"] = { inherit = "Comment" } },
    { ["@org.timestamp.inactive"] = { inherit = "Comment" } },

    --  ─────────────────────────────[ FUGITIVE ]──────────────────────────
    { fugitiveStagedModifier = { inherit = "GitSignsAdd" } },
    { fugitiveUnstagedModifier = { inherit = "GitSignsChange" } },
    { fugitiveUntrackedModifier = { fg = { from = "GitSignsAdd", attr = "fg", alter = 0.2 } } },

    --  ─────────────────────────────[ DIFFIVIEW ]─────────────────────────────
    { DiffAddedChar = { bg = "NONE", fg = { from = "GitSignsAdd", attr = "fg", alter = 0.1 } } },
    { DiffChangedChar = { bg = "NONE", fg = { from = "GitSignsChange", attr = "fg", alter = 0.1 } } },
    { DiffDeletedChar = { bg = "NONE", fg = { from = "GitSignsDelete", attr = "fg", alter = 0.1 } } },
    { DiffviewStatusAdded = { link = "DiffAddedChar" } },
    { DiffviewStatusModified = { link = "DiffChangedChar" } },
    { DiffviewStatusRenamed = { link = "DiffChangedChar" } },
    { DiffviewStatusUnmerged = { link = "DiffChangedChar" } },
    { DiffviewStatusUntracked = { link = "DiffAddedChar" } },
    { DiffviewStatusDeleted = { link = "DiffDeletedChar" } },

    { DiffviewReference = { fg = { from = "GitSignsDelete", attr = "fg", alter = -0.2 }, bold = true } },

    { DiffviewHash = { fg = { from = "diffAdd", attr = "fg", alter = -0.1 } } },
    { DiffviewNonText = { fg = { from = "WinSeparator", attr = "fg", alter = 0.1 } } },

    { DiffviewFilePanelCounter = { fg = { from = "Directory", attr = "fg", alter = -0.3 } } },
    { DiffviewFilePanelDeletions = { link = "DiffDeletedChar" } },
    { DiffviewFilePanelInsertions = { link = "DiffAddedChar" } },
    { DiffviewFilePanelPath = { fg = { from = "DiffviewFilePanelCounter", attr = "fg", alter = 0.3 } } },
    { DiffviewFilePanelSelected = { fg = { from = "DiffChangedChar", attr = "fg" } } },
    { DiffviewFilePanelFileName = { fg = { from = "DiffviewHash", attr = "fg", alter = 0.5 } } },

    --  ──────────────────────────────[ LAZYGIT ]──────────────────────────────
    { LazygitselectedLineBgColor = { bg = { from = "CursorLine", attr = "bg", alter = 0.5 } } },
    { LazygitInactiveBorderColor = { fg = { from = "WinSeparator", attr = "fg", alter = 0.7 }, bg = "NONE" } },

    --  ────────────────────────────[ BUFFERLINE ]─────────────────────────
    { BufferLineIndicatorSelected = { bg = { from = "ColorColumn" } } },

    --  ────────────────────────────────[ BQF ]────────────────────────────
    { BqfSign = { bg = { from = "ColorColumn", attr = "bg" }, { fg = { from = "Boolean" } } } },

    --  ───────────────────────────[ TODO-COMMENT ]────────────────────────
    { TodoSignWarn = { bg = "NONE", fg = "#FBBF24" } },
    { TodoSignFIX = { bg = "NONE", fg = "#DC2626" } }, -- for error
    { TodoSignTODO = { bg = "NONE", fg = "#2563EB" } },

    --  ──────────────────────────────[ GLANCE ]───────────────────────────
    { GlancePreviewNormal = { bg = "#111231" } },
    { GlancePreviewMatch = { fg = "#012D36", bg = "#FDA50F" } },
    { GlanceListMatch = { fg = dark_red, bg = "NONE" } },
    { GlancePreviewCursorLine = { bg = "#1b1c4b" } },

    --  ─────────────────────────────[ MARKDOWN ]──────────────────────────
    { ["@markup.heading.1.markdown"] = { fg = "#4d85c3", bold = true, italic = true } },
    { ["@markup.heading.2.markdown"] = { fg = "#389674", bold = true, italic = true } },
    { ["@markup.heading.3.markdown"] = { fg = "#b0be1e", bold = true, italic = true } },
    { ["@markup.heading.4.markdown"] = { fg = "#8594c8", bold = true, italic = true } },
    { ["@markup.heading.5.markdown"] = { fg = "#f76328", bold = true, italic = true } },
    { ["@markup.heading.6.markdown"] = { fg = "#fccf3e", bold = true, italic = true } },
    { ["@markup.raw.block.markdown"] = { bg = "NONE" } },
    { ["@markup.list.markdown"] = { bg = "NONE" } },

    {
      ["@markup.link.label.markdown_inline"] = {
        fg = { from = "Keyword", attr = "fg", alter = -0.15 },
        bg = H.darken(H.get("Keyword", "fg"), 0.15, H.get("Normal", "bg")),
        bold = true,
      },
    },
    {
      ["@markup.quote.markdown"] = {
        fg = H.tint(H.darken(dark_red, 0.6, H.get("Normal", "fg")), -0.05),
        bg = H.darken(dark_red, 0.15, H.get("Normal", "bg")),
        italic = true,
        bold = false,
      },
    },
    {
      ["@markup.strong.markdown_inline"] = {
        fg = H.tint(H.darken(H.get("Normal", "fg"), 0.1, H.get("Keyword", "fg")), 0.9),
        bg = "NONE",
        bold = true,
      },
    },
    {
      ["@markup.italic.markdown_inline"] = {
        fg = { from = "Keyword", attr = "fg" },
        bg = "NONE",
        bold = false,
        italic = true,
      },
    },
    {
      ["@punctuation.special.markdown"] = {
        fg = { from = "@markup.quote.markdown", attr = "fg" },
      },
    },
    {
      markdownItalic = {
        fg = { from = "@tag.attribute", attr = "fg", alter = 0.5 },
        italic = false,
        underline = false,
      },
    },
    {
      markdownBold = {
        fg = { from = "Boolean", attr = "fg" },
        bold = true,
      },
    },

    { RenderMarkdownCode = { bg = { from = "Normal", attr = "bg", alter = render_markdown_code_bg_alter } } },
    -- code block for org file
    { CodeBlock = { bg = { from = "RenderMarkdownCode", attr = "bg", alter = code_block_fg_alter } } },
    {
      RenderMarkdownCodeInline = {
        fg = { from = "Keyword", attr = "fg", alter = render_markdown_code_inline_fg_alter },
        bg = H.darken(H.get("Keyword", "fg"), render_markdown_code_inline_bg_alter, H.get("Normal", "bg")),
      },
    },
    { ["@markup.raw.markdown_inline"] = { link = "RenderMarkdownCodeInline" } },

    --  ───────────────────────────────[ FLASH ]───────────────────────────────
    { FlashMatch = { fg = "white", bg = "red", bold = true } },
    { FlashLabel = { fg = "white", bg = "blue", bold = true, strikethrough = false } },
    { FlashCursor = { bg = { from = "ColorColumn", attr = "bg", alter = 5 }, bold = true } },

    --  ─────────────────────────────[ GRUG FAR ]──────────────────────────
    {
      GrugFarResultsPath = {
        fg = { from = "Directory", attr = "fg", alter = -0.3 },
        bold = true,
        underline = true,
      },
    },
    {
      GrugFarResultsLineNr = {
        fg = { from = "Normal", attr = "bg", alter = 1 },
        bg = { from = "Normal", attr = "bg", alter = 0.3 },
      },
    },
    {
      GrugFarResultsMatch = {
        fg = { from = "CurSearch", attr = "bg", alter = 0.3 },
        bg = { from = "CurSearch", attr = "bg", alter = -0.65 },
        bold = true,
      },
    },
    { GrugFarResultsNumberLabel = { fg = { from = "DiagnosticError", attr = "fg", alter = -0.6 }, bold = false } },

    --  ──────────────────────────────[ RGFLOW ]───────────────────────────
    {
      RgFlowHeadLine = {
        bg = { from = "Keyword", attr = "fg", alter = -0.65 },
        fg = { from = "NormalFloat", attr = "bg" },
      },
    },
    {
      RgFlowHead = {
        bg = { from = "RgFlowHeadLine" },
        fg = { from = "Keyword", attr = "fg", alter = 0.5 },
        bold = true,
      },
    },
    { RgFlowInputBg = { bg = { from = "RgFlowHeadLine" } } },
    { RgFlowInputFlags = { bg = "NONE" } },

    --  ────────────────────────────[ VIM.MATCHUP ]────────────────────────────
    { MatchParen = { bg = { from = "Normal", attr = "bg", alter = -1 }, fg = "white", bold = false } },

    --  ──────────────────────────────[ LAZYVIM ]──────────────────────────────
    { LazyNormal = { inherit = "NormalFloat" } },
    { LazyDimmed = { bg = "NONE" } },

    --  ─────────────────────────────[ DEBUG:DAP ]─────────────────────────────
    {
      DapBreakpoint = {
        fg = H.tint(H.darken(dark_red, 0.7, H.get("Normal", "bg")), -0.1),
        bg = "NONE",
      },
    },
    {
      DapStopped = {
        bg = H.tint(H.darken(dark_yellow, dapstopped_bg_alter, H.get("Normal", "bg")), -0.1),
        fg = "NONE",
      },
    },
    {
      DapStoppedIcon = {
        bg = H.tint(H.darken(dark_yellow, dapstopped_bg_alter, H.get("Normal", "bg")), -0.1),
        fg = { from = "GitSignsChange", attr = "fg", alter = 0.6 },
      },
    },

    --  ─────────────────────────────[ COVERAGE ]──────────────────────────
    { CoverageCovered = { bg = { from = "ColorColumn", attr = "bg" } } },
    { CoveragePartial = { bg = { from = "ColorColumn", attr = "bg" } } },
    { CoverageUncovered = { bg = { from = "ColorColumn", attr = "bg" } } },

    { CoverageSummaryFail = { bg = { from = "ColorColumn", attr = "bg" } } },

    --  ─────────────────────────────[ OVERSEER ]──────────────────────────
    { OverseerTaskBorder = { fg = { from = "WinSeparator", attr = "fg" }, bg = "NONE" } },

    --  ─────────────────────────────[ WHICH KEY ]─────────────────────────────
    { WhichKeyTitle = { inherit = "FloatTitle" } },
    -- { WhichKeyNormal = { inherit = "NormalFloat", fg = { from = "Function", attr = "fg", alter = 0.1 } } }, -- <----
    { WhichKeyGroup = { inherit = "NormalFloat", fg = { from = "Keyword", attr = "fg", alter = 0.1 } } },
    { WhichKeyDesc = { inherit = "NormalFloat", fg = { from = "Boolean", attr = "fg", alter = 0.1 } } },
    { WhichKeyBorder = { inherit = "FloatBorder" } },

    --  ──────────────────────────────[ TROUBLE ]──────────────────────────────
    { TroubleNormal = { inherit = "Normal" } },
    { TroubleNormalNC = { inherit = "Normal" } },

    { TroubleSignWarning = { bg = "NONE", fg = { from = "DiagnosticSignWarn", alter = -0.1 } } },
    { TroubleSignError = { bg = "NONE", fg = { from = "DiagnosticSignError", alter = -0.1 } } },
    { TroubleSignHint = { bg = "NONE", fg = { from = "DiagnosticSignHint", alter = -0.1 } } },
    { TroubleSignInfo = { bg = "NONE", fg = { from = "DiagnosticSignInfo", alter = -0.1 } } },
    { TroubleSignOther = { bg = "NONE", fg = { from = "DiagnosticSignInfo", alter = -0.1 } } },
    { TroubleSignInformation = { bg = "NONE", fg = { from = "DiagnosticSignInfo", alter = -0.1 } } },

    {
      TroubleIndent = {
        fg = { from = "Normal", attr = "bg", alter = trouble_indent_fg_alter },
        bg = "NONE",
      },
    },
    {
      TroubleIndentFoldClosed = {
        inherit = "TroubleIndent",
        fg = { from = "TroubleIndent", attr = "fg", alter = 0.4 },
      },
    },
    { TroubleIndentFoldOpen = { link = "TroubleIndentFoldClosed" } },

    -- DIRECTORY
    { TroubleDirectory = { bg = "NONE" } },
    { TroubleFsPos = { inherit = "TroubleIndent", fg = { from = "TroubleIndent", attr = "fg", alter = 0.2 } } },
    {
      TroubleFsCount = {
        fg = { from = "Directory", attr = "fg", alter = -0.13 },
        bg = { from = "Directory", attr = "fg", alter = -0.6 },
      },
    },

    -- LSP
    { TroubleLspFilename = { bg = "NONE" } },
    { TroubleLspPos = { link = "TroubleFsPos" } },
    { TroubleLspCount = { link = "TroubleFsCount" } },
    { TroubleLspItemClient = { link = "TroubleLspCount" } },

    -- DIAGNOSTICS
    { TroubleDiagnosticsBasename = { bg = "NONE" } },
    { TroubleDiagnosticsPos = { link = "TroubleFsPos" } },
    {
      TroubleDiagnosticsCount = {
        fg = { from = "DiagnosticWarn", attr = "fg", alter = -0.13 },
        bg = { from = "DiagnosticWarn", attr = "fg", alter = -0.6 },
      },
    },

    -- TODO
    { TroubleTodoFilename = { bg = "NONE" } },
    { TroubleTodoPos = { link = "TroubleFsPos" } },
    { TroubleTodoCount = { link = "TroubleFsCount" } },

    -- QUICKFIX
    { TroubleQfFilename = { bg = "NONE" } },
    { TroubleQfPos = { link = "TroubleFsPos" } },
    { TroubleQfCount = { link = "TroubleFsCount" } },

    -- DUNNO
    {
      TroubleCode = {
        bg = "NONE",
        fg = { from = "ErrorMsg", attr = "fg" },
        underline = false,
      },
    },

    --  ──────────────────────────────[ OUTLINE ]──────────────────────────────
    { OutlineGuides = { fg = { from = "TroubleIndent", attr = "fg", alter = -0.05 }, bg = "NONE" } },
    {
      OutlineCurrent = {
        fg = { from = "diffDelete", attr = "fg", alter = 0.3 },
        bold = true,
        reverse = false,
      },
    },
    { OutlineDetails = { fg = { from = "TroubleIndent", attr = "fg", alter = 0.15 }, bg = "NONE", italic = true } },
    { OutlineJumpHighlight = { bg = "red", fg = "NONE" } },
    { OutlineLineno = { bg = "NONE" } },
    { OutlineFoldMarker = { fg = { from = "TroubleIndentFoldClosed", attr = "fg" }, bg = "NONE" } },

    --  ──────────────────────────────[ AVANTE ]───────────────────────────
    {
      AvanteNormal = {
        fg = { from = "Normal", attr = "bg", alter = 4 },
        bg = { from = "Normal", attr = "bg", alter = -0.5 },
      },
    },
    {
      AvanteInlineHint = {
        fg = { from = "Keyword", attr = "fg", alter = -0.6 },
        bg = "NONE",
      },
    },
  }
end

local function set_sidebar_highlight()
  H.all {
    { PanelDarkBackground = { bg = { from = "Normal", alter = -0.1 } } },
    { PanelDarkHeading = { inherit = "PanelDarkBackground", bold = true } },
    { PanelBackground = { bg = { from = "Normal" } } },
    { PanelHeading = { inherit = "PanelBackground", bold = true } },
    { PanelWinSeparator = { inherit = "PanelBackground", fg = { from = "WinSeparator" } } },
    { PanelStNC = { link = "PanelWinSeparator" } },
    { PanelSt = { bg = { from = "Visual", alter = -0.2 } } },
    { PanelStusLine = { bg = { from = "StatusLine" }, fg = { from = "Normal", attr = "fg" } } },
  }
end

local sidebar_fts = {
  "packer",
  "flutterToolsOutline",
  "undotree",
  "Outline",
  "dbui",
  "neotest-summary",
  "pr",
}

local function on_sidebar_enter()
  vim.opt_local.winhighlight:append {
    Normal = "PanelBackground",
    EndOfBuffer = "PanelBackground",
    StatusLine = "PanelSt",
    SignColumn = "PanelBackground",
    VertSplit = "PanelVertSplit",
    WinSeparator = "PanelWinSeparator",
  }
end

local function colorscheme_overrides()
  local overrides = {
    ["ashen"] = {
      -- GRUG-FAR
      {
        GrugFarResultsLineNr = {
          inherit = "GrugFarResultsLineNr",
          fg = { from = "GrugFarResultsLineNr", attr = "fg", alter = 0.5 },
          bg = { from = "GrugFarResultsLineNr", attr = "bg", alter = 0.35 },
        },
      },
    },
    ["base46-doomchad"] = {
      -- GRUG-FAR
      {
        GrugFarResultsLineNr = {
          inherit = "GrugFarResultsLineNr",
          fg = { from = "GrugFarResultsLineNr", attr = "fg", alter = -0.05 },
          bg = { from = "GrugFarResultsLineNr", attr = "bg", alter = -0.1 },
        },
      },
    },
    ["base46-everforest"] = {
      -- GRUG-FAR
      {
        GrugFarResultsLineNr = {
          inherit = "GrugFarResultsLineNr",
          bg = { from = "GrugFarResultsLineNr", attr = "bg", alter = -0.07 },
        },
      },
    },
    ["base46-gruvchad"] = {
      -- GRUG-FAR
      {
        GrugFarResultsLineNr = {
          inherit = "GrugFarResultsLineNr",
          fg = { from = "GrugFarResultsLineNr", attr = "fg", alter = 0.1 },
          bg = { from = "GrugFarResultsLineNr", attr = "bg", alter = 0.05 },
        },
      },
    },
    ["base46-jellybeans"] = {
      -- GRUG-FAR
      {
        GrugFarResultsLineNr = {
          inherit = "GrugFarResultsLineNr",
          fg = { from = "GrugFarResultsLineNr", attr = "fg", alter = 0.6 },
          bg = { from = "GrugFarResultsLineNr", attr = "bg", alter = 0.4 },
        },
      },
    },
    ["base46-kanagawa"] = {
      -- GRUG-FAR
      {
        GrugFarResultsLineNr = {
          inherit = "GrugFarResultsLineNr",
          fg = { from = "GrugFarResultsLineNr", attr = "fg", alter = 0.3 },
          bg = { from = "GrugFarResultsLineNr", attr = "bg", alter = 0.1 },
        },
      },
    },
    ["base46-material-lighter"] = {
      -- DIAGNOSTICS
      {
        diffAdd = {
          fg = H.tint(H.darken(dark_green, 0.9, H.get("Normal", "bg")), -0.1),
          bg = H.tint(H.darken(dark_green, 0.1, H.get("Normal", "bg")), -0.1),
          reverse = false,
        },
      },
      {
        diffChange = {
          fg = H.darken(dark_yellow, 0.55, H.get("Normal", "bg")),
          bg = H.darken(dark_yellow, 0.1, H.get("Normal", "bg")),
          bold = true,
          reverse = false,
        },
      },
      {
        diffDelete = {
          fg = H.darken(dark_red, 0.7, H.get("Normal", "bg")),
          bg = H.darken(dark_red, 0.1, H.get("Normal", "bg")),
          reverse = false,
        },
      },
      {
        diffText = {
          fg = H.darken(dark_yellow, 0.8, H.get("Normal", "bg")),
          bg = H.darken(dark_yellow, 0.25, H.get("Normal", "bg")),
          bold = true,
          reverse = false,
        },
      },

      { diffAdded = { inherit = "DiffAdd" } },
      { diffChanged = { inherit = "DiffChange" } },
      { diffRemoved = { inherit = "DiffDelete" } },

      {
        GitSignsAdd = {
          bg = "NONE",
          fg = H.tint(H.darken(dark_green, 0.8, H.get("Normal", "bg")), -0.15),
        },
      },

      {
        GitSignsChange = {
          bg = "NONE",
          fg = H.tint(H.darken(dark_yellow, 0.8, H.get("Normal", "bg")), -0.15),
        },
      },
      {
        GitSignsDelete = {
          bg = "NONE",
          fg = H.tint(H.darken(dark_red, 0.8, H.get("Normal", "bg")), -0.15),
        },
      },

      {
        GitSignsAddInline = {
          fg = { from = "diffAdded", attr = "bg", alter = 3 },
          bg = { from = "diffAdded", attr = "bg", alter = 1 },
        },
      },
      {
        GitSignsChangeDelete = {
          fg = { from = "diffChanged", attr = "bg", alter = 3 },
          bg = "NONE",
        },
      },
      {
        GitSignsDeleteInline = {
          fg = { from = "diffDelete", attr = "bg", alter = 3 },
          bg = { from = "diffDelete", attr = "bg", alter = 1 },
        },
      },

      { MiniDiffSignAdd = { bg = "NONE", fg = dark_green } },
      { MiniDiffSignChange = { bg = "NONE", fg = dark_yellow } },
      { MiniDiffSignDelete = { bg = "NONE", fg = dark_red } },

      { NeogitDiffAdd = { link = "diffAdd" } },
      { NeogitDiffAddHighlight = { link = "diffAdd" } },
      { NeogitDiffDelete = { link = "diffDelete" } },
      { NeogitDiffDeleteHighlight = { link = "diffDelete" } },

      { DiffText = { link = "diffText" } },

      -- ╭─────────────────╮
      -- │ SNACKS NOTIFIER │
      -- ╰─────────────────╯
      -- INFO
      {
        SnacksNotifierInfo = {
          fg = H.tint(H.darken(H.get("Function", "fg"), 0.1, H.get("Normal", "bg")), -0.5),
          bg = { from = "Normal", attr = "bg" },
        },
      },
      {
        SnacksNotifierBorderInfo = {
          fg = { from = "FloatBorder", attr = "fg", alter = 0.1 },
          bg = { from = "SnacksNotifierInfo", attr = "bg" },
        },
      },
      {
        SnacksNotifierTitleInfo = {
          fg = { from = "SnacksNotifierBorderInfo", attr = "fg", alter = -0.1 },
          bg = { from = "SnacksNotifierInfo", attr = "bg" },
          bold = true,
        },
      },
      -- WARN
      {
        SnacksNotifierWarn = {
          fg = { from = "diffChange", attr = "fg", alter = -0.5 },
          bg = { from = "Normal", attr = "bg" },
        },
      },
      {
        SnacksNotifierBorderWarn = {
          fg = { from = "diffChange", attr = "fg" },
          bg = { from = "SnacksNotifierWarn", attr = "bg" },
        },
      },
      {
        SnacksNotifierTitleWarn = {
          fg = { from = "SnacksNotifierBorderWarn", attr = "fg", alter = -0.1 },
          bg = { from = "SnacksNotifierWarn", attr = "bg" },
          bold = true,
        },
      },
      -- ERROR
      {
        SnacksNotifierError = {
          fg = { from = "diffDelete", attr = "fg", alter = -0.5 },
          bg = { from = "Normal", attr = "bg" },
        },
      },
      {
        SnacksNotifierBorderError = {
          fg = { from = "diffDelete", attr = "fg" },
          bg = { from = "SnacksNotifierError", attr = "bg" },
        },
      },
      {
        SnacksNotifierTitleError = {
          fg = { from = "SnacksNotifierBorderError", attr = "fg", alter = 0.1 },
          bg = { from = "SnacksNotifierError", attr = "bg" },
          bold = true,
        },
      },

      -- SNACKS
      { SnacksIndentScope = { fg = H.tint(H.darken(dark_yellow, 0.3, H.get("Normal", "bg")), -0.1) } },

      -- QF/QUICKER
      { QuickFixLineNr = { fg = { from = "Normal", attr = "bg", alter = -0.4 } } },
      { qfSeparator1 = { fg = { from = "Normal", attr = "bg", alter = -0.2 } } },
      { qfSeparator2 = { link = "qfSeparator1" } },
      { Delimiter = { link = "qfSeparator1" } },
      {
        QuickFixLine = {
          fg = "NONE",
          bg = { from = "CursorLine", attr = "bg", alter = quickfixline_alter },
          bold = true,
          underline = false,
          reverse = false,
        },
      },

      -- GRUG-FAR
      {
        GrugFarResultsLineNr = {
          inherit = "GrugFarResultsLineNr",
          fg = { from = "GrugFarResultsLineNr", attr = "fg", alter = 0.3 },
          bg = { from = "GrugFarResultsLineNr", attr = "bg", alter = 0.2 },
        },
      },

      -- STATUSLINE
      {
        StatusLine = {
          fg = { from = "Normal", attr = "bg", alter = -0.35 },
          bg = { from = "Normal", attr = "bg", alter = -0.1 },
          reverse = false,
        },
      },
      {
        NoiceCmdline = {
          fg = { from = "StatusLine", attr = "fg", alter = -0.1 },
          bg = { from = "StatusLine", attr = "bg" },
        },
      },
      { BlinkCmpGhostText = { fg = { from = "StatusLine", attr = "bg", alter = -0.22 }, bg = "NONE" } },

      {
        TabLine = {
          fg = { from = "StatusLine", attr = "bg", alter = -0.26 },
          bg = { from = "StatusLine", attr = "bg", alter = -0.01 },
        },
      },

      {
        Folded = {
          fg = { from = "StatusLine", attr = "bg", alter = -0.3 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.01 },
        },
      },
      { FoldedSign = { fg = { from = "Folded", attr = "fg", alter = -0.48 }, bg = "NONE" } },

      -- MARKDOWN
      { RenderMarkdownCode = { bg = { from = "Normal", attr = "bg", alter = 0.52 } } },
      { CodeBlock = { bg = { from = "RenderMarkdownCode", attr = "bg", alter = 0.1 } } },
      {
        ["@markup.quote.markdown"] = {
          inherit = "@markup.quote.markdown",
          fg = { from = "@markup.quote.markdown", attr = "fg", alter = -0.15 },
        },
      },

      -- CREATED HIGHLIGHTS
      { StatusLineFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = -0.5 } } },
      { StatusLineFontNotice = { fg = { from = "Function", attr = "fg", alter = -0.2 } } },
    },
    ["base46-onenord"] = {
      -- GRUG-FAR
      {
        GrugFarResultsLineNr = {
          inherit = "GrugFarResultsLineNr",
          fg = { from = "GrugFarResultsLineNr", attr = "fg", alter = -0.05 },
          bg = { from = "GrugFarResultsLineNr", attr = "bg", alter = -0.05 },
        },
      },
    },
    ["base46-oxocarbon"] = {
      -- GRUG-FAR
      {
        GrugFarResultsLineNr = {
          inherit = "GrugFarResultsLineNr",
          fg = { from = "GrugFarResultsLineNr", attr = "fg", alter = 0.5 },
          bg = { from = "GrugFarResultsLineNr", attr = "bg", alter = 0.4 },
        },
      },
    },
    ["base46-rosepine"] = {
      -- GRUG-FAR
      {
        GrugFarResultsLineNr = {
          inherit = "GrugFarResultsLineNr",
          fg = { from = "GrugFarResultsLineNr", attr = "fg", alter = 0.4 },
          bg = { from = "GrugFarResultsLineNr", attr = "bg", alter = 0.3 },
        },
      },
    },
    ["base46-seoul256_dark"] = {
      -- GRUG-FAR
      {
        GrugFarResultsLineNr = {
          inherit = "GrugFarResultsLineNr",
          fg = { from = "GrugFarResultsLineNr", attr = "fg", alter = -0.15 },
          bg = { from = "GrugFarResultsLineNr", attr = "bg", alter = -0.15 },
        },
      },
    },
    ["base46-solarized_dark"] = {
      -- GRUG-FAR
      {
        GrugFarResultsLineNr = {
          inherit = "GrugFarResultsLineNr",
          fg = { from = "GrugFarResultsLineNr", attr = "fg", alter = 0.1 },
          bg = { from = "GrugFarResultsLineNr", attr = "bg", alter = 0.05 },
        },
      },
    },
    ["base46-vscode_dark"] = {
      -- GRUG-FAR
      {
        GrugFarResultsLineNr = {
          inherit = "GrugFarResultsLineNr",
          fg = { from = "GrugFarResultsLineNr", attr = "fg", alter = 0.1 },
          bg = { from = "GrugFarResultsLineNr", attr = "bg", alter = 0.05 },
        },
      },
    },
    ["base46-zenburn"] = {
      -- GRUG-FAR
      {
        GrugFarResultsLineNr = {
          inherit = "GrugFarResultsLineNr",
          fg = { from = "GrugFarResultsLineNr", attr = "fg", alter = -0.1 },
          bg = { from = "GrugFarResultsLineNr", attr = "bg", alter = -0.1 },
        },
      },
    },
    ["lackluster"] = {
      -- GRUG-FAR
      {
        GrugFarResultsLineNr = {
          inherit = "GrugFarResultsLineNr",
          fg = { from = "GrugFarResultsLineNr", attr = "fg", alter = 0.8 },
          bg = { from = "GrugFarResultsLineNr", attr = "bg", alter = 0.8 },
        },
      },
    },
    ["techbase"] = {
      -- GRUG-FAR
      {
        GrugFarResultsLineNr = {
          inherit = "GrugFarResultsLineNr",
          fg = { from = "GrugFarResultsLineNr", attr = "fg", alter = 0.1 },
          bg = { from = "GrugFarResultsLineNr", attr = "bg", alter = 0.05 },
        },
      },
    },
    ["rose-pine"] = {
      -- DIAGNOSTICS
      {
        diffAdd = {
          fg = H.tint(H.darken(dark_green, 0.9, H.get("Normal", "bg")), -0.1),
          bg = H.tint(H.darken(dark_green, 0.1, H.get("Normal", "bg")), -0.1),
          reverse = false,
        },
      },
      {
        diffChange = {
          fg = H.darken(dark_yellow, 0.55, H.get("Normal", "bg")),
          bg = H.darken(dark_yellow, 0.1, H.get("Normal", "bg")),
          bold = true,
          reverse = false,
        },
      },
      {
        diffDelete = {
          fg = H.darken(dark_red, 0.7, H.get("Normal", "bg")),
          bg = H.darken(dark_red, 0.1, H.get("Normal", "bg")),
          reverse = false,
        },
      },
      {
        diffText = {
          fg = H.darken(dark_yellow, 0.8, H.get("Normal", "bg")),
          bg = H.darken(dark_yellow, 0.25, H.get("Normal", "bg")),
          bold = true,
          reverse = false,
        },
      },

      { diffAdded = { inherit = "DiffAdd" } },
      { diffChanged = { inherit = "DiffChange" } },
      { diffRemoved = { inherit = "DiffDelete" } },

      {
        GitSignsAdd = {
          bg = "NONE",
          fg = H.tint(H.darken(dark_green, 0.8, H.get("Normal", "bg")), -0.15),
        },
      },

      {
        GitSignsChange = {
          bg = "NONE",
          fg = H.tint(H.darken(dark_yellow, 0.8, H.get("Normal", "bg")), -0.15),
        },
      },
      {
        GitSignsDelete = {
          bg = "NONE",
          fg = H.tint(H.darken(dark_red, 0.8, H.get("Normal", "bg")), -0.15),
        },
      },

      {
        GitSignsAddInline = {
          fg = { from = "diffAdded", attr = "bg", alter = 3 },
          bg = { from = "diffAdded", attr = "bg", alter = 1 },
        },
      },
      {
        GitSignsChangeDelete = {
          fg = { from = "diffChanged", attr = "bg", alter = 3 },
          bg = "NONE",
        },
      },
      {
        GitSignsDeleteInline = {
          fg = { from = "diffDelete", attr = "bg", alter = 3 },
          bg = { from = "diffDelete", attr = "bg", alter = 1 },
        },
      },

      { MiniDiffSignAdd = { bg = "NONE", fg = dark_green } },
      { MiniDiffSignChange = { bg = "NONE", fg = dark_yellow } },
      { MiniDiffSignDelete = { bg = "NONE", fg = dark_red } },

      { NeogitDiffAdd = { link = "diffAdd" } },
      { NeogitDiffAddHighlight = { link = "diffAdd" } },
      { NeogitDiffDelete = { link = "diffDelete" } },
      { NeogitDiffDeleteHighlight = { link = "diffDelete" } },

      { DiffText = { link = "diffText" } },

      -- ╭─────────────────╮
      -- │ SNACKS NOTIFIER │
      -- ╰─────────────────╯
      -- SNACKS
      { SnacksIndentScope = { fg = H.tint(H.darken(dark_yellow, 0.3, H.get("Normal", "bg")), -0.1) } },

      -- QF/QUICKER
      { QuickFixLineNr = { fg = { from = "Normal", attr = "bg", alter = -0.4 } } },
      { qfSeparator1 = { fg = { from = "Normal", attr = "bg", alter = -0.2 } } },
      { qfSeparator2 = { link = "qfSeparator1" } },
      { Delimiter = { link = "qfSeparator1" } },
      {
        QuickFixLine = {
          fg = "NONE",
          bg = { from = "PmenuSel", attr = "bg", alter = quickfixline_alter },
          bold = true,
          underline = false,
          reverse = false,
        },
      },

      -- GRUG-FAR
      {
        GrugFarResultsLineNr = {
          inherit = "GrugFarResultsLineNr",
          fg = { from = "GrugFarResultsLineNr", attr = "fg", alter = 0.3 },
          bg = { from = "GrugFarResultsLineNr", attr = "bg", alter = 0.2 },
        },
      },

      -- STATUSLINE
      {
        StatusLine = {
          fg = { from = "Normal", attr = "bg", alter = -0.35 },
          bg = { from = "Normal", attr = "bg", alter = -0.1 },
          reverse = false,
        },
      },
      {
        NoiceCmdline = {
          fg = { from = "StatusLine", attr = "fg", alter = -0.1 },
          bg = { from = "StatusLine", attr = "bg" },
        },
      },
      { BlinkCmpGhostText = { fg = { from = "StatusLine", attr = "bg", alter = -0.22 }, bg = "NONE" } },
      { BlinkCmpLabelKind = { fg = { from = "Pmenu", attr = "bg", alter = -0.3 } } },

      {
        TabLine = {
          fg = { from = "StatusLine", attr = "bg", alter = -0.26 },
          bg = { from = "StatusLine", attr = "bg", alter = -0.01 },
        },
      },

      {
        Folded = {
          fg = { from = "StatusLine", attr = "bg", alter = -0.2 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.037 },
        },
      },
      { FoldedSign = { fg = { from = "Folded", attr = "fg", alter = -0.48 }, bg = "NONE" } },

      -- CREATED HIGHLIGHTS
      { StatusLineFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = -0.5 } } },
      { StatusLineFontNotice = { fg = { from = "Function", attr = "fg", alter = -0.2 } } },
    },
    ["tokyonight-night"] = {
      -- GRUG-FAR
      {
        GrugFarResultsLineNr = {
          inherit = "GrugFarResultsLineNr",
          fg = { from = "GrugFarResultsLineNr", attr = "fg", alter = 0.3 },
          bg = { from = "GrugFarResultsLineNr", attr = "bg", alter = 0.2 },
        },
      },
    },
  }

  local hls = overrides[vim.g.colors_name]
  if hls then
    H.all(hls)
  end
end

local function user_highlights()
  general_overrides()
  set_sidebar_highlight()
  colorscheme_overrides()
end

RUtils.cmd.augroup("UserHighlights", {
  event = "ColorScheme",
  command = function()
    user_highlights()
  end,
}, {
  event = "FileType",
  pattern = sidebar_fts,
  command = function()
    on_sidebar_enter()
  end,
})
