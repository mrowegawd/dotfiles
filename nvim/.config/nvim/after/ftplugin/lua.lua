vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

vim.b.make = "luajit"

local lazy = require("utils.plugin").require_lazy

local UtilKey = lazy "utils.map"
local osv = lazy "osv"

UtilKey.nnoremap("<Leader>dL", function()
  osv.launch { port = 8086 }
end, { desc = "Debug: launch lua adapter", remap = true, force = true })
