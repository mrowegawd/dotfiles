local UIPallette = require("r.utils").uisec

local Highlight = require "r.settings.highlights"

local dark_orange = Highlight.tint(UIPallette.palette.dark_orange, 0.5)
local dark_green = Highlight.tint(UIPallette.palette.dark_green, 0.5)
local dark_red = Highlight.tint(UIPallette.palette.dark_red, 0.5)

-- stylua: ignore
local general_overrides = function()
  Highlight.all {
    { FoldColumn = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 0.4 } } },
    { ColorColumn = { bg = { from = "Normal" , attr = "bg", alter = -0.1 } } },
    { LineNr = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 0.5 } } },
    { CursorLineNr = { fg = { from = "Keyword", attr = "fg", alter = -0.2 }, bg = "NONE", bold = true } },
    { CursorLine = { bg = { from = "Normal", attr = "bg", alter = 0.1 } } },
    { Type = { italic = true, bold = true } },
    { NormalFloat = { bg = { from = "Normal", attr = "bg", alter = -0.1 }, fg = { from = "Normal", attr = "fg" } } },
    { Comment = { fg = { from = "Normal", attr = "fg", alter = -0.5 }, italic = true } },
    { Folded = { bg = { from = "Normal", attr = "bg", alter = 0.1 }, fg = { from = "Normal", attr = "bg", alter = 0.8 } } },
    { EndOfBuffer = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 0.2 } } },

    { StatusLine = { fg = { from = "Normal", attr = "bg", alter = 2 }, bg = { from = "StatusLine" , attr = "bg" } } },
    { StatusLineNC = { bg = { from = "StatusLineNC", attr = "bg", alter = -0.3 } } },

    { SignColumn = { bg = "NONE" } },
    { NonText = { fg = {from = "Normal", attr = "fg", alter = -0.4 } } },

    { WinSeparator = { fg = { from = "Keyword", attr = "fg", alter = -0.5 }, bg = "NONE" } },
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

    { GitSignsAdd = { bg = "NONE", fg =  dark_green } },
    { GitSignsChange = { bg = "NONE", fg = dark_orange } },
    { GitSignsDelete = { bg = "NONE", fg = dark_red } },

    { NeogitDiffAdd =  { link = "diffAdd"} } ,
    { NeogitDiffAddHighlight = { link = "diffAdd" } },
    { NeogitDiffDelete =  { link = "diffDelete" } } ,
    { NeogitDiffDeleteHighlight =  { link = "diffDelete" } } ,
    { DiffText =  { link = "diffText" } } ,
    -----------------------------------------------------------------------
    -- LSP
    -----------------------------------------------------------------------
    { LspCodeLens = { bg  = { from = "Normal", attr = "bg", alter = -0.1 }, fg = { from = "Comment", attr = "fg", alter = -0.5 },  italic = true } },
    -- { LspCodeLensSeparator = { bold = false, italic = false } },

    { illuminatedWordWrite = { bg = { from = "illuminatedWordWrite", attr = "bg", alter = -0.05 } } },
    { illuminatedWordRead = { bg = { from = "illuminatedWordRead", attr = "bg", alter = -0.05 } } },
    { illuminatedWordText = { bg = { from = "illuminatedWordText", attr = "bg", alter = -0.05 } } },

    -- { LspInlayhint = { bg = { from = "Normal", attr = "bg", alter = -0.4 }, fg = { from = "Directory", attr = "fg", alter = -0.3 } } },

    { TreesitterContextSeparator = { fg = { from = "WinSeparator", attr = "fg", alter = -0.1 } } },
    { TreesitterContext = { bg  = { from = "ColorColumn" } } } ,
    { TreesitterContextSeparator = {
      fg = { from = "WinSeparator", attr = "fg", alter = 0.05 },
      bg = { from = "ColorColumn" , attr = "bg" }
    } },
    -----------------------------------------------------------------------
    -- DEBUG
    -----------------------------------------------------------------------
    { debugPC = { bg = { from = "Boolean", attr = "fg", alter = -0.6 }, fg = "NONE", bold = true } },
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
    { DiagnosticFloatingWarn = { fg = { from  = "DiagnosticWarn" , attr = "fg" }, bg = "NONE", bold = true } },
    { DiagnosticFloatingInfo = { fg = { from  = "DiagnosticInfo" , attr = "fg" }, bg = "NONE", bold = true } },
    { DiagnosticFloatingHint = { fg = { from  = "DiagnosticHint" , attr = "fg" }, bg = "NONE", bold = true } },
    { DiagnosticFloatingError = { fg = { from  = "DiagnosticError" , attr = "fg" }, bg = "NONE", bold = true } },
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
        -- undercurl = false,
      },
    },
    {
      DiagnosticWarn = {
        fg = { from = "DiagnosticSignWarn", attr = "fg" },
        bg = { from = "DiagnosticSignWarn", attr = "fg", alter = -0.7 },
        italic = true,
        -- undercurl = false,
      },
    },
    {
      DiagnosticHint = {
        fg = { from = "DiagnosticSignHint", attr = "fg" },
        bg = { from = "DiagnosticSignHint", attr = "fg", alter = -0.7 },
        italic = true,
        -- undercurl = false,
      },
    },
    {
      DiagnosticInfo = {
        fg = { from = "DiagnosticSignInfo", attr = "fg" },
        bg = { from = "DiagnosticSignInfo", attr = "fg", alter = -0.7 },
        italic = true,
        -- undercurl = false,
      },
    },
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
    { MyStatusline = { fg = { from = "Normal", alter = 0.5 } } },
    { Mystatusline_fg = { fg = { from = "LineNr", alter = 0.1 } } },
    { Mystatusline_bg = { bg = { from = "Normal", alter = -0.1 } } },

    { bufferline_unselected = { bg = { from = "Normal", attr = "bg", alter = -0.2 } } },
    { bufferline_selected_bg = { bg = { from = "Normal", attr = "bg" } } },
    { bufferline_fill_bg = { bg = { from = "Normal", attr = "bg", alter = -0.2 } } },
    { bufferline_fill_fg = { bg = { from = "Normal", attr = "fg", alter = -0.1 } } },

    -- { MyStatusLine_red_fg = { fg = { from = "ErrorMsg", attr = "fg", alter = 0.1 } } },
    -- { MyStatusLine_notif_fg = { fg = { from = "Boolean", atrr = "fg", alter = 0.1 } } },
    -- { MyStatusLine_directory_fg = { fg = { from = "Directory", atrr = "fg", alter = 0.1 } } },
    { MyQuickFixLineEnter = { bg = { from = "Normal", attr = "bg", alter = 0.3 } } },
    { MyQuickFixLine = { bg = { from = "ErrorMsg", attr = "fg", alter = -0.7 }, fg = { from = "Normal", attr = "fg" }, bold = true } },
    { LeaveCursorLine = { bg = { from = "Normal", alter = 0.3 } } },
    { MyCursorLine = { bg = { from = "Normal", alter = 0.3 } } },
    { MySeparator = { fg = { from = "LineNr", attr = "fg", alter = -0.1 } } },
    { MySeparator_fg_inactive = { fg = { from = "LineNr", attr = "fg" } } },
    { MyMark = { fg = { from = "DiagnosticSignWarn", attr = "fg", alter = 0.5 }, bold = true, italic = true } },
    {
      MyCodeUsage = {
        fg = { from = "Normal", attr = "bg", alter = 1 },
        bg = { from = "Normal", attr = "bg", alter = -0.15 },
        italic = true,
      },
    },
    { MyParentHint = { bg = { from = "CursorLine", attr = "bg" }, fg = { from = "MyCodeUsage", attr = "fg" , alter = -0.1 } } },
    { CodeBlock1 = { bg = { from = "Normal", alter = -0.15 } } },
    { CodeBlock2 = { bg = "cyan" } },
    { CodeLine1 = { fg = { from = "Error", attr = "fg" } } },

    -----------------------------------------------------------------------
    -- PLUGINS
    -----------------------------------------------------------------------

    -- CMP ================================================================
    { CmpItemAbbr = { fg = { from = "Normal", attr = "bg", alter = 3.5 }, bg = "NONE" } },
    { CmpItemAbbrMatchFuzzy = { fg = dark_red } },
    { CmpItemAbbrMatch = { fg = { from = "GitSignsDelete", attr = "fg", alter = 0.5 } } },

    { CmpItemKindFunction = { fg = { from = "Function", attr = "fg" } } },
    { CmpItemKindModule = { fg = { from = "Include", attr = "fg" } } },
    { CmpItemKindConstant = { fg = { from = "Constant", attr = "fg" } } },
    { CmpItemKindStruct = { fg = { from = "Structure", attr = "fg" } } },
    { CmpItemKindKeyword = { fg = { from = "String", attr = "fg" } } },
    { CmpItemKindText = { fg = { from = "String", attr = "fg" } } },
    { CmpItemKindField = { fg = { from = "Identifier", attr = "fg" } } },

    { PmenuSel = { bg = { from = "Keyword", attr = "fg", alter = -0.6 }, fg = { from = "CmpItemAbbr", attr = "fg", alter = 5 }, bold = true } },
    { Pmenu = { bg = { from = "NormalFloat", attr = "bg", alter = 0.8 }, fg = { from = "CmpItemAbbr" } } },
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
    { FzfLuaBorder = { fg = { from = "WinSeparator" }, bg = { from = "NormalFloat", attr = "bg" } } },
    { FzfLuaTitle = { fg = { from = "Boolean", attr = "fg", alter = 0.2 }, bg = { from = "FzfLuaNormal", attr = "bg" } } },
    { FzfLuaTitleIcon = { fg = { from = "Boolean", attr = "fg", alter = 0.2 }, bg = { from = "FzfLuaNormal", attr = "bg" } } },
    { FzfLuaCursorLine = { bg = { from = "ErrorMsg", alter = -0.8, attr = "fg" } } },

    -- WHICH-KEY ==========================================================
    { WhichKeyBorder = { fg = { from = "FzfLuaBorder", attr = "fg", alter = 0.1 }, bg = { from = "NormalFloat", attr = "bg" } } },

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

    {['@org.timestamp.active'] = { inherit = 'PreProc'}},
    {['@org.timestamp.inactive'] = { inherit = 'Comment'}},
    {['@org.bullet'] = { inherit = 'Identifier'}},
    {['@org.checkbox'] = { inherit = 'PreProc'}},
    {['@org.checkbox.halfchecked'] = { inherit = 'PreProc'}},
    {['@org.checkbox.checked'] = { inherit = 'PreProc'}},
    {['@org.properties'] = { inherit = 'Constant'}},
    {['@org.drawer'] = { inherit = 'Constant'}},
    {['@org.tag'] = { inherit = 'Function'}},
    {['@org.plan'] = { inherit = 'Constant'}},
    {['@org.comment'] = { inherit = 'Comment'}},
    {['@org.directive'] = { inherit = 'Comment'}},
    {['@org.block'] = { inherit = 'Comment'}},
    {['@org.latex'] = { inherit = 'Statement'}},
    {['@org.hyperlinks'] = { inherit = 'Underlined'}},
    {['@org.code'] = { inherit = 'String'}},
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
    { HlSearchLensNear = { bg = { from = "IncSearch", attr = "bg" }, fg = { from = "IncSearch", attr = "bg", alter = -0.3 }, bold = true } },

    -- BUFFERLINE =========================================================
    { BufferLineIndicatorSelected = { bg = { from = "ColorColumn" } } },
    { OctoEditable = { bg = { from = "ColorColumn" } } },
    { OctoBubble = { link = "Normal" } },

    -- BQF ================================================================
    { BqfSign = { bg = { from = "ColorColumn", attr = "bg" }, { fg = { from = "Boolean" } } } },

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

