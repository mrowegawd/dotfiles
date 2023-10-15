require "r.settings.globals"
require "r.settings.ui"
require "r.settings.lazyconfig"

require("r.config").setup {}

-- cfilter plugin allows filtering down an existing quickfix list
vim.cmd.packadd "cfilter"
