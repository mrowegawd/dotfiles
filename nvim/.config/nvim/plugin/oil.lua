local add = require("vim-pack").add

local ConfigPath = require("config").path
local UtilKey = require "utils.map"

local Log = require "utils.log"

add {
  {
    src = "stevearc/oil.nvim",
    lazy = true,
    opts = {
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      prompt_save_on_select_new_entry = false,
      watch_for_changes = true,
      win_options = {
        concealcursor = "n",
      },
      use_default_keymaps = false,
      keymaps = {
        ["g?"] = { "actions.show_help", mode = "n" },
        ["<CR>"] = "actions.select",
        ["<BS>"] = { "actions.parent", mode = "n" },
        ["~"] = { "<cmd>edit $HOME<CR>", mode = "n", desc = "Open CWD" },

        ["-"] = { "actions.parent", mode = "n" },
        ["_"] = { "actions.open_cwd", mode = "n" },
        ["`"] = { "actions.cd", mode = "n" },

        ["<Leader>t"] = "actions.open_terminal",
        ["<a-t>"] = "actions.open_terminal",
        ["P"] = "actions.preview",
        ["H"] = { "actions.toggle_hidden", mode = "n" },
        ["<Leader>cd"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
        ["<Leader>ov"] = { "actions.select", opts = { vertical = true } },
        ["<Leader>os"] = { "actions.select", opts = { horizontal = true } },
        ["<Leader>ot"] = { "actions.select", opts = { tab = true } },
        ["<c-a>y"] = { "actions.copy_to_system_clipboard", mode = { "n", "v" } },
        ["<c-a>cs"] = { "actions.change_sort", mode = "n" },
        ["<C-a>p"] = "actions.paste_from_system_clipboard",
        ["<c-a>q"] = {
          function()
            local oil = require "oil"
            local fs = require "oil.fs"
            local dir = require("oil").get_current_dir()

            ---@return integer start
            ---@return integer end
            local function range_from_selection()
              -- [bufnum, lnum, col, off]; both row and column 1-indexed
              local start = vim.fn.getpos "v"
              local end_ = vim.fn.getpos "."
              local start_row = start[2]
              local end_row = end_[2]

              if start_row > end_row then
                start_row, end_row = end_row, start_row
              end

              return start_row, end_row
            end

            local entries = {}

            local mode = vim.api.nvim_get_mode().mode
            if mode == "v" or mode == "V" then
              if fs.is_mac then
                Log.error "Copying multiple paths to clipboard is not supported on mac"
                return
              end
              local start_row, end_row = range_from_selection()
              for i = start_row, end_row do
                table.insert(entries, oil.get_entry_on_line(0, i))
              end
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
            else
              table.insert(entries, oil.get_cursor_entry())
            end

            if vim.tbl_isempty(entries) then
              return
            end

            local list_items = {}
            for _, x in pairs(entries) do
              list_items[#list_items + 1] = {
                filename = dir .. x.name,
                lnum = x.lnum or 1,
                col = x.col or 1,
                text = x.text or "",
              }
            end

            local data = { items = list_items, title = "oil.nvim" }

            if #list_items == 1 then
              mode = "a"
            else
              mode = " "
            end

            require("utils.qf").save_to_qf_and_auto_open_qf(data, false, mode)

            vim.schedule(function()
              vim.cmd "wincmd p"
            end)
          end,
        },
        ["<c-a>uv"] = {
          desc = "Toggle detail view",
          callback = function()
            local oil = require "oil"
            local config = require "oil.config"
            if #config.columns == 1 then
              oil.set_columns { "icon", "permissions", "size", "mtime" }
            else
              oil.set_columns { "icon" }
            end
          end,
        },
        ["<a-o>"] = {
          function()
            local reverse = {}
            local dropbox_path = ConfigPath.dropbox_path
            local path_fzmark = dropbox_path .. "/data.programming.forprivate/marked-pwd"

            local cat_fzmark = vim.api.nvim_exec2("!cat " .. path_fzmark, { output = true })
            if cat_fzmark.output ~= nil then
              local res = vim.split(cat_fzmark.output, "\n")
              for index = 2, #res - 1 do
                if #res[index] > 1 then
                  reverse[#reverse + 1] = res[index]
                end
              end
            end
            return require("fzf-lua").fzf_exec(reverse, {
              actions = {
                ["default"] = {
                  fn = function(e)
                    if not e then
                      return
                    end

                    vim.cmd.cd(e[1])
                    require("oil").open(e[1])
                  end,
                },
              },
            })
          end,
        },
        ["<a-G>"] = {
          function()
            require("utils.terminal").lazygit()
          end,
        },
        ["<a-T>"] = {
          function()
            local dir = require("oil").get_current_dir()
            require("utils.terminal").open_terminal_in_filetree(dir)
          end,
        },
        ["<a-D>"] = {
          function()
            return require("utils.terminal").lazydocker()
          end,
        },
        ["<Leader><Leader>"] = {
          function()
            local dir = require("oil").get_current_dir()
            if vim.api.nvim_win_get_config(0).relative ~= "" then
              vim.api.nvim_win_close(0, true)
            end
            local fzf_lua = require "fzf-lua"
            fzf_lua.files { cwd = dir }
          end,
          desc = "[F]ind [F]iles in dir",
        },
        ["<Leader>fg"] = {
          function()
            local dir = require("oil").get_current_dir()
            if vim.api.nvim_win_get_config(0).relative ~= "" then
              vim.api.nvim_win_close(0, true)
            end
            local fzf_lua = require "fzf-lua"
            fzf_lua.live_grep { cwd = dir }
          end,
          desc = "[F]ind by [G]rep in dir",
        },
      },
      view_options = {
        show_hidden = true,
      },
    },
  },
}

UtilKey.nnoremap("<Leader>oo", function()
  UtilKey.plugin_load_now "oil.nvim"
  local right_win = {
    "trouble",
    "aerial",
    "Outline",
    "neo-tree",
    "snacks_notif_history",
    "ErgoTerm",
    "codecompanion",
    "pdfview",
  }
  if vim.tbl_contains(right_win, vim.bo.filetype) then
    Log.warn "This filetype is excluded and cannot be opened in oil.nvim"
    return
  end

  vim.cmd "Oil"
end)
