local wo = vim.wo

local base_colors = {
  Directory = { fg = { from = "Directory", attr = "fg" }, bg = "NONE" },
}

local update_col_colorscheme = {
  ["ashen"] = {
    winseparator_fg_alter = 0.5,
    linenr_fg_alter = 1.3,
    nonetext_opacity = 0.35,
    quickfixwinbar_fg_alter = 0.5,
    quickfixwinbar_bg_alter = 1,

    trouble_indent_fg_alter = -0.85,
    panelbottomlinenr_fg_alter = 2.5,

    zshlines_fg_alter = -0.05,
  },
  ["base46-everforest"] = {
    Directory = { fg = "#a7c080", bg = "NONE" },
    linenr_fg_alter = 0.5,
    winseparator_fg_alter = 0.25,
    statusline_fg_alter = 0.5,
    hl_trouble_indent = "Function",
    trouble_indent_fg_alter = -0.55,
    trouble_fold_fg_alter = 0.5,
    outline_indent_fg_alter = -0.3,
    codeblock_bg_alter = 0.1,
    linenrnote_fg_alter = 0.5,
    orgdirective_fg_alter = 0.3,
    commentnote_fg_alter = 0.2,

    panelbottomlinenr_fg_alter = 1,
    panelbottomcursorlinenr_fg_alter = 4,
    panelsidenormal_bg_alter = 0.1,

    quickfixwinbar_fg_alter = 0.2,
    winbar_fg_alter = 0.6,
    winbarnote_fg_alter = 0.8,

    comment_fg_alter = 0.45,
    outline_details_fg_alter = 0.15,
    zshlines_fg_alter = -0.05,
    zshlines_bg_alter = 0.2,
  },
  ["catppuccin"] = {
    panelbottomlinenr_fg_alter = 1.3,
    panelbottomcursorlinenr_fg_alter = 5,
    winseparator_fg_alter = 0.4,
    winseparatornote_fg_alter = 0.8,
    trouble_indent_fg_alter = -0.8,
    commentnote_fg_alter = 0.7,
    linenr_fg_alter = 0.9,
    winbar_fg_alter = 0.6,

    quickfixwinbar_fg_alter = 0.25,

    zshlines_bg_alter = 0.2,
    zshlines_fg_alter = -0.1,
  },
  ["cendre"] = {
    winseparator_fg_alter = 0.4,
    winseparatornote_fg_alter = 0.8,
    trouble_indent_fg_alter = -0.8,
    commentnote_fg_alter = 1,
    linenr_fg_alter = 1.2,
    winbar_fg_alter = 0.6,

    quickfixwinbar_fg_alter = 0.2,
    normalnote_bg_alter = 1,

    panelbottomlinenr_fg_alter = 2.5,
    panelbottomcursorlinenr_fg_alter = 5.5,

    zshlines_bg_alter = 0.2,
    zshlines_fg_alter = -0.1,
  },
  ["gruvbox"] = {
    winseparator_fg_alter = 0.35,
    orgdirective_fg_alter = 0.4,
    linenr_fg_alter = 1.2,
    panelsidenormal_bg_alter = 0.1,
    statusline_fg_alter = 0.25,
    winbar_fg_alter = 0.4,
    winbarnote_fg_alter = 1.5,
    zshlines_fg_alter = -0.2,
    zshlines_bg_alter = 0.4,
  },
  ["habamax"] = {
    winseparator_fg_alter = 0.4,
    zshlines_bg_alter = 0.4,
    zshlines_fg_alter = -0.2,
    winbar_fg_alter = 0.4,
    commentnote_fg_alter = 0.8,
    quickfixwinbar_fg_alter = 0.2,
    linenrnote_fg_alter = 0.7,
  },
  ["intent"] = {
    nonetext_opacity = 0.25,
    winseparator_fg_alter = 0.7,
    linenr_fg_alter = 1.6,
    linenrnote_fg_alter = 1.2,
    commentnote_fg_alter = 0.7,
    codeblock_bg_alter = 0.4,
    panelsidenormal_bg_alter = 0.15,
    trouble_fold_fg_alter = 0.6,
    normalnote_bg_alter = 0.8,
    floatborderaiprompt_fg_alter = 1,
    quickfixwinbar_bg_alter = 1,
    quickfixwinbar_fg_alter = 0.75,
    trouble_indent_fg_alter = -0.75,
    winbar_fg_alter = 0.6,
    panelbottomlinenr_fg_alter = 3,
    panelbottomcursorlinenr_fg_alter = 10,
    outline_indent_fg_alter = -0.45,
    outline_details_fg_alter = 0.6,
  },
  ["jellybeans"] = {
    Directory = { fg = "#8fbfdc", bg = "NONE" },
    panelsidenormal_bg_alter = 0.1,
    quickfixwinbar_fg_alter = 0.35,
    trouble_indent_fg_alter = -0.8,
    normalnote_bg_alter = 0.8,
    winseparator_fg_alter = 0.4,
    winbar_fg_alter = 0.7,
    linenr_fg_alter = 1.2,
    linenrnote_fg_alter = 0.8,
  },
  ["lackluster"] = {
    Directory = { fg = "#7788aa", bg = "NONE" },
    winseparator_fg_alter = 1.5,
    winseparatornote_fg_alter = 0.8,
    floatborderaiprompt_fg_alter = 3,

    codeblock_bg_alter = 0.55,
    comment_fg_alter = 0.8,

    nonetext_opacity = 0.3,
    winbarnote_fg_alter = 2.5,
    normalnote_bg_alter = 3.5,
    linenrnote_fg_alter = 1.2,
    commentnote_fg_alter = 0.8,

    panelbottomlinenr_fg_alter = 12.5,
    panelbottomcursorlinenr_fg_alter = 40,
    panelsidenormal_bg_alter = 0.5,

    statusline_bg_alter = -0.8,

    trouble_indent_fg_alter = -0.85,
    linenr_fg_alter = 4.6,
    winbar_fg_alter = 1.2,
    quickfixwinbar_fg_alter = 0.2,
    quickfixwinbar_bg_alter = 5,
  },
  ["lackluster-mint"] = {
    Directory = { fg = "#7788aa", bg = "NONE" },
    trouble_indent_fg_alter = 0.5,
    winseparator_fg_alter = 0.1,
  },
  ["kanagawa"] = {
    Directory = { fg = "#8fbfdc", bg = "NONE" },
    orgdirective_fg_alter = 0.7,
    linenrnote_fg_alter = 1.2,
    trouble_indent_fg_alter = -0.88,
    winbar_fg_alter = 0.7,
    winseparator_fg_alter = 0.7,
    linenr_fg_alter = 2,

    quickfixwinbar_fg_alter = 0.6,
    quickfixwinbar_bg_alter = 1.5,

    panelbottomlinenr_fg_alter = 4.5,
    panelbottomcursorlinenr_fg_alter = 11,

    panelsidenormal_bg_alter = 0.1,
    statusline_bg_alter = -0.4,
  },
  ["neogotham"] = {
    linenr_fg_alter = 1.4,
    winseparator_fg_alter = 0.45,
    outline_details_fg_alter = 0.7,
    floatborderaiprompt_fg_alter = 1,
    trouble_indent_fg_alter = -0.65,
    trouble_fold_fg_alter = 0.5,
    outline_indent_fg_alter = -0.45,
    winbar_fg_alter = 0.7,
    linenrnote_fg_alter = 0.8,
    zshlines_bg_alter = 0.2,
    zshlines_fg_alter = -0.1,
  },
  ["nightfox"] = { linenr_fg_alter = 1.4, winseparator_fg_alter = 0.45 },
  ["oxocarbon"] = {
    linenr_fg_alter = 1.35,
    winbar_fg_alter = 0.4,
    winseparator_fg_alter = 0.4,
    linenrnote_fg_alter = 0.8,
    floatborderaiprompt_fg_alter = 0.8,
    normalnote_bg_alter = 0.8,
    zshlines_fg_alter = -0.15,
    zshlines_bg_alter = 0.3,
  },
  ["rose-pine"] = {
    linenr_fg_alter = 1.3,
    winseparator_fg_alter = 0.45,
    linenrnote_fg_alter = 0.85,
    winbar_fg_alter = 0.45,
    hl_trouble_indent = "Function",
    trouble_indent_fg_alter = -0.8,
    trouble_fold_fg_alter = 0.65,
    outline_details_fg_alter = 0.5,
    zshlines_fg_alter = -0.15,
    zshlines_bg_alter = 0.25,
  },
  ["tokyonight"] = {
    linenr_fg_alter = 1,
    winseparator_fg_alter = 0.3,
    outline_details_fg_alter = 0.5,
    quickfixwinbar_fg_alter = 0.3,
    linenrnote_fg_alter = 0.7,
    commentnote_fg_alter = 0.7,
    winbar_fg_alter = 0.6,
    panelsidenormal_bg_alter = 0.1,
    trouble_indent_fg_alter = -0.75,
    winbarnote_fg_alter = 1.4,
    outline_indent_fg_alter = -0.1,
    zshlines_fg_alter = -0.15,
    zshlines_bg_alter = 0.25,
  },
  ["tokyonight-night"] = {
    linenr_fg_alter = 2,
    linenrnote_fg_alter = 0.7,
    winseparator_fg_alter = 0.65,
    winbar_fg_alter = 0.85,
    normalnote_bg_alter = 3,

    trouble_indent_fg_alter = -0.85,
    quickfixwinbar_bg_alter = 1.5,
    quickfixwinbar_fg_alter = 0.5,

    panelsidenormal_bg_alter = 0.1,
    panelbottomlinenr_fg_alter = 5,
    panelbottomcursorlinenr_fg_alter = 15,
  },
  ["tokyonight-storm"] = {
    linenr_fg_alter = 0.9,
    winseparator_fg_alter = 0.25,
    linenrnote_fg_alter = 0.5,
    winbarnote_fg_alter = 1,

    commentnote_fg_alter = 0.6,
    winbar_fg_alter = 0.4,
    panelsidenormal_bg_alter = 0.1,
    statusline_fg_alter = 0.3,

    codeblock_bg_alter = 0.15,
    trouble_indent_fg_alter = -0.75,
    quickfixwinbar_fg_alter = 0.3,
    panelbottomlinenr_fg_alter = 1.5,
    panelbottomcursorlinenr_fg_alter = 4.5,

    zshlines_fg_alter = -0.1,
    zshlines_bg_alter = 0.3,
  },
  ["luna"] = {
    nontextnote_fg_alter = -0.2,
    linenr_fg_alter = 3.5,
    winseparator_fg_alter = 1.7,
    linenrnote_fg_alter = 1.5,
    winbar_fg_alter = 1.5,
    winbarnote_fg_alter = 2,
    comment_fg_alter = 1.2,
    commentnote_fg_alter = 2,
    codeblock_bg_alter = 0.6,
    nonetext_opacity = 0.3,

    nontextaiprompt_fg_alter = 5,

    floatbordernote_fg_alter = 15,
    floatborderaiprompt_fg_alter = 3,

    quickfixwinbar_fg_alter = 0.3,
    quickfixwinbar_bg_alter = 2.5,
    normalnote_bg_alter = 2.5,

    panelsidenormal_bg_alter = 1,
    panelbottomlinenr_fg_alter = 9,
    panelbottomcursorlinenr_fg_alter = 30,

    orgdirective_fg_alter = 0.6,

    trouble_indent_fg_alter = -0.85,
    trouble_fold_fg_alter = 0.85,
    outline_indent_fg_alter = -0.3,
    outline_details_fg_alter = 0.7,

    statusline_bg_alter = -0.75,

    zshlines_bg_alter = 0.7,
  },

  ["vscode"] = {
    Directory = { fg = "#569cd6", bg = "NONE" },
    hl_trouble_indent = "Function",
    linenr_fg_alter = 0.9,
    winseparator_fg_alter = 0.3,
    trouble_indent_fg_alter = -0.72,
    trouble_fold_fg_alter = 0.65,
    winbar_fg_alter = 0.5,
  },
  ["zenburn"] = {
    linenr_fg_alter = 0.55,
    winseparator_fg_alter = 0.2,
    commentnote_fg_alter = 0.6,
    linenrnote_fg_alter = 0.4,
    trouble_indent_fg_alter = -0.6,
    trouble_fold_fg_alter = 0.4,
    statusline_fg_alter = 0.15,
    statusline_bg_alter = -0.2,
    codeblock_bg_alter = 0.1,
    orgdirective_fg_alter = 0.25,

    panelbottomlinenr_fg_alter = 1,
    panelbottomcursorlinenr_fg_alter = 5,
    quickfixwinbar_fg_alter = 0.2,
    panelsidenormal_bg_alter = 0.1,

    outline_details_fg_alter = 0.1,
    normalfloat_bg_alter = 0.1,
    winbar_fg_alter = 0.5,
    winbarnote_fg_alter = 0.8,
    zshlines_fg_alter = -0.1,
    zshlines_bg_alter = 0.2,
  },
}

