local M = {}

M.border = {
  rectangle = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
  line = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
  rightsideonly = { "", "", "", "", "", "", "", "│" },
}

M.status = {
  success = "󰄴", -- statt ✅
  error = "󰅚", -- statt ❌
  warning = "", -- statt ⚠️
  loading = "󰝲", -- statt 🔄
  sync = "", -- statt 🔄 (Sync-Variante)
  info = "󰋼", -- statt ℹ️
  hint = "󰌶", -- statt 💡
  warn = "", -- alias für warning
  gear = "", -- alias für gear
  rocket = "", -- für Performance-Status
  list = "", -- Liste
  vim = "",
  neovim = "",
  health = "󰓙", -- MINIMAL ERGÄNZUNG
  update = "󰚰", -- MINIMAL ERGÄNZUNG
  current = "", -- MINIMAL ERGÄNZUNG
  trend_down = "󰔳", -- MINIMAL ERGÄNZUNG

  search = "", -- Suche

  stats = "󰋖", -- Statistiken
  config = "", -- Konfiguration
}

M.misc = {
  ai = "  ",
  dots = "󰇘",
  arrow_right = " ",
  block = "▌ ",

  bookmark = " ",
  org = " ",
  norg = " ",
  markdown = "󰍔 ",

  marks = "📌",
  flags = "🚩",
  cross_sign = "❌",
  checklist = "✅",

  bug = " ", --  'ﴫ'
  calendar = " ",
  caret_right = " ",
  check = " ",
  check_big = " ",
  chevron_right = " ",
  circle = " ",
  clock = " ",
  close = " ",
  boldclose = " ",
  modified = "✘ ",
  largeclose = " ",
  code = " ",
  comment = " ",
  dashboard = " ",
  double_chevron_right = "» ",
  down = "⇣ ",
  ellipsis = "… ",
  fire = " ",
  gear = " ",
  history = " ",
  indent = "Ξ ",
  lightbulb = " ",
  line = "ℓ ", -- ''
  list = " ",
  lock = " ",
  todo = " ",
  note = " ",
  -- note = " ",
  package = "  ",
  pencil = " ", -- '',
  plus = " ",
  project = " ",
  folder = " ",
  session = "󰅟 ",
  question = " ",
  robot = "ﮧ ",
  search = " ",
  readonly = "󰌾 ",
  shaded_lock = " ",
  sign_in = " ",
  sign_out = " ",
  smiley = "ﲃ ",
  squirrel = " ",
  tab = "⇥ ",
  table = " ",
  telescope = " ",
  telescope2 = " ",
  telescope3 = " ",
  terminal = " ",
  terminal2 = " ",
  tools = " ",
  up = "⇡ ",
  lsp = " ",

  Neovim = " ",
  Vim = " ",

  tag = " ",
  watch = " ",
  run_program = "省",

  separator_up = "",
  separator_down = "",

  separator_leg_down = "",
  separator_leg_up = "",

  separator_leg_left = "",
  -- "" },

  separator_hed_down = "",
  separator_hed_up = "",

  vertical_bar = "│",
  dashed_bar = "┊",
}

M.dap = {
  Stopped = "󰁕 ",
  Breakpoint = " ",
  BreakpointCondition = " ",
  BreakpointRejected = " ",
  LogPoint = ".>",
  Pause = " ",
  Play = " ",
  Step_into = " ",
  Step_over = " ",
  Step_out = " ",
  Step_back = " ",
  Run_last = " ",
  Terminate = " ",
  Debug = " ",
  Trace = "✎ ",
}

M.diagnostics = {
  Error = " ",
  Warn = " ",
  Hint = " ",
  -- Question = " ",
  Info = " ",
}
M.documents = {
  file = "",
  files = "",
  folder = "",
  openfolder = "",
  emptyfolder = "",
  emptyopenfolder = "",
  unknown = "",
  symlink = "",
  foldersymlink = "",
}

M.git = {
  added = " ",
  modified = " ",
  removed = " ",
  untrack = " ",
  unmerged = " ",

  add = " ", -- ' ',
  mod = " ",
  remove = " ", -- ' '
  ignore = " ",
  rename = " ",
  diff = " ",
  repo = " ",
  logo = " ",
  branch = " ",
}

M.kinds = {
  Array = " ",
  Boolean = "󰨙 ",
  Class = " ",
  Codeium = " ",
  Color = " ",
  Control = " ",
  Collapsed = " ",
  Constant = "󰏿 ",
  Component = "󰅴 ",
  Constructor = " ",
  Copilot = " ",
  Enum = " ",
  EnumMember = " ",
  Event = " ",
  Field = "󰜢 ",
  File = " ",
  Folder = "󰉋 ",
  Fragment = "󰅴 ",
  Function = "󰊕 ",
  Interface = " ",
  Key = " ",
  Keyword = " ",
  Macro = "󰁚 ",
  Method = "󰆧 ",
  Module = " ",
  Namespace = "󰦮 ",
  Null = " ",
  Number = "󰎠 ",
  Object = " ",
  Operator = " ",
  Package = " ",
  Property = " ",
  Reference = " ",
  Snippet = " ",
  String = " ",
  Struct = "󰙅 ",
  TabNine = "󰏚 ",
  Text = "󰉿 ",
  TypeAlias = " ",
  TypeParameter = " ",
  Unit = " ",
  Value = "󰎟 ",
  Variable = "󰀫 ",
}

return M
