local add_on_event = require("vim-pack").add_on_event

local UtilKey = require "utils.map"
local UtilQf = require "utils.qf"

add_on_event("LspAttach", {
  {
    src = "MadKuntilanak/overlook.nvim",
    opts = {
      ui = {
        size_ratio = 0.70,
        min_width = 40,
        min_height = 20,
      },
      adapters = {
        peek_fzflua = {
          get = function(selection)
            local path = require("utils.cmd").__strip_str(selection[1])
            if not path then
              return
            end

            local lnum, col = 1, 1

            if path:match ":" then
              local parts = vim.split(path, ":")
              path = parts[1]
              lnum = tonumber(parts[2]) or lnum
              col = tonumber(parts[3]) or col
            end

            if path:match "~" then
              path = require("config").path.home .. path:gsub("~", "")
            end

            local bufnr = vim.fn.bufadd(path)

            return {
              target_bufnr = bufnr,
              lnum = lnum,
              col = col,
              title = path,
              win_col = 50,
              win_row = 5,
              win_width = 80,
              win_height = 25,
            }
          end,
        },

        peek_qf = {
          get = function()
            local function win_height()
              return vim.fn.winheight(0)
            end

            local function is_qf_window_at_bottom()
              local editor_last_row = vim.o.lines - vim.o.cmdheight - 1
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                local info = vim.fn.getwininfo(win)[1]
                if info.quickfix == 1 or info.loclist == 1 then
                  local pos = vim.api.nvim_win_get_position(win)
                  local height = vim.api.nvim_win_get_height(win)
                  return (pos[1] + height - 1) >= editor_last_row - 1
                end
              end
              return false
            end

            local cursor_lnum = vim.api.nvim_win_get_cursor(0)[1]
            local is_loc = UtilQf.is_loclist()
            local qflist = UtilQf.get_list_qf(is_loc)
            local item = qflist.items[cursor_lnum]

            local opts = {
              col = item.col or nil,
              lnum = item.lnum or nil,
              win_height = 20,
              win_width = 100,
              win_col = 0,
              win_row = is_qf_window_at_bottom() and -win_height() - 15 or win_height(),
              win_relative = "win",
            }

            if item.bufnr then
              opts.target_bufnr = item.bufnr

              if item.text then
                if #item.text == 0 then
                  local path = require("qfbookmark.utils").nvim_buf_get_name(item.bufnr)
                  opts.title = path and vim.fn.fnamemodify(path, ":~:.") or item.text
                else
                  opts.title = item.text
                end
              end
            end

            return opts
          end,
        },
        peek_file_source = {
          get = function()
            if vim.bo.filetype ~= "orgagenda" then
              return
            end

            local item_headline = require("orgmode.api.agenda").get_headline_at_cursor()
            if not item_headline then
              return
            end

            local opts = { lnum = 0, col = 0 }

            ---@diagnostic disable-next-line: invisible
            local item_section = item_headline._section
            if item_section and item_section.file then
              local path = item_section.file.filename

              if path:match "~" then
                path = require("config").path.home .. path:gsub("~", "")
              end

              local bufnr = vim.fn.bufadd(path)

              opts.target_bufnr = bufnr
              opts.title = path
              opts.lnum = item_headline.position.start_line
              opts.col = item_headline.position.end_col
            end

            local columns = vim.api.nvim_get_option_value("columns", { scope = "global" })
            local win_width = math.ceil(columns / 2)
            local win_height = math.floor(vim.o.lines * 0.3)
            local ui = vim.api.nvim_list_uis()[1]

            opts.win_relative = "editor"
            opts.win_row = math.floor((ui.height - win_height) / 2)
            opts.win_col = math.floor((ui.width - win_width) / 2)
            opts.win_width = 80
            opts.win_height = 30

            return opts
          end,
        },
      },
    },
    on_setup = function()
      UtilKey.nnoremap("<Leader>cP", function()
        require("overlook.api").peek_definition()
      end, { desc = "Action: peek definition [overlook.nvim]" }) -- ft= qf

      -- keys = {
      --   {
      --     "P",
      --     function()
      --       require("overlook.peek").peek_file_source()
      --     end,
      --     ft = "orgagenda",
      --     desc = "Peek: note org item [overlook.nvim]",
      --   },
      -- },

      local api = require "overlook.api"
      local cmds = {
        { "PeekCloseAll", api.close_all, "peek close all" },
        { "PeekCursor", api.peek_cursor, "peek cursor" },
        { "PeekRestorePopup", api.restore_popup, "restore popup" },
        { "PeekRestoreAllPopup", api.restore_all_popups, "restore all popup" },
      }

      for _, cmd in ipairs(cmds) do
        vim.api.nvim_create_user_command(cmd[1], cmd[2], {
          desc = ("Peek: %s [overlook.nvim]"):format(cmd[3]),
        })
      end
    end,
  },
})
