-- Enable experimental lua module loader
vim.loader.enable()

require "r.settings.globals"
require "r.settings.options"
require "r.settings.ui"
require "r.settings.highlights"
require "r.settings.lazyconfig"

-- Load colorscheme

as.pcall("theme failed to load because", vim.cmd.colorscheme, as.colorscheme)
