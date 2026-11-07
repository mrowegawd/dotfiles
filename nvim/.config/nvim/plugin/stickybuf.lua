local add_on_event = require("vim-pack").add_on_event

local lazy = require("utils.plugin").require_lazy

add_on_event("BufReadPost", {

  {
    src = "stevearc/stickybuf.nvim",
    opts = function()
      return {
        get_auto_pin = function(buf)
          local ft = vim.bo[buf].filetype
          local bt = vim.bo[buf].buftype
          if
            vim.tbl_contains({
              "toggleterm",
              "dap-view",
              "dap-view-term",
              "dap-repl",
              "dap-float",
            }, ft) or bt == "prompt" -- buffer REPL dap
          then
            return nil
          end

          if
            vim.tbl_contains({
              "Outline",
              "aerial",
              "trouble",
              "codecompanion",
              "eldochover",
              "main_layout",
            }, ft)
          then
            return "filetype"
          end
          return lazy("stickybuf").should_auto_pin(buf)
        end,
      }
    end,
  },
})
