local UIPallette = require("r.utils").uisec

local Highlight = require "r.settings.highlights"

local dark_green = Highlight.tint(UIPallette.palette.green, 0.3)
local dark_yellow = Highlight.tint(UIPallette.palette.bright_yellow, 0.3)
local dark_red = Highlight.tint(UIPallette.palette.dark_red, 0.3)

local alter_medium_theme = { "lackluster", "oxocarbon", "carbonfox", "catppuccin-mocha", "darkforest" }
local alter_soft_theme = { "coffeecat", "iceclimber", "tokyonight-night" }

local alter_bright_theme = { "farout-night" }
local alter_brightnc_theme = { "dayfox" }
local alter_everforest_theme = { "everforest" }
local alter_tokyonightday_theme = { "tokyonight-day" }
local alter_ashenc_theme = { "ashen", "citruszest" }

local alter_special_theme = { "gruvbox-material", "horizon" }
local alter_specialnc_theme = { "kanagawa" }
local alter_sonokai_theme = { "" }
local alter_darkpmenu_theme = { "selenized", "nightfox", "tokyonight-storm", "vscode_modern" }

local pmenu_alter = 0.3
local pmenusel_alter = 0.3
local pmenuthumb_alter = 0.3
local fzfluasel_alter = 0.3
local quickfixline_alter = 0.3
local cursorline_alter = 0.08

if vim.tbl_contains(alter_special_theme, RUtils.config.colorscheme) then
  cursorline_alter = 0.07
  pmenu_alter = 0.3
  pmenusel_alter = 0.4
  pmenuthumb_alter = 0.4
  fzfluasel_alter = 0.2
  quickfixline_alter = 0.4
end

if vim.tbl_contains(alter_specialnc_theme, RUtils.config.colorscheme) then
  cursorline_alter = 0.1
  pmenu_alter = -0.2
  pmenusel_alter = -0.1
  pmenuthumb_alter = 0.4
  fzfluasel_alter = 0.2
  quickfixline_alter = 0.5
end

if vim.tbl_contains(alter_darkpmenu_theme, RUtils.config.colorscheme) then
  cursorline_alter = 0.1
  pmenu_alter = -0.05
  pmenusel_alter = 0.2
  pmenuthumb_alter = 0.15
  fzfluasel_alter = -0.05
  quickfixline_alter = 0.3
end

if vim.tbl_contains(alter_sonokai_theme, RUtils.config.colorscheme) then
  cursorline_alter = 0.04
  pmenu_alter = -0.2
  pmenusel_alter = 0.25
  pmenuthumb_alter = 0.15
  fzfluasel_alter = -0.05
  quickfixline_alter = 0.3
end

if vim.tbl_contains(alter_medium_theme, RUtils.config.colorscheme) then
  cursorline_alter = 0.08
  pmenu_alter = 0.6
  pmenusel_alter = 0.4
  pmenuthumb_alter = 0.3
  fzfluasel_alter = 0.3
  quickfixline_alter = 0.3
end

if vim.tbl_contains(alter_soft_theme, vim.g.colorscheme) then
  cursorline_alter = 0.05
  pmenu_alter = 0.3
  pmenusel_alter = 0.5
  pmenuthumb_alter = 0.5
  fzfluasel_alter = 0.5
  quickfixline_alter = 0.5
end

if vim.tbl_contains(alter_bright_theme, vim.g.colorscheme) then
  cursorline_alter = 0.13
  pmenu_alter = 1.8
  pmenusel_alter = 0.6
  pmenuthumb_alter = 0.6
  fzfluasel_alter = 0.5
  quickfixline_alter = 0.5
end

if vim.tbl_contains(alter_brightnc_theme, vim.g.colorscheme) then
  cursorline_alter = -0.02
  pmenu_alter = 1.8
  pmenusel_alter = 0.6
  pmenuthumb_alter = 0.6
  fzfluasel_alter = 0.5
  quickfixline_alter = 0.5
end

if vim.tbl_contains(alter_everforest_theme, vim.g.colorscheme) then
  cursorline_alter = 0.07
  pmenu_alter = 1.8
  pmenusel_alter = 0.6
  pmenuthumb_alter = 0.6
  fzfluasel_alter = 0.5
  quickfixline_alter = 0.5
end

if vim.tbl_contains(alter_tokyonightday_theme, vim.g.colorscheme) then
  cursorline_alter = 0.01
  pmenu_alter = 1.8
  pmenusel_alter = 0.6
  pmenuthumb_alter = 0.6
  fzfluasel_alter = 0.5
  quickfixline_alter = 0.5
end

if vim.tbl_contains(alter_ashenc_theme, vim.g.colorscheme) then
  cursorline_alter = 0.04
  pmenu_alter = 1
  pmenusel_alter = 0.8
  pmenuthumb_alter = 0.6
  fzfluasel_alter = 0.8
  quickfixline_alter = 0.5
end

