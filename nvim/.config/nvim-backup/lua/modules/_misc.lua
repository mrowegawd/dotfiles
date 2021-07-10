-- highlight yanked text for 250ms
vim.cmd([[au TextYankPost * silent! lua vim.highlight.on_yank{ timeout = 250 }]])

-- disable git messenger default mappings
vim.g.git_messenger_no_default_mappings = true

-- TODO: Create toggle for debugging lsp
-- To debug
-- vim.lsp.set_log_level("debug")

require("colorizer").setup({
  ["*"] = {
    css = true,
    css_fn = true,
    mode = "background",
  },
})
