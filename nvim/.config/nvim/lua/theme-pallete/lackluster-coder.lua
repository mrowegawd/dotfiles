local M = {}

M.background = "#050505"

local C = {
  luster = "#deeeed",
  lack = "#708090",
  green = "#789978",
  blue = "#7788AA",
  yellow = "#abab77",
  gray3 = "#2a2a2a",
  gray4 = "#444444",
  gray6 = "#7a7a7a",
  gray7 = "#aaaaaa",
  gray8 = "#cccccc",
  param = "#8E8E8E",
  dim = "#666666",
}

M.ansi = {
  C.gray3,
  "#E14040",
  C.green,
  C.yellow,
  C.blue,
  "#A890B0",
  "#6F9A9A",
  C.gray8,
  C.gray6,
  "#EB8080",
  "#9AB29A",
  "#C0C099",
  "#99A6BF",
  "#C4B4CA",
  "#94B8B8",
  C.luster,
}

M.term = {
  background = M.background,
  foreground = C.gray8,
  cursor = C.luster,
  cursor_text = M.background,
  selection_bg = C.gray4,
  selection_fg = C.luster,
  url = C.blue,
  border_active = C.lack,
  border_inactive = C.gray3,
  tab_active_bg = "#191919",
  tab_active_fg = C.luster,
  tab_inactive_bg = M.background,
  tab_inactive_fg = C.gray6,
}

function M.opts()
  return {
    tweak_background = { normal = M.background },
    tweak_syntax = {
      comment = C.gray6,
      builtin = C.gray6,
      keyword = C.param,
      keyword_return = C.gray8,
      keyword_exception = C.blue,
      type = C.green,
    },
    tweak_highlight = {
      ["@keyword"] = { bold = true },
      ["@keyword.return"] = { bold = true },
      ["@keyword.exception"] = { bold = true },
      ["@function"] = { bold = true },
      ["@function.method"] = { bold = true },
      ["@type.definition"] = { bold = true },
      Comment = { italic = true },
      ["@comment"] = { italic = true },
      ["@comment.documentation"] = { italic = true },
      ["@variable.parameter"] = { italic = true },

      Function = { fg = C.gray7 },
      ["@function.call"] = { fg = C.gray7 },
      ["@function.method.call"] = { fg = C.gray7 },

      ["@variable.member"] = { fg = C.param },
      ["@property"] = { fg = C.param },

      Constant = { fg = C.yellow },
      ["@constant"] = { fg = C.yellow },
      ["@constant.builtin"] = { fg = C.yellow },
      ["@number"] = { fg = C.yellow },
      ["@boolean"] = { fg = C.yellow },

      ["@type.builtin"] = { fg = C.green },
      Identifier = { fg = C.gray7 },

      Operator = { fg = C.dim },
      Delimiter = { fg = C.dim },
      ["@operator"] = { fg = C.dim },
      ["@punctuation.bracket"] = { fg = C.dim },
      ["@punctuation.special"] = { fg = C.dim },
      ["@punctuation.delimiter"] = { fg = C.dim },

      ["@tag"] = { fg = C.param },
      ["@tag.builtin"] = { fg = C.param },
      htmlTagName = { fg = C.param },
      ["@tag.delimiter"] = { fg = C.dim },
      ["@tag.attribute"] = { fg = C.gray6 },
      xmlTag = { fg = C.gray6 },
      xmlTagName = { fg = C.gray6 },
      xmlAttrib = { fg = C.dim },

      ["@markup.strong"] = { fg = C.gray8, bold = true },
      ["@markup.italic"] = { fg = C.gray8, italic = true },
      ["@markup.strikethrough"] = { fg = C.dim, strikethrough = true },
      ["@markup.list"] = { fg = C.param },
      ["@markup.link.url"] = { fg = C.gray6 },

      Folded = { fg = C.gray6 },

      Directory = { fg = M.ansi[5] },
    },
  }
end

return M
