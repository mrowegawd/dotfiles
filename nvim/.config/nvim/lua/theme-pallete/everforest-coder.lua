local M = {}

M.setup = {
  background = "hard",
  -- italics = true,
  -- disable_italic_comments = true,
  ui_contrast = "high",
  sign_column_background = "none",
  float_style = "bright",
  diagnostic_virtual_text = "coloured",

  colours_override = function(palette)
    palette.bg_dim = "#171c1f"
    palette.bg0 = "#1b2023"
    palette.bg1 = "#252d30"
    palette.bg2 = "#2d373a"
    palette.bg3 = "#394448"

    palette.fg = "#d3c6aa"
    palette.grey0 = "#859289"
    palette.grey1 = "#9da9a0"
    palette.grey2 = "#b7c4b0"

    palette.red = "#f07178"
    palette.orange = "#e69875"
    palette.yellow = "#dbbc7f"
    palette.green = "#a7c080"
    palette.aqua = "#83c092"
    palette.blue = "#7fbbb3"
    palette.purple = "#d699b6"
  end,

  on_highlights = function(hl, palette)
    local none = "NONE"

    -- Main editor
    hl.Normal = { fg = "#d3c6aa", bg = "#1b2023" }
    hl.NormalNC = { fg = "#c5c8b5", bg = "#1b2023" }
    hl.NormalFloat = { fg = "#d3c6aa", bg = "#252d30" }
    hl.FloatBorder = { fg = "#7fbbb3", bg = "#252d30" }
    hl.FloatTitle = { fg = "#a7c080", bg = "#252d30", bold = true }

    -- Cursor and navigation
    hl.CursorLine = { bg = "#252d30" }
    hl.CursorLineNr = { fg = "#dbbc7f", bg = "#252d30", bold = true }
    hl.LineNr = { fg = "#6f7f78" }
    hl.SignColumn = { bg = none }
    hl.ColorColumn = { bg = "#252d30" }
    hl.Visual = { bg = "#394448" }
    hl.Search = { fg = "#1b2023", bg = "#dbbc7f", bold = true }
    hl.IncSearch = { fg = "#1b2023", bg = "#f07178", bold = true }
    hl.MatchParen = { fg = "#dbbc7f", bold = true, underline = true }

    -- Syntax: traditional vim highlight groups
    hl.Comment = { fg = "#9da9a0" }
    hl.Constant = { fg = "#d699b6" }
    hl.String = { fg = "#a7c080" }
    hl.Character = { fg = "#a7c080" }
    hl.Number = { fg = "#d699b6" }
    hl.Boolean = { fg = "#e69875", bold = true }
    hl.Float = { fg = "#d699b6" }

    hl.Identifier = { fg = "#d3c6aa" }
    hl.Function = { fg = "#a7c080", bold = true }

    hl.Statement = { fg = "#f07178" }
    hl.Conditional = { fg = "#f07178" }
    hl.Repeat = { fg = "#f07178" }
    hl.Keyword = { fg = "#f07178" }
    hl.Operator = { fg = "#83c092" }
    hl.Exception = { fg = "#f07178" }

    hl.PreProc = { fg = "#e69875" }
    hl.Include = { fg = "#e69875" }
    hl.Define = { fg = "#e69875" }
    hl.Macro = { fg = "#e69875" }

    hl.Type = { fg = "#7fbbb3" }
    hl.StorageClass = { fg = "#7fbbb3" }
    hl.Structure = { fg = "#7fbbb3" }
    hl.Typedef = { fg = "#7fbbb3" }

    hl.Special = { fg = "#83c092" }
    hl.SpecialChar = { fg = "#e69875" }
    hl.Delimiter = { fg = "#a09986" }
    hl.Underlined = { fg = "#7fbbb3", underline = true }
    hl.Error = { fg = "#f07178", bold = true }
    hl.Todo = { fg = "#1b2023", bg = "#dbbc7f", bold = true }

    -- Treesitter
    hl["@variable"] = { fg = "#d3c6aa" }
    hl["@variable.builtin"] = { fg = "#e69875" }
    hl["@variable.parameter"] = { fg = "#e2c792" }
    hl["@property"] = { fg = "#83c092" }
    hl["@field"] = { fg = "#83c092" }

    hl["@function"] = { fg = "#a7c080", bold = true }
    hl["@function.call"] = { fg = "#a7c080" }
    hl["@function.method"] = { fg = "#a7c080", bold = true }
    hl["@function.method.call"] = { fg = "#a7c080" }
    hl["@function.builtin"] = { fg = "#83c092" }

    hl["@keyword"] = { fg = "#f07178" }
    hl["@keyword.function"] = { fg = "#f07178", bold = true }
    hl["@keyword.return"] = { fg = "#f07178", bold = true }
    hl["@keyword.operator"] = { fg = "#e69875" }
    hl["@conditional"] = { fg = "#f07178" }
    hl["@repeat"] = { fg = "#f07178" }

    hl["@string"] = { fg = "#a7c080" }
    hl["@string.escape"] = { fg = "#e69875", bold = true }
    hl["@character"] = { fg = "#a7c080" }
    hl["@number"] = { fg = "#d699b6" }
    hl["@boolean"] = { fg = "#e69875", bold = true }
    hl["@constant"] = { fg = "#d699b6" }
    hl["@constant.builtin"] = { fg = "#e69875" }

    hl["@type"] = { fg = "#7fbbb3" }
    hl["@type.builtin"] = { fg = "#7fbbb3", italic = false }
    hl["@constructor"] = { fg = "#7fbbb3" }
    hl["@module"] = { fg = "#7fbbb3" }
    hl["@operator"] = { fg = "#83c092" }
    hl["@punctuation.bracket"] = { fg = "#b7c4b0" }
    hl["@punctuation.delimiter"] = { fg = "#a09986" }

    hl["@comment"] = { fg = "#9da9a0" }
    hl["@comment.todo"] = { fg = "#1b2023", bg = "#dbbc7f", bold = true }

    -- Diagnostics
    hl.DiagnosticError = { fg = "#f07178" }
    hl.DiagnosticWarn = { fg = "#dbbc7f" }
    hl.DiagnosticInfo = { fg = "#7fbbb3" }
    hl.DiagnosticHint = { fg = "#a7c080" }

    hl.DiagnosticVirtualTextError = { fg = "#f07178", bg = "#302528" }
    hl.DiagnosticVirtualTextWarn = { fg = "#dbbc7f", bg = "#302d24" }
    hl.DiagnosticVirtualTextInfo = { fg = "#7fbbb3", bg = "#252d30" }
    hl.DiagnosticVirtualTextHint = { fg = "#a7c080", bg = "#252d30" }

    -- Completion
    hl.Pmenu = { fg = "#d3c6aa", bg = "#252d30" }
    hl.PmenuSel = { fg = "#1b2023", bg = "#a7c080", bold = true }
    hl.PmenuSbar = { bg = "#2d373a" }
    hl.PmenuThumb = { bg = "#7fbbb3" }

    -- Diff
    hl.DiffAdd = { fg = "#a7c080", bg = "#253128" }
    hl.DiffChange = { fg = "#dbbc7f", bg = "#302e25" }
    hl.DiffDelete = { fg = "#f07178", bg = "#302528" }
    hl.DiffText = { fg = "#e2c792", bg = "#45402e", bold = true }

    hl.GitSignsAdd = { fg = "#a7c080" }
    hl.GitSignsChange = { fg = "#dbbc7f" }
    hl.GitSignsDelete = { fg = "#f07178" }
  end,
}

return M
