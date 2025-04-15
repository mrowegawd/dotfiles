local UIPallette = require("r.utils").uisec

local Highlight = require "r.settings.highlights"

local dark_green = Highlight.tint(UIPallette.palette.green, 0.3)
local dark_yellow = Highlight.tint(UIPallette.palette.bright_yellow, 0.3)
local dark_red = Highlight.tint(UIPallette.palette.dark_red, 0.3)

local pmenu_fg_alter, pmenu_bg_alter, pmenusel_bg_alter, quickfixline_alter, fzflua_bg_cursorline_alter, cursorline_alter, normalfloat_bg_alter, normalfloat_fg_alter, cmpdocnormal_fg_alter, winseparator_alter, fzfluasel_bg_alter, cursor_fg, search_fg_alter, search_bg_alter, cursearch_bg_alter, cursearch_fg_alter

local base_cl = {
  cmpdocnormal_fg_alter = 0.3,
  cursor_fg = "#c7063c",
  cursorline_alter = 0.04,
  fzflua_bg_cursorline_alter = 0.05,

  normalfloat_bg_alter = -0.12,
  normalfloat_fg_alter = -0.01,

  pmenu_bg_alter = 0.1,
  pmenu_fg_alter = -0.1,

  pmenusel_bg_alter = 0.15,

  fzfluasel_bg_alter = 0.05,

  quickfixline_alter = 0.6,
  winseparator_alter = 0.35,

  search_fg_alter = 0.1,
  search_bg_alter = 0.8,

  cursearch_fg_alter = 0.1,
  cursearch_bg_alter = 0.8,
}

local function reset_base_alter(themes, alter_base)
  for _, theme in pairs(themes) do
    if theme == RUtils.config.colorscheme then
      for key_alter, val_alter in pairs(alter_base) do
        for key, _ in pairs(base_cl) do
          if key == key_alter then
            base_cl[key] = val_alter
          end
        end
      end
    end
  end

  for i, x in pairs(base_cl) do
    if i == "cmpdocnormal_fg" then
      cmpdocnormal_fg_alter = x
    end
    if i == "pmenu_fg_alter" then
      pmenu_fg_alter = x
    end
    if i == "pmenu_bg_alter" then
      pmenu_bg_alter = x
    end
    if i == "pmenusel_bg_alter" then
      pmenusel_bg_alter = x
    end
    if i == "fzflua_bg_cursorline_alter" then
      fzflua_bg_cursorline_alter = x
    end
    if i == "cursor_fg" then
      cursor_fg = x
    end
    if i == "quickfixline_alter" then
      quickfixline_alter = x
    end
    if i == "cursorline_alter" then
      cursorline_alter = x
    end
    if i == "normalfloat_fg_alter" then
      normalfloat_fg_alter = x
    end
    if i == "normalfloat_bg_alter" then
      normalfloat_bg_alter = x
    end
    if i == "fzfluasel_bg_alter" then
      fzfluasel_bg_alter = x
    end
    if i == "winseparator_alter" then
      winseparator_alter = x
    end

    if i == "search_fg_alter" then
      search_fg_alter = x
    end
    if i == "search_bg_alter" then
      search_bg_alter = x
    end

    if i == "cursearch_fg_alter" then
      cursearch_fg_alter = x
    end
    if i == "cursearch_bg_alter" then
      cursearch_bg_alter = x
    end
  end
end

reset_base_alter({ "ashen" }, {
  cursor_fg = "#b4b4b4",
  cursorline_alter = 0.05,
  fzflua_bg_cursorline_alter = 0.1,
  fzfluasel_bg_alter = -0.08,
  pmenu_bg_alter = 1,
  pmenusel_bg_alter = 2,
  quickfixline_alter = 0.2,
  winseparator_alter = 0.9,
})
reset_base_alter({ "base46-aylin" }, {
  cmpdocnormal_fg_alter = 0.1,
  cursor_fg = "#b3276f",
  cursorline_alter = 0.06,
  fzfluasel_bg_alter = -0.2,
  normalfloat_bg_alter = -0.1,
  pmenu_bg_alter = 0.45,
  pmenusel_bg_alter = 0.85,
  quickfixline_alter = -0.05,
  winseparator_alter = 0.6,
})
reset_base_alter({ "base46-chocolate" }, {
  cursor_fg = "#c8bAA4",
  cursorline_alter = 0.1,
  fzfluasel_bg_alter = -0.23,
  pmenu_bg_alter = 0.4,
  pmenusel_bg_alter = 0.9,
  quickfixline_alter = 0.2,
  winseparator_alter = 0.6,
})
reset_base_alter({ "base46-default-dark" }, {
  cursor_fg = "#9e0e06",
  cursorline_alter = 0.07,
  fzfluasel_bg_alter = -0.2,
  pmenu_bg_alter = 0.6,
  pmenusel_bg_alter = 1.3,
  quickfixline_alter = 0.3,
  winseparator_alter = 0.6,
})
reset_base_alter({ "base46-doomchad" }, {
  cursor_fg = "#81A1C1",
  cursorline_alter = 0.08,
  fzfluasel_bg_alter = -0.3,
  pmenu_bg_alter = 0.4,
  pmenusel_bg_alter = 0.8,
  quickfixline_alter = 0.2,
  winseparator_alter = 0.6,
})
reset_base_alter({ "base46-jabuti" }, {
  cursor_fg = "#c0cbe3",
  cursorline_alter = 0.07,
  fzfluasel_bg_alter = -0.2,
  pmenu_bg_alter = 0.3,
  pmenusel_bg_alter = 0.7,
  quickfixline_alter = 0.15,
  winseparator_alter = 0.65,
})
reset_base_alter({ "base46-jellybeans" }, {
  cursor_fg = "#ffa560",
  cursorline_alter = 0.08,
  fzfluasel_bg_alter = -0.2,
  pmenu_bg_alter = 0.65,
  pmenusel_bg_alter = 1.2,
  quickfixline_alter = 0.25,
  winseparator_alter = 0.7,
})
reset_base_alter({ "base46-kanagawa" }, {
  cmpdocnormal_fg_alter = 0.1,
  cursor_fg = "#b3276f",
  cursorline_alter = 0.08,
  fzflua_bg_cursorline_alter = -0.08,
  fzfluasel_bg_alter = -0.25,
  pmenu_bg_alter = 0.6,
  pmenu_fg_alter = 0.1,
  pmenusel_bg_alter = 1,
  quickfixline_alter = 0.1,
  winseparator_alter = 0.6,
})
reset_base_alter({ "base46-material-darker" }, {
  cursor_fg = "#16afca",
  cursorline_alter = 0.07,
  fzfluasel_bg_alter = -0.2,
  pmenu_bg_alter = 0.52,
  pmenusel_bg_alter = 1,
  quickfixline_alter = 0.25,
  winseparator_alter = 0.5,
})
reset_base_alter({ "base46-onenord" }, {
  cursor_fg = "#3879C5",
  cursorline_alter = 0.1,
  fzfluasel_bg_alter = -0.2,
  pmenu_bg_alter = 0.4,
  quickfixline_alter = 0.1,
  pmenusel_bg_alter = 0.55,
  winseparator_alter = 0.6,
})
reset_base_alter({ "base46-seoul256_dark" }, {
  cursor_fg = "#d75f87",
  cursorline_alter = 0.07,
  fzflua_bg_cursorline_alter = -0.05,
  fzfluasel_bg_alter = -0.34,
  pmenu_bg_alter = 0.3,
  pmenusel_bg_alter = 0.65,
  quickfixline_alter = 0.08,
})
reset_base_alter({ "base46-solarized_dark" }, {
  cursor_fg = "#708284",
  cursorline_alter = 0.07,
  fzflua_bg_cursorline_alter = -0.05,
  fzfluasel_bg_alter = -0.3,
  pmenu_bg_alter = 0.3,
  pmenusel_bg_alter = 0.65,
  quickfixline_alter = 0.2,
  winseparator_alter = 0.7,
})
reset_base_alter({ "base46-zenburn" }, {
  cursor_fg = "#f3eadb",
  cursorline_alter = 0.08,
  fzflua_bg_cursorline_alter = -0.08,
  fzfluasel_bg_alter = -0.3,
  pmenu_bg_alter = 0.4,
  pmenusel_bg_alter = 0.75,
  quickfixline_alter = 0.09,
  winseparator_alter = 0.25,
})
reset_base_alter({ "catppuccin-mocha" }, {
  cursor_fg = "#c7063c",
  cursorline_alter = 0.07,
  fzflua_bg_cursorline_alter = -0.1,
  fzfluasel_bg_alter = -0.35,
  pmenu_bg_alter = 0.65,
  pmenusel_bg_alter = 1.5,
  quickfixline_alter = 0.06,
  winseparator_alter = 0.6,
})
reset_base_alter({ "darkearth" }, {
  cmpdocnormal_fg_alter = 0.1,
  cursor_fg = "#b3276f",
  cursorline_alter = 0.1,
  fzfluasel_bg_alter = -0.3,
  normalfloat_bg_alter = -0.1,
  pmenu_bg_alter = 0.45,
  quickfixline_alter = 0.1,
  pmenusel_bg_alter = 0.8,
})
reset_base_alter({ "horizon" }, {
  cursor_fg = "#b3276f",
  cursorline_alter = 0.08,
  fzflua_bg_cursorline_alter = -0.05,
  fzfluasel_bg_alter = -0.2,
  pmenu_bg_alter = 0.6,
  pmenusel_bg_alter = 1,
  quickfixline_alter = 0.3,
  winseparator_alter = 0.6,
})
reset_base_alter({ "jellybeans" }, {
  cursor_fg = "#ffa560",
  cursorline_alter = 0.06,
  fzfluasel_bg_alter = -0.1,
  pmenu_bg_alter = 1,
  pmenusel_bg_alter = 1.8,
  quickfixline_alter = -0.7,
  winseparator_alter = 0.8,
})
reset_base_alter({ "lackluster" }, {
  cursor_fg = "#deeeed",
  cursorline_alter = 0.15,
  fzflua_bg_cursorline_alter = 0.3,
  fzfluasel_bg_alter = -0.1,
  normalfloat_bg_alter = 0.5,
  normalfloat_fg_alter = -0.01,
  pmenu_bg_alter = 1.5,
  pmenu_fg_alter = 2,
  pmenusel_bg_alter = 2.5,
  quickfixline_alter = 0.5,
  winseparator_alter = 1,
})
reset_base_alter({ "oxocarbon" }, {
  cursor_fg = "#ffffff",
  cursorline_alter = 0.07,
  fzflua_bg_cursorline_alter = 0.05,
  fzfluasel_bg_alter = -0.05,
  pmenu_bg_alter = 0.8,
  pmenusel_bg_alter = 1.5,
  quickfixline_alter = 0.3,
  winseparator_alter = 0.8,
})
reset_base_alter({ "rose-pine-dawn" }, {
  cursorline_alter = 0.1,
  fzflua_bg_cursorline_alter = 0.04,
  fzfluasel_bg_alter = 0.05,
  normalfloat_bg_alter = -0.08,
  pmenu_bg_alter = -0.1,
  pmenu_fg_alter = -0.4,
  pmenusel_bg_alter = -0.02,
  quickfixline_alter = 0.05,
  winseparator_alter = -0.08,
})
reset_base_alter({ "rose-pine-main" }, {
  cursor_fg = "#e0def4",
  cursorline_alter = 0.1,
  fzflua_bg_cursorline_alter = -0.1,
  fzfluasel_bg_alter = -0.05,
  pmenu_bg_alter = 0.5,
  pmenusel_bg_alter = 0.9,
  winseparator_alter = 0.7,
})
reset_base_alter({ "tokyonight-night" }, {
  cursor_fg = "#9e0e06",
  cursorline_alter = 0.05,
  fzflua_bg_cursorline_alter = -0.01,
  fzfluasel_bg_alter = -0.1,
  pmenu_bg_alter = 0.5,
  pmenusel_bg_alter = 1,
  quickfixline_alter = 0.5,
  winseparator_alter = 0.65,
})
reset_base_alter({ "tokyonight-storm" }, {
  cmpdocnormal_fg_alter = 0.1,
  cursor_fg = "#b3276f",
  cursorline_alter = 0.05,
  fzflua_bg_cursorline_alter = -0.02,
  fzfluasel_bg_alter = -0.25,
  pmenu_bg_alter = 0.45,
  pmenu_fg_alter = 0.1,
  pmenusel_bg_alter = 0.8,
  quickfixline_alter = 0.15,
  winseparator_alter = 0.8,
})
reset_base_alter({ "vscode_modern" }, {
  cmpdocnormal_fg_alter = 0.1,
  cursor_fg = "#fa1919",
  cursorline_alter = 0.1,
  fzflua_bg_cursorline_alter = 0.05,
  fzfluasel_bg_alter = -0.2,
  pmenu_bg_alter = 0.5,
  pmenu_fg_alter = 0.1,
  pmenusel_bg_alter = 1,
  search_fg_alter = 0.2,
  search_bg_alter = 0.8,
  quickfixline_alter = 0.35,
  winseparator_alter = 0.45,
})

