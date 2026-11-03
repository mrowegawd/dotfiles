local add_on_event = require("vim-pack").add_on_event

add_on_event("BufReadPost", {
  {
    src = "nanozuki/tabby.nvim",
    on_setup = function()
      local H = require "utils.highlights"

      local function h(name)
        return H.get_hl_as_hex { name = name }
      end

      local theme = {
        fill = "Normal",
        head = "Normal",
        separator = "Normal",

        current_tab = { fg = h("TabLine").fg, bg = h("Normal").bg },
        tab = { fg = h("TabLine").fg, bg = h("Normal").bg },
        win = { fg = h("TabLine").fg, bg = h("Normal").bg },

        tail = "TabLine",
      }

      require("tabby").setup {
        justify = "right",
        line = function(line)
          return {
            line.tabs().foreach(function(tab)
              local hl = tab.is_current() and theme.current_tab or theme.tab
              return {
                line.sep(" ", "Normal", "Normal"),
                tab.is_current() and "" or "󰆣",
                line.sep(" ", "Normal", "Normal"),
                hl = hl,
                margin = "",
              }
            end),
            hl = theme.fill,
          }
        end,
      }
    end,
  },
})
