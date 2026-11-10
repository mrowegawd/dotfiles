local base_colors = { Directory = { fg = { from = "Directory", attr = "fg" }, bg = "NONE" } }

local update_col_colorscheme = {
  ["ashen"] = {
    nonetext_opacity = 0.3,
    linenr_transparency_fg = 0.16,
    troubleindent_transparency_fg = 0.35,
    panelsidenormal_bg_alter = -0.75,
    panelbottomlinenr_fg_alter = 3.5,
    comment_transparency_fg = 0.5,
    pmenusel_transparency_bg = 0.08,
    statuslinetheme_transparency_fg = 0.7,
    winseparator_transparency_fg = 0.15,
    pmenu_fg = -0.15,
    winbar_fg_combine_from = "String",
    folded_fg_alter = 1,
    folded_transparency_bg = 0.03,
    folded_fg_combine_intesity = 0.1,

    normalnote_fg_alter = 8,
    commentnote_fg_alter = 0.9,
    codeblock_bg_alter = 0.4,
    linenrnote_transparency_fg = 0.6,
    winseparatornote_transparency_fg = 0.08,
  },
  ["catppuccin"] = {
    linenr_transparency_fg = 0.13,
    panelbottomlinenr_fg_alter = 2,
    panelsidenormal_bg_alter = -0.5,
    statuslinetheme_transparency_fg = 0.5,
    winseparator_transparency_fg = 0.11,
    codeblock_bg_alter = 0.4,
    normalfloat_bg_alter = 0.3,
    folded_fg_alter = 1,
    folded_transparency_bg = 0.05,
    folded_fg_combine_intesity = 0.1,
    winbar_fg_combine_from = "PreProc",
    winbar_fg_alter = 1,
    pmenu_fg = 0.4,
    pmenusel_transparency_bg = 0.08,
    pmenu_transparency_bg = 0.25,
    troubleindent_transparency_fg = 0.13,

    linenrnote_transparency_fg = 0.3,
    commentnote_fg_alter = 0.15,
    normalnote_bg_alter = 0.35,
    normalnote_transparency_fg = 0.7,

    floatborderaiprompt_fg_alter = 2.5,
  },
  ["cendre"] = {
    linenr_transparency_fg = 0.15,
    panelsidenormal_bg_alter = -0.75,
    pmenu_fg = -0.1,
    normalfloat_bg_alter = 0.3,
    pmenu_transparency_bg = 0.25,
    pmenusel_transparency_bg = 0.1,
    panelbottomlinenr_fg_alter = 2.5,
    winseparator_transparency_fg = 0.15,
    winbar_fg_alter = 3,
    troubleindent_transparency_fg = 0.4,
    statuslinetheme_fg_alter = 4,
    folded_fg_alter = 0.7,
    folded_transparency_bg = 0.1,
    foldsign_fg_alter = 0.1,

    normalnote_bg_alter = 1,
    normalnote_transparency_fg = 0.75,
    commentnote_fg_alter = 0.7,
    linenrnote_transparency_fg = 0.4,
    winseparatornote_transparency_fg = 0.08,

    floatborderaiprompt_fg_alter = 4,
  },
  ["everforest"] = {
    floatborderaiprompt_fg_alter = 2.5,
    cursorlinebright_bg_alter = 0.7,
    orgdirective_fg_alter = 0.3,
    comment_transparency_fg = 0.5,
    statuslinetheme_fg_alter = 3,
    linenr_transparency_fg = 0.1,
    winbar_fg_alter = 2,
    panelsidenormal_bg_alter = -0.3,
    zshlines_transparency_bg = 0.4,
    winseparator_transparency_fg = 0.11,
    normalfloat_transparency_fg = 0.65,
    panelbottomlinenr_fg_alter = 2,
    panelbottomcomment_fg_alter = -0.5,
    pmenu_transparency_bg = 0.25,
    pmenu_fg = 0.3,
    pmenusel_transparency_bg = 0.08,
    folded_fg_alter = 0.85,
    foldsign_fg_alter = 0.02,
    folded_transparency_bg = 0.07,
    folded_fg_combine_intesity = 0.12,

    normalnote_bg_alter = 0.4,
    commentnote_fg_alter = 0.25,
    linenrnote_fg_alter = 0.8,
    linenrnote_transparency_fg = 0.4,
  },
  ["gruvbox"] = {
    linenr_transparency_fg = 0.13,
    panelsidenormal_bg_alter = -0.65,
    orgdirective_fg_alter = 0.4,
    statuslinetheme_fg_alter = 3.5,
    cursorlinebright_bg_alter = 1,
    pmenu_transparency_bg = 0.25,
    pmenusel_transparency_bg = 0.1,
    pmenu_fg = 0.12,
    folded_fg_alter = 1,
    winseparator_transparency_fg = 0.12,

    normalnote_fg_alter = 8,
    normalnote_transparency_fg = 0.4,
    nontextnote_fg_alter = 0.5,
    linenrnote_transparency_fg = 0.4,

    floatborderaiprompt_fg_alter = 2.5,
  },
  ["imli"] = {
    nonetext_opacity = 0.3,
    linenr_transparency_fg = 0.13,
    comment_transparency_fg = 0.65,
    orgdirective_fg_alter = 0.4,
    winseparator_transparency_fg = 0.15,
    troubleindent_transparency_fg = 0.3,
    codeblock_bg_alter = 0.4,
    panelbottomlinenr_fg_alter = 3,
    winbar_fg_combine_from = "Function",
    pmenu_fg = -0.1,
    pmenusel_transparency_bg = 0.1,
    panelsidenormal_bg_alter = -0.65,
    zshlines_transparency_bg = 0.6,
    folded_fg_alter = 1.2,
    folded_transparency_bg = 0.07,
    foldsign_fg_alter = -0.1,

    normalnote_fg_alter = 13,
    normalnote_transparency_fg = 0.8,
    linenrnote_transparency_fg = 0.4,
    nontextnote_fg_alter = 0.1,

    floatborderaiprompt_fg_alter = 2.5,
  },
  ["ef-dream"] = {
    orgdirective_fg_alter = 0.4,
    statuslinetheme_fg_alter = 3,
    pmenu_transparency_bg = 0.3,
    pmenusel_transparency_bg = 0.1,
    winbar_fg_combine_from = "Function",
    codeblock_bg_alter = 0.4,
    cursorline_bg_alter = 0.13,
    zshlines_transparency_bg = 0.4,
    linenr_transparency_fg = 0.12,
    panelsidenormal_bg_alter = -0.5,
    panelbottomlinenr_fg_alter = 1.5,
    winseparator_transparency_fg = 0.09,
    folded_fg_alter = 0.8,
    folded_transparency_bg = 0.05,
    folded_fg_combine_intesity = 0.1,

    normalnote_bg_alter = 0.5,
    nontextnote_fg_alter = 0.1,
    normalnote_transparency_fg = 0.75,
    linenrnote_transparency_fg = 0.3,
  },
  ["ef-cherie"] = {
    nonetext_opacity = 0.15,
    troubleindent_transparency_fg = 0.55,
    codeblock_bg_alter = 0.5,
    panelsidenormal_bg_alter = -0.8,
    linenr_transparency_fg = 0.2,
    panelbottomlinenr_fg_alter = 3.5,
    cursorlinebright_bg_alter = 1.2,
    statuslinetheme_transparency_fg = 0.9,
    winseparator_transparency_fg = 0.22,
    zshlines_transparency_bg = 0.75,
    winbar_fg_alter = 3.8,
    folded_fg_alter = 0.5,
    folded_transparency_bg = 0.05,

    linenrnote_fg_alter = 1.2,
    linenrnote_transparency_fg = 0.3,
    normalnote_transparency_fg = 0.9,
    winseparatornote_transparency_fg = 0.08,
    normalnote_fg_alter = 14,
    nontextnote_fg_alter = 0.1,
    orgdirective_fg_alter = 0.4,

    floatborderaiprompt_fg_alter = 2.5,
  },
  ["intent"] = {
    pmenu_fg = -0.1,
    troubleindent_transparency_fg = 0.55,
    panelsidenormal_bg_alter = -0.9,
    panelbottomlinenr_fg_alter = 5,
    linenr_transparency_fg = 0.18,
    winseparator_transparency_fg = 0.21,
    winbar_fg_alter = 4,
    winbar_fg_combine_from = "Boolean",
    folded_fg_alter = 1.4,
    folded_fg_combine_intesity = 0.1,
    folded_transparency_bg = 0.04,
    zshlines_transparency_bg = 0.75,

    commentnote_fg_alter = 0.7,
    normalnote_fg_alter = 11,
    normalnote_bg_alter = 0.8,
    linenrnote_transparency_fg = 0.55,
    winseparatornote_transparency_fg = 0.08,
  },
  ["jellybeans"] = {
    nonetext_opacity = 0.3,
    panelsidenormal_bg_alter = -0.7,
    linenr_transparency_fg = 0.13,
    panelbottomlinenr_fg_alter = 3,
    statuslinetheme_transparency_fg = 0.7,
    codeblock_bg_alter = 0.45,
    pmenusel_transparency_bg = 0.08,
    winseparator_transparency_fg = 0.15,
    winbar_fg_alter = 3,
    winbar_fg_combine_from = "Type",
    pmenu_fg = 0.5,
    folded_fg_alter = 0.8,
    folded_transparency_bg = 0.07,
    foldsign_fg_alter = -0.1,
    zshlines_transparency_bg = 0.6,

    normalnote_bg_alter = 0.65,
    normalnote_fg_alter = 9,
    linenrnote_transparency_fg = 0.4,
  },
  ["kanagawa"] = {
    orgdirective_fg_alter = 0.7,
    pmenusel_transparency_bg = 0.08,
    troubleindent_transparency_fg = 0.3,
    statuslinetheme_transparency_fg = 0.9,
    codeblock_bg_alter = 0.4,
    cursorline_bg_alter = 0.3,
    panelsidenormal_bg_alter = -0.8,
    panelbottomlinenr_fg_alter = 4,
    linenr_transparency_fg = 0.2,
    winbar_fg_alter = 2.85,
    winbar_fg_combine_from = "Function",
    pmenu_fg = -0.1,
    folded_fg_alter = 0.35,
    folded_transparency_bg = 0.05,
    comment_transparency_fg = 0.5,
    winseparator_transparency_fg = 0.25,
    zshlines_transparency_bg = 0.85,

    floatborderaiprompt_fg_alter = 6,

    linenrnote_fg_alter = 1.4,
    linenrnote_transparency_fg = 0.4,
    normalnote_transparency_fg = 0.68,
    normalnote_bg_alter = 0.6,
    winseparatornote_transparency_fg = 0.06,
  },
  ["lackluster"] = {
    nonetext_opacity = 0.2,
    codeblock_bg_alter = 0.55,
    comment_transparency_fg = 0.4,
    normalfloat_bg_alter = 1.2,
    linenr_transparency_fg = 0.45,
    cursorlinebright_bg_alter = 2.5,
    cursorline_bg_alter = 0.4,
    floatborder_transparency_fg = 0.5,
    statuslinetheme_fg_alter = 8,
    panelbottomlinenr_fg_alter = 8,
    panelsidenormal_bg_alter = -0.9,
    winseparator_transparency_fg = 0.5,
    winbar_fg_alter = 4.5,
    winbar_fg_combine_from = "Boolean",
    pmenu_transparency_bg = 0.55,
    pmenusel_transparency_bg = 0.06,
    zshlines_bg_alter = 20,
    zshlines_transparency_bg = 0.3,
    zshprompt_bg_alter = -0.7,
    pmenu_fg = -0.1,
    troubleindent_transparency_fg = 0.85,
    folded_fg_alter = -0.4,
    folded_fg_combine_intesity = 0.2,

    normalnote_transparency_fg = 0.67,
    normalnote_bg_alter = 2.5,
    linenrnote_fg_alter = 1.5,
    linenrnote_transparency_fg = 0.35,
    winseparatornote_transparency_fg = 0.08,
    commentnote_fg_alter = 0.45,

    floatborderaiprompt_fg_alter = 18,
  },
  ["luna"] = {
    Directory = { fg = "#75a1c7", bg = "NONE" },
    linenr_transparency_fg = 0.36,
    cursorline_bg_alter = 0.5,
    normalfloat_bg_alter = 0.75,
    comment_transparency_fg = 0.3,
    codeblock_bg_alter = 0.45,
    statuslinetheme_fg_alter = 8,
    pmenusel_transparency_bg = 0.07,
    panelsidenormal_bg_alter = -0.5,
    panelbottomlinenr_fg_alter = 4.5,
    winseparator_transparency_fg = 0.5,
    pmenu_fg = -0.1,
    pmenu_transparency_bg = 0.65,
    zshlines_bg_alter = 20,
    zshlines_transparency_bg = 0.3,
    winbar_fg_alter = 5.5,
    panelbottomcomment_fg_alter = -0.1,
    troubleindent_transparency_fg = 0.35,
    folded_fg_alter = -0.4,
    folded_transparency_bg = 0.04,
    folded_fg_combine_intesity = 0.18,

    normalnote_bg_alter = 1.5,
    normalnote_transparency_fg = 0.65,
    orgdirective_fg_alter = 0.3,
    visualnote_bg_alter = 1.5,
    linenrnote_fg_alter = 2.5,
    linenrnote_transparency_fg = 0.25,
    commentnote_fg_alter = 0.4,
    winseparatornote_transparency_fg = 0.08,

    floatborderaiprompt_fg_alter = 15,
    nontextaiprompt_fg_alter = 5,
  },
  ["techbase"] = {
    nonetext_opacity = 0.4,
    statuslinetheme_transparency_fg = 0.5,
    panelsidenormal_bg_alter = -0.6,
    linenr_transparency_fg = 0.1,
    panelbottomlinenr_fg_alter = 2.5,
    comment_fg_alter = 0.5,
    pmenu_transparency_bg = 0.15,
    winbar_fg_alter = 3,
    winbar_fg_combine_from = "Number",
    pmenusel_transparency_bg = 0.1,
    winseparator_transparency_fg = 0.13,
    comment_transparency_fg = 0.8,
    pmenu_fg = -0.1,
    zshlines_transparency_bg = 0.45,
    folded_fg_alter = -0.25,
    folded_transparency_bg = 0.05,
    folded_fg_combine_intesity = 0.3,

    normalnote_fg_alter = 9,
    commentnote_fg_alter = 0.15,
    linenrnote_transparency_fg = 0.35,

    floatborderaiprompt_fg_alter = 2.5,
  },
  ["tokyonight-night"] = {
    linenr_transparency_fg = 0.16,
    comment_transparency_fg = 0.75,
    troubleindent_transparency_fg = 0.3,
    cursorlinebright_bg_alter = 1.3,
    winbar_fg_alter = 4,
    codeblock_bg_alter = 0.45,
    winseparator_transparency_fg = 0.3,
    winbar_fg_combine_from = "Number",
    pmenusel_transparency_bg = 0.08,
    panelsidenormal_bg_alter = -0.7,
    panelbottomlinenr_fg_alter = 2.5,
    pmenu_fg = -0.1,
    zshlines_bg_alter = 15,
    zshlines_transparency_bg = 0.25,
    folded_fg_alter = 0.8,
    folded_transparency_bg = 0.05,
    foldsign_fg_alter = -0.3,

    normalnote_bg_alter = 0.8,
    normalnote_fg_alter = 10,
    normalnote_transparency_fg = 0.7,
    linenrnote_transparency_fg = 0.5,
    linenrnote_fg_alter = 1,
    commentnote_fg_alter = 1.5,

    floatborderaiprompt_fg_alter = 6,
  },
  ["vscode"] = {
    nonetext_opacity = 0.3,
    linenr_transparency_fg = 0.1,
    panelsidenormal_bg_alter = -0.6,
    pmenu_transparency_bg = 0.25,
    statuslinetheme_transparency_fg = 0.6,
    codeblock_bg_alter = 0.4,
    cursorlinebright_bg_alter = 0.8,
    winbar_fg_alter = 2.8,
    winbar_fg_combine_from = "String",
    winseparator_transparency_fg = 0.15,
    pmenu_fg = -0.1,
    folded_fg_alter = 1.2,
    folded_transparency_bg = 0.06,
    foldsign_fg_alter = -0.1,
    folded_fg_combine_intesity = 0.1,
    normalfloat_bg_alter = 0.2,

    normalnote_fg_alter = 10,
    normalnote_bg_alter = 0.45,
    nontextnote_fg_alter = 1.5,
    commentnote_fg_alter = 0.6,
    linenrnote_transparency_fg = 0.3,
    winseparatornote_transparency_fg = 0.08,

    floatborderaiprompt_fg_alter = 3.5,
  },
  ["zenburn"] = {
    Directory = { fg = "#f2d9a0", bg = "NONE" },
    normalfloat_bg_alter = 0.2,
    linenr_transparency_fg = 0.08,
    floatborder_transparency_fg = 0.3,
    statuslinetheme_transparency_fg = 0.5,
    cursorlinebright_bg_alter = 0.5,
    panelsidenormal_bg_alter = -0.6,
    winseparator_transparency_fg = 0.12,
    panelbottomlinenr_fg_alter = 1.5,
    troubleindent_transparency_fg = 0.05,
    pmenu_transparency_bg = 0.1,
    pmenu_fg = -0.1,
    pmenusel_transparency_bg = 0.2,
    winbar_fg_alter = 0.55,
    winbar_fg_combine_from = "String",
    fzfluaheadertext = 0.25,
    floattitle_bg_from = "Number",
    folded_fg_alter = 0.5,
    foldsign_fg_alter = -0.1,
    folded_transparency_bg = 0.08,
    zshlines_transparency_bg = 0.31,
    zshprompt_bg_alter = -0.7,

    normalnote_bg_alter = 0.2,
    normalnote_fg_alter = 25,
    normalnote_transparency_fg = 0.8,
    winseparatornote_transparency_fg = 0.13,
    nonetext_opacity = 0.3,
    commentnote_fg_alter = 0.25,
    linenrnote_fg_alter = 2,
    linenrnote_transparency_fg = 0.12,
    orgdirective_fg_alter = 0.25,

    floatborderaiprompt_fg_alter = 1.5,
  },
}

