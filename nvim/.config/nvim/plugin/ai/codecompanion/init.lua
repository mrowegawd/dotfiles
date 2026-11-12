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
    -- opts = function()
    --   return {
    --     adapters = {
    --       -- http = {
    --       --   webai = function()
    --       --     return require("codecompanion.adapters.webai").make()
    --       --   end,
    --       -- },
    --     },
    --     strategies = {
    --       -- chat = { adapter = "webai" },
    --       -- inline = { adapter = "webai" },
    --       -- cmd = { adapter = "webai" },
    --     },
    --   }
    -- end,
    -- -- config = function(_, opts)
    -- --   require("web-ai").setup { provider = "chatgpt", cdp_port = 9222, new_chat = true }
    -- --   require("codecompanion").setup(opts)
    -- -- end,
  },
}
