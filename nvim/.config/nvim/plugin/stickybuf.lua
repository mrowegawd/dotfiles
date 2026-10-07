local add_on_event = require("vim-pack").add_on_event

add_on_event("BufReadPost", {

  {
    src = "stevearc/stickybuf.nvim",
    opts = function()
      return {
        get_auto_pin = function(buf)
          if vim.bo[buf].filetype == "toggleterm" then
            return nil
          end
          if
            vim.tbl_contains(
              { "Outline", "aerial", "trouble", "codecompanion", "eldochover", "main_layout" },
              vim.bo[buf].filetype
            )
          then
            return "filetype"
          end
          return require("stickybuf").should_auto_pin(buf)
        end,
      }
    end,
  },
})
