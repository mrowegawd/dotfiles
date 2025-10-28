local base_colors = {
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
  blink_cmp_label_kind_fg_alter = 0.6,
  blink_cmp_label_match_fg_alter = 0.2,
  blink_ghost_text_fg_alter = -0.48,
  bqf_keyword = "Keyword",
  cmpdocnormal_fg_alter = 0.3,
  comment_fg_alter = 0.65,
  cursor_fg = "#c7063c",
  cursorline_alter = 0.04,
  cursorline_fg_alter = "Keyword",
  dapstopped_bg_alter = 0.25,
  float_title_bg_alter = -0.1,
  float_title_fg_alter = -0.1,
  fzflua_border_fg_alter = 0.55,
  fzflua_buf_linenr_bg_alter = 0.5,
  fzflua_file_part_fg = 0.85,
  fzflua_normal_bg_alter = 0.5,
  fzflua_sel_sp_fg_alter = -0.3,
  hovered_cursorline_fg_alter = 0.4,
  linenr_fg_alter = 0.08,
  lsp_reference_read_bg_alter = { from = "LspReferenceRead", attr = "bg", alter = -0.2 },
  lsp_reference_text_bg_alter = { from = "LspReferenceText", attr = "bg" },
  lsp_reference_write_bg_alter = { from = "LspReferenceWrite", attr = "bg", alter = -0.2 },
  my_code_usage_bg_alter = -0.55,
  my_code_usage_fg_alter = -0.25,
  noice_cmdline_fg_alter = 0.8,
  nontext_fg_alter = -0.5,
  normal_float_fg_alter = -0.01,
  outline_indent_fg_alter = 0.3,
  panel_sidebar_bg_alter = 0.25,
  panel_sidebar_fg_alter = 0.3,
  pmenu_bg_alter = 0.7,
  pmenu_fg_alter = -0.1,
  pmenu_sel_bg_alter = 0.2,
  pmenu_sp_alter = 2.5,
  pmenu_thumb_bg_alter = 0.4,
  quickfixline_header_bg_alter = 0.4,
  quickfixline_header_fg_alter = 1.7,
  quickfixline_header_tint_bg_alter = 0,
  quickfixline_header_tint_fg_alter = 0,
  quickfixline_linenr_fg_alter = 0.25,
  quickfixline_sp_alter = 1,
  snacks_indent_scope_fg_alter = 0.2,
  statusline_bg_alter = 0,
  statusline_fg_alter = 0.8,
  tabline_bg_alter = 0.05,
  tabline_fg_alter = 0.4,
  trouble_indent_fg_alter = 0.55,
  visual_bg_alter = -0.1,
  winbar_fg_alter = 1.5,
  winbar_right_block_bg_alter = -0.6,
  winbar_right_block_fg_alter = -0.1,
  winseparator_alter = 0.25,

  normal_keyword_alter = 0.14,

  panel_bottom_normal_fg_alter = -0.05,
  panel_bottom_normal_bg_alter = 0.1,

  fold_fg = 0.18,
  fold_bg = 0.05,

  render_markdown_code_bg_alter = 0.4,
  render_markdown_code_inline_bg_alter = 0.12,
  render_markdown_code_inline_fg_alter = 0.1,

  code_block_fg_alter = 0.12, -- for Org file (better to leave it as is)

  snacks_notifier_info_bg = 0.5,
  snacks_notifier_border_info_fg = -0.5,

  snacks_notifier_warn_bg = 0.3,
  snacks_notifier_border_warn_fg = -0.6,

  snacks_notifier_error_fg = 0.1,
  snacks_notifier_error_bg = 0.3,
  snacks_notifier_border_error_fg = -0.4,

  -- diff
  diffadd_fg_alter = -0.2,
  diffadd_bg_alter = 0.2,

  diffchange_fg_alter = -0.2,
  diffchange_bg_alter = 0.2,

  diffdelete_fg_alter = -0.1,
  diffdelete_bg_alter = 0.18,

  difffile_fg_alter = -0.15,
  difffile_bg_alter = -0.68,

  difftext_fg_alter = 0.4,
  difftext_bg_alter = 0.5,

  delta_plus_fg_alter = 0.9,
  delta_plus_bg_alter = -0.4,

  delta_minus_fg_alter = 1,
  delta_minus_bg_alter = -0.4,
}

