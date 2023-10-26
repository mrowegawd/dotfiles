local Util = require "r.utils"

local highlight = require "r.config.highlights"

-- stylua: ignore
local general_overrides = function()
  highlight.all {
    -- { Directory = { fg = { from = "Directory", attr = "fg", alter = -0.5 } } },
    { Normal = { fg = { from = "Normal", attr = "fg", alter = -0.2 } } },
    { ColorColumn = { bg = { from = "Normal" } } },
    { FoldColumn = { bg = "NONE", fg = { from = "ColorColumn", attr = "bg", alter = 0.2 } } },
    { LineNr = { bg = "NONE", fg = { from = "FoldColumn", attr = "fg", alter = 0.2 } } },
    { CursorLineNr = { fg = { from = "ColorColumn", attr = "bg", alter = 1.5 }, bg = "NONE" } },
    { Type = { italic = true, bold = true } },
    { NormalFloat = { bg = { from = "ColorColumn", attr = "bg", alter = -0.05 }, fg = { from = "ColorColumn", attr = "fg", alter = -0.56 } } },
    { FloatBorder = { bg = { from = "ColorColumn", attr = "bg", alter = -0.05 }, fg = { from = "ColorColumn", attr = "fg", alter = -0.56 } } },
    { Comment = { fg = { from = "ColorColumn", attr = "bg", alter = 0.5 }, italic = true } },
    { Folded = { bg = { from = "ColorColumn", attr = "bg", alter = -0.2 }, underline = false } },
    { EndOfBuffer = { bg = "NONE" } },
    { Statusline = { bg = { from = "ColorColumn", attr = "bg", alter = 0.05 } } } ,
    { SignColumn = { bg = "NONE" } },
    { MarkSignNumHL = { inherit = "SpecialKey", bg = "NONE" } },
    { WinSeparator = { fg = { from = "NormalFloat", attr = "fg", alter = -0.25 }, bg = "NONE"  } },

    -----------------------------------------------------------------------------//
    --  Spell
    -----------------------------------------------------------------------------//
    { SpellBad = { undercurl = true, bg = "NONE", fg = "NONE", sp = "green" } },
    { SpellRare = { undercurl = true } },

    -----------------------------------------------------------------------
    --  SEMANTIC TOKENS
    -----------------------------------------------------------------------
    { ["@lsp.type.variable"] = { clear = true } },
    -- { ["@lsp.typemod.method"] = { link = "@method" } },
    -- { ["@lsp.type.parameter"] = { italic = true, fg = { from = "Normal" } } },
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
    -- { ["@type.qualifier"] = { inherit = "@keyword", italic = true } },
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
    { diffAdded = { inherit = "DiffAdd" } },
    { diffChanged = { inherit = "DiffChange" } },
    { diffRemoved = { link = "DiffDelete" } },
    { diffBDiffer = { link = "WarningMsg" } },
    { diffCommon = { link = "WarningMsg" } },
    { diffDiffer = { link = "WarningMsg" } },
    { diffFile = { link = "Directory" } },
    { diffIdentical = { link = "WarningMsg" } },
    { diffIndexLine = { link = "Number" } },
    { diffIsA = { link = "WarningMsg" } },
    { diffNoEOL = { link = "WarningMsg" } },
    { diffOnly = { link = "WarningMsg" } },

    { ["@text.diff.add"] = { link = "DiffAdd" } },
    { ["@text.diff.delete"] = { link = "DiffDelete" } },

    -----------------------------------------------------------------------
    -- LSP
    -----------------------------------------------------------------------
    { LspCodeLens = { inherit = "Comment", bold = true, italic = false } },
    { LspCodeLensSeparator = { bold = false, italic = false } },
    { LspReferenceText = { bg = "NONE", underline = true, sp = { from = "Comment", attr = "fg" } } },
    { LspReferenceRead = { link = "LspReferenceText" } },
    { LspReferenceWrite = { inherit = "LspReferenceText", bold = true, italic = true, underline = true } },
    { LspSignatureActiveParameter = { link = "Visual" } },
    { LspInlayhint = { bg = { from = "ColorColumn", attr = "bg", alter = -0.4 }, fg = { from = "Directory", attr = "fg", alter = -0.3 } } },

    { TreesitterContextSeparator = { fg = { from = "WinSeparator", attr = "fg", alter = -0.1 }, bg = "NONE" } },
    { TreesitterContextLineNumber = { inherit = "LineNr" } },
    { TreesitterContext = { inherit = "ColorColumn" } },

    { illuminatedWordText = { link = "LspReferenceText" } },
    { illuminatedWordWrite = { bg = { from = "Directory", attr = "fg", alter = -0.25 }, fg = "NONE" } },
    { illuminatedWordRead = { bg = { from = "Directory", attr = "fg", alter = -0.25 }, fg = "NONE" } },

    -----------------------------------------------------------------------
    -- DIAGNOSTIC
    -----------------------------------------------------------------------
    { DiagnosticHint = { bg = "NONE" } },
    { DiagnosticError = { bg = "NONE" } },
    { DiagnosticWarning = { bg = "NONE" } },
    { DiagnosticInfo = { bg = "NONE" } },
    { DiagnosticSignError = { bg = "NONE" } },
    { DiagnosticSignWarn = { bg = "NONE" } },
    { DiagnosticSignInfo = { bg = "NONE" } },
    { DiagnosticSignHint = { bg = "NONE" } },

    -- Floating windows
    { DiagnosticFloatingWarn = { link = "DiagnosticWarn" } },
    { DiagnosticFloatingInfo = { link = "DiagnosticInfo" } },
    { DiagnosticFloatingHint = { link = "DiagnosticHint" } },
    { DiagnosticFloatingError = { link = "DiagnosticError" } },
    { DiagnosticFloatTitle = { inherit = "FloatTitle", bold = true } },
    { DiagnosticFloatTitleIcon = { inherit = "FloatTitle", fg = { from = "@character" } } },

    { GitSignsAdd = { bg = "NONE" } },
    { GitSignsChange = { bg = "NONE" } },
    { GitSignsDelete = { bg = "NONE" } },

    -----------------------------------------------------------------------
    -- CREATED HIGHLIGHTS
    -----------------------------------------------------------------------
    { MyCursorline = { bg = { from = "Normal", alter = 0.2 } } },
    { Mystatusline_fg = { fg = { from = "LineNr", alter = 0.1 } } },
    { Mystatusline_bg = { bg = { from = "Normal", alter = -0.1 } } },
    { bufferline_unselected = { bg = { from = "Normal", attr = "bg", alter = 0.2 } } },
    { Mygreen_fg = { fg = { from = "GitSignsAdd", attr = "fg", alter = 0.1 } } },
    { Mymisc_fg = { fg = { from = "Boolean", atrr = "fg", alter = 0.1 }, bg = { from = "Normal", alter = -0.1 } } },
    { MyQuickFixLineLeave = { bg = { from = "CursorLine", alter = 0.2 } } },
    { MyQuickFixLineEnter = { bg = { from = "CursorLine", alter = 0.6 }, fg = { from = "CursorLine", attr = "bg", alter = 2 }, bold = true } },
    { CodeBlock1 = { bg = { from = "ColorColumn", alter = -0.15 } } },
    { CodeBlock2 = { bg = "cyan" } },
    { BorderDirectory = { bg = { from = "Directory", attr = "fg" }, fg = "NONE" } },
    { WinSeparatorCUS = { fg = { from = "WinSeparator", attr = "bg", alter = 0.2 } } },

    -----------------------------------------------------------------------
    -- PLUGINS
    -----------------------------------------------------------------------

    -- CMP ================================================================
    { CmpItemAbbr = { fg = { from = "Normal", attr = "fg", alter = -0.3 }, bg = "NONE" } },
    { CmpItemAbbrMatch = { fg = { from = "ErrorMsg", alter = 0.2 }, bg = "NONE", bold = false } },
    { CmpItemAbbrMatchFuzzy = { fg = { from = "ErrorMsg", alter = -0.3 } } },

    { PmenuSel = { fg = { from = "CmpItemAbbr" , attr = "fg", alter = 3 }, bg = { from = "CmpItemAbbr" , attr = "fg" , alter = -0.45 } } },
    { Pmenu = { bg = { from = "Normal", attr = "bg", alter = 0.3 }, fg = { from = "CmpItemAbbr" } } },
    { PmenuThumb = { bg = { from = "Normal", attr = "bg", alter = 0.3 } } },

    -- TELESCOPE ==========================================================
    { TelescopeNormal = { fg = { from= "CmpItemAbbr", attr = "fg" }, bg = { from = "Normal", attr = "bg" } } },
    { TelescopeBorder = { inherit = "FloatBorder" } },

    -- Prompt
    { TelescoeePromptTitle = { bg = { from = "Normal", attr = "bg" }, fg = { from = "WarningMsg", alter = 0.5, bold = true }, bold = true } },
    { TelescopePromptBorder = { inherit = "FloatBorder" } },
    { TelescopePromptPrefix = { bg = { from = "Normal", attr = "bg" } } },
    { TelescopePromptCounter = { bg = { from = "Normal", attr = "bg" } } },

    -- Preview
    { TelescopePreviewTitle = { bg = { from = "Normal", attr = "bg" }, fg = { from = "Normal", alter = 0.14, bold = true }, bold = true } },
    { TelescopeMatching = { inherit = "CmpItemAbbrMatchFuzzy" } },
    { TelescopeSelection = { inherit = "PmenuSel" } },
    { TelescopeTitle = { fg =  { from = "Boolean", attr = "fg" } } },

    -- Results
    { TelescopeResultsTitle = { fg = { from = "FloatBorder" },bg = "NONE" } },

    -- FZFLUA =============================================================
    { FzfLuaNormal = { inherit = "Normal" } },
    { FzfLuaBorder = { inherit = "WinSeparator" } },
    { FzfLuaTitle = { fg = { from = "Boolean", attr = "fg", alter = -0.3 } } },
    { FzfLuaCursorLine = { bg = { from = "ErrorMsg", alter = -0.8, attr = "fg" } } },

    -- WHICH-KEY ==========================================================
    { WhichKeyBorder = { fg = { from = "FzfLuaBorder", attr = "fg", alter = 0.1 } } },

    -- NOICE ==============================================================
    { NoicePopupBorder = { bg = "NONE", fg = { from = "Directory", attr = "fg" } } },
    { NoiceCmdlinePopup = { bg = { from = "Pmenu" } } },
    { NoiceCmdlinePopupBorder = { fg = { from = "Pmenu", attr = "fg", alter = -0.7 } } },

    -- ORGMODE ============================================================
    { OrgDONE = { fg = "#00FF00" } },

    -- MINIINDENTSCOPE ====================================================
    { MiniIndentscopeSymbol = { fg = { from = "Directory", attr = "fg", alter = -0.2 } } },

    -- HLSEARCH ===========================================================
    { HlSearchLensNear = { bg = { from = "IncSearch", attr = "bg" }, fg = { from = "IncSearch", attr = "bg", alter = -0.3 }, bold = true } },
  }
