vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.b.make = "luajit"

require("r.utils").write_and_source(0)
