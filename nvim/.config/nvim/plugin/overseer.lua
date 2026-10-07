local add = require("vim-pack").add

local UtilKey = require "utils.map"

-- Task runner and job management
add {
  {
    src = "stevearc/overseer.nvim",
    opts = {
      templates = { "builtin", "user" },
      actions = {
        -- How to stop horizontal scroll??
        -- relate issue https://github.com/stevearc/overseer.nvim/issues/207
        ["open the output in tab"] = {
          desc = "Open this task in a new tab",
          run = function(task)
            local overseer_util = require "overseer.util"
            local bufnr = task:get_bufnr()
            if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
              vim.cmd.tabnew()
              overseer_util.set_term_window_opts()
              vim.api.nvim_win_set_buf(0, task:get_bufnr())
              overseer_util.scroll_to_end(0)
            end
          end,
        },
      },
      component_aliases = {
        log = {
          {
            type = "echo",
            level = vim.log.levels.WARN,
          },
          {
            type = "file",
            filename = "overseer.log",
            level = vim.log.levels.DEBUG,
          },
        },
      },
      task_list = {
        direction = "bottom",
        min_height = 10,
        max_height = 15,
        keymaps = {
          ["<PageUp>"] = "keymap.scroll_output_up",
          ["<PageDown>"] = "keymap.scroll_output_down",

          ["<C-u>"] = "keymap.scroll_output_up",
          ["<C-d>"] = "keymap.scroll_output_down",
          -- ["<A-n>"] = "keymap.scroll_output_up",
          -- ["<A-p>"] = "keymap.scroll_output_down",

          ["P"] = "keymap.toggle_preview",
          ["<A-p>"] = "keymap.prev_task",
          ["<A-n>"] = "keymap.next_task",

          ["<C-k>"] = false,
          ["<C-j>"] = false,

          ["<C-p>"] = "keymap.prev_task",
          ["<C-n>"] = "keymap.next_task",

          ["dd"] = { "keymap.run_action", opts = { action = "dispose" }, desc = "Task: dispose task [overseer]" },

          ["<C-h>"] = false, -- disabled because conflict with move_cursor window
          ["<C-l>"] = false,

          ["q"] = function()
            vim.cmd "OverseerClose"
          end,
          ["C"] = function()
            vim.cmd "OverseerClose"
          end,
          ["<Leader><TAB>"] = function()
            vim.cmd "OverseerClose"
          end,
          ["R"] = function()
            local sidebar = require "overseer.task_list.sidebar"
            local sb = sidebar.get_or_create()
            sb:run_action "restart"
          end,
        },
      },
      task_editor = {
        -- Set keymap to false to remove default behavior
        -- You can add custom keymaps here as well (anything vim.keymap.set accepts)
        bindings = {
          i = {
            ["<CR>"] = "NextOrSubmit",
            ["<C-s>"] = "Submit",
            ["<C-c>"] = "Cancel",

            ["<Tab>"] = "Next",
            ["<S-Tab>"] = "Prev",

            ["<A-n>"] = "Next",
            ["<A-p>"] = "Prev",

            ["<C-n>"] = false,
            ["<C-p>"] = false,

            ["<C-k>"] = false,
            ["<C-j>"] = false,
            ["<C-h>"] = false,
            ["<C-l>"] = false,
          },
          n = {
            ["<CR>"] = "NextOrSubmit",
            ["<C-s>"] = "Submit",
            ["q"] = "Cancel",

            ["<Tab>"] = "Next",
            ["<S-Tab>"] = "Prev",

            ["<A-n>"] = "Next",
            ["<A-p>"] = "Prev",

            ["<C-n>"] = false,
            ["<C-p>"] = false,

            ["<C-k>"] = false,
            ["<C-j>"] = false,
            ["<C-h>"] = false,
            ["<C-l>"] = false,

            ["g?"] = "ShowHelp",
          },
        },
      },
    },
    on_setup = function()
      vim.api.nvim_create_user_command("OverseerDebugParser", 'lua require("overseer").debug_parser()', {})

      UtilKey.nnoremap("<Leader>rO", function()
        vim.cmd.OverseerToggle()
      end, { desc = "TaskOverseer: toggle open [overseer.nvim]" })
    end,
  },
}
