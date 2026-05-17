local wo = vim.wo

local base_colors = {
  Directory = { fg = { from = "Directory", attr = "fg" }, bg = "NONE" },
  dapstopped_bg_alter = 0.25,
  grugfar_result_linenr_bg_alter = -0.35,
  grugfar_result_linenr_fg_alter = 0.65,
  grugfar_result_number_fg_alter = 0.6,
  hovered_cursorline_bg_alter = 0.3,
  lsp_code_lens_bg_alter = 0.15,
  lsp_code_lens_fg_alter = 1.5,
  normal_float_fg_alter = -0.01,
  pmenu_thumb_bg_alter = 0.4,
  tmux_statusline_fg_alter = -0.2,
  trouble_indent_fg_alter = 0.55,

  normal_note_bg_alter = 5,
  normal_note_fg_alter = 0.45,
  cursorline_note_bg_alter = 0.1,
  cursorlinenr_note_bg_alter = 0.25,
  delimeter_note_fg_alter = 1,
  floatborder_note_fg_alter = 0.4,
  floattitle_note_fg_alter = 0.2,
  fold_note_fg_alter = 0.1,
  linenr_note_fg_alter = 0.4,
  nontext_note_fg_alter = 0.35,
  urllink_note_bg_alter = 0.6,
  urllink_note_fg_alter = 0.2,
  visual_note_bg_alter = 0.8,

  panel_bottom_normal_bg_alter = 0.1,
}

