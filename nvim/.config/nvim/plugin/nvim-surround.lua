local add = require("vim-pack").add

local lazy = require("utils.plugin").require_lazy
local UtilKey = lazy "utils.map"

-- Surround selections, add quotes, etc.
add {
  {
    src = "kylechui/nvim-surround",
    lazy = true,
    setup = false,
  },
}

-- Disable the default keymaps.
vim.g.nvim_surround_no_mappings = true

local load_surround = function()
  lazy("vim-pack").load_now "nvim-surround"
end
UtilKey.noremap({ "n", "x" }, "<Leader>ys", function()
  load_surround()
  UtilKey.feedkey_plug "<Plug>(nvim-surround-normal)"
end, { desc = "Add a surrounding pair around a motion (normal mode)" })
UtilKey.nnoremap("<Leader>yS", function()
  load_surround()
  UtilKey.feedkey_plug "<Plug>(nvim-surround-normal-cur)"
end, { desc = "Add a surrounding pair around the current line (normal mode)" })
UtilKey.nnoremap("<Leader>yd", function()
  load_surround()
  UtilKey.feedkey_plug "<Plug>(nvim-surround-delete)"
end, { desc = "Delete a surrounding pair" })
UtilKey.nnoremap("<Leader>yc", function()
  load_surround()
  UtilKey.feedkey_plug "<Plug>(nvim-surround-change)"
end, { desc = "Change a surrounding pair" })
