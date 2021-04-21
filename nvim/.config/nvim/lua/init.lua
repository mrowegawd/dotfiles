-- Modules
require("modules._mappings")
require("modules._misc")
require("modules._util")

-- pcall(require, "modules._util") -- some useful utils

-- Plugins
require("plugins._compe")
require("plugins._nvim-tree")
require("plugins._vsnip")
require("plugins._gitsigns")
-- require("plugins._nvim-autopairs") " NOTE: di satukan dengan compe lsp
require("plugins._treesitter")
require("plugins._telescope")
require("plugins._nvim-toggleterm")

require("plugins._dap")

-- Update lsp
require("modules.lsp")
