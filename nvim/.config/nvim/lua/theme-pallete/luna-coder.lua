local M = {}

M.opts = {
  transparent = false,
  accent = 1.0,
  italic_params = true,
  bold_definitions = true,
  bold_control_flow = true,
  brighter_comments = true,
  terminal_colors = true,
  luna = {},
}

M.ansi = {
  "#333333",
  "#e08585",
  "#6fbe80",
  "#d9a35a",
  "#75a1c7",
  "#c4a8d6",
  "#86b3ac",
  "#c7c7c7",
  "#888888",
  "#e69d9d",
  "#8ccb99",
  "#e1b57b",
  "#91b4d2",
  "#d0b9de",
  "#9ec2bd",
  "#f0f0f0",
}

local function blend(fg, bg, alpha)
  local function rgb(hex)
    hex = hex:gsub("#", "")
    return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
  end
  local fr, fg_, fb = rgb(fg)
  local br, bg_, bb = rgb(bg)
  local function mix(a, b)
    return math.floor(a * alpha + b * (1 - alpha) + 0.5)
  end
  return string.format("#%02x%02x%02x", mix(fr, br), mix(fg_, bg_), mix(fb, bb))
end

local function set(hl, group, spec)
  if spec.link then
    hl[group] = { link = spec.link }
    return
  end
  local base = type(hl[group]) == "table" and vim.deepcopy(hl[group]) or {}
  base.link = nil
  hl[group] = vim.tbl_extend("force", base, spec)
end

local function highlights(hl, c, o)
  local bold, italic = true, true

  local groups = {
    ---------------------------------------------------------------- UI ----
    MatchParen = { fg = c.cream, bg = c.selection, bold = true },
    Whitespace = { fg = c.surface },
    NonText = { fg = c.surface },
    SpecialKey = { fg = c.surface },
    Todo = { fg = c.bg, bg = c.warning, bold = true },

    PmenuMatch = { fg = c.keyword, bold = true },
    PmenuMatchSel = { fg = c.keyword, bold = true },
    BlinkCmpLabelMatch = { fg = c.keyword, bold = true },
    SnacksPickerMatch = { fg = c.keyword, bold = true },
    GitSignsCurrentLineBlame = { fg = c.comment, italic = italic },

    ----------------------------------------------------------- Syntax ----
    Comment = { fg = c.comment, italic = italic },
    ["@comment"] = { link = "Comment" },
    ["@comment.documentation"] = { fg = c.grey_light, italic = italic },
    ["@string.documentation"] = { fg = c.grey_light, italic = italic },
    ["@comment.todo"] = { fg = c.bg, bg = c.warning, bold = bold },
    ["@comment.note"] = { fg = c.bg, bg = c.func, bold = bold },
    ["@comment.warning"] = { fg = c.bg, bg = c.keyword, bold = bold },
    ["@comment.error"] = { fg = c.bg, bg = c.error, bold = bold },

    -- Control flow
    Conditional = { fg = c.keyword, bold = o.bold_control_flow },
    Repeat = { fg = c.keyword, bold = o.bold_control_flow },
    Exception = { fg = c.keyword, bold = o.bold_control_flow },
    ["@keyword.conditional"] = { fg = c.keyword, bold = o.bold_control_flow },
    ["@keyword.repeat"] = { fg = c.keyword, bold = o.bold_control_flow },
    ["@keyword.exception"] = { fg = c.keyword, bold = o.bold_control_flow },
    ["@keyword.return"] = { fg = c.error, bold = bold },
    ["@keyword.import"] = { fg = c.info },
    Include = { fg = c.info },
    ["@attribute"] = { fg = c.info },
    ["@attribute.builtin"] = { fg = c.info },

    -- Value
    Number = { fg = c.cream },
    Float = { fg = c.cream },
    ["@number"] = { fg = c.cream },
    ["@number.float"] = { fg = c.cream },
    Boolean = { fg = c.type, bold = bold },
    ["@boolean"] = { fg = c.type, bold = bold },
    ["@constant.builtin"] = { fg = c.type, bold = bold }, -- nil, null, None
    ["@string.escape"] = { fg = c.cream, bold = bold },
    ["@string.regexp"] = { fg = c.cream },
    ["@string.special.url"] = { fg = c.func, underline = true },

    -- Function
    ["@function"] = { fg = c.func, bold = o.bold_definitions },
    ["@function.method"] = { fg = c.func, bold = o.bold_definitions },
    ["@function.call"] = { fg = c.func, bold = false },
    ["@function.method.call"] = { fg = c.func, bold = false },
    ["@function.builtin"] = { fg = c.func, italic = italic },

    ["@variable.parameter"] = { fg = c.fg, italic = o.italic_params },
    ["@variable.builtin"] = { fg = c.signal, italic = italic }, -- self, this
    ["@variable.member"] = { fg = c.silver },
    ["@property"] = { fg = c.silver },

    Operator = { fg = c.grey_light },
    ["@operator"] = { fg = c.grey_light },
    Delimiter = { fg = c.grey },
    ["@punctuation.delimiter"] = { fg = c.grey },
    ["@punctuation.bracket"] = { fg = c.grey_light },

    -- Markdown
    ["@markup.heading.1"] = { fg = c.keyword, bold = bold },
    ["@markup.heading.2"] = { fg = c.func, bold = bold },
    ["@markup.heading.3"] = { fg = c.type, bold = bold },
    ["@markup.heading.4"] = { fg = c.string, bold = bold },
    ["@markup.heading.5"] = { fg = c.silver, bold = bold },
    ["@markup.heading.6"] = { fg = c.silver, bold = bold },
    ["@markup.raw"] = { fg = c.cream, bg = c.bg_alt },

    ------------------------------------------------------------- LSP -----
    LspReferenceText = { bg = blend(c.func, c.bg, 0.14) },
    LspReferenceRead = { bg = blend(c.func, c.bg, 0.14) },
    LspReferenceWrite = { bg = blend(c.func, c.bg, 0.14), underline = true },
    LspInlayHint = { fg = c.comment, bg = blend(c.grey, c.bg, 0.10), italic = italic },
    LspSignatureActiveParameter = { fg = c.keyword, underline = true },

    DiagnosticVirtualTextError = { fg = c.error, bg = blend(c.error, c.bg, 0.12) },
    DiagnosticVirtualTextWarn = { fg = c.warning, bg = blend(c.warning, c.bg, 0.12) },
    DiagnosticVirtualTextInfo = { fg = c.info, bg = blend(c.info, c.bg, 0.12) },
    DiagnosticVirtualTextHint = { fg = c.hint, bg = blend(c.hint, c.bg, 0.12) },
    DiagnosticUnnecessary = { fg = c.grey_warm }, -- unused var / import
    DiagnosticDeprecated = { sp = c.error, strikethrough = true },
  }

  for group, spec in pairs(groups) do
    set(hl, group, spec)
  end

  if o.terminal_colors then
    for i, color in ipairs(M.ansi) do
      vim.g["terminal_color_" .. (i - 1)] = color
    end
  end
end

function M.setup(user_opts)
  local o = vim.tbl_deep_extend("force", M.opts, user_opts or {})

  local config = {
    transparent = o.transparent,
    accent = o.accent,
    on_colors = function(c)
      if o.brighter_comments then
        c.comment = c.grey -- #7c7c7c -> #888888
      end
    end,
    on_highlights = function(hl, c)
      highlights(hl, c, o)
    end,
  }

  require("luna").setup(vim.tbl_deep_extend("force", config, o.luna))
end

return M
