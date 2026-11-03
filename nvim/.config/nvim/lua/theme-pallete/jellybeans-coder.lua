local M = {}

local P = {
  fg = "#e8e8d3", -- foreground
  bg = "#151515", -- background
  grey = "#888888",
  boulder = "#777777",
  regent = "#9098A0", -- regent_grey
  tundora = "#404040",
  cadet = "#b0b8c0", -- cadet_blue
  perano = "#b0d0f0",
  wewak = "#cc88a3",
  mantis = "#70b950",
  sienna = "#d98870", -- raw_sienna
  smoke = "#99ad6a", -- green_smoke
  biloba = "#c6b6ee", -- biloba_flower
  glory = "#8fbfdc", -- morning_glory
  gold = "#fad07a", -- goldenrod
  cove = "#8197bf", -- ship_cove
  koro = "#e6a75a", -- koromiko
  brandy = "#dad085",
  silver = "#c7c7c7",
  light = "#f0f0f0", -- grey_two
  grey3 = "#333333", -- grey_three
  grey1 = "#1c1c1c", -- grey_one
  error = "#d74545",
  info = "#5f9ecf",
}

local R = {
  keyword = P.cove,
  func = P.gold,
  type = P.koro,
  string = P.smoke,
  escape = P.mantis,
  const = P.sienna,
  param = P.biloba,
  prop = P.cadet,
  builtin = P.wewak,
  preproc = P.glory,
  var = P.fg,
  op = P.regent,
  punct = P.boulder,
  comment = P.grey,
}

M.ansi = {
  P.grey3,
  P.error,
  P.mantis,
  P.brandy,
  P.cove,
  P.wewak,
  P.glory,
  P.silver,
  P.grey,
  "#e87a6a",
  "#afd787",
  P.gold,
  P.perano,
  "#e3a9c0",
  "#b3d6ea",
  P.light,
}

M.term = {
  background = P.bg,
  foreground = P.fg,
  cursor = P.fg,
  cursor_text = P.bg,
  selection_bg = P.tundora,
  selection_fg = P.fg,
  url = P.glory,
  border_active = P.cove,
  border_inactive = P.grey3,
  tab_active_bg = P.tundora,
  tab_active_fg = P.fg,
  tab_inactive_bg = P.grey1,
  tab_inactive_fg = P.grey,
}