if vim.tbl_contains({ "ghostty-cairo", "ghostty" }, os.getenv "TERMINAL") then
  update_col_colorscheme["ashen"] = {
    orgdirective_fg_alter = 0.3,
    winbar_fg_combine_from = "String",
    winbar_fg_alter = 3,
    floatborder_transparency_fg = 0.5,
    winseparator_transparency_fg = 0.28,
    linenr_transparency_fg = 0.15,

    normalnote_bg_alter = 1,
    commentnote_fg_alter = 0.15,
    linenrnote_fg_alter = 0.7,
    linenrnote_transparency_fg = 0.4,
    winseparatornote_transparency_fg = 0.15,
  }
  update_col_colorscheme["catppuccin"] = {
    panelsidenormal_bg_alter = -0.5,
    statuslinetheme_transparency_fg = 0.5,
    winbar_fg_combine_from = "Number",
    winseparator_transparency_fg = 0.2,
    linenr_transparency_fg = 0.1,
    folded_fg_alter = 0.8,
    winbar_fg_alter = 1,
    normalfloat_bg_alter = 0.25,
    zshlines_transparency_bg = 0.4,
    floatborder_transparency_fg = 0.5,

    normalnote_fg_alter = 8,
    normalnote_bg_alter = 0.4,
    commentnote_fg_alter = 0.8,
    linenrnote_transparency_fg = 0.32,
  }
  update_col_colorscheme["cendre"] = {
    folded_fg_alter = 0.85,
    winbar_fg_alter = 2.5,
    cursorlinebright_bg_alter = 0.7,
    panelsidenormal_bg_alter = -0.5,
    statuslinetheme_transparency_fg = 0.7,
    winseparator_transparency_fg = 0.26,
    floatborder_transparency_fg = 0.5,
    linenr_transparency_fg = 0.15,
    zshlines_transparency_bg = 0.53,

    normalnote_fg_alter = 10,
    commentnote_fg_alter = 0.9,
    linenrnote_fg_alter = 0.9,
    linenrnote_transparency_fg = 0.55,
  }
  update_col_colorscheme["ef-cherie"] = {
    nonetext_opacity = 0.15,
    linenr_transparency_fg = 0.15,
    troubleindent_transparency_fg = 0.4,
    winseparator_transparency_fg = 0.4,
    panelsidenormal_bg_alter = -0.5,
    cursorlinebright_bg_alter = 0.9,
    folded_fg_alter = 1.2,
    codeblock_bg_alter = 0.5,
    floatborder_transparency_fg = 0.5,
    zshlines_bg_alter = 5.5,

    normalnote_fg_alter = 15,
    normalnote_transparency_fg = 0.7,
    normalnote_bg_alter = 0.5,
    linenrnote_transparency_fg = 0.55,
  }
  update_col_colorscheme["ef-dream"] = {
    statuslinetheme_transparency_fg = 0.5,
    panelsidenormal_bg_alter = -0.4,
    troubleindent_transparency_fg = 0.15,
    linenr_transparency_fg = 0.12,
    panelbottomlinenr_fg_alter = 1.5,
    normalfloat_bg_alter = 0.2,
    folded_fg_alter = 0.8,
    winbar_fg_combine_from = "Function",
    winseparator_transparency_fg = 0.18,
    floatborder_transparency_fg = 0.5,

    normalnote_fg_alter = 8,
    normalnote_bg_alter = 0.4,
    normalnote_transparency_fg = 0.9,
    linenrnote_transparency_fg = 0.34,
    winseparatornote_transparency_fg = 0.15,
  }
  update_col_colorscheme["everforest"] = {
    nonetext_opacity = 0.3,
    panelsidenormal_bg_alter = -0.45,
    statuslinetheme_transparency_fg = 0.5,
    folded_fg_alter = 0.8,
    zshlines_bg_alter = 3,
    normalfloat_bg_alter = 0.25,
    linenr_transparency_fg = 0.1,
    floatborder_transparency_fg = 0.5,
    winseparator_transparency_fg = 0.18,

    linenrnote_transparency_fg = 0.3,
    normalnote_transparency_fg = 1,
  }
  update_col_colorscheme["gruvbox"] = {
    orgdirective_fg_alter = 0.4,
    statuslinetheme_transparency_fg = 0.6,
    panelsidenormal_bg_alter = -0.6,
    panelbottomlinenr_fg_alter = 1.8,
    zshlines_bg_alter = 4.5,
    codeblock_bg_alter = 0.4,
    floatborder_transparency_fg = 0.55,
    linenr_transparency_fg = 0.1,
    winseparator_transparency_fg = 0.2,
    folded_fg_alter = 0.9,

    linenrnote_fg_alter = 1.8,
    commentnote_fg_alter = 0.8,
    normalnote_bg_alter = 0.45,
  }
  update_col_colorscheme["imli"] = {
    linenr_transparency_fg = 0.1,
    winbar_fg_combine_from = "Function",
    winseparator_transparency_fg = 0.26,
    floatborder_transparency_fg = 0.55,
    cursorlinebright_bg_alter = 1,
    codeblock_bg_alter = 0.4,
    statuslinetheme_fg_alter = 4.2,
    panelsidenormal_bg_alter = -0.4,
    panelbottomlinenr_fg_alter = 1.5,
    folded_fg_alter = 0.8,
    zshlines_bg_alter = 4.5,

    linenrnote_transparency_fg = 0.5,
    normalnote_fg_alter = 15,
  }
  update_col_colorscheme["jellybeans"] = {
    statuslinetheme_fg_alter = 4.2,
    winbar_fg_alter = 3,
    winbar_fg_combine_from = "Type",
    winseparator_transparency_fg = 0.22,
    floatborder_transparency_fg = 0.5,
    troubleindent_transparency_fg = 0.3,
    linenr_transparency_fg = 0.12,
    cursorlinebright_bg_alter = 0.7,
    panelsidenormal_bg_alter = -0.55,
    panelbottomlinenr_fg_alter = 3.25,
    zshlines_bg_alter = 4.5,
    folded_fg_alter = 0.8,

    linenrnote_fg_alter = 1.2,
    linenrnote_transparency_fg = 0.3,
    normalnote_transparency_fg = 0.7,
    commentnote_fg_alter = 0.8,
  }
  update_col_colorscheme["kanagawa"] = {
    nonetext_opacity = 0.3,
    linenr_transparency_fg = 0.15,
    panelsidenormal_bg_alter = -0.5,
    panelbottomlinenr_fg_alter = 3,
    floatborder_transparency_fg = 0.6,
    winseparator_transparency_fg = 0.38,
    winbar_fg_combine_from = "Function",
    winbar_fg_alter = 5,
    folded_fg_alter = 0.8,
    orgdirective_fg_alter = 0.25,
    zshlines_bg_alter = 8,

    normalnote_bg_alter = 1.5,
    linenrnote_transparency_fg = 0.4,
    commentnote_fg_alter = 0.45,
  }
  update_col_colorscheme["intent"] = {
    troubleindent_transparency_fg = 0.4,
    panelbottomlinenr_fg_alter = 2.8,
    linenr_fg_alter = 0.08,
    codeblock_bg_alter = 0.4,
    cursorlinebright_bg_alter = 1.4,
    winseparator_transparency_fg = 0.38,
    floatborder_transparency_fg = 0.55,
    winbar_fg_combine_from = "Boolean",
    winbar_fg_combine_intensity = 1,
    folded_fg_alter = 0.8,
    zshlines_bg_alter = 5.5,

    winseparatornote_transparency_fg = 0.1,
    linenrnote_transparency_fg = 0.4,
    normalnote_bg_alter = 1.2,
    normalnote_fg_alter = 12,
    commentnote_fg_alter = 0.6,
  }
  update_col_colorscheme["lackluster"] = {
    nonetext_opacity = 0.3,
    linenr_transparency_fg = 0.45,
    folded_fg_alter = -0.2,
    folded_transparency_bg = 0.08,
    codeblock_bg_alter = 0.4,
    comment_transparency_fg = 0.3,
    cursorlinebright_bg_alter = 1.8,
    statuslinetheme_fg_alter = 9,
    floatborder_transparency_fg = 0.55,
    troubleindent_transparency_fg = 0.6,
    panelsidenormal_bg_alter = 0.3,
    winseparator_transparency_fg = 0.8,
    panelbottomlinenr_fg_alter = 7,
    winbar_fg_combine_alter = 30,
    winbar_fg_combine_intensity = 0.8,
    winbar_fg_combine_from = "Boolean",
    normalfloat_fg_alter = 20,
    zshlines_bg_alter = 15,

    orgdirective_fg_alter = 0.6,
    normalnote_bg_alter = 3,
    normalnote_transparency_fg = 0.7,
    commentnote_fg_alter = 0.1,
    visualnote_bg_alter = 1.2,
    linenrnote_transparency_fg = 0.4,
  }
  update_col_colorscheme["luna"] = {
    linenr_transparency_fg = 0.3,
    nonetext_opacity = 0.35,
    winseparator_transparency_fg = 0.55,
    statuslinetheme_fg_alter = 8,
    panelsidenormal_bg_alter = -0.8,
    panelbottomlinenr_fg_alter = 5,
    cursorlinebright_bg_alter = 1.45,
    comment_transparency_fg = 0.4,
    troubleindent_transparency_fg = 0.6,
    floatborder_transparency_fg = 0.6,
    zshlines_bg_alter = 10,
    cursorline_bg_alter = 0.4,

    normalnote_bg_alter = 1.5,
    normalnote_fg_alter = 12,
    normalnote_transparency_fg = 0.7,
    commentnote_fg_alter = 1.2,
    linenrnote_transparency_fg = 0.6,
    winseparatornote_transparency_fg = 0.08,
  }
  update_col_colorscheme["techbase"] = {
    nonetext_opacity = 0.38,
    comment_fg_alter = 0.4,
    linenr_transparency_fg = 0.1,
    troubleindent_transparency_fg = 0.25,
    folded_fg_alter = 0.8,
    winbar_fg_alter = 1.8,
    winbar_fg_combine_from = "Number",
    statuslinetheme_transparency_fg = 0.5,
    winseparator_transparency_fg = 0.18,
    panelbottomlinenr_fg_alter = 1.5,
    zshlines_transparency_bg = 0.4,

    linenrnote_fg_alter = 0.8,
    linenrnote_transparency_fg = 0.35,
    winseparatornote_transparency_fg = 0.1,
  }
  update_col_colorscheme["neogotham"] = {
    zshlines_bg_alter = 0.65,

    commentnote_fg_alter = 0.1,
    orgdirective_fg_alter = 0.3,
    normalnote_bg_alter = 1.5,
    linenrnote_fg_alter = 1,
  }
  update_col_colorscheme["oxocarbon"] = {
    normalnote_bg_alter = 0.8,
    panelsidenormal_bg_alter = 0.1,

    orgdirective_fg_alter = 0.3,
    linenrnote_fg_alter = 0.8,
    commentnote_fg_alter = 0.8,
  }
  update_col_colorscheme["nightfox"] = { linenr_fg_alter = 1.2 }
  update_col_colorscheme["rose-pine"] = {
    normalnote_bg_alter = 1.1,
    orgdirective_fg_alter = 0.3,
    commentnote_fg_alter = 0.22,

    panelsidenormal_bg_alter = 0.1,
    linenrnote_fg_alter = 0.65,
  }
  update_col_colorscheme["tokyonight"] = {
    nonetext_opacity = 0.4,
    panelsidenormal_bg_alter = 0.1,
    linenrnote_fg_alter = 0.5,

    commentnote_fg_alter = 0.8,
    normalnote_bg_alter = 0.6,
  }
  update_col_colorscheme["tokyonight-night"] = {
    nonetext_opacity = 0.2,
    linenr_transparency_fg = 0.23,
    panelbottomlinenr_fg_alter = 4,
    statuslinetheme_fg_alter = 7,
    panelsidenormal_bg_alter = -0.6,
    winbar_fg_combine_from = "Number",
    winseparator_transparency_fg = 0.42,
    normalnote_bg_alter = 1.5,
    zshlines_bg_alter = 10,
    zshlines_transparency_bg = 0.35,

    linenrnote_transparency_fg = 0.5,
    winseparatornote_transparency_fg = 0.1,
    commentnote_fg_alter = 0.8,
    orgdirective_fg_alter = 0.5,
    normalnote_fg_alter = 10,
  }
  update_col_colorscheme["tokyonight-storm"] = {
    commentnote_fg_alter = 0.55,
    normalnote_bg_alter = 0.4,
    linenrnote_fg_alter = 0.55,
  }
  update_col_colorscheme["vscode"] = {
    linenr_transparency_fg = 0.1,
    statuslinetheme_fg_alter = 3.5,
    panelsidenormal_bg_alter = -0.6,
    winbar_fg_alter = 2.5,
    winbar_fg_combine_from = "String",
    winseparator_transparency_fg = 0.22,
    normalfloat_bg_alter = 0.28,
    folded_fg_alter = 0.8,

    commentnote_fg_alter = 0.85,
    normalnote_bg_alter = 0.4,
    normalnote_transparency_fg = 0.7,
    linenrnote_fg_alter = 0.95,
    linenrnote_transparency_fg = 0.32,
    winseparatornote_transparency_fg = 0.15,
  }
  update_col_colorscheme["zenburn"] = {
    winbar_fg_alter = 0.2,
    winbar_fg_combine_from = "String",
    nonetext_opacity = 0.35,
    pmenu_transparency_bg = 0.1,
    panelbottomlinenr_fg_alter = 1,
    statuslinetheme_transparency_fg = 0.5,
    linenr_transparency_fg = 0.08,
    pmenusel_transparency_bg = 0.4,
    winseparator_transparency_fg = 0.15,
    troubleindent_transparency_fg = 0.08,
    orgdirective_fg_alter = 0.2,
    zshlines_transparency_bg = 0.25,
    normalfloat_bg_alter = 0.15,
    floattitle_bg_from = "Number",

    normalnote_bg_alter = 0.25,
    normalnote_fg_alter = 19,
    linenrnote_fg_alter = 0.5,
    commentnote_fg_alter = 0.12,
    linenrnote_transparency_fg = 0.5,
  }
