vim.loader.enable() -- dont delete this line

require "r.config.lazyconfig"
require("r.config").setup()

vim.cmd.packadd "cfilter"
