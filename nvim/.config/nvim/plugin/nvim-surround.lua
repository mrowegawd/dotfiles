local add_on_event = require("vim-pack").add_on_event

local UtilKey = require "utils.map"

-- Surround selections, add quotes, etc.
add_on_event("UIEnter", {
  {
    src = "kylechui/nvim-surround",
    on_setup = function()
      UtilKey.noremap({ "n", "x" }, "<Leader>ys", "<Plug>(nvim-surround-normal)", {
        desc = "Add a surrounding pair around a motion (normal mode)",
      })
      UtilKey.nnoremap("<Leader>yS", "<Plug>(nvim-surround-normal-cur)", {
        desc = "Add a surrounding pair around the current line (normal mode)",
      })
      UtilKey.nnoremap("<Leader>yd", "<Plug>(nvim-surround-delete)", {
        desc = "Delete a surrounding pair",
      })
      UtilKey.nnoremap("<Leader>yc", "<Plug>(nvim-surround-change)", {
        desc = "Change a surrounding pair",
      })
    end,
  },
})

-- Disable the default keymaps.
vim.g.nvim_surround_no_mappings = true