end

local function update_base_colors(theme)
  local cols = vim.deepcopy(base_colors)
  return vim.tbl_deep_extend("force", cols, update_col_colorscheme[theme] or {})
end

local general_overrides = function()
  local colors = update_base_colors(vim.g.colorscheme)

  local H = require "utils.highlights"
  local git_diff_add = H.get_git_fg_or_bg "DiffAdd"
  local git_diff_change = H.get_git_fg_or_bg "DiffChange"
  local git_diff_delete = H.get_git_fg_or_bg "DiffDelete"

  H.all {

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                    BASE                                     ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    { NormalNC = { inherit = "Normal" } },
    { Directory = colors.Directory },
    { EndOfBuffer = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 0.2 } } },
    { SignColumn = { bg = "NONE" } },
    { WarningMsg = { bg = "NONE" } },
    {
      NonText = {
        fg = { from = "NonText", attr = "fg", alter = 0.5, opacity = colors.nonetext_opacity or 0.25 },
        bg = "NONE",
      },
    },
    {
      WinSeparator = {
        fg = {
          from = "Normal",
          attr = "bg",
          alter = 5,
          transparency = colors.winseparator_transparency_fg or 0.5,
          color = { from = "Normal", attr = "bg" },
        },
        bg = "NONE",
      },
    },

    {
      LineNr = {
        fg = {
          from = "Normal",
          attr = "bg",
          alter = 4,
          transparency = colors.linenr_transparency_fg or 0.2,
          color = { from = "Normal", attr = "bg" },
        },
        bg = "NONE",
        bold = false,
      },
    },
    { LineNrAbove = { inherit = "LineNr" } },
    { LineNrBelow = { inherit = "LineNr" } },
    {
      Comment = {
        fg = {
          from = "Comment",
          attr = "fg",
          alter = colors.comment_fg_alter or 0,
          transparency = colors.comment_transparency_fg or 0.6,
          color = { from = "Normal", attr = "bg" },
        },
        italic = true,
      },
    },
    { ["@comment"] = { inherit = "Comment" } },
    { ["@comment.documentation"] = { fg = { from = "Comment", attr = "fg", contrast = 0.15 } } },

    {
      CursorLine = {
        bg = {
          from = "Normal",
          attr = "bg",
          alter = colors.cursorline_bg_alter or 0.2,
        },
      },
    },
    { CursorLineBright = { bg = { from = "Normal", attr = "bg", alter = colors.cursorlinebright_bg_alter or 0.5 } } },

    { SpecialKey = { bg = "NONE" } },

    {
      CursorLineNr = {
        fg = { from = "Boolean", attr = "fg" },
        bg = {
          from = "Boolean",
          attr = "fg",
          transparency = 0.2,
          color = { from = "Normal", attr = "bg" },
        },
        bold = true,
      },
    },
    { -- ini dibutuhkan untuk re-link kembali CursorLineNr akibat perubahan warna
      CursorLineNrBackup = {
        fg = { from = "Boolean", attr = "fg" },
        bg = {
          from = "Boolean",
          attr = "fg",
          transparency = 0.2,
          color = { from = "Normal", attr = "bg" },
        },

        bold = true,
      },
    },

    {
      StatusLine = {
        bg = { from = "Normal", attr = "bg", alter = -0.3 },
        fg = {
          from = "Normal",
          attr = "bg",
          contrast = 0.5,
          transparency = 0.7,
          color = { from = "Statusline", attr = "bg" },
        },
        reverse = false,
      },
    },
    { StatusLineNC = { inherit = "StatusLine" } },

    -- --------------------

    {
      StatusLineTheme = {
        bg = {
          from = "LineNr",
          attr = "fg",
          transparency = 0.2,
          color = { from = "Normal", attr = "bg" },
        },
        reverse = false,
      },
    },
    {
      StatusLineTheme = {
        fg = {
          from = "StatusLineTheme",
          attr = "bg",
          alter = colors.statuslinetheme_fg_alter or 5,
          transparency = colors.statuslinetheme_transparency_fg or 0.8,
          color = { from = "StatusLineTheme", attr = "bg" },
        },
      },
    },
    { StatusLineNCTheme = { inherit = "StatusLineTheme" } },

    -- --------------------

    {
      Pmenu = {
        fg = {
          from = "Pmenu",
          attr = "fg",
          alter = colors.pmenu_fg or 1,
        },
        bg = {
          from = "Normal",
          attr = "bg",
          alter = 2,
          transparency = colors.pmenu_transparency_bg or 0.2,
          color = { from = "Normal", attr = "bg" },
        },
        reverse = false,
      },
    },
    {
      PmenuSel = {
        fg = "NONE",
        bg = {
          from = "PmenuSel",
          attr = "bg",
          alter = 2,
          combine = { from = "Boolean", attr = "fg" },
          combine_mode = "screen",
          combine_intensity = 0.05,
          transparency = colors.pmenusel_transparency_bg or 0.05,
          color = { from = "Pmenu", attr = "bg" },
        },
        underline = false,
        reverse = false,
      },
    },

    {
      PmenuFloatBorder = {
        bg = { from = "Pmenu", attr = "bg" },
        fg = { from = "Pmenu", attr = "bg" },
      },
    },

    {
      NormalFloat = {
        bg = {
          from = "Normal",
          attr = "bg",
          alter = colors.normalfloat_bg_alter or 0.35,
        },
      },
    },
    {
      NormalFloat = {
        fg = {
          from = "NormalFloat",
          attr = "bg",
          alter = colors.normalfloat_fg_alter or 15,
          transparency = colors.normalfloat_transparency_fg or 0.8,
          color = { from = "NormalFloat", attr = "bg" },
        },
        reverse = false,
      },
    },

    {
      FloatBorder = {
        fg = {
          from = "WinSeparator",
          attr = "fg",
          alter = 0.8,
          transparency = colors.floatborder_transparency_fg or 0.45,
          color = { from = "NormalFloat", attr = "bg" },
        },
        bg = { from = "NormalFloat", attr = "bg" },
        reverse = false,
      },
    },

    {
      FloatTitle = {
        fg = { from = "Normal", attr = "bg" },
        bg = {
          from = colors.floattitle_bg_from or "Boolean",
          attr = "fg",
          combine = { from = "Normal", attr = "fg", alter = -0.5 },
          combine_mode = "subtract",
          combine_intensity = 0.5,
        },
        bold = true,
      },
    },

    {
      FloatFooter = {
        fg = {
          from = "FloatTitle",
          attr = "bg",
          alter = -0.2,
          contrast = 0.1,
        },
        bg = {
          from = "NormalFloat",
          attr = "bg",
        },
      },
    },

    {
      Folded = {
        fg = {
          from = "LineNr",
          attr = "fg",
          alter = colors.folded_fg_alter or 1.5,
          color = { from = "Normal", attr = "bg" },
          combine = { from = "Boolean", attr = "fg", alter = 0.5 },
          combine_mode = "screen",
          combine_intensity = colors.folded_fg_combine_intesity or 0.1,
        },
      },
    },
    {
      Folded = {
        bg = {
          from = "Folded",
          attr = "fg",
          transparency = colors.folded_transparency_bg or 0.05,
          color = { from = "Normal", attr = "bg" },
        },
      },
    },
    {
      FoldedSign = {
        fg = {
          from = "Folded",
          attr = "fg",
          alter = colors.foldsign_fg_alter or -0.1,
          transparency = colors.foldsign_transparency_bg or 0.7,
          color = { from = "Normal", attr = "bg" },
        },
        bg = "NONE",
      },
    },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                    SPELL                                    ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    { SpellBad = { undercurl = true, bg = "NONE", fg = "NONE", sp = "green" } },
    { SpellRare = { undercurl = true } },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                 DIFF COLOR                                  ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    { diffAdded = { fg = git_diff_add } },
    {
      diffAdded = {
        fg = { from = "diffAdded", attr = "fg", alter = 0.1 },
        bg = { from = "diffAdded", attr = "fg", transparency = 0.1, color = { from = "Normal", attr = "bg" } },
      },
    },
    { diffChanged = { fg = git_diff_change } },
    {
      diffChanged = {
        fg = { from = "diffChanged", attr = "fg", alter = 0.1 },
        bg = { from = "diffChanged", attr = "fg", transparency = 0.1, color = { from = "Normal", attr = "bg" } },
      },
    },
    { diffRemoved = { fg = git_diff_delete } },
    {
      diffRemoved = {
        fg = { from = "diffRemoved", attr = "fg", alter = 0.15 },
        bg = { from = "diffRemoved", attr = "fg", transparency = 0.1, color = { from = "Normal", attr = "bg" } },
      },
    },
    {
      diffLine = {
        fg = { from = "Type", attr = "fg", alter = 0.1 },
        bg = { from = "Type", attr = "fg", transparency = 0.3, color = { from = "Normal", attr = "bg" } },
      },
    },
    {
      diffFile = {
        fg = { from = "Type", attr = "fg", transparency = 0.8, color = { from = "Normal", attr = "bg" } },
        bg = { from = "Type", attr = "fg", transparency = 0.1, color = { from = "Normal", attr = "bg" } },
      },
    },

    { DiffAdd = { link = "diffAdded" } },
    { DiffChange = { link = "diffChanged" } },
    { DiffDelete = { link = "diffRemoved" } },

    {
      DiffText = {
        fg = { from = "diffChanged", attr = "fg", alter = 0.15 },
        bg = {
          from = "diffChanged",
          attr = "fg",
          transparency = 0.25,
          color = { from = "Normal", attr = "bg" },
        },
      },
    },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                    ERRORS                                   ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    { ErrorMsg = { bg = "NONE", fg = { from = "diffRemoved", attr = "fg", alter = 0.2 }, reverse = false } },
    { Error = { bg = "NONE", fg = { from = "diffRemoved", attr = "fg", alter = 0.2 }, reverse = false } },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                 DIAGNOSTICS                                 ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    { DiagnosticSignError = { bg = "NONE", fg = { from = "diffRemoved", attr = "fg", alter = 0.5, contrast = 0.05 } } },
    { DiagnosticSignWarn = { bg = "NONE", fg = { from = "diffChanged", attr = "fg", alter = 0.5, contrast = 0.1 } } },
    { DiagnosticSignInfo = { bg = "NONE" } },
    { DiagnosticSignHint = { bg = "NONE" } },

    { DiagnosticError = { fg = { from = "DiagnosticSignError", attr = "fg" }, bg = "NONE", italic = true } },
    { DiagnosticsErrorNumHl = { fg = "NONE", bg = "NONE" } },
    { DiagnosticWarn = { fg = { from = "DiagnosticSignWarn", attr = "fg" }, bg = "NONE", italic = true } },
    { DiagnosticsWarnNumHl = { fg = "NONE", bg = "NONE" } },
    { DiagnosticHint = { fg = { from = "DiagnosticSignHint", attr = "fg" }, bg = "NONE", italic = true } },
    { DiagnosticsHintNumHl = { fg = "NONE", bg = "NONE" } },
    { DiagnosticInfo = { fg = { from = "DiagnosticSignInfo", attr = "fg" }, bg = "NONE", italic = true } },
    { DiagnosticsInfoNumHl = { fg = "NONE", bg = "NONE" } },

    { DiagnosticFloatingWarn = { fg = { from = "DiagnosticWarn", attr = "fg" }, bg = "NONE", bold = true } },
    { DiagnosticFloatingInfo = { fg = { from = "DiagnosticInfo", attr = "fg" }, bg = "NONE", bold = true } },
    { DiagnosticFloatingHint = { fg = { from = "DiagnosticHint", attr = "fg" }, bg = "NONE", bold = true } },
    { DiagnosticFloatingError = { fg = { from = "DiagnosticError", attr = "fg" }, bg = "NONE", bold = true } },
    { DiagnosticFloatTitle = { bg = { from = "NormalFloat", attr = "bg" }, bold = true } },
    { DiagnosticFloatTitleIcon = { bg = { from = "NormalFloat", attr = "bg" }, fg = { from = "@character" } } },

    { DiagnosticVirtualTextWarn = { inherit = "DiagnosticWarn" } },
    { DiagnosticVirtualTextInfo = { inherit = "DiagnosticInfo" } },
    { DiagnosticVirtualTextHint = { inherit = "DiagnosticHint" } },
    { DiagnosticVirtualTextError = { inherit = "DiagnosticError" } },

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

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                     LSP                                     ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    { LspKindArray = { inherit = "@type" } },
    { LspKindClass = { inherit = "@type" } },
    { LspKindStruct = { inherit = "@type" } },
    { LspKindInterface = { inherit = "@type" } },
    { LspKindObject = { inherit = "@type" } },
    { LspKindEnum = { inherit = "@type" } },
    { LspKindTypeParameter = { inherit = "@type.definition" } },
    { LspKindTypeAlias = { inherit = "@type.definition" } },

    { LspKindVariable = { inherit = "@variable" } },
    { LspKindField = { inherit = "@variable.member" } },
    { LspKindProperty = { inherit = "@property" } },
    { LspKindEnumMember = { inherit = "@variable.member" } },
    { LspKindConstant = { inherit = "@constant" } },
    { LspKindKey = { inherit = "@variable.member" } },

    { LspKindFunction = { inherit = "@function" } },
    { LspKindMethod = { inherit = "@function.method" } },
    { LspKindConstructor = { inherit = "@constructor" } },

    { LspKindModule = { inherit = "@module" } },
    { LspKindPackage = { inherit = "@module" } },
    { LspKindNamespace = { inherit = "@module" } },

    { LspKindString = { inherit = "@string" } },
    { LspKindNumber = { inherit = "@number" } },
    { LspKindBoolean = { inherit = "@boolean" } },
    { LspKindValue = { inherit = "@constant" } },
    { LspKindNull = { inherit = "@constant.builtin" } },

    { LspKindKeyword = { inherit = "@keyword" } },
    { LspKindOperator = { inherit = "@operator" } },
    { LspKindSnippet = { inherit = "@comment", fg = { from = "@comment", alter = 0.5 } } },
    { LspKindFile = { inherit = "Tag" } },
    { LspKindFolder = { inherit = "Directory" } },
    { LspKindUnit = { inherit = "@type" } },
    { LspKindEvent = { inherit = "Special" } },

    {
      LspReferenceText = {
        bg = { from = "Special", attr = "fg" },
        fg = { from = "Normal", attr = "bg" },
      },
    },
    {
      LspReferenceRead = {
        fg = { from = "Normal", attr = "bg" },
        bg = {
          from = "Statement",
          attr = "fg",
          transparency = 0.1,
          color = { from = "Type", attr = "fg" },
        },
      },
    },
    {
      LspReferenceWrite = {
        fg = { from = "Normal", attr = "bg" },
        bg = {
          from = "Type",
          attr = "fg",
          transparency = 0.1,
          color = { from = "Statement", attr = "fg" },
        },
        bold = true,
      },
    },

    {
      LspSignatureActiveParameter = {
        fg = { from = "Type", attr = "fg" },
        bg = { from = "Type", attr = "fg", opacity = 0.15 },
        bold = true,
        underline = true,
      },
    },

    { ["@lsp.type.comment"] = { inherit = "@comment" } },

    -- ╔═════════════════════════════════════════════════════════╗
    -- ║                   CREATED HIGHLIGHTS                    ║
    -- ╚═════════════════════════════════════════════════════════╝

    -- ├───────────────────────────────┤ NORMALDARK ├───────────────────────────────┤

    {
      NormalKeyword = {
        fg = { from = "Normal", attr = "bg", opacity = 0.9 },
        bg = { from = "Normal", attr = "bg", opacity = 1 },
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
        fg = { from = "Normal", attr = "fg", alter = 0.5 },
        bg = { from = "Keyword", attr = "fg", alter = -0.2 },
      },
    },
    {
      Zshlines = {
        fg = { --> line
          from = "Normal",
          attr = "fg",
          alter = 0.2,
          transparency = colors.zshlines_transparency_fg or 0.18,
          color = { from = "Normal", attr = "bg" },
        },
        bg = { -- > foreground
          from = "Normal",
          attr = "bg",
          alter = colors.zshlines_bg_alter or 4,
          transparency = colors.zshlines_transparency_bg or 0.5,
          color = { from = "Normal", attr = "bg" },
        },
      },
    },
    {
      Zshprompt = {
        fg = { from = "FloatTitle", attr = "fg" },
        bg = { from = "FloatTitle", attr = "bg" },
      },
    },
    {
      ZshpromptBright = {
        fg = { from = "Keyword", attr = "fg" }, --> line
        bg = { from = "Zshprompt", attr = "bg", alter = colors.zshprompt_bg_alter or -0.65 }, -- > foreground
      },
    },

    -- ├──────────────────────────────────┤ NOTE ├──────────────────────────────────┤
    {
      NormalNote = {
        bg = {
          from = "Normal",
          attr = "bg",
          alter = colors.normalnote_bg_alter or 0.6,
        },
      },
    },
    {
      NormalNote = {
        fg = {
          from = "Normal",
          attr = "fg",
          alter = colors.normalnote_fg_alter or 6,
          transparency = colors.normalnote_transparency_fg or 0.8,
          color = { from = "NormalNote", attr = "bg" },
        },
      },
    },
    {
      LineNrNote = {
        fg = {
          from = "NormalNote",
          attr = "bg",
          alter = colors.linenrnote_fg_alter or 1,
          transparency = colors.linenrnote_transparency_fg or 0.2,
          color = { from = "NormalNote", attr = "bg" },
        },
        bg = { from = "NormalNote", attr = "bg" },
      },
    },
    {
      CommentNote = {
        fg = {
          from = "LineNrNote",
          attr = "fg",
          alter = colors.commentnote_fg_alter or 1,
          opacity = 0.8,
          is_note = true,
        },
      },
    },
    { NonTextNote = { fg = { from = "NormalNote", attr = "bg", alter = colors.nontextnote_fg_alter or 0.8 } } },
    { DelimiterNote = { fg = { from = "Boolean", attr = "fg", alter = colors.delimiternote_fg_alter or -0.25 } } },
    { CursorLineNote = { bg = { from = "NormalNote", attr = "bg" } } },
    {
      CursorLineNoteBright = {
        bg = { from = "NormalNote", attr = "bg", alter = colors.cursorlinebright_bg_alter or 0.2 },
      },
    },
    {
      CursorLineNrNote = {
        fg = { from = "Normal", attr = "bg" },
        bg = {
          from = "Function",
          attr = "fg",
          alter = 0.2,
          transparency = 0.5,
          color = { from = "NormalNote", attr = "bg" },
        },
        bold = true,
      },
    },
    {
      CursorLineNrNoteBackup = {
        fg = { from = "Normal", attr = "bg" },
        bg = {
          from = "Function",
          attr = "fg",
          alter = 0.2,
          transparency = 0.5,
          color = { from = "NormalNote", attr = "bg" },
        },
        bold = true,
      },
    },
    { FoldedNote = { fg = { from = "LineNrNote", attr = "fg", alter = 0.2 } } },
    { FoldedNoteSign = { fg = { from = "LineNrNote", attr = "fg", alter = 0.5 } } },
    {
      FloatBorderNote = {
        fg = {
          from = "NormalNote",
          attr = "fg",
          alter = 0.1,
          transparency = 0.15,
          color = { from = "NormalNote", attr = "bg" },
        },
        bg = { from = "NormalNote", attr = "bg" },
      },
    },
    {
      FloatTitleNote = {
        fg = { from = "FloatBorderNote", attr = "fg", alter = 1.5 },
        bg = { from = "FloatBorderNote", attr = "bg" },
        bold = true,
      },
    },

    {
      FloatFooterNote = {
        fg = { from = "FloatTitleNote", attr = "fg" },
        bg = "NONE",
      },
    },

    { VisualNote = { bg = { from = "Visual", attr = "bg", alter = colors.visualnote_bg_alter or 0.5 } } },
    { PmenuNote = { bg = { from = "NormalNote", attr = "bg" } } },
    {
      PmenuSelNote = {
        bg = {
          from = "NormalNote",
          attr = "bg",
          alter = 1,
          transparency = 0.5,
          color = { from = "NormalNote", attr = "bg" },
        },
      },
    },
    {
      WinSeparatorNote = {
        fg = {
          from = "NormalNote",
          attr = "fg",
          alter = 0.5,
          transparency = colors.winseparatornote_transparency_fg or 0.1,
          color = { from = "NormalNote", attr = "bg" },
        },
        bg = { from = "NormalNote", attr = "bg" },
      },
    },

    { BlinkCmpLabelKindNote = { fg = { from = "LineNrNote", attr = "fg", alter = 0.4 } } },

    -- ├───────────────────────────────┤ AI PROMPT ├────────────────────────────┤

    { NormalAiPrompt = { bg = { from = "Normal", attr = "bg", alter = -0.15 } } },
    {
      NormalAiPrompt = {
        fg = {
          from = "Normal",
          attr = "fg",
          alter = colors.normalai_fg_alter or 1,
          transparency = colors.normalai_transparency_fg or 0.65,
          color = { from = "NormalAiPrompt", attr = "bg" },
        },
      },
    },

    {
      CommentAiPrompt = {
        fg = {
          from = "NormalAiPrompt",
          attr = "fg",
          alter = colors.normale_fg_alter or 0.2,
          transparency = 0.4,
          color = { from = "NormalAiPrompt", attr = "bg" },
        },
      },
    },
    {
      NonTextAiPrompt = {
        fg = {
          from = "NormalAiPrompt",
          attr = "fg",
          alter = colors.nontextaiprompt_fg_alter or 0.2,
          transparency = 0.25,
          color = { from = "NormalAiPrompt", attr = "bg" },
        },
      },
    },
    {
      LineNrAiPrompt = {
        fg = {
          from = "NormalAiPrompt",
          attr = "fg",
          transparency = 0.15,
          color = { from = "NormalAiPrompt", attr = "bg" },
        },
        bg = { from = "NormalAiPrompt", attr = "bg" },
      },
    },
    { DelimiterAiPrompt = { fg = { from = "NormalAiPrompt", attr = "bg" } } },
    { CursorLineAiPrompt = { bg = { from = "NormalAiPrompt", attr = "bg" } } },
    {
      CursorLineNrAiPrompt = {
        fg = { from = "Keyword", attr = "fg", alter = 0.5 },
        bg = { from = "CursorLineAiPrompt", attr = "bg" },
        bold = true,
      },
    },
    { FoldedAiPrompt = { fg = { from = "LineNrAiPrompt", attr = "fg" } } },
    {
      FloatBorderAiPrompt = {
        fg = {
          from = "NormalAiPrompt",
          attr = "fg",
          transparency = 0.5,
          color = { from = "NormalAiPrompt", attr = "bg" },
        },
        bg = { from = "NormalAiPrompt", attr = "bg" },
      },
    },
    {
      FloatBorderAiPrompt = {
        fg = {
          from = "FloatBorderAiPrompt",
          attr = "fg",
          transparency = 0.2,
          color = { from = "NormalAiPrompt", attr = "bg" },
        },
      },
    },

    {
      FloatTitleAiPrompt = {
        fg = { from = "FloatBorderAiPrompt", attr = "bg" },
        bg = {
          from = "FloatTitle",
          attr = "bg",
          alter = colors.floattitleaiprompt_fg_alter or 0.5,
          combine = { from = "FloatBorderAiPrompt", attr = "fg" },
          combine_mode = "subtract",
          combine_intensity = colors.floattitleaiprompt_fg_combine_intensity or 0.8,
        },
        bold = true,
      },
    },

    {
      FloatFooterAiPrompt = {
        fg = {
          from = "FloatTitleAiPrompt",
          attr = "bg",
          transparency = 0.65,
          color = { from = "FloatBorderAiPrompt", attr = "bg" },
        },
        bg = "NONE",
      },
    },

    { VisualAiPrompt = { bg = { from = "Visual", attr = "bg" } } },
    { PmenuAiPrompt = { bg = { from = "NormalAiPrompt", attr = "bg" } } },
    {
      PmenuSelAiPrompt = {
        bg = {
          from = "NormalAiPrompt",
          attr = "bg",
          alter = 1,
          transparency = 0.5,
          color = { from = "NormalAiPrompt", attr = "bg" },
        },
      },
    },
    {
      WinSeparatorAiPrompt = {
        fg = { from = "NormalAiPrompt", attr = "bg", alter = 0.8 },
        bg = { from = "NormalAiPrompt", attr = "bg" },
      },
    },

    -- ├────────────────────────────────┤ HEADING ├─────────────────────────────┤

    { heading1 = { fg = "#4d85c3" } },
    { heading2 = { fg = "#389674" } },
    { heading3 = { fg = "#b0be1e" } },
    { heading4 = { fg = "#8594c8" } },
    { heading5 = { fg = "#f76328" } },
    { heading6 = { fg = "#fccf3e" } },

    { InactiveBorderColorLazy = { fg = { from = "WinSeparator", attr = "fg", alter = 0.2 } } },

    -- ├─────────────────────────────────┤ WINBAR ├─────────────────────────────────┤

    {
      WinBar = {
        fg = {
          from = "Normal",
          attr = "bg",
          alter = colors.winbar_fg_alter or 2,
          combine = { from = colors.winbar_fg_combine_from or "Keyword", attr = "fg" },
          combine_mode = "add",
          combine_intensity = colors.winbar_fg_combine_intensity or 0.8,
        },
        bg = { from = "Normal", attr = "bg" },
      },
    },
    { WinBarNC = { inherit = "WinBar" } },
    {
      WinBarGrey = {
        fg = { from = "NormalKeyword", attr = "fg", alter = 1.5 },
        bg = { from = "NormalKeyword", attr = "bg", opacity = 0.2 },
      },
    },
    {
      WinBarGreen = {
        fg = { from = "diffAdded", attr = "fg", alter = 0.1 },
        bg = { from = "diffAdded", attr = "fg", transparency = 0.1, color = { from = "Normal", attr = "bg" } },
      },
    },
    {
      WinBarRed = {
        fg = { from = "diffRemoved", attr = "fg", alter = 0.1 },
        bg = { from = "diffRemoved", attr = "fg", transparency = 0.1, color = { from = "Normal", attr = "bg" } },
      },
    },
    {
      WinBarYellow = {
        fg = { from = "diffChanged", attr = "fg", alter = 0.1 },
        bg = { from = "diffChanged", attr = "fg", transparency = 0.1, color = { from = "Normal", attr = "bg" } },
      },
    },
    {
      WinBarAiPrompt = {
        fg = { from = "NormalAiPrompt", attr = "bg", alter = 1 },
        bg = {
          from = "NormalAiPrompt",
          attr = "bg",
          alter = 1,
          transparency = 0.1,
          color = { from = "NormalAiPrompt", attr = "bg" },
        },
      },
    },

    {
      WinBarNote = {
        fg = {
          from = "WinBar",
          attr = "fg",
          transparency = 0.9,
          color = { from = "NormalNote", attr = "bg" },
        },
        bg = { from = "NormalNote", attr = "bg" },
      },
    },

    {
      TabLine = {
        fg = {
          from = "WinBar",
          attr = "fg",
          transparency = 0.5,
          color = { from = "Normal", attr = "bg" },
        },
        bg = "NONE",
      },
    },

    -- ├──────────────────────────────────┤ TMUX ├──────────────────────────────────┤
    {
      TmuxStatusline = {
        fg = { from = "WinBar", attr = "fg", alter = 0.5 },
        bg = { from = "WinBar", attr = "fg", alter = 0.15 },
      },
    },

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

    -- ───────────────────────────────[ OCTO ]────────────────────────────
    {
      OctoStatusColumn = {
        fg = { from = "Error", attr = "fg", alter = 0.1, opacity = 0.8 },
      },
    },

    --  ──────────────────────────[ CODECOMPANION ]────────────────────────────

    -- {
    --   CodeCompanionInputHeader = {
    --     fg = { from = "DiffDelete", attr = "bg", alter = 2 },
    --     bg = { from = "DiffDelete", attr = "bg", alter = 0.2 },
    --     bold = true,
    --   },
    -- },

    --  ────────────────────────────[ VIM.MATCHUP ]────────────────────────────
    -- { MatchParen = { bg = { from = "Normal", attr = "bg", alter = -1 }, fg = "white", bold = false } },

    --  ──────────────────────────────[ LAZYVIM ]──────────────────────────────
    { LazyNormal = { inherit = "NormalFloat" } },
    { LazyDimmed = { bg = "NONE" } },

    --  ─────────────────────────────[ OVERSEER ]──────────────────────────
    { OverseerTaskBorder = { fg = { from = "WinSeparator", attr = "fg" }, bg = "NONE" } },
  }
