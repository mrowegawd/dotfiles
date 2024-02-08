local Util = require "r.utils"

local Highlight = require "r.config.highlights"

-- stylua: ignore
local general_overrides = function()
  Highlight.all {
    -- { Directory = { fg = { from = "Directory", attr = "fg", alter = -0.5 } } },
    -- { ColorColumn = { bg = { from = "Normal" , attr = "bg" } } },
    -- { Normal = { fg = { from = "Normal", attr = "fg", alter = -0.1 }, bg = { from = "Normal", attr = "bg", alter= -0.15 } } },
    -- { Normal = { bg = "NONE", fg = { from = "Normal", attr = "fg" } } },
    { FoldColumn = { bg = { from = "Normal" , attr = "bg" }, fg = { from = "ColorColumn", attr = "bg", alter = -0.5 } } },
    { LineNr = { bg = "NONE", fg = { from = "FoldColumn", attr = "bg", alter = 0.5 } } },
    { CursorLineNr = { fg = { from = "Boolean", attr = "fg", alter = 0.4 }, bg = "NONE" } },
    { CursorLine = { bg = { from = "Normal", alter = 0.3 } } },
    { Type = { italic = true, bold = true } },
    { NormalFloat = { bg = { from = "Normal", attr = "bg", alter = -0.1 }, fg = { from = "Normal", attr = "fg" } } },
    { Comment = { fg = { from = "Normal", attr = "fg", alter = -0.5 }, italic = true } },
    { Folded = { bg = { from = "Normal", attr = "bg", alter = 0.5 }, fg = { from = "Normal", attr = "bg", alter = 1.6 } } },
    { EndOfBuffer = { bg = "NONE" } },
    -- { StatusLine = { fg = { from = "ColorColumn", attr = "bg", alter = 0.5 }, bg = { from = "ColorColumn" , attr = "bg", alter = 0.2 } } },
    { StatusLine = { fg = { from = "ColorColumn", attr = "bg", alter = 0.5 }, bg = { from = "Normal" , attr = "bg", alter = 0.2 } } },
    { StatusLineNC = { bg = { from = "StatusLine", attr = "bg", alter = -0.2 } } },
    { SignColumn = { bg = "NONE" } },
    { NonText = { fg = {from = "Normal", attr = "fg", alter = -0.4 } } },

    -- { MarkSignNumHL = { inherit = "SpecialKey" } },
    { WinSeparator = { fg = { from = "@constructor", attr = "fg", alter = -0.5 }, bg = "NONE" } },
    { FloatBorder = { bg = { from = "Normal", attr = "bg", alter = -0.1 }, fg = { from = "WinSeparator" , attr = "fg", alter = 0.5 } } },
    { WinBar = { bg = { from = "ColorColumn" } , fg = { from = "Normal", attr = "bg", alter = 1 } } },
    { WinBarNC = { bg = { from = "ColorColumn" }, fg = { from = "WinBar", attr = "fg" } } },

    { TablineFill = { bg = { from = "Normal"  } } },
    -----------------------------------------------------------------------------//
    --  Spell
    -----------------------------------------------------------------------------//
    { SpellBad = { undercurl = true, bg = "NONE", fg = "NONE", sp = "green" } },
    { SpellRare = { undercurl = true } },

    -----------------------------------------------------------------------
    --  SEMANTIC TOKENS
    -----------------------------------------------------------------------
    -- { String = { italic = true } },
    -- { ["@lsp.type.variable"] = { clear = true } },
    -- { ["@lsp.type.parameter"] = { italic = true, fg = { from = "Normal" } } },
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
    -- TREESITTER
    -----------------------------------------------------------------------
    -- { ["@keyword.return"] = { italic = true, fg = { from = "Keyword" } } },
    -- { ['@type.qualifier'] = { inherit = '@keyword', italic = true } },
    -- { ["@variable"] = { clear = true } },
    -- { ["@parameter"] = { italic = true, bold = true, fg = "NONE" } },
    -- { ["@error"] = { fg = "fg", bg = "NONE" } },
    -- { ["@text.diff.add"] = { link = "DiffAdd" } },
    -- { ["@text.diff.delete"] = { link = "DiffDelete" } },
    -- { ["@text.title.markdown"] = { underdouble = true } },

    -----------------------------------------------------------------------
    -- Diff
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

    { diffAdd = { bg = { from = "GitSignsAdd" , attr = "fg", alter = -0.3 }, fg = { from = "GitSignsAdd" , attr = "fg", alter = 0.5 } } },
    { diffChange = { bg = { from = "WarningMsg" , attr = "fg", alter = -0.3 }, fg = { from = "WarningMsg"  } } },
    { diffDelete = { bg = { from = "ErrorMsg" , attr = "fg", alter = -0.3 }, fg = { from = "ErrorMsg" } } },
    { diffText = { bg = { from = "diffText" , attr = "bg", alter = -0.3 }, fg = { from = "diffText" , attr = "bg", alter = 0.5 } } },

    { NeogitDiffAdd =  { link = "diffAdd"} } ,
    { NeogitDiffAddHighlight = { link = "diffAdd" } },
    { NeogitDiffDelete =  { link = "diffDelete" } } ,
    { NeogitDiffDeleteHighlight =  { link = "diffDelete" } } ,

    -----------------------------------------------------------------------
    -- LSP
    -----------------------------------------------------------------------
    { LspCodeLens = { inherit = "Comment", bold = true, italic = false } },
    { LspCodeLensSeparator = { bold = false, italic = false } },

    { illuminatedWordWrite = { bg = { from = "illuminatedWordWrite", attr = "bg", alter = -0.05 } } },
    { illuminatedWordRead = { bg = { from = "illuminatedWordRead", attr = "bg", alter = -0.05 } } },
    { illuminatedWordText = { bg = { from = "illuminatedWordText", attr = "bg", alter = -0.05 } } },

    -- { LspReferenceText = { bg = "NONE", underline = true, sp = { from = "Comment", attr = "fg" } } },
    -- { LspReferenceWrite = { inherit = 'LspReferenceText', bold = true, italic = true, underline = true } },
    -- { LspSignatureActiveParameter = { link = "Visual" } },

    { LspInlayhint = { bg = { from = "Normal", attr = "bg", alter = -0.4 }, fg = { from = "Directory", attr = "fg", alter = -0.3 } } },

    { TreesitterContextSeparator = { fg = { from = "WinSeparator", attr = "fg", alter = -0.1 } } },
    { TreesitterContext = { bg  = { from = "ColorColumn" } } } ,
    { TreesitterContextSeparator = {
      fg = { from = "WinSeparator", attr = "fg", alter = 0.05 },
      bg = { from = "ColorColumn" , attr = "bg" }
    } },

    -----------------------------------------------------------------------
    -- DIAGNOSTIC
    -----------------------------------------------------------------------
    { DiagnosticHint = { bg = "NONE" } },
    { DiagnosticError = { bg = "NONE" } },
    { DiagnosticWarning = { bg = "NONE" } },
    { DiagnosticInfo = { bg = "NONE" } },
    { DiagnosticSignError = { bg = { from = "Normal", attr = "bg" } } },
    { DiagnosticSignWarn = { bg = { from = "Normal", attr = "bg" } } },
    { DiagnosticSignInfo = { bg = { from = "Normal", attr = "bg" } } },
    { DiagnosticSignHint = { bg = { from = "Normal", attr = "bg" } } },

    -- Floating windows
    { DiagnosticFloatingWarn = { link = "DiagnosticWarn" } },
    { DiagnosticFloatingInfo = { link = "DiagnosticInfo" } },
    { DiagnosticFloatingHint = { link = "DiagnosticHint" } },
    { DiagnosticFloatingError = { link = "DiagnosticError" } },
    { DiagnosticFloatTitle = { inherit = "FloatTitle", bold = true } },
    { DiagnosticFloatTitleIcon = { inherit = "FloatTitle", fg = { from = "@character" } } },

    { DiagnosticVirtualTextWarn = { link = "DiagnosticWarn" } },
    { DiagnosticVirtualTextInfo = { link = "DiagnosticInfo" } },
    { DiagnosticVirtualTextHint = { link = "DiagnosticHint" } },
    { DiagnosticVirtualTextError = { link = "DiagnosticError" } },

    -----------------------------------------------------------------------
    -- CREATED HIGHLIGHTS
    -----------------------------------------------------------------------
    { MyStatusline = { fg = { from = "Normal", alter = 0.5 } } },
    { Mystatusline_fg = { fg = { from = "LineNr", alter = 0.1 } } },
    { Mystatusline_bg = { bg = { from = "Normal", alter = -0.1 } } },

    { bufferline_unselected = { bg = { from = "Normal", attr = "bg", alter = -0.2 } } },
    { bufferline_selected_bg = { bg = { from = "Normal", attr = "bg" } } },
    { bufferline_fill_bg = { bg = { from = "Normal", attr = "bg", alter = -0.2 } } },
    { bufferline_fill_fg = { bg = { from = "Normal", attr = "fg", alter = -0.1 } } },

    { Mygreen_fg = { fg = { from = "GitSignsAdd", attr = "fg", alter = 0.1 } } },
    { MyStatusLine_red_fg = { fg = { from = "ErrorMsg", attr = "fg", alter = 0.1 }, bg = { from = "StatusLine", attr = "bg" } } },
    { MyStatusLine_notif_fg = { fg = { from = "Boolean", atrr = "fg", alter = 0.1 }, bg = { from = "StatusLine", attr = "bg" } } },
    { MyStatusLine_directory_fg = { fg = { from = "Directory", atrr = "fg", alter = 0.1 }, bg = { from = "StatusLine", attr = "bg" } } },
    { MyQuickFixLineLeave = { bg = { from = "ErrorMsg", attr = "fg", alter = -0.5 } } },
    { MyQuickFixLineEnter = { bg = { from = "ErrorMsg", attr = "fg", alter = -0.5 } } },
    { MyQuickFixLine = { bg = { from = "ErrorMsg", attr = "fg", alter = -0.6 } } },
    { MyCursorLine = { bg = { from = "Normal", alter = 0.3 } } },
    { CodeBlock1 = { bg = { from = "Normal", alter = -0.3 } } },
    { CodeBlock2 = { bg = "cyan" } },
    { CodeLine1 = { fg = { from = "Error", attr = "fg" } } },
    -- { CodeComment1 = { fg = { from = "Comment", attr = "fg", alter = 0.3 } } },

    -----------------------------------------------------------------------
    -- PLUGINS
    -----------------------------------------------------------------------

    -- CMP ================================================================
    { CmpItemAbbr = { fg = { from = "Normal", attr = "fg", alter = 1.55 }, bg = "NONE" } },
    { CmpItemAbbrMatch = { fg = { from = "Error", alter = 0.2 }, bg = "NONE", bold = false } },
    { CmpItemAbbrMatchFuzzy = { fg = { from = "Error", alter = -0.5 } } },

    -- { PmenuSel = { fg = "NONE", bg = { from = "Normal" , attr = "bg" , alter = 0.4 } } },
    { PmenuSel = { fg = "NONE", bg = { from = "@keyword", attr = "fg", alter = -0.5 } } },
    { Pmenu = { bg = { from = "Normal", attr = "bg", alter = 0.3 }, fg = { from = "CmpItemAbbr" } } },
    { PmenuThumb = { bg = { from = "WinSeparator", attr = "fg", alter = 0.1 } } },

    -- TELESCOPE ==========================================================
    { TelescopeNormal = { link = "NormalFloat" } },
    { TelescopeBorder = { link = "NormalFloat" } },

    -- Prompt
    { TelescopePromptNormal = { link = "NormalFloat" } },
    { TelescopePromptTitle = { bg = { from = "NormalFloat", attr = "bg" }, fg = { from = "WarningMsg", alter = 0.5, bold = true }, bold = true } },
    { TelescopePromptBorder = { bg = "NONE", fg = { from = "FloatBorder" } } },
    { TelescopePromptPrefix = { bg = { from = "NormalFloat", attr = "bg" } } },
    { TelescopePromptCounter = { bg = { from = "NormalFloat", attr = "bg" } } },

    -- Preview
    { TelescopePreviewNormal = { link = "NormalFloat" } },
    { TelescopePreviewTitle = { bg = { from = "NormalFloat", attr = "bg" }, fg = { from = "ColorColumn", alter = 0.14, bold = true }, bold = true } },
    { TelescopePreviewBorder = { bg = { from = "NormalFloat", attr = "bg" }, fg = { from = "FloatBorder" } } },
    { TelescopeMatching = { inherit = "CmpItemAbbrMatchFuzzy" } },
    { TelescopeSelection = { inherit = "PmenuSel" } },
    { TelescopeTitle = { fg =  { from = "Boolean", attr = "fg" } } },

    -- Results
    { TelescopeResultsNormal = { link = "NormalFloat" } },
    { TelescopeResultsTitle = { fg = { from = "FloatBorder" },bg = "NONE" } },
    { TelescopeResultsBorder = { bg = "NONE", fg = { from = "FloatBorder" } } },

    -- FZFLUA =============================================================
    { FzfLuaNormal = { inherit = "NormalFloat" } },
    { FzfLuaBorder = { fg = { from = "FloatBorder" }, bg = { from = "NormalFloat", attr = "bg" } } },
    { FzfLuaTitle = { fg = { from = "Boolean", attr = "fg", alter = 0.2 }, bg = { from = "FzfLuaNormal", attr = "bg" } } },
    { FzfLuaTitleIcon = { fg = { from = "Boolean", attr = "fg", alter = 0.2 }, bg = { from = "FzfLuaNormal", attr = "bg" } } },
    { FzfLuaCursorLine = { bg = { from = "ErrorMsg", alter = -0.8, attr = "fg" } } },

    -- WHICH-KEY ==========================================================
    { WhichKeyBorder = { fg = { from = "FzfLuaBorder", attr = "fg", alter = 0.1 }, bg = { from = "NormalFloat", attr = "bg" } } },

    -- NOICE ==============================================================
    { NoicePopupBorder = { fg = { from = "FloatBorder" }, bg = "NONE" } },
    { NoiceCmdlinePopup = { bg = { from = "Pmenu" } } },
    { NoiceCmdlinePopupBorder = { fg = { from = "Pmenu", attr = "fg", alter = -0.7 } } },

    -- ORGMODE ============================================================
    { OrgDONE = { fg = "#00FF00" } },

    -- HLSEARCH ===========================================================
    { HlSearchLensNear = { bg = { from = "IncSearch", attr = "bg" }, fg = { from = "IncSearch", attr = "bg", alter = -0.3 }, bold = true } },

    -- BUFFERLINE =========================================================
    { BufferLineIndicatorSelected = { bg = { from = "ColorColumn" } } },
    { OctoEditable = { bg = { from = "ColorColumn" } } },
    { OctoBubble = { link = "Normal" } },

    -- BQF ================================================================
    { BqfSign = { bg = { from = "ColorColumn", attr = "bg" }, { fg = { from = "@field" } } } },

    -- TODOTROUBLE ========================================================
    { TodoSignWarn = { bg = { from = "Normal", attr = "bg" }, fg = { from = "DiagnosticWarn" } } },
    { TodoSignFIX = { bg = { from = "Normal", attr = "bg" }, fg = { from = "DiagnosticSignError" } } },
    { TodoSignTODO = { bg = { from = "Normal", attr = "bg" }, fg = { from = "OrgDONE" } } },
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
    StatusLineNC = "PanelStNC",
    SignColumn = "PanelBackground",
    VertSplit = "PanelVertSplit",
    WinSeparator = "PanelWinSeparator",
  }
