local add_on_event = require("vim-pack").add_on_event
local lazy = require("utils.plugin").require_lazy

local NOTE_FT = { org = true, help = true, orgagenda = true, markdown = true }

add_on_event("BufReadPost", {
  {
    src = "nanozuki/tabby.nvim",
    on_setup = function()
      local H = lazy "utils.highlights"

      local function h(name)
        return H.get_hl_as_hex { name = name }
      end

      local function get_bg(hl_name)
        local hl = vim.api.nvim_get_hl(0, { name = hl_name, link = false })

        if not hl.bg and hl_name == "NormalNote" then
          local note_hl = vim.api.nvim_get_hl(0, { name = "NormalNote" })
          if note_hl.bg then
            return string.format("#%06x", note_hl.bg)
          end
        end

        if hl.bg then
          return string.format("#%06x", hl.bg)
        end

        -- Fallback ke NormalFloat atau Normal
        local fallback = vim.api.nvim_get_hl(0, { name = "Normal" })
        if fallback.bg then
          return string.format("#%06x", fallback.bg)
        end
        return "#000000"
      end

      local function is_noteft()
        local win_id = vim.api.nvim_get_current_win()
        local buf = vim.api.nvim_win_get_buf(win_id)
        return NOTE_FT[vim.bo[buf].filetype]
      end

      local function get_fill()
        return is_noteft() and "NormalNote" or "NormalBack"
      end

      lazy("tabby").setup {
        justify = "right",
        line = function(line)
          local fill_hl = get_fill()

          local bg_color = get_bg(fill_hl)
          local fg_color = h("FloatTitle").bg

          vim.api.nvim_set_hl(0, "TabLineFill", { bg = bg_color })
          vim.api.nvim_set_hl(0, "TabLine", { fg = fg_color, bg = bg_color })

          local theme = {
            fill = fill_hl,
            head = "Normal",
            separator = fill_hl,
            current_tab = { fg = fg_color, bg = bg_color },
            tab = { fg = fg_color, bg = bg_color },
            win = { fg = fg_color, bg = bg_color },
          }

          return {
            line.tabs().foreach(function(tab)
              local hl = tab.is_current() and theme.current_tab or theme.tab
              return {
                line.sep(" ", { fg = fg_color, bg = bg_color }, { fg = fg_color, bg = bg_color }),
                tab.is_current() and "" or "󰆣",
                line.sep(" ", { fg = fg_color, bg = bg_color }, { fg = fg_color, bg = bg_color }),
                hl = hl,
                margin = "",
              }
            end),
            hl = fill_hl,
          }
        end,
      }
    end,
  },
})
