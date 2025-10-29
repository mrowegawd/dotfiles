local listchars = vim.deepcopy(vim.opt.listchars:get())
listchars.tab = "  "
listchars.trail = " "
vim.opt_local.listchars = listchars