local general_overrides = function()
  Highlight.all {
    -- ╔═════════════════════════════════════════════════════════╗
    -- ║                          BASE                           ║
    -- ╚═════════════════════════════════════════════════════════╝
    { FoldColumn = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 0.4 } } },
    { FoldColumn1 = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 1 } } },
    { ColorColumn = { bg = { from = "Normal", attr = "bg", alter = -0.1 } } },
    { LineNr = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 0.8 }, bold = true } },
    {
      CursorLine = {
        bg = Highlight.darken(Highlight.get("Keyword", "fg"), cursorline_alter, Highlight.get("Normal", "bg")),
      },
    },
    {
      CursorLineNr = {
        fg = { from = "Keyword", attr = "fg" },
        bg = { from = "CursorLine", attr = "bg" },
        bold = true,
      },
    },
    { Type = { italic = true, bold = true } },
    { Comment = { fg = { from = "Comment", attr = "fg", alter = -0.55 }, italic = true } },
    {
      Folded = {
        fg = { from = "Normal", attr = "bg", alter = 1.5 },
        bg = { from = "Normal", attr = "bg", alter = 0.7 },
      },
    },
    {
      FoldedBackup = {
        fg = { from = "Normal", attr = "bg", alter = 1.5 },
        bg = { from = "Normal", attr = "bg", alter = 0.7 },
      },
    },
    {
      FoldedMarkdown = {
        fg = { from = "Normal", attr = "bg" },
        bg = "NONE",
      },
    },

    { FoldedSign = { inherit = "Folded", bg = "NONE" } },
    { EndOfBuffer = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 0.2 } } },
    { SignColumn = { bg = "NONE" } },
    { NonText = { fg = { from = "Normal", attr = "bg", alter = 1.5 } } },
    { WinSeparator = { fg = { from = "Normal", attr = "bg", alter = winseparator_alter }, bg = "NONE" } },

    { WinBar = { bg = { from = "ColorColumn" }, fg = { from = "Normal", attr = "bg", alter = 1 } } },
    { WinBarNC = { bg = { from = "ColorColumn", attr = "bg" }, fg = { from = "WinBar", attr = "fg" } } },

    {
      StatusLine = {
        fg = Highlight.tint(Highlight.darken(Highlight.get("Keyword", "fg"), 0.8, Highlight.get("Normal", "bg")), -0.2),
        bg = Highlight.tint(Highlight.darken(Highlight.get("Keyword", "fg"), 0.3, Highlight.get("Normal", "bg")), -0.2),
        reverse = false,
      },
    },
    {
      TabLine = {
        fg = { from = "Normal", attr = "bg", alter = 2.9 },
        bg = { from = "StatusLine", attr = "bg", alter = -0.2 },
        reverse = false,
      },
    },
    {
      Pmenu = {
        fg = { from = "Normal", attr = "fg", alter = pmenu_fg_alter },
        bg = { from = "Normal", attr = "bg", alter = pmenu_bg_alter },
        reverse = false,
      },
    },
    {
      PmenuSel = {
        fg = "NONE",
        bg = { from = "Normal", attr = "bg", alter = pmenusel_bg_alter },
        bold = true,
        reverse = false,
      },
    },
    {
      NormalFloat = {
        fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
        bg = { from = "Normal", attr = "bg", alter = normalfloat_bg_alter },
        reverse = false,
      },
    },
    {
      FloatBorder = {
        fg = { from = "Pmenu", attr = "bg" },
        bg = { from = "NormalFloat", attr = "bg" },
      },
    },

    {
      NormalBoxComment = {
        fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
        bg = { from = "Normal", attr = "bg", alter = 2 },
      },
    },
    {
      FloatBoxComment = {
        fg = { from = "NormalBoxComment", attr = "bg", alter = 0.5 },
        bg = { from = "NormalBoxComment", attr = "bg" },
      },
    },
    {
      VisualBoxComment = {
        fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
        bg = { from = "Keyword", attr = "fg", alter = -0.2 },
      },
    },

    { PmenuThumb = { bg = { from = "FloatBorder", attr = "fg", alter = 0.1 } } },
    {
      FloatTitle = {
        bg = { from = "Keyword", attr = "fg", alter = -0.1 },
        fg = { from = "Normal", attr = "bg" },
        bold = true,
      },
    },

    {
      Search = {
        fg = Highlight.darken(dark_yellow, search_fg_alter, Highlight.get("Normal", "bg")),
        bg = Highlight.darken(dark_yellow, search_bg_alter, Highlight.get("Normal", "bg")),
      },
    },
    {
      CurSearch = {
        fg = Highlight.darken(dark_red, cursearch_fg_alter, Highlight.get("Normal", "bg")),
        bg = Highlight.darken(dark_red, cursearch_bg_alter, Highlight.get("Normal", "bg")),
      },
    },
    {
      IncSearch = {
        fg = Highlight.darken(dark_red, 0.1, Highlight.get("Normal", "bg")),
        bg = Highlight.darken(dark_red, 0.8, Highlight.get("Normal", "bg")),
      },
    },

    { Cursor = { bg = cursor_fg, reverse = false } },
    { TermCursor = { inherit = "Cursor" } },
    { Substitute = { inherit = "Search" } },

    -- {
    --   ErrorMsg = {
    --     inherit = "ErrorMsg",
    --     fg = { from = "ErrorMsg", attr = "fg", alter = 0.2 },
    --     bg = { from = "ErrorMsg", attr = "fg", alter = -0.2 },
    --   },
    -- },

    -- ╔═════════════════════════════════════════════════════════╗
    -- ║                           QF                            ║
    -- ╚═════════════════════════════════════════════════════════╝
    { qfFileName = { bg = "NONE" } },
    { QuickFixFileName = { bg = "NONE" } },
    { QuickFixLineNr = { fg = { from = "Normal", attr = "bg", alter = 1.5 } } },
    {
      QuickFixLine = {
        fg = "NONE",
        bg = { from = "StatusLine", attr = "bg", alter = quickfixline_alter },
        underline = false,
        reverse = false,
      },
    },

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
    -- { ["@punctuation.bracket"] = { fg = "yellow" } },

    { LspKindText = { link = "@markup" } },
    { LspKindBoolean = { link = "@boolean" } },
    { LspKindVariable = { link = "@variable" } },
    { LspKindConstant = { link = "@constant" } },
    { LspKindModule = { link = "@module" } },
    { LspKindPackage = { link = "@module" } },
    { LspKindKeyword = { link = "@lsp.type.keyword" } },
    { LspKindFunction = { link = "@function" } },
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
    -- { ["zshFunction"] = { fg = { from = "Identifier", attr = "fg" }, bold = true } },

    -- ──────────────────────────────── BASH ─────────────────────────────
    -- { ["@function.bash"] = { fg = { from = "Identifier", attr = "fg" }, bold = true } },
    -- { ["@function.call.bash"] = { fg = { from = "Identifier", attr = "fg" }, bold = true } },

    -- ──────────────────────────────── RUST ─────────────────────────────
    -- { ["@lsp.type.function.rust"] = { fg = { from = "Identifier", attr = "fg" }, bold = true } },

    -- ╔═════════════════════════════════════════════════════════╗
    -- ║                       DIFF COLOR                        ║
    -- ╚═════════════════════════════════════════════════════════╝
    -- These highlights are syntax groups that are set in diff.vim
    -- { GitSignsAdd = { bg = { from = "ColorColumn"} } },
    -- { diffBDiffer = { link = 'WarningMsg' } },
    -- { diffCommon = { link = 'WarningMsg' } },
    -- { diffDiffer = { link = 'WarningMsg' } },
    { diffFile = { inherit = "Directory", bg = { from = "Directory", attr = "fg", alter = -0.7 } } },
    -- { diffIdentical = { link = 'WarningMsg' } },
    -- { diffIndexLine = { link = 'Number' } },
    -- { diffIsA = { link = 'WarningMsg' } },
    -- { diffNoEOL = { link = 'WarningMsg' } },
    -- { diffOnly = { link = 'WarningMsg' } },

    {
      -- Setting darken: gunakan paramater (setting_color, ukuran, base_color)
      -- "ukuran" -> semakin tinggi semakin terang, sebaliknya semakin kecil semakin gelap
      diffAdd = {
        fg = Highlight.darken(dark_green, 0.8, Highlight.get("Normal", "bg")),
        bg = Highlight.darken(dark_green, 0.2, Highlight.get("Normal", "bg")),
        bold = true,
        reverse = false,
      },
    },
    {
      diffChange = {
        fg = Highlight.darken(dark_yellow, 0.8, Highlight.get("Normal", "bg")),
        bg = Highlight.darken(dark_yellow, 0.2, Highlight.get("Normal", "bg")),
        bold = true,
        reverse = false,
      },
    },
    {
      diffDelete = {
        fg = Highlight.darken(dark_red, 0.8, Highlight.get("Normal", "bg")),
        bg = Highlight.darken(dark_red, 0.2, Highlight.get("Normal", "bg")),
        bold = true,
        reverse = false,
      },
    },
    {
      diffText = {
        fg = Highlight.darken(dark_yellow, 1, Highlight.get("Normal", "bg")),
        bg = Highlight.darken(dark_yellow, 0.5, Highlight.get("Normal", "bg")),
        bold = true,
        reverse = false,
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

    { DiagnosticError = { fg = { from = "DiagnosticSignError", attr = "fg" }, bg = "NONE", italic = true } },
    { DiagnosticsErrorNumHl = { fg = { from = "DiagnosticError", attr = "fg" }, bg = "NONE" } },
    { DiagnosticWarn = { fg = { from = "DiagnosticSignWarn", attr = "fg" }, bg = "NONE", italic = true } },
    { DiagnosticsWarnNumHl = { fg = { from = "DiagnosticSignWarn", attr = "fg" }, bg = "NONE" } },
    { DiagnosticHint = { fg = { from = "DiagnosticSignHint", attr = "fg" }, bg = "NONE", italic = true } },
    { DiagnosticsHintNumHl = { fg = { from = "DiagnosticHint", attr = "fg" }, bg = "NONE" } },
    { DiagnosticInfo = { fg = { from = "DiagnosticSignInfo", attr = "fg" }, bg = "NONE", italic = true } },
    { DiagnosticsInfoNumHl = { fg = { from = "DiagnosticInfo", attr = "fg" }, bg = "NONE" } },

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

    -- ╔═════════════════════════════════════════════════════════╗
    -- ║                   CREATED HIGHLIGHTS                    ║
    -- ╚═════════════════════════════════════════════════════════╝
    {
      MyCodeUsage = {
        fg = { from = "Keyword", attr = "fg", alter = 0.1 },
        bg = { from = "StatusLine", attr = "bg", alter = -0.05 },
        italic = true,
      },
    },

    {
      KeywordMatch = {
        fg = { from = "DiagnosticError", attr = "fg" },
      },
    },
    {
      KeywordMatchFuzzy = {
        fg = { from = "KeywordMatch", attr = "fg", alter = -0.1 },
      },
    },

    {
      KeywordNC = {
        fg = Highlight.tint(Highlight.get("Keyword", "fg"), -0.1),
        bg = Highlight.tint(Highlight.get("Keyword", "fg"), -0.5),
      },
    },
    {
      KeywordBlur = {
        bg = { from = "StatusLineNC", attr = "bg", alter = 0.6 },
      },
    },

    {
      IndentGuides = {
        fg = { from = "LineNr", attr = "fg", alter = 0.6 },
        bg = "NONE",
      },
    },
    {
      IndentGuidesFolded = {
        fg = { from = "LineNr", attr = "fg", alter = 0.9 },
        bg = "NONE",
      },
    },

    -- HEIRLINE
    {
      StatusLineFilepath = {
        fg = { from = "StatusLine", attr = "fg", alter = 1.2 },
      },
    },
    {
      StatusLineFontWhite = {
        fg = { from = "StatusLine", attr = "fg", alter = 4 },
      },
    },
    {
      StatusLineBranchName = {
        fg = { from = "GitSignsAdd", attr = "fg", alter = 0.2 },
      },
    },
    {
      StatusLineFontNotice = {
        fg = { from = "Function", attr = "fg", alter = 0.2 },
      },
    },

    -- WINBAR
    {
      WinbarFilepath = {
        fg = { from = "LineNr", attr = "fg", alter = 0.5 },
      },
    },
    {
      WinbarFontWhite = {
        fg = { from = "StatusLine", attr = "fg", alter = 4 },
      },
    },

    -- ╔═════════════════════════════════════════════════════════╗
    -- ║                      PLUGIN COLORS                      ║
    -- ╚═════════════════════════════════════════════════════════╝
    --  ───────────────────────────────[ NOICE ]───────────────────────────────
    {
      NoiceCmdline = {
        fg = { from = "StatusLine", attr = "fg", alter = 0.4 },
        bg = { from = "StatusLine", attr = "bg" },
      },
    },
    --  ───────────────────────────────[ BLINK ]───────────────────────────────
    { BlinkCmpGhostText = { fg = { from = "NoiceCmdline", attr = "fg", alter = -0.35 }, bg = "NONE" } },
    {
      BlinkCmpDocSeparator = {
        fg = { from = "FloatBorder", attr = "fg" },
        bg = { from = "Pmenu", attr = "bg" },
      },
    },
    { BlinkCmpLabelMatch = { fg = { from = "Search", attr = "bg", alter = 0.1 } } },

    --  ────────────────────────────────[ CMP ]────────────────────────────────
    { CmpGhostText = { link = "BlinkCmpGhostText" } },
    {
      CmpItemIconWarningMsg = {
        fg = { from = "WarningMsg", attr = "fg" },
        bg = { from = "NormalFloat", attr = "bg" },
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

    { CmpItemAbbrMatchFuzzy = { inherit = "BlinkCmpLabelMatch" } },
    { CmpItemAbbrMatch = { fg = { from = "Error", attr = "fg", alter = 0.2 } } },

    -- ╭─────────╮
    -- │ CMPITEM │
    -- ╰─────────╯
    { CmpItemAbbrDefault = { fg = { from = "CmpItemAbbr", attr = "fg" } } },
    {
      CmpItemFloatBorder = {
        fg = { from = "FloatBorder", attr = "fg" },
        bg = { from = "Pmenu", attr = "bg" },
      },
    },

    -- ╭────────╮
    -- │ CMPDOC │
    -- ╰────────╯
    {
      CmpDocNormal = {
        fg = { from = "Keyword", attr = "fg", alter = cmpdocnormal_fg_alter },
        bg = { from = "Pmenu", attr = "bg" },
      },
    },
    {
      CmpDocFloatBorder = {
        fg = { from = "CmpItemFloatBorder", attr = "fg" },
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

    --  ──────────────────────────────[ AERIALS ]──────────────────────────────
    { AerialGuide = { fg = { from = "WinSeparator", attr = "fg", alter = 0.04 } } },
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

    --  ──────────────────────────────[ FZFLUA ]───────────────────────────
    { FzfLuaFilePart = { fg = { from = "Directory", attr = "fg", alter = -0.2 }, reverse = false } },
    { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.5 } } },
    { FzfLuaCursorLine = { bg = { from = "CursorLine", attr = "bg", alter = fzflua_bg_cursorline_alter } } },
    {
      FzfLuaCursorLineNr = {
        fg = { from = "Keyword", attr = "fg" },
        bg = { from = "FzfLuaCursorLine", attr = "bg" },
      },
    },

    { FzfLuaFzfMatch = { fg = { from = "Search", attr = "bg", alter = 0.2 }, bg = "NONE" } },
    { FzfLuaFzfMatchFuzzy = { fg = { from = "FzfLuaFzfMatch", attr = "fg", alter = -0.3 }, bg = "NONE" } },

    {
      FzfLuaSel = {
        fg = "NONE",
        bg = { from = "PmenuSel", attr = "bg", alter = fzfluasel_bg_alter },
        bold = true,
      },
    },

    -- ╭─────────╮
    -- │ PRPOMPT │
    -- ╰─────────╯
    { FzfLuaNormal = { bg = { from = "NormalFloat", attr = "bg" } } },
    { FzfLuaBorder = { inherit = "FloatBorder" } },
    { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 0.4 } } },

    { FzfLuaTitle = { inherit = "FloatTitle" } },
    {
      FzfLuaTitleIcon = {
        fg = { from = "Boolean", attr = "fg", alter = 0.2 },
        bg = { from = "FzfLuaNormal", attr = "bg" },
      },
    },

    -- ╭─────────╮
    -- │ PREVIEW │
    -- ╰─────────╯
    { FzfLuaPreviewNormal = { inherit = "NormalFloat" } },
    { FzfLuaPreviewBorder = { inherit = "FzfLuaBorder" } },
    { FzfLuaPreviewTitle = { inherit = "FloatTitle" } },
    { FzfLuaScrollBorderFull = { inherit = "PmenuThumb" } },

    --  ─────────────────────────────[ TELESCOPE ]─────────────────────────────
    { TelescopeNormal = { inherit = "FzfLuaNormal" } },
    { TelescopeBorder = { inherit = "FzfLuaBorder" } },
    { TelescopeMatching = { link = "FzfLuaFzfMatch" } },
    { TelescopeTitle = { inherit = "FzfLuaTitle" } },

    {
      TelescopeSelection = {
        -- fg = { from = "PmenuSel", attr = "fg" },
        bg = { from = "FzfLuaSel", attr = "bg" },
        bold = true,
      },
    },
    { TelescopeSelectionCaret = { bg = "NONE", fg = "green" } },

    -- ╭────────╮
    -- │ Prompt │
    -- ╰────────╯
    { TelescopePromptNormal = { inherit = "FzfLuaNormal" } },
    { TelescopePromptTitle = { inherit = "FzfLuaPreviewTitle" } },
    { TelescopePromptBorder = { inherit = "FzfLuaBorder" } },
    { TelescopePromptPrefix = { fg = { from = "FloatBorder", attr = "fg" }, bg = "NONE" } },
    { TelescopePromptCounter = { fg = { from = "FloatBorder", attr = "fg" } } },

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
        fg = { from = "FzfLuaFilePart", attr = "fg" },
        bg = { from = "FzfLuaNormal", attr = "bg" },
      },
    },
    { TelescopeResultsTitle = { inherit = "FzfLuaPreviewTitle" } },
    { TelescopeResultsBorder = { inherit = "FzfLuaBorder" } },
    { MiniAnimateCursor = { fg = "red", bg = "red" } },

    --  ──────────────────────────────[ SNACKS ]───────────────────────────
    -- ╭───────────────╮
    -- │ SNACKS PICKER │
    -- ╰───────────────╯
    { SnacksPickerFile = { link = "FzfLuaFilePart" } },
    { SnacksPickerDir = { link = "FzfLuaDirPart" } },
    { SnacksPickerMatch = { link = "FzfLuaFzfMatch" } },
    { SnacksPickerManSection = { link = "FzfLuaFzfMatchFuzzy" } },
    { SnacksPickerCursorLine = { link = "FzfLuaCursorLine" } },
    { SnacksPickerPreviewCursorLine = { link = "FzfLuaCursorLine" } },
    { SnacksPickerListCursorLine = { link = "FzfLuaSel" } },
    { SnacksPickerBorder = { link = "FloatBorder" } },

    -- ╭──────────────────╮
    -- │ SNACKS DASHBOARD │
    -- ╰──────────────────╯
    {
      SnacksDashboardTitle = {
        fg = { from = "Keyword", attr = "fg" },
        bg = "NONE",
        bold = true,
      },
    },
    {
      SnacksDashboardDesc = {
        fg = { from = "Keyword", attr = "fg" },
        bg = "NONE",
        bold = true,
      },
    },

    {
      SnacksDashboardTerminal = {
        fg = { from = "NonText", attr = "fg" },
        bg = "NONE",
        bold = false,
      },
    },
    {
      SnacksDashboardFooter = {
        fg = { from = "NonText", attr = "fg" },
        bg = "NONE",
        bold = true,
      },
    },

    -- ╭───────────────╮
    -- │ SNACKS INDENT │
    -- ╰───────────────╯
    {
      SnacksIndent = {
        fg = Highlight.darken(Highlight.get("Keyword", "fg"), 0.15, Highlight.get("Normal", "bg")),
      },
    },
    {
      SnacksIndentScope = {
        fg = Highlight.darken(Highlight.get("Keyword", "fg"), 0.4, Highlight.get("Normal", "bg")),
      },
    },

    -- ╭─────────────────╮
    -- │ SNACKS NOTIFIER │
    -- ╰─────────────────╯
    -- INFO
    -- {
    --   SnacksNotifierInfo = {
    --     fg = { from = "DiagnosticInfo", attr = "fg", alter = 2 },
    --     bg = Highlight.darken(Highlight.get("DiagnosticInfo", "fg"), 0.5, Highlight.get("Normal", "bg")),
    --     bold = true,
    --   },
    -- },
    -- {
    --   SnacksNotifierBorderInfo = {
    --     fg = { from = "SnacksNotifierInfo", attr = "bg", alter = 0.2 },
    --     bg = { from = "SnacksNotifierInfo", attr = "bg" },
    --   },
    -- },
    -- {
    --   SnacksNotifierTitleInfo = {
    --     fg = { from = "SnacksNotifierInfo", attr = "bg", alter = 1 },
    --     bg = { from = "SnacksNotifierInfo", attr = "bg" },
    --     bold = true,
    --   },
    -- },

    -- ERROR
    -- {
    --   SnacksNotifierError = {
    --     inherit = "SnacksNotifierError",
    --     -- fg = { from = "ErrorMsg", attr = "fg" },
    --     bg = { from = "KeywordMatchFuzzy", attr = "fg", alter = -0.1 },
    --     bold = true,
    --   },
    -- },
    -- {
    --   SnacksNotifierBorderError = {
    --     fg = { from = "SnacksNotifierError", attr = "bg", alter = -0.3 },
    --     bg = { from = "SnacksNotifierError", attr = "bg" },
    --   },
    -- },
    -- {
    --   SnacksNotifierTitleError = {
    --     fg = { from = "SnacksNotifierBorderError", attr = "fg" },
    --     bg = { from = "SnacksNotifierError", attr = "bg" },
    --     bold = true,
    --   },
    -- },
    -- WARN
    -- {
    --   SnacksNotifierWarn = {
    --     fg = { from = "DiagnosticWarn", attr = "fg", alter = 0.2 },
    --     bg = Highlight.darken(Highlight.get("DiagnosticWarn", "fg"), 0.5, Highlight.get("Normal", "bg")),
    --     bold = true,
    --   },
    -- },
    -- {
    --   SnacksNotifierBorderWarn = {
    --     fg = { from = "SnacksNotifierWarn", attr = "bg", alter = 0.2 },
    --     bg = { from = "SnacksNotifierWarn", attr = "bg" },
    --   },
    -- },
    -- {
    --   SnacksNotifierTitleWarn = {
    --     fg = { from = "SnacksNotifierWarn", attr = "bg", alter = 1 },
    --     bg = { from = "SnacksNotifierWarn", attr = "bg" },
    --     bold = true,
    --   },
    -- },

    -- ╭─────────────╮
    -- │ SNACKS MISC │
    -- ╰─────────────╯
    { SnacksNotifierHistory = { link = "NormalFloat" } },

    --  ──────────────────────────────[ ORGMODE ]──────────────────────────────
    { ["@org.agenda.scheduled"] = { fg = Highlight.darken("#3f9f31", 0.8, Highlight.get("Normal", "bg")) } },
    {
      ["@org.agenda.scheduled_past"] = {
        fg = Highlight.darken(dark_yellow, -0.6, Highlight.get("Normal", "bg")),
      },
    },

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
    -- { ["@org.tag"] = { inherit = "Function" } }, -- <-----------
    { ["@org.plan"] = { inherit = "Constant" } },
    { ["@org.comment"] = { inherit = "Comment" } },
    { ["@org.directive"] = { inherit = "Comment" } },
    { ["@org.block"] = { inherit = "Comment" } },
    { ["@org.latex"] = { inherit = "Statement" } },
    { ["@org.hyperlinks"] = { inherit = "Underlined" } },
    { ["@org.code"] = { inherit = "String" } },

    --  ─────────────────────────────[ FUGITIVE ]──────────────────────────
    { fugitiveStagedModifier = { inherit = "GitSignsAdd" } },
    { fugitiveUnstagedModifier = { inherit = "GitSignsChange" } },
    { fugitiveUntrackedModifier = { fg = { from = "GitSignsAdd", attr = "fg", alter = 0.2 } } },

    --  ─────────────────────────────[ DIFFIVIEW ]─────────────────────────────
    { DiffAddedChar = { bg = "NONE", fg = { from = "GitSignsAdd", attr = "fg", alter = 0.1 } } },
    { DiffChangedChar = { bg = "NONE", fg = { from = "GitSignsChange", attr = "fg", alter = 0.1 } } },
    { DiffDeletedChar = { bg = "NONE", fg = { from = "GitSignsDelete", attr = "fg", alter = 0.1 } } },
    { DiffviewStatusAdded = { link = "DiffAddedChar" } },
    { DiffviewStatusModified = { link = "DiffChangedChar" } },
    { DiffviewStatusRenamed = { link = "DiffChangedChar" } },
    { DiffviewStatusUnmerged = { link = "DiffChangedChar" } },
    { DiffviewStatusUntracked = { link = "DiffAddedChar" } },
    { DiffviewStatusDeleted = { link = "DiffDeletedChar" } },

    { DiffviewReference = { fg = { from = "GitSignsDelete", attr = "fg", alter = -0.2 } } },

    -- { DiffviewHash = { fg = { from = "Directory", attr = "fg", alter = -0.5 } } },
    { DiffviewHash = { fg = "lightmagenta" } },

    { DiffviewFilePanelCounter = { fg = { from = "Directory", attr = "fg", alter = -0.5 } } },
    { DiffviewFilePanelDeletions = { link = "DiffDeletedChar" } },
    { DiffviewFilePanelInsertions = { link = "DiffAddedChar" } },
    { DiffviewFilePanelPath = { fg = { from = "StatusLine", attr = "fg", alter = 0.08 } } },
    { DiffviewFilePanelSelected = { fg = { from = "DiffChangedChar", attr = "fg" } } },
    { DiffviewFilePanelFileName = { fg = { from = "DiffviewHash", attr = "fg", alter = 0.3 } } },

    --  ──────────────────────────────[ LAZYGIT ]──────────────────────────────
    { LazygitselectedLineBgColor = { bg = { from = "CursorLine", attr = "bg", alter = 0.5 } } },
    { LazygitInactiveBorderColor = { fg = { from = "WinSeparator", attr = "fg", alter = 0.7 }, bg = "NONE" } },

    --  ────────────────────────────[ BUFFERLINE ]─────────────────────────
    { BufferLineIndicatorSelected = { bg = { from = "ColorColumn" } } },

    --  ────────────────────────────────[ BQF ]────────────────────────────
    { BqfSign = { bg = { from = "ColorColumn", attr = "bg" }, { fg = { from = "Boolean" } } } },

    --  ───────────────────────────[ TODO-COMMENT ]────────────────────────
    { TodoSignWarn = { bg = "NONE", fg = "#FBBF24" } },
    { TodoSignFIX = { bg = "NONE", fg = "#DC2626" } }, -- for error
    { TodoSignTODO = { bg = "NONE", fg = "#2563EB" } },

    --  ──────────────────────────────[ GLANCE ]───────────────────────────
    { GlancePreviewNormal = { bg = "#111231" } },
    { GlancePreviewMatch = { fg = "#012D36", bg = "#FDA50F" } },
    { GlanceListMatch = { fg = dark_red, bg = "NONE" } },
    { GlancePreviewCursorLine = { bg = "#1b1c4b" } },

    --  ─────────────────────────────[ MARKDOWN ]──────────────────────────
    { ["@markup.heading.1.markdown"] = { fg = "#4d85c3", bold = true, italic = true } },
    { ["@markup.heading.2.markdown"] = { fg = "#389674", bold = true, italic = true } },
    { ["@markup.heading.3.markdown"] = { fg = "#b0be1e", bold = true, italic = true } },
    { ["@markup.heading.4.markdown"] = { fg = "#8594c8", bold = true, italic = true } },
    { ["@markup.heading.5.markdown"] = { fg = "#f76328", bold = true, italic = true } },
    { ["@markup.heading.6.markdown"] = { fg = "#fccf3e", bold = true, italic = true } },
    { ["@markup.raw.block.markdown"] = { bg = "NONE" } },
    { ["@markup.list.markdown"] = { bg = "NONE" } },

    {
      ["@markup.link.label.markdown_inline"] = {
        fg = { from = "Keyword", attr = "fg", alter = 0.2 },
        bg = Highlight.darken(Highlight.get("Keyword", "fg"), 0.2, Highlight.get("Normal", "bg")),
        bold = true,
      },
    },
    {
      ["@markup.quote.markdown"] = {
        fg = { from = "Boolean", attr = "fg", alter = 0.2 },
        bg = Highlight.darken(Highlight.get("Boolean", "fg"), 0.2, Highlight.get("Normal", "bg")),
        italic = true,
        bold = false,
      },
    },
    {
      ["@markup.strong.markdown_inline"] = {
        fg = { from = "Keyword", attr = "fg", alter = 0.2 },
        bg = "NONE",
        bold = true,
      },
    },
    {
      ["@markup.italic.markdown_inline"] = {
        fg = { from = "Keyword", attr = "fg", alter = 0.4 },
        bg = "NONE",
        bold = false,
        italic = true,
      },
    },
    {
      ["@markup.raw.markdown_inline"] = {
        fg = { from = "Keyword", attr = "fg", alter = 0.2 },
        bg = { from = "Normal", attr = "bg", alter = 0.6 },
        bold = true,
        reverse = false,
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
        fg = { from = "Boolean", attr = "fg", alter = 0.2 },
        bold = true,
      },
    },

    { RenderMarkdownCode = { bg = { from = "Normal", attr = "bg", alter = 0.2 } } },
    {
      RenderMarkdownCodeInline = {
        fg = { from = "Keyword", attr = "fg", alter = 0.2 },
        bg = Highlight.darken(Highlight.get("Keyword", "fg"), 0.2, Highlight.get("Normal", "bg")),
        bold = true,
      },
    },
    { ["@markup.raw.markdown_inline"] = { link = "RenderMarkdownCodeInline" } },

    --  ───────────────────────────────[ FLASH ]───────────────────────────────
    { FlashMatch = { fg = "white", bg = "red", bold = true } },
    { FlashLabel = { bg = "black", fg = "yellow", bold = true, strikethrough = false } },
    { FlashCursor = { bg = { from = "ColorColumn", attr = "bg", alter = 5 }, bold = true } },

    --  ─────────────────────────────[ GRUG FAR ]──────────────────────────
    {
      GrugFarResultsPath = {
        fg = { from = "Directory", attr = "fg" },
        bold = true,
        underline = true,
      },
    },
    {
      GrugFarResultsLineNr = {
        fg = { from = "LineNr", attr = "fg", alter = 0.5 },
        bg = { from = "Normal", attr = "bg", alter = 0.2 },
      },
    },

    -- { GrugFarResultsLineColumn = { link = "GrugFarResultsLineNo" } },
    --
    -- {
    --   GrugFarResultsMatch = {
    --     fg = { from = "CurSearch", attr = "bg", alter = 0.5 },
    --     bg = { from = "CurSearch", attr = "bg", alter = -0.6 },
    --     bold = true,
    --   },
    -- },
    { GrugFarResultsNumberLabel = { fg = { from = "CurSearch", attr = "bg", alter = -0.2 } } },

    --  ──────────────────────────────[ RGFLOW ]───────────────────────────
    {
      RgFlowHeadLine = {
        bg = { from = "Keyword", attr = "fg", alter = -0.5 },
        fg = { from = "NormalFloat", attr = "bg" },
      },
    },
    {
      RgFlowHead = {
        bg = { from = "RgFlowHeadLine" },
        fg = { from = "Keyword", attr = "fg", alter = 0.5 },
        bold = true,
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

    --  ────────────────────────────[ VIM.MATCHUP ]────────────────────────────
    { MatchParen = { bg = { from = "Normal", attr = "bg", alter = -1 }, fg = "white", bold = false } },

    --  ──────────────────────────────[ LAZYVIM ]──────────────────────────────
    { LazyNormal = { inherit = "NormalFloat" } },
    { LazyDimmed = { bg = "NONE" } },

    --  ─────────────────────────────[ DEBUG:DAP ]─────────────────────────────
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

    --  ─────────────────────────────[ COVERAGE ]──────────────────────────
    { CoverageCovered = { bg = { from = "ColorColumn", attr = "bg" } } },
    { CoveragePartial = { bg = { from = "ColorColumn", attr = "bg" } } },
    { CoverageUncovered = { bg = { from = "ColorColumn", attr = "bg" } } },

    { CoverageSummaryFail = { bg = { from = "ColorColumn", attr = "bg" } } },

    --  ─────────────────────────────[ OVERSEER ]──────────────────────────
    { OverseerTaskBorder = { fg = { from = "WinSeparator", attr = "fg" }, bg = "NONE" } },

    --  ─────────────────────────────[ WHICH KEY ]─────────────────────────────
    { WhichKeyTitle = { inherit = "FloatTitle" } },
    -- { WhichKeyNormal = { inherit = "NormalFloat", fg = { from = "Function", attr = "fg", alter = 0.1 } } }, -- <----
    { WhichKeyGroup = { inherit = "NormalFloat", fg = { from = "Keyword", attr = "fg", alter = 0.1 } } },
    { WhichKeyDesc = { inherit = "NormalFloat", fg = { from = "Boolean", attr = "fg", alter = 0.1 } } },
    { WhichKeyBorder = { inherit = "FloatBorder" } },

    --  ──────────────────────────────[ TROUBLE ]──────────────────────────────
    { TroubleNormal = { inherit = "Normal" } },
    { TroubleNormalNC = { inherit = "Normal" } },

    { TroubleSignWarning = { bg = "NONE", fg = { from = "DiagnosticSignWarn", alter = -0.1 } } },
    { TroubleSignError = { bg = "NONE", fg = { from = "DiagnosticSignError", alter = -0.1 } } },
    { TroubleSignHint = { bg = "NONE", fg = { from = "DiagnosticSignHint", alter = -0.1 } } },
    { TroubleSignInfo = { bg = "NONE", fg = { from = "DiagnosticSignInfo", alter = -0.1 } } },
    { TroubleSignOther = { bg = "NONE", fg = { from = "DiagnosticSignInfo", alter = -0.1 } } },
    { TroubleSignInformation = { bg = "NONE", fg = { from = "DiagnosticSignInfo", alter = -0.1 } } },

    {
      TroubleIndent = {
        fg = { from = "Normal", attr = "bg", alter = 0.6 },
        bg = "NONE",
      },
    },
    {
      TroubleIndentFoldClosed = {
        inherit = "TroubleIndent",
        fg = { from = "TroubleIndent", attr = "fg", alter = 0.8 },
      },
    },
    { TroubleIndentFoldOpen = { link = "TroubleIndentFoldClosed" } },

    -- DIRECTORY
    { TroubleDirectory = { bg = "NONE" } },
    { TroubleFsPos = { inherit = "TroubleIndent", fg = { from = "TroubleIndent", attr = "fg", alter = 0.5 } } },
    {
      TroubleFsCount = {
        fg = { from = "Directory", attr = "fg", alter = 0.2 },
        bg = { from = "Directory", attr = "fg", alter = -0.5 },
      },
    },

    -- LSP
    { TroubleLspFilename = { bg = "NONE" } },
    { TroubleLspPos = { link = "TroubleFsPos" } },
    { TroubleLspCount = { link = "TroubleFsCount" } },
    { TroubleLspItemClient = { link = "TroubleLspCount" } },

    -- DIAGNOSTICS
    { TroubleDiagnosticsBasename = { bg = "NONE" } },
    { TroubleDiagnosticsPos = { link = "TroubleFsPos" } },
    {
      TroubleDiagnosticsCount = {
        fg = { from = "DiagnosticWarn", attr = "fg", alter = 0.2 },
        bg = { from = "DiagnosticWarn", attr = "fg", alter = -0.5 },
      },
    },

    -- TODO
    { TroubleTodoFilename = { bg = "NONE" } },
    { TroubleTodoPos = { link = "TroubleFsPos" } },
    { TroubleTodoCount = { link = "TroubleFsCount" } },

    -- QUICKFIX
    { TroubleQfFilename = { bg = "NONE" } },
    { TroubleQfPos = { link = "TroubleFsPos" } },
    { TroubleQfCount = { link = "TroubleFsCount" } },

    -- DUNNO
    {
      TroubleCode = {
        bg = "NONE",
        fg = { from = "ErrorMsg", attr = "fg" },
        underline = false,
      },
    },

    --  ──────────────────────────────[ OUTLINE ]──────────────────────────────
    {
      OutlineCurrent = {
        fg = { from = "Keyword", attr = "fg", alter = 0.1 },
        bg = { from = "Keyword", attr = "fg", alter = -0.5 },
        bold = true,
      },
    },
    {
      OutlineDetails = {
        inherit = "Comment",
        fg = { from = "Comment", attr = "fg", alter = 0.8 },
        bg = "NONE",
        italic = true,
      },
    },
    { OutlineJumpHighlight = { bg = "red", fg = "NONE" } },
    { OutlineLineno = { bg = "NONE" } },
    { OutlineFoldMarker = { link = "IndentGuidesFolded" } },
    { OutlineGuides = { link = "IndentGuides" } },

    --  ──────────────────────────────[ AVANTE ]───────────────────────────
    {
      AvanteNormal = {
        fg = { from = "Normal", attr = "bg", alter = 4 },
        bg = { from = "Normal", attr = "bg", alter = -0.5 },
      },
    },
    {
      AvanteInlineHint = {
        fg = { from = "Keyword", attr = "fg", alter = -0.6 },
        bg = "NONE",
      },
    },
  }
end

local function set_sidebar_highlight()
  Highlight.all {
    { PanelDarkBackground = { bg = { from = "Normal", alter = -0.05 } } },
    { PanelDarkHeading = { inherit = "PanelDarkBackground", bold = true } },
    { PanelBackground = { bg = { from = "Normal" } } },
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

local rose_pine = {
  ["rose-pine-dawn"] = {
    -- DIFF
    {
      diffAdd = {
        fg = Highlight.darken(dark_green, 1.3, Highlight.get("Normal", "bg")),
        bg = Highlight.darken(dark_green, 0.9, Highlight.get("Normal", "bg")),
        bold = true,
        reverse = false,
      },
    },
    {
      diffChange = {
        fg = Highlight.darken(dark_yellow, 0.9, Highlight.get("Normal", "bg")),
        bg = Highlight.darken(dark_yellow, 0.7, Highlight.get("Normal", "bg")),
        bold = true,
        reverse = false,
      },
    },
    {
      diffDelete = {
        fg = Highlight.darken(dark_red, 1.3, Highlight.get("Normal", "bg")),
        bg = Highlight.darken(dark_red, 0.7, Highlight.get("Normal", "bg")),
        bold = true,
        reverse = false,
      },
    },
    {
      diffText = {
        fg = Highlight.darken(dark_yellow, 0.5, Highlight.get("Normal", "bg")),
        bg = Highlight.darken(dark_yellow, 0.9, Highlight.get("Normal", "bg")),
        bold = true,
        reverse = false,
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

    { NonText = { fg = { from = "Normal", attr = "bg", alter = -0.2 } } },

    { LineNr = { fg = { from = "Normal", attr = "bg", alter = -0.2 }, bold = true } },
    { LineNrAbove = { link = "LineNr" } },
    { LineNrBelow = { link = "LineNr" } },

    { qfFileName = { fg = { from = "Directory", attr = "fg", alter = 0.3 }, bg = "NONE" } },
    { QuickFixFileName = { fg = { from = "Directory", attr = "fg" }, bg = "NONE" } },

    { Visual = { bg = { from = "Visual", attr = "bg", alter = -0.1 } } },

    { Comment = { fg = { from = "Normal", attr = "bg", alter = -0.35 }, italic = true } },
    { ["@comment"] = { inherit = "Comment" } },

    {
      Folded = {
        fg = Highlight.tint(Highlight.darken(Highlight.get("Keyword", "fg"), 1, Highlight.get("Normal", "bg")), -0.2),
        bg = Highlight.tint(Highlight.darken(Highlight.get("Keyword", "fg"), 0.8, Highlight.get("Normal", "bg")), 0.2),
      },
    },
    { FoldedSign = { fg = { from = "Folded", attr = "fg", alter = -0.4 }, bg = "NONE" } },

    { BlinkCmpLabelMatch = { fg = { from = "KeywordMatch", attr = "fg" } } },
    { CmpItemAbbrMatchFuzzy = { inherit = "BlinkCmpLabelMatch" } },

    -- OUTLINE
    {
      IndentGuides = {
        fg = { from = "Normal", attr = "bg", alter = -0.05 },
        bg = "NONE",
      },
    },
    {
      IndentGuidesFolded = {
        fg = { from = "Normal", attr = "bg", alter = -0.2 },
        bg = "NONE",
      },
    },
    { OutlineDetails = { fg = { from = "Comment", attr = "fg", alter = 0.2 }, bg = "NONE", italic = true } },

    -- QFSILET
    {
      NormalBoxComment = {
        fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
        bg = { from = "Normal", attr = "bg", alter = -0.12 },
      },
    },
    {
      FloatBoxComment = {
        fg = { from = "NormalBoxComment", attr = "bg", alter = -0.05 },
        bg = { from = "NormalBoxComment", attr = "bg" },
      },
    },
    {
      VisualBoxComment = {
        fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
        bg = { from = "Keyword", attr = "fg", alter = -0.2 },
      },
    },

    -- ORGMODE
    { ["@org.comment"] = { inherit = "Comment" } },
    { ["@org.directive"] = { inherit = "Comment" } },
    { ["@org.timestamp.inactive"] = { inherit = "Comment" } },

    -- SNACKS
    { SnacksIndent = { fg = { from = "SnacksIndent", attr = "fg", alter = 0.08 } } },
    { SnacksIndentScope = { fg = { from = "SnacksIndentScope", attr = "fg", alter = 0.15 } } },

    -- FZFLUA
    { FzfLuaCursorLine = { bg = { from = "CursorLine", attr = "bg", alter = fzflua_bg_cursorline_alter } } },
    {
      FzfLuaCursorLineNr = {
        fg = { from = "FzfLuaCursorLine", attr = "bg", alter = -0.5 },
        bg = { from = "FzfLuaCursorLine", attr = "bg" },
      },
    },
    {
      FzfLuaSel = {
        fg = "NONE",
        bg = { from = "PmenuSel", attr = "bg", alter = fzfluasel_bg_alter },
        bold = true,
      },
    },
    { FzfLuaFzfMatch = { fg = { from = "BlinkCmpLabelMatch", attr = "fg" }, bg = "NONE" } },
    { FzfLuaFzfMatchFuzzy = { fg = { from = "FzfLuaFzfMatch", attr = "fg", alter = -0.1 }, bg = "NONE" } },
    { FzfLuaFilePart = { fg = { from = "Directory", attr = "fg", alter = -0.1 }, reverse = false } },
    { FzfLuaDirPart = { fg = { from = "Normal", attr = "bg", alter = -0.35 } } },
    { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = -0.03 } } },

    {
      TelescopeResultsNormal = {
        fg = { from = "FzfLuaFilePart", attr = "fg" },
        bg = { from = "FzfLuaNormal", attr = "bg" },
      },
    },
    {
      TelescopeSelection = {
        bg = { from = "FzfLuaSel", attr = "bg" },
        bold = true,
      },
    },

    -- MARKDOWN
    {
      ["@markup.link.label.markdown_inline"] = {
        fg = { from = "Keyword", attr = "fg", alter = 0.2 },
        bg = { from = "Keyword", attr = "fg", alter = 4.5 },
        bold = true,
      },
    },
    {
      ["@markup.quote.markdown"] = {
        fg = { from = "Boolean", attr = "fg", alter = -0.2 },
        bg = { from = "Boolean", attr = "fg", alter = 0.5 },
        italic = true,
        bold = false,
      },
    },
    {
      ["@markup.strong.markdown_inline"] = {
        fg = { from = "Keyword", attr = "fg", alter = 0.2 },
        bg = "NONE",
        bold = true,
      },
    },
    {
      ["@markup.italic.markdown_inline"] = {
        fg = { from = "Keyword", attr = "fg", alter = 0.4 },
        bg = "NONE",
        bold = false,
        italic = true,
      },
    },
    {
      ["@markup.raw.markdown_inline"] = {
        fg = { from = "Keyword", attr = "fg", alter = 0.2 },
        bg = { from = "Keyword", attr = "fg", alter = 0.6 },
        bold = true,
        reverse = false,
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
        fg = { from = "Boolean", attr = "fg", alter = 0.2 },
        bold = true,
      },
    },
    { RenderMarkdownCode = { bg = { from = "Normal", attr = "bg", alter = -0.1 } } },

    -- SNACKS
    {
      SnacksDashboardTerminal = {
        fg = { from = "NonText", attr = "fg" },
        bg = "NONE",
        bold = false,
      },
    },
    {
      SnacksDashboardFooter = {
        fg = { from = "NonText", attr = "fg" },
        bg = "NONE",
        bold = true,
      },
    },

    -- info
    {
      SnacksNotifierInfo = {
        fg = { from = "DiagnosticInfo", attr = "fg", alter = 2 },
        bg = Highlight.tint(
          Highlight.darken(Highlight.get("DiagnosticInfo", "fg"), 0.5, Highlight.get("Normal", "bg")),
          -0.1
        ),
        bold = true,
      },
    },
    {
      SnacksNotifierBorderInfo = {
        fg = { from = "SnacksNotifierInfo", attr = "bg", alter = 0.2 },
        bg = { from = "SnacksNotifierInfo", attr = "bg" },
      },
    },
    {
      SnacksNotifierTitleInfo = {
        fg = { from = "SnacksNotifierBorderInfo", attr = "fg", alter = 0.2 },
        bg = { from = "SnacksNotifierInfo", attr = "bg" },
        bold = true,
      },
    },
    -- error
    {
      SnacksNotifierError = {
        fg = { from = "DiagnosticError", attr = "fg" },
        bg = Highlight.tint(
          Highlight.darken(Highlight.get("DiagnosticError", "fg"), 0.5, Highlight.get("Normal", "bg")),
          0.5
        ),
        bold = true,
      },
    },
    {
      SnacksNotifierBorderError = {
        fg = { from = "SnacksNotifierError", attr = "bg", alter = 0.1 },
        bg = { from = "SnacksNotifierError", attr = "bg" },
      },
    },
    {
      SnacksNotifierTitleError = {
        fg = { from = "SnacksNotifierBorderError", attr = "fg", alter = 0.2 },
        bg = { from = "SnacksNotifierError", attr = "bg" },
        bold = true,
      },
    },
    -- warn
    {
      SnacksNotifierWarn = {
        fg = { from = "DiagnosticWarn", attr = "fg" },
        bg = Highlight.tint(
          Highlight.darken(Highlight.get("DiagnosticWarn", "fg"), 0.8, Highlight.get("Normal", "bg")),
          0.5
        ),
        bold = true,
      },
    },
    {
      SnacksNotifierBorderWarn = {
        fg = { from = "SnacksNotifierWarn", attr = "bg", alter = -0.1 },
        bg = { from = "SnacksNotifierWarn", attr = "bg" },
      },
    },
    {
      SnacksNotifierTitleWarn = {
        fg = { from = "SnacksNotifierBorderWarn", attr = "fg", alter = -0.2 },
        bg = { from = "SnacksNotifierWarn", attr = "bg" },
        bold = true,
      },
    },

    {
      AvanteInlineHint = {
        fg = { from = "Keyword", attr = "fg", alter = -0.4 },
        bg = "NONE",
      },
    },

    -- LSP
    {
      LspReferenceWrite = {
        bg = { from = "LspReferenceWrite", attr = "bg", alter = 0.22 },
        underline = false,
        reverse = false,
        undercurl = false,
      },
    },

    {
      LspReferenceRead = {
        bg = { from = "LspReferenceRead", attr = "bg", alter = 0.22 },
        underline = false,
        reverse = false,
        undercurl = false,
      },
    },

    -- TROUBLE
    {
      OutlineCurrent = {
        fg = { from = "Keyword", attr = "fg", alter = 0.2 },
        bg = { from = "Keyword", attr = "fg", alter = 1 },
        bold = true,
      },
    },
    {
      TroubleIndent = {
        fg = { from = "Normal", attr = "bg", alter = -0.5 },
        bg = "NONE",
      },
    },
    {
      TroubleIndentFoldClosed = {
        inherit = "TroubleIndent",
        fg = { from = "TroubleIndent", attr = "fg", alter = -0.2 },
      },
    },
    { TroubleIndentFoldOpen = { link = "TroubleIndentFoldClosed" } },

    { TroubleFsPos = { inherit = "TroubleIndent", fg = { from = "TroubleIndent", attr = "fg", alter = -0.1 } } },
    {
      TroubleFsCount = {
        fg = { from = "Directory", attr = "fg", alter = 0.8 },
        bg = { from = "Directory", attr = "fg", alter = 0.2 },
      },
    },

    -- lsp
    { TroubleLspFilename = { bg = "NONE" } },
    { TroubleLspPos = { link = "TroubleFsPos" } },
    { TroubleLspCount = { link = "TroubleFsCount" } },
    { TroubleLspItemClient = { link = "TroubleLspCount" } },

    -- diagnostics
    { TroubleDiagnosticsBasename = { bg = "NONE" } },
    { TroubleDiagnosticsPos = { link = "TroubleFsPos" } },
    {
      TroubleDiagnosticsCount = {
        fg = { from = "DiagnosticWarn", attr = "fg", alter = 0.2 },
        bg = { from = "DiagnosticWarn", attr = "fg", alter = -0.1 },
      },
    },

    -- todo
    { TroubleTodoFilename = { bg = "NONE" } },
    { TroubleTodoPos = { link = "TroubleFsPos" } },
    { TroubleTodoCount = { link = "TroubleFsCount" } },

    -- quickfix
    { TroubleQfFilename = { bg = "NONE" } },
    { TroubleQfPos = { link = "TroubleFsPos" } },
    { TroubleQfCount = { link = "TroubleFsCount" } },

    -- STATUSLINE
    {
      StatusLine = {
        fg = Highlight.tint(Highlight.darken(Highlight.get("Keyword", "fg"), 0.38, Highlight.get("Normal", "bg")), 0.6),
        bg = Highlight.tint(Highlight.darken(Highlight.get("Keyword", "fg"), 0.75, Highlight.get("Normal", "bg")), 0.1),
        reverse = false,
      },
    },
    {
      NoiceCmdline = {
        fg = { from = "StatusLine", attr = "fg", alter = -0.1 },
        bg = { from = "StatusLine", attr = "bg" },
      },
    },
    { BlinkCmpGhostText = { fg = { from = "NoiceCmdline", attr = "fg", alter = -0.08 }, bg = "NONE" } },
    {
      QuickFixLine = {
        fg = "NONE",
        bg = { from = "StatusLine", attr = "bg", alter = quickfixline_alter },
        underline = false,
        reverse = false,
      },
    },
    {
      StatusLineNC = {
        fg = { from = "Normal", attr = "bg", alter = 2.7 },
        bg = { from = "Normal", attr = "bg", alter = -0.2 },
      },
    },
    { KeywordBlur = { bg = { from = "StatusLineNC", attr = "bg", alter = 0.4 } } },
    {
      TabLine = {
        fg = { from = "Normal", attr = "bg", alter = -0.27 },
        bg = { from = "Normal", attr = "bg", alter = -0.06 },
      },
    },
    {
      KeywordNC = {
        fg = { from = "Keyword", attr = "fg" },
        bg = { from = "TabLine", attr = "bg" },
      },
    },

    -- CREATED HIGHLIGHTS
    { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = -0.05 } } },
    { StatusLineFilepath = { fg = { from = "StatusLine", attr = "fg", alter = -0.25 } } },
    { StatusLineFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = -0.35 } } },
    { StatusLineFontNotice = { fg = { from = "Function", attr = "fg", alter = -0.08 } } },
    { WinbarFilepath = { fg = { from = "LineNr", attr = "fg", alter = -0.2 } } },
    { WinbarFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = -0.4 } } },
  },
  ["rose-pine-main"] = {
    { Visual = { bg = { from = "Visual", attr = "bg", alter = 0.05 } } },

    { LineNr = { fg = { from = "LineNr", attr = "fg", alter = 0.05 }, bold = true } },
    { LineNrAbove = { link = "LineNr" } },
    { LineNrBelow = { link = "LineNr" } },

    { Comment = { fg = { from = "Comment", attr = "fg", alter = 0.3 }, italic = true } },
    { ["@comment"] = { inherit = "Comment" } },

    {
      Folded = {
        fg = { from = "Keyword", attr = "fg", alter = -0.48 },
        bg = { from = "Keyword", attr = "fg", alter = -0.68 },
      },
    },
    { FoldedSign = { fg = { from = "Folded", attr = "fg", alter = -0.4 }, bg = "NONE" } },

    -- QFSILET
    {
      NormalBoxComment = {
        fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
        bg = { from = "Normal", attr = "bg", alter = 0.25 },
      },
    },
    {
      FloatBoxComment = {
        fg = { from = "NormalBoxComment", attr = "bg", alter = 0.5 },
        bg = { from = "NormalBoxComment", attr = "bg" },
      },
    },
    {
      VisualBoxComment = {
        fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
        bg = { from = "Keyword", attr = "fg", alter = -0.2 },
      },
    },

    -- BLINK
    { BlinkCmpGhostText = { fg = { from = "LineNr", attr = "fg", alter = 0.6 } } },

    -- OUTLINE
    {
      OutlineCurrent = {
        fg = { from = "Keyword", attr = "fg", alter = 0.7 },
        bg = { from = "Keyword", attr = "fg", alter = -0.1 },
        bold = true,
      },
    },
    {
      IndentGuides = {
        fg = { from = "Normal", attr = "bg", alter = 1 },
        bg = "NONE",
      },
    },
    {
      IndentGuidesFolded = {
        fg = { from = "Normal", attr = "bg", alter = 1.5 },
        bg = "NONE",
      },
    },
    {
      OutlineDetails = {
        inherit = "OutlineDetails",
        fg = { from = "OutlineDetails", attr = "fg", alter = -0.4 },
      },
    },

    -- COMMENT
    { ["@org.comment"] = { inherit = "Comment" } },
    { ["@org.directive"] = { inherit = "Comment" } },
    { ["@org.timestamp.inactive"] = { inherit = "Comment" } },

    -- SNACKS
    { SnacksIndent = { fg = { from = "SnacksIndent", attr = "fg", alter = -0.15 } } },
    { SnacksIndentScope = { fg = { from = "SnacksIndentScope", attr = "fg", alter = -0.2 } } },

    -- FZFLUA
    { FzfLuaFilePart = { fg = { from = "Directory", attr = "fg", alter = -0.2 }, reverse = false } },
    { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.6 } } },
    { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 0.15 } } },
    { FzfLuaCursorLine = { fg = "NONE" } },

    -- TROUBLE
    {
      TroubleIndent = {
        inherit = "TroubleIndent",
        fg = { from = "TroubleIndent", attr = "fg", alter = 0.4 },
      },
    },
    {
      TroubleFsPos = {
        inherit = "TroubleIndent",
        fg = { from = "TroubleIndent", attr = "fg", alter = -0.05 },
      },
    },

    -- AVANTE
    {
      AvanteInlineHint = {
        fg = { from = "Keyword", attr = "fg", alter = -0.4 },
        bg = "NONE",
      },
    },

    -- MARKDOWN
    { RenderMarkdownCode = { bg = { from = "Normal", attr = "bg", alter = 0.35 } } },

    -- STATUSLINE
    {
      StatusLineNC = {
        fg = { from = "Normal", attr = "bg", alter = 3.2 },
        bg = { from = "Normal", attr = "bg", alter = 0.6 },
      },
    },
    {
      KeywordBlur = {
        bg = { from = "StatusLineNC", attr = "bg", alter = 0.4 },
      },
    },
    {
      TabLine = {
        fg = { from = "Normal", attr = "bg", alter = 1.8 },
        bg = { from = "Normal", attr = "bg", alter = 0.4 },
      },
    },

    -- CREATED HIGHLIGHTS
    { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.2 } } },
    { StatusLineFilepath = { fg = { from = "StatusLine", attr = "fg", alter = 1.2 } } },
    { StatusLineFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 2.2 } } },
    { WinbarFilepath = { fg = { from = "LineNr", attr = "fg", alter = 0.8 } } },
    { WinbarFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 2.5 } } },
  },
}

