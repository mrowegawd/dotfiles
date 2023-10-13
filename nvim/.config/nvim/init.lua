require "r.settings.globals"
require "r.settings.options"
require "r.settings.ui"
require "r.settings.highlights"
require "r.settings.lazyconfig"

-- cfilter plugin allows filtering down an existing quickfix list
vim.cmd.packadd "cfilter"

vim.keymap.set("n", "<leader>rL", "<Cmd>Lazy<CR>", { desc = "Misc(lazy): manage" })

-- Load colorscheme
as.pcall("theme failed to load because", vim.cmd.colorscheme, as.colorscheme)
