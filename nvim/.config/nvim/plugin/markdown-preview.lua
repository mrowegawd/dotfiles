local add_on_file_type = require("vim-pack").add_on_file_type
local on_plugin_update = require("vim-pack").on_plugin_update

local UtilKey = require "utils.map"

-- Markdown preview on the browser.
add_on_file_type("markdown", {
  {
    src = "iamcco/markdown-preview.nvim",
    setup = false,
    lazy = true,
  },
})

on_plugin_update("markdown-preview.nvim", function()
  -- if fail, run manually: `:lua vim.fn["mkdp#util#install_sync"](true)`
  vim.fn["mkdp#util#install_sync"](true)
end)