local function colorscheme_overrides()
  local overrides = {
    ["ashen"] = {
      {
        PmenuSel = {
          fg = "NONE",
          bg = Highlight.tint(Highlight.get("Normal", "bg"), pmenusel_bg_alter),
          bold = true,
        },
      },

      { Visual = { bg = { from = "Visual", attr = "bg", alter = -0.15 } } },

      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = 0.4 }, bold = true } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      { Comment = { fg = { from = "Comment", attr = "fg", alter = 0.5 }, italic = true } },
      { ["@comment"] = { inherit = "Comment" } },

      {
        Folded = {
          fg = { from = "Keyword", attr = "fg", alter = -0.75 },
          bg = { from = "Keyword", attr = "fg", alter = -0.85 },
        },
      },
      { FoldedSign = { fg = { from = "Folded", attr = "fg", alter = -0.51 }, bg = "NONE" } },

      -- QFSILET
      {
        NormalBoxComment = {
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Normal", attr = "bg", alter = 0.65 },
        },
      },
      {
        FloatBoxComment = {
          fg = { from = "NormalBoxComment", attr = "bg", alter = 0.5 },
          bg = { from = "NormalBoxComment", attr = "bg" },
        },
      },
      {
        VisualBoxComment = {
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Keyword", attr = "fg", alter = -0.2 },
        },
      },

      -- OUTLINE
      {
        IndentGuides = {
          fg = { from = "LineNr", attr = "fg", alter = 0.1 },
          bg = "NONE",
        },
      },
      {
        IndentGuidesFolded = {
          fg = { from = "LineNr", attr = "fg", alter = 0.5 },
          bg = "NONE",
        },
      },
      {
        OutlineDetails = {
          inherit = "OutlineDetails",
          fg = { from = "OutlineDetails", attr = "fg", alter = -0.2 },
        },
      },

      -- ORGMODE
      { ["@org.comment"] = { inherit = "Comment" } },
      { ["@org.directive"] = { inherit = "Comment" } },
      { ["@org.timestamp.inactive"] = { inherit = "Comment" } },

      -- SNACKS
      { SnacksIndent = { fg = { from = "SnacksIndent", attr = "fg", alter = -0.51 } } },
      { SnacksIndentScope = { fg = { from = "SnacksIndentScope", attr = "fg", alter = -0.58 } } },

      -- BLINK
      { BlinkCmpGhostText = { fg = { from = "LineNr", attr = "fg", alter = 0.6 } } },

      -- DIFFIVIEW
      { DiffviewFilePanelCounter = { fg = { from = "GitSignsAdd", attr = "fg", alter = -0.5 } } },
      { DiffviewFilePanelPath = { fg = { from = "StatusLine", attr = "fg", alter = -0.25 } } },

      -- FZFLUA
      { FzfLuaCursorLine = { fg = "NONE" } },
      { FzfLuaFilePart = { fg = { from = "Directory", attr = "fg", alter = 0.2 }, reverse = false } },
      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.5 } } },
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 0.2 } } },
      {
        TelescopeResultsNormal = {
          fg = { from = "FzfLuaDirPart", attr = "fg" },
          bg = { from = "FzfLuaNormal", attr = "bg" },
        },
      },
      {
        TelescopeSelection = {
          fg = { from = "FzfLuaFilePart", attr = "fg" },
          bg = { from = "FzfLuaSel", attr = "bg" },
          bold = true,
        },
      },

      -- SNACKS
      {
        SnacksNotifierError = {
          fg = { from = "ErrorMsg", attr = "fg" },
          bg = { from = "ErrorMsg", attr = "bg" },
          bold = true,
        },
      },
      {
        SnacksNotifierBorderError = {
          fg = { from = "SnacksNotifierError", attr = "bg", alter = 1 },
          bg = { from = "SnacksNotifierError", attr = "bg" },
        },
      },
      {
        SnacksNotifierTitleError = {
          fg = { from = "SnacksNotifierBorderError", attr = "fg", alter = 0.5 },
          bg = { from = "SnacksNotifierError", attr = "bg" },
          bold = true,
        },
      },

      -- GRUG-FAR
      {
        GrugFarResultsLineNo = {
          fg = { from = "LineNr", attr = "fg", alter = 0.5 },
        },
      },
      {
        GrugFarResultsMatch = {
          fg = { from = "CurSearch", attr = "bg", alter = -0.2 },
          bg = { from = "CurSearch", attr = "bg", alter = -0.7 },
          bold = true,
        },
      },

      -- TROUBLE
      {
        TroubleIndent = {
          fg = { from = "LineNr", attr = "fg", alter = 0.1 },
          bg = "NONE",
        },
      },
      {
        TroubleIndentFoldClosed = {
          inherit = "TroubleIndent",
          fg = { from = "TroubleIndent", attr = "fg", alter = 1 },
        },
      },
      { TroubleFsPos = { inherit = "TroubleIndent", fg = { from = "TroubleIndent", attr = "fg", alter = 0.2 } } },

      -- LSP
      {
        LspReferenceText = {
          bg = { from = "Normal", attr = "bg", alter = 0.4 },
          fg = "NONE",
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },
      {
        LspReferenceWrite = {
          bg = { from = "LspReferenceWrite", attr = "bg", alter = 0.4 },
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },
      {
        LspReferenceRead = {
          bg = { from = "LspReferenceRead", attr = "bg", alter = 0.5 },
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },

      -- MARKDOWN
      { RenderMarkdownCode = { bg = { from = "Normal", attr = "bg", alter = 0.8 } } },

      -- STATUSLINE
      {
        StatusLine = {
          fg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.35, Highlight.get("Normal", "bg")),
            -0.2
          ),
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.1, Highlight.get("Normal", "bg")),
            -0.2
          ),
          reverse = false,
        },
      },
      {
        NoiceCmdline = {
          fg = { from = "StatusLine", attr = "fg", alter = 0.8 },
          bg = { from = "StatusLine", attr = "bg" },
        },
      },
      { qfFileName = { fg = { from = "Directory", attr = "fg", alter = 0.3 }, bg = "NONE" } },
      { QuickFixFileName = { fg = { from = "Directory", attr = "fg", alter = 0.4 }, bg = "NONE" } },
      { QuickFixLineNr = { fg = { from = "Normal", attr = "bg", alter = 4 } } },
      {
        QuickFixLine = {
          fg = "NONE",
          bg = { from = "StatusLine", attr = "bg", alter = quickfixline_alter },
          underline = false,
          reverse = false,
        },
      },
      {
        StatusLineNC = {
          fg = { from = "Normal", attr = "bg", alter = 5 },
          bg = { from = "Normal", attr = "bg", alter = 1.4 },
        },
      },
      {
        KeywordBlur = {
          bg = { from = "StatusLineNC", attr = "bg", alter = 0.45 },
        },
      },
      {
        TabLine = {
          fg = { from = "Normal", attr = "bg", alter = 3.8 },
          bg = { from = "Normal", attr = "bg", alter = 0.8 },
        },
      },

      { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.4 } } },
      { StatusLineFilepath = { fg = { from = "StatusLine", attr = "fg", alter = 1 } } },
      { StatusLineFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 1.9 } } },
      { WinbarFilepath = { fg = { from = "LineNr", attr = "fg", alter = 1.2 } } },
      { WinbarFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 2.5 } } },
    },
    ["base46-aylin"] = {
      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = 0.05 }, bold = true } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      { qfFileName = { fg = { from = "Directory", attr = "fg", alter = 0.3 }, bg = "NONE" } },
      { QuickFixFileName = { fg = { from = "Directory", attr = "fg" }, bg = "NONE" } },

      {
        Visual = {
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.3, Highlight.get("Normal", "bg")),
            -0.2
          ),
        },
      },

      { Comment = { fg = { from = "Comment", attr = "fg", alter = 1.3 }, italic = true } },
      { ["@comment"] = { inherit = "Comment" } },

      {
        Folded = {
          inherit = "Folded",
          fg = { from = "Folded", attr = "fg", alter = -0.1 },
          bg = { from = "Folded", attr = "bg", alter = -0.18 },
        },
      },
      { FoldedSign = { fg = { from = "Folded", attr = "fg", alter = -0.4 }, bg = "NONE" } },

      --
      {
        NormalBoxComment = {
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Normal", attr = "bg", alter = 0.2 },
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
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Keyword", attr = "fg", alter = -0.2 },
        },
      },

      -- OUTLINE
      {
        IndentGuides = {
          fg = { from = "LineNr", attr = "fg", alter = -0.15 },
          bg = "NONE",
        },
      },
      {
        IndentGuidesFolded = {
          fg = { from = "LineNr", attr = "fg", alter = 0.2 },
          bg = "NONE",
        },
      },
      {
        OutlineDetails = {
          inherit = "OutlineDetails",
          fg = { from = "OutlineDetails", attr = "fg", alter = 0.2 },
        },
      },

      -- ORGMODE
      { ["@org.comment"] = { inherit = "Comment" } },
      { ["@org.directive"] = { inherit = "Comment" } },
      { ["@org.timestamp.inactive"] = { inherit = "Comment" } },

      -- SNACKS
      { SnacksIndent = { fg = { from = "SnacksIndent", attr = "fg", alter = -0.23 } } },
      { SnacksIndentScope = { fg = { from = "SnacksIndentScope", attr = "fg", alter = -0.3 } } },

      -- FZFLUA
      { FzfLuaFilePart = { fg = { from = "Directory", attr = "fg", alter = -0.2 }, reverse = false } },
      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.45 } } },
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 0.1 } } },
      {
        TelescopeResultsNormal = {
          fg = { from = "FzfLuaFilePart", attr = "fg" },
          bg = { from = "FzfLuaNormal", attr = "bg" },
        },
      },
      {
        TelescopeSelection = {
          fg = { from = "PmenuSel", attr = "fg" },
          bg = { from = "FzfLuaSel", attr = "bg" },
          bold = true,
        },
      },

      -- AVANTE
      {
        AvanteInlineHint = {
          fg = { from = "Keyword", attr = "fg", alter = -0.4 },
          bg = "NONE",
        },
      },

      -- MARKDOWN
      { RenderMarkdownCode = { bg = { from = "Normal", attr = "bg", alter = 0.3 } } },

      -- TROUBLE
      {
        TroubleIndent = {
          inherit = "TroubleIndent",
          fg = { from = "TroubleIndent", attr = "fg", alter = 0.1 },
        },
      },
      { TroubleFsPos = { inherit = "TroubleIndent", fg = { from = "TroubleIndent", attr = "fg", alter = 0.05 } } },

      -- STATUSLINE
      {
        StatusLine = {
          fg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.5, Highlight.get("Normal", "bg")),
            -0.1
          ),
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.18, Highlight.get("Normal", "bg")),
            -0.2
          ),
          reverse = false,
        },
      },
      {
        NoiceCmdline = {
          fg = { from = "StatusLine", attr = "fg", alter = 1 },
          bg = { from = "StatusLine", attr = "bg" },
        },
      },
      { qfFileName = { fg = { from = "Directory", attr = "fg", alter = 0.3 }, bg = "NONE" } },
      { QuickFixFileName = { fg = { from = "Directory", attr = "fg" }, bg = "NONE" } },
      { QuickFixLineNr = { fg = { from = "Normal", attr = "bg", alter = 2.5 } } },
      {
        QuickFixLine = {
          fg = "NONE",
          bg = { from = "StatusLine", attr = "bg", alter = quickfixline_alter },
          underline = false,
          reverse = false,
        },
      },
      {
        StatusLineNC = {
          fg = { from = "Normal", attr = "bg", alter = 2.7 },
          bg = { from = "Normal", attr = "bg", alter = 0.45 },
        },
      },
      {
        KeywordBlur = {
          bg = { from = "StatusLineNC", attr = "bg", alter = 0.4 },
        },
      },
      {
        TabLine = {
          fg = { from = "Normal", attr = "bg", alter = 1.5 },
          bg = { from = "Normal", attr = "bg", alter = 0.25 },
        },
      },

      -- CREATED HIGHLIGHTS
      { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.2 } } },
      { StatusLineFilepath = { fg = { from = "StatusLine", attr = "fg", alter = 0.7 } } },
      { StatusLineFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 1.9 } } },
      { WinbarFilepath = { fg = { from = "LineNr", attr = "fg", alter = 0.7 } } },
      { WinbarFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 2 } } },
    },
    ["base46-chocolate"] = {
      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = 0.05 }, bold = true } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      { qfFileName = { fg = { from = "Directory", attr = "fg", alter = 0.3 }, bg = "NONE" } },
      { QuickFixFileName = { fg = { from = "Directory", attr = "fg" }, bg = "NONE" } },

      {
        Visual = {
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.3, Highlight.get("Normal", "bg")),
            -0.2
          ),
        },
      },

      { Comment = { fg = { from = "Comment", attr = "fg", alter = 1.25 }, italic = true } },
      { ["@comment"] = { inherit = "Comment" } },

      {
        Folded = {
          inherit = "Folded",
          fg = { from = "Folded", attr = "fg", alter = -0.1 },
          bg = { from = "Folded", attr = "bg", alter = -0.15 },
        },
      },
      { FoldedSign = { fg = { from = "Folded", attr = "fg", alter = -0.4 }, bg = "NONE" } },

      --
      {
        NormalBoxComment = {
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Normal", attr = "bg", alter = 0.2 },
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
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Keyword", attr = "fg", alter = -0.2 },
        },
      },

      -- OUTLINE
      {
        IndentGuides = {
          fg = { from = "LineNr", attr = "fg", alter = -0.2 },
          bg = "NONE",
        },
      },
      {
        IndentGuidesFolded = {
          fg = { from = "LineNr", attr = "fg", alter = 0.2 },
          bg = "NONE",
        },
      },
      {
        OutlineDetails = {
          inherit = "OutlineDetails",
          fg = { from = "OutlineDetails", attr = "fg", alter = -0.02 },
        },
      },

      -- ORGMODE
      { ["@org.comment"] = { inherit = "Comment" } },
      { ["@org.directive"] = { inherit = "Comment" } },
      { ["@org.timestamp.inactive"] = { inherit = "Comment" } },

      -- SNACKS
      { SnacksIndent = { fg = { from = "SnacksIndent", attr = "fg", alter = -0.23 } } },
      { SnacksIndentScope = { fg = { from = "SnacksIndentScope", attr = "fg", alter = -0.3 } } },

      -- FZFLUA
      { FzfLuaFilePart = { fg = { from = "Directory", attr = "fg", alter = 0.1 }, reverse = false } },
      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.35 } } },
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = -0.05 } } },
      {
        TelescopeResultsNormal = {
          fg = { from = "FzfLuaFilePart", attr = "fg" },
          bg = { from = "FzfLuaNormal", attr = "bg" },
        },
      },
      {
        TelescopeSelection = {
          fg = { from = "PmenuSel", attr = "fg" },
          bg = { from = "FzfLuaSel", attr = "bg" },
          bold = true,
        },
      },

      -- AVANTE
      {
        AvanteInlineHint = {
          fg = { from = "Keyword", attr = "fg", alter = -0.4 },
          bg = "NONE",
        },
      },

      -- GRUG-FAR
      {
        GrugFarResultsLineNr = {
          fg = { from = "LineNr", attr = "fg", alter = 0.1 },
        },
      },

      -- MARKDOWN
      { RenderMarkdownCode = { bg = { from = "Normal", attr = "bg", alter = 0.4 } } },

      -- TROUBLE
      {
        TroubleIndent = {
          inherit = "TroubleIndent",
          fg = { from = "TroubleIndent", attr = "fg", alter = 0.1 },
        },
      },
      { TroubleFsPos = { inherit = "TroubleIndent", fg = { from = "TroubleIndent", attr = "fg", alter = 0.05 } } },

      -- STATUSLINE
      {
        StatusLineNC = {
          fg = { from = "Normal", attr = "bg", alter = 2.7 },
          bg = { from = "Normal", attr = "bg", alter = 0.45 },
        },
      },
      {
        KeywordBlur = {
          bg = { from = "StatusLineNC", attr = "bg", alter = 0.4 },
        },
      },
      {
        TabLine = {
          fg = { from = "Normal", attr = "bg", alter = 1.5 },
          bg = { from = "Normal", attr = "bg", alter = 0.25 },
        },
      },

      -- CREATED HIGHLIGHTS
      { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.2 } } },
      { StatusLineFilepath = { fg = { from = "StatusLine", attr = "fg", alter = 1 } } },
      { StatusLineFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 2.5 } } },
      { WinbarFilepath = { fg = { from = "LineNr", attr = "fg", alter = 0.58 } } },
      { WinbarFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 1.8 } } },
    },
    ["base46-default-dark"] = {
      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = 0.12 }, bold = true } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      {
        Visual = {
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.3, Highlight.get("Normal", "bg")),
            -0.2
          ),
        },
      },

      { Comment = { fg = { from = "Comment", attr = "fg", alter = 1.3 }, italic = true } },
      { ["@comment"] = { inherit = "Comment" } },

      {
        Folded = {
          inherit = "Folded",
          fg = { from = "Folded", attr = "fg", alter = -0.1 },
          bg = { from = "Folded", attr = "bg", alter = -0.12 },
        },
      },
      { FoldedSign = { fg = { from = "Folded", attr = "fg", alter = -0.4 }, bg = "NONE" } },

      --
      {
        NormalBoxComment = {
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Normal", attr = "bg", alter = 0.2 },
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
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Keyword", attr = "fg", alter = -0.2 },
        },
      },

      -- OUTLINE
      {
        IndentGuides = {
          fg = { from = "LineNr", attr = "fg", alter = -0.1 },
          bg = "NONE",
        },
      },
      {
        IndentGuidesFolded = {
          fg = { from = "LineNr", attr = "fg", alter = 0.2 },
          bg = "NONE",
        },
      },
      {
        OutlineDetails = {
          inherit = "OutlineDetails",
          fg = { from = "OutlineDetails", attr = "fg", alter = 0.15 },
        },
      },

      -- GRUG-FAR
      {
        GrugFarResultsLineNr = {
          fg = { from = "LineNr", attr = "fg", alter = 0.2 },
          bg = { from = "Normal", attr = "bg", alter = 0.2 },
        },
      },

      -- ORGMODE
      { ["@org.comment"] = { inherit = "Comment" } },
      { ["@org.directive"] = { inherit = "Comment" } },
      { ["@org.timestamp.inactive"] = { inherit = "Comment" } },

      -- SNACKS
      { SnacksIndent = { fg = { from = "SnacksIndent", attr = "fg", alter = -0.23 } } },
      { SnacksIndentScope = { fg = { from = "SnacksIndentScope", attr = "fg", alter = -0.3 } } },

      -- FZFLUA
      { FzfLuaFilePart = { fg = { from = "Directory", attr = "fg", alter = -0.2 }, reverse = false } },
      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.48 } } },
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 0.3 } } },
      {
        TelescopeResultsNormal = {
          fg = { from = "FzfLuaFilePart", attr = "fg" },
          bg = { from = "FzfLuaNormal", attr = "bg" },
        },
      },
      {
        TelescopeSelection = {
          fg = { from = "PmenuSel", attr = "fg" },
          bg = { from = "FzfLuaSel", attr = "bg" },
          bold = true,
        },
      },

      -- TROUBLE
      {
        TroubleIndent = {
          inherit = "TroubleIndent",
          fg = { from = "TroubleIndent", attr = "fg", alter = 0.4 },
        },
      },
      { TroubleFsPos = { inherit = "TroubleIndent", fg = { from = "TroubleIndent", attr = "fg", alter = 0.2 } } },

      -- AVANTE
      {
        AvanteInlineHint = {
          fg = { from = "Keyword", attr = "fg", alter = -0.4 },
          bg = "NONE",
        },
      },

      -- MARKDOWN
      { RenderMarkdownCode = { bg = { from = "Normal", attr = "bg", alter = 0.4 } } },

      -- DIFFVIEW
      { DiffviewFilePanelPath = { fg = { from = "StatusLine", attr = "fg", alter = -0.5 } } },

      -- STATUSLINE
      {
        StatusLine = {
          fg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.4, Highlight.get("Normal", "bg")),
            -0.1
          ),
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.2, Highlight.get("Normal", "bg")),
            -0.2
          ),
          reverse = false,
        },
      },
      {
        NoiceCmdline = {
          fg = { from = "StatusLine", attr = "fg", alter = 1 },
          bg = { from = "StatusLine", attr = "bg" },
        },
      },
      { qfFileName = { fg = { from = "Directory", attr = "fg", alter = 0.3 }, bg = "NONE" } },
      { QuickFixFileName = { fg = { from = "Directory", attr = "fg" }, bg = "NONE" } },
      { QuickFixLineNr = { fg = { from = "Normal", attr = "bg", alter = 2.5 } } },
      {
        QuickFixLine = {
          fg = "NONE",
          bg = { from = "StatusLine", attr = "bg", alter = quickfixline_alter },
          underline = false,
          reverse = false,
        },
      },
      {
        StatusLineNC = {
          fg = { from = "Normal", attr = "bg", alter = 2.7 },
          bg = { from = "Normal", attr = "bg", alter = 0.45 },
        },
      },
      {
        KeywordBlur = {
          bg = { from = "StatusLineNC", attr = "bg", alter = 0.4 },
        },
      },
      {
        TabLine = {
          fg = { from = "Normal", attr = "bg", alter = 2 },
          bg = { from = "Normal", attr = "bg", alter = 0.5 },
        },
      },

      -- CREATED HIGHLIGHTS
      { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.2 } } },
      { StatusLineFilepath = { fg = { from = "StatusLine", attr = "fg", alter = 1.2 } } },
      { StatusLineFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 2 } } },
      { WinbarFilepath = { fg = { from = "LineNr", attr = "fg", alter = 1 } } },
      { WinbarFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 2.8 } } },
    },
    ["base46-doomchad"] = {
      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = -0.1 }, bold = true } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      {
        Visual = {
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.3, Highlight.get("Normal", "bg")),
            -0.2
          ),
        },
      },

      { Comment = { fg = { from = "Comment", attr = "fg", alter = 1.3 }, italic = true } },
      { ["@comment"] = { inherit = "Comment" } },

      {
        Folded = {
          inherit = "Folded",
          fg = { from = "Folded", attr = "fg", alter = -0.3 },
          bg = { from = "Folded", attr = "bg", alter = -0.25 },
        },
      },
      { FoldedSign = { fg = { from = "Folded", attr = "fg", alter = -0.4 }, bg = "NONE" } },

      --
      {
        NormalBoxComment = {
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Normal", attr = "bg", alter = 0.2 },
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
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Keyword", attr = "fg", alter = -0.2 },
        },
      },

      -- OUTLINE
      {
        IndentGuides = {
          fg = { from = "LineNr", attr = "fg", alter = -0.05 },
          bg = "NONE",
        },
      },
      {
        IndentGuidesFolded = {
          fg = { from = "LineNr", attr = "fg", alter = 0.2 },
          bg = "NONE",
        },
      },
      {
        OutlineDetails = {
          inherit = "OutlineDetails",
          fg = { from = "OutlineDetails", attr = "fg", alter = 0.2 },
        },
      },

      -- GRUG-FAR
      {
        GrugFarResultsLineNr = {
          fg = { from = "LineNr", attr = "fg", alter = 0.2 },
          bg = { from = "Normal", attr = "bg", alter = 0.2 },
        },
      },

      -- ORGMODE
      { ["@org.comment"] = { inherit = "Comment" } },
      { ["@org.directive"] = { inherit = "Comment" } },
      { ["@org.timestamp.inactive"] = { inherit = "Comment" } },

      -- SNACKS
      { SnacksIndent = { fg = { from = "SnacksIndent", attr = "fg", alter = -0.23 } } },
      { SnacksIndentScope = { fg = { from = "SnacksIndentScope", attr = "fg", alter = -0.3 } } },

      -- FZFLUA
      { FzfLuaFilePart = { fg = { from = "Directory", attr = "fg", alter = -0.15 }, reverse = false } },
      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.5 } } },
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 0.05 } } },
      {
        TelescopeResultsNormal = {
          fg = { from = "FzfLuaFilePart", attr = "fg" },
          bg = { from = "FzfLuaNormal", attr = "bg" },
        },
      },
      {
        TelescopeSelection = {
          fg = { from = "PmenuSel", attr = "fg" },
          bg = { from = "FzfLuaSel", attr = "bg" },
          bold = true,
        },
      },

      -- TROUBLE
      {
        TroubleIndent = {
          inherit = "TroubleIndent",
          fg = { from = "TroubleIndent", attr = "fg", alter = 0.1 },
        },
      },
      { TroubleFsPos = { inherit = "TroubleIndent", fg = { from = "TroubleIndent", attr = "fg", alter = 0.1 } } },

      -- AVANTE
      {
        AvanteInlineHint = {
          fg = { from = "Keyword", attr = "fg", alter = -0.4 },
          bg = "NONE",
        },
      },

      -- MARKDOWN
      { RenderMarkdownCode = { bg = { from = "Normal", attr = "bg", alter = 0.3 } } },

      -- STATUSLINE
      {
        StatusLine = {
          fg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.55, Highlight.get("Normal", "bg")),
            -0.1
          ),
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.15, Highlight.get("Normal", "bg")),
            -0.2
          ),
          reverse = false,
        },
      },
      {
        NoiceCmdline = {
          fg = { from = "StatusLine", attr = "fg", alter = 1 },
          bg = { from = "StatusLine", attr = "bg" },
        },
      },
      { qfFileName = { fg = { from = "Directory", attr = "fg", alter = 0.3 }, bg = "NONE" } },
      { QuickFixFileName = { fg = { from = "Directory", attr = "fg" }, bg = "NONE" } },
      {
        QuickFixLine = {
          fg = "NONE",
          bg = { from = "StatusLine", attr = "bg", alter = quickfixline_alter },
          underline = false,
          reverse = false,
        },
      },
      {
        StatusLineNC = {
          fg = { from = "Normal", attr = "bg", alter = 2.7 },
          bg = { from = "Normal", attr = "bg", alter = 0.45 },
        },
      },
      {
        KeywordBlur = {
          bg = { from = "StatusLineNC", attr = "bg", alter = 0.4 },
        },
      },
      {
        TabLine = {
          fg = { from = "Normal", attr = "bg", alter = 1 },
          bg = { from = "Normal", attr = "bg", alter = 0.2 },
        },
      },

      -- CREATED HIGHLIGHTS
      { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.2 } } },
      { StatusLineFilepath = { fg = { from = "StatusLine", attr = "fg", alter = 0.5 } } },
      { StatusLineFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 1.8 } } },
      { WinbarFilepath = { fg = { from = "LineNr", attr = "fg", alter = 0.5 } } },
      { WinbarFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 3 } } },
    },
    ["base46-jabuti"] = {
      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = -0.1 }, bold = true } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      { qfFileName = { fg = { from = "Directory", attr = "fg", alter = 0.3 }, bg = "NONE" } },
      { QuickFixFileName = { fg = { from = "Directory", attr = "fg" }, bg = "NONE" } },

      {
        Visual = {
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.3, Highlight.get("Normal", "bg")),
            -0.2
          ),
        },
      },

      { Comment = { fg = { from = "Comment", attr = "fg", alter = 1.3 }, italic = true } },
      { ["@comment"] = { inherit = "Comment" } },

      {
        Folded = {
          inherit = "Folded",
          fg = { from = "Folded", attr = "fg", alter = -0.2 },
          bg = { from = "Folded", attr = "bg", alter = -0.22 },
        },
      },
      { FoldedSign = { fg = { from = "Folded", attr = "fg", alter = -0.4 }, bg = "NONE" } },

      --
      {
        NormalBoxComment = {
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Normal", attr = "bg", alter = 0.2 },
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
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Keyword", attr = "fg", alter = -0.2 },
        },
      },

      -- OUTLINE
      {
        IndentGuides = {
          fg = { from = "LineNr", attr = "fg", alter = -0.05 },
          bg = "NONE",
        },
      },
      {
        IndentGuidesFolded = {
          fg = { from = "LineNr", attr = "fg", alter = 0.2 },
          bg = "NONE",
        },
      },
      {
        OutlineDetails = {
          inherit = "OutlineDetails",
          fg = { from = "OutlineDetails", attr = "fg", alter = 0.2 },
        },
      },

      -- ORGMODE
      { ["@org.comment"] = { inherit = "Comment" } },
      { ["@org.directive"] = { inherit = "Comment" } },
      { ["@org.timestamp.inactive"] = { inherit = "Comment" } },

      -- SNACKS
      { SnacksIndent = { fg = { from = "SnacksIndent", attr = "fg", alter = -0.23 } } },
      { SnacksIndentScope = { fg = { from = "SnacksIndentScope", attr = "fg", alter = -0.3 } } },

      -- FZFLUA
      { FzfLuaFilePart = { fg = { from = "Directory", attr = "fg", alter = -0.1 }, reverse = false } },
      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.45 } } },
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 0.1 } } },
      {
        TelescopeResultsNormal = {
          fg = { from = "FzfLuaFilePart", attr = "fg" },
          bg = { from = "FzfLuaNormal", attr = "bg" },
        },
      },
      {
        TelescopeSelection = {
          fg = { from = "PmenuSel", attr = "fg" },
          bg = { from = "FzfLuaSel", attr = "bg" },
          bold = true,
        },
      },

      -- TROUBLE
      {
        TroubleIndent = {
          inherit = "TroubleIndent",
          fg = { from = "TroubleIndent", attr = "fg", alter = 0.2 },
        },
      },
      {
        TroubleIndentFoldClosed = {
          inherit = "TroubleIndent",
          fg = { from = "TroubleIndent", attr = "fg", alter = 0.4 },
        },
      },
      { TroubleFsPos = { inherit = "TroubleIndent", fg = { from = "TroubleIndent", attr = "fg", alter = 0.05 } } },

      -- AVANTE
      {
        AvanteInlineHint = {
          fg = { from = "Keyword", attr = "fg", alter = -0.4 },
          bg = "NONE",
        },
      },

      -- MARKDOWN
      { RenderMarkdownCode = { bg = { from = "Normal", attr = "bg", alter = 0.25 } } },

      -- STATUSLINE
      {
        StatusLine = {
          fg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.65, Highlight.get("Normal", "bg")),
            -0.1
          ),
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.25, Highlight.get("Normal", "bg")),
            -0.2
          ),
          reverse = false,
        },
      },
      {
        NoiceCmdline = {
          fg = { from = "StatusLine", attr = "fg", alter = 1 },
          bg = { from = "StatusLine", attr = "bg" },
        },
      },
      {
        QuickFixLine = {
          fg = "NONE",
          bg = { from = "StatusLine", attr = "bg", alter = quickfixline_alter },
          underline = false,
          reverse = false,
        },
      },
      {
        StatusLineNC = {
          fg = { from = "Normal", attr = "bg", alter = 2.7 },
          bg = { from = "Normal", attr = "bg", alter = 0.45 },
        },
      },
      {
        KeywordBlur = {
          bg = { from = "StatusLineNC", attr = "bg", alter = 0.4 },
        },
      },
      {
        TabLine = {
          fg = { from = "Normal", attr = "bg", alter = 1.2 },
          bg = { from = "Normal", attr = "bg", alter = 0.25 },
        },
      },

      -- CREATED HIGHLIGHTS
      { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.2 } } },
      { StatusLineFilepath = { fg = { from = "StatusLine", attr = "fg", alter = 0.9 } } },
      { StatusLineFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 1.2 } } },
      { WinbarFilepath = { fg = { from = "LineNr", attr = "fg", alter = 0.8 } } },
      { WinbarFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 1 } } },
    },
    ["base46-jellybeans"] = {
      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = 0.2 }, bold = true } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      {
        Visual = {
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.3, Highlight.get("Normal", "bg")),
            -0.2
          ),
        },
      },

      { Comment = { fg = { from = "Comment", attr = "fg", alter = 1.3 }, italic = true } },
      { ["@comment"] = { inherit = "Comment" } },

      {
        Folded = {
          inherit = "Folded",
          fg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.6, Highlight.get("Normal", "bg")),
            -0.52
          ),
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.4, Highlight.get("Normal", "bg")),
            -0.62
          ),
        },
      },
      { FoldedSign = { fg = { from = "Folded", attr = "fg", alter = -0.4 }, bg = "NONE" } },

      --
      {
        NormalBoxComment = {
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Normal", attr = "bg", alter = 0.4 },
        },
      },
      {
        FloatBoxComment = {
          fg = { from = "NormalBoxComment", attr = "bg", alter = 0.4 },
          bg = { from = "NormalBoxComment", attr = "bg" },
        },
      },
      {
        VisualBoxComment = {
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Keyword", attr = "fg", alter = -0.2 },
        },
      },

      -- OUTLINE
      {
        IndentGuides = {
          fg = { from = "LineNr", attr = "fg", alter = 0.1 },
          bg = "NONE",
        },
      },
      {
        IndentGuidesFolded = {
          fg = { from = "LineNr", attr = "fg", alter = 0.3 },
          bg = "NONE",
        },
      },
      {
        OutlineDetails = {
          inherit = "OutlineDetails",
          fg = { from = "OutlineDetails", attr = "fg", alter = 0.1 },
        },
      },

      -- GRUG-FAR
      {
        GrugFarResultsLineNr = {
          fg = { from = "LineNr", attr = "fg", alter = 0.2 },
          bg = { from = "Normal", attr = "bg", alter = 0.2 },
        },
      },

      -- ORGMODE
      { ["@org.comment"] = { inherit = "Comment" } },
      { ["@org.directive"] = { inherit = "Comment" } },
      { ["@org.timestamp.inactive"] = { inherit = "Comment" } },

      -- SNACKS
      { SnacksIndent = { fg = { from = "SnacksIndent", attr = "fg", alter = -0.23 } } },
      { SnacksIndentScope = { fg = { from = "SnacksIndentScope", attr = "fg", alter = -0.3 } } },

      -- FZFLUA
      { FzfLuaFilePart = { fg = { from = "Directory", attr = "fg", alter = -0.1 }, reverse = false } },
      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.48 } } },
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 0.3 } } },
      {
        TelescopeResultsNormal = {
          fg = { from = "FzfLuaFilePart", attr = "fg" },
          bg = { from = "FzfLuaNormal", attr = "bg" },
        },
      },
      {
        TelescopeSelection = {
          fg = { from = "PmenuSel", attr = "fg" },
          bg = { from = "FzfLuaSel", attr = "bg" },
          bold = true,
        },
      },

      -- TROUBLE
      {
        TroubleIndent = {
          inherit = "TroubleIndent",
          fg = { from = "TroubleIndent", attr = "fg", alter = 0.5 },
        },
      },
      {
        TroubleFsPos = {
          inherit = "TroubleIndent",
          fg = { from = "TroubleIndent", attr = "fg", alter = -0.1 },
        },
      },

      -- AVANTE
      {
        AvanteInlineHint = {
          fg = { from = "Keyword", attr = "fg", alter = -0.4 },
          bg = "NONE",
        },
      },

      -- MARKDOWN
      { RenderMarkdownCode = { bg = { from = "Normal", attr = "bg", alter = 0.4 } } },

      -- STATUSLINE
      {
        StatusLine = {
          fg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.5, Highlight.get("Normal", "bg")),
            -0.1
          ),
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.18, Highlight.get("Normal", "bg")),
            -0.2
          ),
          reverse = false,
        },
      },
      {
        NoiceCmdline = {
          fg = { from = "StatusLine", attr = "fg", alter = 1 },
          bg = { from = "StatusLine", attr = "bg" },
        },
      },
      { qfFileName = { fg = { from = "Directory", attr = "fg", alter = 0.3 }, bg = "NONE" } },
      { QuickFixFileName = { fg = { from = "Directory", attr = "fg" }, bg = "NONE" } },
      { QuickFixLineNr = { fg = { from = "Normal", attr = "bg", alter = 2.5 } } },
      {
        QuickFixLine = {
          fg = "NONE",
          bg = { from = "StatusLine", attr = "bg", alter = quickfixline_alter },
          underline = false,
          reverse = false,
        },
      },
      {
        StatusLineNC = {
          fg = { from = "Normal", attr = "bg", alter = 2.7 },
          bg = { from = "Normal", attr = "bg", alter = 0.45 },
        },
      },
      {
        KeywordBlur = {
          bg = { from = "StatusLineNC", attr = "bg", alter = 0.4 },
        },
      },
      {
        TabLine = {
          fg = { from = "Normal", attr = "bg", alter = 2.5 },
          bg = { from = "Normal", attr = "bg", alter = 0.5 },
        },
      },

      -- CREATED HIGHLIGHTS
      { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.2 } } },
      { StatusLineFilepath = { fg = { from = "StatusLine", attr = "fg", alter = 0.8 } } },
      { StatusLineFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 2 } } },
      { WinbarFilepath = { fg = { from = "LineNr", attr = "fg", alter = 1 } } },
      { WinbarFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 4 } } },
    },
    ["base46-kanagawa"] = {
      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = 0.05 }, bold = true } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      { qfFileName = { fg = { from = "Directory", attr = "fg", alter = 0.3 }, bg = "NONE" } },
      { QuickFixFileName = { fg = { from = "Directory", attr = "fg" }, bg = "NONE" } },

      {
        Visual = {
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.35, Highlight.get("Normal", "bg")),
            -0.2
          ),
        },
      },

      { Comment = { fg = { from = "Comment", attr = "fg", alter = 1.3 }, italic = true } },
      { ["@comment"] = { inherit = "Comment" } },

      {
        Folded = {
          fg = { from = "Keyword", attr = "fg", alter = -0.45 },
          bg = { from = "Keyword", attr = "fg", alter = -0.7 },
        },
      },
      { FoldedSign = { fg = { from = "Folded", attr = "fg", alter = -0.4 }, bg = "NONE" } },

      --
      {
        NormalBoxComment = {
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Normal", attr = "bg", alter = 0.2 },
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
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Keyword", attr = "fg", alter = -0.2 },
        },
      },

      -- OUTLINE
      {
        IndentGuides = {
          fg = { from = "LineNr", attr = "fg", alter = -0.05 },
          bg = "NONE",
        },
      },
      {
        IndentGuidesFolded = {
          fg = { from = "LineNr", attr = "fg", alter = 0.25 },
          bg = "NONE",
        },
      },
      {
        OutlineDetails = {
          inherit = "OutlineDetails",
          fg = { from = "OutlineDetails", attr = "fg", alter = 0.1 },
        },
      },

      -- ORGMODE
      { ["@org.comment"] = { inherit = "Comment" } },
      { ["@org.directive"] = { inherit = "Comment" } },
      { ["@org.timestamp.inactive"] = { inherit = "Comment" } },

      -- SNACKS
      { SnacksIndent = { fg = { from = "SnacksIndent", attr = "fg", alter = -0.23 } } },
      { SnacksIndentScope = { fg = { from = "SnacksIndentScope", attr = "fg", alter = -0.3 } } },

      -- FZFLUA
      { FzfLuaFilePart = { fg = { from = "Directory", attr = "fg", alter = -0.05 }, reverse = false } },
      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.5 } } },
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 0.1 } } },
      {
        TelescopeResultsNormal = {
          fg = { from = "FzfLuaFilePart", attr = "fg" },
          bg = { from = "FzfLuaNormal", attr = "bg" },
        },
      },
      {
        TelescopeSelection = {
          fg = { from = "PmenuSel", attr = "fg" },
          bg = { from = "FzfLuaSel", attr = "bg" },
          bold = true,
        },
      },

      -- AVANTE
      {
        AvanteInlineHint = {
          fg = { from = "Keyword", attr = "fg", alter = -0.4 },
          bg = "NONE",
        },
      },

      -- MARKDOWN
      { RenderMarkdownCode = { bg = { from = "Normal", attr = "bg", alter = 0.35 } } },

      -- STATUSLINE
      {
        StatusLine = {
          fg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.6, Highlight.get("Normal", "bg")),
            -0.1
          ),
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.25, Highlight.get("Normal", "bg")),
            -0.2
          ),
          reverse = false,
        },
      },
      {
        NoiceCmdline = {
          fg = { from = "StatusLine", attr = "fg", alter = 1 },
          bg = { from = "StatusLine", attr = "bg" },
        },
      },
      {
        QuickFixLine = {
          fg = "NONE",
          bg = { from = "StatusLine", attr = "bg", alter = quickfixline_alter },
          underline = false,
          reverse = false,
        },
      },
      {
        StatusLineNC = {
          fg = { from = "Normal", attr = "bg", alter = 2.7 },
          bg = { from = "Normal", attr = "bg", alter = 0.45 },
        },
      },
      {
        KeywordBlur = {
          bg = { from = "StatusLineNC", attr = "bg", alter = 0.4 },
        },
      },
      {
        TabLine = {
          fg = { from = "Normal", attr = "bg", alter = 1.8 },
          bg = { from = "Normal", attr = "bg", alter = 0.3 },
        },
      },

      -- CREATED HIGHLIGHTS
      { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.2 } } },
      { StatusLineFilepath = { fg = { from = "StatusLine", attr = "fg", alter = 1 } } },
      { StatusLineFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 2 } } },
      { WinbarFilepath = { fg = { from = "LineNr", attr = "fg", alter = 0.7 } } },
      { WinbarFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 3.5 } } },
    },
    ["base46-material-darker"] = {
      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = 0.1 }, bold = true } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      { qfFileName = { fg = { from = "Directory", attr = "fg", alter = 0.3 }, bg = "NONE" } },
      { QuickFixFileName = { fg = { from = "Directory", attr = "fg" }, bg = "NONE" } },

      {
        Visual = {
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.3, Highlight.get("Normal", "bg")),
            -0.1
          ),
        },
      },

      { Comment = { fg = { from = "Comment", attr = "fg", alter = 1.2 }, italic = true } },
      { ["@comment"] = { inherit = "Comment" } },

      {
        Folded = {
          inherit = "Folded",
          fg = { from = "Folded", attr = "fg", alter = -0.1 },
          bg = { from = "Folded", attr = "bg", alter = -0.18 },
        },
      },
      { FoldedSign = { fg = { from = "Folded", attr = "fg", alter = -0.4 }, bg = "NONE" } },

      --
      {
        NormalBoxComment = {
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Normal", attr = "bg", alter = 0.2 },
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
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Keyword", attr = "fg", alter = -0.2 },
        },
      },

      -- OUTLINE
      {
        IndentGuides = {
          fg = { from = "LineNr", attr = "fg", alter = -0.15 },
          bg = "NONE",
        },
      },
      {
        IndentGuidesFolded = {
          fg = { from = "LineNr", attr = "fg", alter = 0.3 },
          bg = "NONE",
        },
      },
      {
        OutlineDetails = {
          inherit = "OutlineDetails",
          fg = { from = "OutlineDetails", attr = "fg", alter = 0.2 },
        },
      },

      -- ORGMODE
      { ["@org.comment"] = { inherit = "Comment" } },
      { ["@org.directive"] = { inherit = "Comment" } },
      { ["@org.timestamp.inactive"] = { inherit = "Comment" } },

      -- SNACKS
      { SnacksIndent = { fg = { from = "SnacksIndent", attr = "fg", alter = -0.23 } } },
      { SnacksIndentScope = { fg = { from = "SnacksIndentScope", attr = "fg", alter = -0.3 } } },

      -- FZFLUA
      { FzfLuaFilePart = { fg = { from = "Directory", attr = "fg", alter = -0.15 }, reverse = false } },
      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.5 } } },
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = -0.05 } } },
      {
        TelescopeResultsNormal = {
          fg = { from = "FzfLuaFilePart", attr = "fg" },
          bg = { from = "FzfLuaNormal", attr = "bg" },
        },
      },
      {
        TelescopeSelection = {
          fg = { from = "PmenuSel", attr = "fg" },
          bg = { from = "FzfLuaSel", attr = "bg" },
          bold = true,
        },
      },

      -- TROUBLE
      {
        TroubleIndent = {
          inherit = "TroubleIndent",
          fg = { from = "TroubleIndent", attr = "fg", alter = 0.15 },
        },
      },
      { TroubleFsPos = { inherit = "TroubleIndent", fg = { from = "TroubleIndent", attr = "fg", alter = 0.1 } } },

      -- AVANTE
      {
        AvanteInlineHint = {
          fg = { from = "Keyword", attr = "fg", alter = -0.4 },
          bg = "NONE",
        },
      },

      -- MARKDOWN
      { RenderMarkdownCode = { bg = { from = "Normal", attr = "bg", alter = 0.35 } } },

      -- STATUSLINE
      {
        StatusLine = {
          fg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.5, Highlight.get("Normal", "bg")),
            -0.1
          ),
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.2, Highlight.get("Normal", "bg")),
            -0.2
          ),
          reverse = false,
        },
      },
      {
        NoiceCmdline = {
          fg = { from = "StatusLine", attr = "fg", alter = 1 },
          bg = { from = "StatusLine", attr = "bg" },
        },
      },
      {
        QuickFixLine = {
          fg = "NONE",
          bg = { from = "StatusLine", attr = "bg", alter = quickfixline_alter },
          underline = false,
          reverse = false,
        },
      },
      {
        StatusLineNC = {
          fg = { from = "Normal", attr = "bg", alter = 2.7 },
          bg = { from = "Normal", attr = "bg", alter = 0.45 },
        },
      },
      {
        KeywordBlur = {
          bg = { from = "StatusLineNC", attr = "bg", alter = 0.4 },
        },
      },
      {
        TabLine = {
          fg = { from = "Normal", attr = "bg", alter = 1.5 },
          bg = { from = "Normal", attr = "bg", alter = 0.3 },
        },
      },

      -- CREATED HIGHLIGHTS
      { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.2 } } },
      { StatusLineFilepath = { fg = { from = "StatusLine", attr = "fg", alter = 0.8 } } },
      { StatusLineFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 2 } } },
      { WinbarFilepath = { fg = { from = "LineNr", attr = "fg", alter = 0.7 } } },
      { WinbarFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 3.5 } } },
    },
    ["base46-onenord"] = {
      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = -0.2 }, bold = true } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      { qfFileName = { fg = { from = "Directory", attr = "fg", alter = 0.3 }, bg = "NONE" } },
      { QuickFixFileName = { fg = { from = "Directory", attr = "fg" }, bg = "NONE" } },

      {
        Visual = {
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.3, Highlight.get("Normal", "bg")),
            -0.2
          ),
        },
      },

      { Comment = { fg = { from = "Comment", attr = "fg", alter = 1.3 }, italic = true } },
      { ["@comment"] = { inherit = "Comment" } },

      {
        Folded = {
          inherit = "Folded",
          fg = { from = "Folded", attr = "fg", alter = -0.2 },
          bg = { from = "Folded", attr = "bg", alter = -0.2 },
        },
      },
      { FoldedSign = { fg = { from = "Folded", attr = "fg", alter = -0.4 }, bg = "NONE" } },

      --
      {
        NormalBoxComment = {
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Normal", attr = "bg", alter = 0.2 },
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
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Keyword", attr = "fg", alter = -0.2 },
        },
      },

      -- OUTLINE
      {
        IndentGuides = {
          fg = { from = "LineNr", attr = "fg", alter = -0.05 },
          bg = "NONE",
        },
      },
      {
        IndentGuidesFolded = {
          fg = { from = "LineNr", attr = "fg", alter = 0.25 },
          bg = "NONE",
        },
      },
      {
        OutlineDetails = {
          inherit = "OutlineDetails",
          fg = { from = "OutlineDetails", attr = "fg", alter = 0.2 },
        },
      },

      -- ORGMODE
      { ["@org.comment"] = { inherit = "Comment" } },
      { ["@org.directive"] = { inherit = "Comment" } },
      { ["@org.timestamp.inactive"] = { inherit = "Comment" } },

      -- SNACKS
      { SnacksIndent = { fg = { from = "SnacksIndent", attr = "fg", alter = -0.23 } } },
      { SnacksIndentScope = { fg = { from = "SnacksIndentScope", attr = "fg", alter = -0.3 } } },

      -- FZFLUA
      { FzfLuaFilePart = { fg = { from = "Directory", attr = "fg", alter = -0.12 }, reverse = false } },
      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.45 } } },
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 0.05 } } },
      {
        TelescopeResultsNormal = {
          fg = { from = "FzfLuaFilePart", attr = "fg" },
          bg = { from = "FzfLuaNormal", attr = "bg" },
        },
      },
      {
        TelescopeSelection = {
          fg = { from = "PmenuSel", attr = "fg" },
          bg = { from = "FzfLuaSel", attr = "bg" },
          bold = true,
        },
      },

      -- TROUBLE
      {
        TroubleIndent = {
          inherit = "TroubleIndent",
          fg = { from = "TroubleIndent", attr = "fg", alter = -0.05 },
        },
      },
      { TroubleFsPos = { inherit = "TroubleIndent", fg = { from = "TroubleIndent", attr = "fg", alter = 0.05 } } },

      -- AVANTE
      {
        AvanteInlineHint = {
          fg = { from = "Keyword", attr = "fg", alter = -0.4 },
          bg = "NONE",
        },
      },

      -- MARKDOWN
      { RenderMarkdownCode = { bg = { from = "Normal", attr = "bg", alter = 0.3 } } },

      -- STATUSLINE
      {
        StatusLineNC = {
          fg = { from = "Normal", attr = "bg", alter = 2.7 },
          bg = { from = "Normal", attr = "bg", alter = 0.45 },
        },
      },
      {
        KeywordBlur = {
          bg = { from = "StatusLineNC", attr = "bg", alter = 0.4 },
        },
      },
      {
        TabLine = {
          fg = { from = "Normal", attr = "bg", alter = 1 },
          bg = { from = "Normal", attr = "bg", alter = 0.26 },
        },
      },

      -- CREATED HIGHLIGHTS
      { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.2 } } },
      { StatusLineFilepath = { fg = { from = "StatusLine", attr = "fg", alter = 0.8 } } },
      { StatusLineFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 2 } } },
      { WinbarFilepath = { fg = { from = "LineNr", attr = "fg", alter = 0.8 } } },
      { WinbarFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 3.5 } } },
    },
    ["base46-seoul256_dark"] = {
      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = -0.22 }, bold = true } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      { qfFileName = { fg = { from = "Directory", attr = "fg", alter = 0.3 }, bg = "NONE" } },
      { QuickFixFileName = { fg = { from = "Directory", attr = "fg" }, bg = "NONE" } },

      {
        Visual = {
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.3, Highlight.get("Normal", "bg")),
            -0.2
          ),
        },
      },

      { Comment = { fg = { from = "Comment", attr = "fg", alter = 1.3 }, italic = true } },
      { ["@comment"] = { inherit = "Comment" } },

      {
        Folded = {
          inherit = "Folded",
          fg = { from = "Folded", attr = "fg", alter = -0.4 },
          bg = { from = "Folded", attr = "bg", alter = -0.3 },
        },
      },
      { FoldedSign = { fg = { from = "Folded", attr = "fg", alter = -0.4 }, bg = "NONE" } },

      --
      {
        NormalBoxComment = {
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Normal", attr = "bg", alter = 0.2 },
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
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Keyword", attr = "fg", alter = -0.2 },
        },
      },

      -- OUTLINE
      {
        IndentGuides = {
          fg = { from = "LineNr", attr = "fg", alter = -0.05 },
          bg = "NONE",
        },
      },
      {
        IndentGuidesFolded = {
          fg = { from = "LineNr", attr = "fg", alter = 0.2 },
          bg = "NONE",
        },
      },
      {
        OutlineDetails = {
          inherit = "OutlineDetails",
          fg = { from = "OutlineDetails", attr = "fg", alter = 0.25 },
        },
      },

      -- GRUG-FAR
      {
        GrugFarResultsLineNr = {
          fg = { from = "LineNr", attr = "fg", alter = 0.2 },
          bg = { from = "Normal", attr = "bg", alter = 0.2 },
        },
      },

      -- ORGMODE
      { ["@org.comment"] = { inherit = "Comment" } },
      { ["@org.directive"] = { inherit = "Comment" } },
      { ["@org.timestamp.inactive"] = { inherit = "Comment" } },

      -- SNACKS
      { SnacksIndent = { fg = { from = "SnacksIndent", attr = "fg", alter = -0.23 } } },
      { SnacksIndentScope = { fg = { from = "SnacksIndentScope", attr = "fg", alter = -0.2 } } },

      -- FZFLUA
      { FzfLuaFilePart = { fg = { from = "Directory", attr = "fg", alter = -0.1 }, reverse = false } },
      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.4 } } },
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = -0.05 } } },
      {
        TelescopeResultsNormal = {
          fg = { from = "FzfLuaFilePart", attr = "fg" },
          bg = { from = "FzfLuaNormal", attr = "bg" },
        },
      },
      {
        TelescopeSelection = {
          fg = { from = "PmenuSel", attr = "fg" },
          bg = { from = "FzfLuaSel", attr = "bg" },
          bold = true,
        },
      },

      -- TROUBLE
      {
        TroubleIndent = {
          inherit = "TroubleIndent",
          fg = { from = "TroubleIndent", attr = "fg", alter = -0.12 },
        },
      },
      { TroubleFsPos = { inherit = "TroubleIndent", fg = { from = "TroubleIndent", attr = "fg", alter = 0.05 } } },

      -- AVANTE
      {
        AvanteInlineHint = {
          fg = { from = "Keyword", attr = "fg", alter = -0.4 },
          bg = "NONE",
        },
      },

      -- STATUSLINE
      {
        StatusLineNC = {
          fg = { from = "Normal", attr = "bg", alter = 0.4 },
          bg = { from = "Normal", attr = "bg", alter = 0.45 },
        },
      },
      {
        KeywordBlur = {
          bg = { from = "StatusLineNC", attr = "bg", alter = 0.4 },
        },
      },
      {
        TabLine = {
          fg = { from = "Normal", attr = "bg", alter = 0.8 },
          bg = { from = "Normal", attr = "bg", alter = 0.18 },
        },
      },

      -- CREATED HIGHLIGHTS
      { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.2 } } },
      { StatusLineFilepath = { fg = { from = "StatusLine", attr = "fg", alter = 0.5 } } },
      { StatusLineFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 2 } } },
      { WinbarFilepath = { fg = { from = "LineNr", attr = "fg", alter = 0.4 } } },
      { WinbarFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 3.5 } } },
    },
    ["base46-solarized_dark"] = {
      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = -0.15 }, bold = true } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      {
        Visual = {
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.4, Highlight.get("Normal", "bg")),
            -0.2
          ),
        },
      },

      { Comment = { fg = { from = "Comment", attr = "fg", alter = 1.3 }, italic = true } },
      { ["@comment"] = { inherit = "Comment" } },

      {
        Folded = {
          fg = { from = "Normal", attr = "bg", alter = 1.5 },
          bg = { from = "Normal", attr = "bg", alter = 0.3 },
        },
      },
      { FoldedSign = { fg = { from = "Folded", attr = "fg", alter = -0.4 }, bg = "NONE" } },

      --
      {
        NormalBoxComment = {
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Normal", attr = "bg", alter = 0.2 },
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
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Keyword", attr = "fg", alter = -0.2 },
        },
      },

      -- OUTLINE
      {
        IndentGuides = {
          fg = { from = "LineNr", attr = "fg", alter = 0.05 },
          bg = "NONE",
        },
      },
      {
        IndentGuidesFolded = {
          fg = { from = "LineNr", attr = "fg", alter = 0.28 },
          bg = "NONE",
        },
      },
      {
        OutlineDetails = {
          inherit = "OutlineDetails",
          fg = { from = "OutlineDetails", attr = "fg", alter = 0.1 },
        },
      },

      -- ORGMODE
      { ["@org.comment"] = { inherit = "Comment" } },
      { ["@org.directive"] = { inherit = "Comment" } },
      { ["@org.timestamp.inactive"] = { inherit = "Comment" } },

      -- SNACKS
      { SnacksIndent = { fg = { from = "SnacksIndent", attr = "fg", alter = -0.23 } } },
      { SnacksIndentScope = { fg = { from = "SnacksIndentScope", attr = "fg", alter = -0.3 } } },

      -- FZFLUA
      { FzfLuaFilePart = { fg = { from = "Directory", attr = "fg", alter = -0.05 }, reverse = false } },
      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.5 } } },
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 0.1 } } },
      {
        TelescopeResultsNormal = {
          fg = { from = "FzfLuaFilePart", attr = "fg" },
          bg = { from = "FzfLuaNormal", attr = "bg" },
        },
      },
      {
        TelescopeSelection = {
          fg = { from = "PmenuSel", attr = "fg" },
          bg = { from = "FzfLuaSel", attr = "bg" },
          bold = true,
        },
      },

      -- TROUBLE
      {
        TroubleIndent = {
          inherit = "TroubleIndent",
          fg = { from = "TroubleIndent", attr = "fg", alter = 0.1 },
        },
      },
      { TroubleFsPos = { inherit = "TroubleIndent", fg = { from = "TroubleIndent", attr = "fg", alter = -0.05 } } },

      -- AVANTE
      {
        AvanteInlineHint = {
          fg = { from = "Keyword", attr = "fg", alter = -0.4 },
          bg = "NONE",
        },
      },

      -- MARKDOWN
      { RenderMarkdownCode = { bg = { from = "Normal", attr = "bg", alter = 0.25 } } },

      -- STATUSLINE
      {
        StatusLine = {
          fg = { from = "Normal", attr = "bg", alter = 1.4 },
          bg = { from = "Normal", attr = "bg", alter = 0.25 },
          reverse = false,
        },
      },
      {
        NoiceCmdline = {
          fg = { from = "StatusLine", attr = "fg", alter = 1 },
          bg = { from = "StatusLine", attr = "bg" },
        },
      },
      { qfFileName = { fg = { from = "Directory", attr = "fg", alter = 0.3 }, bg = "NONE" } },
      { QuickFixFileName = { fg = { from = "Directory", attr = "fg" }, bg = "NONE" } },
      {
        QuickFixLine = {
          fg = "NONE",
          bg = { from = "StatusLine", attr = "bg", alter = quickfixline_alter },
          underline = false,
          reverse = false,
        },
      },
      {
        StatusLineNC = {
          fg = { from = "Normal", attr = "bg", alter = 2.7 },
          bg = { from = "Normal", attr = "bg", alter = 0.45 },
        },
      },
      {
        KeywordBlur = {
          bg = { from = "StatusLineNC", attr = "bg", alter = 0.4 },
        },
      },
      {
        TabLine = {
          fg = { from = "Normal", attr = "bg", alter = 1 },
          bg = { from = "Normal", attr = "bg", alter = 0.2 },
        },
      },

      -- CREATED HIGHLIGHTS
      { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.2 } } },
      { StatusLineFilepath = { fg = { from = "StatusLine", attr = "fg", alter = 1 } } },
      { StatusLineFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 2 } } },
      { WinbarFilepath = { fg = { from = "LineNr", attr = "fg", alter = 0.65 } } },
      { WinbarFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 1.8 } } },
    },
    ["base46-zenburn"] = {
      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = -0.18 }, bold = true } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      { qfFileName = { fg = { from = "Directory", attr = "fg", alter = 0.3 }, bg = "NONE" } },
      { QuickFixFileName = { fg = { from = "Directory", attr = "fg" }, bg = "NONE" } },

      {
        Visual = {
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.3, Highlight.get("Normal", "bg")),
            -0.2
          ),
        },
      },

      { Comment = { fg = { from = "Comment", attr = "fg", alter = 1.3 }, italic = true } },
      { ["@comment"] = { inherit = "Comment" } },

      {
        Folded = {
          inherit = "Folded",
          fg = { from = "Folded", attr = "fg", alter = -0.35 },
          bg = { from = "Folded", attr = "bg", alter = -0.28 },
        },
      },
      { FoldedSign = { fg = { from = "Folded", attr = "fg", alter = -0.4 }, bg = "NONE" } },

      --
      {
        NormalBoxComment = {
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Normal", attr = "bg", alter = 0.2 },
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
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Keyword", attr = "fg", alter = -0.2 },
        },
      },

      -- OUTLINE
      {
        IndentGuides = {
          fg = { from = "LineNr", attr = "fg", alter = -0.05 },
          bg = "NONE",
        },
      },
      {
        IndentGuidesFolded = {
          fg = { from = "LineNr", attr = "fg", alter = 0.25 },
          bg = "NONE",
        },
      },
      {
        OutlineDetails = {
          inherit = "OutlineDetails",
          fg = { from = "OutlineDetails", attr = "fg", alter = 0.25 },
        },
      },

      -- GRUG-FAR
      {
        GrugFarResultsLineNr = {
          fg = { from = "LineNr", attr = "fg", alter = 0.2 },
          bg = { from = "Normal", attr = "bg", alter = 0.2 },
        },
      },

      -- ORGMODE
      { ["@org.comment"] = { inherit = "Comment" } },
      { ["@org.directive"] = { inherit = "Comment" } },
      { ["@org.timestamp.inactive"] = { inherit = "Comment" } },

      -- SNACKS
      { SnacksIndent = { fg = { from = "SnacksIndent", attr = "fg", alter = -0.23 } } },
      { SnacksIndentScope = { fg = { from = "SnacksIndentScope", attr = "fg", alter = -0.3 } } },

      -- FZFLUA
      { FzfLuaFilePart = { fg = { from = "Directory", attr = "fg", alter = -0.2 }, reverse = false } },
      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.45 } } },
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 0.05 } } },
      {
        TelescopeResultsNormal = {
          fg = { from = "FzfLuaFilePart", attr = "fg" },
          bg = { from = "FzfLuaNormal", attr = "bg" },
        },
      },
      {
        TelescopeSelection = {
          fg = { from = "PmenuSel", attr = "fg" },
          bg = { from = "FzfLuaSel", attr = "bg" },
          bold = true,
        },
      },

      -- TROUBLE
      {
        TroubleIndent = {
          inherit = "TroubleIndent",
          fg = { from = "TroubleIndent", attr = "fg", alter = 0.05 },
        },
      },
      { TroubleFsPos = { inherit = "TroubleIndent", fg = { from = "TroubleIndent", attr = "fg", alter = -0.05 } } },

      -- AVANTE
      {
        AvanteInlineHint = {
          fg = { from = "Keyword", attr = "fg", alter = -0.4 },
          bg = "NONE",
        },
      },

      -- STATUSLINE
      {
        StatusLineNC = {
          fg = { from = "Normal", attr = "bg", alter = 2.7 },
          bg = { from = "Normal", attr = "bg", alter = 0.45 },
        },
      },
      {
        KeywordBlur = {
          bg = { from = "StatusLineNC", attr = "bg", alter = 0.4 },
        },
      },
      {
        TabLine = {
          fg = { from = "Normal", attr = "bg", alter = 1 },
          bg = { from = "Normal", attr = "bg", alter = 0.23 },
        },
      },

      -- CREATED HIGHLIGHTS
      { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.2 } } },
      { StatusLineFilepath = { fg = { from = "StatusLine", attr = "fg", alter = 0.9 } } },
      { StatusLineFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 1.5 } } },
      { WinbarFilepath = { fg = { from = "LineNr", attr = "fg", alter = 0.65 } } },
      { WinbarFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 1.2 } } },
    },
    ["catppuccin-mocha"] = {
      { Comment = { fg = { from = "Normal", attr = "bg", alter = 1.8 }, italic = true } },
      { ["@comment"] = { inherit = "Comment" } },

      { Visual = { bg = { from = "Visual", attr = "bg", alter = -0.27 } } },

      { LineNr = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 0.6 }, bold = true } },

      {
        Folded = {
          fg = { from = "Keyword", attr = "fg", alter = -0.65 },
          bg = { from = "Keyword", attr = "fg", alter = -0.77 },
        },
      },
      { FoldedSign = { fg = { from = "Folded", attr = "fg", alter = -0.4 }, bg = "NONE" } },

      --
      {
        NormalBoxComment = {
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Normal", attr = "bg", alter = 0.4 },
        },
      },
      {
        FloatBoxComment = {
          fg = { from = "NormalBoxComment", attr = "bg", alter = 0.4 },
          bg = { from = "NormalBoxComment", attr = "bg" },
        },
      },
      {
        VisualBoxComment = {
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Keyword", attr = "fg", alter = -0.2 },
        },
      },

      -- ORGMODE
      { ["@org.comment"] = { inherit = "Comment" } },
      { ["@org.directive"] = { inherit = "Comment" } },
      { ["@org.timestamp.inactive"] = { inherit = "Comment" } },

      -- FZFLUA
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 0.25 } } },

      -- OUTLINE
      {
        IndentGuides = {
          fg = { from = "LineNr", attr = "fg", alter = 0.15 },
          bg = "NONE",
        },
      },
      {
        IndentGuidesFolded = {
          fg = { from = "LineNr", attr = "fg", alter = 0.8 },
          bg = "NONE",
        },
      },
      {
        OutlineDetails = {
          inherit = "OutlineDetails",
          fg = { from = "OutlineDetails", attr = "fg", alter = -0.4 },
        },
      },

      -- SNACKS
      { SnacksIndent = { fg = { from = "SnacksIndent", attr = "fg", alter = -0.32 } } },
      { SnacksIndentScope = { fg = { from = "SnacksIndentScope", attr = "fg", alter = -0.4 } } },

      -- TROUBLE
      {
        TroubleIndent = {
          inherit = "TroubleIndent",
          fg = { from = "TroubleIndent", attr = "fg", alter = 0.2 },
        },
      },
      { TroubleFsPos = { inherit = "TroubleIndent", fg = { from = "TroubleIndent", attr = "fg", alter = 0.05 } } },

      -- AVANTE
      {
        AvanteInlineHint = {
          fg = { from = "Keyword", attr = "fg", alter = -0.45 },
          bg = "NONE",
        },
      },

      -- LSP
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

      -- MARKDOWN
      { RenderMarkdownCode = { bg = { from = "Normal", attr = "bg", alter = 0.3 } } },

      -- STATUSLINE
      {
        StatusLine = {
          fg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.53, Highlight.get("Normal", "bg")),
            -0.1
          ),
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.25, Highlight.get("Normal", "bg")),
            -0.2
          ),
          reverse = false,
        },
      },
      {
        NoiceCmdline = {
          fg = { from = "StatusLine", attr = "fg", alter = 1 },
          bg = { from = "StatusLine", attr = "bg" },
        },
      },
      { qfFileName = { fg = { from = "Directory", attr = "fg", alter = 0.3 }, bg = "NONE" } },
      { QuickFixFileName = { fg = { from = "Directory", attr = "fg" }, bg = "NONE" } },
      { QuickFixLineNr = { fg = { from = "Normal", attr = "bg", alter = 2 } } },
      {
        QuickFixLine = {
          fg = "NONE",
          bg = { from = "StatusLine", attr = "bg", alter = quickfixline_alter },
          underline = false,
          reverse = false,
        },
      },
      {
        StatusLineNC = {
          fg = { from = "Normal", attr = "bg", alter = 3.5 },
          bg = { from = "Normal", attr = "bg", alter = 0.6 },
        },
      },
      {
        KeywordBlur = {
          bg = { from = "StatusLineNC", attr = "bg", alter = 0.4 },
        },
      },
      {
        TabLine = {
          fg = { from = "Normal", attr = "bg", alter = 1.5 },
          bg = { from = "Normal", attr = "bg", alter = 0.28 },
        },
      },

      -- CREATED HIGHLIGHTS
      { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.2 } } },
      { StatusLineFilepath = { fg = { from = "StatusLine", attr = "fg", alter = 0.5 } } },
      { StatusLineFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 1.1 } } },
      { WinbarFilepath = { fg = { from = "LineNr", attr = "fg", alter = 1 } } },
      { WinbarFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 3.5 } } },
    },
    ["darkearth"] = {
      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = -0.1 }, bold = true } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      { qfFileName = { fg = { from = "Directory", attr = "fg", alter = 0.3 }, bg = "NONE" } },
      { QuickFixFileName = { fg = { from = "Directory", attr = "fg" }, bg = "NONE" } },

      {
        Visual = {
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.3, Highlight.get("Normal", "bg")),
            -0.2
          ),
        },
      },

      { Comment = { fg = { from = "Comment", attr = "fg", alter = 0.6 }, italic = true } },
      { ["@comment"] = { inherit = "Comment" } },

      {
        Folded = {
          fg = { from = "Normal", attr = "bg", alter = 1. },
          bg = { from = "Normal", attr = "bg", alter = 0.35 },
        },
      },
      { FoldedSign = { fg = { from = "Folded", attr = "fg", alter = -0.4 }, bg = "NONE" } },

      --
      {
        NormalBoxComment = {
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Normal", attr = "bg", alter = 0.2 },
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
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Keyword", attr = "fg", alter = -0.2 },
        },
      },

      -- OUTLINE
      {
        IndentGuides = {
          fg = { from = "LineNr", attr = "fg", alter = 0.15 },
          bg = "NONE",
        },
      },
      {
        IndentGuidesFolded = {
          fg = { from = "LineNr", attr = "fg", alter = 0.3 },
          bg = "NONE",
        },
      },
      {
        OutlineDetails = {
          inherit = "OutlineDetails",
          fg = { from = "OutlineDetails", attr = "fg", alter = -0.2 },
        },
      },

      -- ORGMODE
      { ["@org.comment"] = { inherit = "Comment" } },
      { ["@org.directive"] = { inherit = "Comment" } },
      { ["@org.timestamp.inactive"] = { inherit = "Comment" } },

      -- SNACKS
      { SnacksIndent = { fg = { from = "SnacksIndent", attr = "fg", alter = -0.23 } } },
      { SnacksIndentScope = { fg = { from = "SnacksIndentScope", attr = "fg", alter = -0.3 } } },

      -- FZFLUA
      { FzfLuaFilePart = { fg = { from = "Directory", attr = "fg", alter = -0.1 }, reverse = false } },
      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.45 } } },
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 0.15 } } },
      {
        TelescopeResultsNormal = {
          fg = { from = "FzfLuaFilePart", attr = "fg" },
          bg = { from = "FzfLuaNormal", attr = "bg" },
        },
      },
      {
        TelescopeSelection = {
          fg = { from = "PmenuSel", attr = "fg" },
          bg = { from = "FzfLuaSel", attr = "bg" },
          bold = true,
        },
      },

      -- MARKDOWN
      { RenderMarkdownCode = { bg = { from = "Normal", attr = "bg", alter = 0.4 } } },

      -- AVANTE
      {
        AvanteInlineHint = {
          fg = { from = "Keyword", attr = "fg", alter = -0.35 },
          bg = "NONE",
        },
      },

      -- TROUBLE
      {
        TroubleIndent = {
          inherit = "TroubleIndent",
          fg = { from = "TroubleIndent", attr = "fg", alter = 0.18 },
        },
      },
      { TroubleFsPos = { inherit = "TroubleIndent", fg = { from = "TroubleIndent", attr = "fg", alter = -0.14 } } },

      -- STATUSLINE
      {
        StatusLineNC = {
          fg = { from = "Normal", attr = "bg", alter = 2.7 },
          bg = { from = "Normal", attr = "bg", alter = 0.45 },
        },
      },
      {
        KeywordBlur = {
          bg = { from = "StatusLineNC", attr = "bg", alter = 0.4 },
        },
      },
      {
        TabLine = {
          fg = { from = "Normal", attr = "bg", alter = 1.1 },
          bg = { from = "Normal", attr = "bg", alter = 0.3 },
        },
      },

      -- CREATED HIGHLIGHTS
      { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.2 } } },
      { StatusLineFilepath = { fg = { from = "StatusLine", attr = "fg", alter = 0.5 } } },
      { StatusLineFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 2 } } },
      { WinbarFilepath = { fg = { from = "LineNr", attr = "fg", alter = 0.8 } } },
      { WinbarFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 2 } } },
    },
    ["horizon"] = {
      { Directory = { fg = { from = "@annotation", attr = "fg", alter = 0.2 }, bg = "NONE" } },

      { Comment = { fg = { from = "Comment", attr = "fg", alter = 2 }, italic = true } },
      { ["@comment"] = { inherit = "Comment" } },

      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = -0.12 }, bold = true } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },
      { PmenuThumb = { bg = { from = "FloatBorder", attr = "fg", alter = 0.3 } } },

      {
        Folded = {
          fg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.42, Highlight.get("Normal", "bg")),
            -0.1
          ),
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.18, Highlight.get("Normal", "bg")),
            -0.2
          ),
        },
      },
      { FoldedSign = { fg = { from = "Folded", attr = "fg", alter = -0.4 }, bg = "NONE" } },

      { qfFileName = { fg = { from = "Directory", attr = "fg", alter = 0.3 }, bg = "NONE" } },
      { QuickFixFileName = { fg = { from = "Directory", attr = "fg" }, bg = "NONE" } },

      { Visual = { bg = { from = "Visual", attr = "bg", alter = -0.1 } } },

      --
      {
        NormalBoxComment = {
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Normal", attr = "bg", alter = 0.4 },
        },
      },
      {
        FloatBoxComment = {
          fg = { from = "NormalBoxComment", attr = "bg", alter = 0.4 },
          bg = { from = "NormalBoxComment", attr = "bg" },
        },
      },
      {
        VisualBoxComment = {
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Keyword", attr = "fg", alter = -0.2 },
        },
      },

      -- OUTLINE
      {
        IndentGuides = {
          fg = { from = "Normal", attr = "bg", alter = 1 },
          bg = "NONE",
        },
      },
      {
        IndentGuidesFolded = {
          fg = { from = "Normal", attr = "bg", alter = 1.8 },
          bg = "NONE",
        },
      },
      {
        OutlineDetails = {
          inherit = "OutlineDetails",
          fg = { from = "OutlineDetails", attr = "fg", alter = 0.15 },
        },
      },

      -- ORGMODE
      { ["@org.comment"] = { inherit = "Comment" } },
      { ["@org.directive"] = { inherit = "Comment" } },
      { ["@org.timestamp.inactive"] = { inherit = "Comment" } },

      -- SNACKS
      { SnacksIndent = { fg = { from = "SnacksIndent", attr = "fg", alter = -0.23 } } },
      { SnacksIndentScope = { fg = { from = "SnacksIndentScope", attr = "fg", alter = -0.3 } } },

      -- FZFLUA
      { FzfLuaFilePart = { fg = { from = "Directory", attr = "fg", alter = -0.2 }, reverse = false } },
      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.55 } } },
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 0.2 } } },
      {
        FzfLuaSearch = {
          bg = Highlight.darken(Highlight.get("Keyword", "fg"), 1, Highlight.get("Normal", "bg")),
          fg = Highlight.get("Normal", "bg"),
        },
      },
      {
        TelescopeResultsNormal = {
          fg = { from = "FzfLuaFilePart", attr = "fg" },
          bg = { from = "FzfLuaNormal", attr = "bg" },
        },
      },
      {
        TelescopeSelection = {
          fg = { from = "PmenuSel", attr = "fg" },
          bg = { from = "FzfLuaSel", attr = "bg" },
          bold = true,
        },
      },

      -- LAZYGIT
      { LazygitInactiveBorderColor = { fg = { from = "WinSeparator", attr = "fg", alter = 0.1 }, bg = "NONE" } },

      -- AVANTE
      {
        AvanteInlineHint = {
          fg = { from = "Keyword", attr = "fg", alter = -0.4 },
          bg = "NONE",
        },
      },

      -- TROUBLE
      {
        TroubleIndent = {
          inherit = "TroubleIndent",
          fg = { from = "TroubleIndent", attr = "fg", alter = 0.2 },
        },
      },
      { TroubleFsPos = { inherit = "TroubleIndent", fg = { from = "TroubleIndent", attr = "fg", alter = -0.18 } } },

      -- MARKDOWN
      { RenderMarkdownCode = { bg = { from = "Normal", attr = "bg", alter = 0.35 } } },

      -- STATUSLINE
      {
        StatusLine = {
          fg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.65, Highlight.get("Normal", "bg")),
            -0.2
          ),
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.2, Highlight.get("Normal", "bg")),
            -0.2
          ),
          reverse = false,
        },
      },
      {
        NoiceCmdline = {
          fg = { from = "StatusLine", attr = "fg", alter = 0.4 },
          bg = { from = "StatusLine", attr = "bg" },
        },
      },
      {
        QuickFixLine = {
          bg = { from = "StatusLine", attr = "bg", alter = quickfixline_alter },
          fg = "NONE",
          underline = false,
        },
      },

      {
        StatusLineNC = {
          fg = { from = "Normal", attr = "bg", alter = 2.7 },
          bg = { from = "Normal", attr = "bg", alter = 0.45 },
        },
      },
      {
        KeywordBlur = {
          bg = { from = "StatusLineNC", attr = "bg", alter = 0.4 },
        },
      },
      {
        TabLine = {
          fg = { from = "Normal", attr = "bg", alter = 1.3 },
          bg = { from = "Normal", attr = "bg", alter = 0.3 },
        },
      },

      -- CREATED HIGHLIGHTS
      { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.2 } } },
      { StatusLineFilepath = { fg = { from = "StatusLine", attr = "fg", alter = 1 } } },
      { StatusLineFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 2 } } },
      { WinbarFilepath = { fg = { from = "LineNr", attr = "fg", alter = 0.8 } } },
      { WinbarFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 2 } } },
    },
    ["lackluster"] = {
      {
        Keyword = {
          fg = { from = "Keyword", attr = "fg", alter = 0.8 },
          bg = "NONE",
        },
      },

      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = 0.4 }, bold = true } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },
      {
        KeywordNC = {
          fg = Highlight.tint(Highlight.get("Keyword", "fg"), 0.3),
          bg = Highlight.tint(Highlight.get("Keyword", "fg"), -0.3),
        },
      },
      { Directory = { fg = "#7788aa", bg = "NONE" } },

      { qfFileName = { fg = { from = "Directory", attr = "fg", alter = 0.3 }, bg = "NONE" } },
      { QuickFixFileName = { fg = { from = "Directory", attr = "fg" }, bg = "NONE" } },

      { Comment = { fg = { from = "Comment", attr = "fg", alter = 1.2 }, italic = true } },
      { ["@comment"] = { inherit = "Comment" } },

      {
        Folded = {
          fg = { from = "Keyword", attr = "fg", alter = -0.72 },
          bg = { from = "Keyword", attr = "fg", alter = -0.81 },
        },
      },
      { FoldedSign = { fg = { from = "Folded", attr = "fg", alter = -0.45 }, bg = "NONE" } },

      { Visual = { bg = { from = "Visual", attr = "bg", alter = -0.45 } } },

      -- FZFLUA
      { FzfLuaFilePart = { fg = { from = "Directory", attr = "fg", alter = 0.1 }, reverse = false } },
      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.4 } } },
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 0.3 } } },
      { FzfLuaScrollBorderFull = { fg = { from = "FzfLuaPreviewBorder", attr = "fg", alter = 1 } } },
      { FzfLuaScrollBorderEmpty = { fg = { from = "FzfLuaPreviewBorder", attr = "fg", alter = 1 } } },
      { FzfLuaScrollFloatEmpty = { fg = { from = "FzfLuaPreviewBorder", attr = "fg", alter = 1 } } },
      { FzfLuaScrollFloatFull = { fg = { from = "FzfLuaPreviewBorder", attr = "fg", alter = 1 } } },
      { FzfLuaHelpBorder = { fg = { from = "FzfLuaNormal", attr = "bg", alter = 1 } } },
      {
        TelescopeResultsNormal = {
          fg = { from = "FzfLuaFilePart", attr = "fg" },
          bg = { from = "FzfLuaNormal", attr = "bg" },
        },
      },
      {
        TelescopeSelection = {
          fg = { from = "PmenuSel", attr = "fg" },
          bg = { from = "FzfLuaSel", attr = "bg" },
          bold = true,
        },
      },

      -- OUTLINE
      {
        OutlineCurrent = {
          fg = { from = "Keyword", attr = "fg", alter = -0.5 },
          bg = { from = "Keyword", attr = "fg", alter = 0.05 },
          bold = true,
        },
      },
      {
        IndentGuides = {
          fg = { from = "Normal", attr = "bg", alter = 1.75 },
          bg = "NONE",
        },
      },
      {
        IndentGuidesFolded = {
          fg = { from = "Normal", attr = "bg", alter = 2.8 },
          bg = "NONE",
        },
      },
      {
        OutlineDetails = {
          inherit = "OutlineDetails",
          fg = { from = "Comment", attr = "fg", alter = -0.1 },
          bg = "NONE",
          italic = true,
        },
      },

      -- BLINK
      { BlinkCmpGhostText = { fg = { from = "LineNr", attr = "fg", alter = 0.7 } } },

      -- AERIALS
      { AerialGuide = { fg = { from = "Normal", attr = "bg", alter = 1 } } },

      -- ORGMODE
      { ["@org.comment"] = { inherit = "Comment" } },
      { ["@org.directive"] = { inherit = "Comment" } },
      { ["@org.checkbox.checked.org"] = { inherit = "Comment" } },
      { ["@org.timestamp.inactive"] = { inherit = "Comment" } },

      -- SNACKS
      { SnacksIndent = { fg = { from = "SnacksIndent", attr = "fg", alter = -0.18 } } },
      { SnacksIndentScope = { fg = { from = "SnacksIndentScope", attr = "fg", alter = -0.3 } } },
      -- error
      {
        SnacksNotifierError = {
          fg = { from = "DiagnosticError", attr = "fg", alter = 5 },
          bg = { from = "DiagnosticError", attr = "fg", alter = -0.6 },
          bold = true,
        },
      },
      {
        SnacksNotifierBorderError = {
          fg = { from = "SnacksNotifierError", attr = "bg", alter = 0.2 },
          bg = { from = "SnacksNotifierError", attr = "bg" },
        },
      },
      {
        SnacksNotifierTitleError = {
          fg = { from = "SnacksNotifierError", attr = "bg", alter = 1 },
          bg = { from = "SnacksNotifierError", attr = "bg" },
          bold = true,
        },
      },
      -- warn
      {
        SnacksNotifierWarn = {
          fg = { from = "DiagnosticWarn", attr = "fg", alter = 0.2 },
          bg = { from = "DiagnosticWarn", attr = "fg", alter = -0.6 },
          bold = true,
        },
      },
      {
        SnacksNotifierBorderWarn = {
          fg = { from = "SnacksNotifierWarn", attr = "bg", alter = 0.1 },
          bg = { from = "SnacksNotifierWarn", attr = "bg" },
        },
      },
      {
        SnacksNotifierTitleWarn = {
          fg = { from = "SnacksNotifierBorderWarn", attr = "fg", alter = 0.3 },
          bg = { from = "SnacksNotifierWarn", attr = "bg" },
          bold = true,
        },
      },

      -- TROUBLE
      {
        TroubleIndent = {
          inherit = "TroubleIndent",
          fg = { from = "TroubleIndent", attr = "fg", alter = 1 },
        },
      },
      {
        TroubleIndentFoldClosed = {
          inherit = "TroubleIndent",
          fg = { from = "TroubleIndent", attr = "fg", alter = 1 },
        },
      },
      { TroubleFsPos = { inherit = "TroubleFsPos", fg = { from = "TroubleFsPos", attr = "fg", alter = 0.05 } } },

      -- GRUG-FAR
      { GrugFarResultsLineNo = { fg = { from = "LineNr", attr = "fg", alter = 1 } } },
      {
        GrugFarResultsMatch = {
          fg = { from = "Directory", attr = "fg", alter = 0.8 },
          bg = { from = "Directory", attr = "fg", alter = -0.5 },
          bold = true,
        },
      },
      { GrugFarResultsNumberLabel = { fg = { from = "Directory", attr = "fg" } } },

      -- DIFFVIEW
      { DiffviewFilePanelCounter = { fg = { from = "Directory", attr = "fg", alter = -0.1 } } },

      -- AVANTE
      {
        AvanteInlineHint = {
          fg = { from = "Keyword", attr = "fg", alter = -0.5 },
          bg = "NONE",
        },
      },

      -- MARKDOWN
      { RenderMarkdownCode = { bg = { from = "Normal", attr = "bg", alter = 0.85 } } },

      -- LSP
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
          bg = { from = "Function", attr = "fg", alter = -0.6 },
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },

      {
        LspReferenceRead = {
          bg = { from = "Function", attr = "fg", alter = -0.6 },
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },

      -- STATUSLINE
      {
        StatusLineNC = {
          fg = { from = "Normal", attr = "bg", alter = 5.7 },
          bg = { from = "Normal", attr = "bg", alter = 1.54 },
        },
      },
      {
        KeywordBlur = {
          bg = { from = "StatusLineNC", attr = "bg", alter = 0.4 },
        },
      },
      {
        TabLine = {
          fg = { from = "StatusLine", attr = "fg", alter = 0.05 },
          bg = { from = "Normal", attr = "bg", alter = 0.9 },
        },
      },

      -- CREATED HIGHLIGHTS
      { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.2 } } },
      { StatusLineFilepath = { fg = { from = "StatusLine", attr = "fg", alter = 0.9 } } },
      { StatusLineFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 2 } } },
      { WinbarFilepath = { fg = { from = "LineNr", attr = "fg", alter = 0.8 } } },
      { WinbarFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 2 } } },
    },
    ["oxocarbon"] = {
      { DiagnosticSignError = { bg = "NONE", fg = Highlight.darken(dark_red, 0.8, Highlight.get("Normal", "bg")) } },
      {
        DiagnosticSignWarn = { bg = "NONE", fg = Highlight.darken(dark_yellow, 0.8, Highlight.get("Normal", "bg")) },
      },
      { DiagnosticSignInfo = { bg = "NONE", fg = "grey" } },
      { DiagnosticSignHint = { bg = "NONE", fg = "darkgrey" } },

      { DiagnosticError = { fg = { from = "DiagnosticSignError", attr = "fg" }, bg = "NONE", italic = true } },
      { DiagnosticsErrorNumHl = { fg = { from = "DiagnosticError", attr = "fg" }, bg = "NONE" } },
      { DiagnosticWarn = { fg = { from = "DiagnosticSignWarn", attr = "fg" }, bg = "NONE", italic = true } },
      { DiagnosticsWarnNumHl = { fg = { from = "DiagnosticSignWarn", attr = "fg" }, bg = "NONE" } },
      { DiagnosticHint = { fg = { from = "DiagnosticSignHint", attr = "fg" }, bg = "NONE", italic = true } },
      { DiagnosticsHintNumHl = { fg = { from = "DiagnosticHint", attr = "fg" }, bg = "NONE" } },
      { DiagnosticInfo = { fg = { from = "DiagnosticSignInfo", attr = "fg" }, bg = "NONE", italic = true } },
      { DiagnosticsInfoNumHl = { fg = { from = "DiagnosticInfo", attr = "fg" }, bg = "NONE" } },

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

      ---

      { Visual = { bg = { from = "Visual", attr = "bg", alter = -0.2 } } },

      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = 0.3 }, bold = true } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      { Comment = { fg = { from = "Comment", attr = "fg", alter = 1.6 }, italic = true } },
      { ["@comment"] = { inherit = "Comment" } },

      {
        Folded = {
          inherit = "Folded",
          fg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.6, Highlight.get("Normal", "bg")),
            -0.38
          ),
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.3, Highlight.get("Normal", "bg")),
            -0.45
          ),
        },
      },
      { FoldedSign = { fg = { from = "Normal", attr = "bg", alter = 0.5 }, bg = "NONE" } },

      --
      {
        NormalBoxComment = {
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Normal", attr = "bg", alter = 1 },
        },
      },
      {
        FloatBoxComment = {
          fg = { from = "NormalBoxComment", attr = "bg", alter = 0.5 },
          bg = { from = "NormalBoxComment", attr = "bg" },
        },
      },
      {
        VisualBoxComment = {
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Keyword", attr = "fg", alter = -0.2 },
        },
      },

      -- BLINK
      { BlinkCmpGhostText = { fg = { from = "LineNr", attr = "fg", alter = 0.6 } } },

      -- OUTLINE
      {
        IndentGuides = {
          fg = { from = "Normal", attr = "bg", alter = 1 },
          bg = "NONE",
        },
      },
      {
        IndentGuidesFolded = {
          fg = { from = "Normal", attr = "bg", alter = 1.85 },
          bg = "NONE",
        },
      },
      {
        OutlineDetails = {
          inherit = "Comment",
          fg = { from = "Comment", attr = "fg", alter = -0.15 },
          bg = "NONE",
          italic = true,
        },
      },

      -- FZFLUA
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 0.15 } } },

      -- ORGMODE
      { ["@org.comment"] = { inherit = "Comment" } },
      { ["@org.directive"] = { inherit = "Comment" } },
      { ["@org.timestamp.inactive"] = { inherit = "Comment" } },
      { ["@org.plan"] = { inherit = "Error", bg = "NONE" } },

      -- SNACKS
      { SnacksIndent = { fg = { from = "SnacksIndent", attr = "fg", alter = -0.34 } } },
      { SnacksIndentScope = { fg = { from = "SnacksIndentScope", attr = "fg", alter = -0.3 } } },

      -- MARKDOWN
      { RenderMarkdownCode = { bg = { from = "Normal", attr = "bg", alter = 0.7 } } },
      {
        ["@markup.link.label.markdown_inline"] = {
          fg = { from = "Function", attr = "fg", alter = -0.3 },
          bg = { from = "Function", attr = "fg", alter = -0.7 },
        },
      },

      -- TROUBLE
      {
        TroubleIndent = {
          inherit = "TroubleIndent",
          fg = { from = "TroubleIndent", attr = "fg", alter = 0.5 },
        },
      },
      {
        TroubleIndentFoldClosed = {
          inherit = "TroubleIndent",
          fg = { from = "TroubleIndent", attr = "fg", alter = 1 },
        },
      },
      { TroubleFsPos = { inherit = "TroubleFsPos", fg = { from = "TroubleFsPos", attr = "fg", alter = 0.05 } } },

      -- GRUG-FAR
      {
        GrugFarResultsLineNo = {
          fg = { from = "LineNr", attr = "fg", alter = 0.5 },
          bg = { from = "Normal", attr = "bg", alter = 0.4 },
        },
      },
      { GrugFarResultsLineColumn = { link = "GrugFarResultsLineNo" } },
      {
        GrugFarResultsMatch = {
          fg = { from = "CurSearch", attr = "bg", alter = 0.2 },
          bg = { from = "CurSearch", attr = "bg", alter = -0.7 },
          bold = true,
        },
      },

      -- AVANTE
      {
        AvanteInlineHint = {
          fg = { from = "Keyword", attr = "fg", alter = -0.25 },
          bg = "NONE",
        },
      },

      -- STATUSLINE
      {
        StatusLine = {
          fg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.4, Highlight.get("Normal", "bg")),
            -0.1
          ),
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.15, Highlight.get("Normal", "bg")),
            -0.2
          ),
          reverse = false,
        },
      },
      {
        NoiceCmdline = {
          fg = { from = "StatusLine", attr = "fg", alter = 0.8 },
          bg = { from = "StatusLine", attr = "bg" },
        },
      },
      {
        QuickFixLine = {
          fg = "NONE",
          bg = { from = "StatusLine", attr = "bg", alter = quickfixline_alter },
          underline = false,
          reverse = false,
        },
      },
      {
        StatusLineNC = {
          fg = { from = "Normal", attr = "bg", alter = 3.3 },
          bg = { from = "Normal", attr = "bg", alter = 0.65 },
        },
      },
      {
        KeywordBlur = {
          bg = { from = "StatusLineNC", attr = "bg", alter = 0.5 },
        },
      },
      {
        TabLine = {
          fg = { from = "Normal", attr = "bg", alter = 3 },
          bg = { from = "Normal", attr = "bg", alter = 0.45 },
        },
      },

      -- CREATED HIGHLIGHTS
      { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.2 } } },
      { StatusLineFilepath = { fg = { from = "StatusLine", attr = "fg", alter = 0.9 } } },
      { StatusLineFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 2 } } },
      { WinbarFilepath = { fg = { from = "LineNr", attr = "fg", alter = 1 } } },
      { WinbarFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 2 } } },
    },
    ["rose-pine"] = rose_pine[RUtils.config.colorscheme],
    ["tokyonight-night"] = {
      { ErrorMsg = { bg = { from = "ErrorMsg", attr = "fg" }, fg = "white" } },
      { Error = { fg = { from = "ErrorMsg", attr = "bg" }, bg = "NONE" } },

      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = 0.05 }, bold = true } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      { Comment = { fg = { from = "Comment", attr = "fg", alter = 1.2 }, italic = true } },
      { ["@comment"] = { inherit = "Comment" } },

      {
        Folded = {
          fg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.42, Highlight.get("Normal", "bg")),
            -0.32
          ),
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.18, Highlight.get("Normal", "bg")),
            -0.3
          ),
        },
      },
      { FoldedSign = { fg = { from = "Folded", attr = "fg", alter = -0.48 }, bg = "NONE" } },

      --
      {
        NormalBoxComment = {
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Normal", attr = "bg", alter = 0.25 },
        },
      },
      {
        FloatBoxComment = {
          fg = { from = "NormalBoxComment", attr = "bg", alter = 0.5 },
          bg = { from = "NormalBoxComment", attr = "bg" },
        },
      },
      {
        VisualBoxComment = {
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Keyword", attr = "fg", alter = -0.2 },
        },
      },

      -- ORGMODE
      { ["@org.comment"] = { inherit = "Comment" } },
      { ["@org.directive"] = { inherit = "Comment" } },
      { ["@org.timestamp.inactive"] = { inherit = "Comment" } },

      -- OUTLINE
      {
        IndentGuides = {
          fg = { from = "Normal", attr = "bg", alter = 0.8 },
          bg = "NONE",
        },
      },
      {
        IndentGuidesFolded = {
          fg = { from = "Normal", attr = "bg", alter = 1.5 },
          bg = "NONE",
        },
      },
      {
        OutlineDetails = {
          inherit = "OutlineDetails",
          fg = { from = "OutlineDetails", attr = "fg", alter = -0.15 },
        },
      },

      -- SNACKS
      { SnacksIndent = { fg = { from = "SnacksIndent", attr = "fg", alter = -0.35 } } },
      { SnacksIndentScope = { fg = { from = "SnacksIndentScope", attr = "fg", alter = -0.4 } } },

      -- FZF
      { FzfLuaFilePart = { fg = { from = "Directory", attr = "fg", alter = -0.1 }, reverse = false } },
      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.4 } } },
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 0.15 } } },
      {
        TelescopeResultsNormal = {
          fg = { from = "FzfLuaFilePart", attr = "fg" },
          bg = { from = "FzfLuaNormal", attr = "bg" },
        },
      },
      {
        TelescopeSelection = {
          fg = { from = "PmenuSel", attr = "fg" },
          bg = { from = "FzfLuaSel", attr = "bg" },
          bold = true,
        },
      },

      -- MARKDOWN
      { RenderMarkdownCode = { bg = { from = "Normal", attr = "bg", alter = 0.35 } } },

      -- TROUBLE
      {
        TroubleIndent = {
          inherit = "TroubleIndent",
          fg = { from = "TroubleIndent", attr = "fg", alter = 0.4 },
        },
      },
      { TroubleFsPos = { inherit = "TroubleIndent", fg = { from = "TroubleIndent", attr = "fg", alter = -0.05 } } },

      -- STATUSLINE
      {
        StatusLine = {
          fg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.4, Highlight.get("Normal", "bg")),
            -0.2
          ),
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.1, Highlight.get("Normal", "bg")),
            -0.2
          ),
          reverse = false,
        },
      },
      {
        NoiceCmdline = {
          fg = { from = "StatusLine", attr = "fg", alter = 0.4 },
          bg = { from = "StatusLine", attr = "bg" },
        },
      },
      {
        QuickFixLine = {
          fg = "NONE",
          bg = { from = "StatusLine", attr = "bg", alter = quickfixline_alter },
          underline = false,
          reverse = false,
        },
      },
      {
        StatusLineNC = {
          fg = { from = "Normal", attr = "bg", alter = 2.8 },
          bg = { from = "Normal", attr = "bg", alter = 0.55 },
        },
      },
      {
        KeywordBlur = {
          bg = { from = "StatusLineNC", attr = "bg", alter = 0.3 },
        },
      },
      {
        TabLine = {
          fg = { from = "Normal", attr = "bg", alter = 1.8 },
          bg = { from = "Normal", attr = "bg", alter = 0.35 },
        },
      },

      -- CREATED HIGHLIGHTS
      { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.2 } } },
      { StatusLineFilepath = { fg = { from = "StatusLine", attr = "fg", alter = 0.9 } } },
      { StatusLineFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 3 } } },
      { WinbarFilepath = { fg = { from = "LineNr", attr = "fg", alter = 0.8 } } },
      { WinbarFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 3 } } },
    },
    ["tokyonight-storm"] = {
      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = -0.05 }, bold = true } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },
      { Visual = { bg = { from = "Visual", attr = "bg", alter = -0.1 } } },
      {
        Folded = {
          fg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.3, Highlight.get("Normal", "bg")),
            -0.1
          ),
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.25, Highlight.get("Normal", "bg")),
            -0.3
          ),
        },
      },
      { FoldedSign = { fg = { from = "Folded", attr = "fg", alter = -0.32 }, bg = "NONE" } },

      { Comment = { fg = { from = "Comment", attr = "fg", alter = 1.5 }, italic = true } },
      { ["@comment"] = { inherit = "Comment" } },
      { ["@org.comment"] = { inherit = "Comment" } },
      { ["@org.directive"] = { inherit = "Comment" } },
      { ["@org.timestamp.inactive"] = { inherit = "Comment" } },

      -- QFSILET
      {
        NormalBoxComment = {
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Normal", attr = "bg", alter = 0.2 },
        },
      },
      {
        FloatBoxComment = {
          fg = { from = "NormalBoxComment", attr = "bg", alter = 0.5 },
          bg = { from = "NormalBoxComment", attr = "bg" },
        },
      },
      {
        VisualBoxComment = {
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Keyword", attr = "fg", alter = -0.2 },
        },
      },

      -- SNACKS
      { SnacksIndent = { fg = { from = "SnacksIndent", attr = "fg", alter = -0.25 } } },
      { SnacksIndentScope = { fg = { from = "SnacksIndentScope", attr = "fg", alter = -0.35 } } },

      -- FZFLUA
      { FzfLuaFilePart = { fg = { from = "Directory", attr = "fg", alter = -0.1 }, reverse = false } },
      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.4 } } },
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 0.02 } } },
      {
        TelescopeResultsNormal = {
          fg = { from = "FzfLuaFilePart", attr = "fg" },
          bg = { from = "FzfLuaNormal", attr = "bg" },
        },
      },
      {
        TelescopeSelection = {
          fg = { from = "PmenuSel", attr = "fg" },
          bg = { from = "FzfLuaSel", attr = "bg" },
          bold = true,
        },
      },

      -- OUTLINE
      {
        IndentGuides = {
          fg = { from = "Normal", attr = "bg", alter = 0.55 },
          bg = "NONE",
        },
      },
      {
        IndentGuidesFolded = {
          fg = { from = "Normal", attr = "bg", alter = 1 },
          bg = "NONE",
        },
      },
      {
        OutlineDetails = {
          inherit = "OutlineDetails",
          fg = { from = "OutlineDetails", attr = "fg", alter = 0.1 },
        },
      },

      -- DIFFVIEW
      { DiffviewHash = { fg = { from = "Directory", attr = "fg", alter = 0.5 } } },
      { DiffviewFilePanelPath = { fg = { from = "StatusLine", attr = "fg", alter = -0.1 } } },

      -- MARKDOWN
      { RenderMarkdownCode = { bg = { from = "Normal", attr = "bg", alter = 0.32 } } },

      -- TROUBLE
      {
        TroubleIndent = {
          inherit = "TroubleIndent",
          fg = { from = "TroubleIndent", attr = "fg", alter = 0.3 },
        },
      },
      { TroubleFsPos = { inherit = "TroubleIndent", fg = { from = "TroubleIndent", attr = "fg", alter = -0.2 } } },

      -- STATUSLINE
      {
        StatusLine = {
          fg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.6, Highlight.get("Normal", "bg")),
            -0.2
          ),
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.2, Highlight.get("Normal", "bg")),
            -0.2
          ),
          reverse = false,
        },
      },
      {
        NoiceCmdline = {
          fg = { from = "StatusLine", attr = "fg", alter = 0.4 },
          bg = { from = "StatusLine", attr = "bg" },
        },
      },
      {
        QuickFixLine = {
          fg = "NONE",
          bg = { from = "StatusLine", attr = "bg", alter = quickfixline_alter },
          underline = false,
          reverse = false,
        },
      },
      {
        StatusLineNC = {
          fg = { from = "Normal", attr = "bg", alter = 2.5 },
          bg = { from = "Normal", attr = "bg", alter = 0.4 },
        },
      },
      { KeywordBlur = { bg = { from = "StatusLineNC", attr = "bg", alter = 0.2 } } },
      {
        TabLine = {
          fg = { from = "Normal", attr = "bg", alter = 1.2 },
          bg = { from = "Normal", attr = "bg", alter = 0.25 },
        },
      },

      -- CREATED HIGHLIGHTS
      { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.3 } } },
      { StatusLineFilepath = { fg = { from = "StatusLine", attr = "fg", alter = 0.9 } } },
      { StatusLineFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 2 } } },
      { WinbarFilepath = { fg = { from = "LineNr", attr = "fg", alter = 0.7 } } },
      { WinbarFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 2 } } },
    },
    ["vscode_modern"] = {
      {
        CursorLine = {
          bg = Highlight.darken(Highlight.get("Keyword", "fg"), cursorline_alter, Highlight.get("Normal", "bg")),
        },
      },
      {
        CursorLineNr = {
          fg = { from = "Keyword", attr = "fg" },
          bg = { from = "CursorLine", attr = "bg" },
          bold = true,
        },
      },

      { Conceal = { bg = "None", fg = { from = "Function", attr = "fg", alter = -0.1 } } },

      { Visual = { bg = { from = "Visual", asttr = "bg", alter = -0.15 } } },
      { Directory = { fg = "#569cd6", bg = "NONE" } },

      {
        Comment = {
          fg = { from = "Normal", attr = "bg", alter = 2 },
          bg = "NONE",
          italic = true,
          reverse = false,
        },
      },
      { ["@comment"] = { inherit = "Comment" } },

      {
        Folded = {
          fg = Highlight.tint(
            Highlight.darken(Highlight.get("Normal", "bg"), 0.5, Highlight.get("Keyword", "fg")),
            -0.05
          ),
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("Normal", "bg"), 0.8, Highlight.get("Keyword", "fg")),
            -0.1
          ),
        },
      },
      { FoldedSign = { fg = { from = "Folded", attr = "fg", alter = -0.22 }, bg = "NONE" } },

      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = 0.05 }, bold = true } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      -- QFSILET
      {
        NormalBoxComment = {
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Normal", attr = "bg", alter = 0.2 },
        },
      },
      {
        FloatBoxComment = {
          fg = { from = "NormalBoxComment", attr = "bg", alter = 0.5 },
          bg = { from = "NormalBoxComment", attr = "bg" },
        },
      },
      {
        VisualBoxComment = {
          fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
          bg = { from = "Keyword", attr = "fg", alter = -0.2 },
        },
      },

      -- WHICHKEY
      { WhichKeyGroup = { inherit = "WhichKeyGroup", fg = { from = "DiagnosticWarn", attr = "fg", alter = -0.1 } } },

      -- ORGMODE
      { ["@org.comment"] = { inherit = "Comment" } },
      { ["@org.directive"] = { inherit = "Comment" } },
      { ["@org.timestamp.inactive"] = { inherit = "Comment" } },
      { ["@org.plan"] = { inherit = "Error", bg = "NONE", underline = false } },

      -- OUTLINE
      {
        IndentGuides = {
          fg = { from = "Normal", attr = "bg", alter = 1 },
          bg = "NONE",
        },
      },
      {
        IndentGuidesFolded = {
          fg = { from = "Normal", attr = "bg", alter = 1.8 },
          bg = "NONE",
        },
      },
      { OutlineDetails = { fg = { from = "Comment", attr = "fg", alter = -0.2 }, bg = "NONE", italic = true } },

      -- FZFLUA
      { FzfLuaFilePart = { fg = { from = "Directory", attr = "fg", alter = -0.1 }, reverse = false } },
      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.45 } } },
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 0.02 } } },
      { FzfLuaCursorLine = { bg = { from = "CursorLine", attr = "bg", alter = fzflua_bg_cursorline_alter } } },
      {
        FzfLuaCursorLineNr = {
          fg = { from = "FzfLuaCursorLine", attr = "bg", alter = 3 },
          bg = { from = "FzfLuaCursorLine", attr = "bg" },
        },
      },

      {
        TelescopeResultsNormal = {
          fg = { from = "FzfLuaFilePart", attr = "fg" },
          bg = { from = "FzfLuaNormal", attr = "bg" },
        },
      },
      {
        TelescopeSelection = {
          fg = { from = "PmenuSel", attr = "fg" },
          bg = { from = "FzfLuaSel", attr = "bg" },
          bold = true,
        },
      },

      -- SNACKS
      { SnacksIndent = { fg = { from = "SnacksIndent", attr = "fg", alter = -0.23 } } },
      { SnacksIndentScope = { fg = { from = "SnacksIndentScope", attr = "fg", alter = -0.34 } } },

      -- TROUBLE
      {
        TroubleIndent = {
          inherit = "TroubleIndent",
          fg = { from = "TroubleIndent", attr = "fg", alter = 0.15 },
        },
      },
      { TroubleFsPos = { inherit = "TroubleIndent", fg = { from = "TroubleIndent", attr = "fg", alter = -0.2 } } },

      -- MARKDOWN
      {
        ["@markup.link.label.markdown_inline"] = {
          fg = { from = "@markup.link.label.markdown_inline", attr = "fg", alter = 0.2 },
          bg = { from = "@markup.link.label.markdown_inline", attr = "fg", alter = -0.5 },
        },
      },

      -- AVANTE
      {
        AvanteInlineHint = {
          fg = { from = "Keyword", attr = "fg", alter = -0.4 },
          bg = "NONE",
        },
      },

      -- LSP
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

      -- MARKDOWN
      { RenderMarkdownCode = { bg = { from = "Normal", attr = "bg", alter = 0.3 } } },

      -- STATUSLINE
      {
        StatusLine = {
          fg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.55, Highlight.get("Normal", "bg")),
            -0.1
          ),
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("Keyword", "fg"), 0.2, Highlight.get("Normal", "bg")),
            -0.2
          ),
          reverse = false,
        },
      },
      {
        NoiceCmdline = {
          fg = { from = "StatusLine", attr = "fg", alter = 1 },
          bg = { from = "StatusLine", attr = "bg" },
        },
      },
      { qfFileName = { fg = { from = "Directory", attr = "fg", alter = 0.3 }, bg = "NONE" } },
      { QuickFixFileName = { fg = { from = "Directory", attr = "fg" }, bg = "NONE" } },
      {
        QuickFixLine = {
          fg = "NONE",
          bg = { from = "StatusLine", attr = "bg", alter = quickfixline_alter },
          underline = false,
          reverse = false,
        },
      },
      {
        StatusLineNC = {
          fg = { from = "Normal", attr = "bg", alter = 3 },
          bg = { from = "Normal", attr = "bg", alter = 0.55 },
        },
      },
      { KeywordBlur = { bg = { from = "StatusLineNC", attr = "bg", alter = 0.4 } } },
      {
        TabLine = {
          fg = { from = "Normal", attr = "bg", alter = 1.5 },
          bg = { from = "Normal", attr = "bg", alter = 0.35 },
        },
      },

      -- CREATED HIGHLIGHTS
      { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.3 } } },
      { StatusLineFilepath = { fg = { from = "StatusLine", attr = "fg", alter = 0.8 } } },
      { StatusLineFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 1.9 } } },
      { WinbarFilepath = { fg = { from = "LineNr", attr = "fg", alter = 0.8 } } },
      { WinbarFontWhite = { fg = { from = "StatusLine", attr = "fg", alter = 2.5 } } },
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
