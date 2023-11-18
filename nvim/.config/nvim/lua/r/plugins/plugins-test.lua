-------------------------------------------------------------------------------
-- NOTE: Just do some testing for new nvim plugin
-------------------------------------------------------------------------------

return {
  -- VSCODE-MULTI-CURSOR.NVIM
  {
    "vscode-neovim/vscode-multi-cursor.nvim",
    enabled = false,
    event = "VeryLazy",
    config = function()
      require("vscode-multi-cursor").setup { -- Config is optional
        -- Whether to set default mappings
        default_mappings = true,
        -- If set to true, only multiple cursors will be created without multiple selections
        no_selection = false,
      }
    end,
    -- cond = not not vim.g.vscode,
  },
  {
    "echasnovski/mini.animate",
    enabled = false,
    event = "VeryLazy",
    opts = function()
      -- don't use animate when scrolling with the mouse
      local mouse_scrolled = false
      for _, scroll in ipairs { "Up", "Down" } do
        local key = "<ScrollWheel" .. scroll .. ">"
        vim.keymap.set({ "", "i" }, key, function()
          mouse_scrolled = true
          return key
        end, { expr = true })
      end

      local animate = require "mini.animate"
      return {
        resize = {
          timing = animate.gen_timing.linear { duration = 120, unit = "total" },
        },
        scroll = {
          timing = animate.gen_timing.exponential { duration = 50, unit = "total" },
          subscroll = animate.gen_subscroll.equal {
            predicate = function(total_scroll)
              if mouse_scrolled then
                mouse_scrolled = false
                return false
              end
              return total_scroll > 1 and total_scroll < 50
            end,
          },
        },
        cursor = {
          subscroll = animate.gen_path.spiral(),
        },
        open = {
          winconfig = animate.gen_winconfig.wipe {
            direction = "from_edge",
          },
        },
        close = {
          winconfig = animate.gen_winconfig.wipe {
            direction = "to_edge",
          },
        },
      }
    end,
  },
}
