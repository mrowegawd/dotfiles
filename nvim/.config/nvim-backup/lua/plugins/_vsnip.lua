local remap = vim.api.nvim_set_keymap

remap(
  "i",
  "<C-f>",
  "vsnip#jumpable(1) ? \"<Plug>(vsnip-jump-next)\" : \"<C-f>\"",
  { silent = true, expr = true }
)
remap(
  "s",
  "<C-f>",
  "vsnip#jumpable(1) ? \"<Plug>(vsnip-jump-next)\" : \"<C-f>\"",
  { silent = true, expr = true }
)
remap(
  "i",
  "<C-b>",
  "vsnip#jumpable(-1) ? \"<Plug>(vsnip-jump-prev)\" : \"<C-b>\"",
  { silent = true, expr = true }
)
remap(
  "s",
  "<C-b>",
  "vsnip#jumpable(-1) ? \"<Plug>(vsnip-jump-prev)\" : \"<C-b>\"",
  { silent = true, expr = true }
)
