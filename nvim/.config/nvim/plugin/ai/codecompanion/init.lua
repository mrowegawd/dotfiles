local add = require("vim-pack").add

local lazy = require("utils.plugin").require_lazy

add {
  { src = "nvim-lua/plenary.nvim", setup = false },
  { src = "nvim-tree/nvim-web-devicons", setup = false },
  { src = "ravitemer/codecompanion-history.nvim", setup = false },
  {
    src = "olimorris/codecompanion.nvim",
    on_setup = function()
      return lazy("utils.codecompanion").setup()
    end,
  },
}
