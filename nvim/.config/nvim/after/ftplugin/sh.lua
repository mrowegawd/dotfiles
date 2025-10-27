local listchars = vim.deepcopy(vim.opt.listchars:get())
listchars.tab = "  "
vim.opt_local.listchars = listchars
