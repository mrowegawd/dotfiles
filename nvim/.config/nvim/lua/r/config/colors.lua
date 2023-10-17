-- if not as then
--   return
-- end

local Util = require "r.utils"

local highlight = require "r.config.highlights"

-- stylua: ignore
local general_overrides = function()
  highlight.all {
    -- { Normal = { fg = { from = "Directory", alter = 0.3 }, bg = "NONE" } },
    { FoldColumn = { bg = "NONE", fg = { from = "ColorColumn", attr = "bg", alter = 0.2 } } },
    { LineNr = { bg = "NONE", fg = { from = "FoldColumn", attr = "fg", alter = 0.2 } } },
    { Directory = { fg = { from = "LineNr", attr = "fg", alter = 0.75 } } },
    { ColorColumn = { bg = { from = "Normal", alter = 0.1 } } },
    { CursorLine = { bg = { from = "Normal", alter = -0.5 } } },
    { CursorLineNr = { fg = { from = "ColorColumn", attr = "bg", alter = 1.5 }, bg = "NONE" } },
    { Pmenu = { bg = { from = "Normal", attr = "bg", alter = 0.3 }, fg = { from = "Normal", attr = "fg", alter = -0.1 } } },
    { PmenuSel = { bold = true, fg = "NONE", bg = { from = "ColorColumn", alter = 0.6 } } },
    { PmenuThumb = { bg = { from = "Normal", attr = "bg", alter = 0.3 } } },
    { Type = { italic = true, bold = true } },
    { NormalFloat = { bg = { from = "Normal" } } },
    { FloatBorder = { bg = { from = "Normal" }, fg = { from = "Directory" } } },
    { Comment = { fg = { from = "Directory", attr = "fg", alter = -0.3 }, italic = true } },
    { Folded = { bg = { from = "Directory", attr = "fg", alter = -0.4 } } },
    { EndOfBuffer = { bg = "NONE" } },
    { SignColumn = { bg = "NONE" } },
    { MarkSignNumHL = { inherit = "SpecialKey", bg = "NONE" } },
    { Normal = { fg = { from = "Directory", alter = 0.3 } } },
    { WinSeparator = { bg = "NONE", fg = { from = "ColorColumn", attr = "bg", alter = 0.15 } } },

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
    -- { DiffAdd = { underline = false, fg = { from = "DiffAdd", attr = "fg", alter = -0.3 } } },
    -- { DiffDelete = { underline = false, fg = { from = "DiffDelete", attr = "fg", alter = -0.3 } } },
    -- { DiffChange = { underline = false, fg = { from = "DiffChange", attr = "fg", alter = -0.3 } } },
    -- { DiffText = { underline = false, fg = { from = "DiffText", attr = "fg", alter = -0.3 } } },
    -- these highlights are syntax groups that are set in diff.vim
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

    { TreesitterContextSeparator = { fg = { from = "Normal", attr = "bg", alter = -0.1 } } },
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
    { CodeBlock1 = { bg = { from = "ColorColumn", alter = 0.2 } } },
    { CodeBlock2 = { bg = "cyan" } },
    { BorderDirectory = { bg = { from = "Directory", attr = "fg" }, fg = "NONE" } },
    { WinSeparatorCUS = { fg = { from = "WinSeparator", attr = "bg", alter = 0.2 } } },
    -----------------------------------------------------------------------
    -- PLUGINS
    -----------------------------------------------------------------------

    -- CMP ================================================================
    { CmpItemAbbr = { fg = { from = "Normal", attr = "fg", alter = -0.3 } } },
    { CmpItemAbbrMatch = { fg = { from = "ErrorMsg", alter = 0.3 }, bg = "NONE", bold = true } },
    { CmpItemMenu = { fg = { from = "Normal", alter = -0.5 }, italic = true } },
    { CmpItemAbbrMatchFuzzy = { fg = { from = "ErrorMsg", alter = -0.3 }, italic = true } },

    -- TELESCOPE ==========================================================
    { TelescopeNormal = { link = "Normal" } },
    { TelescopeBorder = { fg = { from = "Normal", alter = -0.4 }, bg = { from = "Normal", attr = "bg" } } },

    -- Prompt
    { TelescoeePromptTitle = { bg = { from = "Normal", attr = "bg" }, fg = { from = "WarningMsg", alter = 0.14, bold = true }, bold = true } },
    { TelescopePromptBorder = { fg = { from = "Normal", alter = -0.4 }, bg = { from = "Normal", attr = "bg" } } },
    { TelescopePromptPrefix = { bg = { from = "Normal", attr = "bg" } } },
    { TelescopePromptCounter = { bg = { from = "Normal", attr = "bg" } } },

    -- Preview
    { TelescopePreviewTitle = { bg = { from = "Normal", attr = "bg" }, fg = { from = "Normal", alter = 0.14, bold = true }, bold = true } },
    { TelescopeSelection = { link = "PmenuSel" } },
    { TelescopeMatching = { link = "CmpItemAbbrMatch" } },

    -- Results
    { TelescopeResultsTitle = { bg = "NONE" } },

    -- FZFLUA =============================================================
    { FzfLuaNormal = { link = "Normal" } },
    { FzfLuaBorder = { fg = { from = "Directory", attr = "fg" }, bg = { from = "Normal", attr = "bg" } } },
    { FzfLuaTitle = { fg = { from = "Boolean", attr = "fg", alter = -0.3 } } },
    { FzfLuaCursorLine = { bg = { from = "ErrorMsg", alter = -0.8, attr = "fg" } } },

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
    { PanelDarkBackground = { bg = { from = "Normal" } } },
    { PanelDarkHeading = { inherit = "PanelDarkBackground", bold = true } },
    { PanelBackground = { bg = { from = "Normal" } } },
    { PanelHeading = { inherit = "PanelBackground", bold = true } },
    { PanelWinSeparator = { inherit = "PanelBackground", fg = { from = "WinSeparator" } } },
    { PanelStNC = { link = "PanelWinSeparator" } },
    { PanelSt = { bg = { from = "Visual", alter = -0.2 } } },
  }
