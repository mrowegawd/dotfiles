local add_on_event = require("vim-pack").add_on_event
local on_plugin_update = require("vim-pack").on_plugin_update

local lazy = require("utils.plugin").require_lazy

add_on_event("BufReadPost", {
  {
    src = "kevinhwang91/promise-async",
    setup = false,
  },
  {
    src = "kevinhwang91/nvim-fundo",
    setup = false,
    on_setup = function()
      vim.o.undofile = true
      lazy("fundo").setup()
    end,
  },
})


on_plugin_update("nvim-fundo", function()
  lazy("fundo").install()
end)