end

local plugins_overrides = function()
  local H = require "utils.highlights"
  local colors = update_base_colors(vim.g.colorscheme)
  return H.all {

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                    NOICE                                    ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    {
      NoiceCmdline = {
        fg = { from = "StatusLineTheme", attr = "fg", alter = 1.5 },
        bg = { from = "StatusLineTheme", attr = "bg" },
      },
    },

    -- Highlight :Messages noice
    { NoiceSplit = { bg = { from = "NormalKeyword", attr = "bg", alter = -0.6, opacity = 0.7 } } },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                    BLINK                                    ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    {
      BlinkDocNormal = {
        inherit = "NormalFloat",
        fg = { from = "Normal", attr = "fg" },
      },
    },
    {
      BlinkDocFloatBorder = {
        inherit = "NormalFloat",
        fg = { from = "BlinkDocNormal", attr = "bg" },
      },
    },

    { BlinkCmpSignatureHelp = { bg = { from = "Normal", attr = "bg", alter = 0.45 } } },
    {
      BlinkCmpSignatureHelpBorder = {
        bg = { from = "BlinkCmpSignatureHelp", attr = "bg" },
        fg = { from = "BlinkCmpSignatureHelp", attr = "bg" },
      },
    },

    {
      BlinkCmpLabelDeprecated = {
        fg = { from = "Keyword", attr = "fg", alter = -0.3 },
        strikethrough = true,
        italic = true,
      },
    },
    {
      BlinkCmpDocBorder = {
        inherit = "FloatBorder",
        bg = { from = "BlinkDocNormal" },
      },
    },

    {
      BlinkCmpGhostText = {
        fg = { from = "NoiceCmdline", attr = "fg", alter = 0.1 },
        bg = "NONE",
      },
    },
    {
      BlinkCmpDocSeparator = {
        fg = { from = "BlinkDocNormal", attr = "bg", alter = 0.5 },
        bg = { from = "BlinkDocNormal", attr = "bg" },
      },
    },
    {
      BlinkCmpLabelMatch = {
        fg = {
          from = "Constant",
          attr = "fg",
          combine = { from = "Boolean", attr = "fg", alter = 0.8 },
          combine_mode = "multiply",
          combine_intensity = 0.4,
          contrast = 0.08,
        },
        bold = true,
      },
    },
    {
      BlinkCmpLabelKind = {
        fg = {
          from = "Normal",
          attr = "fg",
          alter = 0.2,
          transparency = 0.2,
          color = { from = "Pmenu", attr = "bg" },
        },
      },
    },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                  GITSIGNS                                   ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    { GitSignsAdd = { fg = { from = "diffAdded", attr = "fg", alter = 0.3 }, bg = "NONE" } },
    { GitSignsChange = { fg = { from = "diffChanged", attr = "fg", alter = 0.3 }, bg = "NONE" } },
    { GitSignsDelete = { fg = { from = "diffRemoved", attr = "fg", alter = 0.3 }, bg = "NONE" } },

    { GitSignsAddInline = { link = "diffAdded" } },
    { GitSignsChangeInline = { link = "diffChanged" } },
    { GitSignsDeleteInline = { link = "diffRemoved" } },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                   NEOGIT                                    ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    { NeogitDiffAdd = { inherit = "diffAdded" } },
    { NeogitDiffDelete = { inherit = "diffRemoved" } },

    { NeogitDiffAddHighlight = { inherit = "NeogitDiffAdd" } },
    { NeogitDiffDeleteHighlight = { inherit = "NeogitDiffDelete" } },

    { NeogitDiffAddCursor = { inherit = "NeogitDiffAdd" } },
    { NeogitDiffDeleteCursor = { inherit = "NeogitDiffDelete" } },

    {
      NeogitDiffAddInline = {
        inherit = "NeogitDiffAddCursor",
        fg = { from = "diffAdded", attr = "fg", alter = 0.8 },
      },
    },
    {
      NeogitDiffDeleteInline = {
        inherit = "NeogitDiffDeleteCursor",
        fg = { from = "diffRemoved", attr = "fg", alter = 0.8 },
      },
    },

    {
      NeogitHunkHeader = {
        fg = { from = "Type", attr = "fg", transparency = 0.8, color = { from = "Normal", attr = "bg" } },
        bg = { from = "Type", attr = "fg", transparency = 0.1, color = { from = "Normal", attr = "bg" } },
      },
    },
    {
      NeogitHunkHeaderHighlight = {
        fg = { from = "Type", attr = "fg" },
        bg = { from = "Type", attr = "fg", transparency = 0.3, color = { from = "Normal", attr = "bg" } },
      },
    },
    { NeogitHunkHeaderCursor = { inherit = "NeogitHunkHeaderHighlight" } },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                  FUGITIVE                                   ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    -- { fugitiveStagedModifier = { inherit = "GitSignsAdd" } },
    -- { fugitiveUnstagedModifier = { inherit = "GitSignsChange" } },
    -- { fugitiveUntrackedModifier = { fg = { from = "GitSignsAdd", attr = "fg", alter = 0.2 } } },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                   FZFLUA                                    ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    -- ├─────────────────────────────────┤ PROMPT ├─────────────────────────────────┤

    {
      FzfLuaNormal = {
        fg = { from = "NormalFloat", attr = "fg" },
        bg = { from = "NormalFloat", attr = "bg" },
      },
    },
    {
      FzfLuaFilePart = {
        fg = { from = "Keyword", attr = "fg", alter = 0.15 },
        bg = { from = "FzfLuaNormal", attr = "bg" },
        bold = false,
      },
    },
    {
      FzfLuaBorder = {
        fg = { from = "FloatBorder", attr = "fg" },
        bg = { from = "FloatBorder", attr = "bg" },
      },
    },
    {
      FzfLuaTitle = {
        fg = { from = "FloatTitle", attr = "fg" },
        bg = { from = "FloatTitle", attr = "bg" },
        bold = true,
      },
    },

    { FzfLuaDirPart = { inherit = "FzfLuaFilePart" } },
    {
      FzfLuaHeaderText = {
        fg = {
          from = "type",
          attr = "fg",
          alter = 1,
          transparency = 0.8,
          color = { from = "FzfLuaFilePart", attr = "bg" },
        },
        bg = {
          from = "FzfLuaNormal",
          attr = "bg",
          alter = 1,
          transparency = colors.fzfluaheadertext or 0.6,
          color = { from = "FzfLuaNormal", attr = "bg" },
        },
      },
    },
    { FzfLuaFzfMatchFuzzy = { fg = { from = "BlinkCmpLabelMatch", attr = "fg", alter = 0.1 }, bg = "NONE" } },
    {
      FzfLuaFzfMatch = {
        fg = { from = "BlinkCmpLabelMatch" },
        bg = "NONE",
        bold = true,
      },
    },

    {
      FzfLuaSel = {
        fg = { from = "FzfLuaFilePart", attr = "fg", alter = 0.2 },
        bg = { from = "PmenuSel", attr = "bg" },
        bold = true,
      },
    },

    {
      FzfLuaBufLineNr = {
        fg = { from = "FzfLuaNormal", attr = "bg", alter = 1.5 },
        bg = {
          from = "FzfLuaNormal",
          attr = "bg",
          alter = 0.5,
          transparency = 0.2,
          color = { from = "FzfLuaNormal", attr = "bg" },
        },
      },
    },

    { -- custom color untuk marker fzf
      MarkerFzflua = {
        fg = { from = "Error", attr = "fg", alter = 0.4 },
        bg = "NONE",
      },
    },

    -- ├────────────────────────────────┤ PREVIEW ├─────────────────────────────┤

    {
      FzfLuaPreviewNormal = {
        inherit = "FzfLuaNormal",
        bg = { from = "FzfLuaNormal", attr = "bg" },
      },
    },
    { FzfLuaPreviewBorder = { inherit = "FzfLuaBorder", bold = true } },
    { FzfLuaPreviewTitle = { inherit = "FzfLuaTitle", bold = true } },
    { FzfLuaScrollBorderFull = { fg = { from = "FzfLuaBorder", attr = "fg", alter = 0.3 } } },
    {
      FzfLuaCursorLine = {
        fg = "NONE",
        bg = { from = "FzfLuaNormal", attr = "bg" },
      },
    },

    {
      FzfLuaCursorLineNr = {
        fg = { from = "Directory", attr = "fg", alter = -0.25 },
        bg = { from = "FzfLuaCursorLine", attr = "bg" },
      },
    },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                  TELESCOPE                                  ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    { TelescopeNormal = { inherit = "FzfLuaNormal" } },
    { TelescopeBorder = { inherit = "FzfLuaBorder" } },
    { TelescopeMatching = { link = "FzfLuaFzfMatch" } },
    { TelescopeTitle = { inherit = "FzfLuaTitle" } },

    { TelescopeSelection = { inherit = "FzfLuaSel" } },
    { TelescopeSelectionCaret = { bg = "NONE", fg = "green" } },

    -- ├─────────────────────────────────┤ PROMPT ├─────────────────────────────────┤

    { TelescopePromptNormal = { inherit = "FzfLuaNormal" } },
    { TelescopePromptTitle = { inherit = "FzfLuaPreviewTitle" } },
    { TelescopePromptBorder = { inherit = "FzfLuaBorder" } },
    { TelescopePromptPrefix = { fg = { from = "FzfLuaBorder", attr = "fg" }, bg = "NONE" } },
    { TelescopePromptCounter = { fg = { from = "FzfLuaBorder", attr = "fg" } } },

    -- ├────────────────────────────────┤ PREVIEW ├─────────────────────────────┤

    { TelescopePreviewNormal = { inherit = "FzfLuaPreviewNormal" } },
    { TelescopePreviewTitle = { inherit = "FzfLuaPreviewTitle" } },
    { TelescopePreviewBorder = { inherit = "FzfLuaBorder" } },

    -- ├────────────────────────────────┤ RESULTS ├─────────────────────────────┤

    {
      TelescopeResultsNormal = {
        fg = { from = "FzfLuaFilePart", attr = "fg" },
        bg = { from = "FzfLuaNormal", attr = "bg" },
      },
    },
    { TelescopeResultsTitle = { inherit = "FzfLuaPreviewTitle" } },
    { TelescopeResultsBorder = { inherit = "FzfLuaBorder" } },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                   SNACKS                                    ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    -- ├─────────────────────────────────┤ PROMPT ├─────────────────────────────────┤

    { SnacksPickerFile = { link = "FzfLuaFilePart" } },
    { SnacksPickerDir = { link = "FzfLuaDirPart" } },
    { SnacksPickerMatch = { fg = { from = "FzfLuaFzfMatch", attr = "fg" } } },
    { SnacksPickerManSection = { link = "FzfLuaFzfMatchFuzzy" } },
    { SnacksPickerCursorLine = { link = "FzfLuaCursorLine" } },
    { SnacksPickerPreviewCursorLine = { link = "FzfLuaCursorLine" } },

    { SnacksPickerList = { inherit = "FzfLuaNormal" } },
    { SnacksPickerListBorder = { bg = { from = "FzfLuaNormal", attr = "bg" } } },

    -- Prompt
    { SnacksPickerPrompt = { bg = { from = "Normal", attr = "bg" } } },
    { SnacksPickerListCursorLine = { inherit = "FzfLuaSel", bold = true } },

    { SnacksPickerBorder = { link = "FzfLuaBorder" } },
    { SnacksPickerBoxBorder = { inherit = "FzfLuaBorder" } },
    { SnacksPickerInputBorder = { inherit = "FzfLuaBorder" } },

    { SnacksPickerPreview = { link = "FzfLuaPreviewNormal" } },
    { SnacksPickerPreviewBorder = { link = "FzfLuaPreviewBorder" } },

    -- ├────────────────────────────┤ SNACKS DASHBOARD ├────────────────────────────┤

    { SnacksDashboardTitle = { fg = { from = "Keyword", attr = "fg" }, bg = "NONE", bold = true } },
    { SnacksDashboardDesc = { fg = { from = "Keyword", attr = "fg" }, bg = "NONE", bold = true } },
    { SnacksDashboardDir = { fg = { from = "Keyword", attr = "fg", alter = -0.3 }, bg = "NONE" } },

    { SnacksDashboardTerminal = { fg = { from = "Keyword", attr = "fg" }, bg = "NONE", bold = false } },
    { SnacksDashboardFooter = { fg = { from = "Keyword", attr = "fg", alter = -0.3 }, bg = "NONE", bold = true } },

    -- ├─────────────────────────────┤ SNACKS INDENT ├──────────────────────────┤

    {
      SnacksIndentScope = {
        fg = { from = "DiagnosticOk", attr = "fg", opacity = 0.35 },
        bg = "NONE",
      },
    },

    -- ├────────────────────────────┤ SNACKS NOTIFIER ├─────────────────────────┤

    -- ╭──────╮
    -- │ INFO │
    -- ╰──────╯
    {
      SnacksNotifierInfo = {
        fg = { from = "String", attr = "fg", alter = 0.1 },
        bg = { from = "String", attr = "fg", alter = 0.1, transparency = 0.2, color = { from = "Normal", attr = "bg" } },
      },
    },
    {
      SnacksNotifierBorderInfo = {
        fg = { from = "SnacksNotifierInfo", attr = "bg", alter = 0.25 },
        bg = { from = "SnacksNotifierInfo", attr = "bg" },
      },
    },
    {
      SnacksNotifierTitleInfo = {
        fg = { from = "SnacksNotifierBorderInfo", attr = "fg", alter = 0.8 },
        bg = { from = "SnacksNotifierInfo", attr = "bg" },
        bold = true,
      },
    },

    -- ╭──────╮
    -- │ WARN │
    -- ╰──────╯
    {
      SnacksNotifierWarn = {
        fg = { from = "Type", attr = "fg", alter = 0.2 },
        bg = { from = "Type", attr = "fg", opacity = 0.2 },
      },
    },
    {
      SnacksNotifierBorderWarn = {
        fg = { from = "SnacksNotifierWarn", attr = "bg", alter = 0.25 },
        bg = { from = "SnacksNotifierWarn", attr = "bg" },
      },
    },
    {
      SnacksNotifierTitleWarn = {
        fg = { from = "SnacksNotifierBorderWarn", attr = "fg", alter = 0.8 },
        bg = { from = "SnacksNotifierWarn", attr = "bg" },
        bold = true,
      },
    },

    -- ╭───────╮
    -- │ ERROR │
    -- ╰───────╯
    {
      SnacksNotifierError = {
        fg = { from = "ErrorMsg", attr = "fg", alter = 0.2 },
        bg = { from = "ErrorMsg", attr = "fg", opacity = 0.2 },
      },
    },
    {
      SnacksNotifierBorderError = {
        fg = { from = "SnacksNotifierError", attr = "bg", alter = 0.25 },
        bg = { from = "SnacksNotifierError", attr = "bg" },
      },
    },
    {
      SnacksNotifierTitleError = {
        fg = { from = "SnacksNotifierBorderError", attr = "fg", alter = 0.8 },
        bg = { from = "SnacksNotifierError", attr = "bg" },
        bold = true,
      },
    },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                  MARKDOWN                                   ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    {
      ["@markup.heading.1.markdown"] = {
        fg = { from = "heading1", attr = "fg", alter = 0.6 },
        bg = "NONE",
        bold = true,
      },
    },
    {
      ["@markup.heading.1.markdown_ai"] = {
        fg = { from = "@markup.heading.1.markdown", attr = "fg" },
        bg = {
          from = "heading1",
          attr = "fg",
          transparency = 0.05,
          color = { from = "NormalAiPrompt", attr = "bg" },
        },
        bold = true,
      },
    },

    {
      ["@markup.heading.2.markdown"] = {
        fg = { from = "heading2", attr = "fg", alter = 0.6 },
        bg = "NONE",
        bold = true,
      },
    },
    {
      ["@markup.heading.2.markdown_ai"] = {
        fg = { from = "@markup.heading.2.markdown", attr = "fg" },
        bg = {
          from = "heading2",
          attr = "fg",
          transparency = 0.05,
          color = { from = "NormalAiPrompt", attr = "bg" },
        },
        bold = true,
      },
    },
    -- Color untuk person `## Me` di codecompanion
    {
      ["@markup.heading.2.markdown_ai_person"] = {
        fg = { from = "NormalAiPrompt", attr = "fg" },
        bg = {
          from = "NormalAiPrompt",
          attr = "bg",
          alter = 0.8,
          transparency = 0.5,
          color = { from = "NormalAiPrompt", attr = "bg" },
        },
        bold = true,
      },
    },

    {
      ["@markup.heading.3.markdown"] = {
        fg = { from = "heading3", attr = "fg", alter = 0.6 },
        bg = "NONE",
        bold = true,
      },
    },
    {
      ["@markup.heading.3.markdown_ai"] = {
        fg = { from = "@markup.heading.3.markdown", attr = "fg" },
        bg = {
          from = "heading3",
          attr = "fg",
          transparency = 0.05,
          color = { from = "NormalAiPrompt", attr = "bg" },
        },
        bold = true,
      },
    },
    {
      ["@markup.heading.4.markdown"] = {
        fg = { from = "heading4", attr = "fg", alter = 0.6 },
        bg = "NONE",
        bold = true,
      },
    },
    {
      ["@markup.heading.4.markdown_ai"] = {
        fg = { from = "@markup.heading.4.markdown", attr = "fg" },
        bg = {
          from = "heading4",
          attr = "fg",
          transparency = 0.05,
          color = { from = "NormalAiPrompt", attr = "bg" },
        },
        bold = true,
      },
    },
    {
      ["@markup.heading.5.markdown"] = {
        fg = { from = "heading5", attr = "fg", alter = 0.6 },
        bg = "NONE",
        bold = true,
      },
    },
    {
      ["@markup.heading.5.markdown_ai"] = {
        fg = { from = "@markup.heading.5.markdown", attr = "fg" },
        bg = {
          from = "heading5",
          attr = "fg",
          transparency = 0.05,
          color = { from = "NormalAiPrompt", attr = "bg" },
        },
        bold = true,
      },
    },
    {
      ["@markup.heading.6.markdown"] = {
        fg = { from = "heading6", attr = "fg", alter = 0.6 },
        bg = "NONE",
        bold = true,
      },
    },
    {
      ["@markup.heading.6.markdown_ai"] = {
        fg = { from = "@markup.heading.6.markdown", attr = "fg" },
        bg = {
          from = "heading6",
          attr = "fg",
          transparency = 0.05,
          color = { from = "NormalAiPrompt", attr = "bg" },
        },
        bold = true,
      },
    },

    { RenderMarkdownH1Bg = { inherit = "@markup.heading.1.markdown" } },
    { RenderMarkdownH2Bg = { inherit = "@markup.heading.2.markdown" } },
    { RenderMarkdownH3Bg = { inherit = "@markup.heading.3.markdown" } },
    { RenderMarkdownH4Bg = { inherit = "@markup.heading.4.markdown" } },
    { RenderMarkdownH5Bg = { inherit = "@markup.heading.5.markdown" } },
    { RenderMarkdownH6Bg = { inherit = "@markup.heading.6.markdown" } },

    {
      ["@markup.raw.block.markdown"] = {
        fg = { from = "NormalNote", attr = "fg" },
        bg = { from = "NormalNote", attr = "bg" },
      },
    },
    { ["@markup.list.markdown"] = { bg = "NONE" } },

    {
      ["@markup.quote.markdown"] = {
        bg = {
          from = "Boolean",
          attr = "fg",
          alter = 0.1,
          transparency = 0.1,
          color = { from = "NormalNote", attr = "bg" },
        },
        fg = { from = "Boolean", attr = "fg", alter = 0.1 },
        italic = true,
        bold = false,
      },
    },

    {
      ["@markup.quote.markdown.AiPrompt"] = {
        fg = {
          from = "Keyword",
          attr = "fg",
          alter = 0.1,
          transparency = 0.7,
          color = { from = "NormalAiPrompt", attr = "bg" },
        },
        bg = { from = "NormalAiPrompt", attr = "bg", alter = 0.25 },
        italic = true,
        bold = false,
      },
    },
    { RenderMarkdownQuote1 = { inherit = "@markup.quote.markdown" } },
    { RenderMarkdownQuote2 = { inherit = "@markup.quote.markdown" } },
    { RenderMarkdownQuote3 = { inherit = "@markup.quote.markdown" } },
    { RenderMarkdownQuote4 = { inherit = "@markup.quote.markdown" } },
    { RenderMarkdownQuote5 = { inherit = "@markup.quote.markdown" } },
    { RenderMarkdownQuote6 = { inherit = "@markup.quote.markdown" } },

    {
      ["@markup.strong.markdown_inline"] = {
        fg = {
          from = "NormalNote",
          attr = "fg",
          alter = 0.1,
          transparency = 0.7,
          color = { from = "Statement", attr = "fg" },
        },
        bg = "NONE",
        bold = true,
      },
    },
    {
      ["@markup.italic.markdown_inline"] = {
        fg = { from = "@markup.quote.markdown", attr = "fg", alter = 0.5 },
        bg = "NONE",
        bold = false,
        italic = true,
      },
    },
    {
      ["@punctuation.special.markdown"] = {
        fg = { from = "@markup.quote.markdown", attr = "bg" },
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

    -- Code block
    {
      RenderMarkdownCode = {
        bg = { from = "NormalNote", attr = "bg", alter = colors.codeblock_bg_alter or 0.3, is_note = true },
        italic = false,
      },
    },
    {
      RenderMarkdownCode = {
        bg = {
          from = "RenderMarkdownCode",
          attr = "bg",
          transparency = 0.4,
          color = { from = "NormalNote", attr = "bg" },
        },
      },
    },

    { RenderMarkdownCodeBorder = { bg = { from = "RenderMarkdownCode", attr = "bg", alter = 0.05 } } },
    { RenderMarkdownCodeBorder = { fg = { from = "RenderMarkdownCodeBorder", attr = "bg", alter = 0.8 } } },

    -- Code inline
    {
      RenderMarkdownCodeInline = {
        fg = { from = "String", attr = "fg", alter = -0.02 },
        bg = {
          from = "String",
          attr = "fg",
          alter = -0.5,
          transparency = 0.2,
          color = { from = "NormalNote", attr = "bg" },
        },
      },
    },
    {
      RenderMarkdownCodeInlineAiPrompt = {
        fg = { from = "RenderMarkdownCodeInline", attr = "fg" },
        bg = {
          from = "String",
          attr = "fg",
          transparency = 0.1,
          color = { from = "NormalAiPrompt", attr = "bg" },
        },
      },
    },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                   ORGMODE                                   ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    -- ├─────────────────────────────────┤ Agenda ├─────────────────────────────────┤
    { ["@org.agenda.scheduled"] = { fg = { from = "String", attr = "fg", contrast = 0.2 } } },
    {
      ["@org.agenda.scheduled_past"] = {
        fg = { from = "String", attr = "fg", transparency = 0.2, color = { from = "diffChanged", attr = "fg" } },
      },
    },
    { ["@org.agenda.day"] = { fg = { from = "Statement", attr = "fg", alter = 0.1 } } },
    { ["@org.agenda.today"] = { fg = { from = "@org.agenda.day", attr = "fg", alter = 0.4 }, bold = true } },
    {
      ["@org.agenda.weekend"] = {
        fg = {
          from = "@org.agenda.day",
          attr = "fg",
          alter = 0.1,
          transparency = 0.3,
          color = { from = "Error", attr = "fg" },
        },
      },
    },
    { ["@org.agenda.weekend.today"] = { inherit = "@org.agenda.today" } },

    {
      ["@org.agenda.header"] = {
        fg = {
          from = "StatusLineTheme",
          attr = "fg",
          alter = 0.1,
        },
        bg = { from = "StatusLineTheme", attr = "bg" },
      },
    },

    { OrgVerbatim = { inherit = "RenderMarkdownCodeInline" } },

    -- ├────────────────────────────────┤ Headline ├────────────────────────────────┤
    { ["Headline"] = { bg = "NONE" } },
    { ["Headline1"] = { inherit = "@markup.heading.1.markdown" } },
    { ["@org.headline.level1"] = { inherit = "@markup.heading.1.markdown" } },
    { ["Headline2"] = { inherit = "@markup.heading.2.markdown" } },
    { ["@org.headline.level2"] = { inherit = "@markup.heading.2.markdown" } },
    { ["Headline3"] = { inherit = "@markup.heading.3.markdown" } },
    { ["@org.headline.level3"] = { inherit = "@markup.heading.3.markdown" } },
    { ["Headline4"] = { inherit = "@markup.heading.4.markdown" } },
    { ["@org.headline.level4"] = { inherit = "@markup.heading.4.markdown" } },
    { ["Headline5"] = { inherit = "@markup.heading.5.markdown" } },
    { ["@org.headline.level5"] = { inherit = "@markup.heading.5.markdown" } },
    { ["Headline6"] = { inherit = "@markup.heading.6.markdown" } },
    { ["@org.headline.level6"] = { inherit = "@markup.heading.6.markdown" } },

    -- ├──────────────────────────────────┤ Misc ├──────────────────────────────────┤
    { ["@org.timestamp.active"] = { inherit = "PreProc" } },
    { ["@org.checkbox.halfchecked"] = { inherit = "PreProc" } },
    { ["@org.properties"] = { inherit = "Constant" } },
    { ["@org.drawer"] = { inherit = "Constant" } },
    { ["@org.plan.org"] = { inherit = "Constant" } },
    { ["@org.latex"] = { inherit = "Statement" } },
    {
      ["@org.directive"] = {
        fg = {
          from = "LineNrNote",
          attr = "fg",
          alter = colors.orgdirective_fg_alter or 0.45,
        },
      },
    },
    { ["@org.tag.org"] = { fg = { from = "@org.directive", attr = "fg", alter = 0.5 } } },
    { OrgBulletsDash = { inherit = "Special", bg = "NONE" } },
    { ["@org.bold"] = { inherit = "@markup.strong.markdown_inline", bold = true } },
    { ["@org.italic"] = { inherit = "@markup.italic.markdown_inline" } },
    {
      ["@org.comment.org"] = {
        inherit = "@markup.italic.markdown_inline",
        bg = { from = "NormalNote", attr = "bg", alter = 0.2 },
      },
    },

    { ["@org.code"] = { inherit = "RenderMarkdownCodeInline" } },

    {
      ["@org.block.org"] = {
        fg = {
          from = "RenderMarkdownCodeInline",
          attr = "bg",
          alter = 0.2,
        },
      },
    },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                  ORG.NVIM                                   ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    { CodeBlock = { inherit = "RenderMarkdownCode", reverse = false } },
    {
      CodeBlockFiletypeText = {
        bg = {
          from = "String",
          attr = "fg",
          alter = -0.2,
          transparency = 0.1,
          color = { from = "NormalNote", attr = "bg" },
        },
      },
    },
    {
      CodeBlockFiletypeJson = {
        bg = {
          from = "Boolean",
          attr = "fg",
          transparency = 0.1,
          color = { from = "NormalNote", attr = "bg" },
        },
      },
    },
    {
      CodeBlockFiletypeDb = {
        bg = {
          from = "Type",
          attr = "fg",
          transparency = 0.05,
          color = { from = "NormalNote", attr = "bg" },
        },
      },
    },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                   LAZYGIT                                   ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    { LazygitselectedLineBgColor = { bg = { from = "Keyword", attr = "fg", alter = -0.6 } } },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                TODO-COMMENT                                 ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    { TodoSignWarn = { bg = "NONE" } },
    { TodoSignFIX = { bg = "NONE" } },
    { TodoSignTODO = { bg = "NONE" } },
    { TodoSignNOTE = { bg = "NONE" } },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                    MASON                                    ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    { MasonNormal = { bg = { from = "NormalFloat", attr = "bg" } } },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                    FLASH                                    ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    { FlashLabel = { fg = "white", bg = "red", bold = true } },
    { FlashMatch = { fg = "white", bg = "blue", bold = true, strikethrough = false } },
    { FlashCursor = { bg = { from = "ColorColumn", attr = "bg", alter = 5 }, bold = true } },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                 NOTIFY.NVIM                                 ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    { NotifyBackground = { inherit = "SnacksNotifierInfo" } },

    -- ╭──────╮
    -- │ INFO │
    -- ╰──────╯
    { NotifyINFOBody = { inherit = "SnacksNotifierInfo" } },
    { NotifyINFOBorder = { inherit = "SnacksNotifierBorderInfo" } },
    { NotifyINFOTitle = { inherit = "SnacksNotifierTitleInfo" } },
    { NotifyINFOIcon = { inherit = "SnacksNotifierBorderInfo" } },

    -- ╭──────╮
    -- │ WARN │
    -- ╰──────╯
    { NotifyWARNBody = { inherit = "SnacksNotifierWarn" } },
    { NotifyWARNBorder = { inherit = "SnacksNotifierBorderWarn" } },
    { NotifyWARNTitle = { inherit = "SnacksNotifierTitleWarn" } },
    { NotifyWARNIcon = { inherit = "SnacksNotifierBorderWarn" } },

    -- ╭───────╮
    -- │ ERROR │
    -- ╰───────╯
    { NotifyERRORBody = { inherit = "SnacksNotifierError" } },
    { NotifyERRORBorder = { inherit = "SnacksNotifierBorderError" } },
    { NotifyERRORTitle = { inherit = "SnacksNotifierTitleError" } },
    { NotifyERRORIcon = { inherit = "SnacksNotifierBorderError" } },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                  COVERAGE                                   ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    { CoverageCovered = { bg = { from = "diffAdded", attr = "fg", alter = 0.5 } } },
    { CoveragePartial = { bg = { from = "diffChanged", attr = "fg", alter = 0.5 } } },
    { CoverageUncovered = { bg = { from = "diffRemoved", attr = "fg", alter = 0.5 } } },

    { CoverageSummaryFail = { bg = { from = "diffRemoved", attr = "fg", alter = 0.5 } } },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                  DEBUG DAP                                  ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜
    {
      DapBreakpoint = {
        fg = { from = "diffRemoved", attr = "fg", alter = 0.1, contrast = 0.4 },
        bg = "NONE",
      },
    },

    { DapUIRestartNC = { inherit = "Normal", fg = { from = "Repeat", attr = "fg" } } },
    { DapUINormalNC = { inherit = "Normal", fg = { from = "Repeat", attr = "fg" } } },
    { DapUIPlayPauseNC = { inherit = "Normal", fg = { from = "Repeat", attr = "fg" } } },
    { DapUIStopNC = { inherit = "Normal", fg = { from = "PreProc", attr = "fg" } } },
    { DapUIUnavailableNC = { inherit = "Normal", fg = { from = "Comment", attr = "fg" } } },
    { DapUIStepOverNC = { inherit = "Normal", fg = { from = "Label", attr = "fg" } } },
    { DapUIStepIntoNC = { inherit = "Normal", fg = { from = "Label", attr = "fg" } } },
    { DapUIStepBackNC = { inherit = "Normal", fg = { from = "Label", attr = "fg" } } },
    { DapUIStepOutNC = { inherit = "Normal", fg = { from = "Label", attr = "fg" } } },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                  WHICH KEY                                  ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    {
      WhichKeyNormal = {
        bg = {
          from = "NormalFloat",
          attr = "bg",
        },
      },
    },
    { WhichKey = { bg = { from = "WhichKeyNormal", attr = "bg" } } },
    { WhichKeySeparator = { inherit = "WhichKeyNormal" } },
    { WhichKeyGroup = { inherit = "WhichKeyNormal", fg = { from = "Keyword", attr = "fg", alter = 0.1 } } },
    { WhichKeyDesc = { inherit = "WhichKeyNormal", fg = { from = "Boolean", attr = "fg", alter = 0.1 } } },
    { WhichKeyBorder = { inherit = "WhichKeyNormal" } },
    { WhichKeyTitle = { inherit = "FzfLuaTitle" } },
    {
      WhichKeyIcon = {
        fg = "NONE",
        bg = {
          from = "WhichKeyNormal",
          attr = "bg",
        },
        sp = "NONE",
        underline = false,
        reverse = false,
      },
    },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                    NAVIC                                    ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    { NavicText = { inherit = "WinBar" } },
    { NavicIconsText = { inherit = "LspKindText" } },
    { NavicIconsBoolean = { inherit = "LspKindBoolean" } },
    { NavicIconsVariable = { inherit = "LspKindVariable" } },
    { NavicIconsConstant = { inherit = "LspKindConstant" } },
    { NavicIconsModule = { inherit = "LspKindModule" } },
    { NavicIconsPackage = { inherit = "LspKindPackage" } },
    { NavicIconsKeyword = { inherit = "LspKindKeyword" } },
    { NavicIconsFunction = { inherit = "LspKindFunction" } },
    { NavicIconsStruct = { inherit = "LspKindStruct" } },
    { NavicIconsArray = { inherit = "LspKindObject" } },
    { NavicIconsOperator = { inherit = "LspKindOperator" } },
    { NavicIconsObject = { inherit = "LspKindObject" } },
    { NavicIconsString = { inherit = "LspKindString" } },
    { NavicIconsField = { inherit = "LspKindField" } },
    { NavicIconsNumber = { inherit = "LspKindNumber" } },
    { NavicIconsProperty = { inherit = "LspKindProperty" } },
    { NavicIconsReference = { inherit = "LspKindReference" } },
    { NavicIconsEvent = { inherit = "LspKindEvent" } },
    { NavicIconsFile = { inherit = "LspKindFile" } },
    { NavicIconsFolder = { inherit = "LspKindFolder" } },
    { NavicIconsInterface = { inherit = "LspKindInterface" } },
    { NavicIconsKey = { inherit = "LspKindKey" } },
    { NavicIconsMethod = { inherit = "LspKindMethod" } },
    { NavicIconsNamespace = { inherit = "LspKindNamespace" } },
    { NavicIconsNull = { inherit = "LspKindNull" } },
    { NavicIconsUnit = { inherit = "LspKindUnit" } },
    { NavicIconsEnum = { inherit = "LspKindEnum" } },
    { NavicIconsEnumMember = { inherit = "LspKindEnumMember" } },
    { NavicIconsConstructor = { inherit = "LspKindConstructor" } },
    { NavicIconsTypeParameter = { inherit = "LspKindTypeParameter" } },
    { NavicIconsValue = { inherit = "LspKindValue" } },

    { NavicSeparator = { fg = { from = "WinBar", attr = "fg", alter = -0.1 } } },
    { LspInlayHint = { inherit = "LspInlayhint" } },
  }
end

local function set_panel_highlight()
  local H = require "utils.highlights"
  local colors = update_base_colors(vim.g.colorscheme)
  H.all {

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                   SIDEBAR                                   ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    {
      PanelSideNormal = {
        bg = {
          from = "StatusLineTheme",
          attr = "bg",
          alter = colors.panelsidenormal_bg_alter or -0.5,
          transparency = 0.4,
          color = { from = "Normal", attr = "bg" },
        },
      },
    },
    {
      PanelSideNormal = {
        fg = {
          from = "Normal",
          attr = "fg",
          transparency = 0.7,
          color = { from = "PanelSideNormal", attr = "bg" },
        },
      },
    },

    { PanelSideBackground = { link = "PanelSideNormal", fg = "NONE" } },
    { PanelSideDarkBackground = { bg = { from = "PanelSideNormal", attr = "bg", alter = -1 } } },

    { PanelSideDarkHeading = { inherit = "PanelSideDarkBackground", bold = true } },
    { PanelSideHeading = { inherit = "PanelSideBackground", bold = true } },

    {
      PanelSideRootName = {
        fg = { from = "Comment", attr = "fg", alter = 0.2 },
        bg = { from = "PanelSideNormal", attr = "bg" },
      },
    },

    { PanelSideStNC = { link = "PanelSideWinSeparator" } },
    { PanelSideSt = { bg = { from = "Visual", alter = -0.2 } } },
    { PanelSideStusLine = { bg = { from = "StatusLineTheme" }, fg = { from = "Normal", attr = "fg" } } },

    {
      PanelSideWinSeparator = {
        fg = { from = "WinSeparator", attr = "fg" },
        bg = { from = "Normal", attr = "bg" },
      },
    },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                  BOTTOMBAR                                  ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    { PanelBottomNormal = { inherit = "PanelSideNormal" } },
    { PanelBottomHeading = { inherit = "PanelBottomBackground", bold = true } },
    { PanelBottomBackground = { bg = { from = "PanelBottomNormal", attr = "bg" } } },
    {
      PanelBottomCursorLine = {
        bg = {
          from = "Keyword",
          attr = "fg",
          transparency = 0.05,
          color = { from = "PanelSideNormal", attr = "bg" },
        },
        bold = true,
      },
    },
    {
      PanelBottomCursorLineNr = {
        fg = {
          from = "PanelBottomNormal",
          attr = "bg",
        },
        bg = { from = "ErrorMsg", attr = "fg" },
        bold = true,
      },
    },

    { PanelBottomDarkBackground = { bg = { from = "PanelBottomBackground", attr = "bg", alter = -0.1 } } },
    { PanelBottomDarkHeading = { inherit = "PanelBottomDarkBackground", bold = true } },

    {
      PanelBottomLineNr = {
        fg = {
          from = "PanelBottomNormal",
          attr = "bg",
          alter = colors.panelbottomlinenr_fg_alter or 2,
        },
      },
    },

    { PanelBottomSt = { bg = { from = "Visual", alter = -0.2 } } },
    { PanelBottomStusLine = { bg = { from = "PanelBottomBackground" }, fg = { from = "Normal", attr = "fg" } } },
    {
      PanelBottomWinSeparator = {
        fg = { from = "WinSeparator", attr = "fg" },
        bg = { from = "Normal", attr = "bg" },
      },
    },
    { PanelBottomStNC = { link = "PanelBottomWinSeparator" } },

    {
      PanelBottomComment = {
        fg = { from = "PanelBottomNormal", attr = "fg", alter = colors.panelbottomcomment_fg_alter or 0.1 },
      },
    },

    {
      HoveredCursorline = {
        bg = {
          from = "Directory",
          attr = "fg",
          alter = 0.1,
          transparency = 0.1,
          color = { from = "PanelBottomNormal", attr = "bg" },
        },
      },
    },
    {
      HoveredTerminalFileManagerCursorline = {
        bg = {
          from = "Directory",
          attr = "fg",
          alter = 0.1,
          transparency = 0.1,
          color = { from = "Normal", attr = "bg" },
        },
      },
    },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                  QUICKFIX                                   ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    { QuickFixFileName = { fg = { from = "Directory", attr = "fg" }, bg = "NONE" } },
    {
      QuickFixLine = {
        fg = "NONE",
        bg = "NONE",
        sp = {
          from = "Directory",
          attr = "fg",
          alter = 0.2,
          transparency = 0.4,
          color = { from = "PanelBottomNormal", attr = "bg" },
        },
        underline = true,
        reverse = false,
        bold = true,
      },
    },
    { QuickFixLineNr = { fg = { from = "PanelBottomNormal", attr = "bg", contrast = 0.5 } } },
    { QuickFixMiddleLineNr = { fg = { from = "Constant", attr = "fg", contrast = 0.2 } } },
    { QuickFixWinDelimiter = { fg = { from = "PanelBottomNormal", attr = "bg", alter = 1 } } },
    {
      QuickFixWinSeparator = {
        fg = { from = "WinSeparator", attr = "fg" },
        bg = { from = "PanelBottomNormal", attr = "bg" },
      },
    },
    { qfSeparator1 = { fg = { from = "Error", attr = "fg", alter = 0.1 } } },
    { qfSeparator2 = { link = "qfSeparator1" } },
    { qfFileName = { bg = "NONE" } },

    {
      QuickFixWinbar = {
        bg = {
          from = "FloatTitle",
          attr = "bg",
        },
        fg = {
          from = "FloatTitle",
          attr = "fg",
        },
      },
    },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                  GRUG FAR                                   ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    {
      GrugFarHelpHeader = {
        fg = {
          from = "PanelSideRootName",
          attr = "fg",
          alter = 0.5,
        },
        italic = true,
      },
    },
    {
      GrugFarHelpHeader = {
        fg = {
          from = "GrugFarHelpHeader",
          attr = "fg",
          transparency = 0.4,
          color = { from = "PanelSideBackground", attr = "bg" },
        },
        bg = "NONE",
      },
    },

    { GrugFarInputPlaceholder = { inherit = "GrugFarHelpHeader" } },

    {
      GrugFarResultsMatch = {
        fg = { from = "Search", attr = "bg", transparency = 0.2, color = { from = "Directory", attr = "fg" } },
        bg = { from = "Search", attr = "bg", alter = 0.1, opacity = 0.15 },
        bold = true,
      },
    },
    {
      GrugFarResultsPath = {
        fg = { from = "FloatTitle", attr = "fg" },
        bg = { from = "FloatTitle", attr = "bg" },
        bold = true,
        underline = false,
      },
    },

    {
      GrugFarResultsNumberLabel = {
        fg = {
          from = "PanelSideNormal",
          attr = "fg",
          transparency = 0.15,
          color = { from = "PanelSideNormal", attr = "bg" },
        },
      },
    },

    {
      GrugFarInputLabel = {
        fg = {
          from = "Boolean",
          attr = "fg",
          alter = 0.5,
          transparency = 0.6,
          color = { from = "PanelSideBackground", attr = "bg" },
        },
      },
    },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                 QFBOOKMARK                                  ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    { qfbookmarkqflinenr = { inherit = "warningmsg", bg = "none" } },

    {
      QFBookmarkQfSep = {
        fg = {
          from = "PanelSideNormal",
          attr = "bg",
          contrast = 0.1,
        },
      },
    },

    {
      QFBookmarkQfFileBasename = {
        fg = {
          from = "Directory",
          attr = "fg",
          alter = 0.25,
        },
        bg = "NONE",
      },
    },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                   TROUBLE                                   ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    { TroubleNormal = { inherit = "PanelBottomNormal" } },
    { TroubleNormalNC = { inherit = "PanelBottomNormal" } },

    { TroubleSignWarning = { bg = "NONE", fg = { from = "DiagnosticSignWarn", alter = -0.1 } } },
    { TroubleSignError = { bg = "NONE", fg = { from = "DiagnosticSignError", alter = -0.1 } } },
    { TroubleSignHint = { bg = "NONE", fg = { from = "DiagnosticSignHint", alter = -0.1 } } },
    { TroubleSignInfo = { bg = "NONE", fg = { from = "DiagnosticSignInfo", alter = -0.1 } } },
    { TroubleSignOther = { bg = "NONE", fg = { from = "DiagnosticSignInfo", alter = -0.1 } } },
    { TroubleSignInformation = { bg = "NONE", fg = { from = "DiagnosticSignInfo", alter = -0.1 } } },

    {
      TroublePreview = {
        fg = {
          from = "Error",
          attr = "fg",
          alter = 0.8,
        },
        bg = {
          from = "Error",
          attr = "fg",
          alter = 0.3,
          transparency = 0.25,
          color = { from = "PanelBottomNormal", attr = "bg" },
        },
      },
    },

    -- ├───────────────────────────────┤ DIRECTORY ├────────────────────────────┤

    {
      TroubleDirectory = {
        fg = { from = "FloatTitle", attr = "fg" },
        bg = { from = "FloatTitle", attr = "bg" },
        bold = true,
      },
    },
    {
      TroubleBasename = {
        inherit = "TroubleDirectory",
        fg = { from = "TroubleDirectory", attr = "fg", alter = 5 },
      },
    },
    {
      TroubleQfBasename = {
        inherit = "TroubleBasename",
      },
    },

    {
      TroubleIndent = {
        fg = {
          from = "PanelSideNormal",
          attr = "bg",
          alter = 3.5,
          transparency = colors.troubleindent_transparency_fg or 0.2,
          color = { from = "PanelSideNormal", attr = "bg" },
        },
        bg = "NONE",
      },
    },
    {
      TroubleIndentFoldClosed = {
        inherit = "TroubleIndent",
        fg = { from = "TroubleIndent", attr = "fg", alter = 0.6 },
      },
    },
    { TroubleIndentFoldOpen = { link = "TroubleIndentFoldClosed" } },
    {
      TroubleFsPos = {
        fg = { from = "TroubleIndentFoldClosed", attr = "fg", alter = 0.1 },
        bg = "NONE",
      },
    },
    {
      TroubleFsCount = {
        fg = { from = "Directory", attr = "fg", alter = 0.1 },
        bg = {
          from = "Directory",
          attr = "fg",
          alter = 0.1,
          transparency = 0.15,
          color = { from = "PanelSideNormal", attr = "bg" },
        },
      },
    },

    -- ├──────────────────────────────────┤ LSP ├───────────────────────────────┤

    { TroubleLspFilename = { link = "TroubleDirectory" } },
    { TroubleLspPos = { link = "TroubleFsPos" } },
    { TroubleLspCount = { link = "TroubleFsCount" } },
    { TroubleLspItemClient = { inherit = "Comment", bg = "NONE" } },

    -- ├──────────────────────────────┤ DIAGNOSTICS ├───────────────────────────┤

    {
      TroubleDiagnosticsBasename = {
        inherit = "DiagnosticWarn",
        bg = "NONE",
        italic = false,
      },
    },
    { TroubleDiagnosticsPos = { link = "TroubleFsPos" } },
    {
      TroubleDiagnosticsCount = {
        fg = { from = "DiagnosticWarn", attr = "fg", alter = -0.13 },
        bg = { from = "DiagnosticWarn", attr = "fg", alter = -0.7 },
      },
    },

    -- ├──────────────────────────────────┤ TODO ├──────────────────────────────────┤

    { TroubleTodoFilename = { bg = "NONE" } },
    { TroubleTodoPos = { link = "TroubleFsPos" } },
    { TroubleTodoCount = { link = "TroubleFsCount" } },

    -- ├────────────────────────────────┤ QUICKFIX ├────────────────────────────────┤

    { TroubleQfFilename = { link = "TroubleDirectory" } },
    { TroubleQfPos = { link = "TroubleFsPos" } },
    { TroubleQfCount = { link = "TroubleFsCount" } },

    { TroubleCode = { bg = "NONE", fg = { from = "Error", attr = "fg" }, underline = false } },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                   OUTLINE                                   ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    {
      OutlineGuides = {
        fg = {
          from = "TroubleIndent",
          attr = "fg",
          alter = 0.1,
          transparency = 0.7,
          color = { from = "PanelBottomNormal", attr = "bg" },
        },
        bg = "NONE",
      },
    },
    {
      OutlineCurrent = {
        bg = {
          from = "TroublePreview",
          attr = "fg",
          transparency = 0.25,
          color = { from = "PanelBottomNormal", attr = "bg" },
        },
      },
    },
    {
      OutlineCurrent = {
        fg = {
          from = "TroublePreview",
          attr = "fg",
          alter = 0.15,
        },
      },
    },
    {
      OutlineCurrentParent = {
        bg = {
          from = "String",
          attr = "fg",
          transparency = 0.25,
          color = { from = "PanelBottomNormal", attr = "bg" },
        },
      },
    },
    {
      OutlineCurrentParent = {
        fg = { from = "String", attr = "fg" },
      },
    },

    { OutlineFoldMarker = { fg = { from = "TroubleIndentFoldClosed", attr = "fg" }, bg = "NONE" } },

    {
      OutlineDetails = {
        fg = {
          from = "OutlineFoldMarker",
          attr = "fg",
          alter = 0.1,
          transparency = 0.6,
          color = { from = "PanelBottomNormal", attr = "bg" },
        },
        bg = "NONE",
        italic = true,
      },
    },
    { OutlineJumpHighlight = { bg = "red", fg = "NONE" } },
    { OutlineLineno = { bg = "NONE" } },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                   AERIALS                                   ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    -- { AerialGuide = { link = "OutlineGuides" } },
    -- { AerialLine = { link = "OutlineCurrent" } },

    { AerialBoolean = { link = "LspKindBoolean" } },
    { AerialBooleanIcon = { link = "LspKindBoolean" } },

    { AerialVariable = { link = "LspKindVariable" } },
    { AerialVariableIcon = { link = "LspKindVariable" } },

    { AerialInterface = { link = "LspKindInterface" } },
    { AerialInterfaceIcon = { link = "LspKindInterface" } },

    { AerialKey = { link = "LspKindKey" } },
    { AerialKeyIcon = { link = "LspKindKey" } },

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
  }
end

local function colorscheme_overrides()
  local overrides = {
    ["ashen"] = {
      {
        SnacksIndentScope = {
          fg = { from = "GitSignsAdd", attr = "fg", opacity = 0.35 },
          bg = "NONE",
        },
      },
    },
    ["base46-everforest"] = {
      { Comment = { fg = { from = "Comment", attr = "fg", alter = -0.1 } } },
      {
        SnacksIndentScope = {
          fg = { from = "GitSignsAdd", attr = "fg", opacity = 0.4 },
          bg = "NONE",
        },
      },
    },
    ["kanagawa"] = {
      { NonText = { fg = { from = "NonText", attr = "fg", alter = -0.35 } } },
      {
        SnacksIndentScope = {
          fg = { from = "GitSignsChange", attr = "fg", alter = -0.55 },
          bg = "NONE",
        },
      },
    },
    ["catppuccin"] = {
      { NonText = { fg = { from = "NonText", attr = "fg", alter = -0.3 } } },
      {
        SnacksIndentScope = {
          fg = {
            from = "Boolean",
            attr = "fg",
            alter = 0.1,
            transparency = 0.35,
            color = { from = "Normal", attr = "bg" },
          },
          bg = "NONE",
        },
      },
    },
    ["luna"] = {
      { NonText = { fg = { from = "NonText", attr = "fg", alter = -0.4 } } },
      {
        SnacksIndentScope = {
          fg = { from = "GitSignsChange", attr = "fg", opacity = 0.3 },
          bg = "NONE",
        },
      },
    },
    ["gruvbox"] = {
      { NonText = { fg = { from = "NonText", attr = "fg", alter = -0.4 } } },
      { Comment = { fg = { from = "Comment", attr = "fg", alter = -0.1 } } },
      {
        SnacksIndentScope = {
          fg = { from = "GitSignsAdd", attr = "fg", opacity = 0.4 },
          bg = "NONE",
        },
      },
    },
    ["habamax"] = {
      { NonText = { fg = { from = "NonText", attr = "fg", alter = -0.15 } } },
      { Comment = { fg = { from = "Comment", attr = "fg", alter = -0.15 } } },
      {
        SnacksIndentScope = {
          fg = { from = "GitSignsChange", attr = "fg", opacity = 0.4 },
          bg = "NONE",
        },
      },
    },
    ["intent"] = {
      {
        SnacksIndentScope = {
          fg = { from = "GitSignsAdd", attr = "fg", opacity = 0.5 },
          bg = "NONE",
        },
      },
    },
    ["jellybeans"] = {
      { NonText = { fg = { from = "NonText", attr = "fg", alter = -0.2 } } },
      {
        SnacksIndentScope = {
          fg = { from = "Function", attr = "fg", opacity = 0.4 },
          bg = "NONE",
        },
      },
    },
    ["lackluster"] = {
      { NonText = { fg = { from = "NonText", attr = "fg", alter = -0.2 } } },
      {
        SnacksIndentScope = {
          fg = { from = "GitSignsChange", attr = "fg", opacity = 0.35 },
          bg = "NONE",
        },
      },
    },
    ["neogotham"] = {
      { NonText = { fg = { from = "NonText", attr = "fg", alter = -0.15 } } },
      {
        SnacksIndentScope = {
          fg = { from = "Function", attr = "fg", opacity = 0.6 },
          bg = "NONE",
        },
      },
    },
    ["oxocarbon"] = {
      { NonText = { fg = { from = "NonText", attr = "fg", alter = 0.1 } } },
      {
        SnacksIndentScope = {
          fg = { from = "Function", attr = "fg", opacity = 0.3 },
          bg = "NONE",
        },
      },
    },
    ["tokyonight-night"] = {
      { NonText = { fg = { from = "NonText", attr = "fg", alter = -0.1 } } },
      {
        SnacksIndentScope = {
          fg = { from = "GitSignsChange", attr = "fg", opacity = 0.3 },
          bg = "NONE",
        },
      },
    },

    ["rose-pine"] = {
      { NonText = { fg = { from = "NonText", attr = "fg", alter = -0.2 } } },
      {
        SnacksIndentScope = {
          fg = { from = "GitSignsChange", attr = "fg", opacity = 0.4 },
          bg = "NONE",
        },
      },
    },
    ["vscode"] = {
      {
        SnacksIndentScope = {
          fg = { from = "GitSignsChange", attr = "fg", opacity = 0.4 },
          bg = "NONE",
        },
      },
    },
  }

  local hls = overrides[vim.g.colors_name]
  if hls then
    local H = require "utils.highlights"
    H.all(hls)
  end
end

-- ╓─────────────────────────────────────────────────────────────────────────────╖
-- ║                                 WINDOW DIM                                  ║
-- ╙─────────────────────────────────────────────────────────────────────────────╜

local Win = {}

local winhighlight_bottom_panel = table.concat({
  "Normal:PanelBottomNormal",
  "NormalNC:PanelBottomNormal",
  "Comment:PanelBottomComment",
  "SignColumn:PanelBottomNormal",
  "CursorLine:PanelBottomCursorLine",
  "CursorLineNr:PanelBottomCursorLineNr",
  "LineNr:PanelBottomLineNr",
  "WinSeparator:PanelBottomWinSeparator",
  "Delimiter:QuickFixWinDelimiter",
  "NonText:QuickFixWinDelimiter",
  "EndOfBuffer:PanelBottomNormal",
}, ",")

local winhighlight_note_panel = table.concat({
  "Normal:NormalNote",
  "NormalNC:NormalNote",
  "ColorColumn:NormalNote",
  "EndOfBuffer:NormalNote",
  "SignColumn:NormalNote",
  "NormalFloat:NormalNote",
  "FloatBorder:FloatBorderNote",
  "FloatTitle:FloatTitleNote",
  "FloatFooter:FloatFooterNote",
  "CursorLine:CursorLineNote",
  "CursorLineNr:CursorLineNrNote",
  "Folded:FoldedNote",
  "FoldedSign:FoldedNoteSign",
  "@markup.list.markdown:@markup.list.markdown",
  "Comment:CommentNote",
  "@Comment:CommentNote",
  "Visual:VisualNote",
  "NonText:NonTextNote",
  "LineNr:LineNrNote",
  "WinSeparator:WinSeparatorNote",
  "Delimiter:DelimiterNote",
  "@tag.delimiter:DelimiterNote",

  "RenderMarkdownH1Bg:@markup.heading.1.markdown",
  "RenderMarkdownH2Bg:@markup.heading.2.markdown",
  "RenderMarkdownH3Bg:@markup.heading.3.markdown",
  "RenderMarkdownH4Bg:@markup.heading.4.markdown",
  "RenderMarkdownH5Bg:@markup.heading.5.markdown",
  "RenderMarkdownH6Bg:@markup.heading.6.markdown",
  "RenderMarkdownCodeInline:RenderMarkdownCodeInline",
}, ",")

local winhighlight_ai_panel = table.concat({
  "Normal:NormalAiPrompt",
  "NormalNC:NormalAiPrompt",
  "ColorColumn:NormalAiPrompt",
  "EndOfBuffer:NormalAiPrompt",
  "SignColumn:NormalAiPrompt",
  "NormalFloat:NormalAiPrompt",
  "FloatBorder:FloatBorderAiPrompt",
  "FloatTitle:FloatTitleAiPrompt",
  "FloatFooter:FloatFooterAiPrompt",
  "CursorLine:CursorLineAiPrompt",
  "CursorLineNr:CursorLineNrAiPrompt",
  "Folded:FoldedAiPrompt",
  "Comment:CommentAiPrompt",
  "@Comment:CommentAiPrompt",
  "Visual:VisualAiPrompt",
  "NonText:NonTextAiPrompt",
  "LineNr:LineNrAiPrompt",
  "WinSeparator:WinSeparatorAiPrompt",
  "@markup.list.markdown:@markup.list.markdown",
  "Delimiter:DelimiterAiPrompt",

  "RenderMarkdownH1Bg:@markup.heading.1.markdown_ai",
  "@markup.heading.1.markdown:@markup.heading.1.markdown_ai",
  "RenderMarkdownH2Bg:@markup.heading.2.markdown_ai",
  "@markup.heading.2.markdown:@markup.heading.2.markdown_ai",
  "RenderMarkdownH3Bg:@markup.heading.3.markdown_ai",
  "@markup.heading.3.markdown:@markup.heading.3.markdown_ai",
  "RenderMarkdownH4Bg:@markup.heading.4.markdown_ai",
  "@markup.heading.4.markdown:@markup.heading.4.markdown_ai",
  "RenderMarkdownH5Bg:@markup.heading.5.markdown_ai",
  "@markup.heading.5.markdown:@markup.heading.5.markdown_ai",
  "RenderMarkdownH6Bg:@markup.heading.6.markdown_ai",
  "@markup.heading.6.markdown:@markup.heading.6.markdown_ai",
  "RenderMarkdownCodeInline:RenderMarkdownCodeInlineAiPrompt",
  "@markup.quote.markdown:@markup.quote.markdown.AiPrompt",
}, ",")

Win.filetype_blacklist_winhighlights = {
  ["snacks_picker_input"] = true,
  ["qfbookmark"] = true,
  ["wayfinder"] = true,
  ["pdfview_menu"] = true,
  ["notify"] = true,
}

Win.filetype_winhighlights = {
  ["qf"] = true,
  ["sqmeow-drawer"] = true,
  ["sqmeow-result"] = true,
  ["Outline"] = true,
  ["aerial"] = true,
  ["trouble"] = true,
  ["grug-far"] = true,
  ["dbui"] = true,
  ["dbout"] = true,

  ["dap-repl"] = true,
  ["dap-variables"] = true,
  ["dapui_breakpoints"] = true,
  ["dapui_scopes"] = true,
  ["dapui_stacks"] = true,
  ["dapui_watches"] = true,
}

Win.cursorline_blacklist = {
  ["grug-far"] = true,
  ["noice"] = true,
  ["main_layout"] = true,
  ["dbout"] = true,

  ["codecompanion"] = true,
  ["wayfinder"] = true,

  ["lazy"] = true,

  ["dap-repl"] = true,
  ["dap-variables"] = true,
  ["dapui_breakpoints"] = true,
  ["dapui_scopes"] = true,
  ["dapui_stacks"] = true,
  ["dapui_watches"] = true,
}

Win.cursorline_bright = {
  ["qf"] = true,
  ["trouble"] = true,
  ["orgagenda"] = true,

  ["DiffviewFiles"] = true,
  ["DiffviewFileHistory"] = true,
}

Win.note_winhighlights = {
  ["org"] = true,
  ["orgagenda"] = true,
  ["markdown"] = true,
  ["octo"] = true,
  ["help"] = true,
  ["man"] = true,
  ["eldochover"] = true,
}

Win.aiprompt_winhighlights = {
  ["codecompanion"] = true,
}

-- ├─────────────────────────────────┤ HELPER ├─────────────────────────────────┤

local function current_ft()
  return (require("utils.window").get_bo_buft())
end

local function is_float(win)
  return vim.api.nvim_win_get_config(win).relative ~= ""
end

local function win_ft(win)
  return vim.bo[vim.api.nvim_win_get_buf(win)].filetype
end

local function get_whl(win)
  return vim.api.nvim_get_option_value("winhighlight", { win = win, scope = "local" })
end

-- scope = "local": doesn't change the global value, so new windows won't inherit it.
local function set_whl(win, value)
  if get_whl(win) ~= value then
    vim.api.nvim_set_option_value("winhighlight", value, { win = win, scope = "local" })
  end
end

local function set_win_cursorline(win, on)
  vim.api.nvim_set_option_value("cursorline", on, { win = win, scope = "local" })
end

local function winhighlight_for_filetype(ft)
  if Win.filetype_winhighlights[ft] then
    return winhighlight_bottom_panel
  end
  if Win.note_winhighlights[ft] then
    return winhighlight_note_panel
  end
  if Win.aiprompt_winhighlights[ft] then
    return winhighlight_ai_panel
  end
  return nil
end

-- ├────────────────────────────┤ BRIGHT CURSORLINE ├────────────────────────────┤
-- Level-triggered: no state is stored or restored. `bright_active` is
-- recalculated from the active window, then the bright entry is added or
-- removed safely, without doing anything twice.
local BRIGHT_NORMAL = "CursorLine:CursorLineBright"
local BRIGHT_NOTE = "CursorLine:CursorLineNoteBright"

local bright_active = false

---@return string? Bright winhighlight entry for this window, or nil if not needed.
local function bright_entry_for(win)
  if not bright_active or is_float(win) then
    return nil
  end
  local ft = win_ft(win)
  if Win.cursorline_bright[ft] or Win.cursorline_blacklist[ft] or Win.filetype_blacklist_winhighlights[ft] then
    return nil
  end
  return Win.note_winhighlights[ft] and BRIGHT_NOTE or BRIGHT_NORMAL
end

--- Remove any old bright entry, then add `entry` (nil means remove only).
--- The entry is added at the end, so removing it automatically restores the default CursorLine.
local function with_bright(hl, entry)
  local parts = {}
  for part in vim.gsplit(hl or "", ",", { plain = true, trimempty = true }) do
    if part ~= BRIGHT_NORMAL and part ~= BRIGHT_NOTE then
      parts[#parts + 1] = part
    end
  end
  parts[#parts + 1] = entry
  return table.concat(parts, ",")
end

local function any_trigger_window()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if not is_float(win) and Win.cursorline_bright[win_ft(win)] then
      return true
    end
  end
  return false
end

local function update_bright_state()
  local cur = vim.api.nvim_get_current_win()
  if is_float(cur) then
    -- Floats don't change the state, unless the trigger window is gone (self-healing).
    bright_active = bright_active and any_trigger_window()
  else
    bright_active = Win.cursorline_bright[win_ft(cur)] == true
  end
end

local function sync_bright()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local entry = bright_entry_for(win)
    set_whl(win, with_bright(get_whl(win), entry))
    if entry then
      set_win_cursorline(win, true)
    end
  end
end

-- ├────────────────────────────┤ WINHIGHLIGHT OWNER ├───────────────────────────┤
--- Set winhighlight based on the filetype, but only for windows managed by this module.
--- Other windows (e.g. plugin floats) are left untouched.
local function apply_owned_winhighlight(win, ft)
  local base = winhighlight_for_filetype(ft)

  if base then
    vim.w[win].winhighlight_owner = ft
  elseif vim.w[win].winhighlight_owner ~= nil then
    base = ""
    vim.w[win].winhighlight_owner = nil
  else
    return
  end

  set_whl(win, with_bright(base, bright_entry_for(win)))
end

-- ├───────────────────────────────┤ CURSORLINE ├───────────────────────────────┤

local function set_cursorline(active)
  if Win.cursorline_blacklist[current_ft()] or vim.w.is_overlook_popup then
    active = false
  end
  set_win_cursorline(vim.api.nvim_get_current_win(), active)
end

-- ├────────────────────────────────┤ PMENU ├─────────────────────────────────┤

local pmenu_original = nil ---@type { pmenu: table, pmenusel: table }?
local pmenu_applied = nil ---@type "ai"|"note"|nil

local pmenu_links = {
  ai = { Pmenu = "PmenuAiPrompt", PmenuSel = "PmenuSelAiPrompt" },
  note = { Pmenu = "PmenuNote", PmenuSel = "PmenuSelNote" },
}

local function pmenu_kind(ft)
  if Win.aiprompt_winhighlights[ft] then
    return "ai"
  end
  if Win.note_winhighlights[ft] then
    return "note"
  end
  return nil
end

local function save_pmenu_colors()
  local function resolve(name)
    local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
    if vim.tbl_isempty(hl) then
      local linked = vim.api.nvim_get_hl(0, { name = name, link = true }).link
      if linked then
        hl = vim.api.nvim_get_hl(0, { name = linked, link = false })
      end
    end
    return hl
  end
  return { pmenu = resolve "Pmenu", pmenusel = resolve "PmenuSel" }
end

local function sync_pmenu()
  local kind = pmenu_kind(current_ft())
  if kind == pmenu_applied then
    return
  end

  if kind then
    -- Save the original highlight before overriding it for the first time.
    if not pmenu_original and pmenu_applied == nil then
      pmenu_original = save_pmenu_colors()
    end
    for group, link in pairs(pmenu_links[kind]) do
      vim.api.nvim_set_hl(0, group, { link = link })
    end
  elseif pmenu_original then
    vim.api.nvim_set_hl(0, "Pmenu", pmenu_original.pmenu)
    vim.api.nvim_set_hl(0, "PmenuSel", pmenu_original.pmenusel)
  end
  pmenu_applied = kind
end

-- ├────────────────────────────────┤ UPDATE ├────────────────────────────────┤

--- Apply the filetype-based winhighlight to every window,
--- so windows that were opened without being entered (e.g. qf) also get styled.
local function apply_all_windows_winhighlight()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local ft = win_ft(win)
    if not Win.filetype_blacklist_winhighlights[ft] then
      apply_owned_winhighlight(win, ft)
    end
  end
end

--- The only place that recalculates the active window state.
local function update_current_window()
  update_bright_state() -- Run this before apply_* so the bright entry isn't outdated.
  apply_all_windows_winhighlight()
  set_cursorline(not vim.startswith(vim.api.nvim_get_mode().mode, "i"))
  sync_bright()
  sync_pmenu()
end

-- Some events fire back-to-back (WinEnter + BufEnter + FileType, etc.).
-- Combine them into a single update per tick.
local update_pending = false

local function schedule_update()
  if update_pending then
    return
  end
  update_pending = true
  vim.defer_fn(function()
    update_pending = false
    update_current_window()
  end, 1)
end

local function user_highlights()
  general_overrides()
  plugins_overrides()
  set_panel_highlight()
  colorscheme_overrides()

  -- Save these AFTER applying overrides, so restore brings back your custom
  -- Pmenu colors.
  pmenu_original = save_pmenu_colors()
  pmenu_applied = nil
  sync_pmenu()
end

-- ├─────────────────────────────────┤ AUGRUP ├─────────────────────────────────┤

local UtilAugroup = function()
  return require("utils.map").augroup
end

UtilAugroup()("UserHighlights", {
  event = "ColorScheme",
  command = function()
    user_highlights()
  end,
})

UtilAugroup()("UserDimWindow", {
  event = { "VimEnter", "BufEnter", "WinEnter", "TabEnter", "FileType", "WinClosed" },
  pattern = "*",
  command = function()
    schedule_update()
  end,
}, {
  event = "WinNew",
  pattern = "*",
  command = function()
    -- The newest window has the highest ID
    -- (works for both splits and floats with enter=false).
    local newest = math.max(unpack(vim.api.nvim_list_wins()))
    set_whl(newest, "")
    vim.w[newest].winhighlight_owner = nil
    schedule_update()
  end,
}, {
  event = "InsertEnter",
  pattern = "*",
  command = function()
    set_cursorline(false)
  end,
}, {
  event = "InsertLeave",
  pattern = "*",
  command = function()
    set_cursorline(true)
  end,
})