end

-- stylua: ignore
local function colorscheme_overrides()
  local overrides = {
    -- These colorscheme needs their own config settings
    ["kanagawa"] = {},
    ["catppuccin"] = {},
    ["everblush"] = {},

    ["gruvbox"] = {
      { WinBarNC = { bg = "NONE" } },
      { CmpItemAbbrMatch = { fg = { from = "ErrorMsg", attr = "bg", alter = 0.2 }, bg = "NONE", bold = true } },
    },
    ["doom-one"] = {
      { CmpItemAbbrMatch = { fg = { from = "ErrorMsg", alter = 0.15 }, bg = "NONE", bold = true } },
      { WinSeparator = { bg = "NONE" } },
      { PmenuSel = { fg = { from = "Directory", attr = "fg", alter = 0.6 } } },
    },
    ["gruvbox-material"] = {
      { bufferline_unselected = { bg = { from = "Normal", attr = "fg", alter = -0.75 } } },
      { PmenuSel = { bg = { from = "ColorColumn", alter = 0.6 } } },
      { Folded = { bg = { from = "ColorColumn", attr = "bg", alter = 0.1 } } },
      { TreesitterContextSeparator = { fg = { from = "Normal", attr = "bg", alter = -0.2 } } },
      { IndentBlanklineChar = { fg = { from = "Directory", attr = "fg", alter = -0.8 } } },
    },
    ["github_dark_high_contrast"] = {
      { Comment = { fg = { from = "Directory", alter = 0.9 } } },
      { LineNr = { fg = { from = "LineNr", alter = 0.9 } } },
    },
    ["github_dark_dimmed"] = {
      { illuminatedWordWrite = { bg = { from = "illuminatedWordWrite", attr = "bg", alter = -0.2 } } },
      { illuminatedWordRead = { bg = { from = "illuminatedWordRead", attr = "bg", alter = -0.2 } } },
    },
    ["neosolarized"] = {
      { illuminatedWordWrite = { bg = { from = "illuminatedWordWrite", attr = "bg", alter = -0.3 } } },
      { illuminatedWordRead = { bg = { from = "illuminatedWordRead", attr = "bg", alter = -0.3 } } },
      { CursorLine = { bg = { from = "Normal", alter = 0.25 } } },
      { MatchParen = { bg = { from = "Normal", alter = 0.25 } } },
      { WinSeparator = { bg = "NONE" } },
      { ["@Comment"] = { fg = { from = "Comment" } } },
      { ["@lsp.type.comment"] = { fg = { from = "Comment" } } },
    },
    ["solarized"] = {
      { Folded = { underline = false, bg = { from = "Folded", attr = "bg", alter = -0.3 } } },
      { WinBar = { bg = "NONE" } },
      { MatchParen = { bg = "NONE" } },
      { ErrorMsg = { standout = false, reverse = false } },
      { LineNr = { fg = { from = "LineNr", alter = -0.15 } } },
      { LspReferenceText = { bg = "NONE", standout = false } },
      { illuminatedWordText = { bg = "NONE" } },
      { illuminatedWordWrite = { bg = { from = "illuminatedWordWrite", attr = "bg", alter = -0.2 }, sp = { from = "Directory", attr = "fg" } } },
      { illuminatedWordRead = { bg = { from = "illuminatedWordRead", attr = "bg", alter = -0.2 }, sp = { from = "Directory", attr = "fg" } } },
    },
    ["miasma"] = {
      { CodeBlock1 = { bg = { from = "ColorColumn", alter = 0.4 } } },
    },
    ["darcubox"] = {
      { ["@lsp.type.comment"] = { fg = { from = "Directory", attr = "fg", alter = 0.3 } } },
      { CodeBlock1 = { bg = { from = "ColorColumn", alter = 0.5 } } },
      { LineNr = { fg = { from = "LineNr", alter = 0.4 } } },
    },
    ["darcula-dark"] = {
      { WinSeparator = { bg = "NONE" } },
      { illuminatedWordWrite = { bg = { from = "illuminatedWordWrite", attr = "bg", alter = -0.3 }, sp = { from = "Directory", attr = "fg" } } },
      { illuminatedWordRead = { bg = { from = "illuminatedWordRead", attr = "bg", alter = -0.3 }, sp = { from = "Directory", attr = "fg" } } },
      { CursorLine = { bg = { from = "Normal", alter = 0.25 } } },
      { Normal = { fg = { from = "Directory", alter = 0.3 } } },
      { ["@Comment"] = { fg = { from = "Comment" } } },
    },
    ["everforest"] = {
      { illuminatedWordWrite = { bg = { from = "ColorColumn", attr = "bg", alter = -0.2 } } },
      { illuminatedWordRead = { bg = { from = "ColorColumn", attr = "bg", alter = -0.2 } } },
      { Folded = { bg = { from = "ColorColumn", attr = "bg", alter = 0.2 } } },
      { IndentBlanklineChar = { fg = { from = "Directory", attr = "fg", alter = -0.6 } } },
      { CursorLine = { bg = { from = "Normal", alter = -0.1 } } },
      { WinSeparator = { bg = "NONE" } },
      { Comment = { fg = { from = "Comment", alter = -0.15 } } },
    },
    ["tokyonight"] = {
      { Comment = { fg = { from = "Directory", alter = -0.2 } } },
      { LineNr = { fg = { from = "LineNr", alter = 0.2 } } },
      { TreesitterContextLineNumber = { inherit = "LineNr" } },
      { PmenuSel = { fg = { from = "Directory", attr = "fg", alter = 0.6 } } },
    },
    ["tokyonight-night"] = {
      { WinSeparator = { bg = "NONE" } },
      { Comment = { fg = { from = "Directory", alter = 0.1 } } },
      { CursorLine = { bg = { from = "Normal", alter = 0.4 } } },
      { CmpItemAbbr = { fg = { from = "Directory", attr = "fg", alter = 0.6 } } },
      { MyQuickFixLineLeave = { bg = { from = "Normal", alter = 0.8 } } },
      { LineNr = { fg = { from = "LineNr", alter = 0.2 } } },
      { Normal = { fg = { from = "Directory", alter = 0.8 } } },
      { CodeBlock1 = { bg = { from = "ColorColumn", alter = 0.3 } } },
    },
  }

  local hls = overrides[require("r.config").colorscheme]
  if not hls then
    return
  end
  highlight.all(hls)
end

local function user_highlights()
  general_overrides()
  set_sidebar_highlight()
  colorscheme_overrides()
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
