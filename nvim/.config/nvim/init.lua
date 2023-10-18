require "r.config.lazyconfig"
require("r.config").setup {}

-- cfilter plugin allows filtering down an existing quickfix list
vim.cmd.packadd "cfilter"