end

local function set_sidebar_highlight()
  highlight.all {
    { PanelDarkBackground = { bg = { from = "Normal", alter = -0.2 } } },
    { PanelDarkHeading = { inherit = "PanelDarkBackground", bold = true } },
    { PanelBackground = { bg = { from = "Normal", alter = -0.2 } } },
    { PanelHeading = { inherit = "PanelBackground", bold = true } },
    { PanelWinSeparator = { inherit = "PanelBackground", fg = { from = "WinSeparator" } } },
    { PanelStNC = { link = "PanelWinSeparator" } },
    { PanelSt = { bg = { from = "Visual", alter = -0.2 } } },
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
    -- Theme dengan nama ini, tidak perlu diinstall karena tidak bisa di custom
    -- pada function ini (I dont use it anymore)
    -- {"kanagawa", "catppuccin"}
    ["doom-one"] = {
      { CursorLine = { bg = { from = "ColorColumn", attr= "bg", alter = 0.2 } } },
      { Substitute = { strikethrough = false } },
    },
    ["gruvbox-material"] = {
      { CmpItemAbbr = { fg = { from = "ColorColumn", attr = "bg", alter = 1 }, bg = "NONE" } },
      { PmenuSel = { fg = { from = "CmpItemAbbr" , attr = "fg", alter = 4 }, bg = { from = "Normal" , attr = "bg" , alter = 0.5 } } },
      { WinSeparator = { fg = { from = "ColorColumn", attr = "bg", alter = 0.3 }, bg = "NONE"  } },
      { FzfLuaBorder = { inherit = "WinSeparator" } },
      { TreesitterContextSeparator = { fg = { from = "WinSeparator", attr = "fg", alter = -0.15 }, bg = "NONE" } },
      { Folded = { bg = { from = "ColorColumn", attr = "bg", alter = 0.3 } } },

      { Comment = { fg = { from = "ColorColumn", attr = "bg", alter = 0.9 }, italic = true } },
      { WhichKeyBorder = { fg = { from = "FzfLuaBorder", attr = "fg", alter = 0.1 } } },

      { TelescopeNormal = { fg = { from= "CmpItemAbbr", attr = "fg" }, bg = { from = "Normal", attr = "bg" } } },
      { TelescopeBorder = { inherit = "FzfLuaBorder" } },
      { TelescoeePromptTitle = { bg = { from = "Normal", attr = "bg" }, fg = { from = "WarningMsg", alter = 0.5, bold = true }, bold = true } },
      { TelescopePromptBorder = { inherit = "FloatBorder" } },
      { TelescopePromptPrefix = { bg = { from = "Normal", attr = "bg" } } },
      { TelescopePromptCounter = { bg = { from = "Normal", attr = "bg" } } },
      { TelescopeMatching = { inherit = "CmpItemAbbrMatchFuzzy" } },
      { TelescopeSelection = { inherit = "PmenuSel" } },
      { TelescopeTitle = { fg =  { from = "Boolean", attr = "fg" } } },
    },
    ["solarized"] = {
      { Folded = { underline = false, bg = { from = "ColorColumn", attr = "bg", alter = -0.5 } } },
      { WinBar = { bg = "NONE" } },
      { Directory = { bg = "NONE" } },
      { CursorLine = { bg = { from = "ColorColumn", attr = "bg",  alter = 0.4 } } },

      { CmpItemAbbr = { fg = { from = "ColorColumn", attr = "bg", alter = 1 }, bg = "NONE" } },
      { PmenuSel = { fg = { from = "CmpItemAbbr" , attr = "fg", alter = 4 }, bg = { from = "Normal" , attr = "bg" , alter = 0.5 } } },
      { WinSeparator = { fg = { from = "ColorColumn", attr = "bg", alter = 0.3 }, bg = "NONE"  } },
      { FzfLuaBorder = { inherit = "WinSeparator" } },
      { TreesitterContextSeparator = { fg = { from = "WinSeparator", attr = "fg", alter = -0.15 }, bg = "NONE" } },
      { Folded = { bg = { from = "ColorColumn", attr = "bg", alter = 0.3 } } },

      { Comment = { fg = { from = "ColorColumn", attr = "bg", alter = 0.9 }, italic = true } },
      { WhichKeyBorder = { fg = { from = "FzfLuaBorder", attr = "fg", alter = 0.1 } } },

      { TelescopeNormal = { fg = { from= "CmpItemAbbr", attr = "fg" }, bg = { from = "Normal", attr = "bg" } } },
      { TelescopeBorder = { inherit = "FzfLuaBorder" } },
      { TelescoeePromptTitle = { bg = { from = "Normal", attr = "bg" }, fg = { from = "WarningMsg", alter = 0.5, bold = true }, bold = true } },
      { TelescopePromptBorder = { inherit = "FloatBorder" } },
      { TelescopePromptPrefix = { bg = { from = "Normal", attr = "bg" } } },
      { TelescopePromptCounter = { bg = { from = "Normal", attr = "bg" } } },
      { TelescopeMatching = { inherit = "CmpItemAbbrMatchFuzzy" } },
      { TelescopeSelection = { inherit = "PmenuSel" } },
      { TelescopeTitle = { fg =  { from = "Boolean", attr = "fg" } } },
    },
    ["miasma"] = {
      { Directory = { bg = "NONE" } },
      { CursorLine = { bg = { from = "ColorColumn", attr = "bg",  alter = 0.5 } } },

      { CmpItemAbbr = { fg = { from = "ColorColumn", attr = "bg", alter = 1 }, bg = "NONE" } },
      { PmenuSel = { fg = { from = "CmpItemAbbr" , attr = "fg", alter = 4 }, bg = { from = "Normal" , attr = "bg" , alter = 0.5 } } },
      { WinSeparator = { fg = { from = "ColorColumn", attr = "bg", alter = 0.3 }, bg = "NONE"  } },
      { FzfLuaBorder = { inherit = "WinSeparator" } },
      { TreesitterContextSeparator = { fg = { from = "WinSeparator", attr = "fg", alter = -0.15 }, bg = "NONE" } },
      { Folded = { bg = { from = "ColorColumn", attr = "bg", alter = 0.3 } } },

      { Comment = { fg = { from = "ColorColumn", attr = "bg", alter = 0.9 }, italic = true } },
      { WhichKeyBorder = { fg = { from = "FzfLuaBorder", attr = "fg", alter = 0.1 } } },

      { TelescopeNormal = { fg = { from= "CmpItemAbbr", attr = "fg" }, bg = { from = "Normal", attr = "bg" } } },
      { TelescopeBorder = { inherit = "FzfLuaBorder" } },
      { TelescoeePromptTitle = { bg = { from = "Normal", attr = "bg" }, fg = { from = "WarningMsg", alter = 0.5, bold = true }, bold = true } },
      { TelescopePromptBorder = { inherit = "FloatBorder" } },
      { TelescopePromptPrefix = { bg = { from = "Normal", attr = "bg" } } },
      { TelescopePromptCounter = { bg = { from = "Normal", attr = "bg" } } },
      { TelescopeMatching = { inherit = "CmpItemAbbrMatchFuzzy" } },
      { TelescopeSelection = { inherit = "PmenuSel" } },
      { TelescopeTitle = { fg =  { from = "Boolean", attr = "fg" } } },

    },
    ["nano-theme"] = {
      -- { Normal = { fg = { from = "Directory", alter = -0.2 } } },
      -- { Pmenu = { fg = { from = "Pmenu", attr = "fg", alter = -0.1 }, bg = { from = "Pmenu", attr = "bg", alter = -0.5 } } },
      -- { ColorColumn = { bg = { from = "Normal", alter = 0.1 } } },
      -- { Directory = { fg = { from = "LineNr", attr = "fg", alter = 0.5 } } },
      -- { Folded = { bg = { from = "ColorColumn", attr = "bg", alter = -0.1 } } },
      -- { CursorLine = { bg = { from = "Normal", alter = -0.1 } } },
      -- { CjdeBlock1 = { bg = { from = "ColorColumn", alter = 0.4 } } },
      -- { FloatBorder = { fg = { from = "Normal", attr = "fg",alter = -0.4 } } },
      -- { WinSeparator = { bg = "NONE", fg = {from = "Directory", attr = "fg", alter = -1 } } },
      -- { MyQuickFixLineLeave = { bg = { from = "CursorLine", attr = "bg", alter = -0.5 } } },
      -- { FzfLuaBorder = { fg = { from = "Directory", attr = "fg", alter = -0.5 } } },
      -- { TreesitterContextSeparator = { fg = { from = "Normal", attr = "bg", alter = -0.2 } } },
      -- { PmenuSel = { bold = true, fg = "NONE", bg = { from = "ColorColumn", alter = -0.2 } } },
    },
    ["darcubox"] = {
      { Comment = { fg = { from = "ColorColumnn", attr = "fg", alter = -0.6 }, italic = true } },

      { CmpItemAbbr = { fg = { from = "ColorColumn", attr = "bg", alter = 2 }, bg = "NONE" } },
      { PmenuSel = { fg = { from = "CmpItemAbbr" , attr = "fg", alter = 4 }, bg = { from = "Normal" , attr = "bg" , alter = 0.5 } } },
      { WinSeparator = { fg = { from = "ColorColumn", attr = "bg", alter = 0.95 }, bg = "NONE"  } },
      { FzfLuaBorder = { inherit = "WinSeparator" } },
      { TreesitterContextSeparator = { fg = { from = "WinSeparator", attr = "fg", alter = -0.15 }, bg = "NONE" } },
      { WhichKeyBorder = { fg = { from = "FzfLuaBorder", attr = "fg", alter = 0.1 } } },

      { LspCodeLens = { fg = { from = "Comment", attr = "fg", alter = 0.4 , bold = true } } },

      { TelescopeNormal = { fg = { from= "CmpItemAbbr", attr = "fg" }, bg = { from = "Normal", attr = "bg" } } },
      { TelescopeBorder = { inherit = "FzfLuaBorder" } },
      { TelescoeePromptTitle = { bg = { from = "Normal", attr = "bg" }, fg = { from = "WarningMsg", alter = 0.5, bold = true }, bold = true } },
      { TelescopePromptBorder = { inherit = "FloatBorder" } },
      { TelescopePromptPrefix = { bg = { from = "Normal", attr = "bg" } } },
      { TelescopePromptCounter = { bg = { from = "Normal", attr = "bg" } } },
      { TelescopeMatching = { inherit = "CmpItemAbbrMatchFuzzy" } },
      { TelescopeSelection = { inherit = "PmenuSel" } },
      { TelescopeTitle = { fg =  { from = "Boolean", attr = "fg" } } },
    },
    ["darcula-dark"] = {
      { Directory = { bg = "NONE" } },
      -- { CursorLine = { bg = { from = "Normal", alter = 0.5 } } },
      { FlashMatch = { fg = { from = "ErrorMsg", attr = "fg", alter = 0.3 }, bold = true } },
      -- { MyQuickFixLineLeave = { bg = { from = "CursorLine", alter = -0.15 } } },
      -- { Folded = { underline = false, bg = { from = "Folded", attr = "bg", alter = -0.5 } } },
      { illuminatedWordWrite = { bg = { from = "illuminatedWordWrite", attr = "bg", alter = -0.3 }, sp = { from = "Directory", attr = "fg" } } },
      { illuminatedWordRead = { bg = { from = "illuminatedWordRead", attr = "bg", alter = -0.3 }, sp = { from = "Directory", attr = "fg" } } },


      { CmpItemAbbr = { fg = { from = "ColorColumn", attr = "bg", alter = 0.8 }, bg = "NONE" } },
      { PmenuSel = { fg = { from = "CmpItemAbbr" , attr = "fg", alter = 4 }, bg = { from = "Normal" , attr = "bg" , alter = 0.5 } } },
      { WinSeparator = { fg = { from = "ColorColumn", attr = "bg", alter = 0.2 }, bg = "NONE"  } },
      { FzfLuaBorder = { inherit = "WinSeparator" } },
      { TreesitterContextSeparator = { fg = { from = "WinSeparator", attr = "fg", alter = -0.15 }, bg = "NONE" } },
      { WhichKeyBorder = { fg = { from = "FzfLuaBorder", attr = "fg", alter = 0.1 } } },

      { TelescopeNormal = { fg = { from= "CmpItemAbbr", attr = "fg" }, bg = { from = "Normal", attr = "bg" } } },
      { TelescopeBorder = { inherit = "FzfLuaBorder" } },
      { TelescoeePromptTitle = { bg = { from = "Normal", attr = "bg" }, fg = { from = "WarningMsg", alter = 0.5, bold = true }, bold = true } },
      { TelescopePromptBorder = { inherit = "FloatBorder" } },
      { TelescopePromptPrefix = { bg = { from = "Normal", attr = "bg" } } },
      { TelescopePromptCounter = { bg = { from = "Normal", attr = "bg" } } },
      { TelescopeMatching = { inherit = "CmpItemAbbrMatchFuzzy" } },
      { TelescopeSelection = { inherit = "PmenuSel" } },
      { TelescopeTitle = { fg =  { from = "Boolean", attr = "fg" } } },
    },
    ["everforest"] = {
      { illuminatedWordWrite = { bg = { from = "ColorColumn", attr = "bg", alter = -0.2 } } },
      { illuminatedWordRead = { bg = { from = "ColorColumn", attr = "bg", alter = -0.2 } } },
      { Folded = { bg = { from = "ColorColumn", attr = "bg", alter = 0.2 } } },

      { CodeBlock1 = { bg = { from = "ColorColumn", alter = 0.1 } } },

      { CmpItemAbbr = { fg = { from = "ColorColumn", attr = "bg", alter = 0.8 }, bg = "NONE" } },
      { PmenuSel = { fg = { from = "CmpItemAbbr" , attr = "fg", alter = 4 }, bg = { from = "Normal" , attr = "bg" , alter = 0.5 } } },
      { WinSeparator = { fg = { from = "ColorColumn", attr = "bg", alter = 0.2 }, bg = "NONE"  } },
      { FzfLuaBorder = { inherit = "WinSeparator" } },
      { TreesitterContextSeparator = { fg = { from = "WinSeparator", attr = "fg", alter = -0.15 }, bg = "NONE" } },
      { WhichKeyBorder = { fg = { from = "FzfLuaBorder", attr = "fg", alter = 0.1 } } },

      { TelescopeNormal = { fg = { from= "CmpItemAbbr", attr = "fg" }, bg = { from = "Normal", attr = "bg" } } },
      { TelescopeBorder = { inherit = "FzfLuaBorder" } },
      { TelescoeePromptTitle = { bg = { from = "Normal", attr = "bg" }, fg = { from = "WarningMsg", alter = 0.5, bold = true }, bold = true } },
      { TelescopePromptBorder = { inherit = "FloatBorder" } },
      { TelescopePromptPrefix = { bg = { from = "Normal", attr = "bg" } } },
      { TelescopePromptCounter = { bg = { from = "Normal", attr = "bg" } } },
      { TelescopeMatching = { inherit = "CmpItemAbbrMatchFuzzy" } },
      { TelescopeSelection = { inherit = "PmenuSel" } },
      { TelescopeTitle = { fg =  { from = "Boolean", attr = "fg" } } },
    },
    ["night-owl"] = {
      { Comment = { fg = { from = "ColorColumn", attr = "bg", alter = 1.5 } } },

      { CmpItemAbbr = { fg = { from = "ColorColumn", attr = "bg", alter = 1.6 }, bg = "NONE" } },
      { PmenuSel = { fg = { from = "CmpItemAbbr" , attr = "fg", alter = 5 }, bg = { from = "Normal" , attr = "bg" , alter = 0.5 } } },

      { WinSeparator = { fg = { from = "ColorColumn", attr = "bg", alter = 0.4 }, bg = "NONE"  } },
      { FzfLuaBorder = { inherit = "WinSeparator" } },

      { TreesitterContextSeparator = { fg = { from = "WinSeparator", attr = "fg", alter = -0.05 }, bg = "NONE" } },
      { FlashMatch = { bg = { from = "Error", attr = "fg", alter = 5 }, bold = true } },
      { FlashLable = { bg = { from = "ColorColumn", attr = "bg", alter = 5 }, bold = true } },
      { FlashCursor = { bg = { from = "ColorColumn", attr = "bg", alter = 5 }, bold = true } },
      { CursorLine = { bg = { from = "Normal", alter = 0.8 } } },

      { Folded = { underline = false, bg = { from = "ColorColumn", attr = "bg", alter = 0.25 } } },

      { TelescopeNormal = { fg = { from= "CmpItemAbbr", attr = "fg" }, bg = { from = "Normal", attr = "bg" } } },
      { TelescopeBorder = { inherit = "FzfLuaBorder" } },
      { WhichKeyBorder = { fg = { from = "FzfLuaBorder", attr = "fg", alter = 0.1 } } },

      { StatusLine = { fg = { from = "ColorColumn", attr = "bg", alter = 0.3 }, bg = { from = "ColorColumn" , attr = "bg", alter = 2 } } },

      -- Prompt
      { TelescoeePromptTitle = { bg = { from = "Normal", attr = "bg" }, fg = { from = "WarningMsg", alter = 0.5, bold = true }, bold = true } },
      { TelescopePromptBorder = { inherit = "FloatBorder" } },
      { TelescopePromptPrefix = { bg = { from = "Normal", attr = "bg" } } },
      { TelescopePromptCounter = { bg = { from = "Normal", attr = "bg" } } },

      -- Preview
      { TelescopePreviewTitle = { bg = { from = "Normal", attr = "bg" }, fg = { from = "Normal", alter = 0.14, bold = true }, bold = true } },
      { TelescopeMatching = { inherit = "CmpItemAbbrMatchFuzzy" } },
      { TelescopeSelection = { inherit = "PmenuSel" } },
      { TelescopeTitle = { fg =  { from = "Boolean", attr = "fg" } } },
    },
    ["tokyonight"] = {
      { Folded = { underline = false, bg = { from = "ColorColumn", attr = "bg", alter = -0.15 } } },

      { CmpItemAbbr = { fg = { from = "ColorColumn", attr = "bg", alter = 1.5 }, bg = "NONE" } },
      { PmenuSel = { fg = { from = "CmpItemAbbr" , attr = "fg", alter = 5 }, bg = { from = "Normal" , attr = "bg" , alter = 0.5 } } },

      { Comment = { fg = { from = "ColorColumn", attr = "bg", alter = 0.8 } } },
      { CursorLine = { bg = { from = "ColorColumn", alter = 0.4 } } },
      { WinSeparator = { fg = { from = "ColorColumn", attr = "bg", alter = 0.4 }, bg = "NONE"  } },
      { FzfLuaBorder = { inherit = "WinSeparator" } },
      { WhichKeyBorder = { fg = { from = "FzfLuaBorder", attr = "fg", alter = 0.1 } } },
      { TreesitterContextSeparator = { fg = { from = "WinSeparator", attr = "fg", alter = -0.05 }, bg = "NONE" } },
    }
  }

  local hls = overrides[vim.g.colors_name]
  if hls then highlight.all(hls) end
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