local update_col_colorscheme = {
  ["ashen"] = {
    grugfar_result_linenr_bg_alter = -0.3,
    grugfar_result_linenr_fg_alter = 0.65,
    grugfar_result_number_fg_alter = 0.65,
    lsp_code_lens_bg_alter = 0.5,
    lsp_code_lens_fg_alter = 2.5,
    trouble_indent_fg_alter = 0.8,

    fold_note_fg_alter = 0.05,
    linenr_note_fg_alter = 0.5,
    nontext_note_fg_alter = 0.8,
    normal_note_bg_alter = 15,
    urllink_note_bg_alter = 0.4,
    urllink_note_fg_alter = -0.1,
  },
  ["intent"] = {
    lsp_code_lens_bg_alter = 0.65,
    lsp_code_lens_fg_alter = 3.5,
    trouble_indent_fg_alter = 2.2,

    floatborder_note_fg_alter = 0.3,
    fold_note_fg_alter = 0.05,
    linenr_note_fg_alter = 0.5,
    nontext_note_fg_alter = 0.8,
    normal_note_bg_alter = 4,
    urllink_note_bg_alter = 0.4,
    urllink_note_fg_alter = -0.1,
  },
  ["darcubox"] = {
    hovered_cursorline_bg_alter = 0.8,
  },
  ["base46-material-darker"] = {
    dapstopped_bg_alter = 0.2,
  },
  ["base46-jellybeans"] = {
    dapstopped_bg_alter = 0.2,
    trouble_indent_fg_alter = 0.7,
  },
  ["base46-material-lighter"] = {
    dapstopped_bg_alter = 0.2,
    trouble_indent_fg_alter = 0.5,
  },
  ["base46-melange"] = {
    dapstopped_bg_alter = 0.15,
    trouble_indent_fg_alter = 0.6,
  },
  ["base46-everforest"] = {
    dapstopped_bg_alter = 0.2,
    lsp_code_lens_bg_alter = 0.1,
    lsp_code_lens_fg_alter = 1,
    trouble_indent_fg_alter = 0.7,

    delimeter_note_fg_alter = 1.5,
    floatborder_note_fg_alter = 0.25,
    linenr_note_fg_alter = 0.5,
    normal_note_bg_alter = 0.65,
    normal_note_fg_alter = 0.4,
    urllink_note_bg_alter = 0.4,
    urllink_note_fg_alter = 0.3,
  },
  ["catppuccin"] = {
    dapstopped_bg_alter = 0.15,
    grugfar_result_linenr_fg_alter = 0.7,
    lsp_code_lens_bg_alter = 0.2,
    lsp_code_lens_fg_alter = 1.5,
    trouble_indent_fg_alter = 1.5,

    linenr_note_fg_alter = 0.4,
    normal_note_bg_alter = 1,
  },
  ["habamax"] = {
    dapstopped_bg_alter = 0.15,
    grugfar_result_linenr_fg_alter = 0.7,
    lsp_code_lens_bg_alter = 0.2,
    lsp_code_lens_fg_alter = 1.5,
    trouble_indent_fg_alter = 1.5,

    linenr_note_fg_alter = 0.4,
    normal_note_bg_alter = 1,
  },
  ["github_dark"] = {
    winbar_bg_alter = 0.8,
  },
  ["gruvbox-material"] = {
    lsp_code_lens_bg_alter = -0.03,
    lsp_code_lens_fg_alter = 0.5,
    trouble_indent_fg_alter = 0.35,
  },
  ["night-owl"] = {},
  ["techbase"] = {},
  ["jellybeans"] = {
    Directory = { fg = "#8fbfdc", bg = "NONE" },
    dapstopped_bg_alter = 0.2,
    lsp_code_lens_bg_alter = 0.4,
    lsp_code_lens_fg_alter = 2.2,
    panel_sidebar_bg_altcer = 4,
    trouble_indent_fg_alter = 1,

    floatborder_note_fg_alter = 0.25,
    linenr_note_fg_alter = 0.45,
    normal_note_bg_alter = 2,
    normal_note_fg_alter = 0.6,
  },
  ["kanagawa"] = {
    dapstopped_bg_alter = 0.2,
    grugfar_result_linenr_fg_alter = 0.55,
    grugfar_result_number_fg_alter = 0.55,
    lsp_code_lens_bg_alter = 1,
    lsp_code_lens_fg_alter = 4,
    trouble_indent_fg_alter = 1.5,

    linenr_note_fg_alter = 0.55,
  },
  ["gruvbox"] = {
    dapstopped_bg_alter = 0.2,
    lsp_code_lens_bg_alter = 0.25,
    lsp_code_lens_fg_alter = 1.5,
    trouble_indent_fg_alter = 1,

    delimeter_note_fg_alter = 1.5,
    floatborder_note_fg_alter = 0.25,
    linenr_note_fg_alter = 0.5,
    normal_note_bg_alter = 1,
    normal_note_fg_alter = 0.4,
    urllink_note_bg_alter = 0.4,
    urllink_note_fg_alter = 0.3,
  },
  ["gruvbox-old"] = {
    dapstopped_bg_alter = 0.2,
    lsp_code_lens_bg_alter = 0.5,
    lsp_code_lens_fg_alter = 2.8,
    trouble_indent_fg_alter = 1.8,

    delimeter_note_fg_alter = 1.5,
    linenr_note_fg_alter = 0.6,
    normal_note_bg_alter = 2.5,
    normal_note_fg_alter = 0.4,
    urllink_note_bg_alter = 0.4,
    urllink_note_fg_alter = 0.3,
  },
  ["lemons"] = {
    lsp_code_lens_bg_alter = 3.5,
    lsp_code_lens_fg_alter = 15,
    trouble_indent_fg_alter = 3,

    linenr_note_fg_alter = 1,
    nontext_note_fg_alter = 0.45,
    normal_note_bg_alter = 6.5,
    normal_note_fg_alter = 0.4,
    urllink_note_bg_alter = 0.4,
    urllink_note_fg_alter = 0.05,
  },
  ["lackluster"] = {
    Directory = { fg = "#7788aa", bg = "NONE" },
    lsp_code_lens_bg_alter = 2,
    lsp_code_lens_fg_alter = 9,
    trouble_indent_fg_alter = 1.8,

    cursorlinenr_note_bg_alter = 0.3,
    linenr_note_fg_alter = 0.7,
    normal_note_bg_alter = 10,
    normal_note_fg_alter = 0.2,
  },
  ["lackluster-mint"] = {
    Directory = { fg = "#7788aa", bg = "NONE" },
    trouble_indent_fg_alter = 0.5,
  },
  ["neogotham"] = {
    dapstopped_bg_alter = 0.15,
    grugfar_result_number_fg_alter = 0.5,
    lsp_code_lens_bg_alter = 0.45,
    lsp_code_lens_fg_alter = 3,
    trouble_indent_fg_alter = 1.2,

    normal_note_bg_alter = 2.5,
    normal_note_fg_alter = 0.45,
    nontext_note_fg_alter = 0.45,
  },
  ["oxocarbon"] = {
    dapstopped_bg_alter = 0.2,
    hovered_cursorline_bg_alter = 0.6,
    lsp_code_lens_bg_alter = 0.4,
    lsp_code_lens_fg_alter = 2.5,
    trouble_indent_fg_alter = 1.5,

    linenr_note_fg_alter = 0.6,
    nontext_note_fg_alter = 0.5,
    normal_note_bg_alter = 2,
    normal_note_fg_alter = 0.3,
    urllink_note_bg_alter = 0.35,
    urllink_note_fg_alter = -0.15,
  },
  ["rose-pine"] = {
    grugfar_result_linenr_fg_alter = 0.75,
    grugfar_result_number_fg_alter = 0.5,
    hovered_cursorline_bg_alter = 0.6,
    lsp_code_lens_bg_alter = 0.35,
    lsp_code_lens_fg_alter = 2,
    trouble_indent_fg_alter = 1.8,

    linenr_note_fg_alter = 0.5,
    nontext_note_fg_alter = 0.95,
    normal_note_bg_alter = 1.6,
  },
  ["rose-pine-moon"] = {
    hovered_cursorline_bg_alter = 0.6,
    trouble_indent_fg_alter = 1,
  },
  ["tokyonight"] = {
    dapstopped_bg_alter = 0.15,
    grugfar_result_linenr_fg_alter = 0.7,
    lsp_code_lens_bg_alter = 0.2,
    lsp_code_lens_fg_alter = 2,
    trouble_indent_fg_alter = 1.5,

    linenr_note_fg_alter = 0.5,
    normal_note_bg_alter = 1,
  },
  ["tokyonight-night"] = {
    dapstopped_bg_alter = 0.15,
    grugfar_result_linenr_fg_alter = 0.7,
    lsp_code_lens_bg_alter = 0.8,
    lsp_code_lens_fg_alter = 5,
    trouble_indent_fg_alter = 1.5,

    linenr_note_fg_alter = 0.6,
  },
  ["tokyonight-storm"] = {
    grugfar_result_linenr_bg_alter = -0.25,
    grugfar_result_linenr_fg_alter = 0.4,
    grugfar_result_number_fg_alter = 0.8,
    lsp_code_lens_bg_alter = 0.2,
    lsp_code_lens_fg_alter = 1.2,
    panel_bottom_normal_bg_alter = 0.05,
    trouble_indent_fg_alter = 0.75,

    floatborder_note_fg_alter = 0.2,
    fold_note_fg_alter = 0.05,
    linenr_note_fg_alter = 0.45,
    nontext_note_fg_alter = 0.45,
    normal_note_bg_alter = 0.8,
    normal_note_fg_alter = 0.3,
    urllink_note_bg_alter = 0.4,
    urllink_note_fg_alter = 0.1,
  },
  ["nightfox"] = {
    dapstopped_bg_alter = 0.15,
    grugfar_result_linenr_fg_alter = 0.55,
    lsp_code_lens_bg_alter = 0.5,
    lsp_code_lens_fg_alter = 4,
    trouble_indent_fg_alter = 2,

    fold_note_fg_alter = -0.1,
    linenr_note_fg_alter = 0.6,
    nontext_note_fg_alter = 0.5,
    normal_note_bg_alter = 2.5,
    normal_note_fg_alter = 0.2,
  },
  ["vscode"] = {
    Directory = { fg = "#569cd6", bg = "NONE" },
    dapstopped_bg_alter = 0.2,
    grugfar_result_linenr_fg_alter = 0.3,
    lsp_code_lens_bg_alter = 0.2,
    lsp_code_lens_fg_alter = 1.8,
    tmux_statusline_fg_alter = -0.25,
    trouble_indent_fg_alter = 1.5,

    linenr_note_fg_alter = 0.6,
    nontext_note_fg_alter = 0.5,
    normal_note_bg_alter = 1.25,
    normal_note_fg_alter = 0.3,
  },
  ["vscode_modern"] = {
    Directory = { fg = "#569cd6", bg = "NONE" },
    dapstopped_bg_alter = 0.2,
    hovered_cursorline_bg_alter = 0.35,
    lsp_code_lens_bg_alter = 0.3,
    lsp_code_lens_fg_alter = 2,
    trouble_indent_fg_alter = 1.2,
  },
  ["xenos"] = {
    lsp_code_lens_bg_alter = 0.2,
    lsp_code_lens_fg_alter = 1,
    trouble_indent_fg_alter = 0.6,
  },
  ["y9nika"] = {},
  ["zenburn"] = {
    grugfar_result_linenr_bg_alter = -0.2,
    grugfar_result_linenr_fg_alter = 0.5,
    grugfar_result_number_fg_alter = 0.65,
    hovered_cursorline_bg_alter = 0.1,
    lsp_code_lens_bg_alter = 0.2,
    lsp_code_lens_fg_alter = 1,
    trouble_indent_fg_alter = 0.5,

    linenr_note_fg_alter = 0.4,
    fold_note_fg_alter = 0.05,
    nontext_note_fg_alter = 0.4,
    normal_note_bg_alter = 0.3,
    floatborder_note_fg_alter = 0.15,
    urllink_note_bg_alter = 0.4,
    urllink_note_fg_alter = -0.1,
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
  local dark_orange = H.tint(UIPallette.palette.light_red, 0.3)

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
    { NonText = { fg = { from = "NonText", attr = "fg", alter = 0.5, opacity = 0.5 }, bg = "NONE" } },
    { WinSeparator = { fg = { from = "Normal", attr = "bg", alter = 0.5 }, bg = "NONE" } },

    {
      LineNr = {
        bg = "NONE",
        fg = { from = "Normal", attr = "bg", alter = 0.8 },
        bold = false,
      },
    },
    { LineNrAbove = { inherit = "LineNr" } },
    { LineNrBelow = { inherit = "LineNr" } },
    { Comment = { fg = { from = "Normal", attr = "bg", alter = 3, opacity = 0.6 }, italic = true } },
    { Type = { italic = true, bold = true } },
    { ["@comment"] = { inherit = "Comment" } },

    { CursorLine = { bg = { from = "Normal", attr = "bg" } } },
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

    { StatusLine = { bg = { from = "Normal", attr = "bg", alter = 0.2 } } },
    { StatusLine = { fg = { from = "StatusLine", attr = "bg", alter = 2.5 }, reverse = false } },
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
        bg = { from = "Normal", attr = "bg", alter = 0.55 },
        reverse = false,
      },
    },

    {
      FloatBorder = {
        fg = { from = "NormalFloat", attr = "bg", alter = 0.5 },
        bg = { from = "NormalFloat", attr = "bg" },
      },
    },
    { FloatTitle = { inherit = "FloatBorder", fg = { from = "FloatBorder", attr = "fg", alter = 2 } } },
    {
      FloatCursorline = {
        fg = "NONE",
        bg = { from = "NormalFloat", attr = "bg", alter = 0.2 },
      },
    },

    { TabLine = { bg = { from = "StatusLine", attr = "bg", alter = 0.5, opacity = 0.5 }, reverse = false } },
    { TabLine = { fg = { from = "TabLine", attr = "bg", alter = 1 } } },

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
        bg = { from = "CurSearch", attr = "bg", transparency = 0.8, color = { from = "Normal", attr = "bg" } },
        reverse = true,
      },
    },
    { IncSearch = { inherit = "CurSearch" } },
    { TermCursor = { inherit = "Cursor" } },
    { Substitute = { inherit = "Search" } },

    {
      Folded = {
        fg = { from = "LineNr", attr = "fg", alter = 0.2, opacity = 0.8 },
        bg = "NONE",
      },
    },

    -- Disable the Folded background using the `FoldedMarkdown` group.
    -- Check `windowdim.lua` for details.
    { FoldedMarkdown = { fg = { from = "Normal", attr = "bg" }, bg = "NONE" } },
    { FoldedSign = { inherit = "Folded", bg = "NONE" } },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                    SPELL                                    ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    { SpellBad = { undercurl = true, bg = "NONE", fg = "NONE", sp = "green" } },
    { SpellRare = { undercurl = true } },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                 DIFF COLOR                                  ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    {
      diffAdded = {
        fg = git_diff_add,
        bg = { from = "Normal", attr = "bg", transparency = 0.9, color = git_diff_add },
      },
    },

    {
      diffChanged = {
        fg = git_diff_change,
        bg = { from = "Normal", attr = "bg", transparency = 0.9, color = git_diff_change },
      },
    },
    {
      diffRemoved = {
        fg = git_diff_delete,
        bg = { from = "Normal", attr = "bg", transparency = 0.9, color = git_diff_delete },
      },
    },

    {
      diffLine = {
        fg = { from = "Type", attr = "fg" },
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
    { DiffChange = { link = "diffRemoved" } },
    { DiffDelete = { link = "diffRemoved" } },

    { DiffText = { link = "diffChanged" } },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                    ERROR                                    ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    { ErrorMsg = { bg = "NONE", fg = { from = "diffRemoved", attr = "fg", alter = 0.2 }, reverse = false } },
    { Error = { bg = "NONE", fg = { from = "diffRemoved", attr = "fg", alter = 0.2 }, reverse = false } },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                 DIAGNOSTICS                                 ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    { DiagnosticSignError = { bg = "NONE" } },
    { DiagnosticSignWarn = { bg = "NONE" } },
    { DiagnosticSignInfo = { bg = "NONE" } },
    { DiagnosticSignHint = { bg = "NONE" } },

    { DiagnosticError = { fg = { from = "DiagnosticSignError", attr = "fg" }, bg = "NONE", italic = true } },
    { DiagnosticsErrorNumHl = { fg = { from = "LineNr", attr = "fg" }, bg = "NONE" } },
    { DiagnosticWarn = { fg = { from = "DiagnosticSignWarn", attr = "fg" }, bg = "NONE", italic = true } },
    { DiagnosticsWarnNumHl = { fg = { from = "LineNr", attr = "fg" }, bg = "NONE" } },
    { DiagnosticHint = { fg = { from = "DiagnosticSignHint", attr = "fg" }, bg = "NONE", italic = true } },
    { DiagnosticsHintNumHl = { fg = { from = "LineNr", attr = "fg" }, bg = "NONE" } },
    { DiagnosticInfo = { fg = { from = "DiagnosticSignInfo", attr = "fg" }, bg = "NONE", italic = true } },
    { DiagnosticsInfoNumHl = { fg = { from = "LineNr", attr = "fg" }, bg = "NONE" } },

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
    { LspKindSnippet = { inherit = "@comment" } },
    { LspKindFile = { inherit = "Tag" } },
    { LspKindFolder = { inherit = "Directory" } },
    { LspKindUnit = { inherit = "@type" } },
    { LspKindEvent = { inherit = "Special" } },
    { LspKindReference = { inherit = "@markup.link" } },

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

    {
      LspCodeLens = {
        fg = { from = "Normal", attr = "bg", alter = colors.lsp_code_lens_fg_alter },
        bg = { from = "Normal", attr = "bg", alter = colors.lsp_code_lens_bg_alter },
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
        fg = { from = "Normal", attr = "fg", alter = colors.normal_float_fg_alter },
        bg = { from = "Keyword", attr = "fg", alter = -0.2 },
      },
    },
    {
      Zshlines = {
        fg = { from = "LineNr", attr = "fg", alter = -0.05 }, --> line
        bg = { from = "LineNr", attr = "fg", alter = 1 }, -- > foreground
      },
    },

    -- ├──────────────────────────────────┤ NOTE ├──────────────────────────────────┤
    {
      NormalNote = {
        fg = { from = "Normal", attr = "fg", alter = 0.3 },
        bg = { from = "Normal", attr = "bg", alter = 1 },
      },
    },
    { CommentNote = { fg = { from = "NormalNote", attr = "bg", alter = 1.5, opacity = 0.9, is_note = true } } },
    { NonTextNote = { fg = { from = "NormalNote", attr = "bg", alter = colors.nontext_note_fg_alter } } },
    {
      LineNrNote = {
        fg = { from = "NormalNote", attr = "bg", alter = 0.6 },
        bg = { from = "NormalNote", attr = "bg" },
      },
    },
    { DelimiterNote = { fg = { from = "NormalNote", attr = "bg", alter = colors.delimeter_note_fg_alter } } },
    { CursorLineNote = { bg = { from = "NormalNote", attr = "bg", alter = colors.cursorline_note_bg_alter } } },
    {
      CursorLineNrNote = {
        fg = { from = "Keyword", attr = "fg", alter = 0.5 },
        bg = { from = "CursorLineNote", attr = "bg", alter = colors.cursorlinenr_note_bg_alter },
        bold = true,
      },
    },
    { FoldedNote = { fg = { from = "LineNrNote", attr = "fg", alter = colors.fold_note_fg_alter } } },
    {
      FloatBorderNote = {
        fg = { from = "NormalNote", attr = "bg", alter = 0.5 },
        bg = { from = "NormalNote", attr = "bg" },
      },
    },
    {
      TitleFloatNote = {
        fg = { from = "FloatTitle", attr = "fg", alter = colors.floattitle_note_fg_alter },
        bg = { from = "NormalNote", attr = "bg" },
        bold = true,
      },
    },

    { VisualNote = { bg = { from = "Visual", attr = "bg", alter = colors.visual_note_bg_alter } } },
    { PmenuNote = { bg = { from = "NormalNote", attr = "bg" } } },
    {
      WinSeparatorNote = {
        fg = { from = "NormalNote", attr = "bg", alter = 0.15 },
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
    { CommentAiPrompt = { fg = { from = "NormalAiPrompt", attr = "bg", alter = 0.7, opacity = 0.8 } } },
    { NonTextAiPrompt = { fg = { from = "NormalAiPrompt", attr = "bg", alter = colors.nontext_note_fg_alter } } },
    {
      LineNrAiPrompt = {
        fg = { from = "NormalAiPrompt", attr = "bg", alter = colors.linenr_note_fg_alter },
        bg = { from = "NormalAiPrompt", attr = "bg" },
      },
    },
    { DelimiterAiPrompt = { fg = { from = "NormalAiPrompt", attr = "bg", alter = colors.delimeter_note_fg_alter } } },
    { CursorLineAiPrompt = { bg = { from = "NormalAiPrompt", attr = "bg", alter = colors.cursorline_note_bg_alter } } },
    {
      CursorLineNrAiPrompt = {
        fg = { from = "Keyword", attr = "fg", alter = 0.5 },
        bg = { from = "CursorLineAiPrompt", attr = "bg", alter = colors.cursorlinenr_note_bg_alter },
        bold = true,
      },
    },
    { FoldedAiPrompt = { fg = { from = "LineNrAiPrompt", attr = "fg", alter = colors.fold_note_fg_alter } } },
    {
      FloatBorderAiPrompt = {
        fg = { from = "NormalAiPrompt", attr = "bg", alter = 0.5 },
        bg = { from = "NormalAiPrompt", attr = "bg" },
      },
    },
    {
      TitleFloatAiPrompt = {
        fg = { from = "FloatTitle", attr = "fg", alter = colors.floattitle_note_fg_alter },
        bg = { from = "NormalAiPrompt", attr = "bg" },
        bold = true,
      },
    },

    { VisualAiPrompt = { bg = { from = "Visual", attr = "bg", alter = colors.visual_note_bg_alter } } },
    { PmenuAiPrompt = { bg = { from = "NormalNote", attr = "bg" } } },
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

    {
      HoveredCursorline = { bg = { from = "NormalKeyword", attr = "bg", alter = colors.hovered_cursorline_bg_alter } },
    },
    { InactiveBorderColorLazy = { fg = { from = "WinSeparator", attr = "fg", alter = 0.2 } } },

    { KeywordMatch = { fg = { from = "Function", attr = "fg", alter = 0.1, opacity = 0.4 } } },
    {
      KeywordMatchFuzzy = {
        fg = { from = "KeywordMatch", attr = "fg", alter = -0.1 },
      },
    },

    -- ├─────────────────────────────────┤ WINBAR ├─────────────────────────────────┤

    {
      WinBar = {
        fg = { from = "StatusLine", attr = "fg", opacity = 0.5 },
        bg = { from = "Normal", attr = "bg" },
        bold = true,
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
        bg = { from = "diffAdded", attr = "fg", opacity = 0.2 },
      },
    },
    {
      WinBarRed = {
        fg = { from = "diffRemoved", attr = "fg", alter = 0.1 },
        bg = { from = "diffRemoved", attr = "fg", opacity = 0.2 },
      },
    },
    {
      WinBarYellow = {
        fg = { from = "StatusLine", attr = "fg" },
        bg = { from = "StatusLine", attr = "bg" },
      },
    },
    {
      WinBarNote = {
        fg = { from = "NormalNote", attr = "bg", alter = 1 },
        bg = { from = "NormalNote", attr = "bg" },
      },
    },

    -- ├──────────────────────────────────┤ TMUX ├──────────────────────────────────┤
    {
      TmuxStatusline = {
        fg = { from = "WinBar", attr = "fg", alter = colors.tmux_statusline_fg_alter },
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
  return H.all {

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                    NOICE                                    ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    { NoiceCmdline = { fg = { from = "StatusLine", attr = "bg", alter = 5 }, bg = "NONE" } },

    -- Highlight :Messages noice
    { NoiceSplit = { bg = { from = "NormalKeyword", attr = "bg", alter = -0.6, opacity = 0.7 } } },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                    BLINK                                    ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    {
      BlinkDocNormal = {
        fg = { from = "Normal", attr = "fg" },
        bg = { from = "NormalFloat", attr = "bg" },
      },
    },
    {
      BlinkDocFloatBorder = {
        fg = { from = "NormalFloat", attr = "bg" },
        bg = { from = "NormalFloat", attr = "bg" },
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
    { BlinkCmpLabelKind = { fg = { from = "Pmenu", attr = "fg", alter = 0.01 } } },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                  GITSIGNS                                   ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    { GitSignsAdd = { inherit = "diffAdded", bg = "NONE" } },
    { GitSignsChange = { inherit = "diffChanged", bg = "NONE" } },
    { GitSignsDelete = { inherit = "diffRemoved", bg = "NONE" } },

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
        bg = { from = "FzfLuaNormal", attr = "bg" },
        reverse = false,
        bold = true,
      },
    },
    { FzfLuaBorder = { inherit = "FloatBorder", bg = { from = "FzfLuaNormal", attr = "bg" } } },
    {
      FzfLuaFilePart = {
        fg = { from = "Keyword", attr = "fg", opacity = 0.7 },
        bg = { from = "FzfLuaNormal", attr = "bg" },
      },
    },
    { FzfLuaDirPart = { inherit = "FzfLuaFilePart" } },
    {
      FzfLuaHeaderText = {
        fg = {
          from = "FzfLuaFilePart",
          attr = "fg",
          transparency = 0.7,
          color = { from = "type", attr = "fg" },
        },
      },
    },
    { FzfLuaFzfMatchFuzzy = { fg = { from = "BlinkCmpLabelMatch", attr = "fg", alter = 0.2 }, bg = "NONE" } },
    {
      FzfLuaFzfMatch = {
        fg = { from = "BlinkCmpLabelMatch" },
        bg = "NONE",
        bold = true,
      },
    },
    {
      FzfLuaSel = {
        fg = { from = "FzfLuaFilePart", attr = "fg", alter = 0.4 },
        bg = { from = "PmenuSel", attr = "bg" },
        bold = true,
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
    { FzfLuaScrollBorderFull = { inherit = "PmenuThumb" } },

    {
      FzfLuaCursorLine = {
        fg = "NONE",
        bg = { from = "FzfLuaBorder", attr = "fg", alter = 0.1 },
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
    { SnacksPickerPrompt = { bg = { from = "NormalFloat", attr = "bg" } } },
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

    { SnacksIndentScope = { fg = { from = "Keyword", attr = "fg", opacity = 0.3 }, bg = "NONE" } },

    -- ├────────────────────────────┤ SNACKS NOTIFIER ├─────────────────────────┤

    -- ╭──────╮
    -- │ INFO │
    -- ╰──────╯
    {
      SnacksNotifierInfo = {
        fg = { from = "Normal", attr = "bg", alter = 5 },
        bg = { from = "Normal", attr = "bg", alter = 0.5 },
      },
    },
    {
      SnacksNotifierBorderInfo = {
        fg = { from = "SnacksNotifierInfo", attr = "bg", alter = 0.4 },
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
        fg = { from = "SnacksNotifierWarn", attr = "bg", alter = 0.4 },
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
        fg = { from = "SnacksNotifierError", attr = "bg", alter = 0.4 },
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
        fg = { from = "heading1", attr = "fg", alter = 0.1 },
        bg = { from = "heading1", attr = "fg", opacity = 0.15, is_note = true },
        bold = true,
      },
    },
    {
      ["@markup.heading.1.markdown_ai"] = {
        fg = { from = "heading1", attr = "fg", alter = 0.1 },
        bg = { from = "heading1", attr = "fg", opacity = 0.15, is_aiprompt = true },
        bold = true,
      },
    },

    {
      ["@markup.heading.2.markdown"] = {
        fg = { from = "heading2", attr = "fg", alter = 0.1 },
        bg = { from = "heading2", attr = "fg", opacity = 0.15, is_note = true },
        bold = true,
      },
    },
    {
      ["@markup.heading.2.markdown_ai"] = {
        fg = { from = "heading2", attr = "fg", alter = 0.1 },
        bg = { from = "heading2", attr = "fg", opacity = 0.15, is_aiprompt = true },
        bold = true,
      },
    },

    {
      ["@markup.heading.3.markdown"] = {
        fg = { from = "heading3", attr = "fg", alter = 0.1 },
        bg = { from = "heading3", attr = "fg", opacity = 0.15, is_note = true },
        bold = true,
      },
    },
    {
      ["@markup.heading.3.markdown_ai"] = {
        fg = { from = "heading3", attr = "fg", alter = 0.1 },
        bg = { from = "heading3", attr = "fg", opacity = 0.15, is_aiprompt = true },
        bold = true,
      },
    },
    {
      ["@markup.heading.4.markdown"] = {
        fg = { from = "heading4", attr = "fg", alter = 0.1 },
        bg = { from = "heading4", attr = "fg", opacity = 0.15, is_note = true },
        bold = true,
      },
    },
    {
      ["@markup.heading.4.markdown_ai"] = {
        fg = { from = "heading4", attr = "fg", alter = 0.1 },
        bg = { from = "heading4", attr = "fg", opacity = 0.15, is_aiprompt = true },
        bold = true,
      },
    },
    {
      ["@markup.heading.5.markdown"] = {
        fg = { from = "heading5", attr = "fg", alter = 0.1 },
        bg = { from = "heading5", attr = "fg", opacity = 0.15, is_note = true },
        bold = true,
      },
    },
    {
      ["@markup.heading.5.markdown_ai"] = {
        fg = { from = "heading5", attr = "fg", alter = 0.1 },
        bg = { from = "heading5", attr = "fg", opacity = 0.15, is_aiprompt = true },
        bold = true,
      },
    },
    {
      ["@markup.heading.6.markdown"] = {
        fg = { from = "heading6", attr = "fg", alter = 0.1 },
        bg = { from = "heading6", attr = "fg", opacity = 0.15, is_note = true },
        bold = true,
      },
    },
    {
      ["@markup.heading.6.markdown_ai"] = {
        fg = { from = "heading6", attr = "fg", alter = 0.1 },
        bg = { from = "heading6", attr = "fg", opacity = 0.15, is_aiprompt = true },
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

    {
      ["@markup.link.label.markdown_inline"] = {
        -- fg = { from = "@markup.link", attr = "fg", alter = 0.5 },
        bg = "NONE",
      },
    },

    {
      ["@markup.quote.markdown"] = {
        fg = { from = "Keyword", attr = "fg", alter = 0.2, opacity = 0.3, is_note = true },
        bg = { from = "NormalNote", attr = "bg" },
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
        fg = { from = "@markup.quote.markdown", attr = "fg", alter = 0.5 },
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

    {
      RenderMarkdownCode = {
        bg = { from = "NormalNote", attr = "bg", alter = -0.25, is_note = true },
        italic = false,
      },
    },
    {
      RenderMarkdownCodeInline = {
        fg = { from = "String", attr = "fg", alter = 0.5 },
        bg = {
          from = "String",
          attr = "fg",
          transparency = 0.1,
          color = { from = "NormalNote", attr = "bg" },
        },
      },
    },

    { RenderMarkdownCodeBorder = { bg = { from = "RenderMarkdownCode", attr = "bg", alter = 0.05 } } },
    { RenderMarkdownCodeBorder = { fg = { from = "RenderMarkdownCodeBorder", attr = "bg", alter = 0.8 } } },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                   ORGMODE                                   ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    { ["@org.agenda.scheduled"] = { fg = { from = "String", attr = "fg", contrast = 0.2 } } },
    {
      ["@org.agenda.scheduled_past"] = {
        fg = { from = "String", attr = "fg", transparency = 0.5, color = { from = "diffChanged", attr = "fg" } },
      },
    },
    { ["@org.agenda.day"] = { fg = { from = "Directory", attr = "fg", alter = 0.1 } } },
    { ["@org.agenda.weekend"] = { fg = { from = "Directory", attr = "fg", alter = 0.4 } } },

    { ["@org.agenda.header"] = { fg = { from = "Comment", attr = "fg", alter = 0.5 } } },

    { ["Headline1"] = { inherit = "@markup.heading.1.markdown" } },
    { ["Headline2"] = { inherit = "@markup.heading.2.markdown" } },
    { ["Headline3"] = { inherit = "@markup.heading.3.markdown" } },
    { ["Headline4"] = { inherit = "@markup.heading.4.markdown" } },
    { ["Headline5"] = { inherit = "@markup.heading.5.markdown" } },
    { ["Headline6"] = { inherit = "@markup.heading.6.markdown" } },

    { ["@org.timestamp.active"] = { inherit = "PreProc" } },
    { ["@org.checkbox.halfchecked"] = { inherit = "PreProc" } },
    { ["@org.properties"] = { inherit = "Constant" } },
    { ["@org.drawer"] = { inherit = "Constant" } },
    {
      ["@org.plan.org"] = {
        inherit = "Constant",
        -- bg = { from = "Constant", attr = "fg", transparency = 0.1, color = { from = "NormalNote", attr = "bg" } },
      },
    },
    { ["@org.latex"] = { inherit = "Statement" } },
    -- { ["@org.hyperlink.org"] = { fg = { from = "Error", attr = "fg" } } },
    { ["@org.code"] = { inherit = "RenderMarkdownCodeInline" } },

    { ["@org.bold"] = { inherit = "@markup.strong.markdown_inline" } },
    { ["@org.italic"] = { inherit = "@markup.italic.markdown_inline" } },
    {
      ["@org.comment.org"] = {
        inherit = "@markup.italic.markdown_inline",
        bg = { from = "NormalNote", attr = "bg", alter = 0.2 },
      },
    },

    -- { ["@org.block"] = { inherit = "CommentNote" } },
    { ["@org.checkbox.org"] = { inherit = "ErrorMsg", fg = { from = "NormalNote", attr = "bg", alter = 2 } } },
    { ["@org.checkbox.checked"] = { inherit = "org.comment.org" } },
    { ["@org.directive"] = { fg = { from = "NormalNote", attr = "bg", alter = 1 } } },
    { ["@org.tag.org"] = { fg = { from = "@org.directive", attr = "fg", alter = 0.5 } } },
    { ["@org.timestamp.inactive"] = { fg = { from = "NormalNote", attr = "bg", alter = 0.8 } } },

    { OrgBulletDash = { inherit = "Special" } },
    { CodeBlock = { inherit = "RenderMarkdownCode", reverse = false } },
    { ["@org.block.org"] = { fg = { from = "RenderMarkdownCode", attr = "bg", alter = 0.5 } } },

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
        bg = { from = "LineNr", attr = "fg", alter = 0.6, opacity = 0.2 },
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
    -- ║                                  DIFFVIEW                                   ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    { DiffviewStatusAdded = { inherit = "diffAdded", bg = "NONE" } },
    { DiffviewStatusModified = { inherit = "diffChanged", bg = "NONE" } },
    { DiffviewStatusRenamed = { inherit = "String" } },
    { DiffviewStatusUnmerged = { inherit = "DiffChangedChar" } },
    { DiffviewStatusUntracked = { inherit = "diffAdded", bg = "NONE" } },
    { DiffviewStatusDeleted = { inherit = "diffRemoved", bg = "NONE" } },

    { DiffviewHash = { fg = { from = "diffAdded", attr = "fg" } } },
    { DiffviewNonText = { fg = { from = "WinSeparator", attr = "fg", alter = 0.1 } } },

    { DiffviewFilePanelCounter = { fg = { from = "Directory", attr = "fg", alter = -0.3 } } },
    { DiffviewFilePanelDeletions = { inherit = "DiffviewStatusDeleted" } },
    { DiffviewFilePanelInsertions = { inherit = "DiffviewStatusAdded" } },

    {
      DiffviewFilePanelPath = {
        inherit = "String",
        fg = { from = "String", attr = "fg", transparency = 0.7, color = { from = "Directory", attr = "fg" } },
      },
    },
    { DiffviewFilePanelFileName = { fg = { from = "DiffviewFilePanelPath", attr = "fg", alter = 0.2 } } },

    {
      DiffviewReference = {
        inherit = "diffRemoved",
        fg = { from = "diffRemoved", attr = "fg", alter = 0.1 },
        bold = true,
      },
    },

    {
      DiffviewFilePanelSelected = {
        inherit = "type",
        fg = { from = "type", attr = "fg", alter = 0.15 },
        bg = { from = "type", attr = "fg", opacity = 0.15 },
      },
    },

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
    -- {
    --   DapStopped = {
    --     bg = H.tint(H.darken(dark_yellow, 0.5, H.get("Normal", "bg")), -0.1),
    --     fg = "NONE",
    --   },
    -- },
    -- {
    --   DapStoppedIcon = {
    --     bg = H.tint(H.darken(dark_yellow, colors.dapstopped_bg_alter, H.get("Normal", "bg")), -0.1),
    --     fg = { from = "GitSignsChange", attr = "fg", alter = 0.6 },
    --   },
    -- },

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

    { NavicSeparator = { fg = { from = "Normal", attr = "bg", alter = 2.5, opacity = 0.5 } } },
    { LspInlayHint = { inherit = "LspInlayHint" } },
  }
end

local function set_panel_highlight()
  local H = require "r.settings.highlights"

  H.all {

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                   SIDEBAR                                   ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    {
      PanelSideNormal = {
        fg = { from = "Normal", attr = "fg" },
        bg = { from = "Normal", attr = "bg", alter = -0.15 },
      },
    },
    { PanelSideBackground = { link = "PanelSideNormal", fg = "NONE" } },
    { PanelSideDarkBackground = { bg = { from = "PanelSideNormal", attr = "bg", alter = -1 } } },

    { PanelSideDarkHeading = { inherit = "PanelSideDarkBackground", bold = true } },
    { PanelSideHeading = { inherit = "PanelSideBackground", bold = true } },

    { PanelSideRootName = { fg = { from = "WinBar", attr = "fg" } } },

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
    { PanelBottomCursorLineNr = { fg = { from = "PanelBottomNormal", attr = "bg", alter = 4.5 } } },

    { PanelBottomDarkBackground = { bg = { from = "PanelBottomBackground", attr = "bg", alter = -0.1 } } },
    { PanelBottomDarkHeading = { inherit = "PanelBottomDarkBackground", bold = true } },

    { PanelBottomLineNr = { fg = { from = "PanelBottomNormal", attr = "bg", alter = 3 } } },

    { PanelBottomSt = { bg = { from = "Visual", alter = -0.2 } } },
    { PanelBottomStusLine = { bg = { from = "PanelBottomBackground" }, fg = { from = "Normal", attr = "fg" } } },
    {
      PanelBottomWinSeparator = {
        fg = { from = "WinSeparator", attr = "fg" },
        bg = { from = "PanelBottomNormal", attr = "bg" },
      },
    },
    { PanelBottomStNC = { link = "PanelBottomWinSeparator" } },

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
        fg = { from = "Normal", attr = "bg", alter = 4 },
        bg = { from = "Normal", attr = "bg", alter = 0.5 },
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
      TroubleIndent = {
        fg = { from = "TroubleNormal", attr = "bg", alter = 1 },
        bg = "NONE",
      },
    },
    {
      TroubleIndentFoldClosed = {
        inherit = "TroubleIndent",
        fg = { from = "TroubleIndent", attr = "fg", alter = 0.2 },
      },
    },
    { TroubleIndentFoldOpen = { link = "TroubleIndentFoldClosed" } },

    -- ├───────────────────────────────┤ DIRECTORY ├────────────────────────────┤

    { TroubleDirectory = { bg = "NONE" } },
    { TroubleFsPos = { inherit = "TroubleIndent", fg = { from = "TroubleIndent", attr = "fg", alter = 0.2 } } },
    {
      TroubleFsCount = {
        fg = { from = "Directory", attr = "fg", alter = -0.13 },
        bg = { from = "Directory", attr = "fg", alter = -0.6 },
      },
    },

    -- ├──────────────────────────────────┤ LSP ├───────────────────────────────┤

    { TroubleLspFilename = { bg = "NONE" } },
    { TroubleLspPos = { link = "TroubleFsPos" } },
    { TroubleLspCount = { link = "TroubleFsCount" } },
    { TroubleLspItemClient = { link = "TroubleLspCount" } },

    -- ├──────────────────────────────┤ DIAGNOSTICS ├───────────────────────────┤

    { TroubleDiagnosticsBasename = { bg = "NONE" } },
    { TroubleDiagnosticsPos = { link = "TroubleFsPos" } },
    {
      TroubleDiagnosticsCount = {
        fg = { from = "DiagnosticWarn", attr = "fg", alter = -0.13 },
        bg = { from = "DiagnosticWarn", attr = "fg", alter = -0.6 },
      },
    },

    -- ├──────────────────────────────────┤ TODO ├──────────────────────────────────┤

    { TroubleTodoFilename = { bg = "NONE" } },
    { TroubleTodoPos = { link = "TroubleFsPos" } },
    { TroubleTodoCount = { link = "TroubleFsCount" } },

    -- ├────────────────────────────────┤ QUICKFIX ├────────────────────────────────┤

    {
      TroubleQfFilename = {
        bg = {
          from = "Directory",
          attr = "fg",
          transparency = 0.1,
          color = { from = "PanelBottomNormal", attr = "bg" },
        },
      },
    },
    { TroubleQfPos = { link = "TroubleFsPos" } },
    { TroubleQfCount = { link = "TroubleFsCount" } },

    { TroubleCode = { bg = "NONE", fg = { from = "Error", attr = "fg" }, underline = false } },

    -- ╓─────────────────────────────────────────────────────────────────────────────╖
    -- ║                                   OUTLINE                                   ║
    -- ╙─────────────────────────────────────────────────────────────────────────────╜

    {
      OutlineGuides = {
        fg = { from = "TroubleIndent", attr = "fg", alter = -0.1 },
        bg = "NONE",
      },
    },
    {
      OutlineCurrent = {
        fg = { from = "Error", attr = "fg", alter = 0.5 },
      },
    },
    {
      OutlineCurrent = {
        bg = {
          from = "OutlineCurrent",
          attr = "fg",
          transparency = 0.15,
          color = { from = "PanelBottomNormal", attr = "bg" },
        },
        reverse = false,
        bold = true,
        reverse = false,
      },
    },
    { OutlineFoldMarker = { fg = { from = "TroubleIndentFoldClosed", attr = "fg" }, bg = "NONE" } },

    { OutlineDetails = { fg = { from = "OutlineGuides", attr = "fg", alter = 0.1 }, bg = "NONE", italic = true } },
    { OutlineJumpHighlight = { bg = "red", fg = "NONE" } },
    { OutlineLineno = { bg = "NONE" } },
  }
end

local function colorscheme_overrides()
  local H = require "r.settings.highlights"
  local overrides = {
    -- ["base46-material-lighter"] = {
    --   { QuickFixLineNr = { fg = { from = "Normal", attr = "bg", alter = -0.4 } } },
    --   { qfSeparator1 = { fg = { from = "Normal", attr = "bg", alter = -0.2 } } },
    --   { qfSeparator2 = { link = "qfSeparator1" } },
    --   { Delimiter = { link = "qfSeparator1" } },
    -- },
    --
    -- ["gruvbox-material"] = {
    --   { ErrorMsg = { underline = false } },
    -- },
  }

  local hls = overrides[vim.g.colors_name]
  if hls then
    H.all(hls)
  end
end

---@return { filetype: string, buftype: string, is_float: boolean  }
local __get_win_opts = function(buf)
  local filetype, buftype = RUtils.buf.get_bo_buft(buf)
  local is_float = vim.api.nvim_win_get_config(0).relative ~= ""
  return {
    filetype = filetype,
    buftype = buftype,
    is_float = is_float,
  }
end

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
  "FloatTitle:TitleFloatNote",
  "CursorLine:CursorLineNote",
  "CursorLineNr:CursorLineNrNote",
  "Folded:FoldedNote",
  "@markup.list.markdown:@markup.list.markdown",
  "Comment:ErrorMsg",
  "@Comment:CommentNote",
  "Pmenu:PmenuNote",
  "Visual:VisualNote",
  "NonText:NonTextNote",
  "LineNr:LineNrNote",
  "WinSeparator:WinSeparatorNote",
  "Delimiter:DelimiterNote",
}, ",")

Win.filetype_winhighlights = {
  ["qf"] = true,
  ["Outline"] = true,
  ["trouble"] = true,

  --   "packer",
  --   "flutterToolsOutline",
  --   "undotree",
  --   "dbui",
  --   "neotest-summary",
  --   "pr",
  --
  --   "dapui_scopes",
  --   "dapui_stacks",
  --   "dapui_watches",
  --   "dapui_breakpoints",
  --   "dap-repl",
  -- }
}

Win.note_winhighlights = {
  ["org"] = true,
}

local set_winhighlights = function(filetype)
  if Win.filetype_winhighlights[filetype] then
    wo.winhighlight = winhighlight_bottom_panel
  end

  if Win.note_winhighlights[filetype] then
    wo.winhighlight = winhighlight_note_panel
  end
end

local function focus(ctx)
  ctx = ctx or {}
  local cur_winopts = __get_win_opts(ctx.buf and ctx.buf)
  local filetype = cur_winopts.filetype

  if filetype == "" or not Win.filetype_winhighlights[filetype] then
    wo.winhighlight = ""
  end

  -- if ctx.event then
  --   RUtils.info("buf: " .. ctx.buf .. " event: " .. ctx.event .. " filetype: " .. vim.bo[ctx.buf].filetype)
  -- end

  set_winhighlights(filetype)
end

local function blurred(ctx)
  ctx = ctx or {}
  local cur_winopts = __get_win_opts(ctx.buf and ctx.buf)
  local filetype = cur_winopts.filetype

  if filetype == "" or not Win.filetype_winhighlights[filetype] then
    wo.winhighlight = ""
  end

  set_winhighlights(filetype)
end

local function user_highlights()
  general_overrides()
  plugins_overrides()
  set_panel_highlight()
  colorscheme_overrides()
end

local function win_focus(ctx)
  focus(ctx)
end

local function win_blurred(ctx)
  blurred(ctx)
end

RUtils.map.augroup("UserHighlights", {
  event = "ColorScheme",
  command = function()
    user_highlights()
  end,
}, {
  event = { "BufRead" },
  pattern = "*",
  command = function(ctx)
    win_focus(ctx)
  end,
}, {
  event = { "BufEnter" },
  pattern = "*",
  command = function(ctx)
    win_focus(ctx)
  end,
}, {
  event = { "VimEnter", "FocusGained", "WinEnter" },
  pattern = "*",
  command = function(ctx)
    win_focus(ctx)
  end,
}, {
  event = { "WinLeave", "FocusLost", "BufLeave" },
  pattern = "*",
  command = function(ctx)
    win_blurred(ctx)
  end,
}, {
  event = { "VimResized" },
  pattern = "*",
  command = function()
    vim.cmd "wincmd ="
  end,
}, {
  event = { "FileType" },
  pattern = "qf",
  command = function()
    vim.fn.matchadd("Directory", [[^[^│]*]])
    vim.fn.matchadd("QuickFixMiddleLineNr", [[\v\d+:\d+\s]])
    vim.fn.matchadd("QuickFixWinDelimiter", [[│]])
  end,
})
