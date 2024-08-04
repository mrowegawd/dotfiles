local UIPallette = require("r.utils").uisec

local Highlight = require "r.settings.highlights"

local dark_orange = Highlight.tint(UIPallette.palette.dark_orange, 0.5)
local dark_green = Highlight.tint(UIPallette.palette.dark_green, 0.5)
local dark_red = Highlight.tint(UIPallette.palette.dark_red, 0.5)
local dark_red_more = Highlight.tint(dark_red, -0.4)

local general_overrides = function()
  Highlight.all {
    { FoldColumn = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 0.4 } } },
    { FoldColumn1 = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 1 } } },
    { ColorColumn = { bg = { from = "Normal", attr = "bg", alter = -0.1 } } },
    { LineNr = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 0.5 } } },
    { CursorLine = { bg = { from = "Normal", attr = "bg" } } },
    {
      CursorLineNr = {
        fg = { from = "Keyword", attr = "fg", alter = 0.1 },
        bg = { from = "LineNr", attr = "fg", alter = 0.5 },
        bold = true,
      },
    },
    { Type = { italic = true, bold = true } },
    { Comment = { fg = { from = "Normal", attr = "fg", alter = -0.55 }, italic = true } },
    {
      Folded = {
        bg = { from = "Normal", attr = "bg", alter = 0.4 },
        fg = { from = "Normal", attr = "bg", alter = 0.8 },
      },
    },
    { EndOfBuffer = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 0.2 } } },
    { SignColumn = { bg = "NONE" } },
    { NonText = { fg = { from = "Normal", attr = "fg", alter = -0.4 } } },
    { WinSeparator = { fg = { from = "LineNr", attr = "fg", alter = 0.4 }, bg = "NONE" } },
    { WinBar = { bg = { from = "ColorColumn" }, fg = { from = "Normal", attr = "bg", alter = 1 } } },
    { WinBarNC = { bg = { from = "ColorColumn", attr = "bg" }, fg = { from = "WinBar", attr = "fg" } } },
    { PmenuThumb = { bg = { from = "WinSeparator", attr = "fg", alter = 0.1 } } },
    { QuickFixLine = { bg = { from = "Keyword", attr = "fg", alter = -0.5 }, underline = false } },
    -----------------------------------------------------------------------------//
    --  Spell
    -----------------------------------------------------------------------------//
    { SpellBad = { undercurl = true, bg = "NONE", fg = "NONE", sp = "green" } },
    { SpellRare = { undercurl = true } },

    -----------------------------------------------------------------------
    --  SEMANTIC TOKENS
    -----------------------------------------------------------------------
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

    -----------------------------------------------------------------------
    -- LSP
    -----------------------------------------------------------------------
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

    -- { LspKindSnippet = { link = "Conceal" } },
    { LspKindSnippet = { fg = { from = "Keyword", attr = "fg" } } },

    -----------------------------------------------------------------------
    -- TREESITTER
    -----------------------------------------------------------------------
    { ["@keyword.return"] = { italic = true, fg = { from = "Keyword" } } },
    -- { ['@type.qualifier'] = { inherit = '@keyword', italic = true } },
    -- { ["@variable"] = { fg =  { from = "Directory", attr = "fg", alter = -0.1 } } },
    { ["@parameter"] = { italic = true, bold = true, fg = "NONE" } },
    -- { ["@error"] = { fg = "fg", bg = "NONE" } },
    -- { ["@text.diff.add"] = { link = "DiffAdd" } },
    -- { ["@text.diff.delete"] = { link = "DiffDelete" } },
    -----------------------------------------------------------------------
    -- TREESITTER LANGUAGE
    -----------------------------------------------------------------------
    -- lua
    -- { ["@lsp.type.function.lua"] = { fg = { from = "Identifier", attr = "fg" }, bold = true } },
    -- { ["@function.call.lua"] = { fg = { from = "Identifier", attr = "fg"}, bold = true } },
    -- { ['@lsp.type.variable.lua'] = { italic = true, fg = "green" } },

    -- zsh
    { ["zshFunction"] = { fg = { from = "Identifier", attr = "fg" }, bold = true } },

    -- bash
    { ["@function.bash"] = { fg = { from = "Identifier", attr = "fg" }, bold = true } },
    { ["@function.call.bash"] = { fg = { from = "Identifier", attr = "fg" }, bold = true } },

    -- rust
    { ["@lsp.type.function.rust"] = { fg = { from = "Identifier", attr = "fg" }, bold = true } },

    -----------------------------------------------------------------------
    -- DIFF
    -----------------------------------------------------------------------
    -- These highlights are syntax groups that are set in diff.vim
    -- { GitSignsAdd = { bg = { from = "ColorColumn"} } },
    -- { diffAdded = { inherit = 'DiffAdd' } },
    -- { diffChanged = { inherit = 'DiffChange' } },
    -- { diffRemoved = { link = 'DiffDelete' } },
    -- { diffBDiffer = { link = 'WarningMsg' } },
    -- { diffCommon = { link = 'WarningMsg' } },
    -- { diffDiffer = { link = 'WarningMsg' } },
    -- { diffFile = { link = 'Directory' } },
    -- { diffIdentical = { link = 'WarningMsg' } },
    -- { diffIndexLine = { link = 'Number' } },
    -- { diffIsA = { link = 'WarningMsg' } },
    -- { diffNoEOL = { link = 'WarningMsg' } },
    -- { diffOnly = { link = 'WarningMsg' } },

    { diffAdd = { bg = UIPallette.palette.green_git_bg, fg = "NONE", bold = true } },
    { diffChange = { bg = UIPallette.palette.yellow_git_bg, fg = "NONE", bold = true } },
    { diffDelete = { bg = UIPallette.palette.red_git_bg, fg = "NONE", bold = true } },
    { diffText = { bg = UIPallette.palette.text_git_bg, fg = "NONE", bold = true } },

    { GitSignsAdd = { bg = "NONE", fg = dark_green } },
    { GitSignsChange = { bg = "NONE", fg = dark_orange } },
    { GitSignsDelete = { bg = "NONE", fg = dark_red } },

    { NeogitDiffAdd = { link = "diffAdd" } },
    { NeogitDiffAddHighlight = { link = "diffAdd" } },
    { NeogitDiffDelete = { link = "diffDelete" } },
    { NeogitDiffDeleteHighlight = { link = "diffDelete" } },
    { DiffText = { link = "diffText" } },
    -----------------------------------------------------------------------
    -- DEBUG
    -----------------------------------------------------------------------
    { debugPC = { bg = { from = "Boolean", attr = "fg", alter = -0.6 }, fg = "NONE", bold = true } },

    -----------------------------------------------------------------------
    -- DIAGNOSTIC
    -----------------------------------------------------------------------
    { DiagnosticSignError = { bg = { from = "Normal", attr = "bg" } } },
    { DiagnosticSignWarn = { bg = { from = "Normal", attr = "bg" } } },
    { DiagnosticSignInfo = { bg = { from = "Normal", attr = "bg" } } },
    { DiagnosticSignHint = { bg = { from = "Normal", attr = "bg" } } },

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

    -----------------------------------------------------------------------
    -- MARKDOWN
    -----------------------------------------------------------------------
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
    -----------------------------------------------------------------------
    -- CREATED HIGHLIGHTS
    -----------------------------------------------------------------------

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

    -----------------------------------------------------------------------
    -- PLUGINS
    -----------------------------------------------------------------------

    -- CMP ================================================================
    {
      Pmenu = {
        bg = { from = "Normal", attr = "bg", alter = -0.2 },
        fg = { from = "Normal", attr = "bg", alter = 0.8 },
      },
    },

    { NormalFloat = { bg = { from = "Pmenu", alter = -0.2 } } },
    {
      FloatBorder = {
        bg = { from = "NormalFloat", attr = "bg" },
        fg = { from = "NormalFloat", attr = "bg", alter = 0.8 },
      },
    },

    {
      CmpItemAbbr = {
        fg = { from = "Normal", attr = "bg", alter = 1.5 },
        bg = "NONE",
      },
    },
    {
      PmenuSel = {
        bg = { from = "Keyword", attr = "fg", alter = -0.2 },
        fg = { from = "CmpItemAbbr", attr = "fg", alter = -0.5 },
        bold = true,
      },
    },
    { CmpItemAbbrMatchFuzzy = { fg = { from = "GitSignsDelete", attr = "fg", alter = -0.2 } } },
    { CmpItemAbbrMatch = { fg = { from = "GitSignsDelete", attr = "fg", alter = 0.5 } } },

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

    -- AERIALS ============================================================
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

    -- SHOW CODE LENS PLUGIN ============================================
    {
      LspCodeLens = {
        bg = { from = "Normal", attr = "bg", alter = -0.1 },
        fg = { from = "Comment", attr = "fg", alter = -0.5 },
        italic = true,
      },
    },

    -- TREESITTER CONTEXT ===============================================
    -- { LspCodeLensSeparator = { bold = false, italic = false } },

    -- { illuminatedWordWrite = { bg = { from = "illuminatedWordWrite", attr = "bg", alter = -0.05 } } },
    -- { illuminatedWordRead = { bg = { from = "illuminatedWordRead", attr = "bg", alter = -0.05 } } },
    -- { illuminatedWordText = { bg = { from = "illuminatedWordText", attr = "bg", alter = -0.05 } } },

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

    -- COC =============================================================
    { CocPumMenu = { link = "CmpItemAbbr" } },
    { CocMenuSel = { link = "PmenuSel" } },

    -- FZFLUA =============================================================
    { FzfLuaNormal = { bg = { from = "NormalFloat", attr = "bg" } } },
    {
      FzfLuaBorder = {
        fg = { from = "WinSeparator", attr = "fg", alter = 0.3 },
        bg = { from = "NormalFloat", attr = "bg" },
      },
    },
    {
      FzfLuaPreviewBorder = {
        fg = { from = "WinSeparator", attr = "fg", alter = 0.3 },
        bg = { from = "NormalFloat", attr = "bg" },
      },
    },
    {
      FzfLuaTitle = { fg = { from = "Boolean", attr = "fg", alter = 0.2 }, bg = { from = "NormalFloat", attr = "bg" } },
    },
    {
      FzfLuaTitleIcon = {
        fg = { from = "Boolean", attr = "fg", alter = 0.2 },
        bg = { from = "FzfLuaNormal", attr = "bg" },
      },
    },
    { FzfLuaCursorLine = { bg = { from = "ErrorMsg", alter = -0.8, attr = "fg" } } },
    {
      FzfLuaSel = {
        bg = { from = "PmenuSel", alter = -0.4, attr = "bg" },
        fg = { from = "PmenuSel", alter = 0.3, attr = "bg" },
      },
    },

    { FzfLuaDirPart = { fg = { from = "Normal", attr = "fg", alter = -0.3 } } },
    { FzfLuaFilePart = { fg = { from = "Keyword", attr = "fg" }, reverse = false } },

    -- TELESCOPE ==========================================================
    { TelescopeNormal = { inherit = "FzfLuaNormal" } },
    { TelescopeBorder = { inherit = "FzfLuaBorder" } },
    { TelescopeMatching = { inherit = "CmpItemAbbrMatchFuzzy" } },
    { TelescopeTitle = { inherit = "FzfLuaTitle" } },

    { TelescopeSelection = { inherit = "FzfLuaSel", underline = false, undercurl = false } },
    { TelescopeSelectionCaret = { bg = "NONE", fg = "green" } },

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

    -- WHICH-KEY ==========================================================
    {
      WhichKeyBorder = {
        fg = { from = "ErrorMsg", attr = "fg", alter = 0.5 },
        bg = { from = "NormalFloat", attr = "bg" },
      },
    },
    { WhichKey = { fg = dark_red_more } },

    -- NOICE ==============================================================
    { NoicePopupBorder = { fg = { from = "FloatBorder" }, bg = "NONE" } },
    { NoiceCmdlinePopup = { bg = { from = "Pmenu" } } },
    { NoiceCmdlinePopupBorder = { fg = { from = "Pmenu", attr = "fg", alter = -0.7 } } },

    -----------------------------------------------------------------------
    -- ORGMODE
    -----------------------------------------------------------------------
    { OrgDONE = { fg = "#00FF00" } },
    { ["@org.headline.level1.org"] = { fg = "#4d85c3", bold = true, italic = true } },
    { ["@org.headline.level2.org"] = { fg = "#389674", bold = true, italic = true } },
    { ["@org.headline.level3.org"] = { fg = "#b0be1e", bold = true, italic = true } },
    { ["@org.headline.level4.org"] = { fg = "#8594c8", bold = true, italic = true } },
    { ["@org.headline.level5.org"] = { fg = "#f76328", bold = true, italic = true } },
    { ["@org.headline.level6.org"] = { fg = "#fccf3e", bold = true, italic = true } },

    { ["@org.timestamp.active"] = { inherit = "PreProc" } },
    { ["@org.timestamp.inactive"] = { inherit = "Comment" } },
    { ["@org.bullet"] = { inherit = "Identifier" } },
    { ["@org.checkbox"] = { inherit = "PreProc" } },
    { ["@org.checkbox.halfchecked"] = { inherit = "PreProc" } },
    { ["@org.checkbox.checked"] = { inherit = "PreProc" } },
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
    -- ['@org.code.delimiter'] = 'String',
    -- ['@org.verbatim'] = 'String',
    -- ['@org.verbatim.delimiter'] = 'String',
    -- ['@org.bold'] = { bold = true },
    -- ['@org.bold.delimiter'] = { bold = true },
    -- ['@org.italic'] = { italic = true },
    -- ['@org.italic.delimiter'] = { italic = true },
    -- ['@org.strikethrough'] = { strikethrough = true },
    -- ['@org.strikethrough.delimiter'] = { strikethrough = true },
    -- ['@org.underline'] = { underline = true },
    -- ['@org.underline.delimiter'] = { underline = true },

    -- HLSEARCH ===========================================================
    {
      HlSearchLensNear = {
        bg = { from = "IncSearch", attr = "bg" },
        fg = { from = "IncSearch", attr = "bg", alter = -0.3 },
        bold = true,
      },
    },

    -- BUFFERLINE =========================================================
    { BufferLineIndicatorSelected = { bg = { from = "ColorColumn" } } },
    { OctoEditable = { bg = { from = "ColorColumn" } } },
    { OctoBubble = { link = "Normal" } },

    -- BQF ================================================================
    { BqfSign = { bg = { from = "ColorColumn", attr = "bg" }, { fg = { from = "Boolean" } } } },

    -- TROUBLE ========================================================
    { TodoSignWarn = { bg = { from = "Normal", attr = "bg" }, fg = { from = "DiagnosticWarn" } } },
    { TodoSignFIX = { bg = { from = "Normal", attr = "bg" }, fg = { from = "DiagnosticSignError" } } },
    { TodoSignTODO = { bg = { from = "Normal", attr = "bg" }, fg = { from = "OrgDONE" } } },

    -- GLANCE =============================================================
    { GlancePreviewNormal = { bg = "#111231" } },
    { GlancePreviewMatch = { fg = "#012D36", bg = "#FDA50F" } },
    { GlanceListMatch = { fg = dark_red, bg = "NONE" } },
    { GlancePreviewCursorLine = { bg = "#1b1c4b" } },

    -- MARKDOWN ===========================================================
    {
      ["@markup.raw.markdown_inline"] = {
        bg = { from = "Normal", attr = "bg", alter = -0.4 },
        fg = { from = "ErrorMsg", attr = "fg" },
      },
    },
    -- TELESCOPE ==========================================================
    { MiniAnimateCursor = { fg = "red", bg = "red" } },

    -- VIM.MATCHUP ========================================================
    -- { MatchParen = { bg = { from = "MatchParen", attr = "bg", alter = -0.8 }, fg = "NONE", bold = false } },
    { MatchParen = { bg = { from = "Normal", attr = "bg", alter = -1 }, fg = "white", bold = false } },
    -- { MatchParen = { fg = "white", bg = "black", bold = true } },

    -- VGIT ========================================================
    { VGitLineNr = { bg = "NONE", fg = { from = "LineNr", attr = "fg", alter = 1 } } },
    { VGitComment = { bg = "NONE", fg = { from = "Comment", attr = "fg", alter = 0.5 } } },
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
    ["gruvbox-material"] = {
      {
        CmpItemAbbr = {
          fg = { from = "Normal", attr = "bg", alter = 2 },
          bg = "NONE",
        },
      },

      { Pmenu = { bg = { from = "Normal", attr = "bg", alter = -0.2 }, fg = { from = "CmpItemAbbr" } } },
      {
        PmenuSel = {
          bg = { from = "Keyword", attr = "fg", alter = -0.2 },
          fg = { from = "CmpItemAbbr", attr = "fg", alter = -0.6 },
          bold = true,
        },
      },

      { NormalFloat = { bg = { from = "Pmenu", alter = -0.1 } } },
      {
        FloatBorder = {
          bg = { from = "NormalFloat", attr = "bg" },
          fg = { from = "NormalFloat", attr = "bg", alter = 0.8 },
        },
      },

      { FzfLuaNormal = { bg = { from = "NormalFloat", attr = "bg", alter = 0.1 } } },
      {
        FzfLuaBorder = {
          fg = { from = "WinSeparator", attr = "fg", alter = -0.5 },
          bg = { from = "NormalFloat", attr = "bg", alter = 0.1 },
        },
      },

      {
        FzfLuaTitle = {
          fg = { from = "Boolean", attr = "fg", alter = 0.2 },
          bg = { from = "NormalFloat", attr = "bg", alter = 0.1 },
        },
      },

      {
        FzfLuaPreviewBorder = {
          fg = { from = "FzfLuaBorder", attr = "fg", alter = 0.1 },
          bg = { from = "FzfluaBorder", attr = "bg" },
        },
      },

      {
        Folded = {
          bg = { from = "Normal", attr = "bg", alter = 0.3 },
          fg = { from = "Normal", attr = "bg", alter = 1 },
        },
      },

      { TelescopeNormal = { inherit = "FzfLuaNormal" } },
      { TelescopeBorder = { inherit = "FzfLuaBorder" } },
      { TelescopeTitle = { inherit = "FzfLuaTitle" } },
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

      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = 0.2 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      { DiagnosticVirtualTextWarn = { fg = { from = "DiagnosticWarn", attr = "fg" }, sp = "NONE", undercurl = false } },
      { DiagnosticVirtualTextInfo = { fg = { from = "DiagnosticInfo", attr = "fg" }, sp = "NONE", undercurl = false } },
      {
        DiagnosticVirtualTextError = { fg = { from = "DiagnosticError", attr = "fg" }, sp = "NONE", undercurl = false },
      },
      { DiagnosticVirtualTextHint = { fg = { from = "DiagnosticHint", attr = "fg" }, sp = "NONE", undercurl = false } },

      { DiagnosticFloatingWarn = { fg = { from = "DiagnosticWarn", attr = "fg" }, bg = "NONE", bold = true } },
      { DiagnosticFloatingInfo = { fg = { from = "DiagnosticInfo", attr = "fg" }, bg = "NONE", bold = true } },
      { DiagnosticFloatingHint = { fg = { from = "DiagnosticHint", attr = "fg" }, bg = "NONE", bold = true } },
      { DiagnosticFloatingError = { fg = { from = "DiagnosticError", attr = "fg" }, bg = "NONE", bold = true } },
      { DiagnosticFloatTitle = { bg = { from = "NormalFloat", attr = "bg" }, bold = true } },
      { DiagnosticFloatTitleIcon = { bg = { from = "NormalFloat", attr = "bg" }, fg = { from = "@character" } } },

      {
        LspCodeLens = {
          bg = { from = "Normal", attr = "bg", alter = -0.1 },
          fg = { from = "Comment", attr = "fg", alter = -0.4 },
          italic = true,
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "bg", alter = 2.5 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.4 },
        },
      },
    },
    ["horizon"] = {
      { FzfLuaFzfNormal = { fg = { from = "Keyword", attr = "fg" } } },
      { FzfLuaFilePart = { fg = { from = "Keyword", attr = "fg" }, reverse = false } },
      { FzfLuaDirPart = { fg = { from = "Normal", attr = "fg", alter = -0.3 } } },

      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = 0.2 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      {
        FzfLuaBorder = {
          fg = { from = "WinSeparator", attr = "fg", alter = -0.4 },
          bg = { from = "NormalFloat", attr = "bg", alter = 0.1 },
        },
      },

      {
        FzfLuaPreviewBorder = {
          fg = { from = "FzfLuaBorder", attr = "fg", alter = 0.1 },
          bg = { from = "FzfluaBorder", attr = "bg" },
        },
      },

      { TelescopeBorder = { inherit = "FzfLuaBorder" } },
      -- prompt
      { TelescopePromptBorder = { inherit = "FzfLuaBorder" } },
      { TelescopePromptPrefix = { inherit = "FzfLuaBorder" } },
      -- Preview
      { TelescopePreviewBorder = { inherit = "FzfLuaBorder" } },
      -- Results
      { TelescopeResultsBorder = { inherit = "FzfLuaBorder" } },

      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "fg", alter = 4 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.5 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "bg", alter = 3 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.3 },
        },
      },
      {
        Folded = {
          bg = { from = "Normal", attr = "bg", alter = 0.5 },
          fg = { from = "Normal", attr = "bg", alter = 2 },
        },
      },

      {
        Tabline = {
          bg = { from = "StatusLine", attr = "bg", alter = 0.3 },
          fg = { from = "WinSeparator", attr = "fg", alter = 1 },
        },
      },

      {
        TablineSel = {
          bg = { from = "StatusLine", attr = "bg", alter = 0.8 },
          fg = { from = "StatusLine", attr = "fg", alter = 0.1 },
        },
      },
    },
    ["vague"] = {

      {
        CmpItemAbbr = {
          fg = { from = "Normal", attr = "bg", alter = 5 },
          bg = "NONE",
        },
      },
      { Pmenu = { bg = { from = "Normal", attr = "bg", alter = 1 }, fg = { from = "CmpItemAbbr" } } },
      {
        PmenuSel = {
          bg = { from = "Keyword", attr = "fg", alter = -0.2 },
          fg = { from = "CmpItemAbbr", attr = "fg", alter = -1 },
          bold = true,
        },
      },
      { NormalFloat = { bg = { from = "Pmenu", alter = -0.1 } } },
      {
        FloatBorder = {
          bg = { from = "NormalFloat", attr = "bg" },
          fg = { from = "NormalFloat", attr = "bg", alter = 0.8 },
        },
      },

      { FzfLuaNormal = { bg = { from = "NormalFloat", attr = "bg" } } },
      {
        FzfLuaBorder = {
          fg = { from = "WinSeparator", attr = "fg", alter = 0.5 },
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
        Folded = {
          bg = { from = "Normal", attr = "bg", alter = 0.3 },
          fg = { from = "Normal", attr = "bg", alter = 1 },
        },
      },

      { TelescopeNormal = { inherit = "FzfLuaNormal" } },
      { TelescopeBorder = { inherit = "FzfLuaBorder" } },
      { TelescopeTitle = { inherit = "FzfLuaTitle" } },
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

      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = 0.2 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },
      {
        LspReferenceText = {
          bg = "NONE",
          fg = "NONE",
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },
      {
        LspReferenceWrite = {
          bg = { from = "LspReferenceWrite", attr = "bg", alter = -0.5 },
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },

      {
        LspReferenceRead = {
          bg = { from = "LspReferenceRead", attr = "bg", alter = -0.5 },
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },

      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "fg", alter = 4 },
          bg = { from = "StatusLine", attr = "bg", alter = -0.5 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "bg", alter = 2 },
          bg = { from = "StatusLine", attr = "bg", alter = -0.2 },
        },
      },
      {
        Folded = {
          bg = { from = "Normal", attr = "bg", alter = 0.5 },
          fg = { from = "Normal", attr = "bg", alter = 2 },
        },
      },

      {
        RenderMarkdownCode = {
          bg = { from = "Normal", attr = "bg", alter = 0.5 },
        },
      },

      {
        Tabline = {
          bg = { from = "StatusLine", attr = "bg", alter = -0.1 },
          fg = { from = "WinSeparator", attr = "fg", alter = 1.5 },
        },
      },

      {
        TablineSel = {
          bg = { from = "StatusLine", attr = "bg", alter = 1 },
          fg = { from = "StatusLine", attr = "fg", alter = 0.1 },
        },
      },
    },

    ["kanagawa"] = {
      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = 0.2 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      {
        FzfLuaBorder = {
          fg = { from = "WinSeparator", attr = "fg", alter = -0.4 },
          bg = { from = "NormalFloat", attr = "bg", alter = 0.1 },
        },
      },

      { NormalFloat = { bg = { from = "Pmenu", alter = -0.2 } } },
      {
        FloatBorder = {
          bg = { from = "NormalFloat", attr = "bg" },
          fg = { from = "NormalFloat", attr = "bg", alter = 0.8 },
        },
      },

      { TelescopeBorder = { inherit = "FzfLuaBorder" } },
      -- prompt
      { TelescopePromptBorder = { inherit = "FzfLuaBorder" } },
      { TelescopePromptPrefix = { inherit = "FzfLuaBorder" } },
      -- Preview
      { TelescopePreviewBorder = { inherit = "FzfLuaBorder" } },
      -- Results
      { TelescopeResultsBorder = { inherit = "FzfLuaBorder" } },

      {
        LspReferenceText = {
          bg = "NONE",
          fg = "NONE",
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },

      {
        Folded = {
          bg = { from = "Normal", attr = "bg", alter = 0.5 },
          fg = { from = "Normal", attr = "bg", alter = 2 },
        },
      },
      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "fg", alter = 4 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.5 },
        },
      },
      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "bg", alter = 3 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.5 },
        },
      },

      {
        Tabline = {
          bg = { from = "StatusLine", attr = "bg", alter = 1.5 },
          fg = { from = "WinSeparator", attr = "fg", alter = 1.5 },
        },
      },
      {
        TablineSel = {
          bg = { from = "StatusLine", attr = "bg", alter = 2.5 },
          fg = { from = "WinSeparator", attr = "fg", alter = 3 },
        },
      },
    },
    ["kanagawa-paper"] = {
      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = 0.2 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      {
        CmpItemAbbr = {
          fg = { from = "Normal", attr = "bg", alter = 3 },
          bg = "NONE",
        },
      },
      { Pmenu = { bg = { from = "Normal", attr = "bg", alter = 0.8 }, fg = { from = "CmpItemAbbr" } } },
      {
        PmenuSel = {
          bg = { from = "Keyword", attr = "fg", alter = 0.2 },
          fg = { from = "CmpItemAbbr", attr = "fg", alter = -0.6 },
          bold = true,
        },
      },

      { NormalFloat = { bg = { from = "Pmenu", alter = -0.1 } } },
      {
        FloatBorder = {
          bg = { from = "NormalFloat", attr = "bg" },
          fg = { from = "NormalFloat", attr = "bg", alter = 0.4 },
        },
      },

      { FzfLuaNormal = { bg = { from = "NormalFloat", attr = "bg" } } },
      {
        FzfLuaBorder = {
          fg = { from = "WinSeparator", attr = "fg", alter = 0.2 },
          bg = { from = "NormalFloat", attr = "bg", alter = 0.1 },
        },
      },

      {
        FzfLuaTitle = {
          fg = { from = "Boolean", attr = "fg", alter = 0.2 },
          bg = { from = "NormalFloat", attr = "bg", alter = 0.1 },
        },
      },

      {
        FzfLuaPreviewBorder = {
          fg = { from = "FzfLuaBorder", attr = "fg", alter = 0.1 },
          bg = { from = "FzfluaBorder", attr = "bg" },
        },
      },

      { TelescopeNormal = { inherit = "FzfLuaNormal" } },
      { TelescopeBorder = { inherit = "FzfLuaBorder" } },
      { TelescopeTitle = { inherit = "FzfLuaTitle" } },
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

      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "fg", alter = 4 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.7 },
        },
      },
      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "bg", alter = 3 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.5 },
        },
      },

      {
        Tabline = {
          bg = { from = "StatusLine", attr = "bg", alter = 0.3 },
          fg = { from = "WinSeparator", attr = "fg", alter = 1 },
        },
      },
      {
        TablineSel = {
          bg = { from = "StatusLine", attr = "bg", alter = 1 },
          fg = { from = "WinSeparator", attr = "fg", alter = 0.8 },
        },
      },
      {
        Folded = {
          bg = { from = "Normal", attr = "bg", alter = 0.5 },
          fg = { from = "Normal", attr = "bg", alter = 2 },
        },
      },
    },
    ["apprentice"] = {
      {
        CmpItemAbbr = {
          fg = { from = "Normal", attr = "bg", alter = 1.5 },
          bg = "NONE",
        },
      },
      {
        FzfLuaBorder = {
          fg = { from = "WinSeparator", attr = "fg", alter = -0.1 },
          bg = { from = "NormalFloat", attr = "bg" },
        },
      },

      { TelescopeBorder = { inherit = "FzfLuaBorder" } },
      -- prompt
      { TelescopePromptBorder = { inherit = "FzfLuaBorder" } },
      { TelescopePromptPrefix = { inherit = "FzfLuaBorder" } },
      -- Preview
      { TelescopePreviewBorder = { inherit = "FzfLuaBorder" } },
      -- Results
      { TelescopeResultsBorder = { inherit = "FzfLuaBorder" } },

      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "fg", alter = 6 },
          bg = { from = "StatusLine", attr = "bg", alter = -0.5 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "bg", alter = 1.5 },
          bg = { from = "StatusLine", attr = "bg", alter = -0.2 },
        },
      },
      {
        Folded = {
          bg = { from = "Normal", attr = "bg", alter = 0.4 },
          fg = { from = "Normal", attr = "bg", alter = 1.2 },
        },
      },

      {
        MacthParentCur = {
          bg = { from = "Normal", attr = "bg", alter = 0.5 },
          fg = { from = "Normal", attr = "bg", alter = 2 },
        },
      },

      { MatchParen = { bg = "NONE", fg = "NONE", bold = false } },

      {
        QuickFixLine = {
          bg = { from = "StatusLine", attr = "bg", alter = 0.5 },
          fg = { from = "StatusLine", attr = "fg", alter = 0.4 },
          underline = false,
        },
      },

      { AerialLine = { bg = { from = "Normal", attr = "bg", alter = 0.5 }, fg = "NONE" } },

      { Visual = { bg = { from = "@Boolean", attr = "fg", alter = -0.6 } } },
      { CursorLine = { bg = "NONE" } },
      {
        CursorLineNr = {
          fg = { from = "Keyword", attr = "fg", alter = -0.2 },
          bg = { from = "LineNr", attr = "fg", alter = 0.5 },
          bold = true,
        },
      },
      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = 0.2 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      {
        LspReferenceText = {
          bg = { from = "LspReferenceText", attr = "bg", alter = -0.5 },
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
    },

    ["lackluster"] = {
      {
        Keyword = {
          fg = { from = "Keyword", attr = "fg", alter = 0.8 },
          bg = "NONE",
        },
      },
      {
        CmpItemAbbr = {
          fg = { from = "Normal", attr = "bg", alter = 7 },
          bg = "NONE",
        },
      },
      { Pmenu = { bg = { from = "Normal", attr = "bg", alter = 2 }, fg = { from = "CmpItemAbbr" } } },

      {
        PmenuSel = {
          bg = { from = "Keyword", attr = "fg", alter = -0.2 },
          fg = { from = "CmpItemAbbr", attr = "fg", alter = -0.6 },
          bold = true,
        },
      },

      { FzfLuaDirPart = { fg = { from = "Normal", attr = "fg", alter = -0.4 } } },
      { FzfLuaFilePart = { fg = { from = "Keyword", attr = "fg" }, reverse = false } },

      {
        FzfLuaSel = {
          bg = { from = "PmenuSel", alter = -0.4, attr = "bg" },
          fg = { from = "PmenuSel", alter = 0.3, attr = "bg" },
        },
      },

      { NormalFloat = { bg = { from = "Pmenu", alter = -0.1 } } },
      {
        FloatBorder = {
          bg = { from = "NormalFloat", attr = "bg" },
          fg = { from = "NormalFloat", attr = "bg", alter = 0.4 },
        },
      },

      { FzfLuaNormal = { bg = { from = "NormalFloat", attr = "bg", alter = 0.1 } } },
      {
        FzfLuaBorder = {
          fg = { from = "WinSeparator", attr = "fg", alter = 1.5 },
          bg = { from = "NormalFloat", attr = "bg", alter = 0.1 },
        },
      },

      {
        FzfLuaPreviewBorder = {
          fg = { from = "FzfLuaBorder", attr = "fg", alter = 0.1 },
          bg = { from = "FzfluaBorder", attr = "bg", alter = 0.1 },
        },
      },

      {
        FzfLuaTitle = {
          fg = { from = "Boolean", attr = "fg", alter = 0.2 },
          bg = { from = "NormalFloat", attr = "bg", alter = 0.1 },
        },
      },

      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = 0.8 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      { Visual = { bg = { from = "@Boolean", attr = "fg", alter = -0.6 } } },
      { CursorLine = { bg = { from = "Normal", attr = "bg", alter = 0.7 } } },
      {
        CursorLineNr = {
          fg = { from = "Keyword", attr = "fg", alter = -0.2 },
          bg = { from = "CursorLine", attr = "bg" },
          bold = true,
        },
      },

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
          bg = { from = "Normal", attr = "bg", alter = 1 },
          fg = { from = "Normal", attr = "bg", alter = 2 },
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
          fg = { from = "StatusLine", attr = "fg", alter = 4 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.5 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "bg", alter = 2 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.2 },
        },
      },

      {
        Tabline = {
          bg = { from = "StatusLine", attr = "bg", alter = -0.1 },
          fg = { from = "WinSeparator", attr = "fg", alter = 3 },
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
      { ["@punctuation.bracket"] = { fg = { from = "GitSignsChange", attr = "fg", alter = -0.2 } } },

      {
        QuickFixLine = {
          bg = { from = "Keyword", attr = "fg", alter = -0.5 },
          fg = { from = "Keyword", attr = "fg", alter = 0.8 },
          bold = true,
          underline = false,
        },
      },

      { Comment = { fg = { from = "Normal", attr = "bg", alter = -0.3 }, italic = true } },
      {
        Folded = {
          bg = { from = "Normal", attr = "bg", alter = -0.1 },
          fg = { from = "Normal", attr = "bg", alter = -0.2 },
        },
      },
      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = -0.2 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },
      { WinSeparator = { fg = { from = "LineNr", attr = "fg", alter = -0.1 }, bg = "NONE" } },
      {
        FloatBorder = {
          bg = { from = "Normal", attr = "bg", alter = -0.1 },
          fg = { from = "WinSeparator", attr = "fg", alter = 0.5 },
        },
      },
      { PmenuThumb = { bg = { from = "WinSeparator", attr = "fg", alter = 0.1 } } },
      { TreesitterContextSeparator = { fg = { from = "WinSeparator", attr = "fg", alter = -0.1 } } },
      {
        TreesitterContextSeparator = {
          fg = { from = "WinSeparator", attr = "fg", alter = 0.05 },
          bg = { from = "ColorColumn", attr = "bg" },
        },
      },
      { FzfLuaBorder = { fg = { from = "WinSeparator" }, bg = { from = "NormalFloat", attr = "bg" } } },
      { Visual = { bg = { from = "@Boolean", attr = "fg", alter = -0.6 } } },
      { CursorLine = { bg = { from = "Normal", attr = "bg", alter = -0.05 } } },
      {
        CursorLineNr = {
          fg = { from = "Keyword", attr = "fg", alter = -0.2 },
          bg = { from = "CursorLine", attr = "bg" },
          bold = true,
        },
      },

      { CmpItemAbbr = { fg = { from = "Normal", attr = "bg", alter = -0.5 }, bg = "NONE" } },
      { CmpItemAbbrMatchFuzzy = { fg = { from = "ErrorMsg", attr = "fg" } } },
      { CmpItemAbbrMatch = { fg = { from = "GitSignsDelete", attr = "fg", alter = -0.5 } } },
      { Pmenu = { bg = { from = "NormalFloat", attr = "bg", alter = -0.1 }, fg = { from = "CmpItemAbbr" } } },
      {
        PmenuSel = {
          bg = { from = "Normal", attr = "bg", alter = -0.4 },
          fg = { from = "CmpItemAbbr", attr = "fg", alter = 5 },
          bold = true,
          reverse = false,
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
          fg = { from = "StatusLine", attr = "bg", alter = 2 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.4 },
        },
      },
    },
    ["sweetie"] = {
      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = 0.1 } } },
      { Visual = { bg = { from = "@Boolean", attr = "fg", alter = -0.6 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      {
        CmpItemAbbr = {
          fg = { from = "Normal", attr = "bg", alter = 3 },
          bg = "NONE",
        },
      },
      { Pmenu = { bg = { from = "Normal", attr = "bg", alter = -0.2 }, fg = { from = "CmpItemAbbr" } } },
      {
        PmenuSel = {
          bg = { from = "Keyword", attr = "fg", alter = -0.2 },
          fg = { from = "CmpItemAbbr", attr = "fg", alter = -0.6 },
          bold = true,
        },
      },

      { NormalFloat = { bg = { from = "Pmenu", alter = 0.1 } } },
      {
        FloatBorder = {
          bg = { from = "NormalFloat", attr = "bg" },
          fg = { from = "NormalFloat", attr = "bg", alter = 0.4 },
        },
      },

      { FzfLuaNormal = { bg = { from = "NormalFloat", attr = "bg" } } },
      {
        FzfLuaBorder = {
          bg = { from = "NormalFloat", attr = "bg" },
          fg = { from = "NormalFloat", attr = "bg", alter = 1 },
        },
      },

      {
        FzfLuaTitle = {
          fg = { from = "Boolean", attr = "fg", alter = 0.2 },
          bg = { from = "NormalFloat", attr = "bg", alter = 0.1 },
        },
      },

      {
        FzfLuaPreviewBorder = {
          fg = { from = "FzfLuaBorder", attr = "fg", alter = 0.1 },
          bg = { from = "FzfluaBorder", attr = "bg" },
        },
      },

      { TelescopeNormal = { inherit = "FzfLuaNormal" } },
      { TelescopeBorder = { inherit = "FzfLuaBorder" } },
      { TelescopeTitle = { inherit = "FzfLuaTitle" } },
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

      {
        MyCodeUsage = {
          fg = { from = "Normal", attr = "bg", alter = 8 },
          bg = { from = "Visual", attr = "bg", alter = 1 },
          italic = true,
        },
      },

      {
        Folded = {
          bg = { from = "Normal", attr = "bg", alter = 0.2 },
          fg = { from = "Normal", attr = "bg", alter = 1 },
        },
      },
      { CursorLine = { bg = { from = "Normal", alter = 0.1 } } },
      {
        CursorLineNr = {
          fg = { from = "Keyword", attr = "fg", alter = -0.2 },
          bg = { from = "CursorLine", attr = "bg" },
          bold = true,
        },
      },

      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "bg", alter = 4 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.4 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "bg", alter = 2.2 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.4 },
        },
      },

      {
        Tabline = {
          bg = { from = "StatusLine", attr = "bg", alter = 0.1 },
          fg = { from = "WinSeparator", attr = "fg", alter = 0.3 },
        },
      },

      {
        TablineSel = {
          bg = { from = "StatusLine", attr = "bg", alter = 0.8 },
          fg = { from = "StatusLine", attr = "fg", alter = 0.1 },
        },
      },
    },
    ["neomodern"] = {
      { AerialGuide = { fg = { from = "Normal", attr = "bg", alter = 1 } } },
      {
        MyCodeUsage = {
          fg = { from = "Function", attr = "fg", alter = 1 },
          bg = { from = "Function", attr = "fg", alter = -0.15 },
          italic = true,
        },
      },
      {
        RenderMarkdownCode = {
          bg = { from = "Normal", attr = "bg", alter = 0.4 },
          -- fg = { from = "Normal", attr = "bg", alter = 0.5 },
        },
      },
      {
        Pmenu = {
          bg = { from = "Normal", attr = "bg", alter = 1 },
          fg = { from = "Normal", attr = "bg", alter = 0.5 },
        },
      },
      { NormalFloat = { bg = { from = "Pmenu", alter = -0.2 } } },
      {
        FloatBorder = {
          bg = { from = "NormalFloat", attr = "bg" },
          fg = { from = "NormalFloat", attr = "bg", alter = 0.8 },
        },
      },
      {
        CmpItemAbbr = {
          fg = { from = "Normal", attr = "bg", alter = 4.5 },
          bg = "NONE",
        },
      },

      { FzfLuaNormal = { bg = { from = "NormalFloat", attr = "bg" } } },
      {
        FzfLuaBorder = {
          fg = { from = "WinSeparator", attr = "fg", alter = 0.2 },
          bg = { from = "NormalFloat", attr = "bg" },
        },
      },
      {
        FzfLuaPreviewBorder = {
          fg = { from = "FzfLuaBorder", attr = "fg", alter = 0.1 },
          bg = { from = "FzfluaBorder", attr = "bg", alter = 0.05 },
        },
      },
      {
        FzfLuaTitle = {
          fg = { from = "Boolean", attr = "fg", alter = 0.2 },
          bg = { from = "NormalFloat", attr = "bg" },
        },
      },

      { TelescopeNormal = { inherit = "FzfLuaNormal" } },
      { TelescopeBorder = { inherit = "FzfLuaBorder" } },
      { TelescopeTitle = { inherit = "FzfLuaTitle" } },
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

      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = 0.25 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      { Visual = { bg = { from = "@Boolean", attr = "fg", alter = -0.6 } } },
      {
        Folded = {
          bg = { from = "Normal", attr = "bg", alter = 0.5 },
          fg = { from = "Normal", attr = "bg", alter = 2 },
        },
      },

      {
        QuickFixLine = {
          bg = { from = "Keyword", attr = "fg", alter = -0.5 },
          fg = { from = "Keyword", attr = "fg", alter = 0.8 },
          bold = true,
          underline = false,
        },
      },

      { CursorLine = { bg = "NONE" } },

      {
        LspReferenceText = {
          bg = { from = "Normal", attr = "bg", alter = 0.7 },
          fg = "NONE",
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },
      {
        LspReferenceWrite = {
          bg = { from = "Normal", attr = "bg", alter = 0.9 },
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },

      {
        LspReferenceRead = {
          bg = { from = "Normal", attr = "bg", alter = 0.9 },
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },

      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "fg", alter = 6 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.4 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "bg", alter = 2 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.2 },
        },
      },

      {
        Tabline = {
          bg = { from = "LineNr", attr = "fg", alter = -0.1 },
          fg = { from = "WinSeparator", attr = "fg", alter = 1 },
        },
      },

      {
        TablineSel = {
          bg = { from = "LineNr", attr = "fg", alter = 0.8 },
          fg = { from = "StatusLine", attr = "fg", alter = 0.1 },
        },
      },
    },
    ["farout"] = {
      { CmpItemAbbr = { fg = { from = "Normal", attr = "bg", alter = 9 }, bg = "NONE" } },
      { Pmenu = { bg = { from = "Normal", attr = "bg", alter = 2 }, fg = { from = "CmpItemAbbr" } } },

      { NormalFloat = { bg = { from = "Pmenu", alter = -0.2 } } },
      {
        FloatBorder = {
          bg = { from = "NormalFloat", attr = "bg" },
          fg = { from = "NormalFloat", attr = "bg", alter = 0.8 },
        },
      },

      { FzfLuaNormal = { bg = { from = "NormalFloat", attr = "bg" } } },

      {
        FloatBorder = {
          bg = { from = "Pmenu", attr = "bg", alter = -0.3 },
          fg = { from = "WinSeparator", attr = "fg", alter = 0.5 },
        },
      },
      {
        FzfLuaBorder = {
          fg = { from = "WinSeparator", attr = "fg", alter = 1 },
          bg = { from = "NormalFloat", attr = "bg" },
        },
      },
      {
        FzfLuaPreviewBorder = {
          bg = { from = "FzfluaBorder", attr = "bg" },
          fg = { from = "FzfluaBorder", attr = "bg", alter = 0.8 },
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

      { TelescopeNormal = { inherit = "FzfLuaNormal" } },
      { TelescopeBorder = { inherit = "FzfLuaBorder" } },
      { TelescopeTitle = { inherit = "FzfLuaTitle" } },
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

      { WinSeparator = { fg = { from = "LineNr", attr = "fg", alter = 1 }, bg = "NONE" } },

      {
        Folded = {
          bg = { from = "Normal", attr = "bg", alter = 1.5 },
          fg = { from = "Normal", attr = "bg", alter = 3 },
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
      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "bg", alter = 5 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.5 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "bg", alter = 2 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.2 },
        },
      },
      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = 1.6 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      { qfFileName = { fg = { from = "qfFileName", attr = "fg", alter = 0.3 } } },

      { CursorLine = { bg = "NONE" } },
      {
        CursorLineNr = {
          fg = { from = "Keyword", attr = "fg", alter = -0.2 },
          bg = { from = "LineNr", attr = "fg", alter = 0.5 },
          bold = true,
        },
      },
      {
        MyParentHint = {
          bg = { from = "CursorLine", attr = "bg" },
          fg = { from = "MyCodeUsage", attr = "fg", alter = 0.7 },
        },
      },

      {
        Tabline = {
          bg = { from = "StatusLine", attr = "bg", alter = -0.1 },
          fg = { from = "WinSeparator", attr = "fg", alter = 1 },
        },
      },

      {
        TablineSel = {
          bg = { from = "StatusLine", attr = "bg", alter = 0.8 },
          fg = { from = "StatusLine", attr = "fg", alter = 0.1 },
        },
      },
    },
    ["miasma"] = {
      {
        CmpItemAbbr = {
          fg = { from = "Normal", attr = "bg", alter = 2 },
          bg = "NONE",
        },
      },
      { Pmenu = { bg = { from = "Normal", attr = "bg", alter = -0.3 }, fg = { from = "CmpItemAbbr", attr = "fg" } } },

      {
        PmenuSel = {
          bg = { from = "Keyword", attr = "fg", alter = -0.2 },
          fg = { from = "CmpItemAbbr", attr = "fg", alter = -0.6 },
          bold = true,
        },
      },

      { NormalFloat = { bg = { from = "Pmenu", alter = -0.3 }, fg = { from = "Normal", attr = "bg", alter = 4 } } },
      {
        FloatBorder = {
          bg = { from = "NormalFloat", attr = "bg" },
          fg = { from = "NormalFloat", attr = "bg", alter = 2 },
        },
      },

      { FzfLuaNormal = { bg = { from = "NormalFloat", attr = "bg", alter = 0.1 } } },
      {
        FzfLuaBorder = {
          fg = { from = "WinSeparator", attr = "fg", alter = -0.4 },
          bg = { from = "NormalFloat", attr = "bg", alter = 0.1 },
        },
      },

      {
        FzfLuaTitle = {
          fg = { from = "Boolean", attr = "fg", alter = 0.2 },
          bg = { from = "NormalFloat", attr = "bg", alter = 0.1 },
        },
      },

      { TelescopeNormal = { inherit = "FzfLuaNormal" } },
      { TelescopeBorder = { inherit = "FzfLuaBorder" } },
      { TelescopeTitle = { inherit = "FzfLuaTitle" } },
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

      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = 0.1 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      { FoldColumn = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 0.28 } } },
      {
        qfFileName = {
          fg = { from = "Directory", attr = "fg" },
          bg = "NONE",
        },
      },

      {
        QuickFixLine = {
          fg = { from = "Normal", attr = "fg", alter = 0.2 },
          bg = { from = "Keyword", attr = "fg", alter = -0.5 },
          underline = false,
        },
      },

      {
        MyCodeUsage = {
          fg = { from = "Normal", attr = "bg", alter = -0.5 },
          bg = { from = "LineNr", attr = "fg", alter = 1 },
          italic = true,
        },
      },

      { String = { fg = { from = "String", attr = "fg", alter = 0.4 } } },
      { Comment = { fg = { from = "Comment", attr = "fg", alter = -0.3 } } },
      { ["@org.agenda.scheduled"] = { fg = { from = "@tag.attribute", attr = "fg", alter = 0.2 } } },
      {
        Folded = {
          bg = { from = "Normal", attr = "bg", alter = 0.4 },
          fg = { from = "Normal", attr = "bg", alter = 1.6 },
        },
      },
      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "fg", alter = 3 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.5 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "bg", alter = 2 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.2 },
        },
      },
      {
        Tabline = {
          bg = { from = "Normal", attr = "bg", alter = 0.5 },
          fg = { from = "WinSeparator", attr = "fg", alter = 0.5 },
        },
      },

      {
        TablineSel = {
          bg = { from = "StatusLine", attr = "bg", alter = 0.8 },
          fg = { from = "StatusLine", attr = "fg", alter = 0.1 },
        },
      },
      {
        LspReferenceText = {
          fg = "NONE",
          undercurl = false,
          bold = false,
          bg = { from = "LspReferenceText", attr = "bg", alter = -0.2 },
        },
      },
      {
        LspReferenceWrite = {
          fg = "NONE",
          italic = true,
          undercurl = false,
          bold = false,
          bg = { from = "LspReferenceText" },
        },
      },
      { LspReferenceRead = { fg = "NONE", undercurl = false, bold = false, bg = { from = "LspReferenceText" } } },
    },
    ["flow"] = {
      {
        MyCodeUsage = {
          fg = { from = "LineNr", attr = "fg", alter = 1 },
          bg = { from = "LineNr", attr = "fg", alter = -0.15 },
          italic = true,
        },
      },

      { Pmenu = { bg = { from = "Normal", attr = "bg", alter = -0.2 }, fg = { from = "CmpItemAbbr" } } },
      {
        PmenuSel = {
          bg = { from = "Keyword", attr = "fg", alter = -0.2 },
          fg = { from = "CmpItemAbbr", attr = "fg", alter = -0.6 },
          bold = true,
        },
      },

      { NormalFloat = { bg = { from = "Pmenu", alter = -0.1 } } },
      {
        FloatBorder = {
          bg = { from = "NormalFloat", attr = "bg" },
          fg = { from = "NormalFloat", attr = "bg", alter = 0.8 },
        },
      },

      { FzfLuaNormal = { bg = { from = "NormalFloat", attr = "bg" } } },
      {
        FzfLuaBorder = {
          bg = { from = "NormalFloat", attr = "bg" },
          fg = { from = "WinSeparator", attr = "fg", alter = -0.5 },
        },
      },

      {
        FzfLuaTitle = {
          fg = { from = "Boolean", attr = "fg", alter = 0.2 },
          bg = { from = "NormalFloat", attr = "bg", alter = 0.1 },
        },
      },

      {
        FzfLuaPreviewBorder = {
          bg = { from = "FzfluaBorder", attr = "bg" },
          fg = { from = "FzfluaBorder", attr = "bg", alter = 0.7 },
        },
      },

      { TelescopeNormal = { inherit = "FzfLuaNormal" } },
      { TelescopeBorder = { inherit = "FzfLuaBorder" } },
      { TelescopeTitle = { inherit = "FzfLuaTitle" } },
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

      {
        QuickFixLine = {
          bg = { from = "StatusLine", attr = "bg", alter = 3 },
          fg = { from = "StatusLine", attr = "bg", alter = 6 },
          underline = false,
        },
      },

      {
        Visual = {
          fg = { from = "IncSearch", attr = "bg", alter = 12 },
          bg = { from = "IncSearch", attr = "bg", alter = -0.6 },
        },
      },

      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = 0.1 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "bg", alter = 5 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.5 },
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
          bg = { from = "StatusLine", attr = "bg", alter = 0.2 },
          fg = { from = "WinSeparator", attr = "fg", alter = 1 },
        },
      },
      {
        TablineSel = {
          bg = { from = "StatusLine", attr = "bg", alter = 0.8 },
          fg = { from = "StatusLine", attr = "fg", alter = 0.1 },
        },
      },
    },
    ["solarized-osaka"] = {
      { AerialGuide = { fg = { from = "Normal", attr = "bg", alter = 1 } } },

      {
        CmpItemAbbr = {
          fg = { from = "Normal", attr = "bg", alter = 5 },
          bg = "NONE",
        },
      },
      { Pmenu = { bg = { from = "Normal", attr = "bg", alter = 1 }, fg = { from = "CmpItemAbbr", attr = "fg" } } },

      {
        PmenuSel = {
          bg = { from = "Keyword", attr = "fg", alter = -0.2 },
          fg = { from = "CmpItemAbbr", attr = "fg", alter = -0.6 },
          bold = true,
          reverse = false,
        },
      },

      { NormalFloat = { bg = { from = "Pmenu", alter = 0.1 }, fg = { from = "Pmenu", attr = "fg", alter = 0.5 } } },

      {
        FloatBorder = {
          bg = { from = "NormalFloat", attr = "bg" },
          fg = { from = "NormalFloat", attr = "bg", alter = 1 },
        },
      },

      { FzfLuaNormal = { bg = { from = "NormalFloat", attr = "bg" } } },
      {
        FzfLuaBorder = {
          bg = { from = "NormalFloat", attr = "bg" },
          fg = { from = "WinSeparator", attr = "fg", alter = 0.8 },
        },
      },

      {
        FzfLuaPreviewBorder = {
          bg = { from = "FzfluaBorder", attr = "bg" },
          fg = { from = "FzfluaBorder", attr = "bg", alter = 0.7 },
        },
      },

      {
        FzfLuaTitle = {
          fg = { from = "Boolean", attr = "fg", alter = 0.2 },
          bg = { from = "NormalFloat", attr = "bg", alter = 0.1 },
        },
      },

      { TelescopeNormal = { inherit = "FzfLuaNormal" } },
      { TelescopeBorder = { inherit = "FzfLuaBorder" } },
      { TelescopeTitle = { inherit = "FzfLuaTitle" } },
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

      {
        MyCodeUsage = {
          fg = { from = "Normal", attr = "bg", alter = 8 },
          bg = { from = "Visual", attr = "bg", alter = 0.8 },
          italic = true,
        },
      },
      {
        FoldColumn = {
          bg = "NONE",
          fg = { from = "Normal", attr = "bg", alter = 0.7 },
        },
      },
      {
        Folded = {
          bg = { from = "Normal", attr = "bg", alter = 0.7 },
          fg = { from = "Normal", attr = "bg", alter = 1.6 },
        },
      },
      { TroubleNormal = { inherit = "Normal" } },

      {
        ["@markup.raw.markdown_inline"] = {
          bg = { from = "Normal", attr = "bg", alter = -0.2 },
          fg = { from = "ErrorMsg", attr = "fg" },
        },
      },

      {
        RenderMarkdownCode = {
          bg = { from = "Normal", attr = "bg", alter = 0.8 },
          -- fg = { from = "Normal", attr = "bg", alter = 0.5 },
        },
      },

      { LineNr = { fg = { from = "Normal", attr = "bg", alter = 1.5 }, bg = { from = "Normal", attr = "bg" } } },
      { CursorLine = { bg = { from = "Normal", alter = 0.4 } } },
      {
        CursorLineNr = {
          fg = { from = "Keyword", attr = "fg", alter = -0.2 },
          bg = { from = "CursorLine", attr = "bg" },
          bold = true,
        },
      },
      {
        MyParentHint = {
          bg = { from = "CursorLine", attr = "bg" },
          fg = { from = "LineNr", attr = "fg", alter = 1 },
        },
      },

      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "bg", alter = 3 },
          bg = { from = "StatusLine", attr = "bg", alter = -0.2 },
        },
      },
      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "bg", alter = 2 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.2 },
        },
      },
      {
        Tabline = {
          bg = { from = "StatusLine", attr = "bg", alter = 0.3 },
          fg = { from = "WinSeparator", attr = "fg", alter = 2 },
        },
      },

      {
        TablineSel = {
          bg = { from = "StatusLine", attr = "bg", alter = 0.8 },
          fg = { from = "StatusLine", attr = "fg", alter = 0.1 },
        },
      },
    },
    ["selenized"] = {
      { ErrorMsg = { fg = "red" } },
      { CodeLine1 = { fg = { from = "Error", attr = "fg" } } },
      { ["@lsp.type.selfKeyword"] = { fg = { from = "Error", attr = "fg", alter = 0.2 } } },
      { FzfLuaCursorLine = { bg = { from = "Error", alter = -0.8, attr = "fg" } } },

      {
        MyCodeUsage = {
          fg = { from = "LineNr", attr = "fg", alter = 4 },
          bg = { from = "Visual", attr = "bg", alter = 0.8 },
          italic = true,
        },
      },

      { Comment = { fg = { from = "Normal", attr = "bg", alter = 1 } } },
      {
        Folded = {
          bg = { from = "Normal", attr = "bg", alter = 0.2 },
          fg = { from = "Normal", attr = "bg", alter = 2 },
        },
      },
      {
        Directory = {
          fg = { from = "WinSeparator", attr = "fg", alter = 4 },
        },
      },
      { CmpItemAbbr = { fg = { from = "Normal", attr = "bg", alter = 2 }, bg = "NONE" } },

      {
        CmpItemAbbr = {
          fg = { from = "Normal", attr = "bg", alter = 1.5 },
          bg = "NONE",
        },
      },
      { Pmenu = { bg = { from = "Normal", attr = "bg", alter = -0.3 }, fg = { from = "CmpItemAbbr" } } },
      {
        PmenuSel = {
          bg = { from = "Keyword", attr = "fg", alter = -0.2 },
          fg = { from = "CmpItemAbbr", attr = "fg", alter = -0.6 },
          bold = true,
        },
      },

      { CmpItemAbbrMatchFuzzy = { fg = { from = "Error", attr = "fg", alter = 5 } } },
      { NormalFloat = { bg = { from = "Pmenu", alter = -0.1 }, fg = { from = "Pmenu", alter = 0.2 } } },
      {
        FloatBorder = {
          bg = { from = "NormalFloat", attr = "bg" },
          fg = { from = "NormalFloat", attr = "bg", alter = 0.8 },
        },
      },

      { FzfLuaNormal = { bg = { from = "NormalFloat", attr = "bg" } } },
      {
        FzfLuaBorder = {
          fg = { from = "WinSeparator", attr = "fg", alter = -0.5 },
          bg = { from = "NormalFloat", attr = "bg" },
        },
      },

      {
        FzfLuaTitle = {
          fg = { from = "Boolean", attr = "fg", alter = 0.2 },
          bg = { from = "NormalFloat", attr = "bg", alter = 0.1 },
        },
      },

      {
        FzfLuaPreviewBorder = {
          bg = { from = "FzfluaBorder", attr = "bg" },
          fg = { from = "FzfluaBorder", attr = "bg", alter = 0.7 },
        },
      },

      { MatchParen = { bg = { from = "Normal", attr = "bg", alter = 0.2 }, fg = "NONE", bold = false } },

      { TelescopeNormal = { inherit = "FzfLuaNormal" } },
      { TelescopeBorder = { inherit = "FzfLuaBorder" } },
      { TelescopeTitle = { inherit = "FzfLuaTitle" } },
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

      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = 0.1 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      {
        LspCodeLens = {
          bg = { from = "Normal", attr = "bg", alter = -0.05 },
          fg = { from = "Comment", attr = "fg", alter = -0.1 },
          italic = true,
        },
      },
      { Visual = { bg = { from = "Visual", attr = "bg", alter = 0.2 } } },

      {
        MyParentHint = {
          bg = { from = "CursorLine", attr = "bg" },
          fg = { from = "LineNr", attr = "fg", alter = 0.2 },
        },
      },
      {
        FoldColumn = {
          bg = "NONE",
          fg = { from = "Normal", attr = "bg", alter = 0.25 },
        },
      },

      {
        Tabline = {
          bg = { from = "StatusLine", attr = "bg", alter = 0.2 },
          fg = { from = "WinSeparator", attr = "fg", alter = 0.5 },
        },
      },

      {
        TablineSel = {
          bg = { from = "StatusLine", attr = "bg", alter = 0.8 },
          fg = { from = "StatusLine", attr = "fg", alter = 0.5 },
        },
      },

      {
        StatusLine = {
          fg = { from = "WinSeparator", attr = "fg", alter = 1 },
          bg = { from = "StatusLine", attr = "bg", alter = -0.3 },
          reverse = false,
        },
      },
      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "bg", alter = 2.5 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.5 },
        },
      },
    },
    ["tokyonight-storm"] = {
      { FzfLuaFzfNormal = { fg = { from = "Keyword", attr = "fg", alter = -0.3 } } },
      { FzfLuaDirPart = { fg = { from = "Normal", attr = "fg", alter = -0.2 } } },

      {
        CmpItemAbbr = {
          fg = { from = "Normal", attr = "bg", alter = 2.5 },
          bg = "NONE",
          reverse = false,
        },
      },

      { Pmenu = { bg = { from = "Normal", attr = "bg", alter = -0.2 }, fg = { from = "CmpItemAbbr" } } },
      {
        PmenuSel = {
          bg = { from = "Keyword", attr = "fg", alter = -0.5 },
          fg = { from = "Normal", attr = "bg", alter = -0.5 },
          bold = true,
          reverse = false,
        },
      },

      { NormalFloat = { bg = { from = "Pmenu", alter = -0.1 }, fg = { from = "Pmenu", alter = 0.4 } } },
      {
        FloatBorder = {
          bg = { from = "NormalFloat", attr = "bg" },
          fg = { from = "NormalFloat", attr = "bg", alter = 0.8 },
        },
      },

      { FzfLuaNormal = { bg = { from = "NormalFloat", attr = "bg" } } },
      {
        FzfLuaBorder = {
          bg = { from = "NormalFloat", attr = "bg" },
          fg = { from = "WinSeparator", attr = "fg", alter = -0.4 },
        },
      },

      {
        FzfLuaPreviewBorder = {
          fg = { from = "FzfLuaBorder", attr = "fg", alter = 0.1 },
          bg = { from = "FzfluaBorder", attr = "bg" },
        },
      },

      {
        FzfLuaTitle = {
          fg = { from = "Boolean", attr = "fg", alter = 0.2 },
          bg = { from = "NormalFloat", attr = "bg", alter = 0.1 },
        },
      },

      { TelescopeNormal = { inherit = "FzfLuaNormal" } },
      { TelescopeBorder = { inherit = "FzfLuaBorder" } },
      { TelescopeTitle = { inherit = "FzfLuaTitle" } },
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

      { WinSeparator = { fg = { from = "Keyword", attr = "fg", alter = -0.6 }, bg = "NONE" } },

      { LineNr = { bg = "NONE", fg = { from = "LineNr", attr = "fg", alter = 0.2 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      {
        MyCodeUsage = {
          fg = { from = "Visual", attr = "bg", alter = 7 },
          bg = { from = "Visual", attr = "bg", alter = 0.7 },
          italic = true,
        },
      },

      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "bg", alter = 6 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.2 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "bg", alter = 2.5 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.4 },
        },
      },

      {
        Tabline = {
          bg = { from = "StatusLine", attr = "bg", alter = 0.4 },
          fg = { from = "WinSeparator", attr = "fg", alter = 0.5 },
        },
      },

      {
        TablineSel = {
          bg = { from = "StatusLine", attr = "bg", alter = 0.8 },
          fg = { from = "StatusLine", attr = "fg", alter = 0.1 },
        },
      },
    },
    ["tokyonight-night"] = {
      { FzfLuaFzfNormal = { fg = { from = "Keyword", attr = "fg" } } },
      { FzfLuaDirPart = { fg = { from = "Normal", attr = "bg", alter = 3 } } },

      {
        CmpItemAbbr = {
          fg = { from = "Normal", attr = "bg", alter = 2.5 },
          bg = "NONE",
          reverse = false,
        },
      },

      { Pmenu = { bg = { from = "Normal", attr = "bg", alter = -0.2 }, fg = { from = "CmpItemAbbr" } } },
      {
        PmenuSel = {
          bg = { from = "ErrorMsg", attr = "fg", alter = -0.2 },
          fg = { from = "Normal", attr = "bg", alter = -0.1 },
          bold = true,
          reverse = false,
        },
      },

      {
        FzfLuaSel = {
          bg = { from = "PmenuSel", alter = -0.4, attr = "bg" },
          fg = { from = "Keyword", alter = 0.1, attr = "fg" },
        },
      },

      { NormalFloat = { bg = { from = "Pmenu", alter = -0.1 }, fg = { from = "Pmenu", alter = 0.4 } } },
      {
        FloatBorder = {
          bg = { from = "NormalFloat", attr = "bg" },
          fg = { from = "NormalFloat", attr = "bg", alter = 0.8 },
        },
      },

      { FzfLuaNormal = { bg = { from = "NormalFloat", attr = "bg" } } },
      {
        FzfLuaBorder = {
          bg = { from = "NormalFloat", attr = "bg", alter = 0.1 },
          fg = { from = "WinSeparator", attr = "fg", alter = -0.4 },
        },
      },

      {
        FzfLuaPreviewBorder = {
          fg = { from = "FzfLuaBorder", attr = "fg", alter = 0.1 },
          bg = { from = "FzfluaBorder", attr = "bg" },
        },
      },

      {
        FzfLuaTitle = {
          fg = { from = "Boolean", attr = "fg", alter = 0.2 },
          bg = { from = "NormalFloat", attr = "bg", alter = 0.1 },
        },
      },

      { TelescopeNormal = { inherit = "FzfLuaNormal" } },
      { TelescopeBorder = { inherit = "FzfLuaBorder" } },
      { TelescopeTitle = { inherit = "FzfLuaTitle" } },
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

      { WinSeparator = { fg = { from = "Keyword", attr = "fg", alter = -0.7 }, bg = "NONE" } },
      { MatchParen = { bg = { from = "MatchParen", attr = "bg", alter = -0.1 }, fg = "NONE", bold = false } },

      { LineNr = { bg = "NONE", fg = { from = "LineNr", attr = "fg", alter = 0.2 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      {
        MyCodeUsage = {
          fg = { from = "Visual", attr = "bg", alter = 7 },
          bg = { from = "Visual", attr = "bg", alter = 0.7 },
          italic = true,
        },
      },

      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "bg", alter = 6 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.2 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "bg", alter = 4 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.6 },
        },
      },

      {
        Tabline = {
          bg = { from = "StatusLine", attr = "bg", alter = 0.8 },
          fg = { from = "WinSeparator", attr = "fg", alter = 1 },
        },
      },

      {
        TablineSel = {
          bg = { from = "StatusLine", attr = "bg", alter = 0.8 },
          fg = { from = "StatusLine", attr = "fg", alter = 0.1 },
        },
      },
    },

    ["doom-one"] = {
      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = 0.15 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      {
        FzfLuaBorder = {
          fg = { from = "WinSeparator", attr = "fg", alter = -0.2 },
          bg = { from = "NormalFloat", attr = "bg" },
        },
      },

      { TelescopeBorder = { inherit = "FzfLuaBorder" } },
      -- prompt
      { TelescopePromptBorder = { inherit = "FzfLuaBorder" } },
      { TelescopePromptPrefix = { inherit = "FzfLuaBorder" } },
      -- Preview
      { TelescopePreviewBorder = { inherit = "FzfLuaBorder" } },
      -- Results
      { TelescopeResultsBorder = { inherit = "FzfLuaBorder" } },

      {
        Folded = {
          bg = { from = "Normal", attr = "bg", alter = 0.5 },
          fg = { from = "Normal", attr = "bg", alter = 1.6 },
        },
      },
      { CursorLine = { bg = "NONE" } },
      {
        CursorLineNr = {
          fg = { from = "Keyword", attr = "fg", alter = -0.2 },
          bg = { from = "LineNr", attr = "fg", alter = 0.2 },
          bold = true,
        },
      },

      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "bg", alter = 6 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.2 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "bg", alter = 3 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.4 },
        },
      },

      {
        Tabline = {
          bg = { from = "StatusLine", attr = "bg", alter = 0.2 },
          fg = { from = "WinSeparator", attr = "fg", alter = 0.3 },
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
      {
        Folded = {
          bg = { from = "Normal", attr = "bg", alter = 0.7 },
          fg = { from = "Normal", attr = "bg", alter = 1.6 },
        },
      },

      {
        FzfLuaBorder = {
          fg = { from = "WinSeparator", attr = "fg", alter = -0.4 },
          bg = { from = "NormalFloat", attr = "bg", alter = 0.1 },
        },
      },

      {
        FzfLuaPreviewBorder = {
          fg = { from = "FzfLuaBorder", attr = "fg", alter = 0.1 },
          bg = { from = "FzfluaBorder", attr = "bg" },
        },
      },

      { TelescopeBorder = { inherit = "FzfLuaBorder" } },
      -- prompt
      { TelescopePromptBorder = { inherit = "FzfLuaBorder" } },
      { TelescopePromptPrefix = { inherit = "FzfLuaBorder" } },
      -- Preview
      { TelescopePreviewBorder = { inherit = "FzfLuaBorder" } },
      -- Results
      { TelescopeResultsBorder = { inherit = "FzfLuaBorder" } },

      {
        LineNr = {
          fg = { from = "LineNr", attr = "fg", alter = 0.3 },
          bg = "NONE",
        },
      },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      { Comment = { fg = { from = "Comment", alter = -0.3 } } },
      -- { CursorLine = { bg = { from = "Normal", alter = 0.3 } } },
      { CursorLine = { bg = "NONE" } },
      {
        CursorLineNr = {
          fg = { from = "Keyword", attr = "fg", alter = 0.2 },
          bg = { from = "LineNr", attr = "fg", alter = 0.5 },
          -- bg = { from = "CursorLine", attr = "bg" },
          bold = true,
        },
      },

      {
        MyParentHint = {
          bg = { from = "CursorLine", attr = "bg" },
          fg = { from = "MyCodeUsage", attr = "fg", alter = -0.1 },
        },
      },

      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "bg", alter = 6 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.8 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "bg", alter = 3 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.4 },
        },
      },

      {
        Tabline = {
          bg = { from = "StatusLine", attr = "bg", alter = 0.2 },
          fg = { from = "WinSeparator", attr = "fg", alter = 0.3 },
        },
      },

      {
        TablineSel = {
          bg = { from = "StatusLine", attr = "bg", alter = 0.8 },
          fg = { from = "StatusLine", attr = "fg", alter = 0.1 },
        },
      },
    },
    ["tender"] = {
      { CursorLine = { bg = { from = "Normal", alter = 0.1 } } },
      { CursorLineNr = { bg = { from = "CursorLine", attr = "bg" } } },

      {
        FzfLuaBorder = {
          fg = { from = "WinSeparator", attr = "fg", alter = -0.2 },
          bg = { from = "NormalFloat", attr = "bg" },
        },
      },

      {
        FzfLuaPreviewBorder = {
          fg = { from = "FzfLuaBorder", attr = "fg", alter = 0.1 },
          bg = { from = "FzfluaBorder", attr = "bg" },
        },
      },

      { TelescopeBorder = { inherit = "FzfLuaBorder" } },
      -- prompt
      { TelescopePromptBorder = { inherit = "FzfLuaBorder" } },
      { TelescopePromptPrefix = { inherit = "FzfLuaBorder" } },
      -- Preview
      { TelescopePreviewBorder = { inherit = "FzfLuaBorder" } },
      -- Results
      { TelescopeResultsBorder = { inherit = "FzfLuaBorder" } },

      { LineNr = { bg = "NONE", fg = { from = "LineNr", attr = "fg", alter = 0.1 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },
      {
        Folded = {
          -- bg = { from = "Normal", attr = "bg", alter = 0.7 },
          fg = { from = "Normal", attr = "bg", alter = 1.6 },
        },
      },

      {
        MyCodeUsage = {
          fg = { from = "Visual", attr = "bg", alter = 8 },
          bg = { from = "Visual", attr = "bg", alter = 0.8 },
          italic = true,
        },
      },

      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "bg", alter = 2 },
          bg = { from = "StatusLine", attr = "bg", alter = -0.4 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "bg", alter = 2 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.1 },
        },
      },

      {
        Tabline = {
          bg = { from = "StatusLine", attr = "bg", alter = 0.1 },
          fg = { from = "WinSeparator", attr = "fg", alter = 0.5 },
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
      { DiagnosticUnderlineWarn = { undercurl = true, sp = { from = "DiagnosticWarn", attr = "fg" } } },
      { DiagnosticUnderlineHint = { undercurl = true, sp = { from = "DiagnosticHint", attr = "fg" } } },
      { DiagnosticUnderlineError = { undercurl = true, sp = { from = "DiagnosticError", attr = "fg" } } },
      { DiagnosticUnderlineInfo = { undercurl = true, sp = { from = "DiagnosticInfo", attr = "fg" } } },

      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = 0.2 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      {
        StatusLine = {
          fg = { from = "Normal", attr = "fg", alter = 0.4 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.5 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "bg", alter = 3 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.2 },
        },
      },

      {
        Tabline = {
          bg = { from = "StatusLine", attr = "bg", alter = 0.1 },
          fg = { from = "WinSeparator", attr = "fg", alter = 0.6 },
        },
      },

      {
        TablineSel = {
          bg = { from = "StatusLine", attr = "bg", alter = 0.5 },
          fg = { from = "StatusLine", attr = "fg", alter = 0.1 },
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