local general_overrides = function()
  Highlight.all {
    -- ╔═════════════════════════════════════════════════════════╗
    -- ║                          BASE                           ║
    -- ╚═════════════════════════════════════════════════════════╝
    { FoldColumn = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 0.4 } } },
    { FoldColumn1 = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 1 } } },
    { ColorColumn = { bg = { from = "Normal", attr = "bg", alter = -0.1 } } },
    { LineNr = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 0.8 } } },
    {
      CursorLine = {
        bg = Highlight.darken(Highlight.get("Keyword", "fg"), cursorline_alter, Highlight.get("Normal", "bg")),
      },
    },
    {
      CursorLineNr = {
        fg = { from = "Normal", attr = "fg" },
        bg = { from = "CursorLine", attr = "bg" },
        bold = true,
      },
    },
    { Type = { italic = true, bold = true } },
    { Comment = { fg = { from = "Normal", attr = "fg", alter = -0.55 }, italic = true } },
    {
      Folded = {
        fg = { from = "Normal", attr = "bg", alter = 1.3 },
        bg = { from = "Normal", attr = "bg", alter = 0.25 },
      },
    },
    { EndOfBuffer = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 0.2 } } },
    { SignColumn = { bg = "NONE" } },
    { NonText = { fg = { from = "Normal", attr = "fg", alter = -0.4 } } },
    { WinSeparator = { fg = { from = "Normal", attr = "bg", alter = 0.6 }, bg = "NONE" } },

    { WinBar = { bg = { from = "ColorColumn" }, fg = { from = "Normal", attr = "bg", alter = 1 } } },
    { WinBarNC = { bg = { from = "ColorColumn", attr = "bg" }, fg = { from = "WinBar", attr = "fg" } } },

    {
      StatusLine = {
        fg = { from = "StatusLine", attr = "fg", alter = 0.1 },
        bg = { from = "StatusLine", attr = "bg" },
      },
    },
    {
      StatusLineNC = {
        fg = { from = "StatusLine", attr = "fg", alter = -0.2 },
        bg = { from = "StatusLine", attr = "bg", alter = 0.3 },
      },
    },

    {
      Tabline = {
        fg = { from = "WinSeparator", attr = "fg", alter = 1 },
        bg = { from = "StatusLine", attr = "bg", alter = 0.2 },
      },
    },
    {
      TablineSel = {
        fg = { from = "StatusLine", attr = "bg", alter = 2.5 },
        bg = { from = "StatusLine", attr = "bg", alter = 1 },
      },
    },
    {
      Pmenu = {
        fg = { from = "Normal", attr = "fg", alter = -0.1 },
        bg = { from = "Normal", attr = "bg", alter = pmenu_alter },
      },
    },
    {
      PmenuSel = {
        fg = "NONE",
        bg = { from = "CursorLine", attr = "bg", alter = pmenusel_alter },
        bold = true,
      },
    },
    { PmenuThumb = { bg = { from = "Pmenu", attr = "bg", alter = pmenuthumb_alter } } },
    { NormalFloat = { bg = { from = "Pmenu" } } },
    {
      FloatBorder = {
        fg = { from = "NormalFloat", attr = "bg", alter = 1 },
        bg = { from = "NormalFloat", attr = "bg" },
      },
    },

    -- ╒═════════════════════════════════════════════════════════╕
    -- │                           QF                            │
    -- ╘═════════════════════════════════════════════════════════╛
    { qfFileName = { fg = { from = "Directory", attr = "fg", alter = 0.3 }, bg = "NONE" } },
    { QuickFixFileName = { fg = { from = "Directory", attr = "fg" }, bg = "NONE" } },
    { QuickFixLine = { bg = { from = "CursorLine", attr = "bg", alter = quickfixline_alter }, underline = false } },

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
    { ["@punctuation.bracket"] = { fg = "yellow" } },

    { LspKindText = { link = "@markup" } },
    { LspKindBoolean = { link = "@boolean" } },
    { LspKindVariable = { link = "@variable" } },
    { LspKindConstant = { link = "@constant" } },
    { LspKindModule = { link = "@module" } },
    { LspKindPackage = { link = "@module" } },
    { LspKindKeyword = { link = "@lsp.type.keyword" } },
    { LspKindFunction = { link = "@function" } },
    -- { LspKindFunction = { link = "@lsp.typemod.function.declaration" } },
    { LspKindStruct = { link = "@lsp.type.struct" } },
    { LspKindArray = { link = "@punctuation.bracket" } },
    { LspKindOperator = { link = "@operator" } },
    { LspKindObject = { link = "@constant" } },
    { LspKindString = { link = "@string" } },
    { LspKindField = { link = "@variable.member" } },
    { LspKindNumber = { link = "@number" } },
    { LspKindProperty = { link = "@property" } },
    { LspKindReference = { link = "@markup.link" } },
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
        bg = { from = "LspReferenceText", attr = "bg" },
        fg = "NONE",
        underline = false,
        reverse = false,
        undercurl = false,
      },
    },
    {
      LspReferenceWrite = {
        bg = { from = "LspReferenceWrite", attr = "bg", alter = -0.2 },
        underline = false,
        reverse = false,
        undercurl = false,
      },
    },

    {
      LspReferenceRead = {
        bg = { from = "LspReferenceRead", attr = "bg", alter = -0.2 },
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
    { ["zshFunction"] = { fg = { from = "Identifier", attr = "fg" }, bold = true } },

    -- ──────────────────────────────── BASH ─────────────────────────────
    { ["@function.bash"] = { fg = { from = "Identifier", attr = "fg" }, bold = true } },
    { ["@function.call.bash"] = { fg = { from = "Identifier", attr = "fg" }, bold = true } },

    -- ──────────────────────────────── RUST ─────────────────────────────
    { ["@lsp.type.function.rust"] = { fg = { from = "Identifier", attr = "fg" }, bold = true } },

    -- ╔═════════════════════════════════════════════════════════╗
    -- ║                       DIFF COLOR                        ║
    -- ╚═════════════════════════════════════════════════════════╝
    -- These highlights are syntax groups that are set in diff.vim
    -- { GitSignsAdd = { bg = { from = "ColorColumn"} } },
    -- { diffBDiffer = { link = 'WarningMsg' } },
    -- { diffCommon = { link = 'WarningMsg' } },
    -- { diffDiffer = { link = 'WarningMsg' } },
    -- { diffFile = { link = 'Directory' } },
    -- { diffIdentical = { link = 'WarningMsg' } },
    -- { diffIndexLine = { link = 'Number' } },
    -- { diffIsA = { link = 'WarningMsg' } },
    -- { diffNoEOL = { link = 'WarningMsg' } },
    -- { diffOnly = { link = 'WarningMsg' } },

    { diffAdd = { bg = Highlight.darken(Highlight.get("Normal", "bg"), 0.8, dark_green), fg = "NONE", bold = true } },
    {
      diffChange = { bg = Highlight.darken(Highlight.get("Normal", "bg"), 0.8, dark_yellow), fg = "NONE", bold = true },
    },
    -- stylua: ignore
    { diffDelete = { bg = Highlight.darken(Highlight.get("Normal", "bg"), 0.7, dark_red), fg = Highlight.darken(dark_red, 0.2, Highlight.get("Normal", "bg")), bold = true, }, },
    {
      diffText = {
        bg = Highlight.darken(Highlight.get("Normal", "bg"), 0.6, dark_yellow),
        fg = "NONE",
        bold = true,
      },
    },

    { diffAdded = { inherit = "DiffAdd" } },
    { diffChanged = { inherit = "DiffChange" } },
    { diffRemoved = { inherit = "DiffDelete" } },

    { GitSignsAdd = { bg = "NONE", fg = dark_green } },
    { GitSignsChange = { bg = "NONE", fg = dark_yellow } },
    { GitSignsDelete = { bg = "NONE", fg = dark_red } },

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

    -- Floating windows
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
      DiagnosticError = {
        fg = { from = "DiagnosticSignError", attr = "fg" },
        bg = { from = "DiagnosticSignError", attr = "fg", alter = -0.7 },
        italic = true,
      },
    },
    {
      DiagnosticsErrorNumHl = {
        fg = { from = "DiagnosticError", attr = "fg" },
        bg = "NONE",
      },
    },
    {
      DiagnosticWarn = {
        fg = { from = "DiagnosticSignWarn", attr = "fg" },
        bg = { from = "DiagnosticSignWarn", attr = "fg", alter = -0.7 },
        italic = true,
      },
    },
    {
      DiagnosticsWarnNumHl = {
        fg = { from = "DiagnosticSignWarn", attr = "fg" },
        bg = "NONE",
      },
    },
    {
      DiagnosticHint = {
        fg = { from = "DiagnosticSignHint", attr = "fg" },
        bg = { from = "DiagnosticSignHint", attr = "fg", alter = -0.7 },
        italic = true,
      },
    },
    {
      DiagnosticsHintNumHl = {
        fg = { from = "DiagnosticHint", attr = "fg" },
        bg = "NONE",
      },
    },
    {
      DiagnosticInfo = {
        fg = { from = "DiagnosticSignInfo", attr = "fg" },
        bg = { from = "DiagnosticSignInfo", attr = "fg", alter = -0.7 },
        italic = true,
      },
    },
    {
      DiagnosticsInfoNumHl = {
        fg = { from = "DiagnosticInfo", attr = "fg" },
        bg = "NONE",
      },
    },

    { DiagnosticUnderlineWarn = { undercurl = true, sp = { from = "DiagnosticWarn", attr = "fg" } } },
    { DiagnosticUnderlineHint = { undercurl = true, sp = { from = "DiagnosticHint", attr = "fg" } } },
    { DiagnosticUnderlineError = { undercurl = true, sp = { from = "DiagnosticError", attr = "fg" } } },
    { DiagnosticUnderlineInfo = { undercurl = true, sp = { from = "DiagnosticInfo", attr = "fg" } } },

    -- ╒═════════════════════════════════════════════════════════╕
    -- │                   CREATED HIGHLIGHTS                    │
    -- ╘═════════════════════════════════════════════════════════╛
    { MyMark = { fg = { from = "DiagnosticSignWarn", attr = "fg", alter = 0.5 }, bold = true, italic = true } },
    {
      MyCodeUsage = {
        fg = { from = "Visual", attr = "bg", alter = 1 },
        bg = { from = "Visual", attr = "bg", alter = -0.15 },
        italic = true,
      },
    },
    {
      MyParentHint = {
        bg = { from = "CursorLine", attr = "bg" },
        fg = { from = "MyCodeUsage", attr = "fg", alter = -0.1 },
      },
    },
    { RenderMarkdownCode = { bg = { from = "Normal", alter = 0.3 } } },
    { CodeLine1 = { fg = { from = "ErrorMsg", attr = "fg" } } },
    {
      KeywordNC = {
        bg = Highlight.tint(Highlight.get("Keyword", "fg"), -0.5),
        fg = Highlight.tint(Highlight.get("Keyword", "fg"), -0.1),
      },
    },

    -- ╔═════════════════════════════════════════════════════════╗
    -- ║                      PLUGIN COLORS                      ║
    -- ╚═════════════════════════════════════════════════════════╝
    --  ──────────────────────────────── BLINK ───────────────────────────
    { BlinkCmpGhostText = { fg = { from = "LineNr", attr = "fg", alter = 0.3 } } },

    -- ───────────────────────────────── CMP ─────────────────────────────
    { CmpGhostText = { link = "@BlinkCmpGhostText" } },
    {
      CmpItemIconWarningMsg = {
        fg = { from = "WarningMsg", attr = "fg" },
        bg = { from = "NormalFloat", attr = "bg" },
      },
    },

    -- ╭─────────╮
    -- │ CMPITEM │
    -- ╰─────────╯
    { CmpItemAbbrDefault = { fg = { from = "CmpItemAbbr", attr = "fg" } } },
    {
      CmpItemFloatBorder = {
        fg = { from = "Pmenu", attr = "bg" },
        bg = { from = "Pmenu", attr = "bg" },
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
    { CmpItemAbbrMatchFuzzy = { fg = { from = "Boolean", attr = "fg" } } },
    { CmpItemAbbrMatch = { fg = { from = "Boolean", attr = "fg" } } },

    -- ╭────────╮
    -- │ CMPDOC │
    -- ╰────────╯
    {
      CmpDocNormal = {
        fg = { from = "Keyword", attr = "fg", alter = -0.15 },
        bg = { from = "Pmenu", attr = "bg" },
      },
    },
    {
      CmpDocFloatBorder = {
        fg = { from = "Pmenu", attr = "bg" },
        bg = { from = "Pmenu", attr = "bg" },
      },
    },

    -- ╭─────────╮
    -- │ CMPKIND │
    -- ╰─────────╯
    { CmpItemKindArray = { link = "LspKindArray" } },
    { CmpItemKindCopilot = { bg = "NONE", fg = "#118c74" } },
    { CmpItemKindDefault = { bg = "NONE", fg = "#6172b0" } },
    { CmpItemKindFunction = { link = "LspKindFunction" } },
    { CmpItemKindBoolean = { link = "LspKindBoolean" } },
    { CmpItemKindVariable = { link = "LspKindVariable" } },
    { CmpItemKindMethod = { link = "LspKindMethod" } },
    { CmpItemKindModule = { link = "LspKindModule" } },
    { CmpItemKindText = { link = "LspKindText" } },
    { CmpItemKindClass = { link = "LspKindClass" } },
    { CmpItemKindCodeium = { bg = "NONE", fg = "#118c74" } },
    { CmpItemKindColor = { link = "LspKindColor" } },
    { CmpItemKindConstant = { link = "LspKindConstant" } },
    { CmpItemKindStruct = { link = "LspKindStruct" } },
    { CmpItemKindSnippet = { link = "LspKindSnippet" } },
    { CmpItemKindString = { link = "LspKindString" } },
    { CmpItemKindNumber = { link = "LspKindNumber" } },
    { CmpItemKindPackage = { link = "LspKindPackage" } },
    { CmpItemKindObject = { link = "LspKindObject" } },
    { CmpItemKindNamespace = { link = "LspKindNamespace" } },
    { CmpItemKindEvent = { link = "LspKindEvent" } },
    { CmpItemKindField = { link = "LspKindField" } },
    { CmpItemKindFile = { link = "LspKindFile" } },
    { CmpItemKindFolder = { link = "LspKindFolder" } },
    { CmpItemKindInterface = { link = "LspKindInterface" } },
    { CmpItemKindUnit = { link = "LspKindUnit" } },
    { CmpItemKindKey = { link = "LspKindKey" } },
    { CmpItemKindKeyword = { link = "LspKindKeyword" } },
    { CmpItemKindNull = { link = "LspKindNull" } },
    { CmpItemKindOperator = { link = "LspKindOperator" } },
    { CmpItemKindProperty = { link = "LspKindProperty" } },
    { CmpItemKindReference = { link = "LspKindReference" } },
    { CmpItemKindValue = { link = "LspKindValue" } },
    { CmpItemKindEnum = { link = "LspKindEnum" } },
    { CmpItemKindEnumMember = { link = "LspKindEnumMember" } },
    { CmpItemKindConstructor = { link = "LspKindConstructor" } },
    { CmpItemKindTypeParameter = { link = "LspKindTypeParameter" } },
    { CmpItemKindTabNine = { bg = "NONE", fg = "#118c74" } },

    -- ─────────────────────────────── AERIALS ───────────────────────────
    { AerialGuide = { fg = { from = "Normal", attr = "bg", alter = 0.8 } } },
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

    -- ───────────────────────── TREESITTER CONTEXT ──────────────────────
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

    -- ───────────────────────────────── COC ─────────────────────────────
    { CocPumMenu = { link = "CmpItemAbbr" } },
    { CocMenuSel = { link = "PmenuSel" } },

    -- ─────────────────────────────── FZFLUA ────────────────────────────
    { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.5 } } },
    { FzfLuaFilePart = { fg = { from = "Keyword", attr = "fg", alter = -0.2 }, reverse = false } },
    { FzfLuaCursorLine = { bg = { from = "CursorLine", alter = 0.4, attr = "bg" } } },
    {
      FzfLuaSel = {
        fg = { from = "PmenuSel", attr = "bg", alter = 0.2 },
        bg = { from = "CursorLine", attr = "bg", alter = fzfluasel_alter },
      },
    },

    -- ╭─────────╮
    -- │ PRPOMPT │
    -- ╰─────────╯
    { FzfLuaNormal = { bg = { from = "NormalFloat", attr = "bg" } } },
    { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 0.6 } } },
    {
      FzfLuaBorder = {
        fg = { from = "NormalFloat", attr = "bg" },
        bg = { from = "NormalFloat", attr = "bg" },
      },
    },

    {
      FzfLuaTitle = {
        fg = { from = "Boolean", attr = "fg", alter = 0.2 },
        bg = { from = "NormalFloat", attr = "bg" },
      },
    },
    {
      FzfLuaTitleIcon = {
        fg = { from = "Boolean", attr = "fg", alter = 0.2 },
        bg = { from = "FzfLuaNormal", attr = "bg" },
      },
    },
    -- ╭─────────╮
    -- │ PREVIEW │
    -- ╰─────────╯
    { FzfLuaPreviewNormal = { bg = { from = "FzfLuaNormal", attr = "bg" } } },
    {
      FzfLuaPreviewBorder = {
        fg = { from = "FzfLuaNormal", attr = "bg" },
        bg = { from = "FzfLuaNormal", attr = "bg" },
      },
    },
    {
      FzfLuaPreviewTitle = {
        bg = { from = "Keyword", attr = "fg", alter = -0.1 },
        fg = { from = "Normal", attr = "bg" },
        bold = true,
      },
    },

    -- ────────────────────────────── TELESCOPE ──────────────────────────────
    { TelescopeNormal = { inherit = "FzfLuaNormal" } },
    { TelescopeBorder = { inherit = "FzfLuaBorder" } },
    { TelescopeMatching = { link = "CmpItemAbbrMatchFuzzy" } },
    { TelescopeTitle = { inherit = "FzfLuaTitle" } },

    {
      TelescopeSelection = {
        fg = { from = "FzfLuaSel", attr = "fg", alter = 0.8 },
        bg = { from = "FzfLuaSel", attr = "bg" },
      },
    },
    { TelescopeSelectionCaret = { bg = "NONE", fg = "green" } },

    -- ╭────────╮
    -- │ Prompt │
    -- ╰────────╯
    { TelescopePromptNormal = { inherit = "FzfLuaNormal" } },
    { TelescopePromptTitle = { inherit = "FzfLuaPreviewTitle" } },
    { TelescopePromptBorder = { inherit = "FzfLuaBorder" } },
    { TelescopePromptPrefix = { inherit = "FzfLuaBorder" } },
    { TelescopePromptCounter = { inherit = "FzfLuaBorder" } },

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
        fg = { from = "FzfLuaDirPart", attr = "fg" },
        bg = { from = "FzfLuaNormal", attr = "bg" },
      },
    },
    { TelescopeResultsTitle = { inherit = "FzfLuaPreviewTitle" } },
    { TelescopeResultsBorder = { inherit = "FzfLuaBorder" } },
    { MiniAnimateCursor = { fg = "red", bg = "red" } },

    -- ──────────────────────────────── NOICE ────────────────────────────────
    { NoicePopupBorder = { fg = { from = "FloatBorder" }, bg = "NONE" } },
    { NoiceCmdlinePopup = { bg = { from = "Pmenu" } } },
    { NoiceCmdlinePopupBorder = { fg = { from = "Pmenu", attr = "fg", alter = -0.7 } } },

    -- ─────────────────────────────── ORGMODE ───────────────────────────────
    { ["@org.agenda.scheduled"] = { fg = Highlight.darken("#3f9f31", 0.8, Highlight.get("Normal", "bg")) } },

    { ["@org.headline.level1.org"] = { fg = "#4d85c3", bold = true, italic = true } },
    { ["@org.headline.level2.org"] = { fg = "#389674", bold = true, italic = true } },
    { ["@org.headline.level3.org"] = { fg = "#b0be1e", bold = true, italic = true } },
    { ["@org.headline.level4.org"] = { fg = "#8594c8", bold = true, italic = true } },
    { ["@org.headline.level5.org"] = { fg = "#f76328", bold = true, italic = true } },
    { ["@org.headline.level6.org"] = { fg = "#fccf3e", bold = true, italic = true } },

    {
      ["@org.agenda.today"] = {
        fg = Highlight.darken("#fccf3e", 0.8, Highlight.get("Normal", "bg")),
        bold = true,
        italic = true,
      },
    },
    { ["@org.timestamp.active"] = { inherit = "PreProc" } },
    { ["@org.timestamp.inactive"] = { inherit = "Comment" } },
    { ["@org.bullet"] = { inherit = "Identifier" } },
    { ["@org.checkbox"] = { fg = "green" } },
    { ["@org.checkbox.halfchecked"] = { inherit = "PreProc" } },
    { ["@org.checkbox.checked"] = { inherit = "Comment" } },
    { ["@org.properties"] = { inherit = "Constant" } },
    { ["@org.drawer"] = { inherit = "Constant" } },
    { ["@org.tag"] = { inherit = "Function" } },
    { ["@org.plan"] = { inherit = "Constant" } },
    { ["@org.comment"] = { inherit = "Comment" } },
    { ["@org.directive"] = { inherit = "Comment" } },
    { ["@org.block"] = { inherit = "Comment" } },
    { ["@org.latex"] = { inherit = "Statement" } },
    { ["@org.hyperlinks"] = { inherit = "Underlined" } },
    { ["@org.code"] = { inherit = "String" } },

    { ["@markup.quote.markdown"] = { bg = { from = "Boolean", attr = "fg", alter = -0.8 }, italic = true } },

    -- ────────────────────────────── HLSEARCH ───────────────────────────
    {
      HlSearchLensNear = {
        bg = { from = "IncSearch", attr = "bg" },
        fg = { from = "IncSearch", attr = "bg", alter = -0.3 },
        bold = true,
      },
    },

    -- ───────────────────────────── BUFFERLINE ──────────────────────────
    { BufferLineIndicatorSelected = { bg = { from = "ColorColumn" } } },

    -- ───────────────────────────────── BQF ─────────────────────────────
    { BqfSign = { bg = { from = "ColorColumn", attr = "bg" }, { fg = { from = "Boolean" } } } },

    -- ─────────────────────────────── TROUBLE ───────────────────────────
    { TodoSignWarn = { bg = "NONE", fg = "#FBBF24" } },
    { TodoSignFIX = { bg = "NONE", fg = "#DC2626" } }, -- for error
    { TodoSignTODO = { bg = "NONE", fg = "#2563EB" } },

    -- ─────────────────────────────── GLANCE ────────────────────────────
    { GlancePreviewNormal = { bg = "#111231" } },
    { GlancePreviewMatch = { fg = "#012D36", bg = "#FDA50F" } },
    { GlanceListMatch = { fg = dark_red, bg = "NONE" } },
    { GlancePreviewCursorLine = { bg = "#1b1c4b" } },

    -- ────────────────────────────── MARKDOWN ───────────────────────────
    { ["@markup.quote.markdown"] = { italic = true } },
    { ["@markup.heading.1.markdown"] = { fg = "#4d85c3", bold = true, italic = true } },
    { ["@markup.heading.2.markdown"] = { fg = "#389674", bold = true, italic = true } },
    { ["@markup.heading.3.markdown"] = { fg = "#b0be1e", bold = true, italic = true } },
    { ["@markup.heading.4.markdown"] = { fg = "#8594c8", bold = true, italic = true } },
    { ["@markup.heading.5.markdown"] = { fg = "#f76328", bold = true, italic = true } },
    { ["@markup.heading.6.markdown"] = { fg = "#fccf3e", bold = true, italic = true } },
    {
      markdownItalic = {
        fg = { from = "@tag.attribute", attr = "fg", alter = 0.5 },
        italic = false,
        underline = false,
      },
    },
    {
      markdownBold = {
        fg = { from = "Boolean", attr = "fg", alter = 0.2 },
        bold = true,
      },
    },
    {
      ["@markup.strong.markdown_inline"] = {
        fg = { from = "Normal", attr = "fg", alter = 0.5 },
        bg = { from = "Normal", attr = "bg", alter = 0.2 },
        bold = true,
      },
    },
    {
      ["@markup.raw.markdown_inline"] = {
        bg = { from = "Normal", attr = "bg", alter = -0.4 },
        fg = { from = "ErrorMsg", attr = "fg" },
        reverse = false,
      },
    },

    -- ─────────────────────────────── RGFLOW ────────────────────────────
    {
      RgFlowHeadLine = {
        bg = Highlight.darken(dark_yellow, 0.1, Highlight.get("Normal", "bg")),
        fg = { from = "NormalFloat", attr = "bg" },
      },
    },
    {
      RgFlowHead = {
        bg = { from = "RgFlowHeadLine" },
        fg = { from = "Keyword", attr = "fg" },
      },
    },
    {
      RgFlowInputBg = {
        bg = { from = "RgFlowHeadLine" },
      },
    },
    {
      RgFlowInputFlags = {
        bg = "NONE",
      },
    },

    -- ───────────────────────────── VIM.MATCHUP ─────────────────────────────
    { MatchParen = { bg = { from = "Normal", attr = "bg", alter = -1 }, fg = "white", bold = false } },

    -- ──────────────────────────────── VGIT ─────────────────────────────────
    { VGitLineNr = { bg = "NONE", fg = { from = "LineNr", attr = "fg", alter = 1 } } },
    { VGitComment = { bg = "NONE", fg = { from = "Comment", attr = "fg", alter = 0.5 } } },

    -- ─────────────────────────────── LAZYVIM ───────────────────────────────
    { LazyNormal = { inherit = "NormalFloat" } },

    -- ──────────────────────────── SNACKS INDENT ────────────────────────────
    { SnacksIndent = { fg = { from = "Normal", attr = "bg", alter = 0.5 } } },
    {
      SnacksIndentScope = {
        fg = Highlight.darken(Highlight.get("Special", "fg"), 0.4, Highlight.get("Normal", "bg")),
      },
    },

    --  ────────────────────────────── DEBUG:DAP ─────────────────────────────
    { DapBreakpoint = { fg = { from = "Error", attr = "fg" }, bg = "NONE" } },
    { DapStopped = { bg = { from = "GitSignsChange", attr = "fg", alter = -0.6 }, fg = "NONE" } },
    {
      DapStoppedIcon = {
        bg = { from = "GitSignsChange", attr = "fg", alter = -0.6 },
        fg = { from = "GitSignsChange", attr = "fg", alter = 0.6 },
      },
    },
    -- { DapStoppedMod = { bg = yellowlow, fg = yellowhi } },
    -- { DapUiPlayPause = { bg = RUtils.colortbl.statusline_bg } },
    -- { DapUiStop = { bg = RUtils.colortbl.statusline_bg } },
    -- { DapUiRestart = { bg = RUtils.colortbl.statusline_bg } },

    --  ─────────────────────────────── LAZYGIT ───────────────────────────────
    { LazygitselectedLineBgColor = { bg = { from = "CursorLine", attr = "bg", alter = 0.5 } } },
    { LazygitInactiveBorderColor = { fg = { from = "WinSeparator", attr = "fg", alter = 0.7 }, bg = "NONE" } },
  }