local function colorscheme_overrides()
  local overrides = {
    ["gruvbox-material"] = {
      { CmpItemAbbr = { fg = { from = "Normal", attr = "bg", alter = 2 }, bg = "NONE" } },
      { Pmenu = { bg = { from = "NormalFloat", attr = "bg", alter = 0.4 }, fg = { from = "CmpItemAbbr" } } },

      { DiagnosticFloatingWarn = { fg = { from = "DiagnosticWarn", attr = "fg" }, bg = "NONE", bold = true } },
      { DiagnosticFloatingInfo = { fg = { from = "DiagnosticInfo", attr = "fg" }, bg = "NONE", bold = true } },
      { DiagnosticFloatingHint = { fg = { from = "DiagnosticHint", attr = "fg" }, bg = "NONE", bold = true } },
      { DiagnosticFloatingError = { fg = { from = "DiagnosticError", attr = "fg" }, bg = "NONE", bold = true } },
      { DiagnosticFloatTitle = { bg = { from = "NormalFloat", attr = "bg" }, bold = true } },
      { DiagnosticFloatTitleIcon = { bg = { from = "NormalFloat", attr = "bg" }, fg = { from = "@character" } } },

      { MySeparator_fg_inactive = { fg = { from = "LineNr", attr = "fg", alter = -0.15 } } },
      {
        LspCodeLens = {
          bg = { from = "Normal", attr = "bg", alter = -0.1 },
          fg = { from = "Comment", attr = "fg", alter = -0.4 },
          italic = true,
        },
      },
      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "fg", alter = 0.2 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.3 },
        },
      },
      {
        StatusLineNC = {
          fg = { from = "StatusLineNC", attr = "fg", alter = -0.1 },
          bg = { from = "StatusLineNC", attr = "bg", alter = 0.5 },
        },
      },
      { LeaveCursorLine = { bg = { from = "Normal", attr = "bg", alter = 0.2 } } },
      { MyQuickFixLineEnter = { bg = { from = "Normal", attr = "bg", alter = 1 } } },
      {
        MyQuickFixLine = {
          bg = { from = "Error", attr = "fg", alter = -0.5 },
          fg = { from = "Normal", attr = "fg" },
          bold = true,
        },
      },
    },
    ["kanagawa"] = {
      { MySeparator_fg_inactive = { fg = { from = "LineNr", attr = "fg", alter = -0.2 } } },
      { MyQuickFixLineEnter = { bg = { from = "Normal", attr = "bg", alter = 1 } } },
      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "fg", alter = 0.4 },
          bg = { from = "StatusLine", attr = "bg", alter = 1.1 },
        },
      },
      {
        StatusLineNC = {
          fg = { from = "StatusLineNC", attr = "fg", alter = 0.1 },
          bg = { from = "StatusLineNC", attr = "bg", alter = 1.4 },
        },
      },
    },
    ["flexoki"] = {
      { CmpItemAbbr = { fg = { from = "Normal", attr = "bg", alter = 6 }, bg = "NONE" } },
      { Pmenu = { bg = { from = "NormalFloat", attr = "bg", alter = 2 }, fg = { from = "CmpItemAbbr" } } },

      -- LSP
      { CmpItemKindVariable = { inherit = "Constant" } },
      { CmpItemKindProperty = { inherit = "@property" } },
      { CmpItemKindField = { inherit = "Function" } },

      { MyQuickFixLineEnter = { bg = { from = "Normal", attr = "bg", alter = 2 } } },

      {
        MyCodeUsage = {
          fg = { from = "Normal", attr = "bg", alter = 3 },
          bg = { from = "Normal", attr = "bg", alter = 1 },
          italic = true,
        },
      },
      {
        FoldColumn = {
          bg = "NONE",
          fg = { from = "Normal", attr = "bg", alter = 1 },
        },
      },
      {
        Folded = {
          bg = { from = "Normal", attr = "bg", alter = 0.7 },
          fg = { from = "Normal", attr = "bg", alter = 0.8 },
        },
      },
      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = 0.3 } } },
      { MySeparator_fg_inactive = { fg = { from = "LineNr", attr = "fg", alter = 0.1 } } },
      { CursorLine = { bg = { from = "Normal", alter = 0.4 } } },
      {
        MyParentHint = {
          bg = { from = "CursorLine", attr = "bg" },
          fg = { from = "LineNr", attr = "fg", alter = 1 },
        },
      },
      { MySeparator = { fg = { from = "LineNr", attr = "fg", alter = -0.1 } } },
      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "fg", alter = 2.5 },
          bg = { from = "StatusLine", attr = "bg", alter = -0.3 },
        },
      },
      {
        StatusLineNC = {
          fg = { from = "StatusLineNC", attr = "fg", alter = -0.3 },
          bg = { from = "StatusLineNC", attr = "bg", alter = 0.1 },
        },
      },
    },
    ["ayu"] = {
      -- CMP
      { CmpItemAbbr = { fg = { from = "Normal", attr = "bg", alter = 7 }, bg = "NONE" } },
      { Pmenu = { bg = { from = "NormalFloat", attr = "bg", alter = 2 }, fg = { from = "CmpItemAbbr" } } },
      {
        PmenuSel = {
          bg = { from = "Statement", attr = "fg", alter = -0.5 },
          fg = { from = "CmpItemAbbr", attr = "fg", alter = 5 },
          bold = true,
          reverse = false,
        },
      },

      {
        MyCodeUsage = {
          fg = { from = "Normal", attr = "bg", alter = 3 },
          bg = { from = "Normal", attr = "bg", alter = 1 },
          italic = true,
        },
      },
      { MySeparator_fg_inactive = { fg = { from = "LineNr", attr = "fg", alter = 0.2 } } },
      {
        FoldColumn = {
          bg = "NONE",
          fg = { from = "Normal", attr = "bg", alter = 1 },
        },
      },
      {
        Folded = {
          bg = { from = "Normal", attr = "bg", alter = 0.7 },
          fg = { from = "Normal", attr = "bg", alter = 0.8 },
        },
      },
      { CursorLine = { bg = { from = "Normal", alter = 0.6 } } },
      {
        MyParentHint = {
          bg = { from = "CursorLine", attr = "bg" },
          fg = { from = "LineNr", attr = "fg", alter = 1 },
        },
      },
      { MySeparator = { fg = { from = "LineNr", attr = "fg", alter = 0.5 } } },
      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = 0.5 }, bg = { from = "Normal", attr = "bg" } } },

      { LeaveCursorLine = { bg = { from = "Normal", alter = 0.8 } } },
      { MyQuickFixLineEnter = { bg = { from = "Keyword", attr = "fg", alter = -0.7 } } },
      {
        MyQuickFixLine = {
          bg = { from = "ErrorMsg", attr = "fg", alter = -0.5 },
          fg = { from = "Normal", attr = "fg" },
          bold = true,
        },
      },
      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "fg", alter = 1.5 },
          bg = { from = "StatusLine", attr = "bg", alter = 1.1 },
        },
      },
      {
        StatusLineNC = {
          fg = { from = "StatusLineNC", attr = "fg", alter = -0.1 },
          bg = { from = "StatusLineNC", attr = "bg", alter = 1.3 },
        },
      },
    },
    ["farout"] = {
      { CmpItemAbbr = { fg = { from = "Normal", attr = "bg", alter = 9 }, bg = "NONE" } },
      { Pmenu = { bg = { from = "NormalFloat", attr = "bg", alter = 2 }, fg = { from = "CmpItemAbbr" } } },

      {
        MyCodeUsage = {
          fg = { from = "Normal", attr = "bg", alter = 3 },
          bg = { from = "Normal", attr = "bg", alter = 1.3 },
          italic = true,
        },
      },
      { MySeparator_fg_inactive = { fg = { from = "LineNr", attr = "fg", alter = 0.5 } } },
      {
        FoldColumn = {
          bg = "NONE",
          fg = { from = "Normal", attr = "bg", alter = 1.5 },
        },
      },
      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "fg", alter = 1.8 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.4 },
        },
      },
      {
        StatusLineNC = {
          fg = { from = "StatusLineNC", attr = "fg", alter = 0.1 },
          bg = { from = "StatusLineNC", attr = "bg", alter = 0.5 },
        },
      },
      { LineNr = { bg = "NONE", fg = { from = "Folded", attr = "fg", alter = 0.5 } } },
      { qfFileName = { fg = { from = "qfFileName", attr = "fg", alter = 0.3 } } },

      { illuminatedWordWrite = { bg = { from = "illuminatedWordWrite", attr = "bg", alter = -0.5 } } },
      { illuminatedWordRead = { bg = { from = "illuminatedWordRead", attr = "bg", alter = -0.5 } } },
      { illuminatedWordText = { bg = { from = "illuminatedWordText", attr = "bg", alter = -0.5 } } },

      { CursorLine = { bg = { from = "Normal", attr = "bg", alter = 0.8 } } },
      {
        MyParentHint = {
          bg = { from = "CursorLine", attr = "bg" },
          fg = { from = "MyCodeUsage", attr = "fg", alter = 0.7 },
        },
      },
      { LeaveCursorLine = { bg = { from = "Normal", alter = 1.5 } } },
      { MyQuickFixLineEnter = { bg = { from = "Normal", attr = "bg", alter = 2.5 } } },
      {
        MyQuickFixLine = {
          bg = { from = "Error", attr = "fg", alter = -0.5 },
          fg = { from = "Normal", attr = "fg" },
          bold = true,
        },
      },
    },
    ["miasma"] = {
      { CmpItemAbbr = { fg = { from = "Normal", attr = "bg", alter = 2 }, bg = "NONE" } },
      { Pmenu = { bg = { from = "NormalFloat", attr = "bg", alter = 0.4 }, fg = { from = "CmpItemAbbr" } } },

      { MySeparator_fg_inactive = { fg = { from = "LineNr", attr = "fg", alter = -0.15 } } },
      { FoldColumn = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 0.28 } } },
      {
        qfFileName = {
          fg = { from = "Directory", attr = "fg" },
          bg = "NONE",
        },
      },
      {
        LspReferenceText = {
          bg = { from = "Normal", attr = "bg" },
          fg = "NONE",
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },
      {
        LspReferenceWrite = {
          bg = { from = "Normal", attr = "bg" },
          bold = true,
          italic = true,
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },

      { MyQuickFixLineEnter = { bg = { from = "Keyword", attr = "fg", alter = -0.8 } } },

      { LspReferenceRead = { bg = { from = "Normal", attr = "bg" }, underline = false, undercurl = false } },
      { MySeparator = { fg = { from = "LineNr", attr = "fg", alter = -0.05 } } },
      { String = { fg = { from = "String", attr = "fg", alter = 0.4 } } },
      { Comment = { fg = { from = "Comment", attr = "fg", alter = -0.3 } } },
      { ["@org.agenda.scheduled"] = { fg = { from = "@tag.attribute", attr = "fg", alter = 0.2 } } },
      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "fg", alter = 0.2 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.5 },
        },
      },
      {
        StatusLineNC = {
          fg = { from = "StatusLineNC", attr = "fg", alter = -0.1 },
          bg = { from = "StatusLineNC", attr = "bg", alter = 0.8 },
        },
      },
    },
    ["solarized-osaka"] = {
      { CmpItemAbbr = { fg = { from = "Normal", attr = "bg", alter = 4.5 }, bg = "NONE" } },
      {
        PmenuSel = {
          bg = { from = "Statement", attr = "fg", alter = -0.5 },
          fg = { from = "CmpItemAbbr", attr = "fg", alter = 5 },
          bold = true,
          reverse = false,
        },
      },

      {
        MyCodeUsage = {
          fg = { from = "Normal", attr = "bg", alter = 2.5 },
          bg = { from = "Normal", attr = "bg", alter = 0.7 },
          italic = true,
        },
      },
      { MySeparator_fg_inactive = { fg = { from = "LineNr", attr = "fg", alter = 0.05 } } },
      {
        FoldColumn = {
          bg = "NONE",
          fg = { from = "Normal", attr = "bg", alter = 0.7 },
        },
      },
      { MySeparator = { fg = { from = "LineNr", attr = "fg", alter = 0.2 } } },
      { TroubleNormal = { inherit = "Normal" } },
      { ["@markup.raw.markdown_inline"] = { bg = "NONE" } },
      { markdownCode = { bg = "NONE" } },

      { LineNr = { fg = { from = "Normal", attr = "bg", alter = 1 }, bg = { from = "Normal", attr = "bg" } } },

      { CursorLine = { bg = { from = "Normal", alter = 0.2 } } },
      {
        MyParentHint = {
          bg = { from = "CursorLine", attr = "bg" },
          fg = { from = "LineNr", attr = "fg", alter = 1 },
        },
      },

      { LeaveCursorLine = { bg = { from = "Normal", attr = "bg", alter = 0.5 } } },
      { MyQuickFixLineEnter = { bg = { from = "Statement", attr = "fg", alter = -0.7 } } },
      {
        MyQuickFixLine = {
          bg = { from = "Error", attr = "fg", alter = -0.5 },
          fg = { from = "Normal", attr = "fg" },
          bold = true,
        },
      },

      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "fg", alter = 0.5 },
          bg = { from = "StatusLine", attr = "bg", alter = -0.1 },
          reverse = false,
        },
      },
      {
        StatusLineNC = {
          fg = { from = "StatusLineNC", attr = "fg", alter = -0.4 },
          bg = { from = "StatusLineNC", attr = "bg", alter = 1.1 },
          reverse = false,
        },
      },
    },
    ["selenized"] = {
      { CmpItemAbbr = { fg = { from = "Normal", attr = "bg", alter = 2 }, bg = "NONE" } },
      { Pmenu = { bg = { from = "NormalFloat", attr = "bg", alter = 0.4 }, fg = { from = "CmpItemAbbr" } } },

      { MySeparator_fg_inactive = { fg = { from = "LineNr", attr = "fg", alter = -0.2 } } },
      {
        LspCodeLens = {
          bg = { from = "Normal", attr = "bg", alter = -0.05 },
          fg = { from = "Comment", attr = "fg", alter = -0.1 },
          italic = true,
        },
      },
      { Visual = { bg = { from = "Visual", attr = "bg", alter = 0.2 } } },
      { MySeparator = { fg = { from = "LineNr", attr = "fg", alter = -0.15 } } },

      { LeaveCursorLine = { bg = { from = "Normal", attr = "bg", alter = 0.3 } } },
      { MyQuickFixLineEnter = { bg = { from = "Keyword", attr = "fg", alter = -0.7 } } },
      {
        MyQuickFixLine = {
          bg = { from = "Error", attr = "fg", alter = -0.2 },
          fg = { from = "Normal", attr = "fg" },
          bold = true,
        },
      },
      { CursorLine = { bg = { from = "Normal", alter = 0.05 } } },
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
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "fg", alter = -0.1 },
          bg = { from = "StatusLineNC", attr = "bg", alter = 0.15 },
          reverse = false,
        },
      },
    },
    ["onedark"] = {
      { CmpItemAbbr = { fg = { from = "Normal", attr = "bg", alter = 3 }, bg = "NONE" } },
      { Pmenu = { bg = { from = "NormalFloat", attr = "bg", alter = 0.5 }, fg = { from = "CmpItemAbbr" } } },

      { MySeparator_fg_inactive = { fg = { from = "LineNr", attr = "fg", alter = -0.2 } } },
      {
        FoldColumn = {
          bg = "NONE",
          fg = { from = "Normal", attr = "bg", alter = 0.25 },
        },
      },
      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "fg", alter = 0.5 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.1 },
          reverse = false,
        },
      },
      {
        StatusLineNC = {
          fg = { from = "StatusLineNC", attr = "fg", alter = 0.1 },
          bg = { from = "StatusLineNC", attr = "bg", alter = 0.3 },
          reverse = false,
        },
      },
      { MyQuickFixLineEnter = { bg = { from = "Normal", attr = "bg", alter = 0.7 } } },
      {
        MyQuickFixLine = {
          bg = { from = "ErrorMsg", attr = "fg", alter = -0.3 },
          fg = { from = "Normal", attr = "fg" },
          bold = true,
        },
      },
    },
    ["bamboo"] = {
      { MySeparator_fg_inactive = { fg = { from = "LineNr", attr = "fg", alter = -0.2 } } },
      { MySeparator = { fg = { from = "LineNr", attr = "fg", alter = -0.15 } } },
      { ["@comment"] = { fg = { from = "@comment", attr = "fg", alter = -0.5 } } },

      { MyQuickFixLineEnter = { bg = { from = "Normal", attr = "bg", alter = 0.8 } } },

      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "fg", alter = -0.1 },
          bg = { from = "StatusLine", attr = "bg" },
          reverse = false,
        },
      },
      {
        StatusLineNC = {
          fg = { from = "StatusLineNC", attr = "fg", alter = 0.1 },
          bg = { from = "StatusLineNC", attr = "bg", alter = 0.4 },
          reverse = false,
        },
      },
    },
    ["tokyonight"] = {
      { CmpItemAbbr = { fg = { from = "Normal", attr = "bg", alter = 5 }, bg = "NONE" } },
      { Pmenu = { bg = { from = "NormalFloat", attr = "bg", alter = 1 }, fg = { from = "CmpItemAbbr" } } },

      { MySeparator_fg_inactive = { fg = { from = "LineNr", attr = "fg", alter = -0.2 } } },
      { ["@markup.raw.markdown_inline"] = { bg = "NONE" } },
      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "fg", alter = 0.2 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.9 },
          reverse = false,
        },
      },
      {
        StatusLineNC = {
          fg = { from = "StatusLineNC", attr = "fg", alter = 0.5 },
          bg = { from = "StatusLineNC", attr = "bg", alter = 1.2 },
          reverse = false,
        },
      },
      { LeaveCursorLine = { bg = { from = "Normal", alter = 0.3 } } },
      { MyQuickFixLineEnter = { bg = { from = "Normal", attr = "bg", alter = 0.8 } } },
      {
        MyQuickFixLine = {
          bg = { from = "Error", attr = "fg", alter = -0.5 },
          fg = { from = "Normal", attr = "fg" },
          bold = true,
        },
      },
    },
    ["vscode_modern"] = {
      { MySeparator_fg_inactive = { fg = { from = "LineNr", attr = "fg", alter = -0.1 } } },
      { CursorLine = { bg = { from = "Normal", alter = 0.1 } } },
      {
        MyParentHint = {
          bg = { from = "CursorLine", attr = "bg" },
          fg = { from = "MyCodeUsage", attr = "fg", alter = -0.1 },
        },
      },

      { MyQuickFixLineEnter = { bg = { from = "Normal", attr = "bg", alter = 0.8 } } },

      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "fg", alter = 0.4 },
          bg = { from = "StatusLine", attr = "bg", alter = 1 },
          reverse = false,
        },
      },
      {
        StatusLineNC = {
          fg = { from = "StatusLineNC", attr = "fg", alter = -0.5 },
          bg = { from = "StatusLineNC", attr = "bg", alter = 0.2 },
          reverse = false,
        },
      },
    },
    ["rose-pine"] = {
      { CmpItemKindVariable = { inherit = "Constant" } },
      { CmpItemKindProperty = { inherit = "@property" } },
      { CmpItemKindField = { inherit = "Function" } },

      { MySeparator_fg_inactive = { fg = { from = "LineNr", attr = "fg", alter = -0.1 } } },
      { MySeparator = { fg = { from = "LineNr", attr = "fg", alter = -0.05 } } },
      { WhichKeyFloat = { inherit = "NormalFloat" } },

      { LeaveCursorLine = { bg = { from = "Normal", alter = 0.3 } } },

      { MyQuickFixLineEnter = { bg = { from = "Normal", attr = "bg", alter = 2 } } },

      -- { ["@org.agenda.scheduled"] = { fg = { from = "Boolean", attr = "fg", alter = 1 } } },
      { ["@org.agenda.scheduled"] = { fg = "green" } },
      -- { ["@org.agenda.scheduled_past"] = { bg = { from = "Normal", attr = "bg", alter = 2 } } },

      {
        MyQuickFixLine = {
          bg = { from = "Error", attr = "fg", alter = -0.5 },
          fg = { from = "Normal", attr = "fg" },
          bold = true,
        },
      },

      {
        MyCodeUsage = {
          fg = { from = "Normal", attr = "bg", alter = 2.5 },
          bg = { from = "Normal", attr = "bg", alter = 0.5 },
          italic = true,
        },
      },
      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "fg", alter = 0.3 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.3 },
        },
      },
      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "fg", alter = -0.1 },
          bg = { from = "StatusLineNC", attr = "bg", alter = 0.6 },
        },
      },
    },
    ["catppuccin-mocha"] = {
      { MySeparator_fg_inactive = { fg = { from = "LineNr", attr = "fg", alter = -0.2 } } },

      { MySeparator = { fg = { from = "LineNr", attr = "fg", alter = -0.15 } } },
      { MyQuickFixLineEnter = { bg = { from = "Normal", attr = "bg", alter = 0.8 } } },
      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "fg", alter = 0.3 },
          bg = { from = "StatusLine", attr = "bg", alter = 0.9 },
        },
      },
      {
        StatusLineNC = {
          fg = { from = "StatusLine", attr = "fg", alter = -0.1 },
          bg = { from = "StatusLineNC", attr = "bg", alter = 1.3 },
        },
      },
    },
    ["catppuccin-latte"] = {
      { MySeparator_fg_inactive = { fg = { from = "LineNr", attr = "fg", alter = -0.3 } } },

      { CursorLine = { bg = { from = "Normal", attr = "bg", alter = -0.05 } } },
      {
        MyParentHint = {
          bg = { from = "CursorLine", attr = "bg" },
          fg = { from = "MyCodeUsage", attr = "fg", alter = -0.2 },
        },
      },
      { MyQuickFixLineEnter = { bg = { from = "Normal", attr = "bg", alter = -0.1 } } },

      {
        Folded = {
          bg = { from = "Normal", attr = "bg", alter = -0.1 },
          fg = { from = "Normal", attr = "bg", alter = 0.8 },
        },
      },
      {
        MyQuickFixLine = {
          bg = { from = "ErrorMsg", attr = "fg", alter = 0.1 },
          fg = { from = "Normal", attr = "bg" },
          bold = true,
        },
      },
      { LeaveCursorLine = { bg = { from = "Normal", attr = "bg", alter = -0.1 } } },
      { MyCursorLine = { bg = { from = "Normal", alter = 0.3 } } },

      {
        FoldColumn = {
          bg = "NONE",
          fg = { from = "Normal", attr = "bg", alter = -0.1 },
        },
      },
      { MySeparator = { fg = { from = "LineNr", attr = "fg", alter = -0.2 } } },
      { WinSeparator = { fg = { from = "@constructor", attr = "fg", alter = 0.2 }, bg = "NONE" } },

      { Comment = { fg = { from = "Normal", attr = "bg", alter = -0.25 } } },

      { illuminatedWordWrite = { bg = { from = "illuminatedWordWrite", attr = "bg", alter = 0.1 } } },
      { illuminatedWordRead = { bg = { from = "illuminatedWordRead", attr = "bg", alter = 0.1 } } },
      { illuminatedWordText = { bg = { from = "illuminatedWordText", attr = "bg", alter = 0.1 } } },

      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "fg", alter = -0.1 },
          bg = { from = "StatusLine", attr = "bg", alter = -0.4 },
        },
      },
      {
        StatusLineNC = {
          fg = { from = "StatusLineNC", attr = "fg", alter = 0.5 },
          bg = { from = "StatusLineNC", attr = "bg", alter = 0.1 },
        },
      },
      {
        MyStatusLine_directory_fg = {
          fg = { from = "Directory", atrr = "fg", alter = 0.1 },
          -- bg = { from = "StatusLine", attr = "bg" },
        },
      },
      {
        MyStatusLine_notif_fg = {
          fg = { from = "Boolean", atrr = "fg", alter = 0.1 },
          bg = { from = "StatusLine", attr = "bg" },
        },
      },
      {
        MyStatusLine_red_fg = {
          fg = { from = "ErrorMsg", attr = "fg", alter = 0.1 },
          bg = { from = "StatusLine", attr = "bg" },
        },
      },

      { bufferline_fill_bg = { bg = { from = "Normal", attr = "bg", alter = -0.45 } } },
      { bufferline_selected_bg = { bg = { from = "Normal", attr = "bg" } } },

      -- CMP
      { CmpItemAbbr = { fg = { from = "Normal", attr = "fg", alter = 0.3 }, bg = "NONE" } },
      { CmpItemAbbrMatchFuzzy = { fg = dark_red } },
      { CmpItemAbbrMatch = { fg = { from = "ErrorMsg", attr = "fg", alter = 0.5 } } },

      {
        PmenuSel = {
          bg = { from = "Statement", attr = "fg", alter = -0.3 },
          fg = { from = "Normal", attr = "fg", alter = 6 },
          bold = true,
        },
      },
      {
        Pmenu = {
          fg = { from = "Normal", attr = "fg" },
          bg = { from = "Normal", attr = "bg", alter = -0.2 },
        },
      },
      { PmenuThumb = { bg = { from = "Normal", attr = "bg", alter = -0.3 } } },

      -- { PmenuSel = { bg = { from = "Boolean", attr = "fg", alter = 1.2 }, fg = "NONE" } },

      -- TELESCOPE ==========================================================
      { TelescopeNormal = { link = "NormalFloat" } },
      { TelescopeBorder = { link = "NormalFloat" } },

      -- Prompt
      { TelescopePromptNormal = { link = "NormalFloat" } },
      {
        TelescopePromptTitle = {
          bg = { from = "NormalFloat", attr = "bg" },
          fg = { from = "WarningMsg", alter = 0.5, bold = true },
          bold = true,
        },
      },
      { TelescopePromptBorder = { bg = "NONE", fg = { from = "FloatBorder" } } },
      { TelescopePromptPrefix = { bg = { from = "NormalFloat", attr = "bg" } } },
      { TelescopePromptCounter = { bg = { from = "NormalFloat", attr = "bg" } } },

      -- Preview
      { TelescopePreviewNormal = { link = "NormalFloat" } },
      {
        TelescopePreviewTitle = {
          bg = { from = "NormalFloat", attr = "bg" },
          fg = { from = "ColorColumn", alter = 0.14, bold = true },
          bold = true,
        },
      },
      { TelescopePreviewBorder = { bg = { from = "NormalFloat", attr = "bg" }, fg = { from = "FloatBorder" } } },
      { TelescopeMatching = { inherit = "CmpItemAbbrMatchFuzzy" } },
      { TelescopeSelection = { inherit = "PmenuSel" } },
      { TelescopeTitle = { fg = { from = "Boolean", attr = "fg" } } },

      -- Results
      { TelescopeResultsNormal = { link = "NormalFloat" } },
      { TelescopeResultsTitle = { fg = { from = "FloatBorder" }, bg = "NONE" } },
      { TelescopeResultsBorder = { bg = "NONE", fg = { from = "FloatBorder" } } },

      -- FZFLUA =============================================================
      { FzfLuaNormal = { inherit = "NormalFloat" } },
      { FzfLuaBorder = { fg = { from = "FloatBorder" }, bg = { from = "NormalFloat", attr = "bg" } } },
      {
        FzfLuaTitle = {
          fg = { from = "Boolean", attr = "fg", alter = 0.2 },
          bg = { from = "FzfLuaNormal", attr = "bg" },
        },
      },
      {
        FzfLuaTitleIcon = {
          fg = { from = "Boolean", attr = "fg", alter = 0.2 },
          bg = { from = "FzfLuaNormal", attr = "bg" },
        },
      },
      { FzfLuaCursorLine = { bg = { from = "ErrorMsg", alter = -0.8, attr = "fg" } } },

      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = -0.2 }, bg = { from = "Normal", attr = "bg" } } },
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
