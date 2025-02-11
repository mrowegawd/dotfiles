local UIPallette = require("r.utils").uisec

local Highlight = require "r.settings.highlights"

local dark_green = Highlight.tint(UIPallette.palette.green, 0.3)
local dark_yellow = Highlight.tint(UIPallette.palette.bright_yellow, 0.3)
local dark_red = Highlight.tint(UIPallette.palette.dark_red, 0.3)

local pmenu_fg_alter, pmenu_bg_alter, pmenu_fg_border_alter, pmenusel_bg_alter, pmenuthumb_alter, quickfixline_alter, fzflua_bg_cursorline_alter, cursorline_alter, normalfloat_bg_alter, normalfloat_fg_alter, cmpdocnormal_fg_alter, winseparator_alter, normalfloat_border_fg_alter, fzfluasel_bg_alter

local base_cl = {
  cmpdocnormal_fg_alter = 0.3,
  cursorline_alter = 0.04,
  fzflua_bg_cursorline_alter = 0.05,

  normalfloat_bg_alter = -0.12,
  normalfloat_fg_alter = -0.01,
  normalfloat_border_fg_alter = 1.2,

  pmenu_bg_alter = 0.1,
  pmenu_fg_alter = -0.1,
  pmenu_fg_border_alter = 1.5,

  fzfluasel_bg_alter = -0.2,

  pmenusel_bg_alter = 0.15,
  pmenusel_fg_alter = -0.6,
  pmenuthumb_alter = 1,

  quickfixline_alter = 0.3,
  winseparator_alter = 0.6,
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
    if i == "pmenu_fg_border_alter" then
      pmenu_fg_border_alter = x
    end
    if i == "pmenusel_bg_alter" then
      pmenusel_bg_alter = x
    end
    if i == "pmenuthumb_alter" then
      pmenuthumb_alter = x
    end
    if i == "fzflua_bg_cursorline_alter" then
      fzflua_bg_cursorline_alter = x
    end
    if i == "pmenuthumb_alter" then
      pmenuthumb_alter = x
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
    if i == "normalfloat_border_fg_alter" then
      normalfloat_border_fg_alter = x
    end
    if i == "fzfluasel_bg_alter" then
      fzfluasel_bg_alter = x
    end
    if i == "winseparator_alter" then
      winseparator_alter = x
    end
  end
end

reset_base_alter({ "ashen" }, {
  cursorline_alter = 0.05,
  normalfloat_border_fg_alter = 2,
  pmenu_fg_border_alter = 1.5,
  pmenusel_bg_alter = 1,
  pmenusel_fg_alter = 0.1,
  pmenuthumb_alter = 1.8,
  quickfixline_alter = 0.4,
  winseparator_alter = 0.8,
})
reset_base_alter({ "base2tone_cave_dark" }, {
  fzflua_bg_cursorline_alter = -0.14,
  pmenu_bg_alter = -0.1,
  pmenu_fg_border_alter = 0.7,
  pmenusel_bg_alter = -0.2,
  pmenusel_fg_alter = 0.9,
  pmenuthumb_alter = 0.5,
})
reset_base_alter({ "base2tone_field_dark" }, {
  pmenu_bg_alter = 0.5,
  pmenu_fg_border_alter = 0,
  pmenusel_bg_alter = -0.2,
  pmenusel_fg_alter = 0.9,
  pmenuthumb_alter = 0.4,
})
reset_base_alter({ "catppuccin-mocha" }, {
  fzflua_bg_cursorline_alter = -0.1,
  pmenu_bg_alter = -0.15,
  pmenu_fg_border_alter = 0.8,
  pmenuthumb_alter = 0.7,
  winseparator_alter = 0.4,
})
reset_base_alter({ "coffeecat" }, {
  cursorline_alter = 0.04,
  fzflua_bg_cursorline_alter = -0.08,
  pmenu_bg_alter = -0.1,
  pmenu_fg_border_alter = 0.8,
  pmenuthumb_alter = 0.7,
  quickfixline_alter = 0.5,
})
reset_base_alter({ "ef-dream" }, {
  fzflua_bg_cursorline_alter = -0.1,
  pmenu_bg_alter = -0.15,
  pmenu_fg_border_alter = 0.8,
  pmenuthumb_alter = 0.7,
  winseparator_alter = 0.4,
})
reset_base_alter({ "gruvbox-material" }, {
  cursorline_alter = 0.2,
  fzflua_bg_cursorline_alter = -0.1,
  normalfloat_bg_alter = -0.13,
  normalfloat_border_fg_alter = 0.9,
  pmenu_bg_alter = -0.15,
  pmenu_fg_alter = 0.5,
  pmenu_fg_border_alter = 0.65,
  pmenusel_bg_alter = 0.15,
  pmenusel_fg_alter = 0,
  pmenuthumb_alter = 0.6,
  winseparator_alter = 0.4,
})
reset_base_alter({ "horizon" }, {
  cursorline_alter = 0.2,
  fzflua_bg_cursorline_alter = -0.48,
  pmenu_bg_alter = -0.1,
  pmenu_fg_border_alter = 0.9,
})
reset_base_alter({ "jellybeans" }, {
  cursorline_alter = 0.04,
  pmenu_bg_alter = 0.8,
  pmenu_fg_border_alter = 0.9,
  pmenusel_bg_alter = 0.2,
  pmenuthumb_alter = 0.6,
})
reset_base_alter({ "lackluster" }, {
  cursorline_alter = 0.13,
  fzflua_bg_cursorline_alter = 0.3,
  normalfloat_bg_alter = 0.5,
  normalfloat_fg_alter = -0.01,
  pmenu_bg_alter = 0.5,
  pmenu_fg_alter = 0.3,
  pmenu_fg_border_alter = 0.8,
  pmenuthumb_alter = 1,
})
reset_base_alter({ "oldworld" }, {
  cursorline_alter = 0.06,
  pmenu_fg_border_alter = 0.5,
  pmenu_bg_alter = 0.8,
  pmenuthumb_alter = 0.4,
})
reset_base_alter({ "oxocarbon" }, {
  cursorline_alter = 0.07,
  fzflua_bg_cursorline_alter = -0.05,
  pmenu_bg_alter = -0.05,
  pmenu_fg_border_alter = 1.5,
  pmenuthumb_alter = 0.8,
  quickfixline_alter = 0.5,
})
reset_base_alter({ "rose-pine-dawn" }, {
  cursorline_alter = -0.09,
  fzflua_bg_cursorline_alter = -0.07,
  normalfloat_bg_alter = -0.08,
  pmenu_bg_alter = -0.1,
  pmenu_fg_alter = -0.4,
  pmenu_fg_border_alter = 0,
  pmenusel_bg_alter = 0.05,
  pmenusel_fg_alter = -0.3,
  pmenuthumb_alter = -0.1,
  quickfixline_alter = 0.5,
  winseparator_alter = -0.06,
})
reset_base_alter({ "rose-pine-main" }, {
  cursorline_alter = 0.09,
  fzflua_bg_cursorline_alter = -0.05,
  normalfloat_bg_alter = -0.15,
  pmenu_bg_alter = -0.2,
  pmenu_fg_border_alter = 1.2,
  pmenusel_bg_alter = 0.08,
  pmenuthumb_alter = 0.7,
  quickfixline_alter = 0.5,
  winseparator_alter = 0.4,
})
reset_base_alter({ "sunburn" }, {
  pmenu_bg_alter = -0.05,
  pmenu_fg_border_alter = 1.2,
})
reset_base_alter({ "tokyonight-night" }, {
  cursorline_alter = 0.02,
  fzflua_bg_cursorline_alter = -0.01,
  fzfluasel_bg_alter = -0.1,
  normalfloat_border_fg_alter = 0.9,
  pmenu_bg_alter = -0.15,
  pmenu_fg_border_alter = 0.9,
  pmenusel_bg_alter = 0.07,
  pmenuthumb_alter = 0.7,
  quickfixline_alter = 0.8,
  winseparator_alter = 0.5,
})
reset_base_alter({ "tokyonight-storm" }, {
  cmpdocnormal_fg_alter = 0.1,
  cursorline_alter = 0.05,
  fzflua_bg_cursorline_alter = -0.12,
  fzfluasel_bg_alter = -0.1,
  normalfloat_border_fg_alter = 0.9,
  pmenu_bg_alter = -0.15,
  pmenu_fg_alter = 0.1,
  pmenu_fg_border_alter = 0.7,
  pmenusel_bg_alter = 0.07,
  pmenuthumb_alter = 0.5,
  winseparator_alter = 0.4,
})
reset_base_alter({ "vscode_modern" }, {
  cmpdocnormal_fg_alter = 0.1,
  cursorline_alter = 0.05,
  fzflua_bg_cursorline_alter = -0.12,
  fzfluasel_bg_alter = 0.05,
  normalfloat_border_fg_alter = 0.9,
  pmenu_bg_alter = -0.15,
  pmenu_fg_alter = 0.1,
  pmenu_fg_border_alter = 0.7,
  pmenusel_bg_alter = 0.06,
  pmenuthumb_alter = 0.5,
  winseparator_alter = 0.4,
  quickfixline_alter = 0.5,
})
reset_base_alter({ "zenburned" }, {
  cursorline_alter = 0.08,
  fzflua_bg_cursorline_alter = -0.08,
  pmenu_bg_alter = -0.2,
  pmenu_fg_border_alter = 0,
  pmenusel_bg_alter = 0,
  fzfluasel_bg_alter = 0.2,
  normalfloat_border_fg_alter = 0.6,
  pmenuthumb_alter = 0.4,
  winseparator_alter = 0.18,
})

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
    { Comment = { fg = { from = "Comment", attr = "fg", alter = -0.55 }, italic = true } },
    {
      Folded = {
        fg = { from = "Normal", attr = "bg", alter = 1.5 },
        bg = { from = "Normal", attr = "bg", alter = 0.7 },
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
        fg = { from = "Normal", attr = "bg", alter = 6 },
        bg = { from = "Normal", attr = "bg", alter = 1.3 },
        reverse = false,
      },
    },
    {
      StatusLineNC = {
        fg = { from = "Normal", attr = "bg", alter = 4.1 },
        bg = { from = "StatusLine", attr = "bg", alter = -0.2 },
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
        bg = Highlight.darken(Highlight.get("Normal", "fg"), pmenusel_bg_alter, Highlight.get("Normal", "bg")),
        bold = true,
      },
    },
    { PmenuThumb = { bg = { from = "Pmenu", attr = "bg", alter = pmenuthumb_alter } } },
    {
      NormalFloat = {
        fg = { from = "Normal", attr = "fg", alter = normalfloat_fg_alter },
        bg = { from = "Normal", attr = "bg", alter = normalfloat_bg_alter },
      },
    },
    {
      FloatBorder = {
        fg = { from = "NormalFloat", attr = "bg", alter = normalfloat_border_fg_alter },
        bg = { from = "NormalFloat", attr = "bg" },
      },
    },

    {
      FloatTitle = {
        bg = { from = "Keyword", attr = "fg", alter = -0.1 },
        fg = { from = "Normal", attr = "bg" },
        bold = true,
      },
    },
    { StatusLine_esse = { fg = { from = "Keyword", attr = "fg" }, bg = { from = "Normal", attr = "bg" } } },

    -- ╔═════════════════════════════════════════════════════════╗
    -- ║                           QF                            ║
    -- ╚═════════════════════════════════════════════════════════╝
    { qfFileName = { bg = "NONE" } },
    { QuickFixFileName = { bg = "NONE" } },
    {
      QuickFixLine = {
        fg = "NONE",
        bg = { from = "CursorLine", attr = "bg", alter = quickfixline_alter },
        underline = false,
        reverse = false,
      },
    },

    -- ╔═════════════════════════════════════════════════════════╗
    -- ║                          SPELL                          ║t
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
      diffChange = {
        bg = Highlight.darken(Highlight.get("Normal", "bg"), 0.8, dark_yellow),
        fg = "NONE",
        bold = true,
      },
    },
    -- stylua: ignore
    { diffDelete = { bg = Highlight.darken(Highlight.get("Normal", "bg"), 0.7, dark_red), fg = Highlight.darken(dark_red, 0.2, Highlight.get("Normal", "bg")), bold = true, }, },
    {
      diffText = {
        bg = Highlight.darken(Highlight.get("Normal", "bg"), 0.4, dark_yellow),
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
    { MyMark = { fg = { from = "DiagnosticSignWarn", attr = "fg", alter = 0.5 }, bold = true, italic = true } },
    {
      MyCodeUsage = {
        fg = { from = "Keyword", attr = "fg", alter = 0.1 },
        bg = { from = "StatusLine", attr = "bg", alter = -0.05 },
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
        fg = Highlight.tint(Highlight.get("Keyword", "fg"), -0.1),
        bg = Highlight.tint(Highlight.get("Keyword", "fg"), -0.5),
      },
    },
    {
      KeywordBlur = {
        bg = { from = "StatusLineNC", attr = "bg", alter = 0.6 },
      },
    },

    -- ╔═════════════════════════════════════════════════════════╗
    -- ║                      PLUGIN COLORS                      ║
    -- ╚═════════════════════════════════════════════════════════╝
    --  ──────────────────────────────── BLINK ───────────────────────────
    { CmpGhostText = { link = "BlinkCmpGhostText" } },
    { BlinkCmpGhostText = { fg = { from = "BlinkCmpGhostText", attr = "fg", alter = 0.45 } } },
    {
      BlinkCmpDocSeparator = {
        fg = { from = "WinSeparator", attr = "fg", alter = 0.8 },
        bg = { from = "Pmenu", attr = "bg" },
      },
    },
    { BlinkCmpLabelMatch = { fg = { from = "Error", attr = "fg", alter = -0.3 } } },

    -- ───────────────────────────────── CMP ─────────────────────────────
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
    { CmpItemAbbrMatch = { fg = { from = "CmpItemAbbrMatchFuzzy", attr = "fg", alter = 0.2 } } },

    -- ╭─────────╮
    -- │ CMPITEM │
    -- ╰─────────╯
    { CmpItemAbbrDefault = { fg = { from = "CmpItemAbbr", attr = "fg" } } },
    {
      CmpItemFloatBorder = {
        fg = { from = "Pmenu", attr = "bg", alter = pmenu_fg_border_alter },
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

    -- ─────────────────────────────── AERIALS ───────────────────────────
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

    -- ─────────────────────────────── FZFLUA ────────────────────────────
    { FzfLuaFilePart = { fg = { from = "Directory", attr = "fg", alter = -0.2 }, reverse = false } },
    { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.5 } } },
    { FzfLuaCursorLine = { bg = { from = "CursorLine", attr = "bg", alter = fzflua_bg_cursorline_alter } } },
    {
      FzfLuaCursorLineNr = {
        fg = { from = "FzfLuaCursorLine", attr = "bg", alter = 0.8 },
        bg = { from = "FzfLuaCursorLine", attr = "bg" },
      },
    },

    { FzfLuaFzfMatch = { fg = { from = "Error", attr = "fg", alter = 0.5 }, bg = "NONE" } },
    { FzfLuaFzfMatchFuzzy = { fg = { from = "FzfLuaFzfMatch", attr = "fg", alter = -0.2 }, bg = "NONE" } },

    {
      FzfLuaSel = {
        fg = "NONE",
        bg = { from = "PmenuSel", attr = "bg", alter = fzfluasel_bg_alter },
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
    { FzfLuaScrollBorderFull = { fg = { from = "FzfLuaPreviewBorder", attr = "fg", alter = 1 } } },

    -- ────────────────────────────── TELESCOPE ──────────────────────────────
    { TelescopeNormal = { inherit = "FzfLuaNormal" } },
    { TelescopeBorder = { inherit = "FzfLuaBorder" } },
    { TelescopeMatching = { link = "FzfLuaFzfMatch" } },
    { TelescopeTitle = { inherit = "FzfLuaTitle" } },

    {
      TelescopeSelection = {
        fg = { from = "PmenuSel", attr = "fg" },
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
    { TelescopePromptPrefix = { fg = { from = "FloatBorder", attr = "fg" } } },
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

    -- ──────────────────────────────── NOICE ────────────────────────────────
    {
      NoiceCmdline = {
        fg = { from = "Pmenu", attr = "fg", alter = 5 },
        bg = { from = "Pmenu", attr = "bg", alter = -0.2 },
      },
    },

    -- ─────────────────────────────── ORGMODE ───────────────────────────────
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
    { ["@org.tag"] = { inherit = "Function" } },
    { ["@org.plan"] = { inherit = "Constant" } },
    { ["@org.comment"] = { inherit = "Comment" } },
    { ["@org.directive"] = { inherit = "Comment" } },
    { ["@org.block"] = { inherit = "Comment" } },
    { ["@org.latex"] = { inherit = "Statement" } },
    { ["@org.hyperlinks"] = { inherit = "Underlined" } },
    { ["@org.code"] = { inherit = "String" } },

    -- ───────────────────────────── BUFFERLINE ──────────────────────────
    { BufferLineIndicatorSelected = { bg = { from = "ColorColumn" } } },

    -- ───────────────────────────────── BQF ─────────────────────────────
    { BqfSign = { bg = { from = "ColorColumn", attr = "bg" }, { fg = { from = "Boolean" } } } },

    -- ──────────────────────────── FUGITIVE ─────────────────────────────
    { fugitiveStagedModifier = { inherit = "GitSignsAdd" } },
    { fugitiveUnstagedModifier = { inherit = "GitSignsChange" } },
    { fugitiveUntrackedModifier = { fg = { from = "GitSignsAdd", attr = "fg", alter = 0.2 } } },

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
    { ["@markup.heading.1.markdown"] = { fg = "#4d85c3", bold = true, italic = true } },
    { ["@markup.heading.2.markdown"] = { fg = "#389674", bold = true, italic = true } },
    { ["@markup.heading.3.markdown"] = { fg = "#b0be1e", bold = true, italic = true } },
    { ["@markup.heading.4.markdown"] = { fg = "#8594c8", bold = true, italic = true } },
    { ["@markup.heading.5.markdown"] = { fg = "#f76328", bold = true, italic = true } },
    { ["@markup.heading.6.markdown"] = { fg = "#fccf3e", bold = true, italic = true } },
    {
      ["@markup.quote.markdown"] = {
        fg = { from = "Boolean", attr = "fg", alter = -0.2 },
        bg = { from = "Boolean", attr = "fg", alter = -0.8 },
        bold = true,
        italic = true,
      },
    },
    { ["@markup.raw.block.markdown"] = { bg = "NONE" } },

    {
      ["@markup.italic.markdown_inline"] = {
        fg = { from = "@tag.attribute", attr = "fg", alter = -0.2 },
        italic = true,
        underline = false,
      },
    },
    {
      ["@markup.link.label.markdown_inline"] = {
        fg = { from = "@markup.link.label.markdown_inline", attr = "fg", alter = -0.2 },
        bg = { from = "@markup.link.label.markdown_inline", attr = "fg", alter = -0.8 },
      },
    },
    {
      ["@markup.strong.markdown_inline"] = {
        fg = { from = "Normal", attr = "fg", alter = 0.5 },
        bg = "NONE",
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

    --  ────────────────────────────── WHICH-KEY ──────────────────────────────
    { WhichKeyTitle = { inherit = "FloatTitle" } },
    { WhichKeyNormal = { inherit = "NormalFloat", fg = { from = "Function", attr = "fg", alter = 0.1 } } },
    { WhichKeyGroup = { inherit = "NormalFloat", fg = { from = "Keyword", attr = "fg", alter = 0.1 } } },
    { WhichKeyDesc = { inherit = "NormalFloat", fg = { from = "Boolean", attr = "fg", alter = 0.1 } } },
    { WhichKeyBorder = { inherit = "FloatBorder" } },

    --  ─────────────────────────────── AVANTE ────────────────────────────────
    {
      AvanteNormal = {
        fg = { from = "Normal", attr = "bg", alter = 4 },
        bg = { from = "Normal", attr = "bg", alter = -0.5 },
      },
    },
    --  ─────────────────────────────── DASHBOARD ─────────────────────────────
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
        bold = bold,
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
    { Keyword = { fg = { from = "Keyword", attr = "fg", alter = 0.8 } } },
    {
      KeywordNC = {
        fg = { from = "Keyword", attr = "fg", alter = -0.2 },
        bg = { from = "Keyword", attr = "fg", alter = 0.01 },
      },
    },
    { ["@punctuation.bracket"] = { fg = { from = "@constructor", attr = "fg" } } },
    {
      PmenuSel = {
        -- fg = { from = "Directory", attr = "fg", alter = pmenusel_fg_alter },
        bg = { from = "Normal", attr = "bg", alter = pmenusel_bg_alter },
        bold = true,
      },
    },

    { WinSeparator = { fg = { from = "Normal", attr = "bg", alter = winseparator_alter }, bg = "NONE" } },

    { NonText = { fg = { from = "Normal", attr = "bg", alter = -0.4 } } },

    { Visual = { bg = { from = "Visual", attr = "bg", alter = -0.05 } } },

    { LineNr = { fg = { from = "LineNr", attr = "fg", alter = -0.18 } } },
    { LineNrAbove = { link = "LineNr" } },
    { LineNrBelow = { link = "LineNr" } },
    { BlinkCmpGhostText = { fg = { from = "LineNr", attr = "fg", alter = 0.6 } } },

    { Comment = { fg = { from = "Normal", attr = "bg", alter = -0.25 }, italic = true } },
    { ["@comment"] = { inherit = "Comment" } },
    { ["@org.comment"] = { inherit = "Comment" } },

    --- BLINK
    { BlinkCmpLabelMatch = { fg = { from = "Error", attr = "fg", alter = 0.05 } } },

    --- CMP
    { CmpItemAbbrMatchFuzzy = { inherit = "BlinkCmpLabelMatch" } },
    { CmpItemAbbrMatch = { fg = { from = "CmpItemAbbrMatchFuzzy", attr = "fg", alter = 0.2 } } },

    { SnacksIndent = { fg = { from = "Normal", attr = "bg", alter = -0.03 } } },
    { SnacksIndentScope = { fg = { from = "SnacksIndentScope", attr = "fg", alter = 0.04 } } },

    {
      ["@markup.raw.markdown_inline"] = {
        bg = "NONE",
      },
    },
    {
      ["@markup.link.label.markdown_inline"] = {
        fg = { from = "@markup.link.label.markdown_inline", attr = "fg", alter = -0.2 },
        bg = { from = "@markup.link.label.markdown_inline", attr = "fg", alter = 0.9 },
      },
    },
    {
      ["@markup.strong.markdown_inline"] = {
        fg = "magenta",
        bg = "NONE",
        bold = true,
      },
    },

    -- FZFLUA
    {
      FzfLuaSel = {
        fg = { from = "PmenuSel", attr = "fg" },
        bg = { from = "PmenuSel", attr = "bg" },
      },
    },
    { FzfLuaFilePart = { fg = { from = "PmenuSel", attr = "fg", alter = 0.06 }, reverse = false } },
    { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = 0.08 } } },
    { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = -0.2 } } },

    { FzfLuaCursorLine = { fg = "NONE" } },

    {
      Search = {
        fg = { from = "Normal", attr = "bg" },
        bg = Highlight.darken(dark_yellow, 0.5, Highlight.get("Normal", "bg")),
      },
    },
    {
      IncSearch = {
        fg = { from = "Normal", attr = "bg" },
        bg = Highlight.darken(dark_yellow, 1.2, Highlight.get("Normal", "bg")),
      },
    },
    { CurSearch = { inherit = "IncSearch", bold = true } },

    {
      Folded = {
        fg = { from = "Boolean", attr = "fg", alter = -0.2 },
        bg = { from = "Boolean", attr = "fg", alter = 0.75 },
        bold = false,
      },
    },
    { FoldedSign = { fg = { from = "Normal", attr = "bg", alter = -0.08 }, bg = "NONE" } },

    {
      FloatBorder = {
        fg = { from = "FzfLuaNormal", attr = "bg" },
        bg = { from = "FzfLuaNormal", attr = "bg" },
      },
    },

    {
      NoiceCmdline = {
        fg = { from = "Pmenu", attr = "fg", alter = 5 },
        bg = { from = "Pmenu", attr = "bg", alter = 0.02 },
      },
    },

    {
      LspReferenceText = {
        bg = { from = "Normal", attr = "bg", alter = -0.02 },
        fg = "NONE",
        underline = false,
        reverse = false,
        undercurl = false,
      },
    },
    {
      LspReferenceWrite = {
        bg = { from = "Normal", attr = "bg", alter = -0.05 },
        underline = false,
        reverse = false,
        undercurl = false,
      },
    },
    {
      LspReferenceRead = {
        bg = { from = "Normal", attr = "bg", alter = -0.02 },
        underline = false,
        reverse = false,
        undercurl = false,
      },
    },

    {
      StatusLine = {
        fg = { from = "Keyword", attr = "fg", alter = 0.6 },
        bg = { from = "Keyword", attr = "fg", alter = -0.4 },
      },
    },
    {
      StatusLineNC = {
        fg = { from = "Normal", attr = "bg", alter = -0.45 },
        bg = { from = "Normal", attr = "bg", alter = -0.09 },
      },
    },
    {
      KeywordBlur = {
        bg = { from = "StatusLineNC", attr = "bg", alter = -0.06 },
      },
    },
    {
      TabLine = {
        fg = { from = "Normal", attr = "bg", alter = -0.2 },
        bg = { from = "Normal", attr = "bg", alter = -0.06 },
      },
    },
    { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = -0.07 } } },
  },
  ["rose-pine-main"] = {
    { Visual = { bg = { from = "Visual", attr = "bg", alter = -0.05 } } },

    { LineNr = { fg = { from = "LineNr", attr = "fg", alter = 0.01 } } },
    { LineNrAbove = { link = "LineNr" } },
    { LineNrBelow = { link = "LineNr" } },
    { BlinkCmpGhostText = { fg = { from = "LineNr", attr = "fg", alter = 0.6 } } },

    { Comment = { fg = { from = "Comment", attr = "fg", alter = 0.2 }, italic = true } },
    { ["@comment"] = { inherit = "Comment" } },
    { ["@org.comment"] = { inherit = "Comment" } },

    { SnacksIndent = { fg = { from = "Normal", attr = "bg", alter = 0.3 } } },
    { SnacksIndentScope = { fg = { from = "SnacksIndentScope", attr = "fg", alter = -0.6 } } },

    { FzfLuaFilePart = { fg = { from = "Directory", attr = "fg", alter = -0.2 }, reverse = false } },
    { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.6 } } },
    { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 0.2 } } },

    { FzfLuaCursorLine = { fg = "NONE" } },

    {
      Search = {
        bg = Highlight.darken(dark_yellow, 0.5, Highlight.get("Normal", "bg")),
        fg = { from = "Normal", attr = "bg" },
      },
    },
    {
      IncSearch = {
        bg = Highlight.darken(dark_yellow, 1.2, Highlight.get("Normal", "bg")),
        fg = { from = "Normal", attr = "bg" },
      },
    },
    { CurSearch = { inherit = "IncSearch", bold = true } },

    {
      Folded = {
        fg = { from = "Normal", attr = "bg", alter = 0.6 },
        bg = { from = "Normal", attr = "bg", alter = -0.3 },
      },
    },
    { FoldedSign = { fg = { from = "Folded", attr = "fg", alter = -0.05 }, bg = "NONE" } },

    {
      NoiceCmdline = {
        fg = { from = "Pmenu", attr = "fg", alter = 5 },
        bg = { from = "Pmenu", attr = "bg", alter = 0.05 },
      },
    },
    {
      StatusLine = {
        fg = { from = "Keyword", attr = "fg", alter = 0.6 },
        bg = { from = "Keyword", attr = "fg", alter = -0.4 },
      },
    },
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
        fg = { from = "Normal", attr = "bg", alter = 3 },
        bg = { from = "Normal", attr = "bg", alter = 0.25 },
      },
    },
    { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.35 } } },
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

      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = 0.15 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },
      { BlinkCmpGhostText = { fg = { from = "LineNr", attr = "fg", alter = 0.6 } } },

      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 0.25 } } },

      { Comment = { fg = { from = "Comment", attr = "fg", alter = 0.3 }, italic = true } },
      { ["@comment"] = { inherit = "Comment" } },
      { ["@org.comment"] = { inherit = "Comment" } },
      { ["@org.directive"] = { inherit = "Comment" } },

      { qfFileName = { fg = { from = "Directory", attr = "fg", alter = 0.3 }, bg = "NONE" } },
      { QuickFixFileName = { fg = { from = "Directory", attr = "fg", alter = 0.4 }, bg = "NONE" } },
      { QuickFixLine = { fg = "NONE", underline = false, bg = { from = "QuickFixLine", attr = "bg", alter = 0.2 } } },

      { SnacksIndent = { fg = { from = "SnacksIndent", attr = "fg", alter = 0.02 } } },
      { SnacksIndentScope = { fg = { from = "SnacksIndentScope", attr = "fg", alter = -0.48 } } },

      { FzfLuaSel = { bg = { from = "PmenuSel", attr = "bg" } } },
      { FzfLuaCursorLine = { fg = "NONE" } },

      { FzfLuaFilePart = { fg = { from = "Directory", attr = "fg", alter = 0.2 }, reverse = false } },
      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.5 } } },
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 0.6 } } },

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

      {
        Search = {
          bg = Highlight.darken(dark_yellow, 0.5, Highlight.get("Normal", "bg")),
          fg = { from = "Normal", attr = "bg" },
        },
      },
      {
        IncSearch = {
          bg = Highlight.darken(dark_yellow, 1.2, Highlight.get("Normal", "bg")),
          fg = { from = "Normal", attr = "bg" },
        },
      },
      { CurSearch = { inherit = "IncSearch", bold = true } },

      {
        Folded = {
          fg = { from = "@keyword.function", attr = "fg", alter = -0.57 },
          bg = { from = "@keyword.function", attr = "fg", alter = -0.85 },
        },
      },
      { FoldedSign = { fg = { from = "Normal", attr = "bg", alter = 1 }, bg = "NONE" } },

      {
        NoiceCmdline = {
          fg = { from = "Pmenu", attr = "fg", alter = 5 },
          bg = { from = "Pmenu", attr = "bg", alter = 0.4 },
        },
      },

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

      {
        StatusLine = {
          fg = { from = "Keyword", attr = "fg", alter = -0.2 },
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("StatusLine_esse", "bg"), 0.5, Highlight.get("StatusLine_esse", "fg")),
            -0.4
          ),
        },
      },
      {
        StatusLineNC = {
          fg = { from = "Normal", attr = "bg", alter = 4.8 },
          bg = { from = "Normal", attr = "bg", alter = 1.2 },
        },
      },
      {
        KeywordBlur = {
          bg = { from = "StatusLineNC", attr = "bg", alter = 0.28 },
        },
      },
      {
        TabLine = {
          fg = { from = "Normal", attr = "bg", alter = 3.8 },
          bg = { from = "Normal", attr = "bg", alter = 0.48 },
        },
      },
      { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.4 } } },
    },
    ["base2tone_cave_dark"] = {
      { NormalNC = { bg = "NONE" } },

      { DiagnosticSignError = { bg = "NONE", fg = Highlight.darken(dark_red, 0.8, Highlight.get("Normal", "bg")) } },
      { DiagnosticSignWarn = { bg = "NONE", fg = Highlight.darken(dark_yellow, 0.8, Highlight.get("Normal", "bg")) } },
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

      { ErrorMsg = { bg = Highlight.darken(dark_red, 0.8, Highlight.get("Normal", "bg")), fg = "white" } },
      { Error = { fg = { from = "ErrorMsg", attr = "bg" }, bg = "NONE" } },

      { FzfLuaFzfMatch = { fg = { from = "Error", attr = "fg", alter = 0.2 }, bg = "NONE" } },
      { FzfLuaFzfMatchFuzzy = { fg = { from = "FzfLuaFzfMatch", attr = "fg", alter = -0.3 }, bg = "NONE" } },

      { BlinkCmpLabelMatch = { fg = { from = "Error", attr = "fg", alter = -0.3 } } },
      { CmpItemAbbrMatchFuzzy = { inherit = "BlinkCmpLabelMatch" } },
      { CmpItemAbbrMatch = { fg = { from = "CmpItemAbbrMatchFuzzy", attr = "fg", alter = 0.2 } } },

      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = -0.15 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },
      { BlinkCmpGhostText = { fg = { from = "LineNr", attr = "fg", alter = 0.6 } } },

      { Comment = { fg = { from = "Comment", attr = "fg", alter = 1 }, italic = true } },
      { ["@comment"] = { inherit = "Comment" } },
      { ["@org.comment"] = { inherit = "Comment" } },
      { ["@org.directive"] = { inherit = "Comment" } },

      { Visual = { bg = { from = "Visual", attr = "bg", alter = -0.23 } } },

      { SnacksIndent = { fg = { from = "Normal", attr = "bg", alter = 0.2 } } },
      { SnacksIndentScope = { fg = { from = "SnacksIndentScope", attr = "fg", alter = -0.45 } } },

      { FzfLuaFilePart = { fg = { from = "Directory", attr = "fg", alter = -0.1 }, reverse = false } },
      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.4 } } },
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 0.6 } } },
      { FzfLuaSearch = { inherit = "CurSearch" } },

      {
        Folded = {
          fg = { from = "Normal", attr = "bg", alter = 0.4 },
          bg = { from = "Normal", attr = "bg", alter = -0.2 },
        },
      },
      { FoldedSign = { fg = { from = "Folded", attr = "fg", alter = -0.05 }, bg = "NONE" } },

      {
        NoiceCmdline = {
          fg = { from = "Pmenu", attr = "fg", alter = 5 },
          bg = { from = "Pmenu", attr = "bg", alter = 0.02 },
        },
      },

      {
        ["@markup.link.label.markdown_inline"] = {
          fg = Highlight.tint(Highlight.get("Keyword", "fg"), -0.3),
          bg = Highlight.tint(Highlight.get("Keyword", "fg"), -0.8),
        },
      },
      {
        StatusLine = {
          fg = { from = "Keyword", attr = "fg", alter = 0.5 },
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("StatusLine_esse", "bg"), 0.6, Highlight.get("StatusLine_esse", "fg")),
            -0.3
          ),
        },
      },
      {
        StatusLineNC = {
          fg = { from = "Normal", attr = "bg", alter = 3 },
          bg = { from = "Normal", attr = "bg", alter = 0.5 },
        },
      },
      {
        KeywordBlur = {
          bg = { from = "StatusLineNC", attr = "bg", alter = 0.5 },
        },
      },
      {
        TabLine = {
          fg = { from = "Normal", attr = "bg", alter = 2.8 },
          bg = { from = "Normal", attr = "bg", alter = 0.2 },
        },
      },
      { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.3 } } },
    },
    ["base2tone_field_dark"] = {
      { NormalNC = { bg = "NONE" } },

      { DiagnosticSignError = { bg = "NONE", fg = Highlight.darken(dark_red, 0.8, Highlight.get("Normal", "bg")) } },
      { DiagnosticSignWarn = { bg = "NONE", fg = Highlight.darken(dark_yellow, 0.8, Highlight.get("Normal", "bg")) } },
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

      { ErrorMsg = { bg = Highlight.darken(dark_red, 0.8, Highlight.get("Normal", "bg")), fg = "white" } },
      { Error = { fg = { from = "ErrorMsg", attr = "bg" }, bg = "NONE" } },

      { FzfLuaFzfMatch = { fg = { from = "Error", attr = "fg", alter = 0.2 }, bg = "NONE" } },
      { FzfLuaFzfMatchFuzzy = { fg = { from = "FzfLuaFzfMatch", attr = "fg", alter = -0.3 }, bg = "NONE" } },

      { BlinkCmpLabelMatch = { fg = { from = "Error", attr = "fg", alter = -0.3 } } },
      { CmpItemAbbrMatchFuzzy = { inherit = "BlinkCmpLabelMatch" } },
      { CmpItemAbbrMatch = { fg = { from = "CmpItemAbbrMatchFuzzy", attr = "fg", alter = 0.2 } } },

      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = -0.1 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },
      { BlinkCmpGhostText = { fg = { from = "LineNr", attr = "fg", alter = 0.6 } } },

      { Comment = { fg = { from = "Comment", attr = "fg", alter = 1 }, italic = true } },
      { ["@comment"] = { inherit = "Comment" } },
      { ["@org.comment"] = { inherit = "Comment" } },

      { Visual = { bg = { from = "Visual", attr = "bg", alter = -0.18 } } },

      { SnacksIndent = { fg = { from = "Normal", attr = "bg", alter = 0.2 } } },
      { SnacksIndentScope = { fg = { from = "SnacksIndentScope", attr = "fg", alter = -0.5 } } },

      { FzfLuaFilePart = { fg = { from = "Directory", attr = "fg", alter = -0.1 }, reverse = false } },
      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.4 } } },
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 0.6 } } },
      { FzfLuaSearch = { inherit = "CurSearch" } },

      {
        Folded = {
          fg = { from = "Normal", attr = "bg", alter = 0.6 },
          bg = { from = "Normal", attr = "bg", alter = -0.2 },
        },
      },
      { FoldedSign = { fg = { from = "Folded", attr = "fg", alter = -0.05 }, bg = "NONE" } },

      {
        NoiceCmdline = {
          fg = { from = "Pmenu", attr = "fg", alter = 5 },
          bg = { from = "Pmenu", attr = "bg", alter = 0.02 },
        },
      },

      {
        ["@markup.link.label.markdown_inline"] = {
          fg = Highlight.tint(Highlight.get("Keyword", "fg"), -0.3),
          bg = Highlight.tint(Highlight.get("Keyword", "fg"), -0.8),
        },
      },

      {
        StatusLine = {
          fg = { from = "Keyword", attr = "fg", alter = 0.15 },
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("StatusLine_esse", "bg"), 0.5, Highlight.get("StatusLine_esse", "fg")),
            -0.2
          ),
        },
      },
      {
        StatusLineNC = {
          fg = { from = "Normal", attr = "bg", alter = 3 },
          bg = { from = "Normal", attr = "bg", alter = 0.5 },
        },
      },
      {
        KeywordBlur = {
          bg = { from = "StatusLineNC", attr = "bg", alter = 0.4 },
        },
      },
      {
        TabLine = {
          fg = { from = "Normal", attr = "bg", alter = 3 },
          bg = { from = "Normal", attr = "bg", alter = 0.24 },
        },
      },
      { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.3 } } },
    },
    ["ef-dream"] = {
      { Comment = { fg = { from = "Normal", attr = "bg", alter = 1.4 }, italic = true } },
      { ["@comment"] = { inherit = "Comment" } },
      { ["@org.comment"] = { inherit = "Comment" } },
      { ["@org.directive"] = { inherit = "Comment" } },

      { Visual = { bg = { from = "Visual", attr = "bg", alter = -0.27 } } },

      { FzfLuaFzfMatch = { fg = { from = "Error", attr = "fg", alter = 0.05 }, bg = "NONE" } },
      { FzfLuaFzfMatchFuzzy = { fg = { from = "FzfLuaFzfMatch", attr = "fg", alter = -0.4 }, bg = "NONE" } },

      { LineNr = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 0.6 } } },
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 0.3 } } },
      { BlinkCmpGhostText = { fg = { from = "LineNr", attr = "fg", alter = 0.6 } } },

      {
        Folded = {
          fg = { from = "Normal", attr = "bg", alter = 0.5 },
          bg = { from = "Normal", attr = "bg", alter = -0.19 },
        },
      },
      { FoldedSign = { fg = { from = "Folded", attr = "fg", alter = -0.15 }, bg = "NONE" } },

      { SnacksIndent = { fg = { from = "Normal", attr = "bg", alter = 0.18 } } },
      { SnacksIndentScope = { fg = { from = "Normal", attr = "bg", alter = 0.5 } } },

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
        NoiceCmdline = {
          fg = { from = "Pmenu", attr = "fg", alter = 5 },
          bg = { from = "Pmenu", attr = "bg", alter = -0.05 },
        },
      },

      {
        StatusLine = {
          fg = { from = "Keyword", attr = "fg", alter = 0.2 },
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("StatusLine_esse", "fg"), 0.5, Highlight.get("StatusLine_esse", "bg")),
            -0.2
          ),
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
          fg = { from = "Normal", attr = "bg", alter = 2.6 },
          bg = { from = "Normal", attr = "bg", alter = 0.2 },
        },
      },
      { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.3 } } },
    },
    ["catppuccin-mocha"] = {
      { Comment = { fg = { from = "Normal", attr = "bg", alter = 1.4 }, italic = true } },
      { ["@comment"] = { inherit = "Comment" } },
      { ["@org.comment"] = { inherit = "Comment" } },
      { ["@org.directive"] = { inherit = "Comment" } },

      { Visual = { bg = { from = "Visual", attr = "bg", alter = -0.27 } } },

      { FzfLuaFzfMatch = { fg = { from = "Error", attr = "fg", alter = 0.05 }, bg = "NONE" } },
      { FzfLuaFzfMatchFuzzy = { fg = { from = "FzfLuaFzfMatch", attr = "fg", alter = -0.4 }, bg = "NONE" } },

      { LineNr = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 0.6 } } },
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 0.3 } } },
      { BlinkCmpGhostText = { fg = { from = "LineNr", attr = "fg", alter = 0.6 } } },

      {
        Folded = {
          fg = { from = "Normal", attr = "bg", alter = 0.5 },
          bg = { from = "Normal", attr = "bg", alter = -0.23 },
        },
      },
      { FoldedSign = { fg = { from = "Folded", attr = "fg", alter = -0.15 }, bg = "NONE" } },

      { SnacksIndent = { fg = { from = "Normal", attr = "bg", alter = 0.18 } } },
      { SnacksIndentScope = { fg = { from = "Normal", attr = "bg", alter = 0.5 } } },

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
        NoiceCmdline = {
          fg = { from = "Pmenu", attr = "fg", alter = 5 },
          bg = { from = "Pmenu", attr = "bg", alter = -0.05 },
        },
      },

      {
        StatusLine = {
          fg = { from = "Keyword", attr = "fg", alter = 0.2 },
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("StatusLine_esse", "fg"), 0.5, Highlight.get("StatusLine_esse", "bg")),
            -0.2
          ),
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
          fg = { from = "Normal", attr = "bg", alter = 2.6 },
          bg = { from = "Normal", attr = "bg", alter = 0.2 },
        },
      },
      { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.3 } } },
    },
    ["neomodern"] = {
      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = -0.1 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },
      { BlinkCmpGhostText = { fg = { from = "LineNr", attr = "fg", alter = 0.6 } } },

      { Visual = { bg = { from = "Visual", attr = "bg", alter = -0.15 }, fg = "NONE" } },

      { FzfLuaFzfMatch = { fg = { from = "Error", attr = "fg", alter = 0.05 }, bg = "NONE" } },
      { FzfLuaFzfMatchFuzzy = { fg = { from = "FzfLuaFzfMatch", attr = "fg", alter = -0.4 }, bg = "NONE" } },

      { Comment = { fg = { from = "Comment", attr = "fg", alter = 0.48 }, italic = true } },
      { ["@comment"] = { inherit = "Comment" } },
      { ["@org.comment"] = { inherit = "Comment" } },
      { ["@org.directive"] = { inherit = "Comment" } },

      { SnacksIndent = { fg = { from = "SnacksIndent", attr = "fg", alter = -0.2 } } },
      { SnacksIndentScope = { fg = { from = "SnacksIndentScope", attr = "fg", alter = -0.4 } } },

      {
        Folded = {
          fg = { from = "Normal", attr = "bg", alter = 0.4 },
          bg = { from = "Normal", attr = "bg", alter = -0.2 },
        },
      },
      { FoldedSign = { fg = { from = "Folded", attr = "fg", alter = 0.02 }, bg = "NONE" } },

      {
        CurSearch = {
          bg = Highlight.darken(Highlight.get("Keyword", "fg"), 1, Highlight.get("Normal", "bg")),
          fg = Highlight.get("Normal", "bg"),
        },
      },
      { Search = { bg = { from = "Search", attr = "fg" }, fg = { from = "Search", attr = "fg", alter = -0.8 } } },
      { IncSearch = { inherit = "CurSearch" } },

      {
        FzfLuaSearch = {
          bg = Highlight.darken(Highlight.get("Keyword", "fg"), 1, Highlight.get("Normal", "bg")),
          fg = Highlight.get("Normal", "bg"),
        },
      },

      {
        NoiceCmdline = {
          fg = { from = "Pmenu", attr = "fg", alter = 5 },
          bg = { from = "Pmenu", attr = "bg", alter = 0.05 },
        },
      },

      {
        StatusLine = {
          fg = { from = "Keyword", attr = "fg", alter = 0.2 },
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("StatusLine_esse", "fg"), 0.6, Highlight.get("StatusLine_esse", "bg")),
            -0.5
          ),
          reverse = false,
        },
      },
      {
        StatusLineNC = {
          fg = { from = "Normal", attr = "bg", alter = 2.8 },
          bg = { from = "Normal", attr = "bg", alter = 0.6 },
          reverse = false,
        },
      },
      { KeywordBlur = { bg = { from = "StatusLineNC", attr = "bg", alter = 0.4 } } },
      {
        TabLine = {
          fg = { from = "Normal", attr = "bg", alter = 3 },
          bg = { from = "Normal", attr = "bg", alter = 0.3 },
          reverse = false,
        },
      },
      { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.3 } } },
    },
    ["gruvbox-material"] = {
      { CursorLine = { bg = Highlight.tint(Highlight.get("Normal", "bg"), cursorline_alter) } },
      {
        CursorLineNr = {
          fg = { from = "Normal", attr = "fg" },
          bg = { from = "CursorLine", attr = "bg" },
          bold = true,
        },
      },

      {
        CmpItemAbbr = {
          fg = { from = "Function", attr = "fg", alter = -0.3 },
          bg = "NONE",
        },
      },
      {
        CmpDocNormal = {
          fg = { from = "CmpItemAbbr", attr = "fg", alter = -0.1 },
          bg = { from = "Pmenu", attr = "bg" },
        },
      },
      { CmpItemAbbrDefault = { fg = { from = "CmpItemAbbr", attr = "fg" } } },

      { FzfLuaFzfMatch = { fg = { from = "Error", attr = "fg", alter = 0.05 }, bg = "NONE" } },
      { FzfLuaFzfMatchFuzzy = { fg = { from = "FzfLuaFzfMatch", attr = "fg", alter = -0.4 }, bg = "NONE" } },

      { Directory = { fg = { from = "Identifier", attr = "fg" }, bg = "NONE" } },

      { qfFileName = { fg = { from = "Directory", attr = "fg", alter = 0.3 }, bg = "NONE" } },
      { QuickFixFileName = { fg = { from = "Directory", attr = "fg" }, bg = "NONE" } },
      { QuickFixLine = { fg = "NONE", underline = false } },

      {
        Comment = {
          fg = { from = "Normal", attr = "bg", alter = 1 },
          bg = "NONE",
          italic = true,
          reverse = false,
        },
      },
      { ["@comment"] = { inherit = "Comment" } },
      { ["@org.comment"] = { inherit = "Comment" } },
      { ["@org.directive"] = { inherit = "Comment" } },

      { SnacksIndent = { fg = { from = "Normal", attr = "bg", alter = 0.15 } } },
      { SnacksIndentScope = { fg = { from = "SnacksIndentScope", attr = "fg", alter = -0.4 } } },
      {
        Folded = {
          fg = { from = "Normal", attr = "bg", alter = 0.6 },
          bg = { from = "Normal", attr = "bg", alter = -0.15 },
        },
      },
      { FoldedSign = { fg = { from = "Folded", attr = "fg", alter = -0.05 }, bg = "NONE" } },

      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = -0.2 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      { FzfLuaFilePart = { fg = { from = "Directory", attr = "fg", alter = -0.2 }, reverse = false } },
      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.55 } } },
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

      { Visual = { bg = { from = "Visual", attr = "bg", alter = -0.1 } } },

      {
        NoiceCmdline = {
          fg = { from = "Pmenu", attr = "fg", alter = 5 },
          bg = { from = "Pmenu", attr = "bg", alter = -0.02 },
        },
      },

      {
        StatusLine = {
          fg = { from = "@variable", attr = "fg", alter = 0.2 },
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("@variable", "fg"), 0.7, Highlight.get("StatusLine_esse", "bg")),
            -0.34
          ),
          reverse = false,
        },
      },
      {
        StatusLineNC = {
          fg = { from = "Normal", attr = "bg", alter = 2.5 },
          bg = { from = "Normal", attr = "bg", alter = 0.45 },
          reverse = false,
        },
      },
      { KeywordBlur = { bg = { from = "StatusLineNC", attr = "bg", alter = 0.4 } } },
      {
        TabLine = {
          fg = { from = "Normal", attr = "bg", alter = 2.3 },
          bg = { from = "Normal", attr = "bg", alter = 0.18 },
          reverse = false,
        },
      },
      { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.3 } } },
    },
    ["horizon"] = {
      { CursorLine = { bg = Highlight.tint(Highlight.get("Normal", "bg"), cursorline_alter) } },
      {
        CursorLineNr = {
          fg = { from = "Normal", attr = "fg" },
          bg = { from = "CursorLine", attr = "bg" },
          bold = true,
        },
      },
      { Directory = { fg = { from = "@annotation", attr = "fg", alter = 0.2 }, bg = "NONE" } },
      {
        PmenuSel = {
          bg = Highlight.darken(Highlight.get("Normal", "fg"), pmenusel_bg_alter, Highlight.get("Normal", "bg")),
          bold = true,
        },
      },

      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = -0.1 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      { Visual = { bg = { from = "Visual", attr = "bg", alter = -0.1 } } },

      { qfFileName = { fg = { from = "Directory", attr = "fg", alter = 0.3 }, bg = "NONE" } },
      { QuickFixFileName = { fg = { from = "Directory", attr = "fg" }, bg = "NONE" } },
      {
        QuickFixLine = {
          bg = { from = "CursorLine", attr = "bg", alter = 0.5 },
          fg = "NONE",
          underline = false,
        },
      },

      { CurSearch = { fg = Highlight.get("Normal", "bg") } },
      {
        Search = {
          fg = { from = "Search", attr = "fg", alter = 1 },
          bg = { from = "Search", attr = "bg", alter = 0.4 },
        },
      },

      { Comment = { fg = { from = "Comment", attr = "fg", alter = 1.2 }, italic = true } },
      { ["@comment"] = { inherit = "Comment" } },
      { ["@org.comment"] = { inherit = "Comment" } },
      { ["@org.directive"] = { inherit = "Comment" } },

      { SnacksIndent = { fg = { from = "SnacksIndent", attr = "fg", alter = -0.2 } } },
      { SnacksIndentScope = { fg = { from = "Normal", attr = "bg", alter = 0.7 } } },

      {
        Folded = {
          fg = { from = "Normal", attr = "bg", alter = 0.6 },
          bg = { from = "Normal", attr = "bg", alter = -0.2 },
        },
      },
      { FoldedSign = { fg = { from = "Folded", attr = "fg", alter = -0.05 }, bg = "NONE" } },

      { FzfLuaFilePart = { fg = { from = "Directory", attr = "fg", alter = -0.2 }, reverse = false } },
      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.55 } } },
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 0.1 } } },
      {
        FzfLuaSel = {
          fg = { from = "PmenuSel", attr = "fg" },
          bg = { from = "PmenuSel", attr = "bg" },
        },
      },
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

      {
        NoiceCmdline = {
          fg = { from = "Pmenu", attr = "fg", alter = 5 },
          bg = { from = "Pmenu", attr = "bg", alter = 0.02 },
        },
      },
      {
        ["@markup.link.label.markdown_inline"] = {
          fg = Highlight.tint(dark_yellow, -0.2),
          bg = Highlight.tint(dark_yellow, -0.8),
          underline = false,
        },
      },

      {
        StatusLine = {
          fg = { from = "Keyword", attr = "fg", alter = 0.2 },
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("StatusLine_esse", "fg"), 0.6, Highlight.get("StatusLine_esse", "bg")),
            -0.5
          ),
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
          bg = { from = "Normal", attr = "bg", alter = 0.25 },
        },
      },
      { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.3 } } },
    },
    ["jellybeans"] = {
      { DiagnosticSignError = { bg = "NONE", fg = Highlight.darken(dark_red, 0.8, Highlight.get("Normal", "bg")) } },
      { DiagnosticSignWarn = { bg = "NONE", fg = Highlight.darken(dark_yellow, 0.8, Highlight.get("Normal", "bg")) } },
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

      { Error = { fg = { from = "ErrorMsg", attr = "bg" }, bg = "NONE" } },

      { FzfLuaFzfMatch = { fg = { from = "Error", attr = "fg", alter = 0.5 }, bg = "NONE" } },
      { FzfLuaFzfMatchFuzzy = { fg = { from = "FzfLuaFzfMatch", attr = "fg", alter = -0.3 }, bg = "NONE" } },

      { CmpItemAbbrMatch = { fg = { from = "Error", attr = "fg", alter = 0.5 } } },
      { CmpItemAbbrMatchFuzzy = { fg = { from = "CmpItemAbbrMatch", attr = "fg", alter = -0.5 } } },

      { TelescopeMatching = { link = "CmpItemAbbrMatchFuzzy" } },

      { Visual = { bg = { from = "Visual", attr = "bg", alter = -0.2 } } },
      { Comment = { fg = { from = "Comment", attr = "fg", alter = 0.15 }, italic = true } },
      { ["@comment"] = { inherit = "Comment" } },
      { ["@org.comment"] = { inherit = "Comment" } },
      { ["@org.directive"] = { inherit = "Comment" } },

      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = 0.05 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },
      { BlinkCmpGhostText = { fg = { from = "LineNr", attr = "fg", alter = 0.6 } } },

      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 0.5 } } },

      { SnacksIndent = { fg = { from = "SnacksIndent", attr = "fg", alter = -0.12 } } },
      { SnacksIndentScope = { fg = { from = "SnacksIndentScope", attr = "fg", alter = -0.5 } } },

      { QuickFixLine = { bg = { from = "CursorLine", attr = "bg", alter = 0.5 }, fg = "NONE", underline = false } },

      {
        Folded = {
          fg = { from = "@keyword.function", attr = "fg", alter = -0.7 },
          bg = { from = "@keyword.function", attr = "fg", alter = -0.85 },
        },
      },
      { FoldedSign = { fg = { from = "Folded", attr = "fg", alter = -0.5 }, bg = "NONE" } },

      {
        ["@markup.link.label.markdown_inline"] = {
          fg = Highlight.tint(dark_yellow, -0.2),
          bg = Highlight.tint(dark_yellow, -0.8),
          underline = false,
        },
      },

      {
        StatusLine = {
          fg = { from = "Keyword", attr = "fg", alter = 0.1 },
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("StatusLine_esse", "fg"), 0.6, Highlight.get("StatusLine_esse", "bg")),
            -0.4
          ),
        },
      },
      {
        StatusLineNC = {
          fg = { from = "Normal", attr = "bg", alter = 3.3 },
          bg = { from = "Normal", attr = "bg", alter = 0.65 },
        },
      },
      { KeywordBlur = { bg = { from = "StatusLineNC", attr = "bg", alter = 0.4 } } },
      {
        TabLine = {
          fg = { from = "Normal", attr = "bg", alter = 3.5 },
          bg = { from = "Normal", attr = "bg", alter = 0.35 },
        },
      },
      { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.3 } } },
    },
    ["lackluster"] = {
      {
        KeywordNC = {
          fg = Highlight.tint(Highlight.get("Keyword", "fg"), 0.3),
          bg = Highlight.tint(Highlight.get("Keyword", "fg"), -0.3),
        },
      },
      { Directory = { fg = "#7788aa", bg = "NONE" } },
      {
        PmenuSel = {
          -- fg = { from = "Directory", attr = "fg", alter = pmenusel_fg_alter },
          bg = Highlight.darken(Highlight.get("Normal", "fg"), pmenusel_bg_alter, Highlight.get("Normal", "bg")),
          bold = true,
        },
      },
      {
        FzfLuaSel = {
          fg = { from = "PmenuSel", attr = "fg" },
          bg = { from = "PmenuSel", attr = "bg" },
        },
      },

      { CurSearch = { bg = { from = "Error", attr = "fg", alter = 0.2 }, fg = "white" } },
      {
        Search = {
          fg = { from = "CurSearch", attr = "fg" },
          bg = Highlight.darken(Highlight.get("Error", "fg"), 0.5, Highlight.get("Normal", "bg")),
        },
      },
      { IncSearch = { link = "CurSearch" } },

      { qfFileName = { fg = { from = "Directory", attr = "fg", alter = 0.3 }, bg = "NONE" } },
      { QuickFixFileName = { fg = { from = "Directory", attr = "fg" }, bg = "NONE" } },
      {
        QuickFixLine = {
          bg = { from = "CursorLine", attr = "bg", alter = 0.35 },
          fg = "NONE",
          underline = false,
        },
      },

      { CmpItemAbbrMatchFuzzy = { fg = "#FAB005" } },
      { CmpItemAbbrMatch = { fg = { from = "CmpItemAbbrMatchFuzzy", attr = "fg", alter = -0.3 } } },

      { FzfLuaFilePart = { fg = { from = "Directory", attr = "fg", alter = 0.1 }, reverse = false } },
      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.4 } } },
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 1.8 } } },
      { FzfLuaScrollBorderFull = { fg = { from = "FzfLuaPreviewBorder", attr = "fg", alter = 1 } } },
      { FzfLuaScrollBorderEmpty = { fg = { from = "FzfLuaPreviewBorder", attr = "fg", alter = 1 } } },
      { FzfLuaScrollFloatEmpty = { fg = { from = "FzfLuaPreviewBorder", attr = "fg", alter = 1 } } },
      { FzfLuaScrollFloatFull = { fg = { from = "FzfLuaPreviewBorder", attr = "fg", alter = 1 } } },
      { FzfLuaHelpBorder = { fg = { from = "FzfLuaPreviewBorder", attr = "fg", alter = 1 } } },

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

      { WinSeparator = { fg = { from = "LineNr", attr = "fg", alter = 0.1 }, bg = "NONE" } },
      {
        Keyword = {
          fg = { from = "Keyword", attr = "fg", alter = 0.8 },
          bg = "NONE",
        },
      },

      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = 0.3 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      { Visual = { bg = { from = "Visual", attr = "bg", alter = -0.45 } } },
      { BlinkCmpGhostText = { fg = { from = "LineNr", attr = "fg", alter = 0.7 } } },

      { AerialGuide = { fg = { from = "Normal", attr = "bg", alter = 1 } } },

      {
        Folded = {
          fg = Highlight.tint(Highlight.get("Error", "fg"), -0.32),
          bg = Highlight.tint(Highlight.get("Error", "fg"), -0.9),
        },
      },
      { FoldedSign = { fg = { from = "Normal", attr = "bg", alter = 1 }, bg = "NONE" } },

      { Comment = { fg = { from = "Comment", attr = "fg", alter = 1 }, italic = true } },
      { ["@comment"] = { inherit = "Comment" } },
      { ["@org.comment"] = { inherit = "Comment" } },
      { ["@org.directive"] = { inherit = "Comment" } },

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
          bg = { from = "Normal", attr = "bg", alter = 1.5 },
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },

      {
        LspReferenceRead = {
          bg = { from = "Normal", attr = "bg", alter = 1.5 },
          underline = false,
          reverse = false,
          undercurl = false,
        },
      },

      { SnacksIndent = { fg = { from = "SnacksIndent", attr = "fg", alter = 0.08 } } },
      { SnacksIndentScope = { fg = { from = "SnacksIndentScope", attr = "fg", alter = -0.4 } } },

      { ["@org.checkbox.checked.org"] = { inherit = "Comment" } },

      {
        StatusLine = {
          fg = { from = "Keyword", attr = "fg", alter = -0.02 },
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("StatusLine_esse", "fg"), 0.4, Highlight.get("StatusLine_esse", "bg")),
            0.4
          ),
        },
      },
      {
        StatusLineNC = {
          fg = { from = "Normal", attr = "bg", alter = 5 },
          bg = { from = "Normal", attr = "bg", alter = 1.3 },
        },
      },
      {
        KeywordBlur = {
          bg = { from = "StatusLineNC", attr = "bg", alter = 0.4 },
        },
      },
      {
        TabLine = {
          fg = { from = "StatusLine", attr = "fg", alter = -0.45 },
          bg = { from = "Normal", attr = "bg", alter = 0.6 },
        },
      },
      { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.35 } } },
    },
    ["oldworld"] = {
      { Visual = { bg = { from = "Visual", attr = "bg", alter = -0.22 } } },
      { NormalNC = { bg = "NONE" } },
      -- { Normal = { bg = "NONE" } },

      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = -0.02 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },
      { BlinkCmpGhostText = { fg = { from = "LineNr", attr = "fg", alter = 0.6 } } },

      { QuickFixLine = { bg = { from = "CursorLine", attr = "bg", alter = 0.3 }, fg = "NONE", underline = false } },

      { Comment = { fg = { from = "Comment", attr = "fg", alter = 0.2 }, italic = true } },
      { ["@comment"] = { inherit = "Comment" } },
      { ["@org.comment"] = { inherit = "Comment" } },
      { ["@org.directive"] = { inherit = "Comment" } },

      { SnacksIndent = { fg = { from = "Normal", attr = "bg", alter = 0.3 } } },
      { SnacksIndentScope = { fg = { from = "SnacksIndentScope", attr = "fg", alter = -0.5 } } },

      { FzfLuaFilePart = { fg = { from = "Directory", attr = "fg", alter = -0.2 }, reverse = false } },
      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.6 } } },
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 0.2 } } },
      { FzfLuaCursorLine = { bg = { from = "CursorLine", attr = "bg", alter = fzflua_bg_cursorline_alter } } },
      {
        FzfLuaCursorLineNr = {
          fg = { from = "FzfLuaCursorLine", attr = "bg", alter = 0.8 },
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

      {
        Search = {
          bg = Highlight.darken(dark_yellow, 0.5, Highlight.get("Normal", "bg")),
          fg = { from = "Normal", attr = "bg" },
        },
      },
      {
        IncSearch = {
          bg = Highlight.darken(dark_yellow, 1.2, Highlight.get("Normal", "bg")),
          fg = { from = "Normal", attr = "bg" },
        },
      },
      { CurSearch = { inherit = "IncSearch", bold = true } },

      {
        Folded = {
          fg = { from = "@keyword.function", attr = "fg", alter = -0.65 },
          bg = { from = "@keyword.function", attr = "fg", alter = -0.8 },
        },
      },
      { FoldedSign = { fg = { from = "Folded", attr = "fg", alter = -0.4 }, bg = "NONE" } },

      {
        NoiceCmdline = {
          fg = { from = "Pmenu", attr = "fg", alter = 5 },
          bg = { from = "Pmenu", attr = "bg", alter = 0.4 },
        },
      },
      {
        StatusLine = {
          fg = { from = "Keyword", attr = "fg", alter = 0.2 },
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("StatusLine_esse", "fg"), 0.4, Highlight.get("StatusLine_esse", "bg")),
            0.05
          ),
        },
      },
      {
        StatusLineNC = {
          fg = { from = "Normal", attr = "bg", alter = 3.5 },
          bg = { from = "Normal", attr = "bg", alter = 0.68 },
        },
      },
      { KeywordBlur = { bg = { from = "StatusLineNC", attr = "bg", alter = 0.4 } } },
      {
        TabLine = {
          fg = { from = "Normal", attr = "bg", alter = 2.8 },
          bg = { from = "Normal", attr = "bg", alter = 0.3 },
        },
      },
      { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.35 } } },
    },
    ["oxocarbon"] = {
      { DiagnosticSignError = { bg = "NONE", fg = Highlight.darken(dark_red, 0.8, Highlight.get("Normal", "bg")) } },
      { DiagnosticSignWarn = { bg = "NONE", fg = Highlight.darken(dark_yellow, 0.8, Highlight.get("Normal", "bg")) } },
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

      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = -0.02 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },
      { BlinkCmpGhostText = { fg = { from = "LineNr", attr = "fg", alter = 0.6 } } },

      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 0.4 } } },

      { Comment = { fg = { from = "Comment", attr = "fg", alter = 0.6 }, italic = true } },
      { ["@comment"] = { inherit = "Comment" } },
      { ["@org.comment"] = { inherit = "Comment" } },

      { SnacksIndent = { fg = { from = "Normal", attr = "bg", alter = 0.4 } } },
      { SnacksIndentScope = { fg = { from = "SnacksIndentScope", attr = "fg", alter = -0.6 } } },
      {
        Folded = {
          fg = { from = "Keyword", attr = "fg", alter = -0.7 },
          bg = { from = "Keyword", attr = "fg", alter = -0.85 },
        },
      },
      { FoldedSign = { fg = { from = "Normal", attr = "bg", alter = 0.5 }, bg = "NONE" } },

      {
        MyCodeUsage = {
          fg = { from = "MyCodeUsage", attr = "fg", alter = -0.1 },
          bg = { from = "MyCodeUsage", attr = "bg", alter = -0.1 },
          italic = true,
        },
      },

      {
        ["@markup.link.label.markdown_inline"] = {
          fg = Highlight.tint(dark_yellow, -0.2),
          bg = Highlight.tint(dark_yellow, -0.8),
        },
      },

      {
        NoiceCmdline = {
          fg = { from = "Pmenu", attr = "fg", alter = 5 },
          bg = { from = "Pmenu", attr = "bg", alter = 0.02 },
        },
      },
      {
        StatusLine = {
          fg = { from = "Keyword", attr = "fg", alter = 0.2 },
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("StatusLine_esse", "bg"), 0.6, Highlight.get("StatusLine_esse", "fg")),
            -0.3
          ),
        },
      },
      {
        StatusLineNC = {
          fg = { from = "Normal", attr = "bg", alter = 3 },
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
          bg = { from = "Normal", attr = "bg", alter = 0.3 },
        },
      },
      { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.35 } } },
    },
    ["rose-pine"] = rose_pine[RUtils.config.colorscheme],
    ["sunburn"] = {
      { Visual = { bg = { from = "@Boolean", attr = "fg", alter = -0.74 } } },

      { Comment = { fg = { from = "Comment", attr = "fg", alter = 0.75 }, italic = true } },
      { ["@comment"] = { inherit = "Comment" } },
      { ["@org.comment"] = { inherit = "Comment" } },

      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = 0.02 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },
      { BlinkCmpGhostText = { fg = { from = "LineNr", attr = "fg", alter = 0.6 } } },

      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 0.3 } } },

      { SnacksIndent = { fg = { from = "SnacksIndentScope", attr = "fg", alter = -0.55 } } },
      { SnacksIndentScope = { fg = { from = "SnacksIndentScope", attr = "fg", alter = -0.4 } } },

      {
        Folded = {
          fg = { from = "Normal", attr = "bg", alter = 0.6 },
          bg = { from = "Normal", attr = "bg", alter = -0.4 },
        },
      },
      { FoldedSign = { fg = { from = "Folded", attr = "fg", alter = 0.1 }, bg = "NONE" } },

      {
        NoiceCmdline = {
          fg = { from = "Pmenu", attr = "fg", alter = 3.5 },
          bg = { from = "Pmenu", attr = "bg", alter = -0.02 },
        },
      },
      {
        ["@markup.link.label.markdown_inline"] = {
          fg = Highlight.tint(dark_yellow, -0.2),
          bg = Highlight.tint(dark_yellow, -0.8),
          underline = false,
        },
      },

      {
        StatusLine = {
          fg = { from = "Keyword", attr = "fg", alter = 0.4 },
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("StatusLine_esse", "fg"), 0.6, Highlight.get("StatusLine_esse", "bg")),
            -0.5
          ),
        },
      },
      {
        StatusLineNC = {
          fg = { from = "Normal", attr = "bg", alter = 3.3 },
          bg = { from = "Normal", attr = "bg", alter = 0.7 },
        },
      },
      { KeywordBlur = { bg = { from = "StatusLineNC", attr = "bg", alter = 0.4 } } },
      {
        TabLine = {
          fg = { from = "Normal", attr = "bg", alter = 3 },
          bg = { from = "Normal", attr = "bg", alter = 0.36 },
        },
      },
      { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.35 } } },
    },
    ["tokyonight-night"] = {
      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = -0.05 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },

      { BlinkCmpGhostText = { fg = { from = "LineNr", attr = "fg", alter = 0.6 } } },
      { Comment = { fg = { from = "Comment", attr = "fg", alter = 0.8 }, italic = true } },
      { ["@comment"] = { inherit = "Comment" } },
      { ["@org.comment"] = { inherit = "Comment" } },

      { SnacksIndent = { fg = { from = "Normal", attr = "bg", alter = 0.2 } } },
      { SnacksIndentScope = { fg = { from = "Normal", attr = "bg", alter = 0.5 } } },

      { BlinkCmpGhostText = { fg = { from = "LineNr", attr = "fg", alter = 0.5 } } },

      {
        Folded = {
          fg = { from = "Normal", attr = "bg", alter = 0.6 },
          bg = { from = "Normal", attr = "bg", alter = -0.25 },
        },
      },
      { FoldedSign = { fg = { from = "Folded", attr = "fg", alter = -0.05 }, bg = "NONE" } },

      { FzfLuaFilePart = { fg = { from = "Directory", attr = "fg", alter = -0.1 }, reverse = false } },
      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.4 } } },
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

      {
        NoiceCmdline = {
          fg = { from = "Pmenu", attr = "fg", alter = 3.5 },
          bg = { from = "Pmenu", attr = "bg", alter = 0.08 },
        },
      },

      {
        StatusLine = {
          fg = { from = "Keyword", attr = "fg", alter = 0.2 },
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("StatusLine_esse", "bg"), 0.4, Highlight.get("StatusLine_esse", "fg")),
            -0.5
          ),
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
          fg = { from = "Normal", attr = "bg", alter = 2.7 },
          bg = { from = "Normal", attr = "bg", alter = 0.2 },
        },
      },
      { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.35 } } },
    },
    ["tokyonight-storm"] = {
      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = -0.08 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },
      { BlinkCmpGhostText = { fg = { from = "LineNr", attr = "fg", alter = 0.6 } } },

      { Comment = { fg = { from = "Comment", attr = "fg", alter = 1 }, italic = true } },
      { ["@comment"] = { inherit = "Comment" } },
      { ["@org.comment"] = { inherit = "Comment" } },

      { SnacksIndent = { fg = { from = "SnacksIndent", attr = "fg", alter = -0.22 } } },
      { SnacksIndentScope = { fg = { from = "SnacksIndentScope", attr = "fg", alter = -0.2 } } },

      { FzfLuaFilePart = { fg = { from = "Directory", attr = "fg", alter = -0.1 }, reverse = false } },
      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.4 } } },
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

      {
        NoiceCmdline = {
          fg = { from = "Pmenu", attr = "fg", alter = 3.5 },
          bg = { from = "Pmenu", attr = "bg", alter = 0.04 },
        },
      },

      { Visual = { bg = { from = "Visual", attr = "bg", alter = -0.1 } } },

      {
        Folded = {
          fg = { from = "Normal", attr = "bg", alter = 0.2 },
          bg = { from = "Normal", attr = "bg", alter = -0.18 },
        },
      },
      { FoldedSign = { fg = { from = "Folded", attr = "fg", alter = 0.1 }, bg = "NONE" } },

      {
        StatusLine = {
          fg = { from = "Keyword", attr = "fg", alter = 0.4 },
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("StatusLine_esse", "bg"), 0.4, Highlight.get("StatusLine_esse", "fg")),
            -0.4
          ),
        },
      },
      {
        StatusLineNC = {
          fg = { from = "Normal", attr = "bg", alter = 3 },
          bg = { from = "Normal", attr = "bg", alter = 0.55 },
        },
      },
      { KeywordBlur = { bg = { from = "StatusLineNC", attr = "bg", alter = 0.3 } } },
      {
        TabLine = {
          fg = { from = "Normal", attr = "bg", alter = 2.3 },
          bg = { from = "Normal", attr = "bg", alter = 0.2 },
        },
      },
      { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.3 } } },
    },
    ["vscode_modern"] = {
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

      { Conceal = { bg = "None", fg = { from = "Function", attr = "fg", alter = -0.1 } } },

      { Visual = { bg = { from = "Visual", attr = "bg", alter = -0.1 } } },

      { Directory = { fg = "#569cd6", bg = "NONE" } },
      {
        PmenuSel = {
          bg = Highlight.darken(Highlight.get("Normal", "fg"), pmenusel_bg_alter, Highlight.get("Normal", "bg")),
          bold = true,
        },
      },
      {
        FzfLuaSel = {
          fg = "NONE",
          bg = { from = "PmenuSel", attr = "bg", alter = fzfluasel_bg_alter },
        },
      },

      { Search = { fg = { from = "CurSearch", attr = "bg", alter = 1 } } },

      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = -0.1 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },
      { BlinkCmpGhostText = { fg = { from = "LineNr", attr = "fg", alter = 0.6 } } },

      { FzfLuaFilePart = { fg = { from = "Directory", attr = "fg", alter = -0.1 }, reverse = false } },
      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.4 } } },
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 0.2 } } },
      { FzfLuaCursorLine = { bg = { from = "CursorLine", attr = "bg", alter = fzflua_bg_cursorline_alter } } },
      {
        FzfLuaCursorLineNr = {
          fg = { from = "FzfLuaCursorLine", attr = "bg", alter = 0.8 },
          bg = { from = "FzfLuaCursorLine", attr = "bg" },
        },
      },

      {
        ["@markup.link.label.markdown_inline"] = {
          fg = { from = "@markup.link.label.markdown_inline", attr = "fg", alter = 0.2 },
          bg = { from = "@markup.link.label.markdown_inline", attr = "fg", alter = -0.5 },
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

      {
        Comment = {
          fg = { from = "Normal", attr = "bg", alter = 1.5 },
          bg = "NONE",
          italic = true,
          reverse = false,
        },
      },
      { ["@comment"] = { inherit = "Comment" } },
      { ["@org.comment"] = { inherit = "Comment" } },
      { BlinkCmpGhostText = { fg = { from = "Comment", attr = "fg", alter = 0.3 } } },

      {
        Folded = {
          fg = { from = "Normal", attr = "bg", alter = 0.6 },
          bg = { from = "Normal", attr = "bg", alter = -0.18 },
        },
      },
      { FoldedSign = { fg = { from = "Folded", attr = "fg", alter = -0.05 }, bg = "NONE" } },

      { SnacksIndent = { fg = { from = "Normal", attr = "bg", alter = 0.2 } } },
      { SnacksIndentScope = { fg = { from = "SnacksIndentScope", attr = "fg", alter = -0.5 } } },

      { qfFileName = { fg = { from = "Directory", attr = "fg", alter = 0.3 }, bg = "NONE" } },
      { QuickFixFileName = { fg = { from = "Directory", attr = "fg" }, bg = "NONE" } },
      {
        QuickFixLine = {
          bg = { from = "CursorLine", attr = "bg", alter = quickfixline_alter },
          fg = "NONE",
          underline = false,
        },
      },

      { CmpItemAbbrMatchFuzzy = { fg = { from = "GitSignsDelete", attr = "fg" } } },
      { CmpItemAbbrMatch = { fg = { from = "GitSignsDelete", attr = "fg" } } },

      {
        NoiceCmdline = {
          fg = { from = "Pmenu", attr = "fg", alter = 5 },
          bg = { from = "Pmenu", attr = "bg", alter = -0.02 },
        },
      },

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
        StatusLine = {
          fg = { from = "Keyword", attr = "fg", alter = 1 },
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("StatusLine_esse", "bg"), 0.5, Highlight.get("StatusLine_esse", "fg")),
            -0.2
          ),
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
          fg = { from = "Normal", attr = "bg", alter = 2.8 },
          bg = { from = "Normal", attr = "bg", alter = 0.25 },
        },
      },
      { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.3 } } },
    },
    ["zenburned"] = {
      { DiagnosticSignError = { bg = "NONE", fg = Highlight.darken(dark_red, 0.8, Highlight.get("Normal", "bg")) } },
      { DiagnosticSignWarn = { bg = "NONE", fg = Highlight.darken(dark_yellow, 0.8, Highlight.get("Normal", "bg")) } },
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

      { Directory = { fg = "#6099c0", bg = "NONE" } },
      {
        PmenuSel = {
          bg = Highlight.darken(Highlight.get("Normal", "fg"), pmenusel_bg_alter, Highlight.get("Normal", "bg")),
          bold = true,
        },
      },
      {
        FzfLuaSel = {
          fg = "NONE",
          bg = { from = "PmenuSel", attr = "bg", alter = fzfluasel_bg_alter },
        },
      },

      { Visual = { bg = { from = "Visual", attr = "bg", alter = -0.12 } } },

      { LineNr = { fg = { from = "LineNr", attr = "fg", alter = -0.25 } } },
      { LineNrAbove = { link = "LineNr" } },
      { LineNrBelow = { link = "LineNr" } },
      { BlinkCmpGhostText = { fg = { from = "LineNr", attr = "fg", alter = 0.6 } } },

      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = 0.25 } } },

      { Comment = { fg = { from = "Comment", attr = "fg", alter = 1 }, italic = true } },
      { ["@comment"] = { inherit = "Comment" } },
      { ["@org.comment"] = { inherit = "Comment" } },

      { qfFileName = { fg = { from = "Directory", attr = "fg", alter = 0.3 }, bg = "NONE" } },
      { QuickFixFileName = { fg = { from = "Directory", attr = "fg", alter = 0.4 }, bg = "NONE" } },
      { QuickFixLine = { fg = "NONE", underline = false } },

      { SnacksIndent = { fg = { from = "Normal", attr = "bg", alter = 0.12 } } },
      { SnacksIndentScope = { fg = { from = "SnacksIndentScope", attr = "fg", alter = -0.3 } } },

      { FzfLuaFilePart = { fg = { from = "Directory", attr = "fg", alter = 0.2 }, reverse = false } },
      { FzfLuaDirPart = { fg = { from = "Directory", attr = "fg", alter = -0.3 } } },
      { FzfLuaHeaderText = { fg = { from = "LineNr", attr = "fg", alter = -0.05 } } },

      { FzfLuaCursorLine = { fg = "NONE" } },
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

      {
        Search = {
          bg = Highlight.darken(dark_yellow, 0.5, Highlight.get("Normal", "bg")),
          fg = { from = "Normal", attr = "bg" },
        },
      },
      {
        IncSearch = {
          bg = Highlight.darken(dark_yellow, 1.2, Highlight.get("Normal", "bg")),
          fg = { from = "Normal", attr = "bg" },
        },
      },
      { CurSearch = { inherit = "IncSearch", bold = true } },

      {
        Folded = {
          fg = { from = "Normal", attr = "bg", alter = 0.5 },
          bg = { from = "Normal", attr = "bg", alter = -0.13 },
        },
      },
      { FoldedSign = { fg = { from = "Folded", attr = "fg", alter = -0.14 }, bg = "NONE" } },

      {
        NoiceCmdline = {
          fg = { from = "Pmenu", attr = "fg", alter = 5 },
          bg = { from = "Pmenu", attr = "bg", alter = 0.01 },
        },
      },

      {
        LspReferenceText = {
          bg = { from = "Normal", attr = "bg", alter = 0.1 },
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

      {
        StatusLine = {
          fg = { from = "StatusLine", attr = "fg", alter = 0.02 },
          bg = Highlight.tint(
            Highlight.darken(Highlight.get("StatusLine_esse", "bg"), 0.6, Highlight.get("StatusLine_esse", "fg")),
            0.1
          ),
        },
      },
      {
        StatusLineNC = {
          fg = { from = "Normal", attr = "bg", alter = 1.8 },
          bg = { from = "Normal", attr = "bg", alter = 0.34 },
        },
      },
      { KeywordBlur = { bg = { from = "StatusLineNC", attr = "bg", alter = 0.2 } } },
      {
        TabLine = {
          fg = { from = "Normal", attr = "bg", alter = 1.3 },
          bg = { from = "Normal", attr = "bg", alter = 0.15 },
        },
      },
      { MyCodeUsage = { bg = { from = "TabLine", attr = "bg", alter = 0.2 } } },
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
