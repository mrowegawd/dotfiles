local gitsigns = require("gitsigns")

gitsigns.setup({
  signs = {
    add = {
      hl = "SignifySignAdd",
      text = "＋",
      numhl = "GitSignsAddNr",
      linehl = "GitSignsAddLn",
    },
    change = {
      hl = "SignifySignChange",
      text = "m",
      numhl = "GitSignsChangeNr",
      linehl = "GitSignsChangeLn",
    },
    delete = {
      hl = "SignifySignDelete",
      text = "～",
      numhl = "GitSignsDeleteNr",
      linehl = "GitSignsDeleteLn",
    },
    topdelete = {
      hl = "SignifySignDelete",
      text = "‾",
      numhl = "GitSignsDeleteNr",
      linehl = "GitSignsDeleteLn",
    },
    changedelete = {
      hl = "SignifySignChange",
      text = "～",
      numhl = "GitSignsChangeNr",
      linehl = "GitSignsChangeLn",
    },
  },
  numhl = false,
  linehl = false,
  keymaps = {
    -- Default keymap options
    noremap = true,
    buffer = true,

    ["n <A-Down>"] = {
      expr = true,
      "&diff ? '<A-Down' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'",
    },
    ["n <A-Up>"] = {
      expr = true,
      "&diff ? '<A-Up' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'",
    },

    ["n <localleader>ga"] = "<cmd>lua require\"gitsigns\".stage_hunk()<CR>",
    ["n <localleader>gU"] = "<cmd>lua require\"gitsigns\".undo_stage_hunk()<CR>",
    ["n <localleader>gr"] = "<cmd>lua require\"gitsigns\".reset_hunk()<CR>",
    ["n <localleader>gR"] = "<cmd>lua require\"gitsigns\".reset_buffer()<CR>",
    ["n <localleader>gP"] = "<cmd>lua require\"gitsigns\".preview_hunk()<CR>",
    ["n <localleader>gb"] = "<cmd>lua require\"gitsigns\".blame_line()<CR>",

    -- Text objects
    ["o ih"] = ":<C-U>lua require\"gitsigns\".select_hunk()<CR>",
    ["x ih"] = ":<C-U>lua require\"gitsigns\".select_hunk()<CR>",
  },
  watch_index = {
    interval = 1000,
  },
  current_line_blame = false,
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  use_decoration_api = true,
  use_internal_diff = true, -- If luajit is present
})