end

-- stylua: ignore
local function colorscheme_overrides()
  local overrides = {
    ["doom-one"] = {
      { diffChange = { bg = { from = "DiffModifiedGutter", attr = "fg", alter = -0.2 }, fg = { from = "DiffModifiedGutter" , attr = "fg", alter = 0.5 } } },
      { diffAdd = { bg = { from = "DiffAddedGutter" , attr = "fg", alter = -0.2 }, fg = { from = "DiffAddedGutter" , attr = "fg", alter = 0.5 } } },
      { diffDelete = { bg = { from = "DiffRemovedGutter" , attr = "fg", alter = -0.2 }, fg = { from = "DiffRemovedGutter" , attr = "fg", alter = 0.5 } } },

      { NeogitDiffAdd =  { link = "diffAdd"} } ,
      { NeogitDiffAddHighlight = { link = "diffChange" } },
      { NeogitDiffDelete =  { link = "diffDelete" } } ,
      { NeogitDiffDeleteHighlight =  { link = "diffDelete" } } ,
    },
    ["gruvbox"] = {
      { diffChange = { bg = { from = "GitSignsChange" , attr = "fg", alter = -0.3 }, fg = { from = "GitSignsChange" , attr = "fg", alter = 0.5 } } },
      { diffAdd = { bg = { from = "GitSignsAdd" , attr = "fg", alter = -0.3 }, fg = { from = "GitSignsAdd" , attr = "fg", alter = 0.5 } } },
      { diffDelete = { bg = { from = "GitSignsDelete" , attr = "fg", alter = -0.3 }, fg = { from = "GitSignsDelete" , attr = "fg", alter = 0.5 } } },
      { diffText = { bg = { from = "diffText" , attr = "bg", alter = -0.3 }, fg = { from = "diffText" , attr = "bg", alter = 0.5 } } },
      { StatusLine = { fg = { from = "ColorColumn", attr = "bg", alter = 0.5 }, bg = { from = "Normal" , attr = "bg", alter = 0.2 }, reverse = false } },
    },
    ["miasma"] = {
      { GitSignsAdd = { bg = "NONE", fg = { from = "GitSignsAdd" , attr = "fg" } } },
      { GitSignsChange = { bg = "NONE", fg = { from = "GitSignsChange" , attr = "fg" } } },
      { GitSignsDelete = { bg = "NONE", fg = { from = "GitSignsDelete" , attr = "fg" } } },

      { LspReferenceText = { bg = { from = 'Normal', attr = "bg" }, fg = "NONE", underline = false, reverse = false, undercurl = false } },
      { LspReferenceWrite = { bg = { from = 'Normal', attr = "bg" }, bold = true, italic = true, underline = false, reverse = false, undercurl =false }  },
      { LspReferenceRead = { bg = { from = "Normal", attr = "bg" }, underline = false, undercurl = false } },

      { String = { fg = { from = "String", attr = "fg", alter = 0.4 } } },
      { Comment = { fg = { from = "Comment", attr = "fg", alter = -0.3 } } },
    },
    ["onedark"] = {},
    ["solarized-osaka"] = {
      { NormalNC = { inherit = "Normal" } },
      { TroubleNormal = { inherit = "Normal" } },
      { GitSignsAdd = { bg = { from = "Normal", attr = "bg" }, fg = { from = "diffAdded" } } },
      { GitSignsChange = { bg = { from = "Normal", attr = "bg" }, fg = { from = "diffChanged" } } },
      { GitSignsDelete = { bg = { from = "Normal", attr = "bg" },  fg = { from = "diffRemoved" } } },

      { diffChange = { bg = { from = "GitSignsChange" , attr = "fg", alter = 0.05 }, fg = { from = "GitSignsChange" , attr = "fg", alter = -0.5 } } },
      { diffAdd = { bg = { from = "GitSignsAdd" , attr = "fg", alter = 0.05 }, fg = { from = "GitSignsAdd" , attr = "fg", alter = -0.5 } } },
      { diffDelete = { bg = { from = "GitSignsDelete" , attr = "fg", alter = 0.05 }, fg = { from = "GitSignsDelete" , attr = "fg", alter = -0.5 } } },
      { diffText = { bg = { from = "diffText" , attr = "fg", alter = 0.05 }, fg = { from = "diffText" , attr = "fg", alter = -0.4 } } },

      { LineNr = { fg = { from = "Normal", attr = "bg", alter = 1 }, bg = { from = "Normal", attr = "bg" } } },
      { CursorLine = { bg = { from = "Normal", alter = 0.4 } } },
      { MyCursorLine = { bg = { from = "Normal", alter = 0.4 } } },
    },
    ["seoul256"] = {
      { GitSignsAdd = { bg = "NONE", fg = { from = "GitGutterAdd" , attr = "fg" } } },
      { GitSignsChange = { bg = "NONE", fg = { from = "GitGutterChange" , attr = "fg" } } },
      { GitSignsDelete = { bg = "NONE", fg = { from = "GitGutterDelete" , attr = "fg" } } },

      { diffChange = { bg = { from = "GitSignsChange" , attr = "fg", alter = 0.05 }, fg = { from = "GitSignsChange" , attr = "fg", alter = -0.5 } } },
      { diffAdd = { bg = { from = "GitSignsAdd" , attr = "fg", alter = 0.05 }, fg = { from = "GitSignsAdd" , attr = "fg", alter = -0.5 } } },
      { diffDelete = { bg = { from = "GitSignsDelete" , attr = "fg", alter = 0.05 }, fg = { from = "GitSignsDelete" , attr = "fg", alter = -0.5 } } },
      { diffText = { bg = { from = "diffText" , attr = "fg", alter = 0.05 }, fg = { from = "diffText" , attr = "fg", alter = -0.4 } } },

      { NeogitDiffAdd =  { link = "diffAdd"} } ,
      { NeogitDiffAddHighlight = { link = "diffAdd" } },
      { NeogitDiffDelete =  { link = "diffDelete" } } ,
      { NeogitDiffDeleteHighlight =  { link = "diffDelete" } } ,
      { CursorLine = { bg = { from = "Normal", alter = 0.2 } } },


      { Comment = { fg = { from = "Comment", attr = "fg", alter = 0.3 } } },
      { CodeBlock1 = { bg = { from = "Normal", alter = -0.25 } } },
    },
    ["kanagawa"] = {
      { GitSignsAdd = { bg = "NONE", fg = { from = "diffAdd" , attr = "fg" } } },
      { GitSignsChange = { bg = "NONE", fg = { from = "diffChange" , attr = "fg" } } },
      { GitSignsDelete = { bg = "NONE", fg = { from = "diffDelete" , attr = "fg" } } },
    },
    ["terafox"] = {},
    ["oxocarbon"] = {
      { diffChange = { bg = { from = "DiffChanged" , attr = "fg", alter = -0.3 }, fg = { from = "DiffChanged" , attr = "fg", alter = 0.5 } } },
      { diffAdd = { bg = { from = "DiffAdded" , attr = "fg", alter = -0.3 }, fg = { from = "DiffAdded" , attr = "fg", alter = 0.5 } } },
      { diffDelete = { bg = { from = "DiffRemoved" , attr = "fg", alter = -0.3 }, fg = { from = "DiffRemoved" , attr = "fg", alter = 0.5 } } },
      { diffText = { bg = { from = "diffText" , attr = "bg", alter = -0.3 }, fg = { from = "diffText" , attr = "bg", alter = 0.5 } } },

      { NeogitDiffAdd =  { link = "diffAdd"} } ,
      { NeogitDiffAddHighlight = { link = "diffAdd" } },
      { NeogitDiffDelete =  { link = "diffDelete" } } ,
      { NeogitDiffDeleteHighlight =  { link = "diffDelete" } } ,
    },
    ["selenized"] = {
      { GitSignsAdd = { bg = { from = "Normal", attr = "bg" } } },
      { GitSignsChange = { bg = { from = "Normal", attr = "bg" } } },
      { GitSignsDelete = { bg = { from = "Normal", attr = "bg" } } },
      { Visual = { bg = { from = "Visual", attr = "bg", alter = 0.2 } } },
    },
    ["bamboo"] = {
      { ["@comment"] = { fg = { from = "@comment", attr = "fg", alter = -0.5 } } },
    },
    ["catppuccin-latte"] = {
      { Comment = { fg = { from = "Normal", attr = "bg", alter = -0.4 } } },

      { CmpItemAbbr = { fg = { from = "Normal", attr = "bg", alter = -0.5 }, bg = "NONE" } },
      { CmpItemAbbrMatch = { fg = { from = "Error", alter = 0.2 }, bg = "NONE", bold = false } },
      { CmpItemAbbrMatchFuzzy = { fg = { from = "Error", alter = -0.5 } } },

      { PmenuSel = { fg = { from = "CmpItemAbbr" , attr = "fg", alter = -4 }, bg = { from = "Normal" , attr = "bg" , alter = 0.5 } } },
      { Pmenu = { bg = { from = "Normal", attr = "bg", alter = -1 }, fg = { from = "CmpItemAbbr" } } },
      { PmenuThumb = { bg = { from = "Normal", attr = "bg", alter = -0.3 } } },
    },
    ["tokyonight"] = {
      { WinSeparator = { fg = { from = "Normal", attr = "bg", alter = -0.1 }, bg = "NONE" } },
      { FloatBorder = { bg = "NONE", fg = { from = "WinSeparator" } } },
      { Comment = { fg = { from = "Normal", attr = "bg", alter = -0.3 } } },
      { LineNr = { fg = { from = "Normal", attr = "bg", alter = -0.1 } } },
      { CursorLine = { bg = { from = "Normal", alter = 0.03 } } },
      { CursorLineNr = { fg = { from = "Boolean", attr = "fg", alter = 0.4 }, bg = { from = "Normal", attr = "bg", alter = 0.03 } } },

      { Folded = { bg = { from = "Normal", attr = "bg", alter = -0.1 }, fg = "NONE" } },

      { CmpItemAbbr = { fg = { from = "Normal", attr = "bg", alter = -0.5 }, bg = "NONE" } },
      { CmpItemAbbrMatch = { fg = { from = "Error", alter = 0.2 }, bg = "NONE", bold = false } },
      { CmpItemAbbrMatchFuzzy = { fg = { from = "Error", alter = -0.5 } } },

      { PmenuSel = { fg = { from = "CmpItemAbbr" , attr = "fg", alter = -4 }, bg = { from = "Normal" , attr = "bg" , alter = -0.1 } } },
      { Pmenu = { bg = { from = "Normal", attr = "bg", alter = -1 }, fg = { from = "CmpItemAbbr" } } },
      { PmenuThumb = { bg = { from = "WinSeparator", attr = "fg" } } },

      { TelescopePromptTitle = { bg = { from = "Normal", attr = "bg" }, fg = { from = "WarningMsg", alter = 0.5, bold = true }, bold = true } },
      { TelescopePromptBorder = { bg = "NONE", fg = { from = "FloatBorder" } } },
      { TelescopePromptPrefix = { bg = { from = "Normal", attr = "bg" } } },
      { TelescopePromptCounter = { bg = { from = "Normal", attr = "bg" } } },

      -- Preview
      { TelescopePreviewTitle = { bg = { from = "Normal", attr = "bg" }, fg = { from = "ColorColumn", alter = 0.14, bold = true }, bold = true } },
      { TelescopePreviewBorder = { bg = "NONE", fg = { from = "FloatBorder" } } },
      { TelescopeMatching = { inherit = "CmpItemAbbrMatchFuzzy" } },
      { TelescopeSelection = { inherit = "PmenuSel" } },
      { TelescopeTitle = { fg =  { from = "Boolean", attr = "fg" } } },

      -- Results
      { TelescopeResultsTitle = { fg = { from = "FloatBorder" },bg = "NONE" } },
      { TelescopeResultsBorder = { bg = "NONE", fg = { from = "FloatBorder" } } },

      -- FZFLUA =============================================================
      { FzfLuaNormal = { inherit = "Normal" } },
      { FzfLuaBorder = { fg = { from = "FloatBorder" }, bg = { from = "Normal", attr = "bg" } } },
      { FzfLuaTitle = { fg = { from = "Boolean", attr = "fg", alter = 0.2 }, bold = true } },
      { FzfLuaCursorLine = { bg = { from = "ErrorMsg", alter = -0.8, attr = "fg" } } },


      { StatusLine = { fg = { from = "ColorColumn", attr = "bg", alter = 0.5 }, bg = { from = "Normal" , attr = "bg", alter = -0.05 } } },
    },
    ["moonfly"] = {
      { GitSignsAdd = { bg = { from = "Normal", attr = "bg", alter = 1.5 }, fg = { from = "DiffAdded", attr = "fg" } } },
      { GitSignsChange = { bg = { from = "Normal", attr = "bg", alter = 1.5 },  fg = { from = "DiffChanged", attr = "fg" } } },
      { GitSignsDelete = { bg = { from = "Normal", attr = "bg", alter = 1.5 },  fg = { from = "DiffRemoved", attr = "fg"} } },

      { LineNr = { bg = { from = "Normal", attr = "bg", alter = 1.5 }, fg = { from = "FoldColumn", attr = "bg", alter = 4 } } },

      { FloatBorder = { bg = "NONE", fg = { from = "ColorColumn", attr ="bg", alter= 4 } } },
      { WinSeparator = { fg = { from = "Normal", attr = "bg", alter = 2.5 }, bg = { from = "ColorColumn" } } },

      { CmpItemAbbr = { fg = { from = "ColorColumn", attr = "bg", alter = 7 }, bg = "NONE" } },
      { CmpItemAbbrMatch = { fg = { from = "Error", alter = 0.2 }, bg = "NONE", bold = false } },
      { CmpItemAbbrMatchFuzzy = { fg = { from = "Error", alter = -0.5 } } },

      { PmenuSel = { fg = { from = "CmpItemAbbr" , attr = "fg", alter = 3 }, bg = { from = "Normal" , attr = "bg" , alter = 0.5 } } },
      { Pmenu = { bg = { from = "Normal", attr = "bg", alter = -1 }, fg = { from = "CmpItemAbbr" } } },
      { PmenuThumb = { bg = { from = "Normal", attr = "bg", alter = 0.3 } } },

      { FzfLuaBorder = { fg = { from = "FloatBorder" }, bg = { from = "Normal", attr = "bg" } } },
    },
    ["base16-emil"] = {
      { Normal = { fg = { from = "Normal", attr = "fg" }, bg = { from = "Normal", attr = "bg", alter= 0.15 } } } ,
      { CursorLine = { bg = { from = "ColorColumn", alter = 0.4 } } } ,

      { CmpItemAbbr = { fg = { from = "ColorColumn", attr = "bg", alter = -0.5 }, bg = "NONE" } },
      { CmpItemAbbrMatch = { fg = { from = "Error", alter = 0.2 }, bg = "NONE", bold = false } },
      { CmpItemAbbrMatchFuzzy = { fg = { from = "Error", alter = -0.5 } } },

      { PmenuSel = { fg = { from = "CmpItemAbbr" , attr = "fg", alter = -4 }, bg = { from = "Normal" , attr = "bg" , alter = 0.5 } } },
      { Pmenu = { bg = { from = "Normal", attr = "bg", alter = -1 }, fg = { from = "CmpItemAbbr" } } },
      { PmenuThumb = { bg = { from = "Normal", attr = "bg", alter = 0.3 } } },
    }
  }

  local hls = overrides[vim.g.colors_name]
  if hls then Highlight.all(hls) end
end

local function user_highlights()
  general_overrides()
  set_sidebar_highlight()
  colorscheme_overrides()
end

Util.cmd.augroup("UserHighlights", {
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
