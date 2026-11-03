local M = {}

M.opts = {
  flavour = "mocha",
  transparent_background = false,
  term_colors = true,
  italic_conditionals = false,
  italic_params = true,
  bold_definitions = true,
  brighter_comments = true,
  catppuccin = {},
}

function M.build(user_opts)
  local o = vim.tbl_deep_extend("force", M.opts, user_opts or {})

  local config = {
    flavour = o.flavour,
    transparent_background = o.transparent_background,
    term_colors = o.term_colors,

    styles = {
      comments = { "italic" },
      conditionals = o.italic_conditionals and { "italic" } or {},
      loops = {},
      functions = {},
      keywords = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = { "bold" },
      properties = {},
      types = {},
      operators = {},
    },

    integrations = {
      blink_cmp = { style = "bordered" },
      gitsigns = true,
      neotree = true,
      grug_far = true,
      which_key = true,
      snacks = { enabled = true, indent_scope_color = "lavender" },
    },

    custom_highlights = function(c)
      local bold = { "bold" }
      local italic = { "italic" }

      local hl = {
        -------------------------------------------------------------- UI --
        MatchParen = { fg = c.peach, bg = c.surface1, style = bold },
        Whitespace = { fg = c.surface1 },
        NonText = { fg = c.surface1 },
        SpecialKey = { fg = c.surface1 },
        Todo = { fg = c.crust, bg = c.yellow, style = bold },

        PmenuMatch = { fg = c.peach, style = bold },
        PmenuMatchSel = { fg = c.peach, style = bold },
        BlinkCmpLabelMatch = { fg = c.peach, style = bold },
        SnacksPickerMatch = { fg = c.peach, style = bold },
        GitSignsCurrentLineBlame = { fg = c.overlay0, style = italic },

        ------------------------------------------------------------ Syntax --
        -- Control flow
        Conditional = { fg = c.mauve, style = bold },
        Repeat = { fg = c.mauve, style = bold },
        Exception = { fg = c.mauve, style = bold },
        ["@keyword.conditional"] = { fg = c.mauve, style = bold },
        ["@keyword.repeat"] = { fg = c.mauve, style = bold },
        ["@keyword.exception"] = { fg = c.mauve, style = bold },
        ["@keyword.return"] = { fg = c.red, style = bold },
        ["@keyword.import"] = { fg = c.teal },
        Include = { fg = c.teal },

        -- Value: string / number / constant / boolean
        ["@number"] = { fg = c.peach },
        ["@number.float"] = { fg = c.peach },
        ["@constant"] = { fg = c.flamingo },
        ["@constant.builtin"] = { fg = c.pink, style = bold }, -- nil, null, None
        ["@boolean"] = { fg = c.pink, style = bold },
        ["@string.escape"] = { fg = c.pink, style = bold },
        ["@string.regexp"] = { fg = c.pink },
        ["@string.special.url"] = { fg = c.blue, style = { "underline" } },

        -- Function
        ["@function"] = { fg = c.blue, style = o.bold_definitions and bold or {} },
        ["@function.method"] = { fg = c.blue, style = o.bold_definitions and bold or {} },
        ["@function.call"] = { fg = c.blue },
        ["@function.method.call"] = { fg = c.blue },
        ["@function.builtin"] = { fg = c.teal },

        ["@variable.parameter"] = { fg = c.maroon, style = o.italic_params and italic or {} },
        ["@variable.builtin"] = { fg = c.red, style = italic }, -- self, this

        -- Comments
        Comment = { fg = o.brighter_comments and c.overlay1 or c.overlay0, style = italic },
        ["@comment"] = { link = "Comment" },
        ["@comment.documentation"] = { fg = c.overlay2, style = italic },
        ["@string.documentation"] = { fg = c.overlay2, style = italic },
        ["@comment.todo"] = { fg = c.crust, bg = c.yellow, style = bold },
        ["@comment.note"] = { fg = c.crust, bg = c.blue, style = bold },
        ["@comment.warning"] = { fg = c.crust, bg = c.peach, style = bold },
        ["@comment.error"] = { fg = c.crust, bg = c.red, style = bold },

        ["@markup.raw"] = { fg = c.teal, bg = c.mantle },

        ------------------------------------------------------------- LSP ---
        DiagnosticUnnecessary = { fg = c.overlay0 },
        DiagnosticDeprecated = { sp = c.red, style = { "strikethrough" } },
        LspSignatureActiveParameter = { fg = c.peach, style = { "underline" } },
      }

      return hl
    end,
  }

  return vim.tbl_deep_extend("force", config, o.catppuccin)
end

function M.setup(user_opts)
  require("catppuccin").setup(M.build(user_opts))
end

return M
