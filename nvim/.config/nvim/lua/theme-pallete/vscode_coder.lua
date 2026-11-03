local M = {}

M.color_overrides = {
  vscLineNumber = "#888888",
  vscSuggestion = "#7F7F7F",
  vscViolet = "#9093D6",
  vscCursorDarkDark = "#2D2D2D",
  vscSearch = "#6B4E12",
}

M.group_overrides = {
  ["@constant"] = { fg = "#FF9E64" },

  Normal = { bg = "#191919", fg = "#d4d4d4" },

  FloatBorder = { bg = "#0f0f0f", fg = "#2d2d2d" },

  Number = { fg = "#C3E88D" },
  Folded = { fg = "#344037" },
  FloatTitle = { fg = "#C3E88D" },
  Float = { fg = "#C3E88D" },
  ["@number"] = { fg = "#C3E88D" },
  ["@number.float"] = { fg = "#C3E88D" },

  Special = { fg = "#E5C07B" },

  ["@module"] = { fg = "#D0D0D0" },

  ["@type.builtin"] = { fg = "#4EC9B0" },

  ["@variable.parameter"] = { fg = "#9CDCFE", italic = true },
  ["@variable.parameter.reference"] = { fg = "#9CDCFE", italic = true },

  ["@lsp.type.comment.c"] = { link = "@comment" },
  ["@lsp.type.comment.cpp"] = { link = "@comment" },

  IncSearch = { fg = "#1F1F1F", bg = "#E5B045", bold = true },
  MatchParen = { fg = "#FFD602", bg = "#3A3D41", bold = true },

  Whitespace = { fg = "#4A4A4A" },
  NonText = { fg = "#4A4A4A" },

  DiagnosticHint = { fg = "#8FA8C0" },
  DiagnosticUnderlineHint = { undercurl = true, sp = "#8FA8C0" },
}

M.term = {
  background = "#1F1F1F",
  foreground = "#D4D4D4",
  cursor = "#AEAFAD",
  cursor_text = "#1F1F1F",
  selection_bg = "#264F78",
  selection_fg = "#D4D4D4",
  url = "#4FC1FF",
  border_active = "#569CD6",
  border_inactive = "#444444",
  tab_active_bg = "#1F1F1F",
  tab_active_fg = "#FFFFFF",
  tab_inactive_bg = "#2D2D2D",
  tab_inactive_fg = "#9D9D9D",
}

M.ansi = {
  "#2D2D2D",
  "#F44747",
  "#73C991",
  "#E5C07B",
  "#569CD6",
  "#C586C0",
  "#4EC9B0",
  "#D4D4D4",
  "#888888",
  "#FF7A7A",
  "#9BE0A8",
  "#F2D69B",
  "#7FB8EE",
  "#DDA8DA",
  "#7EE0CB",
  "#FFFFFF",
}

return M