local update_col_colorscheme = {
  ["ashen"] = {
    comment_fg_alter = 0.9,
    fold_fg = 0.25,
    fzflua_file_part_fg = 0.6,
    linenr_fg_alter = -0.05,
    nontext_fg_alter = 3,
    pmenu_bg_alter = 1.8,
    render_markdown_code_bg_alter = 1.4,
    statusline_fg_alter = 0.8,
    winbar_right_block_bg_alter = 0.6,
    winbar_right_block_fg_alter = -0.25,
    winseparator_alter = 1.3,
  },
  ["darcubox"] = {
    comment_fg_alter = 0.9,
    fold_fg = 0.25,
    hovered_cursorline_fg_alter = 0.8,
    linenr_fg_alter = 0.1,
    nontext_fg_alter = 3,
    pmenu_bg_alter = 2,
    pmenu_sp_alter = 4,
    render_markdown_code_bg_alter = 1.4,
    statusline_fg_alter = 0.85,
    visual_bg_alter = 0.2,
    winbar_right_block_bg_alter = 0.8,
    winbar_right_block_fg_alter = 0.1,
    winseparator_alter = 1.3,
  },
  ["base46-kanagawa"] = {
    cmpdocnormal_fg_alter = 0.1,
    cursor_fg = "#b3276f",
    cursorline_alter = 0.65,
    cursorline_fg_alter = "WinSeparator",
    dapstopped_bg_alter = 0.2,
    fold_fg = 0.3,
    fzflua_border_fg_alter = 0.8,
    linenr_fg_alter = -0.05,
    noice_cmdline_fsg_alter = 0.4,
    nontext_fg_alter = 1.8,
    normal_keyword_alter = 0.16,
    pmenu_bg_alter = 0.8,
    quickfixline_linenr_fg_alter = 0.35,
    quickfixline_sp_alter = 0.7,
    render_markdown_code_bg_alter = 0.38,
    render_markdown_code_inline_bg_alter = 0.2,
    snacks_indent_scope_fg_alter = 0.22,
    statusline_bg_alter = -0.1,
    tabline_fg_alter = 0.55,
    winseparator_alter = 0.6,
  },
  ["base46-palenight"] = {
    comment_fg_alter = 0.5,
    linenr_fg_alter = -0.02,
    pmenu_bg_alter = 0.5,
    statusline_bg_alter = -0.05,
    winbar_right_block_bg_alter = 0.3,
    winseparator_alter = 0.25,
  },
  ["base46-material-darker"] = {
    comment_fg_alter = 0.6,
    cursor_fg = "#16afca",
    cursorline_alter = 0.07,
    dapstopped_bg_alter = 0.2,
    fzflua_border_fg_alter = 0.7,
    fzflua_file_part_fg = 0.65,
    linenr_fg_alter = -0.02,
    noice_cmdline_fg_alter = 0.6,
    pmenu_sp_alter = 2.2,
    quickfixline_linenr_fg_alter = 0.3,
    quickfixline_sp_alter = 0.5,
    render_markdown_code_inline_bg_alter = 0.15,
    snacks_indent_scope_fg_alter = 0.18,
    tabline_fg_alter = 0.5,
    visual_bg_alter = -0.2,
    winseparator_alter = 0.4,
  },
  ["base46-jellybeans"] = {
    cursor_fg = "#ffa560",
    cursorline_alter = 0.6,
    cursorline_fg_alter = "WinSeparator",
    dapstopped_bg_alter = 0.2,
    fzflua_border_fg_alter = 1.5,
    fzflua_file_part_fg = 0.7,
    linenr_fg_alter = 0.15,
    noice_cmdline_fg_alter = 0.65,
    nontext_fg_alter = 2.5,
    normal_keyword_alter = 0.14,
    panel_sidebar_bg_alter = 4,
    pmenu_bg_alter = 1.5,
    pmenu_sp_alter = 3,
    quickfixline_header_fg_alter = 1.75,
    render_markdown_code_bg_alter = 0.9,
    render_markdown_code_inline_bg_alter = 0.15,
    render_markdown_code_inline_fg_alter = 0.05,
    tabline_fg_alter = 0.55,
    trouble_indent_fg_alter = 0.7,
    winbar_fg_alter = 1.5,
    winbar_right_block_bg_alter = 1,
    winseparator_alter = 0.9,
  },
  ["base46-material-lighter"] = {
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
    fzflua_file_part_fg = -0.4,
    linenr_fg_alter = -0.04,
    lsp_reference_read_bg_alter = { from = "LspReferenceRead", attr = "bg", alter = 0.26 },
    lsp_reference_text_bg_alter = { from = "LspReferenceText", attr = "bg" },
    lsp_reference_write_bg_alter = { from = "LspReferenceWrite", attr = "bg", alter = 0.26 },
    my_code_usage_bg_alter = 3.5,
    my_code_usage_fg_alter = 0.7,
    nontext_fg_alter = -0.45,
    pmenu_fg_alter = -0.2,
    pmenu_sel_bg_alter = -0.05,
    snacks_indent_scope_fg_alter = 0.7,
    trouble_indent_fg_alter = 0.5,
    winseparator_alter = -0.16,
  },
  ["base46-melange"] = {
    blink_ghost_text_fg_alter = -0.4,
    cursor_fg = "#ece1d7",
    cursorline_alter = 0.06,
    dapstopped_bg_alter = 0.15,
    fold_fg = 0.2,
    fzflua_file_part_fg = 0.7,
    linenr_fg_alter = 0.05,
    noice_cmdline_fg_alter = 0.6,
    normal_keyword_alter = 0.1,
    pmenu_bg_alter = 0.5,
    pmenu_sp_alter = 1.5,
    render_markdown_code_bg_alter = 0.25,
    snacks_indent_scope_fg_alter = 0.13,
    winbar_fg_alter = 1.5,
    trouble_indent_fg_alter = 0.6,
    winbar_right_block_bg_alter = 0.35,
    winseparator_alter = 0.3,
  },
  ["base46-oxocarbon"] = {
    blink_cmp_label_kind_fg_alter = 0.75,
    comment_fg_alter = 0.78,
    cursor_fg = "#ffffff",
    cursorline_alter = 0.5,
    cursorline_fg_alter = "WinSeparator",
    dapstopped_bg_alter = 0.2,
    fold_fg = 0.18,
    linenr_fg_alter = -0.05,
    noice_cmdline_fg_alter = 1,
    nontext_fg_alter = 2.7,
    normal_keyword_alter = 0.18,
    pmenu_bg_alter = 1.3,
    pmenu_sp_alter = 3.5,
    render_markdown_code_bg_alter = 0.85,
    render_markdown_code_inline_bg_alter = 0.16,
    statusline_bg_alter = -0.08,
    tabline_fg_alter = 0.6,
    trouble_indent_fg_alter = 1.65,
    winbar_right_block_bg_alter = 0.6,
    winseparator_alter = 1,
  },
  ["base46-seoul256_dark"] = {
    blink_cmp_label_kind_fg_alter = 0.6,
    blink_ghost_text_fg_alter = -0.45,
    comment_fg_alter = 0.32,
    cursor_fg = "#d75f87",
    cursorline_alter = 0.03,
    dapstopped_bg_alter = 0.2,
    fold_bg = 0,
    fold_fg = 0.1,
    fzflua_border_fg_alter = 0.2,
    fzflua_file_part_fg = 0.7,
    linenr_fg_alter = 0.07,
    my_code_usage_bg_alter = -0.4,
    my_code_usage_fg_alter = -0.02,
    noice_cmdline_fg_alter = 0.4,
    nontext_fg_alter = 0.8,
    normal_keyword_alter = 0.12,
    outline_indent_fg_alter = 0.15,
    pmenu_bg_alter = 0.2,
    pmenu_sel_bg_alter = 0.13,
    pmenu_sp_alter = 1,

    quickfixline_header_bg_alter = 0.2,
    quickfixline_header_fg_alter = 1,
    quickfixline_linenr_fg_alter = 0.2,
    quickfixline_sp_alter = 0.4,

    render_markdown_code_bg_alter = 0.08,
    render_markdown_code_inline_bg_alter = 0.04,
    snacks_notifier_border_error_fg = -0.1,
    snacks_notifier_border_warn_fg = -0.4,
    tabline_fg_alter = 0.2,
    trouble_indent_fg_alter = 0.2,
    winbar_right_block_bg_alter = 0.07,
    winseparator_alter = 0.08,
    winbar_fg_alter = 1.1,

    difffile_fg_alter = 0.05,
    difffile_bg_alter = -0.5,

    difftext_fg_alter = 0.2,
    difftext_bg_alter = 0.3,

    delta_plus_fg_alter = 1.2,
    delta_minus_fg_alter = 1.5,
  },
  ["base46-zenburn"] = {
    blink_cmp_label_kind_fg_alter = 0.7,
    blink_ghost_text_fg_alter = -0.55,
    comment_fg_alter = 0.38,
    cursor_fg = "#f3eadb",
    cursorline_alter = 0.04,
    dapstopped_bg_alter = 0.15,
    fold_bg = 0,
    fzflua_border_fg_alter = 0.25,
    my_code_usage_bg_alter = -0.4,
    my_code_usage_fg_alter = 0.1,
    nontext_fg_alter = 0.8,
    normal_keyword_alter = 0.1,
    pmenu_bg_alter = 0.2,
    pmenu_sp_alter = 1,
    statusline_bg_alter = -0.01,

    quickfixline_header_bg_alter = 0.2,
    quickfixline_header_fg_alter = 1.3,
    quickfixline_linenr_fg_alter = 0.2,
    quickfixline_sp_alter = 0.4,

    render_markdown_code_bg_alter = 0.07,
    render_markdown_code_inline_bg_alter = 0.04,
    snacks_indent_scope_fg_alter = 0.11,
    snacks_notifier_border_error_fg = -0.1,
    snacks_notifier_border_warn_fg = -0.4,
    tabline_fg_alter = 0.25,
    trouble_indent_fg_alter = 0.2,
    winbar_right_block_bg_alter = 0.15,
    winseparator_alter = 0.12,
    winbar_fg_alter = 1.1,

    difffile_bg_alter = -0.55,
    difffile_fg_alter = -0.1,

    difftext_fg_alter = 0.6,
    difftext_bg_alter = 0.4,

    delta_plus_fg_alter = 1.2,
    delta_minus_fg_alter = 1.5,
  },
  ["github_dark"] = {
    comment_fg_alter = 1,
    linenr_fg_alter = -0.05,
    pmenu_bg_alter = 1.6,
    statusline_fg_alter = 0.8,
    winbar_bg_alter = 0.8,
    winbar_right_block_bg_alter = 0.8,
    winseparator_alter = 1.3,
  },
  ["gruvbox-material"] = {
    blink_cmp_label_kind_fg_alter = 0.7,
    comment_fg_alter = 0.5,
    pmenu_bg_alter = 0.4,
    render_markdown_code_bg_alter = 0.25,
    statusline_fg_alter = 0.7,
    winbar_fg_alter = 1.1,
    winbar_right_block_bg_alter = -0.6,
    winbar_right_block_fg_alter = -0.05,
    winseparator_alter = 0.2,
  },
  ["night-owl"] = {
    comment_fg_alter = 1.2,
    fold_fg = 0.3,
    linenr_fg_alter = 0.6,
    quickfixline_linenr_fg_alter = 0.3,
    statusline_fg_alter = 2,
    winbar_fg_alter = 3,
  },
  ["techbase"] = {
    comment_fg_alter = 0.68,
    linenr_fg_alter = -0.05,
    fold_fg = 0.3,
    fzflua_file_part_fg = 0.6,
    pmenu_bg_alter = 0.9,
    render_markdown_code_bg_alter = 0.7,
    statusline_fg_alter = 0.85,
    winseparator_alter = 0.58,
  },
  ["jellybeans"] = {
    comment_fg_alter = 0.75,
    cursor_fg = "#ffa560",
    cursorline_alter = 2.5,
    cursorline_fg_alter = "WinSeparator",
    dapstopped_bg_alter = 0.2,
    fzflua_border_fg_alter = 1.5,
    fzflua_file_part_fg = 0.65,
    noice_cmdline_fg_alter = 0.65,
    normal_keyword_alter = 0.14,
    panel_sidebar_bg_altcer = 4,
    pmenu_bg_alter = 1.3,
    pmenu_sp_alter = 3,
    quickfixline_header_fg_alter = 1.75,
    quickfixline_linenr_fg_alter = 0.5,
    render_markdown_code_bg_alter = 1,
    render_markdown_code_inline_bg_alter = 0.15,
    render_markdown_code_inline_fg_alter = 0.05,
    tabline_fg_alter = 0.55,
    trouble_indent_fg_alter = 0.7,
    winbar_fg_alter = 1.5,
    winseparator_alter = 1,
  },
  ["lackluster"] = {
    Directory = { fg = "#7788aa", bg = "NONE" },
    bqf_keyword = "String",
    comment_fg_alter = 0.5,
    cursor_fg = "#deeeed",
    cursorline_alter = 0.27,
    fold_bg = 0,
    fold_fg = 0.18,
    fzflua_border_fg_alter = 2,
    fzflua_file_part_fg = 1.2,
    linenr_fg_alter = 0.15,
    lsp_reference_read_bg_alter = { from = "Function", attr = "fg", alter = -0.6 },
    lsp_reference_text_bg_alter = { from = "Normal", attr = "bg", alter = 1.2 },
    lsp_reference_write_bg_alter = { from = "Function", attr = "fg", alter = -0.6 },
    my_code_usage_bg_alter = -0.35,
    my_code_usage_fg_alter = -0.1,
    noice_cmdline_fg_alter = 0.6,
    normal_keyword_alter = 0.4,
    outline_indent_fg_alter = 0.15,
    pmenu_bg_alter = 2.2,
    pmenu_sp_alter = 5,

    quickfixline_sp_alter = 0.45,

    render_markdown_code_bg_alter = 1.35,
    render_markdown_code_inline_bg_alter = 0.35,
    snacks_notifier_info_fg = 1.6,
    trouble_indent_fg_alter = 0.5,
    visual_bg_alter = 0.05,
    winbar_fg_alter = 1.5,
    winbar_right_block_bg_alter = 1.2,
    winseparator_alter = 1.4,

    diffadd_fg_alter = -0.2,
    diffadd_bg_alter = 0.18,

    diffchange_fg_alter = -0.3,
    diffchange_bg_alter = 0.18,

    diffdelete_fg_alter = -0.3,
    diffdelete_bg_alter = 0.2,
  },
  ["minimal"] = {
    blink_ghost_text_fg_alter = -0.4,
    cursor_fg = "#ece1d7",
    cursorline_alter = 0.05,
    dapstopped_bg_alter = 0.15,
    fold_fg = 0.3,
    fzflua_file_part_fg = 0.7,
    linenr_fg_alter = -0.1,
    noice_cmdline_fg_alter = 0.6,
    normal_keyword_alter = 0.1,
    pmenu_bg_alter = 1,
    pmenu_sp_alter = 2,
    render_markdown_code_bg_alter = 0.23,
    snacks_indent_scope_fg_alter = 0.13,
    statusline_bg_alter = -0.08,
    tabline_fg_alter = 0.3,
    trouble_indent_fg_alter = 0.6,
    winbar_fg_alter = 1.2,
    winbar_right_block_bg_alter = 0.5,
    winbar_right_block_fg_alter = 0.1,
    winseparator_alter = 0.72,
  },
  ["nightingale"] = {
    comment_fg_alter = 0.6,
    fold_fg = 0.15,
    nontext_fg_alter = -0.4,
    quickfixline_linenr_fg_alter = 0.4,
    statusline_fg_alter = 0.7,
    winbar_fg_alter = 1.2,
    winbar_right_block_bg_alter = -0.5,
    winbar_right_block_fg_alter = -0.04,
    winseparator_alter = 0.45,
  },
  ["neogotham"] = {
    comment_fg_alter = 0.8,
    cursor_fg = "#98d1ce",
    cursorline_alter = 0.05,
    dapstopped_bg_alter = 0.15,
    fold_fg = 0.18,
    fzflua_border_fg_alter = 2.5,
    linenr_fg_alter = -0.05,
    noice_cmdline_fg_alter = 0.6,
    normal_keyword_alter = 0.25,
    pmenu_bg_alter = 2.3,
    pmenu_sp_alter = 6,
    render_markdown_code_bg_alter = 1.5,
    trouble_indent_fg_alter = 0.6,
    winbar_right_block_bg_alter = 1.1,
    winseparator_alter = 2,
  },
  ["oxocarbon"] = {
    blink_cmp_label_kind_fg_alter = 0.75,
    comment_fg_alter = 0.8,
    cursor_fg = "#ffffff",
    cursorline_alter = 0.5,
    cursorline_fg_alter = "WinSeparator",
    dapstopped_bg_alter = 0.2,
    fold_fg = 0.5,
    fzflua_file_part_fg = 0.7,
    hovered_cursorline_fg_alter = 0.6,
    noice_cmdline_fg_alter = 0.7,
    normal_keyword_alter = 0.18,
    pmenu_bg_alter = 1.3,
    pmenu_sp_alter = 3.5,
    quickfixline_linenr_fg_alter = 0.35,
    render_markdown_code_bg_alter = 1,
    render_markdown_code_inline_bg_alter = 0.16,
    statusline_bg_alter = -0.05,
    tabline_fg_alter = 0.6,
    trouble_indent_fg_alter = 1.65,
    winseparator_alter = 0.9,
  },
  ["rose-pine"] = {
    comment_fg_alter = 0.6,
    fold_fg = 0.25,
    fzflua_file_part_fg = 1.2,
    hovered_cursorline_fg_alter = 0.6,
    linenr_fg_alter = 0.1,
    nontext_fg_alter = -0.2,
    pmenu_bg_alter = 1,
    quickfixline_linenr_fg_alter = 0.65,
    render_markdown_code_bg_alter = 0.5,
    statusline_bg_alter = -0.05,
    winbar_right_block_bg_alter = -0.35,
    winbar_right_block_fg_alter = 0.12,
    winseparator_alter = 0.7,
  },
  ["rose-pine-moon"] = {
    comment_fg_alter = 0.6,
    fold_fg = 0.25,
    hovered_cursorline_fg_alter = 0.6,
    linenr_fg_alter = 0.1,
    pmenu_bg_alter = 0.5,
    quickfixline_linenr_fg_alter = 0.35,
    render_markdown_code_bg_alter = 0.5,
    statusline_bg_alter = -0.05,
    statusline_fg_alter = 0.55,
    winbar_right_block_bg_alter = -0.4,
    winbar_right_block_fg_alter = 0.1,
    winseparator_alter = 0.3,
  },
  ["tokyonight-night"] = {
    blink_ghost_text_fg_alter = -0.5,
    comment_fg_alter = 0.6,
    cursor_fg = "#ece1d7",
    cursorline_alter = 0.05,
    dapstopped_bg_alter = 0.15,
    fold_fg = 0.2,
    fzflua_file_part_fg = 0.6,
    linenr_fg_alter = 0.05,
    noice_cmdline_fg_alter = 0.8,
    normal_keyword_alter = 0.1,
    pmenu_bg_alter = 0.9,
    pmenu_sp_alter = 2,
    quickfixline_linenr_fg_alter = 0.5,
    render_markdown_code_bg_alter = 0.65,
    snacks_indent_scope_fg_alter = 0.13,
    statusline_bg_alter = -0.05,
    trouble_indent_fg_alter = 0.6,
    winbar_fg_alter = 1.3,
    winbar_right_block_bg_alter = -0.63,
    winbar_right_block_fg_alter = -0.3,
    winseparator_alter = 0.7,
  },
  ["tokyonight-storm"] = {
    blink_ghost_text_fg_alter = -0.55,
    comment_fg_alter = 0.6,
    fzflua_file_part_fg = 0.6,
    pmenu_bg_alter = 0.4,
    quickfixline_linenr_fg_alter = 0.2,
    render_markdown_code_bg_alter = 0.23,
    winbar_fg_alter = 1,
    winbar_right_block_fg_alter = -0.15,
  },
  ["vscode_modern"] = {
    Directory = { fg = "#569cd6", bg = "NONE" },
    cmpdocnormal_fg_alter = 0.1,
    comment_fg_alter = 0.6,
    cursor_fg = "#fa1919",
    cursorline_alter = 0.1,
    dapstopped_bg_alter = 0.2,
    fold_bg = 0,
    fzflua_border_fg_alter = 0.7,
    hovered_cursorline_fg_alter = 0.35,
    linenr_fg_alter = -0.02,
    lsp_reference_read_bg_alter = { from = "LspReferenceRead", attr = "bg", alter = -0.1 },
    lsp_reference_text_bg_alter = { from = "LspReferenceText", attr = "bg", alter = -0.2 },
    lsp_reference_write_bg_alter = { from = "LspReferenceWrite", attr = "bg", alter = -0.1 },
    noice_cmdline_fg_alter = 0.6,
    nontext_fg_alter = -0.4,
    pmenu_bg_alter = 0.72,
    quickfixline_linenr_fg_alter = 0.45,
    render_markdown_code_bg_alter = 0.4,
    snacks_indent_scope_fg_alter = 0.15,
    winbar_fg_alter = 1.2,
    winbar_right_block_bg_alter = -0.55,
    winseparator_alter = 0.5,
  },
  ["xenos"] = {
    fold_fg = 0.35,
    fzflua_file_part_fg = 0.5,
    linenr_fg_alter = -0.02,
    pmenu_fg_alter = -0.05,
    quickfixline_linenr_fg_alter = 0.15,
    render_markdown_code_bg_alter = 0.45,
    statusline_fg_alter = 0.8,
    visual_bg_alter = -0.32,
    winbar_fg_alter = 1.3,
    winbar_right_block_bg_alter = -0.65,
    winbar_right_block_fg_alter = -0.3,
    winseparator_alter = 0.57,
  },
  ["y9nika"] = {
    comment_fg_alter = 0.85,
    fold_fg = 0.25,
    fzflua_file_part_fg = 0.6,
    linenr_fg_alter = -0.05,
    pmenu_bg_alter = 1.8,
    render_markdown_code_bg_alter = 1.4,
    statusline_fg_alter = 0.8,
    winbar_right_block_bg_alter = 0.6,
    winbar_right_block_fg_alter = -0.25,
    winseparator_alter = 1.1,
  },
  ["zenburn"] = {
    comment_fg_alter = 0.5,
    fold_fg = 0.15,
    fzflua_file_part_fg = 0.7,
    linenr_fg_alter = 0.02,
    noice_cmdline_fg_alter = 0.65,
    pmenu_bg_alter = 0.25,
    pmenu_sp_alter = 2,
    quickfixline_linenr_fg_alter = 0.04,
    render_markdown_code_bg_alter = 0.08,
    render_markdown_code_inline_bg_alter = 0.05,
    render_markdown_code_inline_fg_alter = -0.05,
    statusline_bg_alter = -0.02,
    statusline_fg_alter = 0.45,
    winbar_bg_alter = 0.5,
    winbar_fg_alter = 0.8,
    winbar_right_block_fg_alter = -0.2,
    winseparator_alter = 0.1,
  },
}

