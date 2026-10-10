local add_on_event = require("vim-pack").add_on_event

local UtilKey = require "utils.map"

add_on_event("UIEnter", {
  { src = "smart-splits-nvim/backend-tmux", setup = false },
  {
    src = "mrjones2014/smart-splits.nvim",
    opts = {
      ignored_filetypes = { "nofile", "quickfix", "prompt", "Trouble" },
      ignored_buftypes = { "NvimTree" },
      swap = { move_cursor = true, },
      move = { same_row = false, },
      resize = { amount = 4, },
      kitty_password = nil,
      mux = { backend = "smart-splits-backend-tmux" },
    },
    on_setup = function()
      UtilKey.nnoremap("<a-h>", require("smart-splits").move_cursor_left)
      UtilKey.nnoremap("<a-j>", require("smart-splits").move_cursor_down)
      UtilKey.nnoremap("<a-k>", require("smart-splits").move_cursor_up)
      UtilKey.nnoremap("<a-l>", require("smart-splits").move_cursor_right)

      -- stylua: ignore
      UtilKey.nnoremap("<a-H>", function() require("smart-splits").resize_left() end)
      -- stylua: ignore
      UtilKey.nnoremap("<a-J>", function() require("smart-splits").resize_down() end)
      -- stylua: ignore
      UtilKey.nnoremap("<a-K>", function() require("smart-splits").resize_up() end)
      -- stylua: ignore
      UtilKey.nnoremap("<a-L>", function() require("smart-splits").resize_right() end)
    end,
  },
})