if os.getenv "TERMINAL" == "ghostty" then
  update_col_colorscheme["ashen"] = {
    winseparator_fg_alter = 0.7,
    linenr_fg_alter = 1.6,
    commentnote_fg_alter = 0.8,
    hl_trouble_indent = "Boolean",
    linenrnote_fg_alter = 1,
    winbar_fg_alter = 0.5,
    trouble_indent_fg_alter = -0.5,
    trouble_fold_fg_alter = 0.5,
    outline_indent_fg_alter = -0.3,
    outline_details_fg_alter = 0.4,
  }
  update_col_colorscheme["base46-everforest"] = {
    commentnote_fg_alter = 0.45,
    linenr_fg_alter = 0.7,
    linenrnote_fg_alter = 0.5,
    orgblockorg_fg_alter = -0.15,
    orgdirective_fg_alter = 0.4,
    winseparator_fg_alter = 0.3,
    hl_trouble_indent = "@variable",
    zshlines_fg_alter = -0.1,
    trouble_indent_fg_alter = -0.5,
    trouble_fold_fg_alter = 0.5,
    outline_indent_fg_alter = -0.3,
    outline_details_fg_alter = 0.5,
    winbar_fg_alter = 0.3,
    foldedsign_fg_alter = 0.4,
    winbarnote_fg_alter = 0.8,
    zshlines_bg_alter = 0.2,
  }
  update_col_colorscheme["catppuccin"] = {
    linenr_fg_alter = 0.9,
    linenrnote_fg_alter = 0.6,
    commentnote_fg_alter = 0.8,
    winseparator_fg_alter = 0.6,
    zshlines_bg_alter = 0.2,
    winbar_fg_alter = 0.65,
    hl_trouble_indent = "Function",
    trouble_indent_fg_alter = -0.5,
    trouble_fold_fg_alter = 0.1,
    outline_indent_fg_alter = -0.3,
    outline_details_fg_alter = 0.5,
  }
  update_col_colorscheme["cendre"] = {
    linenr_fg_alter = 1.2,
    linenrnote_fg_alter = 0.9,
    codeblock_bg_alter = 0.22,
    commentnote_fg_alter = 0.9,
    statusline_bg_alter = -0.2,
    winseparator_fg_alter = 0.7,
    zshlines_bg_alter = 0.5,
    zshlines_fg_alter = 0.05,
    winbar_fg_alter = 0.7,
    hl_trouble_indent = "Function",
    trouble_indent_fg_alter = -0.5,
    trouble_fold_fg_alter = -0.05,
    outline_indent_fg_alter = -0.3,
    outline_details_fg_alter = 0.2,
  }
  update_col_colorscheme["gruvbox"] = {
    winseparator_fg_alter = 0.8,
    commentnote_fg_alter = 0.8,
    linenr_fg_alter = 1.22,
    zshlines_bg_alter = 0.3,
    zshlines_fg_alter = -0.1,
    trouble_indent_fg_alter = -0.25,
    orgdirective_fg_alter = 0.55,
    trouble_fold_fg_alter = 0.15,
    outline_indent_fg_alter = -0.3,
    outline_details_fg_alter = 0.4,
    winbar_fg_alter = 0.25,
    winbarnote_fg_alter = 1.2,
  }
  update_col_colorscheme["jellybeans"] = {
    winseparator_fg_alter = 0.6,
    linenr_fg_alter = 1.35,
    winbar_fg_alter = 0.7,
    trouble_fold_fg_alter = 0.8,
    linenrnote_fg_alter = 0.85,
    outline_details_fg_alter = 0.25,
  }
  update_col_colorscheme["kanagawa"] = {
    linenr_fg_alter = 2.1,
    winseparator_fg_alter = 0.8,
    trouble_indent_fg_alter = -0.75,
    trouble_fold_fg_alter = 0.45,
    outline_details_fg_alter = 0.25,
    winbar_fg_alter = 0.6,
    linenrnote_fg_alter = 1.25,
    commentnote_fg_alter = 0.45,
  }
  update_col_colorscheme["habamax"] = {
    trouble_fold_fg_alter = 0.5,
    linenr_fg_alter = 1,
    trouble_indent_fg_alter = -0.7,
    winbar_fg_alter = 0.4,
    linenrnote_fg_alter = 0.55,
    winseparator_fg_alter = 0.5,
    codeblock_bg_alter = 0.2,
    commentnote_fg_alter = 0.8,
    outline_details_fg_alter = 0.25,
  }
  update_col_colorscheme["intent"] = {
    linenr_fg_alter = 2,
    winseparator_fg_alter = 1,
    linenrnote_fg_alter = 0.8,
    trouble_fold_fg_alter = 0.45,
    trouble_indent_fg_alter = -0.8,
    winbar_fg_alter = 0.7,
    outline_details_fg_alter = 0.25,
    commentnote_fg_alter = 0.6,
    normalnote_bg_alter = 1.8,
  }
  update_col_colorscheme["luna"] = {
    linenr_fg_alter = 3.6,
    panelsidenormal_bg_alter = -0.5,
    winseparator_fg_alter = 1.8,
    statusline_bg_alter = -0.6,
    codeblock_bg_alter = 0.55,
    floatbordernote_fg_alter = 2,
    floatborderaiprompt_fg_alter = 4,
    linenrnote_fg_alter = 1.5,
    trouble_fold_fg_alter = 0.45,
    trouble_indent_fg_alter = -0.8,
    winbar_fg_alter = 1,
    outline_details_fg_alter = 0.25,
    commentnote_fg_alter = 1.5,
    comment_fg_alter = 1.2,
    normalnote_bg_alter = 1.8,
  }
  update_col_colorscheme["lackluster"] = {
    codeblock_bg_alter = 0.55,
    commentnote_fg_alter = 1,
    linenr_fg_alter = 4.3,
    hl_trouble_indent = "WarningMsg",
    normalnote_bg_alter = 1.5,
    linenrnote_fg_alter = 1.8,
    winbar_fg_alter = 0.8,
    statusline_bg_alter = -0.6,
    winbarnote_fg_alter = 3,
    orgblockorg_fg_alter = 0.1,
    outline_details_fg_alter = 0.25,
    orgdirective_fg_alter = 1,
    statusline_fg_alter = 0.8,
    winseparator_fg_alter = 2.2,
    winseparatornote_fg_alter = 1.2,
  }
  update_col_colorscheme["neogotham"] = {
    zshlines_fg_alter = 0.2,
    zshlines_bg_alter = 0.65,
    linenr_fg_alter = 1.3,
    winbar_fg_alter = 0.6,
    commentnote_fg_alter = 0.4,
    linenrnote_fg_alter = 1,
  }
  update_col_colorscheme["oxocarbon"] = {
    linenr_fg_alter = 1.3,
    winseparator_fg_alter = 0.8,
    winbar_fg_alter = 0.48,
    statusline_bg_alter = -0.2,
    linenrnote_fg_alter = 1,
    commentnote_fg_alter = 0.8,
  }
  update_col_colorscheme["nightfox"] = { linenr_fg_alter = 1.2, winseparator_fg_alter = 0.6 }
  update_col_colorscheme["rose-pine"] = {
    winseparator_fg_alter = 0.7,
    linenrnote_fg_alter = 0.8,
    trouble_indent_fg_alter = -0.75,
    trouble_fold_fg_alter = 0.65,
  }
  update_col_colorscheme["tokyonight"] = {
    winseparator_fg_alter = 0.45,
    linenrnote_fg_alter = 0.7,
    winbar_fg_alter = 0.5,
    commentnote_fg_alter = 0.5,
    normalnote_bg_alter = 0.65,
  }
  update_col_colorscheme["tokyonight-night"] = {
    winseparator_fg_alter = 1.2,
    normalnote_bg_alter = 1.5,
    codeblock_bg_alter = 0.3,
    statusline_bg_alter = -0.4,
    floatborderaiprompt_fg_alter = 2,
    linenr_fg_alter = 2.4,
    linenrnote_fg_alter = 1.2,
    commentnote_fg_alter = 0.8,
    orgdirective_fg_alter = 0.5,
  }
  update_col_colorscheme["tokyonight-storm"] = {
    commentnote_fg_alter = 0.55,
    trouble_indent_fg_alter = -0.5,
    statusline_bg_alter = -0.18,
    winseparator_fg_alter = 0.4,
    outline_details_fg_alter = 0.3,
    trouble_fold_fg_alter = 0.45,
    linenr_fg_alter = 0.7,
    normalnote_bg_alter = 0.4,
    winbarnote_fg_alter = 1,
    linenrnote_fg_alter = 0.55,
    winbar_fg_alter = 0.55,
  }
  update_col_colorscheme["vscode"] = {
    trouble_indent_fg_alter = -0.7,
    trouble_fold_fg_alter = 0.5,
    statusline_bg_alter = -0.2,
    winseparator_fg_alter = 0.45,
    hl_trouble_indent = "@variable",
    outline_details_fg_alter = 0.3,
    zshlines_bg_alter = 0.25,
    normalnote_bg_alter = 0.4,
    winbarnote_fg_alter = 1.2,
    winbar_fg_alter = 0.5,
  }
  update_col_colorscheme["zenburn"] = {
    commentnote_fg_alter = 0.5,
    winbar_fg_alter = 0.4,
    winbarnote_fg_alter = 1.4,
    linenr_fg_alter = 0.5,
    statusline_bg_alter = -0.15,
    linenrnote_fg_alter = 0.35,
    comment_fg_alter = 0.5,
    nontextnote_fg_alter = 0.5,
    normalnote_bg_alter = 0.35,
    outline_details_fg_alter = 0.15,
    outline_indent_fg_alter = -0.3,
    trouble_fold_fg_alter = 0.2,
    trouble_indent_fg_alter = -0.45,
    zshlines_bg_alter = 0.2,
    winseparator_fg_alter = 0.25,
  }
