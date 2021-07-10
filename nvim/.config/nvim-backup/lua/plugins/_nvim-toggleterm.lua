local termtoggle = require("toggleterm")

termtoggle.setup({
  size = 30,
  open_mapping = [[<c-\>]],
  shade_filetypes = {},
  shade_terminals = true,
  -- the degree by which to darken to terminal colour,
  -- default: 1 for dark backgrounds, 3 for light
  shading_factor = "<number>",
  start_in_insert = true,
  persist_size = true,
  direction = "horizontal", -- horizontal | vertical
})
