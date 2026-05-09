return {
  -- MINI.PAIRS (disabled)
  {
    "nvim-mini/mini.pairs",
    enabled = false,
    event = "VeryLazy",
    opts = {
      modes = { insert = true, command = true, terminal = false },
      -- Skip `autopair` when next character is one of these
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      -- Skip `autopair` when the cursor is inside these `treesitter` nodes
      skip_ts = { "string" },
      -- Skip `autopair` when next character is closing pair
      -- and there are more closing pairs than opening pairs
      skip_unbalanced = true,
      -- Better deal with markdown code blocks
      markdown = true,
    },
    config = function(_, opts)
      RUtils.mini.pairs(opts)
    end,
  },
  -- NVIM-AUTOPAIRS - AUTO CLOSE BRACKETS
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      enable_check_bracket_line = false,
    },
    config = function()
      require("nvim-autopairs").setup {
        fast_wrap = {},
      }

      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"

      local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }

      -- ADD SPACES BETWEEN PARENTHESES
      npairs.add_rules {
        -- Rule for a pair with left-side ' ' and right side ' '
        Rule(" ", " ")
          -- Pair will only occur if the conditional function returns true
          :with_pair(function(opts)
            -- We are checking if we are inserting a space in (), [], or {}
            local pair = opts.line:sub(opts.col - 1, opts.col)
            return vim.tbl_contains({
              brackets[1][1] .. brackets[1][2],
              brackets[2][1] .. brackets[2][2],
              brackets[3][1] .. brackets[3][2],
            }, pair)
          end)
          :with_move(cond.none())
          :with_cr(cond.none())
          -- We only want to delete the pair of spaces when the cursor is as such: ( | )
          :with_del(
            function(opts)
              local col = vim.api.nvim_win_get_cursor(0)[2]
              local context = opts.line:sub(col - 1, col + 2)
              return vim.tbl_contains({
                brackets[1][1] .. "  " .. brackets[1][2],
                brackets[2][1] .. "  " .. brackets[2][2],
                brackets[3][1] .. "  " .. brackets[3][2],
              }, context)
            end
          ),
      }

      -- ARROW KEY ON JAVASCRIPT
      npairs.add_rules {
        Rule("%(.*%)%s*%=>$", " {  }", { "typescript", "typescriptreact", "javascript" })
          :use_regex(true)
          :set_end_pair_length(2),
      }

      -- AUTO ADDSPACE ON =
      npairs.add_rules {
        Rule("=", "")
          :with_pair(cond.not_inside_quote())
          :with_pair(function(opts)
            local last_char = opts.line:sub(opts.col - 1, opts.col - 1)
            if last_char:match "[%w%=%s]" then
              return true
            end
            return false
          end)
          :replace_endpair(function(opts)
            local prev_2char = opts.line:sub(opts.col - 2, opts.col - 1)
            local next_char = opts.line:sub(opts.col, opts.col)
            next_char = next_char == " " and "" or " "
            if prev_2char:match "%w$" then
              return "<bs> =" .. next_char
            end
            if prev_2char:match "%=$" then
              return next_char
            end
            if prev_2char:match "=" then
              return "<bs><bs>=" .. next_char
            end
            return ""
          end)
          :set_end_pair_length(0)
          :with_move(cond.none())
          :with_del(cond.none()),
      }

      -- For each pair of brackets we will add another rule
      for _, bracket in pairs(brackets) do
        npairs.add_rules {
          -- Each of these rules is for a pair with left-side '( ' and right-side ' )' for each bracket type
          Rule(bracket[1] .. " ", " " .. bracket[2])
            :with_pair(cond.none())
            :with_move(function(opts)
              return opts.char == bracket[2]
            end)
            :with_del(cond.none())
            :use_key(bracket[2])
            -- Removes the trailing whitespace that can occur without this
            :replace_map_cr(function(_)
              return "<C-c>2xi<CR><C-c>O"
            end),
        }
      end

      -- MOVE PAST COMMAS AND SEMICOLONS
      for _, punct in pairs { ",", ";" } do
        require("nvim-autopairs").add_rules {
          require "nvim-autopairs.rule"("", punct)
            :with_move(function(opts)
              return opts.char == punct
            end)
            :with_pair(function()
              return false
            end)
            :with_del(function()
              return false
            end)
            :with_cr(function()
              return false
            end)
            :use_key(punct),
        }
      end
    end,
  },
  -- TS-COMMENTS
  {
    "folke/ts-comments.nvim",
    event = "LazyFile",
    opts = true,
  },
  -- SCRATCH
  {
    "LintaoAmons/scratch.nvim",
    cmd = { "Scratch", "ScratchOpen" },
    opts = {
      scratch_file_dir = RUtils.config.path.wiki_path .. "/scratch.nvim", -- where your scratch files will be put
      filetypes = { "lua", "js", "sh", "ts", "go", "txt", "md", "rs" }, -- you can simply put filetype here
    },
    keys = {
      {
        "<Leader>bX",
        "<CMD>Scratch<CR>",
        desc = "Buffer: select list scratch buffer ft [scratch.nvim]",
      },
      {
        "<Leader>bx",
        "<CMD>ScratchOpen<CR>",
        desc = "Buffer: scratch [scratch.nvim]",
      },
    },
  },
  -- NVIM-SURROUND
  {
    -- how to use it: `ysiw`, `yc<brackets>`, `yd<brackets>`
    "kylechui/nvim-surround",
    event = "VeryLazy",
    init = function()
      -- Disable the default keymaps.
      vim.g.nvim_surround_no_mappings = true
    end,
    config = function()
      require("nvim-surround").setup()

      vim.keymap.set("n", "ys", "<Plug>(nvim-surround-normal)", {
        desc = "Add a surrounding pair around a motion (normal mode)",
      })
      vim.keymap.set("n", "yss", "<Plug>(nvim-surround-normal-cur)", {
        desc = "Add a surrounding pair around the current line (normal mode)",
      })
      vim.keymap.set("n", "yS", "<Plug>(nvim-surround-normal-line)", {
        desc = "Add a surrounding pair around a motion, on new lines (normal mode)",
      })
      vim.keymap.set("n", "ySS", "<Plug>(nvim-surround-normal-cur-line)", {
        desc = "Add a surrounding pair around the current line, on new lines (normal mode)",
      })

      vim.keymap.set("x", "S", "<Plug>(nvim-surround-visual)", {
        desc = "Add a surrounding pair around a visual selection",
      })
      vim.keymap.set("x", "gS", "<Plug>(nvim-surround-visual-line)", {
        desc = "Add a surrounding pair around a visual selection, on new lines",
      })

      vim.keymap.set("n", "yd", "<Plug>(nvim-surround-delete)", {
        desc = "Delete a surrounding pair",
      })
      vim.keymap.set("n", "yc", "<Plug>(nvim-surround-change)", {
        desc = "Change a surrounding pair",
      })
      vim.keymap.set("n", "yC", "<Plug>(nvim-surround-change-line)", {
        desc = "Change a surrounding pair, putting replacements on new lines",
      })
    end,
  },
  -- GITIGNORE.NVIM
  {
    "wintermute-cell/gitignore.nvim",
    cmd = "Gitignore",
    config = function()
      require "gitignore"
    end,
  },
  -- ASYNC.NVIM
  { "lewis6991/async.nvim", lazy = true },
  -- REFACTORING
  {
    "ThePrimeagen/refactoring.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      {
        "<leader>ri",
        function()
          return require("refactoring").inline_var()
        end,
        mode = "x",
        desc = "Refactoring: inline variable",
        expr = true,
      },
      {
        "<leader>rf",
        function()
          return require("refactoring").extract_func()
        end,
        mode = "x",
        desc = "Refactoring: extract function",
        expr = true,
      },
      {
        "<leader>rF",
        function()
          return require("refactoring").extract_func_to_file()
        end,
        mode = { "x" },
        desc = "Refactoring: extract function to file",
        expr = true,
      },
      {
        "<leader>rx",
        function()
          return require("refactoring").extract_var()
        end,
        mode = { "x" },
        desc = "Refactoring: Extract variable",
        expr = true,
      },

      -- Printout
      {
        "<Leader>rP",
        function()
          require("refactoring").debug.printf { below = false }
        end,
        desc = "Refactoring: insert print above [refactoring]",
      },
      {
        "<Leader>rp",
        function()
          require("refactoring").debug.print_var { normal = true }
        end,
        desc = "Refactoring: insert print below [refactoring]",
      },
    },
    opts = {},
  },
  -- OVERSEER.NVIM
  {
    "stevearc/overseer.nvim", -- Task runner and job management
    keys = { { "<Leader>rO", "<Cmd> OverseerToggle <CR>", desc = "TaskOverseer: toggle open [overseer.nvim]" } },
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
    config = function(_, opts)
      require("overseer").setup(opts)
      vim.api.nvim_create_user_command("OverseerDebugParser", 'lua require("overseer").debug_parser()', {})
    end,
  },
  -- RUNMUX
  {
    --"mrowegawd/rmux",
    -- enabled = false,
    dir = "~/.local/src/nvim_plugins/rmux",
    dependencies = { "stevearc/overseer.nvim" },
    keys = {
      { "<Leader>rf", "<Cmd> RmuxRunFile <CR>", desc = "Task: run file [rmux]" },

      { "<Leader>rl", "<Cmd> RmuxSendline <CR>", desc = "Task: send line [rmux]" },
      { "<Leader>rl", "<Cmd> RmuxSendlineV <CR>", desc = "Task: send line (visual) [rmux]", mode = { "x" } },
      { "<Leader>r<CR>", "<Cmd> RmuxSendEnter <CR>", desc = "Task: send enter key [rmux]", mode = { "x", "n" } },

      { "<Leader>rs", "<Cmd> RmuxSelectTargetPane <CR>", desc = "Task: select target pane [rmux]" },

      { "<Leader>rR", "<Cmd> RmuxSendRestartTaskPane <CR>", desc = "Task: restart the selected task pane [rmux]" },

      { "<Leader>ri", "<Cmd> RmuxSendInterrupt <CR>", desc = "Task: send interrupt [rmux]" },
      { "<Leader>rI", "<Cmd> RmuxSendInterruptAll <CR>", desc = "Task: send interrupt (all) [rmux]" },

      { "<Leader>rC", "<Cmd> RmuxKillAllPanes <CR>", desc = "Task: kill all panes [rmux]" },

      { "<a-R>", "<Cmd> RmuxGrepBuf <CR>", desc = "Task: open single find err [rmux]" },

      {
        "<Leader>rF",
        function()
          local task_cmds = {
            ["Task - Run task with Rmux"] = function()
              vim.cmd "RmuxRunFile"
            end,
            ["Task - Setup file rc"] = function()
              vim.cmd "RmuxSetTemplate"
            end,
            ["Task - Send interrupt"] = function()
              vim.cmd "RmuxSendInterrupt"
            end,
            ["Task - Send interrupt all"] = function()
              vim.cmd "RmuxSendInterruptAll"
            end,
            ["Task - Grep error (task running required)"] = function()
              vim.cmd "RmuxGrepErr"
            end,
            ["Task - Kill all panes"] = function()
              vim.cmd "RmuxKillAllPanes"
            end,
            ["Task - Select target pane"] = function()
              vim.cmd "RmuxKillAllPanes"
            end,
            ["Task - Edit config tasks.json"] = function()
              vim.cmd "RmuxEDITConfig"
            end,
            ["Task - Select filerc"] = function()
              vim.cmd "RmuxSelectFilerc"
            end,
            ["Task - Printout / Show configs"] = function()
              vim.cmd "RmuxSelectFilerc"
            end,

            ["TaskOverseer - Open overseer window toggle"] = function()
              vim.cmd "OverseerToggle"
            end,
            ["TaskOverseer - Run task with Overseer"] = function()
              vim.cmd "OverseerRun"
            end,
            ["TaskOverseer - Run open shell"] = function()
              vim.cmd "OverseerShell"
            end,

            ["Gitignore - Run generate gitignore"] = function()
              vim.cmd "Gitignore"
            end,

            -- Refactoring
            ["Refactoring - Select refactor"] = function()
              require("refactoring").select_refactor()
            end,
            ["Refactoring - Extract"] = function()
              vim.cmd "Refactor extract"
            end,
            ["Refactoring - Extract entire block"] = function()
              vim.cmd "Refactor extract_block"
            end,
            ["Refactoring - Extract function to a file"] = function()
              vim.cmd "Refactor extract_block_to_file"
            end,
            ["Refactoring - Clean all debug print string"] = function()
              require("refactoring").debug.cleanup {}
            end,
          }

          if vim.bo.filetype == "python" then
            task_cmds["Pyrola - Open / Start init"] = function()
              vim.cmd "Pyrola init"
            end

            task_cmds["Pyrola - Inspector under cursor"] = function()
              require("pyrola").inspect()
            end

            task_cmds["Pyrola - Send entire buffer to REPL"] = function()
              require("pyrola").send_buffer_to_repl()
            end

            task_cmds["Pyrola - History image viewer"] = function()
              require("pyrola").open_history_manager()
            end

            task_cmds["Pyrola - Send semantic code block"] = function()
              require("pyrola").send_statement_definition()
            end
          end

          if vim.bo.filetype == "yaml.ansible" then
            task_cmds["Ansible - Run task with Nvim.ansible"] = function()
              require("ansible").run()
            end
          end

          table.sort(task_cmds)

          RUtils.fzflua.open_cmd_bulk_center(
            task_cmds,
            { winopts = { title = RUtils.fzflua.format_title("Task Commands", RUtils.config.icons.misc.checklist) } }
          )
        end,
        desc = "Bulk: task commands",
        mode = { "n" },
      },
    },
    opts = {
      rmuxdirrc = RUtils.config.path.dropbox_path .. "/data.programming.forprivate/runmux/vscode",
      setnotif = false,
    },
  },
}
