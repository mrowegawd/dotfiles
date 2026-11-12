local add = require("vim-pack").add

local lazy = require("utils.plugin").require_lazy

-- local add_on_event = require("vim-pack").add_on_event

add {
  {
    src = "rachartier/tiny-cmdline.nvim",
    opts = function()
      return {
        position = {
          x = "50%",
          y = "50%",
        },
        border = "rounded",
        title = {
          enabled = true,
          pos = "center",
        },
        on_reposition = lazy("tiny-cmdline").adapters.blink,
      }
    end,
    on_setup = function()
      vim.o.cmdheight = 0
    end,
  },
}