end

local function update_base_colors(theme)
  local cols = vim.deepcopy(base_colors)
  return vim.tbl_deep_extend("force", cols, update_col_colorscheme[theme] or {})
end

local general_overrides = function()
  local H = require "r.settings.highlights"

  local colors = update_base_colors(RUtils.config.colorscheme)

  local git_diff_add = H.get_git_fg_or_bg "DiffAdd"
  local git_diff_change = H.get_git_fg_or_bg "DiffChange"
  local git_diff_delete = H.get_git_fg_or_bg "DiffDelete"

  H.all {

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                    BASE                                     ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    { FoldColumn = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 0.4 } } },
    { NormalNC = { inherit = "Normal" } },
    { FoldColumn1 = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 1 } } },
    { ColorColumn = { bg = { from = "Normal", attr = "bg" } } },
    { ErrorMsg = { bg = "NONE" } },

    { Directory = colors.Directory },

    { EndOfBuffer = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 0.2 } } },
    { SignColumn = { bg = "NONE" } },
    {
      NonText = {
        fg = { from = "NonText", attr = "fg", alter = 0.5, opacity = colors.nonetext_opacity or 0.5 },
        bg = "NONE",
      },
    },
    {
      WinSeparator = {
        fg = { from = "Normal", attr = "bg", alter = colors.winseparator_fg_alter or 0.6 },
        bg = "NONE",
      },
    },

    {
      LineNr = {
        bg = "NONE",
        fg = { from = "Normal", attr = "bg", alter = colors.linenr_fg_alter or 1.15 },
        bold = false,
      },
    },
    { LineNrAbove = { inherit = "LineNr" } },
    { LineNrBelow = { inherit = "LineNr" } },
    {
      Comment = {
        fg = { from = "LineNr", attr = "fg", alter = colors.comment_fg_alter or 0.6, opacity = 0.85 },
        italic = true,
      },
    },
    { Type = { italic = true, bold = true } },
    { ["@comment"] = { inherit = "Comment" } },

    { CursorLine = { bg = { from = "Normal", attr = "bg" } } },
    { CursorLineBright = { bg = { from = "Normal", attr = "bg", alter = 0.4 } } },

    { SpecialKey = { bg = "NONE" } },

    {
      CursorLineNr = {
        fg = { from = "Keyword", attr = "fg" },
        bg = { from = "Keyword", attr = "fg", opacity = 0.15 },
        bold = true,
      },
    },
    {
      Visual = {
        bg = { from = "type", attr = "fg", transparency = 0.15, color = { from = "Normal", attr = "bg" } },
        fg = "NONE",
      },
    },

    { StatusLine = { bg = { from = "Normal", attr = "bg", alter = colors.statusline_bg_alter or -0.3 } } },
    {
      StatusLine = {
        fg = { from = "LineNr", attr = "fg", alter = colors.statusline_fg_alter or 0.5 },
        reverse = false,
      },
    },
    { StatusLineNC = { inherit = "StatusLine" } },

    {
      Pmenu = {
        fg = { from = "Normal", attr = "fg", opacity = 0.6 },
        bg = { from = "Normal", attr = "bg" },
        reverse = false,
      },
    },
    {
      PmenuSel = {
        fg = "NONE",
        bg = { from = "Keyword", attr = "fg", transparency = 0.1, color = { from = "Normal", attr = "bg" } },
        underline = false,
        reverse = false,
      },
    },

    { PmenuFloatBorder = { bg = { from = "Pmenu", attr = "bg" }, fg = { from = "Pmenu", attr = "bg" } } },
    {
      PmenuThumb = {
        bg = { from = "PmenuSel", attr = "bg", alter = 1 },
        fg = { from = "PmenuSel", attr = "bg" },
      },
    },
    { PmenuSbar = { bg = { from = "PmenuSel", attr = "bg" } } },

    {
      NormalFloat = {
        fg = { from = "Normal", attr = "fg" },
        bg = { from = "Normal", attr = "bg", alter = colors.normalfloat_bg_alter or 0.25 },
        reverse = false,
      },
    },

    {
      FloatBorder = {
        fg = { from = "WinSeparator", attr = "fg", alter = 0.15 },
        bg = { from = "Normal", attr = "bg" },
      },
    },
    {
      FloatTitle = {
        inherit = "FloatBorder",
        fg = { from = "FloatBorder", attr = "fg", alter = 2 },
        bold = true,
      },
    },
    {
      FloatFooter = {
        fg = { from = "FloatTitle", attr = "fg", alter = -0.05 },
        bg = "NONE",
      },
    },
    {
      FloatCursorline = {
        fg = "NONE",
        bg = { from = "NormalFloat", attr = "bg", alter = 0.2 },
      },
    },

    { TabLine = { fg = { from = "LineNr", attr = "fg", alter = 0.4 }, bg = "NONE" } },

    {
      CurSearch = {
        bg = { from = "CurSearch", attr = "bg", alter = 0.7 },
        fg = { from = "CurSearch", attr = "bg", transparency = 0.1, color = { from = "Normal", attr = "bg" } },
        bold = true,
      },
    },
    {
      Search = {
        inherit = "CurSearch",
        fg = { from = "CurSearch", attr = "fg", alter = 0.5 },
        bg = { from = "CurSearch", attr = "bg", transparency = 0.8, color = { from = "Normal", attr = "bg" } },
        reverse = true,
      },
    },
    { IncSearch = { inherit = "CurSearch" } },
    { TermCursor = { inherit = "Cursor" } },
    { Substitute = { inherit = "CurSearch" } },

    {
      Folded = {
        fg = {
          from = "LineNr",
          attr = "fg",
          contrast = 0.1,
        },
        bg = "NONE",
      },
    },
    {
      FoldedSign = {
        fg = {
          from = "LineNr",
          attr = "fg",
          alter = colors.foldedsign_fg_alter or 0.5,
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
    -- ║                                    ERROR                                    ║
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

    -- Struktur & Data
    { LspKindArray = { inherit = "@type" } },
    { LspKindClass = { inherit = "@type" } },
    { LspKindStruct = { inherit = "@type" } },
    { LspKindInterface = { inherit = "@type" } },
    { LspKindObject = { inherit = "@type" } },
    { LspKindEnum = { inherit = "@type" } },
    { LspKindTypeParameter = { inherit = "@type.definition" } },
    { LspKindTypeAlias = { inherit = "@type.definition" } },

    -- Variabel & Member
    { LspKindVariable = { inherit = "@variable" } },
    { LspKindField = { inherit = "@variable.member" } },
    { LspKindProperty = { inherit = "@property" } },
    { LspKindEnumMember = { inherit = "@variable.member" } },
    { LspKindConstant = { inherit = "@constant" } },
    { LspKindKey = { inherit = "@variable.member" } },

    -- Fungsi & Metode
    { LspKindFunction = { inherit = "@function" } },
    { LspKindMethod = { inherit = "@function.method" } },
    { LspKindConstructor = { inherit = "@constructor" } },

    -- Konteks & Scope
    { LspKindModule = { inherit = "@module" } },
    { LspKindPackage = { inherit = "@module" } },
    { LspKindNamespace = { inherit = "@module" } },

    -- Tipe Data Primitif
    { LspKindString = { inherit = "@string" } },
    { LspKindNumber = { inherit = "@number" } },
    { LspKindBoolean = { inherit = "@boolean" } },
    { LspKindValue = { inherit = "@constant" } },
    { LspKindNull = { inherit = "@constant.builtin" } },

    -- Lain-lain
    { LspKindKeyword = { inherit = "@keyword" } },
    { LspKindOperator = { inherit = "@operator" } },
    { LspKindSnippet = { inherit = "@comment", fg = { from = "@comment", alter = 0.5 } } },
    { LspKindFile = { inherit = "Tag" } },
    { LspKindFolder = { inherit = "Directory" } },
    { LspKindUnit = { inherit = "@type" } },
    { LspKindEvent = { inherit = "Special" } },
    -- { LspKindReference = { inherit = "@markup.link" } },

    {
      LspReferenceText = {
        bg = { from = "Special", attr = "fg" },
        fg = { from = "Normal", attr = "bg" },
        bold = true,
      },
    },
    {
      LspReferenceRead = {
        bg = { from = "Type", attr = "fg" },
        fg = { from = "Normal", attr = "bg" },
        bold = true,
      },
    },
    {
      LspReferenceWrite = {
        bg = { from = "Statement", attr = "fg" },
        fg = { from = "Normal", attr = "bg" },
        underline = true,
        bold = true,
      },
    },

    -- {
    --   LspCodeLens = {
    --     fg = { from = "Normal", attr = "bg", alter = colors.lsp_code_lens_fg_alter },
    --     bg = { from = "Normal", attr = "bg", alter = colors.lsp_code_lens_bg_alter },
    --   },
    -- },
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
        fg = { from = "LineNr", attr = "fg", alter = colors.zshlines_fg_alter or 0.05 }, --> line
        bg = { from = "LineNr", attr = "fg", alter = colors.zshlines_bg_alter or 0.6 }, -- > foreground
      },
    },

    -- ├──────────────────────────────────┤ NOTE ├──────────────────────────────────┤
    {
      NormalNote = {
        fg = { from = "Normal", attr = "fg", alter = 0.2 },
        bg = { from = "Normal", attr = "bg", alter = colors.normalnote_bg_alter or 0.6 },
      },
    },
    {
      LineNrNote = {
        fg = { from = "NormalNote", attr = "bg", alter = colors.linenrnote_fg_alter or 0.6 },
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
    { NonTextNote = { fg = { from = "NormalNote", attr = "bg", alter = colors.nontextnote_fg_alter or 1.2 } } },
    { DelimiterNote = { fg = { from = "NormalNote", attr = "bg", alter = 1.2 } } },
    { CursorLineNote = { bg = { from = "NormalNote", attr = "bg" } } },
    {
      CursorLineNrNote = {
        fg = { from = "Keyword", attr = "fg", alter = 0.5 },
        bg = {
          from = "Keyword",
          attr = "fg",
          alter = 0.1,
          transparency = 0.1,
          color = { from = "NormalNote", attr = "bg" },
        },
        bold = true,
      },
    },
    { FoldedNote = { fg = { from = "LineNrNote", attr = "fg", alter = 0.2 } } },
    { FoldedNoteSign = { fg = { from = "LineNrNote", attr = "fg", alter = 0.5 } } },
    {
      FloatBorderNote = {
        fg = { from = "NormalNote", attr = "bg", alter = colors.floatbordernote_fg_alter or 0.5 },
        bg = { from = "NormalNote", attr = "bg" },
      },
    },
    {
      FloatTitleNote = {
        fg = { from = "FloatBorderNote", attr = "fg", alter = 0.25 },
        bg = { from = "FloatBorderNote", attr = "bg" },
        bold = true,
      },
    },

    {
      FloatFooterNote = {
        fg = { from = "FloatTitleNote", attr = "fg", alter = -0.05 },
        bg = "NONE",
      },
    },

    { VisualNote = { bg = { from = "Visual", attr = "bg", alter = 0.5 } } },
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
        fg = { from = "NormalNote", attr = "bg", alter = colors.winseparatornote_fg_alter or 0.35 },
        bg = { from = "NormalNote", attr = "bg" },
      },
    },

    -- ├───────────────────────────────┤ AI PROMPT ├────────────────────────────┤

    {
      NormalAiPrompt = {
        fg = { from = "Normal", attr = "fg", alter = 0.15 },
        bg = { from = "Normal", attr = "bg", alter = -0.15 },
      },
    },
    { CommentAiPrompt = { fg = { from = "NormalAiPrompt", attr = "bg", alter = 5 } } },
    {
      NonTextAiPrompt = {
        fg = { from = "NormalAiPrompt", attr = "bg", alter = colors.nontextaiprompt_fg_alter or 1.2 },
      },
    },
    {
      LineNrAiPrompt = {
        fg = { from = "NormalAiPrompt", attr = "bg", alter = 0.5 },
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
        fg = { from = "NormalAiPrompt", attr = "bg", alter = colors.floatborderaiprompt_fg_alter or 0.5 },
        bg = { from = "NormalAiPrompt", attr = "bg" },
      },
    },

    {
      FloatTitleAiPrompt = {
        fg = { from = "FloatBorderAiPrompt", attr = "fg", alter = 1.5 },
        bg = { from = "FloatBorderAiPrompt", attr = "bg" },
        bold = true,
      },
    },

    {
      FloatFooterAiPrompt = {
        fg = { from = "FloatTitleAiPrompt", attr = "fg", alter = -0.05 },
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
        fg = { from = "LineNr", attr = "fg", alter = colors.winbar_fg_alter or 0.8 },
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
      WinBarNote = {
        fg = { from = "NormalNote", attr = "bg", alter = colors.winbarnote_fg_alter or 1.8 },
        bg = { from = "NormalNote", attr = "bg" },
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
  local H = require "r.settings.highlights"
  local colors = update_base_colors(RUtils.config.colorscheme)
  return H.all {

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                    NOICE                                    ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    { NoiceCmdline = { fg = { from = "StatusLine", attr = "fg", alter = 1.5 }, bg = "NONE" } },

    -- Highlight :Messages noice
    { NoiceSplit = { bg = { from = "NormalKeyword", attr = "bg", alter = -0.6, opacity = 0.7 } } },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                    BLINK                                    ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    {
      BlinkDocNormal = {
        fg = { from = "Normal", attr = "fg" },
        bg = { from = "NormalFloat", attr = "bg", alter = 0.15 },
      },
    },
    {
      BlinkDocFloatBorder = {
        fg = { from = "BlinkDocNormal", attr = "bg", alter = 0.1 },
        bg = { from = "NormalFloat", attr = "bg", alter = 0.15 },
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
    { BlinkCmpLabelMatch = { fg = { from = "constant", attr = "fg", alter = 0.4 } } },
    { BlinkCmpLabelKind = { fg = { from = "LineNr", attr = "fg", alter = 0.25 } } },

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

    { FzfLuaNormal = { bg = { from = "NormalFloat", attr = "bg" } } },
    {
      FzfLuaTitle = {
        inherit = "FloatTitle",
        reverse = false,
        bold = true,
      },
    },
    { FzfLuaBorder = { inherit = "FloatBorder" } },
    {
      FzfLuaFilePart = {
        fg = { from = "Keyword", attr = "fg", contrast = 0.15 },
        bg = { from = "FzfLuaNormal", attr = "bg" },
        bold = false,
      },
    },
    { FzfLuaDirPart = { inherit = "FzfLuaFilePart" } },
    {
      FzfLuaHeaderText = {
        fg = {
          from = "type",
          attr = "fg",
          opacity = 0.8,
          contrast = 0.1,
          transparency = 0.8,
          color = { from = "FzfLuaFilePart", attr = "bg" },
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
        fg = { from = "FzfLuaFilePart", attr = "fg", alter = 0.25 },
        bg = { from = "Keyword", attr = "fg", transparency = 0.15, color = { from = "FzfLuaNormal", attr = "bg" } },
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
    { FzfLuaPreviewTitle = { inherit = "FzfLuaTitle" } },
    { FzfLuaScrollBorderFull = { fg = { from = "FzfLuaBorder", attr = "fg", alter = 0.3 } } },
    {
      FzfLuaCursorLine = {
        fg = "NONE",
        bg = {
          from = "FzfLuaNormal",
          attr = "bg",
          alter = 0.5,
          transparency = 1,
          color = { from = "FzfLuaNormal", bg = "attr" },
        },
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
        bg = { from = "NormalNote", attr = "bg" },
      },
    },
    { ["@markup.list.markdown"] = { bg = "NONE" } },

    -- {
    --   ["@markup.link.label.markdown_inline"] = {
    --     fg = { from = "@markup.link", attr = "fg", alter = 0.5 },
    --     bg = "NONE",
    --   },
    -- },

    {
      ["@markup.quote.markdown"] = {
        fg = {
          from = "Keyword",
          attr = "fg",
          alter = 0.1,
          transparency = 0.7,
          color = { from = "NormalNote", attr = "bg" },
        },
        bg = { from = "NormalNote", attr = "bg", alter = -0.1 },
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
          from = "Statement",
          attr = "fg",
          alter = 0.1,
          transparency = 0.9,
          color = { from = "NormalNote", attr = "bg" },
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
        bg = { from = "NormalNote", attr = "bg", alter = colors.codeblock_bg_alter or 0.2, is_note = true },
        italic = false,
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
          transparency = 0.1,
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
          from = "StatusLine",
          attr = "fg",
          alter = 0.1,
        },
        bg = { from = "StatusLine", attr = "bg" },
      },
    },

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
    { ["@org.checkbox.org"] = { inherit = "Error" } },
    { ["@org.checkbox.checked"] = { inherit = "org.comment.org" } },
    {
      ["@org.directive"] = { fg = { from = "LineNrNote", attr = "fg", alter = colors.orgdirective_fg_alter or 0.45 } },
    },
    { ["@org.tag.org"] = { fg = { from = "@org.directive", attr = "fg", alter = 0.5 } } },
    { OrgBulletsDash = { inherit = "Special", bg = "NONE" } },
    { ["@org.bold"] = { inherit = "@markup.strong.markdown_inline" } },
    { ["@org.italic"] = { inherit = "@markup.italic.markdown_inline" } },
    {
      ["@org.comment.org"] = {
        inherit = "@markup.italic.markdown_inline",
        bg = { from = "NormalNote", attr = "bg", alter = 0.2 },
      },
    },

    { ["@org.code"] = { inherit = "RenderMarkdownCodeInline" } },

    { CodeBlock = { inherit = "RenderMarkdownCode", reverse = false } },
    {
      ["@org.block.org"] = { fg = { from = "LineNrNote", attr = "fg", alter = colors.orgblockorg_fg_alter or 0.2 } },
    },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                   LAZYGIT                                   ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    { LazygitselectedLineBgColor = { bg = { from = "Keyword", attr = "fg", alter = -0.6 } } },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                TODO-COMMENT                                 ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    { TodoSignWarn = { bg = "NONE" } },
    { TodoSignFIX = { bg = "NONE" } }, -- for error
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
    -- ║                                  GRUG FAR                                   ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    {
      GrugFarHelpHeader = {
        fg = { from = "Comment", attr = "fg", alter = -0.05 },
        italic = true,
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
        fg = { from = "Directory", attr = "fg", alter = -0.3 },
        bold = true,
        underline = true,
      },
    },
    {
      GrugFarResultsLineNr = {
        fg = { from = "LineNr", attr = "fg", alter = 0.6 },
        bg = { from = "LineNr", attr = "fg", alter = 0.6, opacity = 0.1 },
      },
    },
    {
      GrugFarResultsNumberLabel = {
        fg = { from = "diffRemoved", attr = "fg", alter = 0.1, opacity = 0.5 },
        bold = false,
      },
    },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                 NOTIFY.NVIM                                 ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

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

    { WhichKey = { bg = { from = "FzfLuaNormal", attr = "bg" } } },
    { WhichKeySeparator = { bg = { from = "FzfLuaNormal", attr = "bg" } } },
    { WhichKeyTitle = { inherit = "FzfLuaTitle" } },
    { WhichKeyNormal = { inherit = "FzfLuaNormal" } },
    { WhichKeyGroup = { inherit = "FzfLuaNormal", fg = { from = "Keyword", attr = "fg", alter = 0.1 } } },
    { WhichKeyDesc = { inherit = "FzfLuaNormal", fg = { from = "Boolean", attr = "fg", alter = 0.1 } } },
    { WhichKeyBorder = { inherit = "FzfLuaBorder" } },

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
    { LspInlayHint = { inherit = "LspInlayHint" } },
  }
end

local function set_panel_highlight()
  local H = require "r.settings.highlights"
  local colors = update_base_colors(RUtils.config.colorscheme)

  H.all {

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                   SIDEBAR                                   ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    {
      PanelSideNormal = {
        fg = { from = "Normal", attr = "fg" },
        bg = { from = "StatusLine", attr = "bg", alter = colors.panelsidenormal_bg_alter or -0.05 },
      },
    },
    { PanelSideBackground = { link = "PanelSideNormal", fg = "NONE" } },
    { PanelSideDarkBackground = { bg = { from = "PanelSideNormal", attr = "bg", alter = -1 } } },

    { PanelSideDarkHeading = { inherit = "PanelSideDarkBackground", bold = true } },
    { PanelSideHeading = { inherit = "PanelSideBackground", bold = true } },

    {
      PanelSideRootName = { bg = { from = "PanelSideNormal", attr = "bg" }, fg = { from = "StatusLine", attr = "fg" } },
    },

    { PanelSideStNC = { link = "PanelSideWinSeparator" } },
    { PanelSideSt = { bg = { from = "Visual", alter = -0.2 } } },
    { PanelSideStusLine = { bg = { from = "StatusLine" }, fg = { from = "Normal", attr = "fg" } } },

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
          alter = colors.panelbottomcursorlinenr_fg_alter or 8,
          bold = true,
        },
      },
    },

    { PanelBottomDarkBackground = { bg = { from = "PanelBottomBackground", attr = "bg", alter = -0.1 } } },
    { PanelBottomDarkHeading = { inherit = "PanelBottomDarkBackground", bold = true } },

    {
      PanelBottomLineNr = {
        fg = { from = "PanelBottomNormal", attr = "bg", alter = colors.panelbottomlinenr_fg_alter or 2 },
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
      HoveredCursorline = {
        bg = { from = "PanelSideBackground", attr = "bg", alter = 0.6 },
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
          from = "Keyword",
          attr = "fg",
          alter = 0.5,
          transparency = 0.2,
          color = { from = "PanelBottomNormal", attr = "bg" },
        },
        underline = true,
        reverse = false,
      },
    },
    { QuickFixLineNr = { fg = { from = "PanelBottomNormal", attr = "bg", contrast = 0.5 } } },
    { QuickFixMiddleLineNr = { fg = { from = "Constant", attr = "fg", contrast = 0.2 } } },
    { QuickFixWinDelimiter = { fg = { from = "PanelBottomNormal", attr = "bg", alter = 1 } } },
    {
      QuickFixWinSeparator = {
        fg = { from = "WinSeparator", attr = "fg" },
        bg = { from = "Normal", attr = "bg" },
      },
    },
    { qfSeparator1 = { fg = { from = "Error", attr = "fg", alter = 0.1 } } },
    { qfSeparator2 = { link = "qfSeparator1" } },
    { qfFileName = { bg = "NONE" } },

    {
      QuickFixWinbar = {
        fg = { from = "WinBar", attr = "fg", alter = colors.quickfixwinbar_fg_alter or 0.4 },
        bg = { from = "PanelBottomNormal", attr = "bg", alter = colors.quickfixwinbar_bg_alter or 0.5 },
      },
    },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                 QFBOOKMARK                                  ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    -- {
    --   QFBookmarkQfLineNr = {
    --     fg = {
    --       from = "QuickFixMiddleLineNr",
    --       attr = "fg",
    --     },
    --   },
    -- },
    { QFBookmarkQfLineNr = { link = "WarningMsg" } },

    {
      QFBookmarkQfSep = {
        fg = {
          from = "WinSeparator",
          attr = "fg",
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

    {
      TroubleIndent = {
        fg = {
          from = colors.hl_trouble_indent or "Directory",
          attr = "fg",
          alter = colors.trouble_indent_fg_alter or -0.7,
        },
        bg = "NONE",
      },
    },
    {
      TroubleIndentFoldClosed = {
        inherit = "TroubleIndent",
        fg = { from = "TroubleIndent", attr = "fg", alter = colors.trouble_fold_fg_alter or 1.2 },
      },
    },
    { TroubleIndentFoldOpen = { link = "TroubleIndentFoldClosed" } },

    -- ├───────────────────────────────┤ DIRECTORY ├────────────────────────────┤

    {
      TroubleDirectory = {
        fg = { from = "Normal", attr = "bg" },
        bg = {
          from = "Directory",
          attr = "fg",
        },
        bold = true,
      },
    },
    {
      TroubleFsPos = {
        inherit = "TroubleIndent",
        fg = { from = "TroubleIndent", attr = "fg", alter = 0.2 },
      },
    },
    {
      TroubleFsCount = {
        fg = { from = "Directory", attr = "fg", alter = -0.13 },
        bg = { from = "TroubleFsPos", attr = "fg" },
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
        fg = { from = "TroubleIndent", attr = "fg", alter = colors.outline_indent_fg_alter or 0 },
        bg = "NONE",
      },
    },
    {
      OutlineCurrent = {
        fg = { from = "Normal", attr = "bg" },
        bg = {
          from = "TroublePreview",
          attr = "fg",
        },
      },
    },
    {
      OutlineCurrentParent = {
        fg = { from = "Normal", attr = "bg" },
        bg = {
          from = "String",
          attr = "fg",
        },
      },
    },
    { OutlineFoldMarker = { fg = { from = "TroubleIndentFoldClosed", attr = "fg", alter = -0.1 }, bg = "NONE" } },

    {
      OutlineDetails = {
        fg = { from = "OutlineGuides", attr = "fg", alter = colors.outline_details_fg_alter or 0.7 },
        bg = "NONE",
        italic = true,
      },
    },
    { OutlineJumpHighlight = { bg = "red", fg = "NONE" } },
    { OutlineLineno = { bg = "NONE" } },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                   AERIALS                                   ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    { AerialGuide = { link = "OutlineGuides" } },
    { AerialLine = { link = "OutlineCurrent" } },

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
  local H = require "r.settings.highlights"
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
          fg = { from = "OutlineDetails", attr = "fg", alter = 0.1 },
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
          fg = { from = "OutlineDetails", attr = "fg", opacity = 0.8 },
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
          fg = { from = "OutlineDetails", attr = "fg", opacity = 0.9 },
          bg = "NONE",
        },
      },
    },
    ["oxocarbon"] = {
      { NonText = { fg = { from = "NonText", attr = "fg", alter = 0.1 } } },
      {
        SnacksIndentScope = {
          fg = { from = "OutlineDetails", attr = "fg", opacity = 0.85 },
          bg = "NONE",
        },
      },
    },
    ["tokyonight-night"] = {
      { NonText = { fg = { from = "NonText", attr = "fg", alter = -0.1 } } },
      {
        SnacksIndentScope = {
          fg = { from = "GitSignsChange", attr = "fg", opacity = 0.5 },
          bg = "NONE",
        },
      },
    },

    ["rose-pine"] = {
      { NonText = { fg = { from = "NonText", attr = "fg", alter = -0.2 } } },
      {
        SnacksIndentScope = {
          fg = { from = "GitSignsChange", attr = "fg", alter = -0.25 },
          bg = "NONE",
        },
      },
    },
    ["vscode"] = {
      {
        SnacksIndentScope = {
          fg = { from = "GitSignsChange", attr = "fg", alter = -0.3 },
          bg = "NONE",
        },
      },
    },
  }

  local hls = overrides[vim.g.colors_name]
  if hls then
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

  --
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
}

Win.filetype_winhighlights = {
  ["qf"] = true,
  ["Outline"] = true,
  ["aerial"] = true,
  ["trouble"] = true,
  ["grug-far"] = true,
  ["dbui"] = true,
  -- ["TelescopePrompt"] = true,

  --   "flutterToolsOutline",
  --   "undotree",
  --   "neotest-summary",
  --   "pr",

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
  ["markdown"] = true,
  ["octo"] = true,
  ["eldochover"] = true,
}

Win.aiprompt_winhighlights = {
  ["codecompanion"] = true,
}

-- ├─────────────────────────────────┤ HELPER ├─────────────────────────────────┤

---@return { filetype: string, buftype: string, is_float: boolean  }
local __get_win_opts = function()
  local filetype, buftype = RUtils.buf.get_bo_buft()
  local is_float = vim.api.nvim_win_get_config(0).relative ~= ""
  return {
    filetype = filetype,
    buftype = buftype,
    is_float = is_float,
  }
end

local get_winhighlight_for_filetype = function(filetype)
  if Win.filetype_winhighlights[filetype] then
    return winhighlight_bottom_panel
  end
  if Win.note_winhighlights[filetype] then
    return winhighlight_note_panel
  end
  if Win.aiprompt_winhighlights[filetype] then
    return winhighlight_ai_panel
  end
  return nil
end

local set_winhighlights = function(filetype)
  local hl = get_winhighlight_for_filetype(filetype)
  if hl then
    wo.winhighlight = hl
    vim.w.rutils_winhighlight_owner = filetype
  else
    if vim.w.rutils_winhighlight_owner ~= nil then
      wo.winhighlight = ""
      vim.w.rutils_winhighlight_owner = nil
    end
  end
end

local hl_note = {
  ["Pmenu"] = "PmenuNote",
  ["PmenuSel"] = "PmenuSelNote",
}

local hl_aiprompt = {
  ["Pmenu"] = "PmenuAiPrompt",
  ["PmenuSel"] = "PmenuSelAiPrompt",
}

local hl_cursorline = {
  ["CursorLine"] = "CursorLineBright",
}

local pmenu_original = nil
local cursorline_original = nil

---@param ft string
---@param is_color_restore? boolean
---@param is_cursorline_restore? boolean
local function set_hl(ft, is_color_restore, is_cursorline_restore)
  is_color_restore = is_color_restore or false
  is_cursorline_restore = is_cursorline_restore or false

  local function __set(tbl)
    for key, val in pairs(tbl) do
      vim.api.nvim_set_hl(0, key, { link = val })
    end
  end

  if is_color_restore then
    if not pmenu_original then
      return
    end
    vim.api.nvim_set_hl(0, "Pmenu", pmenu_original.pmenu)
    vim.api.nvim_set_hl(0, "PmenuSel", pmenu_original.pmenusel)

    pmenu_original = nil
    return
  end

  if is_cursorline_restore then
    if cursorline_original then
      __set { ["CursorLine"] = "CursorLine" }
      cursorline_original = nil
      return
    end

    if Win.cursorline_bright[ft] then
      __set(hl_cursorline)
    end
    return
  end

  if Win.aiprompt_winhighlights[ft] then
    __set(hl_aiprompt)
  end

  if Win.note_winhighlights[ft] then
    __set(hl_note)
  end
end

-- ├──────────────────────────────┤ FOCUS OR NOT ├──────────────────────────────┤

local function focus(ctx)
  ctx = ctx or {}
  local cur_winopts = __get_win_opts()
  local filetype = cur_winopts.filetype

  if Win.filetype_blacklist_winhighlights[filetype] then
    return
  end

  if cur_winopts.is_float then
    local hl = get_winhighlight_for_filetype(filetype)
    if hl then
      wo.winhighlight = hl
      vim.w.rutils_winhighlight_owner = filetype
      return
    end
    if not vim.w.is_overlook_popup then
      wo.winhighlight = ""
    end
    return
  end

  set_winhighlights(filetype)
end

local function blurred(ctx)
  ctx = ctx or {}
  local cur_winopts = __get_win_opts()
  local filetype = cur_winopts.filetype

  set_winhighlights(filetype)
end

-- ├───────────────────────────────┤ SET CURSOR ├───────────────────────────────┤

local function set_cursorline(ctx, active)
  ctx = ctx or {}
  local cur_winopts = __get_win_opts()
  local filetype = cur_winopts.filetype

  if Win.cursorline_blacklist[filetype] then
    active = false
  end

  if vim.w.is_overlook_popup then
    active = false
  end

  wo.cursorline = active

  local ft = vim.bo.filetype
  set_hl(ft, false, true)
end

-- ├───────────────────────────────┤ BUF EVENT ├────────────────────────────┤

local function buf_enter(ctx)
  focus(ctx)
  set_cursorline(ctx, true)
end

local function buf_leave(ctx)
  focus(ctx)
  set_cursorline(ctx, false)
end

local function win_enter(ctx)
  focus(ctx)
  set_cursorline(ctx, true)
end

local function win_leave(ctx)
  blurred(ctx)
  set_cursorline(ctx, true)
end

local function insert_enter(ctx)
  set_cursorline(ctx, false)
end

local function insert_leave(ctx)
  set_cursorline(ctx, true)
end

local function focus_gain(ctx)
  set_cursorline(ctx, true)
end

local function focus_lost(ctx)
  blurred(ctx)
end

local function user_highlights()
  general_overrides()
  plugins_overrides()
  set_panel_highlight()
  colorscheme_overrides()
end

-- ├─────────────────────────────────┤ AUGRUP ├─────────────────────────────────┤

RUtils.map.augroup("UserHighlights", {
  event = "ColorScheme",
  command = function()
    user_highlights()
  end,
})

RUtils.map.augroup("UserDimWindow", {
  event = "InsertEnter",
  pattern = "*",
  command = function(ctx)
    insert_enter(ctx)
  end,
}, {
  event = "InsertLeave",
  pattern = "*",
  command = function(ctx)
    insert_leave(ctx)
  end,
}, {
  event = "BufRead",
  pattern = "*",
  command = function(ctx)
    vim.defer_fn(function()
      buf_enter(ctx)
    end, 1)
  end,
}, {
  event = "BufEnter",
  pattern = "*",
  command = function(ctx)
    vim.defer_fn(function()
      buf_enter(ctx)
    end, 1)
  end,
}, {
  event = "BufLeave",
  pattern = "*",
  command = function(ctx)
    if not cursorline_original then
      cursorline_original = true
    end

    vim.defer_fn(function()
      buf_leave(ctx)
    end, 1)
  end,
}, {
  event = "WinNew",
  pattern = "*",
  command = function()
    wo.winhighlight = ""
    vim.w.rutils_winhighlight_owner = nil
  end,
}, {
  event = "WinEnter",
  pattern = "*",
  command = function(ctx)
    vim.defer_fn(function()
      win_enter(ctx)
    end, 1)
  end,
}, {
  event = "WinLeave",
  pattern = "*",
  command = function(ctx)
    if not cursorline_original then
      cursorline_original = true
    end
    win_leave(ctx)
  end,
}, {
  event = "VimEnter",
  pattern = "*",
  command = function(ctx)
    vim.defer_fn(function()
      win_enter(ctx)
    end, 1)
  end,
}, {
  event = "FocusGained",
  pattern = "*",
  command = function(ctx)
    focus_gain(ctx)
  end,
}, {
  event = "FocusLost",
  pattern = "*",
  command = function(ctx)
    focus_lost(ctx)
  end,
})

-- Store original Pmenu colors before overriding
local function save_pmenu_colors()
  local pmenu = vim.api.nvim_get_hl(0, { name = "Pmenu", link = false })
  local pmenusel = vim.api.nvim_get_hl(0, { name = "PmenuSel", link = false })
  return { pmenu = pmenu, pmenusel = pmenusel }
end

local get_note_filetype = function(win_highlights)
  local tbl = {}
  for key, _ in pairs(win_highlights) do
    tbl[#tbl + 1] = key
  end
  return tbl
end

local note_filetypes = get_note_filetype(Win.note_winhighlights)
local ai_prompt_filetypes = get_note_filetype(Win.aiprompt_winhighlights)

local all_special = vim.tbl_extend("force", {}, Win.note_winhighlights, Win.aiprompt_winhighlights)

RUtils.map.augroup("UserHighlightsCustom", {
  event = "FileType",
  pattern = note_filetypes,
  command = function(ctx)
    vim.schedule(function()
      if not pmenu_original then
        pmenu_original = save_pmenu_colors()
      end
      local ft = vim.bo[ctx.buf].filetype
      set_hl(ft)
    end)
  end,
}, {
  event = "FileType",
  pattern = ai_prompt_filetypes,
  command = function(ctx)
    if not pmenu_original then
      pmenu_original = save_pmenu_colors()
    end
    local ft = vim.bo[ctx.buf].filetype
    set_hl(ft)
  end,
}, {
  event = { "BufEnter", "WinEnter" },
  pattern = "*",
  command = function(ctx)
    if not pmenu_original then
      pmenu_original = save_pmenu_colors()
    end

    local ft = vim.bo[ctx.buf].filetype
    if all_special[ft] then
      set_hl(ft)
    end
  end,
}, {
  event = { "BufLeave", "WinLeave" },
  pattern = "*",
  command = function(ctx)
    local ft = vim.bo[ctx.buf].filetype
    if all_special[ft] then
      set_hl(ft, true)
    end
  end,
}, {
  event = "WinClosed",
  pattern = "*",
  command = function(ctx)
    -- Check if closed window was a float
    local win = tonumber(ctx.match)
    if not win or not vim.api.nvim_win_is_valid(win) then
      return
    end

    local cfg = vim.api.nvim_win_get_config(win)
    if cfg.relative ~= "" then
      -- Float was closed, check current window filetype
      local cur_ft = vim.bo.filetype
      if not all_special[cur_ft] then
        set_hl(cur_ft, true)
      end
    end
  end,
})