local function update_base_colors(theme)
  local cols = vim.deepcopy(base_colors)
  return vim.tbl_deep_extend("force", cols, update_col_colorscheme[theme] or {})
end

local general_overrides = function()
  local H = require "r.settings.highlights"
  local UIPallette = require("r.utils").uisec

  local dark_green = H.tint(UIPallette.palette.green, 0.3)
  local dark_yellow = H.tint(UIPallette.palette.bright_yellow, 0.3)
  local dark_red = H.tint(UIPallette.palette.dark_red, 0.3)

  local colors = update_base_colors(RUtils.config.colorscheme)

  H.all {
    -- ╔═════════════════════════════════════════════════════════╗
    -- ║                          BASE                           ║
    -- ╚═════════════════════════════════════════════════════════╝
    { FoldColumn = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 0.4 } } },
    { NormalNC = { inherit = "Normal" } },
    { FoldColumn1 = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 1 } } },
    { ColorColumn = { bg = { from = "Normal", attr = "bg" } } },
    { ErrorMsg = { bg = "NONE" } },

    { Directory = colors.Directory },

    { EndOfBuffer = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 0.2 } } },
    { SignColumn = { bg = "NONE" } },
    { NonText = { fg = { from = "Keyword", attr = "fg", alter = colors.nontext_fg_alter }, bg = "NONE" } },
    { WinSeparator = { fg = { from = "Normal", attr = "bg", alter = colors.winseparator_alter }, bg = "NONE" } },

    {
      LineNr = { bg = "NONE", fg = { from = "WinSeparator", attr = "fg", alter = colors.linenr_fg_alter }, bold = true },
    },
    { LineNrAbove = { link = "LineNr" } },
    { LineNrBelow = { link = "LineNr" } },
    { Comment = { fg = { from = "LineNr", attr = "fg", alter = colors.comment_fg_alter }, italic = true } },
    { Type = { italic = true, bold = true } },
    { ["@comment"] = { inherit = "Comment" } },

    {
      CursorLine = {
        bg = H.darken(H.get(colors.cursorline_fg_alter, "fg"), colors.cursorline_alter, H.get("Normal", "bg")),
      },
    },
    {
      CursorLineNr = {
        fg = { from = "Keyword", attr = "fg" },
        bg = { from = "CursorLine", attr = "bg" },
        bold = true,
      },
    },
    {
      Visual = {
        bg = H.tint(H.darken(H.get("String", "fg"), 0.3, H.get("Normal", "bg")), colors.visual_bg_alter),
        fg = "NONE",
      },
    },

    {
      StatusLine = {
        fg = { from = "WinSeparator", attr = "fg", alter = colors.statusline_fg_alter },
        bg = { from = "WinSeparator", attr = "fg", alter = colors.statusline_bg_alter },
        reverse = false,
      },
    },

    {
      Pmenu = {
        fg = { from = "Normal", attr = "fg", alter = colors.pmenu_fg_alter },
        bg = { from = "Normal", attr = "bg", alter = colors.pmenu_bg_alter },
        sp = { from = "Normal", attr = "bg", alter = colors.pmenu_sp_alter },
        reverse = false,
      },
    },
    { PmenuSel = { fg = "NONE", bg = "NONE", bold = true, underline = true, reverse = false } },
    { PmenuFloatBorder = { bg = { from = "Pmenu", attr = "bg" }, fg = { from = "Pmenu", attr = "bg" } } },
    { PmenuThumb = { bg = { from = "Pmenu", attr = "bg", alter = colors.pmenu_thumb_bg_alter } } },

    {
      NormalFloat = {
        fg = { from = "Pmenu", attr = "fg", alter = colors.normal_float_fg_alter },
        bg = { from = "Pmenu", attr = "bg", alter = -0.1 },
        reverse = false,
      },
    },
    {
      FloatBorder = {
        fg = { from = "NormalFloat", attr = "bg" },
        bg = { from = "NormalFloat", attr = "bg" },
      },
    },
    {
      FloatTitle = {
        fg = { from = "Normal", attr = "bg", alter = colors.float_title_fg_alter },
        bg = { from = "Keyword", attr = "fg", alter = colors.float_title_bg_alter },
        bold = true,
      },
    },
    {
      FloatCursorline = {
        fg = "NONE",
        bg = { from = "NormalFloat", attr = "bg", alter = 0.2 },
      },
    },

    { NormalKeyword = { fg = H.darken(H.get("Keyword", "fg"), colors.normal_keyword_alter, H.get("Normal", "bg")) } },
    {
      NormalKeyword = {
        bg = { from = "NormalKeyword", attr = "fg" },
        fg = { from = "NormalKeyword", attr = "fg", alter = 3 },
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
        fg = { from = "NormalBoxComment", attr = "bg", alter = 0.3 },
        bg = { from = "NormalBoxComment", attr = "bg" },
      },
    },
    {
      VisualBoxComment = {
        fg = { from = "Normal", attr = "fg", alter = colors.normal_float_fg_alter },
        bg = { from = "Keyword", attr = "fg", alter = -0.2 },
      },
    },

    {
      TabLine = {
        bg = { from = "Pmenu", attr = "bg", alter = colors.tabline_bg_alter },
        reverse = false,
      },
    },

    {
      TabLine = {
        fg = { from = "TabLine", attr = "bg", alter = colors.tabline_fg_alter },
        reverse = false,
      },
    },

    { Dark_red = { fg = dark_red } },
    { Dark_yellow = { fg = dark_yellow } },

    { CurSearch = colors.CurSearch },
    { Search = colors.Search },
    { IncSearch = { inherit = "CurSearch" } },
    { Cursor = { bg = colors.cursor_fg, reverse = false } },
    { TermCursor = { inherit = "Cursor" } },
    { Substitute = { inherit = "Search" } },

    {
      Folded = {
        fg = { from = "LineNr", attr = "fg", alter = colors.fold_fg },
        -- bg = { from = "Normal", attr = "bg", alter = fold_bg },
        bg = "NONE",
      },
    },
    {
      FoldedBackup = {
        fg = { from = "Normal", attr = "bg", alter = 1.5 },
        bg = { from = "Normal", attr = "bg", alter = 0.7 },
      },
    },
    -- Disable the Folded background using the `FoldedMarkdown` group.
    -- Check `windowdim.lua` for details.
    { FoldedMarkdown = { fg = { from = "Normal", attr = "bg" }, bg = "NONE" } },
    { FoldedSign = { inherit = "Folded", bg = "NONE" } },

    -- ╔═════════════════════════════════════════════════════════╗
    -- ║                          SPELL                          ║
    -- ╚═════════════════════════════════════════════════════════╝
    { SpellBad = { undercurl = true, bg = "NONE", fg = "NONE", sp = "green" } },
    { SpellRare = { undercurl = true } },

    -- ╔═════════════════════════════════════════════════════════╗
    -- ║                       DIFF COLOR                        ║
    -- ╚═════════════════════════════════════════════════════════╝
    {
      diffFile = {
        fg = { from = "Directory", attr = "fg", alter = colors.difffile_bg_alter },
        bg = { from = "Directory", attr = "fg", alter = colors.difffile_fg_alter },
        bold = true,
      },
    },

    -- Setting darken: gunakan paramater (setting_color, ukuran, base_color)
    {
      -- "ukuran" -> semakin tinggi semakin terang, sebaliknya semakin kecil semakin gelap
      diffAdd = {
        fg = H.tint(dark_green, colors.diffadd_fg_alter),
        bg = H.tint(H.darken(dark_green, colors.diffadd_bg_alter, H.get("Normal", "bg")), -0.1),
        reverse = false,
      },
    },
    {
      diffChange = {
        fg = H.tint(dark_yellow, colors.diffchange_fg_alter),
        bg = H.tint(H.darken(dark_yellow, colors.diffchange_bg_alter, H.get("Normal", "bg")), -0.1),
        reverse = false,
      },
    },
    {
      diffDelete = {
        fg = H.tint(dark_red, colors.diffdelete_fg_alter),
        bg = H.tint(H.darken(dark_red, colors.diffdelete_bg_alter, H.get("Normal", "bg")), -0.1),
        reverse = false,
      },
    },
    {
      diffText = {
        fg = { from = "diffChange", attr = "fg", alter = colors.difftext_fg_alter },
        bg = { from = "diffChange", attr = "bg", alter = colors.difftext_bg_alter },
        reverse = false,
      },
    },

    {
      deltaPlus = {
        fg = H.tint(H.darken(dark_green, colors.delta_plus_fg_alter, H.get("Normal", "bg")), -0.1),
        bg = H.tint(H.darken(dark_green, colors.delta_plus_bg_alter, H.get("Normal", "bg")), -0.1),
        bold = true,
      },
    },
    {
      deltaMinus = {
        fg = H.tint(H.darken(dark_red, colors.delta_minus_fg_alter, H.get("Normal", "bg")), -0.1),
        bg = H.tint(H.darken(dark_red, colors.delta_minus_bg_alter, H.get("Normal", "bg")), -0.1),
        bold = true,
      },
    },

    { DiffAdded = { inherit = "diffAdd" } },
    { DiffChange = { inherit = "diffChange" } },
    { DiffDelete = { inherit = "diffDelete" } },

    { diffChanged = { inherit = "diffChange" } },
    { diffRemoved = { inherit = "diffDelete" } },

    { GitSignsAdd = { bg = "NONE", fg = dark_green } },
    { GitSignsChange = { bg = "NONE", fg = dark_yellow } },
    { GitSignsDelete = { bg = "NONE", fg = dark_red } },

    { GitSignsAddInline = { inherit = "deltaPlus" } },
    { GitSignsDeleteInline = { inherit = "deltaMinus" } },

    { MiniDiffSignAdd = { bg = "NONE", fg = dark_green } },
    { MiniDiffSignChange = { bg = "NONE", fg = dark_yellow } },
    { MiniDiffSignDelete = { bg = "NONE", fg = dark_red } },

    { NeogitDiffAdd = { link = "diffAdd" } },
    { NeogitDiffAddHighlight = { link = "diffAdd" } },
    { NeogitDiffDelete = { link = "diffDelete" } },
    { NeogitDiffDeleteHighlight = { link = "diffDelete" } },

    { DiffText = { link = "diffText" } },

    -- ╔═════════════════════════════════════════════════════════╗
    -- ║                       ERROR COLOR                       ║
    -- ╚═════════════════════════════════════════════════════════╝

    { ErrorMsg = { bg = "NONE", fg = { from = "diffDelete", attr = "fg", alter = 0.5 } } },
    { Error = { bg = "NONE", fg = { from = "diffDelete", attr = "fg", alter = 0.3 } } },

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
    -- ║                     SEMANTIC TOKENS                     ║
    -- ╚═════════════════════════════════════════════════════════╝
    -- { ["@lsp.type.parameter"] = { italic = true, bold = true, fg = { from = "Normal" } } },
    -- { ["@lsp.type.selfKeyword"] = { fg = { from = "ErrorMsg", attr = "fg", alter = 0.2 } } },
    -- { ["@lsp.type.comment"] = { fg = "NONE" } },

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

    { LspKindSnippet = { fg = { from = "Keyword", attr = "fg" } } },
    {
      LspReferenceText = {
        bg = "#6A5ACD", -- Slate Blue
        fg = "#ffffff", -- White text for strong contrast
        underline = false,
        reverse = false,
        undercurl = false,
      },
    },
    {
      LspReferenceWrite = {
        bg = "#FF4500", -- OrangeRed (menonjol untuk write)
        fg = "#000000", -- Black text for contrast
        underline = false,
        reverse = false,
        undercurl = false,
      },
    },
    {
      LspReferenceRead = {
        bg = "#32CD32", -- Lime Green
        fg = "#000000",
        underline = false,
        reverse = false,
        undercurl = false,
      },
    },

    -- ╔═════════════════════════════════════════════════════════╗
    -- ║                       TREESITTER                        ║
    -- ╚═════════════════════════════════════════════════════════╝
    -- { ["@keyword.return"] = { italic = true, fg = { from = "Keyword" } } },
    -- { ['@type.qualifier'] = { inherit = '@keyword', italic = true } },
    -- { ["@variable"] = { fg =  { from = "Directory", attr = "fg", alter = -0.1 } } },
    -- { ["@parameter"] = { italic = true, bold = true, fg = "NONE" } },
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
    -- ║                   CREATED HIGHLIGHTS                    ║
    -- ╚═════════════════════════════════════════════════════════╝
    {
      HoveredCursorline = { bg = { from = "NormalKeyword", attr = "bg", alter = colors.hovered_cursorline_fg_alter } },
    },
    { YankInk = { bg = { from = "DiffDelete", attr = "bg", alter = 0.5 } } },
    { InactiveBorderColorLazy = { fg = { from = "WinSeparator", attr = "fg", alter = 0.2 } } },
    {
      MyCodeUsage = {
        fg = H.tint(H.get("String", "fg"), colors.my_code_usage_fg_alter),
        bg = H.tint(H.darken(H.get("String", "fg"), 0.7, H.get("Normal", "bg")), colors.my_code_usage_bg_alter),
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

    -- WINBAR
    {
      WinBar = {
        fg = { from = "StatusLine", attr = "bg", alter = colors.winbar_fg_alter },
        bg = { from = "StatusLine", attr = "bg" },
        bold = false,
      },
    },
    {
      WinBarNC = {
        fg = { from = "WinBar", attr = "fg" },
        bg = { from = "StatusLine", attr = "bg" },
        bold = false,
      },
    },
    {
      WinBarRightBlock = {
        fg = { from = "Keyword", attr = "fg", alter = colors.winbar_right_block_fg_alter },
        -- bg = H.tint(H.darken(H.get("Keyword", "fg"), 0.1, H.get("Normal", "bg")), colors.winbar_right_block_bg_alter),
        bg = { from = "Keyword", attr = "fg", alter = colors.winbar_right_block_bg_alter },
        bold = true,
      },
    },

    -- ╔═════════════════════════════════════════════════════════╗
    -- ║                      PLUGIN COLORS                      ║
    -- ╚═════════════════════════════════════════════════════════╝

    -- ╭────────╮
    -- │ CMPDOC │
    -- ╰────────╯
    -- Ditaruh disini untuk sementara waktu, karena blink mengadopsi color
    -- `CmpDocFloatBorder` ini
    {
      CmpDocNormal = {
        fg = { from = "Keyword", attr = "fg", alter = colors.cmpdocnormal_fg_alter },
        bg = { from = "Pmenu", attr = "bg", alter = 0.15 },
      },
    },
    { CmpDocFloatBorder = { inherit = "CmpDocNormal", fg = { from = "CmpDocNormal", attr = "bg" } } },

    --  ───────────────────────────────[ BEACON ]──────────────────────────────
    { BeaconDefault = { bg = colors.cursor_fg } },

    --  ───────────────────────────────[ NOICE ]───────────────────────────────
    {
      NoiceCmdline = { fg = { from = "StatusLine", attr = "fg", alter = colors.noice_cmdline_fg_alter }, bg = "NONE" },
    },
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
    {
      BlinkCmpGhostText = {
        fg = { from = "NoiceCmdline", attr = "fg", alter = colors.blink_ghost_text_fg_alter },
        bg = "NONE",
      },
    },
    {
      BlinkCmpDocSeparator = {
        fg = { from = "CmpDocNormal", attr = "bg", alter = 0.15 },
        bg = { from = "CmpDocNormal", attr = "bg" },
      },
    },
    {
      BlinkCmpLabelMatch = { fg = { from = "diffDelete", attr = "fg", alter = colors.blink_cmp_label_match_fg_alter } },
    },
    { BlinkCmpLabelKind = { fg = { from = "Pmenu", attr = "bg", alter = colors.blink_cmp_label_kind_fg_alter } } },

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
    -- {
    --   CmpItemKindText = {
    --     inherit = "LspKindText",
    --     fg = { from = "LspKindText", attr = "fg", alter = 0.1 },
    --     bg = { from = "LspKindText", attr = "fg", alter = -0.65 },
    --   },
    -- },
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
    { FzfLuaNormal = { bg = { from = "NormalFloat", attr = "bg" } } },
    {
      FzfLuaBorder = {
        fg = { from = "FzfLuaNormal", attr = "bg" },
        bg = { from = "FzfLuaNormal", attr = "bg" },
      },
    },

    {
      FzfLuaBufLineNr = {
        fg = { from = "FzfLuaNormal", attr = "bg", alter = colors.fzflua_buf_linenr_bg_alter },
        bg = "NONE",
      },
    },

    { FzfLuaTitle = { inherit = "FloatTitle" } },

    { FzfLuaFilePart = { fg = H.darken(H.get("Keyword", "fg"), colors.fzflua_file_part_fg, H.get("Normal", "bg")) } },
    { FzfLuaDirPart = { inherit = "FzfLuaFilePart" } },

    { FzfLuaHeaderText = { fg = { from = "FzfLuaFilePart", attr = "fg", alter = -0.22 } } },

    { FzfLuaFzfMatch = { fg = { from = "BlinkCmpLabelMatch", attr = "fg", alter = 0.3 }, bg = "NONE" } },
    { FzfLuaFzfMatchFuzzy = { fg = { from = "FzfLuaFzfMatch", attr = "fg", alter = -0.1 }, bg = "NONE" } },

    {
      FzfLuaSel = {
        fg = { from = "FzfLuaFilePart", attr = "fg", alter = 0.35 },
        bg = { from = "FzfLuaNormal", attr = "bg" },
        sp = { from = "FzfLuaFilePart", attr = "fg", alter = colors.fzflua_sel_sp_fg_alter },
        underline = true,
        bold = true,
      },
    },

    -- ╭─────────╮
    -- │ PREVIEW │
    -- ╰─────────╯
    {
      FzfLuaPreviewNormal = {
        inherit = "FzfLuaNormal",
        bg = { from = "FzfLuaNormal", attr = "bg", alter = -0.05 },
      },
    },
    {
      FzfLuaPreviewBorder = {
        fg = { from = "FzfLuaPreviewNormal", attr = "bg" },
        bg = { from = "FzfLuaPreviewNormal", attr = "bg" },
      },
    },
    { FzfLuaPreviewTitle = { inherit = "FzfLuaTitle" } },
    { FzfLuaScrollBorderFull = { inherit = "PmenuThumb" } },

    { FzfLuaCursorLine = { bg = { from = "FzfLuaBorder", attr = "fg", alter = 0.12 } } },

    {
      FzfLuaCursorLineNr = {
        fg = { from = "Directory", attr = "fg", alter = -0.25 },
        bg = { from = "FzfLuaCursorLine", attr = "bg" },
      },
    },

    --  ─────────────────────────────[ TELESCOPE ]─────────────────────────────
    { TelescopeNormal = { inherit = "FzfLuaNormal" } },
    { TelescopeBorder = { inherit = "FzfLuaBorder" } },
    { TelescopeMatching = { link = "FzfLuaFzfMatch" } },
    { TelescopeTitle = { inherit = "FzfLuaTitle" } },

    { TelescopeSelection = { inherit = "FzfLuaSel" } },
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
    { TelescopePreviewNormal = { inherit = "FzfLuaPreviewNormal" } },
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
    { SnacksPickerMatch = { fg = { from = "FzfLuaFzfMatch", attr = "fg" } } },
    { SnacksPickerManSection = { link = "FzfLuaFzfMatchFuzzy" } },
    { SnacksPickerCursorLine = { link = "FzfLuaCursorLine" } },
    { SnacksPickerPreviewCursorLine = { link = "FzfLuaCursorLine" } },

    { SnacksPickerList = { inherit = "FzfLuaNormal" } },
    { SnacksPickerListBorder = { bg = { from = "FzfLuaNormal", attr = "bg" } } },

    -- Prompt
    { SnacksPickerPrompt = { bg = { from = "NormalFloat", attr = "bg" } } },
    { SnacksPickerListCursorLine = { inherit = "FzfLuaSel", fg = "NONE", bold = true } },

    { SnacksPickerBorder = { link = "FzfLuaBorder" } },
    { SnacksPickerBoxBorder = { link = "FzfLuaBorder" } },
    -- { SnacksPickerInput = { bg = { from = "FzfLuaNormal", attr = "bg" } } },
    { SnacksPickerInputBorder = { link = "FzfLuaBorder" } },

    { SnacksPickerPreview = { link = "FzfLuaPreviewNormal" } },
    { SnacksPickerPreviewBorder = { link = "FzfLuaPreviewBorder" } },

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
    { SnacksIndentScope = { fg = H.darken(dark_yellow, colors.snacks_indent_scope_fg_alter, H.get("Normal", "bg")) } },

    -- ╭─────────────────╮
    -- │ SNACKS NOTIFIER │
    -- ╰─────────────────╯
    -- INFO
    {
      SnacksNotifierInfo = {
        fg = { from = "String", attr = "fg" },
        bg = { from = "Normal", attr = "bg" },
      },
    },
    {
      SnacksNotifierBorderInfo = {
        fg = { from = "SnacksNotifierInfo", attr = "fg", alter = colors.snacks_notifier_border_info_fg },
        bg = { from = "SnacksNotifierInfo", attr = "bg" },
      },
    },
    {
      SnacksNotifierTitleInfo = {
        fg = { from = "Normal", attr = "bg" },
        bg = { from = "SnacksNotifierInfo", attr = "fg", alter = 0.2 },
        bold = true,
      },
    },
    -- WARN
    {
      SnacksNotifierWarn = {
        fg = { from = "Type", attr = "fg" },
        bg = { from = "Normal", attr = "bg" },
      },
    },
    {
      SnacksNotifierBorderWarn = {
        fg = { from = "SnacksNotifierWarn", attr = "fg", alter = colors.snacks_notifier_border_warn_fg },
        bg = { from = "SnacksNotifierWarn", attr = "bg" },
      },
    },
    {
      SnacksNotifierTitleWarn = {
        fg = { from = "Normal", attr = "bg" },
        bg = { from = "SnacksNotifierWarn", attr = "fg", alter = 0.4 },
        bold = true,
      },
    },
    -- ERROR
    {
      SnacksNotifierError = {
        fg = { from = "diffDelete", attr = "fg", alter = colors.snacks_notifier_error_fg },
        bg = { from = "Normal", attr = "bg" },
      },
    },
    {
      SnacksNotifierBorderError = {
        fg = { from = "SnacksNotifierError", attr = "fg", alter = colors.snacks_notifier_border_error_fg },
        bg = { from = "SnacksNotifierError", attr = "bg" },
      },
    },
    {
      SnacksNotifierTitleError = {
        fg = { from = "Normal", attr = "bg" },
        bg = { from = "SnacksNotifierError", attr = "fg", alter = 0.5 },
        bold = true,
      },
    },

    -- ╭─────────────╮
    -- │ SNACKS MISC │
    -- ╰─────────────╯
    { SnacksNotifierHistory = { link = "NormalFloat" } },

    -- ────────────────────────────[ NOTIFY.NVIM ]────────────────────────────
    { NotifyBackground = { bg = { from = "Keyword", attr = "fg" } } },

    -- INFO
    { NotifyINFOBody = { inherit = "SnacksNotifierInfo" } },
    { NotifyINFOBorder = { inherit = "SnacksNotifierBorderInfo", bg = "NONE" } },
    { NotifyINFOTitle = { fg = { from = "SnacksNotifierTitleInfo", attr = "bg" }, bg = "NONE" } },
    { NotifyINFOIcon = { fg = { from = "SnacksNotifierTitleInfo", attr = "bg" }, bg = "NONE" } },
    -- WARN
    { NotifyWARNBody = { inherit = "SnacksNotifierWarn" } },
    { NotifyWARNBorder = { inherit = "SnacksNotifierBorderWarn", bg = "NONE" } },
    { NotifyWARNTitle = { fg = { from = "SnacksNotifierTitleWarn", attr = "bg" }, bg = "NONE" } },
    { NotifyWARNIcon = { fg = { from = "SnacksNotifierTitleWarn", attr = "bg" }, bg = "NONE" } },
    -- ERROR
    { NotifyERRORBody = { inherit = "SnacksNotifierError" } },
    { NotifyERRORBorder = { inherit = "SnacksNotifierBorderError", bg = "NONE" } },
    { NotifyERRORTitle = { fg = { from = "SnacksNotifierTitleError", attr = "bg" }, bg = "NONE" } },
    { NotifyERRORIcon = { fg = { from = "SnacksNotifierTitleError", attr = "bg" }, bg = "NONE" } },

    -- ───────────────────────────────[ OCTO ]────────────────────────────
    {
      OctoStatusColumn = {
        fg = H.darken(H.get("Keyword", "fg"), 0.3, H.get("Error", "fg")),
      },
    },

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
        fg = { from = "Statement", attr = "fg", alter = 0.35 },
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
    { LazygitselectedLineBgColor = { bg = { from = "Keyword", attr = "fg", alter = -0.6 } } },

    --  ────────────────────────────[ BUFFERLINE ]─────────────────────────
    { BufferLineIndicatorSelected = { bg = { from = "ColorColumn" } } },

    --  ────────────────────────────────[ BQF ]────────────────────────────
    { BqfSign = { bg = { from = "ColorColumn", attr = "bg" }, { fg = { from = "Boolean" } } } },
    { BqfPreviewBorder = { fg = { from = colors.bqf_keyword, attr = "fg", alter = -0.5 }, bg = "NONE" } },
    { BqfPreviewThumb = { bg = { from = "BqfPreviewBorder", attr = "fg", alter = 0.2 } } },
    {
      BqfPreviewTitle = {
        fg = { from = colors.bqf_keyword, attr = "fg", alter = 0.1 },
        bg = { from = "BqfPreviewBorder", attr = "fg" },
      },
    },

    --  ───────────────────────────[ TODO-COMMENT ]────────────────────────
    { TodoSignWarn = { bg = "NONE" } },
    { TodoSignFIX = { bg = "NONE" } }, -- for error
    { TodoSignTODO = { bg = "NONE" } },
    { TodoSignNOTE = { bg = "NONE" } },

    --  ───────────────────────────[ MASON ]────────────────────────
    { MasonNormal = { bg = { from = "NormalFloat", attr = "bg" } } },

    --  ──────────────────────────────[ GLANCE ]───────────────────────────
    { GlancePreviewNormal = { bg = "#111231" } },
    { GlancePreviewMatch = { fg = "#012D36", bg = "#FDA50F" } },
    { GlanceListMatch = { fg = dark_red, bg = "NONE" } },
    { GlancePreviewCursorLine = { bg = "#1b1c4b" } },

    --  ─────────────────────────────[ MARKDOWN ]──────────────────────────
    { ["@markup.heading.1.markdown"] = { fg = "#4d85c3", bold = true, italic = true, bg = "NONE" } },
    { ["@markup.heading.2.markdown"] = { fg = "#389674", bold = true, italic = true, bg = "NONE" } },
    { ["@markup.heading.3.markdown"] = { fg = "#b0be1e", bold = true, italic = true, bg = "NONE" } },
    { ["@markup.heading.4.markdown"] = { fg = "#8594c8", bold = true, italic = true, bg = "NONE" } },
    { ["@markup.heading.5.markdown"] = { fg = "#f76328", bold = true, italic = true, bg = "NONE" } },
    { ["@markup.heading.6.markdown"] = { fg = "#fccf3e", bold = true, italic = true, bg = "NONE" } },
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

    { RenderMarkdownCode = { bg = { from = "Normal", attr = "bg", alter = colors.render_markdown_code_bg_alter } } },
    -- code block for org file
    { CodeBlock = { bg = { from = "RenderMarkdownCode", attr = "bg", alter = colors.code_block_fg_alter } } },
    {
      RenderMarkdownCodeInline = {
        fg = { from = "Keyword", attr = "fg", alter = colors.render_markdown_code_inline_fg_alter },
        bg = H.darken(H.get("Keyword", "fg"), colors.render_markdown_code_inline_bg_alter, H.get("Normal", "bg")),
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
        fg = { from = "LineNr", attr = "fg", alter = 0.8 },
        bg = { from = "LineNr", attr = "fg", alter = 0.1 },
      },
    },
    {
      GrugFarResultsMatch = {
        fg = { from = "CurSearch", attr = "bg", alter = 0.3 },
        bg = { from = "CurSearch", attr = "bg", alter = -0.65 },
        bold = true,
      },
    },
    {
      GrugFarResultsNumberLabel = {
        fg = H.darken(H.get("DiagnosticError", "fg"), 0.3, H.get("Normal", "bg")),
        bold = false,
      },
    },

    --  ──────────────────────────────[ RGFLOW ]───────────────────────────
    {
      RgFlowHeadLine = {
        bg = { from = "NormalKeyword", attr = "bg", alter = 0.1 },
        fg = { from = "NormalKeyword", attr = "bg", alter = 0.1 },
      },
    },
    {
      RgFlowHead = {
        fg = { from = "Keyword", attr = "fg", alter = 0.5 },
        bg = { from = "RgFlowHeadLine" },
        bold = true,
      },
    },
    {
      RgFlowInputBg = {
        fg = { from = "RgFlowHeadLine", attr = "bg", alter = 2 },
        bg = { from = "RgFlowHeadLine", attr = "bg", alter = -0.1 },
      },
    },
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
        bg = H.tint(H.darken(dark_yellow, colors.dapstopped_bg_alter, H.get("Normal", "bg")), -0.1),
        fg = "NONE",
      },
    },
    {
      DapStoppedIcon = {
        bg = H.tint(H.darken(dark_yellow, colors.dapstopped_bg_alter, H.get("Normal", "bg")), -0.1),
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
    { WhichKey = { bg = { from = "FzfLuaNormal", attr = "bg" } } },
    { WhichKeySeparator = { bg = { from = "FzfLuaNormal", attr = "bg" } } },
    { WhichKeyTitle = { inherit = "FzfLuaTitle" } },
    { WhichKeyNormal = { inherit = "FzfLuaNormal", fg = { from = "Function", attr = "fg", alter = 0.1 } } }, -- <----
    { WhichKeyGroup = { inherit = "FzfLuaNormal", fg = { from = "Keyword", attr = "fg", alter = 0.1 } } },
    { WhichKeyDesc = { inherit = "FzfLuaNormal", fg = { from = "Boolean", attr = "fg", alter = 0.1 } } },
    { WhichKeyBorder = { inherit = "FzfLuaBorder" } },

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

local function set_panel_highlight()
  local H = require "r.settings.highlights"

  local colors = update_base_colors(RUtils.config.colorscheme)

  H.all {
    -- +---------+
    -- | SIDEBAR |
    -- +---------+
    {
      PanelSideNormal = {
        fg = { from = "Normal", attr = "fg", alter = -0.05 },
        -- bg = { from = "NormalKeyword", attr = "bg", alter = -0.1 },
        bg = { from = "WinBar", attr = "bg" },
      },
    },
    { PanelSideBackground = { link = "PanelSideNormal", fg = "NONE" } },
    { PanelSideDarkBackground = { bg = { from = "PanelSideNormal", attr = "bg", alter = -1 } } },

    { PanelSideDarkHeading = { inherit = "PanelSideDarkBackground", bold = true } },
    { PanelSideHeading = { inherit = "PanelSideBackground", bold = true } },

    { PanelSideRootName = { fg = { from = "PanelSideNormal", attr = "bg", alter = 1.35 } } },

    { PanelSideStNC = { link = "PanelSideWinSeparator" } },
    { PanelSideSt = { bg = { from = "Visual", alter = -0.2 } } },
    { PanelSideStusLine = { bg = { from = "StatusLine" }, fg = { from = "Normal", attr = "fg" } } },

    {
      PanelSideWinSeparator = {
        fg = { from = "WinSeparator", attr = "fg" },
        bg = { from = "PanelSideBackground", attr = "bg" },
      },
    },

    -- +--------+
    -- | BOTTOM |
    -- +--------+
    {
      PanelBottomNormal = {
        fg = { from = "NormalKeyword", attr = "fg", alter = colors.panel_bottom_normal_fg_alter },
        -- bg = { from = "NormalKeyword", attr = "bg", alter = colors.panel_bottom_normal_bg_alter },
        bg = { from = "WinBar", attr = "bg" },
      },
    },
    { PanelBottomHeading = { inherit = "PanelBottomBackground", bold = true } },
    { PanelBottomBackground = { bg = { from = "PanelBottomNormal", attr = "bg" } } },

    { PanelBottomDarkBackground = { bg = { from = "PanelBottomBackground", attr = "bg", alter = -0.1 } } },
    { PanelBottomDarkHeading = { inherit = "PanelBottomDarkBackground", bold = true } },

    { PanelBottomSt = { bg = { from = "Visual", alter = -0.2 } } },
    { PanelBottomStNC = { link = "PanelBottomWinSeparator" } },
    { PanelBottomStusLine = { bg = { from = "PanelBottomBackground" }, fg = { from = "Normal", attr = "fg" } } },
    {
      PanelBottomWinSeparator = {
        fg = { from = "WinSeparator", attr = "fg" },
        bg = { from = "Normal", attr = "bg" },
      },
    },

    -- +----------------------+
    -- | Quickfix - QuickList |
    -- +----------------------+
    {
      QuickFixLine = {
        fg = "NONE",
        bg = "NONE",
        sp = { from = "NormalKeyword", attr = "bg", alter = colors.quickfixline_sp_alter },
        underline = true,
        bold = true,
        reverse = false,
      },
    },
    {
      QuickFixHeader = {
        bg = { from = "PanelBottomNormal", attr = "bg", alter = colors.quickfixline_header_bg_alter },
        fg = { from = "PanelBottomNormal", attr = "bg", alter = colors.quickfixline_header_fg_alter },
      },
    },
    { QuickFixLineNr = { fg = { from = "NormalKeyword", attr = "bg", alter = colors.quickfixline_linenr_fg_alter } } },
    { qfSeparator1 = { fg = { from = "QuickFixLineNr", attr = "fg", alter = -0.1 } } },
    { qfSeparator2 = { link = "qfSeparator1" } },
    { Delimiter = { link = "qfSeparator1" } },
    { QuickFixFileName = { bg = "NONE" } },
    { qfFileName = { bg = "NONE" } },

    --  ──────────────────────────────[ TROUBLE ]──────────────────────────────
    { TroubleNormal = { inherit = "PanelBottomNormal" } },
    { TroubleNormalNC = { inherit = "PanelBottomNormal" } },

    { TroubleSignWarning = { bg = "NONE", fg = { from = "DiagnosticSignWarn", alter = -0.1 } } },
    { TroubleSignError = { bg = "NONE", fg = { from = "DiagnosticSignError", alter = -0.1 } } },
    { TroubleSignHint = { bg = "NONE", fg = { from = "DiagnosticSignHint", alter = -0.1 } } },
    { TroubleSignInfo = { bg = "NONE", fg = { from = "DiagnosticSignInfo", alter = -0.1 } } },
    { TroubleSignOther = { bg = "NONE", fg = { from = "DiagnosticSignInfo", alter = -0.1 } } },
    { TroubleSignInformation = { bg = "NONE", fg = { from = "DiagnosticSignInfo", alter = -0.1 } } },

    {
      TroubleIndent = {
        fg = { from = "TroubleNormal", attr = "bg", alter = colors.trouble_indent_fg_alter },
        bg = "NONE",
      },
    },
    {
      TroubleIndentFoldClosed = {
        inherit = "TroubleIndent",
        fg = { from = "TroubleIndent", attr = "fg", alter = 0.5 },
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

    { TroubleCode = { bg = "NONE", fg = { from = "ErrorMsg", attr = "fg" }, underline = false } },

    --  ──────────────────────────────[ OUTLINE ]──────────────────────────────
    {
      OutlineGuides = {
        fg = { from = "PanelSideNormal", attr = "bg", alter = colors.outline_indent_fg_alter },
        bg = "NONE",
      },
    },
    {
      OutlineCurrent = {
        fg = { from = "diffDelete", attr = "fg", alter = 0.3 },
        bold = true,
        reverse = false,
      },
    },
    { OutlineDetails = { fg = { from = "OutlineGuides", attr = "fg", alter = 0.1 }, bg = "NONE", italic = true } },
    { OutlineJumpHighlight = { bg = "red", fg = "NONE" } },
    { OutlineLineno = { bg = "NONE" } },
    { OutlineFoldMarker = { fg = { from = "OutlineGuides", attr = "fg", alter = 0.48 }, bg = "NONE" } },

    --  ──────────────────────────────[ AERIALS ]──────────────────────────────
    { AerialGuide = { inherit = "OutlineGuides" } },

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

    --  ──────────────────────────────[ NAVIC ]──────────────────────────────
    { NavicText = { link = "WinBar" } },
    { NavicIconsText = { link = "LspKindText" } },
    { NavicIconsBoolean = { link = "LspKindBoolean" } },
    { NavicIconsVariable = { link = "LspKindVariable" } },
    { NavicIconsConstant = { link = "LspKindConstant" } },
    { NavicIconsModule = { link = "LspKindModule" } },
    { NavicIconsPackage = { link = "LspKindPackage" } },
    { NavicIconsKeyword = { link = "LspKindKeyword" } },
    { NavicIconsFunction = { link = "LspKindFunction" } },
    { NavicIconsStruct = { link = "LspKindStruct" } },
    { NavicIconsArray = { link = "LspKindObject" } },
    { NavicIconsOperator = { link = "LspKindOperator" } },
    { NavicIconsObject = { link = "LspKindObject" } },
    { NavicIconsString = { link = "LspKindString" } },
    { NavicIconsField = { link = "LspKindField" } },
    { NavicIconsNumber = { link = "LspKindNumber" } },
    { NavicIconsProperty = { link = "LspKindProperty" } },
    { NavicIconsReference = { link = "LspKindReference" } },
    { NavicIconsEvent = { link = "LspKindEvent" } },
    { NavicIconsFile = { link = "LspKindFile" } },
    { NavicIconsFolder = { link = "LspKindFolder" } },
    { NavicIconsInterface = { link = "LspKindInterface" } },
    { NavicIconsKey = { link = "LspKindKey" } },
    { NavicIconsMethod = { link = "LspKindMethod" } },
    { NavicIconsNamespace = { link = "LspKindNamespace" } },
    { NavicIconsNull = { link = "LspKindNull" } },
    { NavicIconsUnit = { link = "LspKindUnit" } },
    { NavicIconsEnum = { link = "LspKindEnum" } },
    { NavicIconsEnumMember = { link = "LspKindEnumMember" } },
    { NavicIconsConstructor = { link = "LspKindConstructor" } },
    { NavicIconsTypeParameter = { link = "LspKindTypeParameter" } },
    { NavicIconsValue = { link = "LspKindValue" } },
    { LspInlayHint = { link = "LspInlayHint" } },
  }
end

local sidebar_fts = {
  "packer",
  "flutterToolsOutline",
  "undotree",
  "dbui",
  "neotest-summary",
  "pr",

  "dapui_scopes",
  "dapui_stacks",
  "dapui_watches",
  "dapui_breakpoints",
  "dap-repl",
}

local function on_sidebar_enter()
  vim.opt_local.winhighlight:append {
    Normal = "PanelSideNormal",
    EndOfBuffer = "PanelSideNormal",
    StatusLine = "PanelSideSt",
    SignColumn = "PanelSideNormal",
    VertSplit = "PanelSideNormal", -- TODO: check ini, seharusnya bukan `PanelSideNormal, seharusnya VertSplit juga tapi khusus untuk sidebar
    WinSeparator = "PanelSideWinSeparator",
  }
end

local function colorscheme_overrides()
  local H = require "r.settings.highlights"

  -- local UIPallette = require("r.utils").uisec
  -- local dark_green = H.tint(UIPallette.palette.green, 0.3)
  -- local dark_yellow = H.tint(UIPallette.palette.bright_yellow, 0.3)
  -- local dark_red = H.tint(UIPallette.palette.dark_red, 0.3)

  local overrides = {
    ["base46-material-lighter"] = {
      { QuickFixLineNr = { fg = { from = "Normal", attr = "bg", alter = -0.4 } } },
      { qfSeparator1 = { fg = { from = "Normal", attr = "bg", alter = -0.2 } } },
      { qfSeparator2 = { link = "qfSeparator1" } },
      { Delimiter = { link = "qfSeparator1" } },
    },

    ["gruvbox-material"] = {
      { ErrorMsg = { underline = false } },
    },

    ["jellybeans"] = {
      {
        OctoStatusColumn = {
          fg = H.darken(H.get("Keyword", "fg"), 0.4, H.get("Error", "fg")),
        },
      },
    },

    ["xenos"] = {
      -- WARN
      {
        SnacksNotifierWarn = {
          fg = { from = "diffChange", attr = "fg" },
          bg = { from = "Normal", attr = "bg" },
        },
      },
      {
        SnacksNotifierBorderWarn = {
          fg = { from = "SnacksNotifierWarn", attr = "fg", alter = -0.2 },
          bg = { from = "SnacksNotifierWarn", attr = "bg" },
        },
      },
      {
        SnacksNotifierTitleWarn = {
          fg = { from = "Normal", attr = "bg" },
          bg = { from = "SnacksNotifierWarn", attr = "fg", alter = 0.4 },
          bold = true,
        },
      },

      -- WARN
      { NotifyWARNBody = { inherit = "SnacksNotifierWarn" } },
      { NotifyWARNBorder = { inherit = "SnacksNotifierBorderWarn", bg = "NONE" } },
      { NotifyWARNTitle = { fg = { from = "SnacksNotifierTitleWarn", attr = "bg" }, bg = "NONE" } },
      { NotifyWARNIcon = { fg = { from = "SnacksNotifierTitleWarn", attr = "bg" }, bg = "NONE" } },
    },
  }

  local hls = overrides[vim.g.colors_name]
  if hls then
    H.all(hls)
  end
end

local function user_highlights()
  general_overrides()
  set_panel_highlight()
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
