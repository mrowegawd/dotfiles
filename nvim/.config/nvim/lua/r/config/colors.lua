local UIPallette = require("r.utils").uisec

local Highlight = require "r.settings.highlights"

local dark_green = Highlight.tint(UIPallette.palette.green, 0.3)
local dark_yellow = Highlight.tint(UIPallette.palette.bright_yellow, 0.3)
local dark_red = Highlight.tint(UIPallette.palette.dark_red, 0.3)
local light_red = Highlight.tint(UIPallette.palette.pale_red, 0.3)

local base = Highlight.get("Normal", "bg")

local general_overrides = function()
  Highlight.all {
    { FoldColumn = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 0.4 } } },
    { FoldColumn1 = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 1 } } },
    { ColorColumn = { bg = { from = "Normal", attr = "bg", alter = -0.1 } } },
    { LineNr = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 0.8 } } },
    { CursorLine = { bg = { from = "Keyword", attr = "fg", alter = -0.75 } } },
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
        fg = { from = "Normal", attr = "bg", alter = 1 },
        bg = { from = "Normal", attr = "bg", alter = 0.4 },
      },
    },
    { EndOfBuffer = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 0.2 } } },
    { SignColumn = { bg = "NONE" } },
    { NonText = { fg = { from = "Normal", attr = "fg", alter = -0.4 } } },
    { WinSeparator = { fg = { from = "Normal", attr = "bg", alter = 0.4 }, bg = "NONE" } },
    { WinBar = { bg = { from = "ColorColumn" }, fg = { from = "Normal", attr = "bg", alter = 1 } } },
    { WinBarNC = { bg = { from = "ColorColumn", attr = "bg" }, fg = { from = "WinBar", attr = "fg" } } },
    { PmenuThumb = { bg = { from = "WinSeparator", attr = "fg", alter = 0.1 } } },
    { QuickFixLine = { bg = { from = "CursorLine", attr = "bg", alter = 0.5 }, underline = false } },
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
        fg = { from = "Normal", attr = "bg", alter = 0.8 },
        bg = { from = "Normal", attr = "bg", alter = -0.2 },
      },
    },
    {
      PmenuSel = {
        fg = "NONE",
        bg = { from = "Keyword", attr = "fg", alter = -0.7 },
        bold = true,
      },
    },
    { NormalFloat = { bg = { from = "Pmenu", alter = -0.2 } } },
    {
      FloatBorder = {
        fg = { from = "NormalFloat", attr = "bg", alter = 1 },
        bg = { from = "NormalFloat", attr = "bg" },
      },
    },
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
    -- { diffBDiffer = { link = 'WarningMsg' } },
    -- { diffCommon = { link = 'WarningMsg' } },
    -- { diffDiffer = { link = 'WarningMsg' } },
    -- { diffFile = { link = 'Directory' } },
    -- { diffIdentical = { link = 'WarningMsg' } },
    -- { diffIndexLine = { link = 'Number' } },
    -- { diffIsA = { link = 'WarningMsg' } },
    -- { diffNoEOL = { link = 'WarningMsg' } },
    -- { diffOnly = { link = 'WarningMsg' } },

    { diffAdd = { bg = Highlight.darken(dark_green, 0.3, base), fg = "NONE", bold = true } },
    { diffChange = { bg = Highlight.darken(dark_yellow, 0.4, base), fg = "NONE", bold = true } },
    -- stylua: ignore
    { diffDelete = { bg = Highlight.darken(dark_red, 0.1, base), fg = Highlight.darken(dark_red, 0.2, base), bold = true, }, },
    { diffText = { bg = Highlight.darken(light_red, 0.3, base), fg = "NONE", bold = true } },

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
    -----------------------------------------------------------------------
    -- DEBUG
    -----------------------------------------------------------------------
    { debugPC = { bg = { from = "Boolean", attr = "fg", alter = -0.6 }, fg = "NONE", bold = true } },

    -----------------------------------------------------------------------
    -- DIAGNOSTIC
    -----------------------------------------------------------------------
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
    {
      ["@markup.strong.markdown_inline"] = {
        fg = { from = "Normal", attr = "fg", alter = 0.5 },
        bg = { from = "Normal", attr = "bg", alter = 0.2 },
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
      CmpItemIconWarningMsg = {
        fg = { from = "WarningMsg", attr = "fg" },
        bg = { from = "NormalFloat", attr = "bg" },
      },
    },
    {
      CmpItemFloatBorder = {
        fg = { from = "FloatBorder", attr = "fg", alter = 0.2 },
        bg = { from = "Pmenu", attr = "bg" },
      },
    },
    {
      CmpItemAbbr = {
        fg = { from = "Keyword", attr = "fg", alter = -0.3 },
        bg = "NONE",
      },
    },
    { CmpItemAbbrMatchFuzzy = { fg = { from = "Boolean", attr = "fg" } } },
    { CmpItemAbbrMatch = { fg = { from = "Boolean", attr = "fg" } } },

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
        fg = { from = "FloatBorder", attr = "fg" },
        bg = { from = "NormalFloat", attr = "bg" },
      },
    },
    { FzfLuaPreviewNormal = { bg = { from = "FzfLuaNormal", attr = "bg" } } },
    {
      FzfLuaPreviewBorder = {
        fg = { from = "FloatBorder", attr = "fg" },
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

    {
      FzfLuaTitle = { fg = { from = "Boolean", attr = "fg", alter = 0.2 }, bg = { from = "NormalFloat", attr = "bg" } },
    },
    {
      FzfLuaTitleIcon = {
        fg = { from = "Boolean", attr = "fg", alter = 0.2 },
        bg = { from = "FzfLuaNormal", attr = "bg" },
      },
    },
    { FzfLuaCursorLine = { bg = { from = "CursorLine", alter = 0.4, attr = "bg" } } },

    {
      FzfLuaSel = {
        fg = { from = "PmenuSel", attr = "bg", alter = 0.2 },
        bg = { from = "PmenuSel", attr = "bg", alter = -0.2 },
      },
    },

    { FzfLuaDirPart = { fg = { from = "Keyword", attr = "fg", alter = -0.5 } } },
    { FzfLuaFilePart = { fg = { from = "Keyword", attr = "fg", alter = -0.2 }, reverse = false } },

    -- TELESCOPE ==========================================================
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

    -- Prompt
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
    {
      TelescopeResultsNormal = {
        bg = { from = "FzfLuaNormal", attr = "bg" },
        fg = { from = "FzfLuaDirPart", attr = "fg" },
      },
    },
    { TelescopeResultsTitle = { inherit = "FzfLuaTitle" } },
    { TelescopeResultsBorder = { inherit = "FzfLuaBorder" } },

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
        reverse = false,
      },
    },

    -- RGFLOW =============================================================
    {
      RgFlowHeadLine = {
        bg = Highlight.darken(dark_yellow, 0.1, base),
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

    -- TELESCOPE ==========================================================
    { MiniAnimateCursor = { fg = "red", bg = "red" } },

    -- VIM.MATCHUP ========================================================
    -- { MatchParen = { bg = { from = "MatchParen", attr = "bg", alter = -0.8 }, fg = "NONE", bold = false } },
    { MatchParen = { bg = { from = "Normal", attr = "bg", alter = -1 }, fg = "white", bold = false } },
    -- { MatchParen = { fg = "white", bg = "black", bold = true } },

    -- VGIT ========================================================
    { VGitLineNr = { bg = "NONE", fg = { from = "LineNr", attr = "fg", alter = 1 } } },
    { VGitComment = { bg = "NONE", fg = { from = "Comment", attr = "fg", alter = 0.5 } } },

    -- LAZYVIM =====================================================
    { LazyNormal = { inherit = "NormalFloat" } },
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
      { CursorLine = { bg = { from = "Keyword", attr = "fg", alter = -0.72 } } },
      {
        CursorLineNr = {
          fg = { from = "Normal", attr = "fg" },
          bg = { from = "CursorLine", attr = "bg" },
          bold = true,
        },
      },
      { ["@org.agenda.scheduled"] = { fg = "#3f9f31" } },

      { QuickFixLine = { bg = { from = "CursorLine", attr = "bg", alter = 0.4 }, underline = false } },
    },
    ["kanagawa"] = {
      { CursorLine = { bg = { from = "Keyword", attr = "fg", alter = -0.7 } } },

      {
        CursorLineNr = {
          fg = { from = "Normal", attr = "fg" },
          bg = { from = "CursorLine", attr = "bg" },
          bold = true,
        },
      },

      {
        Folded = {
          fg = { from = "Normal", attr = "bg", alter = 1.5 },
          bg = { from = "Normal", attr = "bg", alter = 0.3 },
        },
      },
      {
        StatusLine = {
          fg = { from = "Normal", attr = "bg", alter = 4 },
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
          fg = { from = "WinSeparator", attr = "fg", alter = 1.5 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.3 },
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
      { WinSeparator = { fg = { from = "LineNr", attr = "fg", alter = 0.1 }, bg = "NONE" } },
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
          bg = { from = "Keyword", attr = "fg", alter = -0.6 },
          bold = true,
        },
      },

      { NormalFloat = { bg = { from = "Pmenu", alter = -0.1 } } },
      {
        FloatBorder = {
          fg = { from = "NormalFloat", attr = "bg", alter = 0.5 },
          bg = { from = "NormalFloat", attr = "bg" },
        },
      },

      { CmpItemAbbrMatchFuzzy = { fg = { from = "GitSignsDelete", attr = "fg" } } },
      { CmpItemAbbrMatch = { fg = { from = "GitSignsDelete", attr = "fg" } } },
      {
        CmpItemFloatBorder = {
          fg = { from = "FloatBorder", attr = "fg" },
          bg = { from = "Pmenu", attr = "bg" },
        },
      },
      {
        CmpItemIconWarningMsg = {
          fg = { from = "WarningMsg", attr = "fg" },
          bg = { from = "CmpItemFloatBorder", attr = "bg" },
        },
      },

      { FzfLuaDirPart = { fg = { from = "Normal", attr = "fg", alter = -0.4 } } },
      { FzfLuaFilePart = { fg = { from = "Keyword", attr = "fg" }, reverse = false } },

      { FzfLuaNormal = { bg = { from = "NormalFloat", attr = "bg", alter = 0.1 } } },
      {
        FzfLuaBorder = {
          fg = { from = "FloatBorder", attr = "fg" },
          bg = { from = "NormalFloat", attr = "bg" },
        },
      },
      { FzfLuaPreviewNormal = { bg = { from = "FzfLuaNormal", attr = "bg" } } },
      {
        FzfLuaPreviewBorder = {
          fg = { from = "FzfLuaBorder", attr = "fg", alter = 0.1 },
          bg = { from = "FzfluaBorder", attr = "bg", alter = 0.1 },
        },
      },

      {
        FzfLuaSel = {
          fg = { from = "PmenuSel", attr = "bg", alter = 0.3 },
          bg = { from = "PmenuSel", attr = "bg", alter = -0.1 },
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
      { CursorLine = { bg = { from = "Keyword", attr = "fg", alter = -0.85 } } },
      {
        CursorLineNr = {
          fg = { from = "Normal", attr = "fg" },
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
          fg = { from = "Normal", attr = "bg", alter = 8.5 },
          bg = { from = "StatusLine", attr = "bg", alter = -0.1 },
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
          fg = { from = "WinSeparator", attr = "fg", alter = 2.5 },
          bg = { from = "StatusLine", attr = "bg", alter = -0.05 },
        },
      },

      {
        TablineSel = {
          bg = { from = "StatusLine", attr = "bg", alter = 0.8 },
          fg = { from = "StatusLine", attr = "fg", alter = 0.1 },
        },
      },
    },
    ["dawnfox"] = {
      { ["@punctuation.bracket"] = { fg = { from = "GitSignsChange", attr = "fg", alter = -0.2 } } },
      { ["@markup.quote.markdown"] = { bg = { from = "GitSignsChange", attr = "fg", alter = 1.5 } } },

      { Comment = { fg = { from = "Normal", attr = "bg", alter = -0.3 }, italic = true } },

      { Visual = { bg = { from = "Visual", attr = "bg", alter = -0.1 } } },
      {
        Folded = {
          fg = { from = "Normal", attr = "bg", alter = -0.2 },
          bg = { from = "Normal", attr = "bg", alter = -0.07 },
          h,
        },
      },
      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = -0.25 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },
      { WinSeparator = { fg = { from = "LineNr", attr = "fg", alter = 0.1 }, bg = "NONE" } },
      { TreesitterContextSeparator = { fg = { from = "WinSeparator", attr = "fg", alter = -0.1 } } },
      {
        TreesitterContextSeparator = {
          fg = { from = "WinSeparator", attr = "fg", alter = 0.05 },
          bg = { from = "ColorColumn", attr = "bg" },
        },
      },
      { CursorLine = { bg = { from = "Normal", attr = "bg", alter = -0.06 } } },
      {
        CursorLineNr = {
          fg = { from = "Keyword", attr = "fg", alter = -0.2 },
          bg = { from = "CursorLine", attr = "bg" },
          bold = true,
        },
      },
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
          fg = { from = "Normal", attr = "fg", alter = -0.1 },
          bg = { from = "Normal", attr = "bg", alter = -0.1 },
        },
      },
      {
        PmenuSel = {
          bg = { from = "Normal", attr = "bg", alter = -0.02 },
          bold = true,
          reverse = false,
        },
      },

      {
        PmenuThumb = {
          bg = { from = "Pmenu", attr = "bg", alter = 0.1 },
        },
      },

      { NormalFloat = { bg = { from = "Pmenu", attr = "bg" } } },
      {
        FloatBorder = {
          fg = { from = "NormalFloat", attr = "bg", alter = -0.1 },
          bg = { from = "NormalFloat", attr = "bg" },
        },
      },

      { FzfLuaNormal = { bg = { from = "NormalFloat", attr = "bg" } } },

      {
        FzfLuaBorder = {
          fg = { from = "FloatBorder", attr = "fg" },
          bg = { from = "NormalFloat", attr = "bg" },
        },
      },

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

      { FzfLuaDirPart = { fg = { from = "Normal", attr = "fg", alter = 0.5 } } },
      { FzfLuaFilePart = { fg = { from = "Keyword", attr = "fg" }, reverse = false } },

      { FzfLuaPreviewNormal = { bg = { from = "FzfLuaNormal", attr = "bg" } } },
      {
        FzfLuaPreviewBorder = {
          fg = { from = "FzfLuaBorder", attr = "fg" },
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
        LspReferenceText = {
          bg = { from = "Normal", attr = "bg", alter = -0.05 },
          fg = "NONE",
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },
      {
        LspReferenceWrite = {
          bg = { from = "Normal", attr = "bg", alter = -0.1 },
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },

      {
        LspReferenceRead = {
          bg = { from = "Normal", attr = "bg", alter = -0.1 },
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },

      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "bg", alter = -0.5 },
          bg = { from = "Normal", attr = "bg", alter = -0.45 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "bg" },
          bg = { from = "StatusLine", attr = "bg", alter = 0.6 },
        },
      },

      {
        Tabline = {
          fg = { from = "WinSeparator", attr = "fg", alter = -0.2 },
          bg = { from = "Normal", attr = "bg", alter = -0.05 },
        },
      },

      {
        TablineSel = {
          fg = { from = "StatusLine", attr = "fg", alter = 0.1 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.5 },
        },
      },
    },
    ["rose-pine"] = {
      { ["@punctuation.bracket"] = { fg = { from = "GitSignsChange", attr = "fg", alter = -0.2 } } },
      { ["@markup.quote.markdown"] = { bg = { from = "GitSignsChange", attr = "fg", alter = 1.5 } } },

      { Comment = { fg = { from = "Normal", attr = "bg", alter = -0.3 }, italic = true } },

      { Visual = { bg = { from = "Visual", attr = "bg", alter = -0.1 } } },
      {
        Folded = {
          fg = { from = "Normal", attr = "bg", alter = -0.2 },
          bg = { from = "Normal", attr = "bg", alter = -0.07 },
          h,
        },
      },
      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = -0.25 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },
      { WinSeparator = { fg = { from = "LineNr", attr = "fg", alter = 0.1 }, bg = "NONE" } },
      { TreesitterContextSeparator = { fg = { from = "WinSeparator", attr = "fg", alter = -0.1 } } },
      {
        TreesitterContextSeparator = {
          fg = { from = "WinSeparator", attr = "fg", alter = 0.05 },
          bg = { from = "ColorColumn", attr = "bg" },
        },
      },
      { CursorLine = { bg = { from = "Normal", attr = "bg", alter = -0.06 } } },
      {
        CursorLineNr = {
          fg = { from = "Keyword", attr = "fg", alter = -0.2 },
          bg = { from = "CursorLine", attr = "bg" },
          bold = true,
        },
      },
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
          fg = { from = "Normal", attr = "fg", alter = -0.1 },
          bg = { from = "Normal", attr = "bg", alter = -0.1 },
        },
      },
      {
        PmenuSel = {
          bg = { from = "Normal", attr = "bg", alter = -0.02 },
          bold = true,
          reverse = false,
        },
      },

      {
        PmenuThumb = {
          bg = { from = "Pmenu", attr = "bg", alter = 0.1 },
        },
      },

      { NormalFloat = { bg = { from = "Pmenu", attr = "bg" } } },
      {
        FloatBorder = {
          fg = { from = "NormalFloat", attr = "bg", alter = -0.1 },
          bg = { from = "NormalFloat", attr = "bg" },
        },
      },

      { FzfLuaNormal = { bg = { from = "NormalFloat", attr = "bg" } } },

      {
        FzfLuaBorder = {
          fg = { from = "FloatBorder", attr = "fg" },
          bg = { from = "NormalFloat", attr = "bg" },
        },
      },

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

      { FzfLuaDirPart = { fg = { from = "Normal", attr = "fg", alter = 0.5 } } },
      { FzfLuaFilePart = { fg = { from = "Keyword", attr = "fg" }, reverse = false } },

      { FzfLuaPreviewNormal = { bg = { from = "FzfLuaNormal", attr = "bg" } } },
      {
        FzfLuaPreviewBorder = {
          fg = { from = "FzfLuaBorder", attr = "fg" },
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
        LspReferenceText = {
          bg = { from = "Normal", attr = "bg", alter = -0.05 },
          fg = "NONE",
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },
      {
        LspReferenceWrite = {
          bg = { from = "Normal", attr = "bg", alter = -0.1 },
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },

      {
        LspReferenceRead = {
          bg = { from = "Normal", attr = "bg", alter = -0.1 },
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },

      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "bg", alter = -0.5 },
          bg = { from = "Normal", attr = "bg", alter = -0.45 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "bg" },
          bg = { from = "StatusLine", attr = "bg", alter = 0.6 },
        },
      },

      {
        Tabline = {
          fg = { from = "WinSeparator", attr = "fg", alter = -0.2 },
          bg = { from = "Normal", attr = "bg", alter = -0.05 },
        },
      },

      {
        TablineSel = {
          fg = { from = "StatusLine", attr = "fg", alter = 0.1 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.5 },
        },
      },
    },
    ["everforest"] = {
      { ["@punctuation.bracket"] = { fg = { from = "GitSignsChange", attr = "fg", alter = -0.2 } } },
      { ["@markup.quote.markdown"] = { bg = { from = "GitSignsChange", attr = "fg", alter = 1.5 } } },

      { Comment = { fg = { from = "Normal", attr = "bg", alter = -0.3 }, italic = true } },

      { Visual = { bg = { from = "Visual", attr = "bg", alter = -0.1 } } },
      {
        Folded = {
          fg = { from = "Normal", attr = "bg", alter = -0.2 },
          bg = { from = "Normal", attr = "bg", alter = -0.07 },
          h,
        },
      },
      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = -0.25 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },
      { WinSeparator = { fg = { from = "LineNr", attr = "fg", alter = 0.1 }, bg = "NONE" } },
      { TreesitterContextSeparator = { fg = { from = "WinSeparator", attr = "fg", alter = -0.1 } } },
      {
        TreesitterContextSeparator = {
          fg = { from = "WinSeparator", attr = "fg", alter = 0.05 },
          bg = { from = "ColorColumn", attr = "bg" },
        },
      },
      { CursorLine = { bg = { from = "Normal", attr = "bg", alter = -0.06 } } },
      {
        CursorLineNr = {
          fg = { from = "Keyword", attr = "fg", alter = -0.2 },
          bg = { from = "CursorLine", attr = "bg" },
          bold = true,
        },
      },
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
          fg = { from = "Normal", attr = "fg", alter = -0.1 },
          bg = { from = "Normal", attr = "bg", alter = -0.1 },
        },
      },
      {
        PmenuSel = {
          bg = { from = "Normal", attr = "bg", alter = -0.02 },
          bold = true,
          reverse = false,
        },
      },

      {
        PmenuThumb = {
          bg = { from = "Pmenu", attr = "bg", alter = 0.1 },
        },
      },

      { NormalFloat = { bg = { from = "Pmenu", attr = "bg" } } },
      {
        FloatBorder = {
          fg = { from = "NormalFloat", attr = "bg", alter = 0.1 },
          bg = { from = "NormalFloat", attr = "bg" },
        },
      },

      { FzfLuaNormal = { bg = { from = "NormalFloat", attr = "bg" } } },

      {
        FzfLuaBorder = {
          fg = { from = "FloatBorder", attr = "fg" },
          bg = { from = "NormalFloat", attr = "bg" },
        },
      },

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

      { FzfLuaDirPart = { fg = { from = "Normal", attr = "fg", alter = 0.5 } } },
      { FzfLuaFilePart = { fg = { from = "Keyword", attr = "fg" }, reverse = false } },

      { FzfLuaPreviewNormal = { bg = { from = "FzfLuaNormal", attr = "bg" } } },
      {
        FzfLuaPreviewBorder = {
          fg = { from = "FzfLuaBorder", attr = "fg" },
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
          fg = { from = "StatusLine", attr = "bg", alter = -0.5 },
          bg = { from = "Normal", attr = "bg", alter = -0.45 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "bg" },
          bg = { from = "StatusLine", attr = "bg", alter = 0.6 },
        },
      },

      {
        Tabline = {
          fg = { from = "WinSeparator", attr = "fg", alter = -0.2 },
          bg = { from = "Normal", attr = "bg", alter = -0.05 },
        },
      },

      {
        TablineSel = {
          fg = { from = "StatusLine", attr = "fg", alter = 0.1 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.5 },
        },
      },
    },
    ["lavish"] = {
      { Comment = { fg = { from = "Normal", attr = "bg", alter = 1.7 }, bg = "NONE", italic = true, reverse = false } },
      { ["@lsp.type.comment"] = { inherit = "Comment" } },
      { CursorLine = { bg = { from = "Keyword", attr = "fg", alter = -0.7 } } },
      {
        CursorLineNr = {
          fg = { from = "Keyword", attr = "fg", alter = 0.2 },
          bg = { from = "CursorLine", attr = "bg" },
          bold = true,
        },
      },

      {
        QuickFixLine = {
          bg = { from = "CursorLine", attr = "bg", alter = 0.4 },
          fg = { from = "CursorLine", attr = "bg", alter = 4 },
          underline = false,
        },
      },
      { qfFileName = { fg = { from = "Directory", attr = "fg", alter = 0.3 }, bg = "NONE" } },

      { Visual = { bg = { from = "Visual", attr = "bg", alter = -0.2 } } },

      {
        ["RenderMarkdownCodeInline"] = {
          fg = { from = "Directory", attr = "fg", alter = 0.5 },
          bg = { from = "Directory", attr = "fg", alter = 0.4 },
          bold = true,
        },
      },

      { ["@org.agenda.scheduled"] = { fg = "#3f9f31" } },

      {
        LspReferenceText = {
          bg = { from = "Normal", attr = "bg", alter = 0.5 },
          fg = "NONE",
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },
      {
        LspReferenceWrite = {
          bg = { from = "Normal", attr = "bg", alter = 1.2 },
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },

      {
        LspReferenceRead = {
          bg = { from = "Normal", attr = "bg", alter = 1.2 },
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },
      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "bg", alter = 2 },
          bg = { from = "Normal", attr = "bg", alter = 0.1 },
        },
      },
      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "bg", alter = 2.8 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.5 },
        },
      },
      {
        Tabline = {
          fg = { from = "StatusLine", attr = "bg", alter = 2 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.3 },
        },
      },

      {
        TablineSel = {
          fg = { from = "StatusLine", attr = "fg", alter = -0.2 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.7 },
        },
      },
    },
    ["evangelion"] = {
      { Comment = { fg = { from = "Normal", attr = "bg", alter = 1.7 }, bg = "NONE", italic = true, reverse = false } },
      { ["@lsp.type.comment"] = { inherit = "Comment" } },
      { CursorLine = { bg = { from = "Keyword", attr = "fg", alter = -0.8 } } },
      {
        CursorLineNr = {
          fg = { from = "Keyword", attr = "fg", alter = 0.2 },
          bg = { from = "CursorLine", attr = "bg" },
          bold = true,
        },
      },

      {
        QuickFixLine = {
          bg = { from = "CursorLine", attr = "bg", alter = 0.4 },
          fg = { from = "CursorLine", attr = "bg", alter = 4 },
          underline = false,
        },
      },
      { qfFileName = { fg = { from = "Directory", attr = "fg", alter = 0.3 }, bg = "NONE" } },

      { Visual = { bg = { from = "Visual", attr = "bg", alter = 0.4 } } },
      -- { ["@markup.strong.markdown_inline"] = { fg = { from = "Visual", attr = "bg", alter = 1.4 } } },

      { ["@org.agenda.scheduled"] = { fg = "#3f9f31" } },

      { CmpItemAbbrMatchFuzzy = { fg = { from = "ErrorMsg", attr = "fg" } } },
      { CmpItemAbbrMatch = { fg = { from = "ErrorMsg", attr = "fg" } } },

      {
        MyCodeUsage = {
          fg = { from = "Directory", attr = "fg", alter = 0.5 },
          bg = { from = "Visual", attr = "bg", alter = -0.8 },
          italic = true,
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
          fg = { from = "StatusLine", attr = "bg", alter = 1.5 },
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
    ["sweetie"] = {
      { CursorLine = { bg = { from = "Keyword", attr = "fg", alter = -0.67 } } },
      {
        CursorLineNr = {
          fg = { from = "Keyword", attr = "fg", alter = 0.2 },
          bg = { from = "CursorLine", attr = "bg" },
          bold = true,
        },
      },

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

      { Visual = { bg = { from = "Visual", attr = "bg", alter = 0.4 } } },

      { ["@org.agenda.scheduled"] = { fg = "#3f9f31" } },

      {
        MyCodeUsage = {
          fg = { from = "Normal", attr = "bg", alter = 3 },
          bg = { from = "Visual", attr = "bg", alter = 0.1 },
          italic = true,
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
          fg = { from = "StatusLine", attr = "bg", alter = 1.5 },
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
      { CursorLine = { bg = { from = "Keyword", attr = "fg", alter = -0.8 } } },
      {
        CursorLineNr = {
          fg = { from = "Normal", attr = "fg" },
          bg = { from = "CursorLine", attr = "bg" },
          bold = true,
        },
      },

      { QuickFixLine = { bg = { from = "CursorLine", attr = "bg", alter = 0.4 }, underline = false } },
      { qfFileName = { fg = { from = "qfFileName", attr = "fg", alter = 0.3 } } },
      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "bg", alter = 4 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.4 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "bg", alter = 1.5 },
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
    ["PaperColor"] = {
      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "bg", alter = 4 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.4 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "bg", alter = 1.5 },
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
          fg = { from = "StatusLine", attr = "fg" },
          bg = { from = "StatusLine", attr = "bg", alter = 0.2 },
        },
      },
    },
    ["farout"] = {
      { qfFileName = { fg = { from = "qfFileName", attr = "fg", alter = 0.3 } } },

      { CursorLine = { bg = { from = "Keyword", attr = "fg", alter = -0.78 } } },
      {
        CursorLineNr = {
          fg = { from = "Normal", attr = "fg" },
          bg = { from = "CursorLine", attr = "bg" },
          bold = true,
        },
      },

      { QuickFixLine = { bg = { from = "CursorLine", attr = "bg", alter = 0.2 }, underline = false } },
      { Pmenu = { bg = { from = "Normal", attr = "bg", alter = 2 }, fg = { from = "CmpItemAbbr" } } },
      {
        PmenuSel = {
          bg = { from = "CursorLine", attr = "bg", alter = 0.8 },
          bold = true,
          reverse = false,
        },
      },

      { NormalFloat = { bg = { from = "Pmenu", alter = -0.2 } } },
      {
        FloatBorder = {
          fg = { from = "NormalFloat", attr = "bg", alter = 0.8 },
          bg = { from = "NormalFloat", attr = "bg" },
        },
      },

      { FzfLuaNormal = { bg = { from = "NormalFloat", attr = "bg" } } },

      { CmpItemAbbr = { fg = { from = "Normal", attr = "bg", alter = 9 }, bg = "NONE" } },
      {
        CmpItemFloatBorder = {
          fg = { from = "FloatBorder", attr = "fg", alter = 0.2 },
          bg = { from = "Pmenu", attr = "bg" },
        },
      },
      {
        CmpItemIconWarningMsg = {
          fg = { from = "WarningMsg", attr = "fg" },
          bg = { from = "CmpItemFloatBorder", attr = "bg" },
        },
      },

      { FzfLuaNormal = { bg = { from = "NormalFloat", attr = "bg" } } },
      {
        FzfLuaBorder = {
          bg = { from = "NormalFloat", attr = "bg" },
          fg = { from = "WinSeparator", attr = "fg", alter = 2 },
        },
      },
      { FzfLuaPreviewNormal = { bg = { from = "FzfLuaNormal", attr = "bg" } } },
      {
        FzfLuaPreviewBorder = {
          fg = { from = "FzfluaBorder", attr = "bg", alter = 0.8 },
          bg = { from = "FzfluaBorder", attr = "bg" },
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

      {
        FzfLuaSel = {
          fg = { from = "PmenuSel", attr = "bg", alter = 0.2 },
          bg = { from = "PmenuSel", attr = "bg", alter = -0.1 },
        },
      },

      { FzfLuaDirPart = { fg = { from = "Keyword", attr = "fg", alter = -0.5 } } },
      { FzfLuaFilePart = { fg = { from = "Keyword", attr = "fg", alter = -0.1 }, reverse = false } },

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

      { WinSeparator = { fg = { from = "LineNr", attr = "fg", alter = 0.6 }, bg = "NONE" } },

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

      {
        MyParentHint = {
          bg = { from = "CursorLine", attr = "bg" },
          fg = { from = "MyCodeUsage", attr = "fg", alter = 0.7 },
        },
      },

      {
        Tabline = {
          bg = { from = "StatusLine", attr = "bg", alter = 0.1 },
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
    ["flow"] = {
      {
        QuickFixLine = {
          bg = { from = "CursorLine", attr = "bg", alter = 0.4 },
          fg = { from = "CursorLine", attr = "bg", alter = 4 },
          underline = false,
        },
      },
      { qfFileName = { fg = { from = "qfFileName", attr = "fg", alter = 0.3 } } },

      { Visual = { bg = { from = "Visual", attr = "bg", alter = -0.3 } } },
      {
        MyCodeUsage = {
          fg = { from = "Directory", attr = "fg", alter = 0.2 },
          bg = { from = "Directory", attr = "fg", alter = -0.5 },
          italic = true,
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
    ["selenized"] = {
      { Comment = { fg = { from = "Normal", attr = "bg", alter = 1 }, italic = true } },
      { CursorLine = { bg = { from = "Normal", attr = "bg", alter = 0.2 } } },

      { Visual = { bg = { from = "Visual", attr = "bg", alter = 0.3 } } },

      {
        Folded = {
          fg = { from = "Normal", attr = "bg", alter = 1 },
          bg = { from = "Normal", attr = "bg", alter = 0.3 },
        },
      },

      { ["@org.agenda.scheduled"] = { fg = "#3f9f31" } },

      {
        CursorLineNr = {
          fg = { from = "Normal", attr = "fg" },
          bg = { from = "CursorLine", attr = "bg" },
          bold = true,
        },
      },

      {
        qfFileName = {
          fg = { from = "Normal", attr = "bg", alter = 1.5 },
          bg = "NONE",
        },
      },

      { QuickFixLine = { bg = { from = "CursorLine", attr = "bg", alter = 0.2 }, underline = false } },

      { FzfLuaCursorLine = { bg = { from = "CursorLine", alter = 0.4, attr = "bg" } } },
      { ErrorMsg = { fg = "red" } },

      {
        Pmenu = {
          fg = { from = "Normal", attr = "bg", alter = 0.8 },
          bg = { from = "Normal", attr = "bg", alter = -0.2 },
        },
      },
      {
        PmenuSel = {
          fg = "NONE",
          bg = { from = "CursorLine", attr = "bg", alter = 0.2 },
          bold = true,
        },
      },
      { NormalFloat = { bg = { from = "Pmenu", alter = -0.2 } } },
      {
        FloatBorder = {
          fg = { from = "NormalFloat", attr = "bg", alter = 1 },
          bg = { from = "NormalFloat", attr = "bg" },
        },
      },

      { FzfLuaCursorLine = { bg = { from = "CursorLine", alter = 0.4, attr = "bg" } } },
      {
        FzfLuaSel = {
          fg = { from = "PmenuSel", attr = "bg", alter = 0.2 },
          bg = { from = "PmenuSel", attr = "bg", alter = -0.2 },
        },
      },
    },
    ["melange"] = {
      {
        Comment = {
          fg = { from = "Normal", attr = "bg", alter = 1.2 },
        },
      },
      {
        StatusLine = {
          fg = { from = "Normal", attr = "bg", alter = 4 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.2 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "bg", alter = 1.5 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.2 },
        },
      },

      {
        Tabline = {
          fg = { from = "WinSeparator", attr = "fg", alter = 1 },
          bg = { from = "WinSeparator", attr = "fg", alter = 0.05 },
          reverse = false,
        },
      },

      {
        TablineSel = {
          fg = { from = "StatusLine", attr = "fg", alter = 0.3 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.6 },
        },
      },
    },
    ["dayfox"] = {
      { WinSeparator = { fg = { from = "Normal", attr = "bg", alter = -0.1 }, bg = "NONE" } },
      { Comment = { fg = { from = "Normal", attr = "bg", alter = -0.3 }, italic = true } },
      { CursorLine = { bg = "#e3ddf8" } },

      { ["@markup.quote.markdown"] = { bg = { from = "GitSignsChange", attr = "fg", alter = 1.5 } } },
      {
        CursorLineNr = {
          fg = { from = "Normal", attr = "fg" },
          bg = { from = "CursorLine", attr = "bg" },
          bold = true,
        },
      },

      {
        Folded = {
          fg = { from = "Normal", attr = "bg", alter = -0.5 },
          bg = { from = "Normal", attr = "bg", alter = -0.1 },
        },
      },
      { QuickFixLine = { bg = { from = "CursorLine", attr = "bg", alter = -0.1 }, underline = false } },
      {
        qfFileName = {
          fg = { from = "Directory", attr = "fg", alter = -0.2 },
          bg = "NONE",
        },
      },

      { ["@punctuation.bracket"] = { fg = { from = "Keyword", attr = "fg", alter = -0.2 } } },

      { ["@lsp.type.parameter"] = { italic = true, bold = true, fg = { from = "Keyword" } } },

      { LineNr = { bg = "NONE", fg = { from = "LineNr", attr = "fg", alter = -0.3 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      { CmpItemAbbr = { fg = { from = "Normal", attr = "bg", alter = -0.5 }, bg = "NONE" } },
      { Pmenu = { bg = { from = "Normal", attr = "bg", alter = -0.1 }, fg = { from = "CmpItemAbbr" } } },
      {
        PmenuSel = {
          fg = "NONE",
          bg = { from = "CursorLine", attr = "bg", alter = -0.1 },
          bold = true,
        },
      },
      { PmenuThumb = { bg = { from = "Normal", attr = "bg", alter = -0.2 } } },

      { NormalFloat = { bg = { from = "Pmenu" } } },
      {
        FloatBorder = {
          fg = { from = "NormalFloat", attr = "bg", alter = -0.1 },
          bg = { from = "NormalFloat", attr = "bg" },
        },
      },

      { CmpItemAbbrMatchFuzzy = { fg = { from = "Keyword", attr = "fg", alter = -0.1 } } },
      { CmpItemAbbrMatch = { fg = { from = "Keyword", attr = "fg", alter = -0.1 } } },
      {
        CmpItemFloatBorder = {
          fg = { from = "FloatBorder", attr = "fg" },
          bg = { from = "Pmenu", attr = "bg" },
        },
      },
      {
        CmpItemIconWarningMsg = {
          fg = { from = "WarningMsg", attr = "fg" },
          bg = { from = "CmpItemFloatBorder", attr = "bg" },
        },
      },

      { FzfLuaNormal = { bg = { from = "NormalFloat", attr = "bg" } } },
      {
        FzfLuaBorder = {
          fg = { from = "FloatBorder", attr = "fg" },
          bg = { from = "NormalFloat", attr = "bg" },
        },
      },

      { FzfLuaPreviewNormal = { bg = { from = "FzfLuaNormal", attr = "bg" } } },
      {
        FzfLuaPreviewBorder = {
          fg = { from = "FzfluaBorder", attr = "fg" },
          bg = { from = "FzfluaBorder", attr = "bg" },
        },
      },
      {
        FzfLuaTitle = {
          fg = "NONE",
          bg = "NONE",
        },
      },
      {
        FzfLuaTitleIcon = {
          fg = { from = "Boolean", attr = "fg", alter = 0.2 },
          bg = { from = "FzfLuaNormal", attr = "bg" },
        },
      },

      {
        FzfLuaSel = {
          fg = { from = "CmpItemAbbr", attr = "fg" },
          bg = { from = "CursorLine", attr = "bg", alter = -0.2 },
        },
      },

      { FzfLuaCursorLine = { bg = { from = "CursorLine", attr = "bg", alter = 0.04 } } },
      { FzfLuaCursorLineNr = { bg = { from = "CursorLine", attr = "bg", alter = 0.04 } } },

      { FzfLuaDirPart = { fg = { from = "Normal", attr = "bg", alter = -0.34 } } },
      { FzfLuaFilePart = { fg = { from = "Keyword", attr = "fg", alter = 0.5 }, reverse = false } },

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
      {
        TelescopeResultsNormal = {
          bg = { from = "FzfLuaNormal", attr = "bg" },
          fg = { from = "FzfLuaDirPart", attr = "fg" },
        },
      },
      { TelescopeResultsTitle = { inherit = "FzfLuaTitle" } },
      { TelescopeResultsBorder = { inherit = "FzfLuaBorder" } },

      -----
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
          fg = { from = "StatusLine", attr = "bg", alter = -0.6 },
          bg = { from = "StatusLine", attr = "bg", alter = -0.38 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "bg", alter = 0.1 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.6 },
        },
      },

      {
        Tabline = {
          fg = { from = "WinSeparator", attr = "fg", alter = -0.2 },
          bg = { from = "Normal", attr = "bg", alter = -0.05 },
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
      { Search = { bg = "red" } },
    },
    ["nightfox"] = {
      { CursorLine = { bg = { from = "Keyword", attr = "fg", alter = -0.65 } } },
      {
        CursorLineNr = {
          fg = { from = "Normal", attr = "fg" },
          bg = { from = "CursorLine", attr = "bg" },
          bold = true,
        },
      },

      { QuickFixLine = { bg = { from = "CursorLine", attr = "bg", alter = 0.4 }, underline = false } },
      {
        Comment = {
          fg = { from = "Normal", attr = "bg", alter = 1.2 },
        },
      },
      {
        StatusLine = {
          fg = { from = "Normal", attr = "bg", alter = 4 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.2 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "bg", alter = 2 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.3 },
        },
      },

      {
        Tabline = {
          fg = { from = "WinSeparator", attr = "fg", alter = 1 },
          bg = { from = "WinSeparator", attr = "fg", alter = -0.03 },
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
    ["terafox"] = {
      { CursorLine = { bg = { from = "Keyword", attr = "fg", alter = -0.65 } } },
      {
        CursorLineNr = {
          fg = { from = "Normal", attr = "fg" },
          bg = { from = "CursorLine", attr = "bg" },
          bold = true,
        },
      },

      { QuickFixLine = { bg = { from = "CursorLine", attr = "bg", alter = 0.4 }, underline = false } },
      {
        Comment = {
          fg = { from = "Normal", attr = "bg", alter = 1.2 },
        },
      },
      {
        StatusLine = {
          fg = { from = "Normal", attr = "bg", alter = 4 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.2 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "bg", alter = 2 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.3 },
        },
      },

      {
        Tabline = {
          fg = { from = "WinSeparator", attr = "fg", alter = 1 },
          bg = { from = "WinSeparator", attr = "fg", alter = 0.05 },
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
      { CursorLine = { bg = { from = "Keyword", attr = "fg", alter = -0.72 } } },
      {
        CursorLineNr = {
          fg = { from = "Normal", attr = "fg" },
          bg = { from = "CursorLine", attr = "bg" },
          bold = true,
        },
      },
      {
        StatusLine = {
          fg = { from = "Normal", attr = "bg", alter = 3 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.2 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "bg", alter = 2.5 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.3 },
        },
      },

      {
        Tabline = {
          fg = { from = "WinSeparator", attr = "fg", alter = 1 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.3 },
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

      { Comment = { fg = { from = "Normal", attr = "bg", alter = -0.25 }, italic = true } },
      {
        Folded = {
          fg = { from = "Normal", attr = "bg", alter = -0.2 },
          bg = { from = "Normal", attr = "bg", alter = -0.05 },
          h,
        },
      },
      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = -0.3 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },
      { WinSeparator = { fg = { from = "LineNr", attr = "fg", alter = 0.1 }, bg = "NONE" } },
      { TreesitterContextSeparator = { fg = { from = "WinSeparator", attr = "fg", alter = -0.1 } } },
      {
        TreesitterContextSeparator = {
          fg = { from = "WinSeparator", attr = "fg", alter = 0.05 },
          bg = { from = "ColorColumn", attr = "bg" },
        },
      },
      { CursorLine = { bg = { from = "Normal", attr = "bg", alter = -0.06 } } },
      {
        CursorLineNr = {
          fg = { from = "Keyword", attr = "fg", alter = -0.2 },
          bg = { from = "CursorLine", attr = "bg" },
          bold = true,
        },
      },
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
          fg = { from = "Normal", attr = "fg", alter = -0.1 },
          bg = { from = "Normal", attr = "bg", alter = -0.1 },
        },
      },
      {
        PmenuSel = {
          bg = { from = "Normal", attr = "bg", alter = -0.02 },
          bold = true,
          reverse = false,
        },
      },

      {
        PmenuThumb = {
          bg = { from = "Pmenu", attr = "bg", alter = 0.1 },
        },
      },

      { NormalFloat = { bg = { from = "Pmenu", attr = "bg" } } },
      {
        FloatBorder = {
          fg = { from = "NormalFloat", attr = "bg", alter = 0.1 },
          bg = { from = "NormalFloat", attr = "bg" },
        },
      },

      { FzfLuaNormal = { bg = { from = "NormalFloat", attr = "bg" } } },
      {
        FzfLuaBorder = {
          fg = { from = "FloatBorder", attr = "fg" },
          bg = { from = "NormalFloat", attr = "bg" },
        },
      },

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

      { FzfLuaDirPart = { fg = { from = "Normal", attr = "fg", alter = 0.5 } } },
      { FzfLuaFilePart = { fg = { from = "Keyword", attr = "fg" }, reverse = false } },

      { FzfLuaPreviewNormal = { bg = { from = "FzfLuaNormal", attr = "bg" } } },
      {
        FzfLuaPreviewBorder = {
          fg = { from = "FzfLuaBorder", attr = "fg" },
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
          fg = { from = "StatusLine", attr = "bg", alter = -0.5 },
          bg = { from = "Normal", attr = "bg", alter = -0.45 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "bg" },
          bg = { from = "StatusLine", attr = "bg", alter = 0.6 },
        },
      },

      {
        Tabline = {
          fg = { from = "WinSeparator", attr = "fg", alter = -0.2 },
          bg = { from = "Normal", attr = "bg", alter = -0.05 },
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
        StatusLine = {
          fg = { from = "Normal", attr = "bg", alter = 3 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.3 },
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
          fg = { from = "WinSeparator", attr = "fg", alter = 1.4 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.4 },
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
    ["catppuccin-latte"] = {
      { WinSeparator = { fg = { from = "Normal", attr = "bg", alter = -0.05 }, bg = "NONE" } },
      {
        MyCodeUsage = {
          fg = { from = "Visual", attr = "bg", alter = 2 },
          bg = { from = "Visual", attr = "bg", alter = 0.05 },
          italic = true,
        },
      },

      { Comment = { fg = { from = "Normal", attr = "bg", alter = -0.3 }, italic = true } },
      { CursorLine = { bg = "#e3ddf8" } },
      {
        CursorLineNr = {
          fg = { from = "Normal", attr = "fg" },
          bg = { from = "CursorLine", attr = "bg" },
          bold = true,
        },
      },

      {
        Folded = {
          fg = { from = "Normal", attr = "bg", alter = -0.5 },
          bg = { from = "Normal", attr = "bg", alter = -0.05 },
        },
      },
      {
        QuickFixLine = {
          fg = { from = "CursorLine", attr = "bg", alter = 0.1 },
          bg = { from = "CursorLine", attr = "bg", alter = -0.1 },
          underline = false,
        },
      },
      {
        qfFileName = {
          fg = { from = "Normal", attr = "fg" },
          bg = "NONE",
        },
      },

      { ["@punctuation.bracket"] = { fg = { from = "Keyword", attr = "fg", alter = -0.2 } } },

      { LineNr = { bg = "NONE", fg = { from = "LineNr", attr = "fg", alter = -0.3 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      { CmpItemAbbr = { fg = { from = "Normal", attr = "bg", alter = -0.5 }, bg = "NONE" } },
      { Pmenu = { bg = { from = "Normal", attr = "bg", alter = -0.1 }, fg = { from = "CmpItemAbbr" } } },
      {
        PmenuSel = {
          fg = "NONE",
          bg = { from = "CursorLine", attr = "bg", alter = -0.1 },
          bold = true,
        },
      },
      { PmenuThumb = { bg = { from = "Normal", attr = "bg", alter = -0.2 } } },

      { NormalFloat = { bg = { from = "Pmenu" } } },
      {
        FloatBorder = {
          fg = { from = "NormalFloat", attr = "bg", alter = -0.1 },
          bg = { from = "NormalFloat", attr = "bg" },
        },
      },

      { CmpItemAbbrMatchFuzzy = { fg = { from = "ErrorMsg", attr = "fg" } } },
      { CmpItemAbbrMatch = { fg = { from = "ErrorMsg", attr = "fg" } } },
      {
        CmpItemFloatBorder = {
          fg = { from = "FloatBorder", attr = "fg" },
          bg = { from = "Pmenu", attr = "bg" },
        },
      },
      {
        CmpItemIconWarningMsg = {
          fg = { from = "WarningMsg", attr = "fg" },
          bg = { from = "CmpItemFloatBorder", attr = "bg" },
        },
      },

      { FzfLuaNormal = { bg = { from = "NormalFloat", attr = "bg" } } },
      {
        FzfLuaBorder = {
          fg = { from = "FloatBorder", attr = "fg" },
          bg = { from = "NormalFloat", attr = "bg" },
        },
      },

      { FzfLuaPreviewNormal = { bg = { from = "FzfLuaNormal", attr = "bg" } } },
      {
        FzfLuaPreviewBorder = {
          fg = { from = "FzfluaBorder", attr = "fg" },
          bg = { from = "FzfluaBorder", attr = "bg" },
        },
      },
      {
        FzfLuaPreviewTitle = {
          bg = { from = "ErrorMsg", attr = "fg" },
        },
      },
      {
        FzfLuaTitle = {
          fg = "NONE",
          bg = { from = "NormalFloat", attr = "bg" },
        },
      },
      {
        FzfLuaTitleIcon = {
          fg = { from = "Boolean", attr = "fg", alter = 0.2 },
          bg = { from = "FzfLuaNormal", attr = "bg" },
        },
      },

      {
        FzfLuaSel = {
          fg = { from = "CmpItemAbbr", attr = "fg" },
          bg = { from = "CursorLine", attr = "bg", alter = -0.1 },
        },
      },

      { FzfLuaCursorLine = { bg = { from = "CursorLine", attr = "bg", alter = 0.04 } } },
      { FzfLuaCursorLineNr = { bg = { from = "CursorLine", attr = "bg", alter = 0.04 } } },

      { FzfLuaDirPart = { fg = { from = "Normal", attr = "bg", alter = -0.4 } } },
      { FzfLuaFilePart = { fg = { from = "Keyword", attr = "fg", alter = 0.2 }, reverse = false } },

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

      -----
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
          fg = { from = "StatusLine", attr = "bg", alter = -0.6 },
          bg = { from = "StatusLine", attr = "bg", alter = -0.45 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "bg", alter = 0.3 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.7 },
        },
      },

      {
        Tabline = {
          fg = { from = "WinSeparator", attr = "fg", alter = -0.3 },
          bg = { from = "Normal", attr = "bg", alter = -0.05 },
        },
      },

      {
        TablineSel = {
          fg = { from = "StatusLine", attr = "fg", alter = 0.5 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.5 },
        },
      },
    },
    ["catppuccin-mocha"] = {
      {
        StatusLine = {
          fg = { from = "Normal", attr = "bg", alter = 3.5 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.2 },
        },
      },

      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "bg", alter = 3.5 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.5 },
        },
      },

      {
        Tabline = {
          fg = { from = "WinSeparator", attr = "fg", alter = 1 },
          bg = { from = "WinSeparator", attr = "fg", alter = 0.05 },
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
