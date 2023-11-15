local Util = require "r.utils"

local highlight = require "r.config.highlights"

-- stylua: ignore
local general_overrides = function()
  highlight.all {
    -- { Directory = { fg = { from = "Directory", attr = "fg", alter = -0.5 } } },
    { ColorColumn = { bg = { from = "Normal" , attr = "bg" } } },
    { Normal = { fg = { from = "Normal", attr = "fg", alter = -0.1 }, bg = { from = "Normal", attr = "bg", alter= -0.15 } } },
    { FoldColumn = { bg = "NONE", fg = { from = "ColorColumn", attr = "bg", alter = 0.2 } } },
    { LineNr = { bg = { from = "ColorColumn" }, fg = { from = "FoldColumn", attr = "fg", alter = 0.2 } } },
    { CursorLineNr = { fg = { from = "ColorColumn", attr = "bg", alter = 1.5 }, bg = { from = "ColorColumn" } } },
    { CursorLine = { bg = { from = "ColorColumn", alter = 0.3 } } },
    { Type = { italic = true, bold = true } },
    { NormalFloat = { bg = { from = "Normal", attr = "bg", alter = -0.2 }, fg = { from = "Normal", attr = "fg" } } },
    { FloatBorder = { bg = "NONE", fg = { from = "ColorColumn", attr = "bg", alter = 0.4 } } },
    { Comment = { fg = { from = "Normal", attr = "fg", alter = -0.5 }, italic = true } },
    { Folded = { bg = { from = "ColorColumn", attr = "bg" }, underline = false } },
    { EndOfBuffer = { bg = "NONE" } },
    { StatusLine = { fg = { from = "ColorColumn", attr = "bg", alter = 0.5 }, bg = { from = "ColorColumn" , attr = "bg", alter = 0.1 } } },
    -- { SignColumn = { bg = { from = "ColorColumn" } } },
    -- { MarkSignNumHL = { inherit = "SpecialKey" } },
    { WinSeparator = { fg = { from = "ColorColumn", attr = "bg", alter = 0.25 }, bg = { from = "ColorColumn" } } },
    { WinBar = { bg = { from = "ColorColumn" } } },
    { WinBarNC = { bg = { from = "ColorColumn" } } },
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
    -- { GitSignsAdd = { bg = { from = "ColorColumn"} } },

    -- { diffAdded = { inherit = "DiffAdd" } },
    -- { diffChanged = { inherit = "DiffChange" } },
    -- { diffRemoved = { link = "DiffDelete" } },
    -- { diffBDiffer = { link = "WarningMsg" } },
    -- { diffCommon = { link = "WarningMsg" } },
    -- { diffDiffer = { link = "WarningMsg" } },
    -- { diffFile = { link = "Directory" } },
    -- { diffIdentical = { link = "WarningMsg" } },
    -- { diffIndexLine = { link = "Number" } },
    -- { diffIsA = { link = "WarningMsg" } },
    -- { diffNoEOL = { link = "WarningMsg" } },
    -- { diffOnly = { link = "WarningMsg" } },

    -- { ["@text.diff.add"] = { link = "DiffAdd" } },
    -- { ["@text.diff.delete"] = { link = "DiffDelete" } },

    { GitSignsAdd = { bg = { from = "ColorColumn" } } },
    { GitSignsChange = { bg = { from = "ColorColumn" } } },
    { GitSignsDelete = { bg = { from = "ColorColumn" } } },

    -----------------------------------------------------------------------
    -- LSP
    -----------------------------------------------------------------------
    { LspCodeLens = { inherit = "Comment", bold = true, italic = false } },
    { LspCodeLensSeparator = { bold = false, italic = false } },
    { LspReferenceText = { bg = "NONE", underline = true, sp = { from = "Comment", attr = "fg" } } },
    { illuminatedWordWrite = { bg = { from = "illuminatedWordWrite", attr = "bg", alter = 0.1 } } },
    { illuminatedWordRead = { bg = { from = "illuminatedWordRead", attr = "bg", alter = 0.1 } } },

    { LspSignatureActiveParameter = { link = "Visual" } },
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
    { DiagnosticSignError = { bg = { from = "ColorColumn" } } },
    { DiagnosticSignWarn = { bg = { from = "ColorColumn" } } },
    { DiagnosticSignInfo = { bg = { from = "ColorColumn" } } },
    { DiagnosticSignHint = { bg = { from = "ColorColumn" } } },

    -- Floating windows
    { DiagnosticFloatingWarn = { link = "DiagnosticWarn" } },
    { DiagnosticFloatingInfo = { link = "DiagnosticInfo" } },
    { DiagnosticFloatingHint = { link = "DiagnosticHint" } },
    { DiagnosticFloatingError = { link = "DiagnosticError" } },
    { DiagnosticFloatTitle = { inherit = "FloatTitle", bold = true } },
    { DiagnosticFloatTitleIcon = { inherit = "FloatTitle", fg = { from = "@character" } } },

    -----------------------------------------------------------------------
    -- CREATED HIGHLIGHTS
    -----------------------------------------------------------------------
    { MyStatusline = { fg = { from = "Normal", alter = 0.5 } } },
    { Mystatusline_fg = { fg = { from = "LineNr", alter = 0.1 } } },
    { Mystatusline_bg = { bg = { from = "Normal", alter = -0.1 } } },
    { bufferline_unselected = { bg = { from = "Normal", attr = "bg", alter = 0.2 } } },
    { Mygreen_fg = { fg = { from = "GitSignsAdd", attr = "fg", alter = 0.1 } } },
    { Mymisc_fg = { fg = { from = "Boolean", atrr = "fg", alter = 0.1 }, bg = { from = "Normal", alter = -0.1 } } },
    { MyQuickFixLineLeave = { bg = { from = "CursorLine", alter = 0.2 } } },
    { MyQuickFixLineEnter = { bg = { from = "Boolean", attr = "fg", alter = -0.4 } } },
    { MyQuickFixLine = { bg = { from = "MyQuickFixLineEnter", attr = "bg", alter = -0.4 } } },
    { MyCursorLine = { bg = { from = "ColorColumn", alter = 0.3 } } },
    { CodeBlock1 = { bg = { from = "Normal", alter = 0.5 } } },
    { CodeBlock2 = { bg = "cyan" } },
    { CodeLine1 = { fg = { from = "Error", attr = "fg" } } },
    { CodeComment1 = { fg = { from = "Comment", attr = "fg", alter = -0.3 } } },

    -----------------------------------------------------------------------
    -- PLUGINS
    -----------------------------------------------------------------------

    -- CMP ================================================================
    { CmpItemAbbr = { fg = { from = "ColorColumn", attr = "bg", alter = 1.55 }, bg = "NONE" } },
    { CmpItemAbbrMatch = { fg = { from = "Error", alter = 0.2 }, bg = "NONE", bold = false } },
    { CmpItemAbbrMatchFuzzy = { fg = { from = "Error", alter = -0.5 } } },

    { PmenuSel = { fg = { from = "CmpItemAbbr" , attr = "fg", alter = 4 }, bg = { from = "ColorColumn" , attr = "bg" , alter = 0.5 } } },
    { Pmenu = { bg = { from = "Normal", attr = "bg", alter = 0.3 }, fg = { from = "CmpItemAbbr" } } },
    { PmenuThumb = { bg = { from = "Normal", attr = "bg", alter = 0.3 } } },

    -- TELESCOPE ==========================================================
    { TelescopeNormal = { fg = { from = "CmpItemAbbr", attr = "fg" }, bg = { from = "Normal", attr = "bg", alter = -0.1 } } },
    { TelescopeBorder = { bg = { from = "Normal", attr = "bg", alter = -0.1  } } },

    -- Prompt
    { TelescopePromptTitle = { bg = { from = "Normal", attr = "bg" }, fg = { from = "WarningMsg", alter = 0.5, bold = true }, bold = true } },
    { TelescopePromptBorder = { bg = { from = "Normal", attr = "bg", alter = -0.15 }, fg = { from = "ColorColumn", attr = "bg" } } },
    { TelescopePromptPrefix = { bg = { from = "Normal", attr = "bg" } } },
    { TelescopePromptCounter = { bg = { from = "Normal", attr = "bg" } } },

    -- Preview
    { TelescopePreviewTitle = { bg = { from = "Normal", attr = "bg" }, fg = { from = "ColorColumn", alter = 0.14, bold = true }, bold = true } },
    { TelescopePreviewBorder = { bg = { from = "Normal", attr = "bg", alter = -0.15 }, fg = { from = "ColorColumn", attr = "bg" } } },
    { TelescopeMatching = { inherit = "CmpItemAbbrMatchFuzzy" } },
    { TelescopeSelection = { inherit = "PmenuSel" } },
    { TelescopeTitle = { fg =  { from = "Boolean", attr = "fg" } } },

    -- Results
    { TelescopeResultsTitle = { fg = { from = "FloatBorder" },bg = "NONE" } },
    { TelescopeResultsBorder = { bg = { from = "Normal", attr = "bg", alter = -0.15 }, fg = { from = "ColorColumn", attr = "bg" } } },

    -- FZFLUA =============================================================
    { FzfLuaNormal = { inherit = "Normal" } },
    -- { FzfLuaBorder = { inherit = "WinSeparator" } },
    { FzfLuaBorder = { fg = { from = "FloatBorder" }, bg = { from = "Normal", attr = "bg" } } },
    { FzfLuaTitle = { fg = { from = "Boolean", attr = "fg", alter = -0.3 } } },
    { FzfLuaCursorLine = { bg = { from = "ErrorMsg", alter = -0.8, attr = "fg" } } },

    -- WHICH-KEY ==========================================================
    { WhichKeyBorder = { fg = { from = "FzfLuaBorder", attr = "fg", alter = 0.1 } } },

    -- NOICE ==============================================================
    { NoicePopupBorder = { bg = "NONE", fg = { from = "ColorColumn", attr = "bg", alter = 0.25 } } },
    { NoiceCmdlinePopup = { bg = { from = "Pmenu" } } },
    { NoiceCmdlinePopupBorder = { fg = { from = "Pmenu", attr = "fg", alter = -0.7 } } },

    -- ORGMODE ============================================================
    { OrgDONE = { fg = "#00FF00" } },

    -- HLSEARCH ===========================================================
    { HlSearchLensNear = { bg = { from = "IncSearch", attr = "bg" }, fg = { from = "IncSearch", attr = "bg", alter = -0.3 }, bold = true } },

    -- BUFFERLINE =========================================================
    { BufferLineIndicatorSelected = { bg = { from = "ColorColumn" } } },
  }
end

local function set_sidebar_highlight()
  highlight.all {
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
    -- {"kanagawa", "catppuccin"} -- remove this
    -- ["doom-one"] = { },
    -- ["gruvbox-material"] = { },
    -- ["solarized"] = { }
    -- ["miasma"] = { },
    -- ["nano-theme"] = { },
    -- ["darcubox"] = { },
    -- ["onedark"] = { },
    -- ["everforest"] = { },
    -- ["night-owl"] = { },
    -- ["tokyonight"] = { }
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
