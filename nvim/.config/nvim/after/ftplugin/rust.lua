vim.opt.tabstop = 4

vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

local bufnr = vim.api.nvim_get_current_buf()

vim.keymap.set("n", "<Leader>cR", function()
  vim.cmd.RustLsp "codeAction"
end, { desc = "Code Action", buffer = bufnr })
vim.keymap.set("n", "<Leader>dr", function()
  vim.cmd.RustLsp "debuggables"
end, { desc = "Rust Debuggables", buffer = bufnr })
