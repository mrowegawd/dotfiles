if not vim.env.HERDR_ENV then
  return
end

local add = require("vim-pack").add

local lazy = require("utils.plugin").require_lazy

local UtilKey = lazy "utils.map"

add {
  {
    src = "lmilojevicc/herdr-splits.nvim",
    module_name = "herdr-splits",
    opts = {
      auto_sync_herdr = true,
      nav_keys = {
        left = "<M-h>",
        down = "<M-j>",
        up = "<M-k>",
        right = "<M-l>",
      },
      resize_keys = {
        left = "<M-S-h>",
        down = "<M-S-j>",
        up = "<M-S-k>",
        right = "<M-S-l>",
      },
    },
    on_setup = function()
      local herdr_splits = lazy "herdr-splits"
      local cmds = {
        { "<a-h>", herdr_splits.move_cursor_left, "left" },
        { "<C-x><C-h>", herdr_splits.move_cursor_left, "left" },
        { "<a-j>", herdr_splits.move_cursor_down, "down" },
        { "<C-x><C-j>", herdr_splits.move_cursor_down, "down" },
        { "<a-k>", herdr_splits.move_cursor_up, "up" },
        { "<C-x><C-k>", herdr_splits.move_cursor_up, "up" },
        { "<a-l>", herdr_splits.move_cursor_right, "right" },
        { "<C-x><C-l>", herdr_splits.move_cursor_right, "right" },
        { "<a-H>", herdr_splits.resize_left, "resize left" },
        { "<a-J>", herdr_splits.resize_down, "resize down" },
        { "<a-K>", herdr_splits.resize_up, "resize up" },
        { "<a-L>", herdr_splits.resize_right, "resize right" },
      }

      for _, cmd in ipairs(cmds) do
        UtilKey.nnoremap(cmd[1], function()
          cmd[2]()
        end, { desc = ("Window: %s [smart-split]"):format(cmd[3]) })
      end
    end,
  },
}