function M.on_highlights(hl, _)
  if vim.o.background ~= "dark" then
    return
  end

  local g = {
    Comment = { fg = R.comment, italic = true },
    Constant = { fg = R.const },
    String = { fg = R.string },
    Pmenu = { fg = R.punct },
    Character = "String",
    Number = "Constant",
    Boolean = "Constant",
    Float = "Constant",
    Identifier = { fg = R.var },
    Function = { fg = R.func },
    Statement = { fg = R.keyword },
    Conditional = "Statement",
    Repeat = "Statement",
    Label = "Statement",
    Keyword = "Statement",
    Exception = "Statement",
    Operator = { fg = R.op },
    PreProc = { fg = R.preproc },
    Include = "PreProc",
    Define = "PreProc",
    Macro = "PreProc",
    PreCondit = "PreProc",
    Type = { fg = R.type, bold = true },
    StorageClass = "Statement",
    Structure = "Statement",
    Typedef = "Type",
    Special = { fg = R.builtin },
    SpecialChar = { fg = R.escape },
    SpecialComment = "Comment",
    Debug = "Special",
    Tag = { fg = R.keyword },
    Delimiter = { fg = R.punct },
    Directory = { fg = M.ansi[5] },

    -- Treesitter
    ["@variable"] = { fg = R.var },
    ["@variable.builtin"] = { fg = R.builtin },
    ["@variable.parameter"] = { fg = R.param, italic = true },
    ["@variable.parameter.builtin"] = { fg = R.param, italic = true },
    ["@variable.member"] = { fg = R.prop },
    ["@property"] = { fg = R.prop },
    ["@constant"] = "Constant",
    ["@constant.builtin"] = { fg = R.builtin },
    ["@constant.macro"] = "Constant",
    ["@module"] = { fg = R.preproc },
    ["@module.builtin"] = { fg = R.builtin },
    ["@label"] = "Statement",
    ["@string"] = "String",
    ["@string.escape"] = { fg = R.escape },
    ["@string.regexp"] = { fg = R.escape },
    ["@string.special"] = { fg = R.escape },
    ["@string.special.url"] = { fg = R.preproc, underline = true },
    ["@character"] = "String",
    ["@character.special"] = { fg = R.escape },
    ["@number"] = "Constant",
    ["@number.float"] = "Constant",
    ["@boolean"] = "Constant",
    ["@function"] = "Function",
    ["@function.call"] = { fg = R.func },
    ["@function.builtin"] = { fg = R.builtin },
    ["@function.macro"] = "PreProc",
    ["@function.method"] = "Function",
    ["@function.method.call"] = "@function.call",
    ["@constructor"] = { fg = R.type },
    ["@operator"] = "Operator",
    ["@keyword"] = "Statement",
    ["@keyword.function"] = "Statement",
    ["@keyword.return"] = "Statement",
    ["@keyword.conditional"] = "Statement",
    ["@keyword.repeat"] = "Statement",
    ["@keyword.exception"] = "Statement",
    ["@keyword.modifier"] = "Statement",
    ["@keyword.type"] = "Statement",
    ["@keyword.coroutine"] = "Statement",
    ["@keyword.operator"] = "Statement",
    ["@keyword.import"] = "PreProc",
    ["@keyword.directive"] = "PreProc",
    ["@type"] = "Type",
    ["@type.builtin"] = { fg = R.type, bold = true },
    ["@type.definition"] = "Type",
    ["@attribute"] = { fg = R.preproc },
    ["@attribute.builtin"] = { fg = R.preproc },
    ["@punctuation.delimiter"] = "Delimiter",
    ["@punctuation.bracket"] = "Delimiter",
    ["@punctuation.special"] = "Operator",
    ["@comment"] = "Comment",
    ["@comment.documentation"] = "Comment",
    ["@tag"] = "Tag",
    ["@tag.attribute"] = { fg = R.preproc },
    ["@tag.delimiter"] = "Delimiter",
    ["@markup.heading"] = { fg = R.func, bold = true },
    ["@markup.strong"] = { fg = R.var, bold = true },
    ["@markup.italic"] = { fg = R.var, italic = true },
    ["@markup.strikethrough"] = { fg = R.comment, strikethrough = true },
    ["@markup.link"] = { fg = R.preproc },
    ["@markup.link.url"] = { fg = R.preproc, underline = true },
    ["@markup.raw"] = { fg = R.string },
    ["@markup.list"] = { fg = R.keyword },
    ["@markup.quote"] = "Comment",

    -- LSP semantic tokens
    ["@lsp.type.namespace"] = "@module",
    ["@lsp.type.type"] = "@type",
    ["@lsp.type.class"] = "@type",
    ["@lsp.type.enum"] = "@type",
    ["@lsp.type.interface"] = "@type",
    ["@lsp.type.struct"] = "@type",
    ["@lsp.type.typeParameter"] = "@type",
    ["@lsp.type.parameter"] = "@variable.parameter",
    ["@lsp.type.variable"] = "@variable",
    ["@lsp.type.property"] = "@property",
    ["@lsp.type.enumMember"] = "@constant",
    ["@lsp.type.function"] = "@function",
    ["@lsp.type.method"] = "@function.method",
    ["@lsp.type.macro"] = "@function.macro",
    ["@lsp.type.decorator"] = "@attribute",
    ["@lsp.type.comment"] = "@comment",
  }

  for name, spec in pairs(g) do
    hl[name] = spec
  end
end

function M.opts()
  return {
    italics = true,
    bold = true,
    on_highlights = M.on_highlights,
  }
end

return M
