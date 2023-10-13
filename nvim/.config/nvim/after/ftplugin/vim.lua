vim.keymap.set("n", "K", function()
  vim.cmd.help(vim.fn.expand "<cword>")
end, { buffer = true, desc = "Help instead of hover" })