end

local function set_sidebar_highlight()
  Highlight.all {
    { PanelDarkBackground = { bg = { from = "Normal", alter = -0.05 } } },
    { PanelDarkHeading = { inherit = "PanelDarkBackground", bold = true } },
    { PanelBackground = { bg = { from = "Normal", alter = -0.05 } } },
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
    ["horizon"] = {
      { Directory = { fg = { from = "@annotation", attr = "fg", alter = 0.2 }, bg = "NONE" } },

      { qfFileName = { fg = { from = "Directory", attr = "fg", alter = 0.3 }, bg = "NONE" } },
      { QuickFixFileName = { fg = { from = "Directory", attr = "fg" }, bg = "NONE" } },
      {
        QuickFixLine = {
          bg = { from = "CursorLine", attr = "bg", alter = -0.05 },
          fg = "NONE",
          underline = false,
        },
      },

      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.55 } } },

      {
        Comment = {
          fg = { from = "Normal", attr = "bg", alter = 1 },
          bg = "NONE",
          italic = true,
          reverse = false,
        },
      },
      {
        StatusLine = {
          fg = { from = "Normal", attr = "bg", alter = 4 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.25 },
        },
      },
      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "fg", alter = -0.15 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.35 },
        },
      },

      {
        Tabline = {
          fg = { from = "StatusLine", attr = "bg", alter = 1.2 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.25 },
        },
      },

      {
        TablineSel = {
          fg = { from = "StatusLine", attr = "fg", alter = 0.1 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.8 },
        },
      },
    },
    ["gruvbox-material"] = {
      { Directory = { fg = { from = "Identifier", attr = "fg" }, bg = "NONE" } },

      { qfFileName = { fg = { from = "Directory", attr = "fg", alter = 0.3 }, bg = "NONE" } },
      { QuickFixFileName = { fg = { from = "Directory", attr = "fg" }, bg = "NONE" } },
      {
        QuickFixLine = {
          bg = { from = "CursorLine", attr = "bg", alter = -0.05 },
          fg = "NONE",
          underline = false,
        },
      },

      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.4 } } },

      {
        Comment = {
          fg = { from = "Normal", attr = "bg", alter = 1 },
          bg = "NONE",
          italic = true,
          reverse = false,
        },
      },
      { SnacksIndent = { fg = { from = "Normal", attr = "bg", alter = 0.3 } } },
      {
        Folded = {
          fg = { from = "Normal", attr = "bg", alter = 1 },
          bg = { from = "Normal", attr = "bg", alter = 0.3 },
        },
      },

      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = -0.1 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "bg", alter = 2.3 },
          bg = { from = "StatusLine", attr = "bg", alter = -0.04 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "fg", alter = -0.05 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.4 },
        },
      },

      {
        Tabline = {
          fg = { from = "WinSeparator", attr = "fg", alter = 0.5 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.2 },
        },
      },

      {
        TablineSel = {
          fg = { from = "StatusLine", attr = "fg", alter = 0.1 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.8 },
        },
      },
    },
    ["kanagawa"] = {
      { Directory = { fg = { from = "Type", attr = "fg" }, bg = "NONE" } },

      { qfFileName = { fg = { from = "Directory", attr = "fg", alter = 0.3 }, bg = "NONE" } },
      { QuickFixFileName = { fg = { from = "Directory", attr = "fg" }, bg = "NONE" } },
      {
        QuickFixLine = {
          bg = { from = "CursorLine", attr = "bg", alter = -0.05 },
          fg = "NONE",
          underline = false,
        },
      },

      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.5 } } },
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = -0.08 } } },

      {
        Folded = {
          fg = { from = "Normal", attr = "bg", alter = 1 },
          bg = { from = "Normal", attr = "bg", alter = 0.5 },
        },
      },
      {
        StatusLine = {
          fg = { from = "Normal", attr = "bg", alter = 4 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.6 },
        },
      },
      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "bg", alter = 2.5 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.5 },
        },
      },

      {
        Tabline = {
          fg = { from = "WinSeparator", attr = "fg", alter = 0.6 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.35 },
        },
      },
      {
        TablineSel = {
          fg = { from = "WinSeparator", attr = "fg", alter = 3 },
          bg = { from = "StatusLine", attr = "bg", alter = 1.5 },
        },
      },
    },
    ["lackluster"] = {
      { Directory = { fg = "#BD93F9", bg = "NONE" } },

      { qfFileName = { fg = { from = "Directory", attr = "fg", alter = 0.3 }, bg = "NONE" } },
      { QuickFixFileName = { fg = { from = "Directory", attr = "fg" }, bg = "NONE" } },
      {
        QuickFixLine = {
          bg = { from = "CursorLine", attr = "bg", alter = 0.35 },
          fg = "NONE",
          underline = false,
        },
      },

      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.65 } } },

      { WinSeparator = { fg = { from = "LineNr", attr = "fg", alter = 0.1 }, bg = "NONE" } },
      {
        Keyword = {
          fg = { from = "Keyword", attr = "fg", alter = 0.8 },
          bg = "NONE",
        },
      },

      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = 0.4 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      { Visual = { bg = { from = "@Boolean", attr = "fg", alter = -0.5 } } },

      {
        MyCodeUsage = {
          fg = { from = "LineNr", attr = "fg", alter = 1 },
          bg = { from = "Visual", attr = "bg", alter = 2 },
          italic = true,
        },
      },

      { AerialGuide = { fg = { from = "Normal", attr = "bg", alter = 1 } } },

      {
        Folded = {
          fg = { from = "Normal", attr = "bg", alter = 1.5 },
          bg = { from = "Normal", attr = "bg", alter = 0.7 },
        },
      },

      {
        LspReferenceText = {
          bg = { from = "Normal", attr = "bg", alter = 1.2 },
          fg = "NONE",
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },
      {
        LspReferenceWrite = {
          bg = { from = "Normal", attr = "bg", alter = 2 },
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },

      {
        LspReferenceRead = {
          bg = { from = "Normal", attr = "bg", alter = 2 },
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },

      {
        StatusLine = {
          fg = { from = "Normal", attr = "bg", alter = 7.5 },
          bg = { from = "StatusLine", attr = "bg", alter = -0.3 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "WinSeparator", attr = "fg", alter = 2.2 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.5 },
        },
      },

      {
        Tabline = {
          fg = { from = "WinSeparator", attr = "fg", alter = 0.7 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.03 },
        },
      },

      {
        TablineSel = {
          bg = { from = "StatusLine", attr = "bg", alter = 0.8 },
          fg = { from = "StatusLine", attr = "fg", alter = 0.1 },
        },
      },
    },
    ["everforest"] = {
      { Directory = { fg = { from = "Identifier", attr = "fg" }, bg = "NONE" } },

      { qfFileName = { fg = { from = "Directory", attr = "fg", alter = 0.3 }, bg = "NONE" } },
      { QuickFixFileName = { fg = { from = "Directory", attr = "fg" }, bg = "NONE" } },
      {
        QuickFixLine = {
          bg = { from = "CursorLine", attr = "bg", alter = -0.05 },
          fg = "NONE",
          underline = false,
        },
      },

      { SnacksIndent = { fg = { from = "Normal", attr = "bg", alter = -0.05 } } },

      {
        ["@org.agenda.today"] = {
          fg = Highlight.darken("#fccf3e", 0.5, Highlight.get("Keyword", "fg")),
          bold = true,
          italic = true,
        },
      },

      { ["@punctuation.bracket"] = { fg = { from = "GitSignsChange", attr = "fg", alter = -0.2 } } },
      { ["@markup.quote.markdown"] = { bg = { from = "GitSignsChange", attr = "fg", alter = 1.5 } } },

      { Comment = { fg = { from = "Normal", attr = "bg", alter = -0.2 }, italic = true } },

      { Visual = { bg = { from = "Visual", attr = "bg", alter = -0.1 } } },
      {
        Folded = {
          fg = { from = "Normal", attr = "bg", alter = -0.2 },
          bg = { from = "Normal", attr = "bg", alter = -0.06 },
        },
      },
      { LineNr = { fg = { from = "Normal", attr = "bg", alter = -0.2 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },
      { BlinkCmpGhostText = { fg = { from = "LineNr", attr = "fg", alter = -0.05 } } },

      { WinSeparator = { fg = { from = "LineNr", attr = "fg", alter = 0.1 }, bg = "NONE" } },
      { TreesitterContextSeparator = { fg = { from = "WinSeparator", attr = "fg", alter = -0.1 } } },
      {
        TreesitterContextSeparator = {
          fg = { from = "WinSeparator", attr = "fg", alter = 0.05 },
          bg = { from = "ColorColumn", attr = "bg" },
        },
      },

      {
        CmpItemAbbr = {
          fg = { from = "Keyword", attr = "fg", alter = -0.3 },
          bg = "NONE",
        },
      },
      {
        Pmenu = {
          fg = { from = "Normal", attr = "fg", alter = -0.1 },
          bg = { from = "Normal", attr = "bg", alter = -0.1 },
        },
      },
      {
        PmenuSel = {
          bg = { from = "CursorLine", attr = "bg", alter = 0.02 },
          bold = true,
          reverse = false,
        },
      },
      {
        PmenuThumb = {
          bg = { from = "Pmenu", attr = "bg", alter = -0.1 },
        },
      },

      { NormalFloat = { bg = { from = "Pmenu", attr = "bg" } } },
      {
        FloatBorder = {
          fg = { from = "NormalFloat", attr = "bg" },
          bg = { from = "NormalFloat", attr = "bg" },
        },
      },

      --  ───────────────────────────────── CMP ─────────────────────────────────
      {
        CmpItemIconWarningMsg = {
          fg = { from = "WarningMsg", attr = "fg" },
          bg = { from = "Pmenu", attr = "bg" },
        },
      },
      {
        CmpItemFloatBorder = {
          fg = { from = "Pmenu", attr = "bg" },
          bg = { from = "Pmenu", attr = "bg" },
        },
      },
      {
        CmpDocNormal = {
          fg = { from = "Keyword", attr = "fg", alter = -0.15 },
          bg = { from = "Pmenu", attr = "bg" },
        },
      },
      {
        CmpDocFloatBorder = {
          fg = { from = "Pmenu", attr = "bg" },
          bg = { from = "Pmenu", attr = "bg" },
        },
      },

      --  ─────────────────────────────── FZFLUA ────────────────────────────────
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = -0.05 } } },
      { FzfLuaNormal = { bg = { from = "NormalFloat", attr = "bg" } } },

      {
        FzfLuaBorder = {
          fg = { from = "FloatBorder", attr = "fg" },
          bg = { from = "NormalFloat", attr = "bg" },
        },
      },
      {
        FzfLuaTitle = {
          fg = { from = "Keyword", attr = "fg", alter = 0.2 },
          bg = { from = "NormalFloat", attr = "bg" },
        },
      },

      {
        FzfLuaSel = {
          fg = { from = "PmenuSel", attr = "bg", alter = 0.3 },
          bg = { from = "PmenuSel", attr = "bg" },
        },
      },

      { FzfLuaCursorLine = { bg = { from = "CursorLine", attr = "bg", alter = 0.04 } } },

      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = 0.2 } } },
      { FzfLuaFilePart = { fg = { from = "Keyword", attr = "fg" }, reverse = false } },

      { FzfLuaPreviewNormal = { bg = { from = "FzfLuaNormal", attr = "bg" } } },
      {
        FzfLuaPreviewBorder = {
          fg = { from = "FzfLuaBorder", attr = "fg" },
          bg = { from = "FzfluaBorder", attr = "bg" },
        },
      },

      --  ────────────────────────────── TELESCOPE ──────────────────────────────
      { TelescopeNormal = { inherit = "FzfLuaNormal" } },
      { TelescopeBorder = { inherit = "FzfLuaBorder" } },
      { TelescopeTitle = { inherit = "FzfLuaTitle" } },
      {
        TelescopeSelection = {
          bg = { from = "FzfLuaSel", attr = "bg" },
          fg = { from = "FzfLuaSel", attr = "fg", alter = -0.35 },
        },
      },
      -- prompt
      { TelescopePromptNormal = { inherit = "FzfLuaNormal" } },
      { TelescopePromptTitle = { inherit = "FzfLuaPreviewTitle" } },
      { TelescopePromptBorder = { inherit = "FzfLuaBorder" } },
      { TelescopePromptPrefix = { inherit = "FzfLuaBorder" } },
      { TelescopePromptCounter = { inherit = "FzfLuaBorder" } },
      -- Preview
      { TelescopePreviewNormal = { inherit = "FzfLuaNormal" } },
      { TelescopePreviewTitle = { inherit = "FzfLuaPreviewTitle" } },
      { TelescopePreviewBorder = { inherit = "FzfLuaBorder" } },
      -- Results
      {
        TelescopeResultsNormal = {
          fg = { from = "FzfLuaDirPart", attr = "fg" },
          bg = { from = "FzfLuaNormal", attr = "bg" },
        },
      },
      { TelescopeResultsTitle = { inherit = "FzfLuaPreviewTitle" } },
      { TelescopeResultsBorder = { inherit = "FzfLuaBorder" } },

      --  ──────────────────────────────── MISC ─────────────────────────────
      {
        StatusLine = {
          fg = { from = "Normal", attr = "bg", alter = -0.6 },
          bg = { from = "StatusLine", attr = "bg", alter = -0.5 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "fg", alter = 0.4 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.65 },
        },
      },

      {
        Tabline = {
          fg = { from = "WinSeparator", attr = "fg", alter = -0.2 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.95 },
        },
      },

      {
        TablineSel = {
          fg = { from = "StatusLine", attr = "fg", alter = 0.1 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.5 },
        },
      },
    },
    ["evangelion"] = {
      { Directory = { fg = { from = "Identifier", attr = "fg", alter = 0.1 }, bg = "NONE" } },

      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.5 } } },
      { qfFileName = { fg = { from = "Directory", attr = "fg", alter = 0.3 }, bg = "NONE" } },
      { QuickFixFileName = { fg = { from = "Directory", attr = "fg" }, bg = "NONE" } },
      {
        QuickFixLine = {
          fg = { from = "qfFileName", attr = "bg" },
          underline = false,
        },
      },

      { Comment = { fg = { from = "Normal", attr = "bg", alter = 1.7 }, bg = "NONE", italic = true, reverse = false } },
      { ["@lsp.type.comment"] = { inherit = "Comment" } },

      { Visual = { bg = { from = "Visual", attr = "bg", alter = 0.4 } } },

      { BlinkCmpGhostText = { fg = { from = "LineNr", attr = "fg", alter = 0.4 } } },

      {
        LspReferenceText = {
          bg = { from = "LspReferenceText", attr = "bg", alter = -0.4 },
          fg = "NONE",
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },
      {
        LspReferenceWrite = {
          bg = { from = "LspReferenceWrite", attr = "bg", alter = -0.2 },
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },

      {
        LspReferenceRead = {
          bg = { from = "LspReferenceRead", attr = "bg", alter = -0.2 },
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },

      {
        MyCodeUsage = {
          fg = { from = "Directory", attr = "fg", alter = 0.5 },
          bg = { from = "Visual", attr = "bg", alter = -0.8 },
          italic = true,
        },
      },

      {
        StatusLine = {
          fg = { from = "Normal", attr = "bg", alter = 4 },
          bg = { from = "Normal", attr = "bg", alter = 0.4 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "fg", alter = -0.3 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.2 },
        },
      },

      {
        Tabline = {
          fg = { from = "StatusLine", attr = "bg", alter = 1 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.1 },
        },
      },

      {
        TablineSel = {
          fg = { from = "StatusLine", attr = "fg", alter = -0.2 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.2 },
        },
      },
    },
    ["oxocarbon"] = {
      { Directory = { fg = "#78a9ff", bg = "NONE" } },

      { qfFileName = { fg = { from = "Directory", attr = "fg", alter = 0.3 }, bg = "NONE" } },
      { QuickFixFileName = { fg = { from = "Directory", attr = "fg" }, bg = "NONE" } },
      {
        QuickFixLine = {
          bg = { from = "CursorLine", attr = "bg", alter = 0.35 },
          fg = "NONE",
          underline = false,
        },
      },

      { BlinkCmpGhostText = { fg = { from = "LineNr", attr = "fg", alter = 0.5 } } },
      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.5 } } },

      {
        Folded = {
          fg = { from = "Normal", attr = "bg", alter = 1.5 },
          bg = { from = "Normal", attr = "bg", alter = 0.6 },
        },
      },
      {
        LspReferenceText = {
          bg = { from = "Normal", attr = "bg", alter = 0.2 },
          fg = "NONE",
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },
      {
        LspReferenceWrite = {
          bg = { from = "Normal", attr = "bg", alter = 0.8 },
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },
      {
        LspReferenceRead = {
          bg = { from = "Normal", attr = "bg", alter = 0.8 },
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },
      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "fg", alter = -0.3 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.5 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "fg", alter = -0.2 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.5 },
        },
      },

      {
        Tabline = {
          fg = { from = "StatusLine", attr = "bg", alter = 1.3 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.1 },
        },
      },

      {
        TablineSel = {
          fg = { from = "StatusLine", attr = "fg", alter = -0.2 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.2 },
        },
      },
    },
    ["farout"] = {
      { Comment = { fg = { from = "Normal", attr = "bg", alter = 3.5 }, bg = "NONE", italic = true, reverse = false } },
      { SnacksIndent = { fg = { from = "Normal", attr = "bg", alter = 1.5 } } },
      { qfFileName = { fg = { from = "qfFileName", attr = "fg", alter = 0.3 } } },

      { WinSeparator = { fg = { from = "LineNr", attr = "fg", alter = 0.6 }, bg = "NONE" } },

      {
        Folded = {
          fg = { from = "Normal", attr = "bg", alter = 3.5 },
          bg = { from = "Normal", attr = "bg", alter = 1.7 },
        },
      },

      {
        MyCodeUsage = {
          fg = { from = "Normal", attr = "bg", alter = 3 },
          bg = { from = "Visual", attr = "bg", alter = 2 },
          italic = true,
        },
      },
      {
        FoldColumn = {
          bg = "NONE",
          fg = { from = "Normal", attr = "bg", alter = 1.5 },
        },
      },

      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = 1.4 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      { BlinkCmpGhostText = { fg = { from = "LineNr", attr = "fg", alter = 0.7 } } },
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 0.6 } } },

      {
        MyParentHint = {
          bg = { from = "CursorLine", attr = "bg" },
          fg = { from = "MyCodeUsage", attr = "fg", alter = 0.7 },
        },
      },

      {
        LspReferenceText = {
          bg = { from = "Normal", attr = "bg", alter = 1.2 },
          fg = "NONE",
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },
      {
        LspReferenceWrite = {
          bg = { from = "Normal", attr = "bg", alter = 2 },
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },

      {
        LspReferenceRead = {
          bg = { from = "Normal", attr = "bg", alter = 2 },
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },

      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "bg", alter = 4.5 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.2 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "fg", alter = -0.05 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.4 },
        },
      },

      {
        Tabline = {
          fg = { from = "WinSeparator", attr = "fg", alter = 0.8 },
          bg = { from = "StatusLine", attr = "bg", alter = -0.05 },
        },
      },

      {
        TablineSel = {
          fg = { from = "StatusLine", attr = "fg", alter = 0.1 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.8 },
        },
      },
    },
    ["selenized"] = {
      { Directory = { fg = "#4695f7", bg = "NONE" } },

      { qfFileName = { fg = { from = "Directory", attr = "fg", alter = 0.3 }, bg = "NONE" } },
      { QuickFixFileName = { fg = { from = "Directory", attr = "fg" }, bg = "NONE" } },
      {
        QuickFixLine = {
          bg = { from = "CursorLine", attr = "bg", alter = 0.35 },
          fg = "NONE",
          underline = false,
        },
      },

      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.3 } } },

      { SnacksIndent = { fg = { from = "Normal", attr = "bg", alter = 0.3 } } },
      { Comment = { fg = { from = "Normal", attr = "bg", alter = 1 }, italic = true } },
      { Visual = { bg = { from = "Visual", attr = "bg", alter = 0.3 } } },

      {
        ["@org.agenda.today"] = {
          fg = Highlight.darken("#00ff00", 0.9, Highlight.get("Normal", "bg")),
          bold = true,
          italic = true,
        },
      },

      {
        Folded = {
          fg = { from = "Normal", attr = "bg", alter = 1 },
          bg = { from = "Normal", attr = "bg", alter = 0.3 },
        },
      },
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 0.1 } } },

      {
        qfFileName = {
          fg = { from = "Normal", attr = "bg", alter = 1.5 },
          bg = "NONE",
        },
      },

      { QuickFixLine = { bg = { from = "CursorLine", attr = "bg", alter = 0.2 }, underline = false, reverse = false } },
      { ErrorMsg = { fg = "red" } },

      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = -0.15 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },
      {
        StatusLine = {
          fg = { from = "Normal", attr = "bg", alter = 2.4 },
          bg = { from = "StatusLine", attr = "bg", alter = -0.2 },
        },
      },
      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "fg", alter = -0.2 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.5 },
        },
      },
      {
        Tabline = {
          fg = { from = "WinSeparator", attr = "fg", alter = 0.4 },
          bg = { from = "Normal", attr = "bg", alter = 0.4 },
        },
      },
      {
        TablineSel = {
          fg = { from = "StatusLine", attr = "fg", alter = 0.1 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.8 },
        },
      },
    },
    ["dayfox"] = {
      { SnacksIndent = { fg = { from = "Normal", attr = "bg", alter = -0.04 } } },
      { WinSeparator = { fg = { from = "Normal", attr = "bg", alter = -0.1 }, bg = "NONE" } },
      { Comment = { fg = { from = "Normal", attr = "bg", alter = -0.3 }, italic = true } },

      { ["@markup.quote.markdown"] = { bg = { from = "GitSignsChange", attr = "fg", alter = 1.5 } } },

      {
        Folded = {
          fg = { from = "Normal", attr = "bg", alter = -0.4 },
          bg = { from = "Normal", attr = "bg", alter = -0.05 },
        },
      },
      { QuickFixLine = { bg = { from = "CursorLine", attr = "bg", alter = -0.1 }, underline = false } },

      { ["@punctuation.bracket"] = { fg = { from = "Keyword", attr = "fg", alter = -0.2 } } },

      { ["@lsp.type.parameter"] = { italic = true, bold = true, fg = { from = "Keyword" } } },

      { LineNr = { bg = "NONE", fg = { from = "LineNr", attr = "fg", alter = -0.2 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      { BlinkCmpGhostText = { fg = { from = "LineNr", attr = "fg", alter = -0.1 } } },

      {
        Pmenu = {
          fg = { from = "Normal", attr = "fg", alter = 0.5 },
          bg = { from = "Normal", attr = "bg", alter = -0.15 },
        },
      },
      {
        PmenuSel = {
          fg = "NONE",
          bg = { from = "Pmenu", attr = "bg", alter = 0.1 },
          bold = true,
        },
      },
      { PmenuThumb = { bg = { from = "Pmenu", attr = "bg", alter = -0.1 } } },

      { NormalFloat = { bg = { from = "Pmenu" } } },
      {
        FloatBorder = {
          fg = { from = "NormalFloat", attr = "bg" },
          bg = { from = "NormalFloat", attr = "bg" },
        },
      },

      --  ───────────────────────────────── CMP ─────────────────────────────────
      { CmpItemAbbr = { fg = { from = "Normal", attr = "bg", alter = -0.4 }, bg = "NONE" } },
      { CmpItemAbbrMatchFuzzy = { fg = { from = "Keyword", attr = "fg", alter = -0.1 } } },
      { CmpItemAbbrMatch = { fg = { from = "Keyword", attr = "fg", alter = -0.1 } } },
      {
        CmpItemFloatBorder = {
          fg = { from = "FloatBorder", attr = "fg" },
          bg = { from = "Pmenu", attr = "bg" },
        },
      },
      {
        CmpDocNormal = {
          fg = { from = "Keyword", attr = "fg", alter = -0.15 },
          bg = { from = "Pmenu", attr = "bg" },
        },
      },
      {
        CmpDocFloatBorder = {
          fg = { from = "Pmenu", attr = "bg" },
          bg = { from = "Pmenu", attr = "bg" },
        },
      },
      {
        CmpItemIconWarningMsg = {
          fg = { from = "WarningMsg", attr = "fg" },
          bg = { from = "CmpItemFloatBorder", attr = "bg" },
        },
      },

      --  ─────────────────────────────── FZFLUA ────────────────────────────
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = -0.2 } } },
      { FzfLuaNormal = { bg = { from = "NormalFloat", attr = "bg" } } },
      {
        FzfLuaBorder = {
          fg = { from = "NormalFloat", attr = "bg" },
          bg = { from = "NormalFloat", attr = "bg" },
        },
      },

      { FzfLuaPreviewNormal = { bg = { from = "FzfLuaNormal", attr = "bg" } } },
      {
        FzfLuaPreviewBorder = {
          fg = { from = "FzfLuaNormal", attr = "bg" },
          bg = { from = "FzfLuaNormal", attr = "bg" },
        },
      },
      { FzfLuaTitle = { inherit = "FzfLuaPreviewTitle" } },
      {
        FzfLuaTitleIcon = {
          fg = { from = "Boolean", attr = "fg", alter = 0.2 },
          bg = { from = "FzfLuaNormal", attr = "bg" },
        },
      },

      {
        FzfLuaSel = {
          fg = { from = "CmpItemAbbr", attr = "fg" },
          bg = { from = "CursorLine", attr = "bg" },
        },
      },

      { FzfLuaCursorLine = { bg = { from = "CursorLine", attr = "bg", alter = 0.04 } } },
      { FzfLuaCursorLineNr = { bg = { from = "CursorLine", attr = "bg", alter = 0.04 } } },

      { FzfLuaDirPart = { fg = { from = "Normal", attr = "bg", alter = -0.34 } } },
      { FzfLuaFilePart = { fg = { from = "Keyword", attr = "fg", alter = 0.5 }, reverse = false } },

      --  ────────────────────────────── TELESCOPE ──────────────────────────────
      { TelescopeNormal = { inherit = "FzfLuaNormal" } },
      { TelescopeBorder = { inherit = "FzfLuaBorder" } },
      { TelescopeTitle = { inherit = "FzfLuaTitle" } },
      {
        TelescopeSelection = {
          bg = { from = "FzfLuaSel", attr = "bg" },
          fg = { from = "FzfLuaSel", attr = "fg", alter = -0.2 },
        },
      },
      -- prompt
      { TelescopePromptNormal = { inherit = "FzfLuaNormal" } },
      { TelescopePromptTitle = { inherit = "FzfLuaPreviewTitle" } },
      { TelescopePromptBorder = { inherit = "FzfLuaBorder" } },
      { TelescopePromptPrefix = { inherit = "FzfLuaBorder" } },
      { TelescopePromptCounter = { inherit = "FzfLuaBorder" } },
      -- Preview
      { TelescopePreviewNormal = { inherit = "FzfLuaNormal" } },
      { TelescopePreviewTitle = { inherit = "FzfLuaPreviewTitle" } },
      { TelescopePreviewBorder = { inherit = "FzfLuaBorder" } },
      -- Results
      {
        TelescopeResultsNormal = {
          fg = { from = "FzfLuaDirPart", attr = "fg" },
          bg = { from = "FzfLuaNormal", attr = "bg" },
        },
      },
      { TelescopeResultsTitle = { inherit = "FzfLuaPreviewTitle" } },
      { TelescopeResultsBorder = { inherit = "FzfLuaBorder" } },

      --  ──────────────────────────────── MISC ─────────────────────────────
      {
        LspReferenceText = {
          bg = { from = "LspReferenceText", attr = "bg", alter = 0.8 },
          fg = "NONE",
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },
      {
        LspReferenceWrite = {
          bg = { from = "LspReferenceWrite", attr = "bg", alter = 0.8 },
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },

      {
        LspReferenceRead = {
          bg = { from = "LspReferenceRead", attr = "bg", alter = 0.8 },
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },

      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "bg", alter = -0.5 },
          bg = { from = "StatusLine", attr = "bg", alter = -0.4 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "fg", alter = 0.5 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.6 },
        },
      },

      {
        Tabline = {
          fg = { from = "WinSeparator", attr = "fg", alter = -0.15 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.75 },
        },
      },

      {
        TablineSel = {
          fg = { from = "StatusLine", attr = "fg", alter = 0.1 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.5 },
        },
      },
    },
    ["neomodern"] = {
      { SnacksIndent = { fg = { from = "Normal", attr = "bg", alter = 0.3 } } },

      { Search = { bg = "red" } },

      {
        Folded = {
          fg = { from = "Normal", attr = "bg", alter = 1.2 },
          bg = { from = "Normal", attr = "bg", alter = 0.6 },
        },
      },

      {
        StatusLine = {
          fg = { from = "Normal", attr = "bg", alter = 4.5 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.2 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "fg", alter = -0.2 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.2 },
        },
      },

      {
        Tabline = {
          fg = { from = "WinSeparator", attr = "fg", alter = 0.6 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.04 },
          reverse = false,
        },
      },
    },
    ["sonokai"] = {
      { Directory = { fg = { from = "Type", attr = "fg" }, bg = "NONE" } },

      { qfFileName = { fg = { from = "Directory", attr = "fg", alter = 0.3 }, bg = "NONE" } },
      { QuickFixFileName = { fg = { from = "Directory", attr = "fg" }, bg = "NONE" } },
      {
        QuickFixLine = {
          bg = { from = "CursorLine", attr = "bg", alter = 0.35 },
          fg = "NONE",
          underline = false,
        },
      },

      { Comment = { fg = { from = "Normal", attr = "bg", alter = 1.2 }, italic = true } },

      -- { WinSeparator = { fg = { from = "Normal", attr = "bg", alter = 0.3 }, bg = "NONE" } },
      { LineNr = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 0.5 } } },

      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.5 } } },
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 0.2 } } },

      { SnacksIndent = { fg = { from = "Normal", attr = "bg", alter = 0.3 } } },
      {
        SnacksIndentScope = {
          fg = Highlight.darken(Highlight.get("Special", "fg"), 0.2, Highlight.get("Normal", "bg")),
        },
      },

      { Search = { bg = { from = "IncSearch", attr = "bg", alter = 0.8 }, italic = true } },

      {
        Folded = {
          fg = { from = "Normal", attr = "bg", alter = 1.2 },
          bg = { from = "Normal", attr = "bg", alter = 0.2 },
        },
      },

      {
        StatusLine = {
          fg = { from = "Normal", attr = "bg", alter = 3.2 },
          bg = { from = "StatusLine", attr = "bg", alter = -0.15 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "fg", alter = -0.2 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.3 },
        },
      },
      {
        Tabline = {
          fg = { from = "WinSeparator", attr = "fg", alter = 0.55 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.06 },
          reverse = false,
        },
      },
    },
    ["nightfox"] = {
      { QuickFixLine = { bg = { from = "CursorLine", attr = "bg", alter = 0.4 }, underline = false } },
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = -0.1 } } },
      {
        Comment = {
          fg = { from = "Normal", attr = "bg", alter = 1.2 },
        },
      },
      {
        StatusLine = {
          fg = { from = "Normal", attr = "bg", alter = 4 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.7 },
        },
      },

      {
        Folded = {
          fg = { from = "Normal", attr = "bg", alter = 1.5 },
          bg = { from = "Normal", attr = "bg", alter = 0.4 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "fg", alter = -0.15 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.4 },
        },
      },

      {
        Tabline = {
          fg = { from = "WinSeparator", attr = "fg", alter = 0.5 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.09 },
          reverse = false,
        },
      },

      {
        TablineSel = {
          fg = { from = "StatusLine", attr = "fg", alter = 0.3 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.8 },
        },
      },
    },
    ["ashen"] = {
      { BlinkCmpGhostText = { fg = { from = "LineNr", attr = "fg", alter = 1.2 } } },
      { QuickFixLine = { bg = { from = "CursorLine", attr = "bg", alter = 0.4 }, fg = "NONE", underline = false } },
      {
        ["@comment"] = {
          fg = { from = "Normal", attr = "bg", alter = 2.7 },
        },
      },
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 1 } } },
      {
        StatusLine = {
          fg = { from = "Normal", attr = "bg", alter = 7.5 },
          bg = { from = "StatusLine", attr = "bg", alter = -0.4 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "fg", alter = -0.15 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.4 },
        },
      },

      {
        Tabline = {
          fg = { from = "WinSeparator", attr = "fg", alter = 1 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.1 },
          reverse = false,
        },
      },

      {
        TablineSel = {
          fg = { from = "StatusLine", attr = "fg", alter = 0.3 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.8 },
        },
      },
    },
    ["citruszest"] = {
      { BlinkCmpGhostText = { fg = { from = "LineNr", attr = "fg", alter = 1.2 } } },
      {
        Folded = {
          fg = { from = "Normal", attr = "bg", alter = 1.5 },
          bg = { from = "Normal", attr = "bg", alter = 0.7 },
        },
      },
      {
        ["@comment"] = {
          fg = { from = "Normal", attr = "bg", alter = 2.7 },
        },
      },
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 1 } } },
      {
        SnacksIndentScope = {
          fg = Highlight.darken(Highlight.get("Special", "fg"), 0.3, Highlight.get("Normal", "bg")),
        },
      },
      {
        StatusLine = {
          fg = { from = "Normal", attr = "bg", alter = 7.5 },
          bg = { from = "StatusLine", attr = "bg", alter = -0.4 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "fg", alter = -0.15 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.4 },
        },
      },

      {
        Tabline = {
          fg = { from = "WinSeparator", attr = "fg", alter = 1.2 },
          bg = { from = "StatusLine", attr = "bg", alter = -0.2 },
          reverse = false,
        },
      },

      {
        TablineSel = {
          fg = { from = "StatusLine", attr = "fg", alter = 0.5 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.8 },
        },
      },
    },
    ["carbonfox"] = {
      { BlinkCmpGhostText = { fg = { from = "LineNr", attr = "fg", alter = 0.5 } } },
      {
        Folded = {
          fg = { from = "Normal", attr = "bg", alter = 1 },
          bg = { from = "Normal", attr = "bg", alter = 0.6 },
        },
      },
      {
        Comment = {
          fg = { from = "Normal", attr = "bg", alter = 1.4 },
        },
      },

      {
        StatusLine = {
          fg = { from = "Normal", attr = "bg", alter = 4 },
          bg = { from = "StatusLine", attr = "bg", alter = 1.5 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "fg", alter = 0.05 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.35 },
        },
      },

      {
        Tabline = {
          fg = { from = "WinSeparator", attr = "fg", alter = 0.9 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.3 },
          reverse = false,
        },
      },

      {
        TablineSel = {
          fg = { from = "StatusLine", attr = "fg", alter = 0.3 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.8 },
        },
      },
    },
    ["tokyonight-storm"] = {
      {
        Folded = {
          fg = { from = "Normal", attr = "bg", alter = 1.2 },
          bg = { from = "Normal", attr = "bg", alter = 0.3 },
        },
      },
      {
        StatusLine = {
          fg = { from = "Normal", attr = "bg", alter = 3.5 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.3 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "fg", alter = -0.2 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.4 },
        },
      },

      {
        Tabline = {
          fg = { from = "WinSeparator", attr = "fg", alter = 0.4 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.2 },
        },
      },

      {
        TablineSel = {
          bg = { from = "StatusLine", attr = "bg", alter = 0.8 },
          fg = { from = "StatusLine", attr = "fg", alter = 0.1 },
        },
      },
    },
    ["tokyonight-day"] = {
      { ["@markup.quote.markdown"] = { bg = { from = "GitSignsChange", attr = "fg", alter = 1.5 } } },
      { ["@punctuation.bracket"] = { fg = { from = "GitSignsChange", attr = "fg", alter = -0.2 } } },

      { SnacksIndent = { fg = { from = "Normal", attr = "bg", alter = 0.05 } } },

      { Comment = { fg = { from = "Normal", attr = "bg", alter = -0.25 }, italic = true } },
      {
        Folded = {
          fg = { from = "Normal", attr = "bg", alter = -0.2 },
          bg = { from = "Normal", attr = "bg", alter = 0.02 },
        },
      },
      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = -0.2 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },
      { WinSeparator = { fg = { from = "LineNr", attr = "fg", alter = 0.1 }, bg = "NONE" } },

      {
        QuickFixLine = {
          bg = { from = "CursorLine", attr = "bg", alter = -0.05 },
          fg = "NONE",
          underline = false,
        },
      },
      {
        qfFileName = {
          fg = { from = "Directory", attr = "fg", alter = -0.1 },
          bg = "NONE",
        },
      },

      {
        CmpItemAbbr = {
          fg = { from = "Keyword", attr = "fg", alter = -0.3 },
          bg = "NONE",
        },
      },
      {
        Pmenu = {
          fg = { from = "Normal", attr = "fg", alter = 0.5 },
          bg = { from = "Normal", attr = "bg", alter = -0.1 },
        },
      },
      {
        PmenuSel = {
          fg = "NONE",
          bg = { from = "CursorLine", attr = "bg", alter = 0.05 },
          bold = true,
        },
      },

      {
        PmenuThumb = {
          bg = { from = "Pmenu", attr = "bg", alter = -0.1 },
        },
      },

      { NormalFloat = { bg = { from = "Pmenu" } } },
      {
        FloatBorder = {
          fg = { from = "NormalFloat", attr = "bg" },
          bg = { from = "NormalFloat", attr = "bg" },
        },
      },
      --  ───────────────────────────────── CMP ─────────────────────────────────
      { BlinkCmpGhostText = { fg = { from = "LineNr", attr = "fg", alter = -0.05 } } },
      {
        CmpItemIconWarningMsg = {
          fg = { from = "WarningMsg", attr = "fg" },
          bg = { from = "Pmenu", attr = "bg" },
        },
      },

      {
        CmpItemFloatBorder = {
          fg = { from = "FloatBorder", attr = "fg" },
          bg = { from = "Pmenu", attr = "bg" },
        },
      },
      {
        CmpDocNormal = {
          fg = { from = "Keyword", attr = "fg", alter = -0.15 },
          bg = { from = "Pmenu", attr = "bg" },
        },
      },
      {
        CmpDocFloatBorder = {
          fg = { from = "Pmenu", attr = "bg" },
          bg = { from = "Pmenu", attr = "bg" },
        },
      },
      {
        CmpItemIconWarningMsg = {
          fg = { from = "WarningMsg", attr = "fg" },
          bg = { from = "CmpItemFloatBorder", attr = "bg" },
        },
      },

      --  ─────────────────────────────── FZFLUA ────────────────────────────
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = -0.2 } } },
      { FzfLuaNormal = { bg = { from = "NormalFloat", attr = "bg" } } },
      {
        FzfLuaBorder = {
          fg = { from = "FloatBorder", attr = "fg" },
          bg = { from = "NormalFloat", attr = "bg" },
        },
      },

      { FzfLuaTitle = { inherit = "FzfLuaPreviewTitle" } },

      {
        FzfLuaSel = {
          fg = { from = "PmenuSel", attr = "bg", alter = 0.3 },
          bg = { from = "PmenuSel", attr = "bg" },
        },
      },

      { FzfLuaCursorLine = { bg = { from = "CursorLine", attr = "bg", alter = 0.04 } } },

      { FzfLuaDirPart = { fg = { from = "Normal", attr = "fg", alter = 0.5 } } },
      { FzfLuaFilePart = { fg = { from = "Keyword", attr = "fg" }, reverse = false } },

      { FzfLuaPreviewNormal = { bg = { from = "FzfLuaNormal", attr = "bg" } } },
      {
        FzfLuaPreviewBorder = {
          fg = { from = "FzfLuaBorder", attr = "fg" },
          bg = { from = "FzfluaBorder", attr = "bg" },
        },
      },

      --  ────────────────────────────── TELESCOPE ──────────────────────────────
      { TelescopeNormal = { inherit = "FzfLuaNormal" } },
      { TelescopeBorder = { inherit = "FzfLuaBorder" } },
      { TelescopeTitle = { inherit = "FzfLuaTitle" } },
      {
        TelescopeSelection = {
          fg = "NONE",
          bg = { from = "FzfLuaSel", attr = "bg" },
        },
      },

      -- prompt
      { TelescopePromptNormal = { inherit = "FzfLuaNormal" } },
      { TelescopePromptTitle = { inherit = "FzfLuaTitle" } },
      { TelescopePromptBorder = { inherit = "FzfLuaBorder" } },
      { TelescopePromptPrefix = { inherit = "FzfLuaBorder" } },
      { TelescopePromptCounter = { inherit = "FzfLuaBorder" } },

      -- Preview
      { TelescopePreviewNormal = { inherit = "FzfLuaNormal" } },
      { TelescopePreviewTitle = { inherit = "FzfLuaTitle" } },
      { TelescopePreviewBorder = { inherit = "FzfLuaBorder" } },

      -- Results
      { TelescopeResultsNormal = { inherit = "FzfLuaNormal" } },
      { TelescopeResultsTitle = { inherit = "FzfLuaTitle" } },
      { TelescopeResultsBorder = { inherit = "FzfLuaBorder" } },

      --  ──────────────────────────────── MISC ─────────────────────────────
      {
        LspReferenceText = {
          bg = { from = "LspReferenceText", attr = "bg", alter = 1 },
          fg = "NONE",
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },
      {
        LspReferenceWrite = {
          bg = { from = "LspReferenceWrite", attr = "bg", alter = 1 },
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },

      {
        LspReferenceRead = {
          bg = { from = "LspReferenceRead", attr = "bg", alter = 1 },
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },

      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "bg", alter = -0.55 },
          bg = { from = "Normal", attr = "bg", alter = -0.5 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "fg", alter = 0.5 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.7 },
        },
      },

      {
        Tabline = {
          fg = { from = "WinSeparator", attr = "fg", alter = -0.18 },
          bg = { from = "Normal", attr = "bg", alter = 0.06 },
        },
      },

      {
        TablineSel = {
          fg = { from = "StatusLine", attr = "fg", alter = 0.1 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.5 },
        },
      },
    },
    ["tokyonight-night"] = {
      {
        Folded = {
          fg = { from = "Normal", attr = "bg", alter = 1.2 },
          bg = { from = "Normal", attr = "bg", alter = 0.45 },
        },
      },
      {
        StatusLine = {
          fg = { from = "Normal", attr = "bg", alter = 5 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.6 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "fg", alter = -0.2 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.4 },
        },
      },

      {
        Tabline = {
          fg = { from = "WinSeparator", attr = "fg", alter = 0.8 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.2 },
        },
      },

      {
        TablineSel = {
          bg = { from = "StatusLine", attr = "bg", alter = 0.8 },
          fg = { from = "StatusLine", attr = "fg", alter = 0.1 },
        },
      },
    },
    ["vscode_modern"] = {
      { Directory = { fg = "#569cd6", bg = "NONE" } },

      { qfFileName = { fg = { from = "Directory", attr = "fg", alter = 0.3 }, bg = "NONE" } },
      { QuickFixFileName = { fg = { from = "Directory", attr = "fg" }, bg = "NONE" } },
      {
        QuickFixLine = {
          bg = { from = "CursorLine", attr = "bg", alter = 0.35 },
          fg = "NONE",
          underline = false,
        },
      },

      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.5 } } },

      {
        Comment = {
          fg = { from = "Normal", attr = "bg", alter = 1.2 },
          bg = "NONE",
          italic = true,
          reverse = false,
        },
      },
      {
        Folded = {
          fg = { from = "Normal", attr = "bg", alter = 1.5 },
          bg = { from = "Normal", attr = "bg", alter = 0.45 },
        },
      },
      { SnacksIndent = { fg = { from = "Normal", attr = "bg", alter = 0.4 } } },
      {
        SnacksIndentScope = {
          fg = Highlight.darken(Highlight.get("Special", "fg"), 0.2, Highlight.get("Normal", "bg")),
        },
      },

      { CmpItemAbbrMatchFuzzy = { fg = { from = "GitSignsDelete", attr = "fg" } } },
      { CmpItemAbbrMatch = { fg = { from = "GitSignsDelete", attr = "fg" } } },

      {
        LspReferenceText = {
          bg = { from = "LspReferenceText", attr = "bg", alter = -0.4 },
          fg = "NONE",
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },
      {
        LspReferenceWrite = {
          bg = { from = "LspReferenceWrite", attr = "bg", alter = -0.1 },
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },

      {
        LspReferenceRead = {
          bg = { from = "LspReferenceRead", attr = "bg", alter = -0.1 },
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },

      {
        MyCodeUsage = {
          fg = { from = "Visual", attr = "bg", alter = 1 },
          bg = { from = "Visual", attr = "bg", alter = -0.5 },
          italic = true,
        },
      },
      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "bg", alter = 7 },
          bg = { from = "StatusLine", attr = "bg", alter = 1 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "fg", alter = -0.1 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.4 },
        },
      },

      {
        Tabline = {
          fg = { from = "WinSeparator", attr = "fg", alter = 0.65 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.25 },
        },
      },

      {
        TablineSel = {
          bg = { from = "StatusLine", attr = "bg", alter = 0.8 },
          fg = { from = "StatusLine", attr = "fg", alter = 0.1 },
        },
      },
    },
    ["catppuccin-mocha"] = {
      { SnacksIndent = { fg = { from = "Normal", attr = "bg", alter = 0.3 } } },
      { Comment = { fg = { from = "Normal", attr = "bg", alter = 1.4 }, italic = true } },

      { LineNr = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 0.7 } } },
      { BlinkCmpGhostText = { fg = { from = "LineNr", attr = "fg", alter = 0.6 } } },

      {
        LspReferenceText = {
          bg = { from = "Normal", attr = "bg", alter = 0.2 },
          fg = "NONE",
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },
      {
        LspReferenceWrite = {
          bg = { from = "Normal", attr = "bg", alter = 0.8 },
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },
      {
        LspReferenceRead = {
          bg = { from = "Normal", attr = "bg", alter = 0.8 },
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },

      {
        StatusLine = {
          fg = { from = "Normal", attr = "bg", alter = 3.5 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.5 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "bg", alter = 2 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.4 },
        },
      },

      {
        Tabline = {
          fg = { from = "WinSeparator", attr = "fg", alter = 0.5 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.2 },
          reverse = false,
        },
      },

      {
        TablineSel = {
          fg = { from = "StatusLine", attr = "fg", alter = 0.5 },
          bg = { from = "StatusLine", attr = "bg", alter = 1 },
        },
      },
    },
  }

  local hls = overrides[vim.g.colors_name]
  if hls then
    Highlight.all(hls)
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
