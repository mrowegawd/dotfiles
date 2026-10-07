local keymap = vim.keymap

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

vim.b.make = "luajit"

-- keymap.set("n", "<Leader>dal", function()
--   require("osv").run_this()
-- end, { buffer = true, desc = "Debug: adapter lua [nlua]" })

keymap.set("n", "<Leader>dD", function()
  require("osv").launch { port = 8086 }
end, { buffer = true, desc = "Debug: launch debug lua [nlua]" })
