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
  -- BLINK.PAIRS - AUTO CLOSE AND COLOR BRACKETS (disabled)
  {
    "saghen/blink.pairs",
    enabled = false,
    version = "*", -- (recommended) only required with prebuilt binaries
    dependencies = "saghen/blink.download",
    --- @module 'blink.pairs'
    --- @type blink.pairs.Config
    opts = {
      mappings = {
        -- you can call require("blink.pairs.mappings").enable()
        -- and require("blink.pairs.mappings").disable()
        -- to enable/disable mappings at runtime
        enabled = true,
        cmdline = true,
        -- or disable with `vim.g.pairs = false` (global) and `vim.b.pairs = false` (per-buffer)
        -- and/or with `vim.g.blink_pairs = false` and `vim.b.blink_pairs = false`
        disabled_filetypes = {},
        -- see the defaults:
        -- https://github.com/Saghen/blink.pairs/blob/main/lua/blink/pairs/config/mappings.lua#L14
        pairs = {},
      },
      highlights = {
        enabled = true,
        -- requires require('vim._extui').enable({}), otherwise has no effect
        cmdline = true,
        groups = {
          "BlinkPairsOrange",
          "BlinkPairsPurple",
          "BlinkPairsBlue",
        },
        unmatched_group = "BlinkPairsUnmatched",

        -- highlights matching pairs under the cursor
        matchparen = {
          enabled = true,
          -- known issue where typing won't update matchparen highlight, disabled by default
          cmdline = false,
          -- also include pairs not on top of the cursor, but surrounding the cursor
          include_surrounding = false,
          group = "BlinkPairsMatchParen",
          priority = 250,
        },
      },
      debug = false,
    },
  },
  -- TS-COMMENTS
  {
    "folke/ts-comments.nvim",
    event = "LazyFile",
    opts = true,
  },
  -- MINI.AI (disabled)
  {
    "nvim-mini/mini.ai",
    enabled = false,
    event = "LazyFile",
    opts = function()
      local ai = require "mini.ai"
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter { -- code block
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          },
          f = ai.gen_spec.treesitter { a = "@function.outer", i = "@function.inner" }, -- function
          c = ai.gen_spec.treesitter { a = "@class.outer", i = "@class.inner" }, -- class
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
          d = { "%f[%d]%d+" }, -- digits
          e = { -- Word with case
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          },
          g = RUtils.mini.ai_buffer, -- buffer
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call { name_pattern = "[%w_]" }, -- without dot in function name
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
      RUtils.on_load("which-key.nvim", function()
        vim.schedule(function()
          RUtils.mini.ai_whichkey(opts)
        end)
      end)
    end,
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
    version = "*",
    keys = {
      { "ys", mode = "n", desc = "Surround: motion [nvim-surround]" },
      { "ySS", mode = "n", desc = "Surround: current line [nvim-surround]" },
      -- { "yS", mode = "n", desc = "Surround + motion + line" },
      { "<c-x>s", mode = "i", desc = "Surround: surround (insert) [nvim-surround]" },
      { "S", mode = "x", desc = "Surround: motion (visual) [nvim-surround]" },
      { "yd", mode = "n", desc = "Surround: delete surround [nvim-surround]" },
      { "yc", mode = "n", desc = "Surround: change surround [nvim-surround]" },
      { "yC", mode = "n", desc = "Surround: change line [nvim-surround]" },
    },
    config = function()
      local input = require("nvim-surround.input").get_input
      require("nvim-surround").setup {
        keymaps = {
          insert = "<C-x>s",
          insert_line = "<C-x>S",

          normal = "ys",
          normal_cur = "ya",
          normal_line = "ySA",
          normal_cur_line = "ySS",
          visual = "S",
          visual_line = "gS",
          delete = "yd",
          change = "yc",
          change_line = "yC",
        },
        -- Configuration here, or leave empty to use defaults
        aliases = {
          ["d"] = { "{", "[", "(", "<", '"', "'", "`" }, -- Any delimiter
          ["b"] = { "{", "[", "(", "<" }, -- Bracket
          ["p"] = { "(" },
        },
        surrounds = {
          ["f"] = {
            change = {
              target = "^.-([%w_.]+!?)()%(.-%)()()$",
              replacement = function()
                local result = input "Enter the function name: "
                if result then
                  return { { result }, { "" } }
                end
              end,
            },
          },
          ["g"] = {
            add = function()
              local result = require("nvim-surround.config").get_input "Enter the generic name: "
              if result then
                return {
                  { result .. "<" },
                  { ">" },
                }
              end
            end,
            find = "[%w_]-<.->",
            delete = "^([%w_]-<)().-(>)()$",
          },
          ["G"] = {
            add = function()
              local result = require("nvim-surround.config").get_input "Enter the generic name: "
              if result then
                return {
                  { result .. "<" },
                  { ">" },
                }
              end
            end,
            find = "[%w_]-<.->",
            delete = "^([%w_]-<)().-(>)()$",
          },
        },
        move_cursor = false,
      }
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
  -- REFACTORING
  {
    "ThePrimeagen/refactoring.nvim",
    cmd = "Refactor",
    keys = {
      -- { "<Leader>rr", "", desc = "refactoring" },
      -- {
      --   "<Leader>rF",
      --   function()
      --     local refactoring = require "refactoring"
      --     local fzf_lua = require "fzf-lua"
      --     local results = refactoring.get_refactors()
      --
      --     local opts = {
      --       prompt = "  ",
      --       winopts = {
      --         title = RUtils.fzflua.format_title("Refactoring?", ""),
      --         border = "rounded",
      --         height = #results + 3,
      --         width = 0.30,
      --         row = 1.05,
      --         backdrop = 100,
      --         relative = "cursor",
      --       },
      --       actions = {
      --         ["default"] = function(selected)
      --           vim.cmd "normal! gv"
      --           -- refactoring.refactor(selected[1])
      --         end,
      --       },
      --     }
      --     fzf_lua.fzf_exec(results, opts)
      --   end,
      --   mode = { "n", "x" },
      --   desc = "Refactoring: select ref cmds [refacoring.nvim]",
      -- },

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
    opts = {
      prompt_func_return_type = {
        go = false,
        java = false,
        cpp = false,
        c = false,
        h = false,
        hpp = false,
        cxx = false,
      },
      prompt_func_param_type = {
        go = false,
        java = false,
        cpp = false,
        c = false,
        h = false,
        hpp = false,
        cxx = false,
      },
      printf_statements = {},
      print_var_statements = {},
      show_success_message = true, -- Shows a message with information about the refactor on success
      -- i.e. [Refactor] Unlined 3 variable occurrences
    },
    config = function(_, opts)
      require("refactoring").setup(opts)
      if RUtils.has "telescope.nvim" then
        RUtils.on_load("telescope.nvim", function()
          require("telescope").load_extension "refactoring"
        end)
      end
    end,
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

          ["<c-u>"] = "keymap.scroll_output_up",
          ["<c-d>"] = "keymap.scroll_output_down",

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

            ["?"] = "ShowHelp",
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
      { "<Leader>rn", "<Cmd> RmuxRunFile <CR>", desc = "Task: run file [rmux]" },

      { "<Leader>rv", "<Cmd> RmuxSendline <CR>", desc = "Task: send line [Rmux]" },
      { "<Leader>rv", "<Cmd> RmuxSendlineV <CR>", desc = "Task: send line (visual) [Rmux]", mode = { "x" } },

      { "<Leader>ri", "<Cmd> RmuxSendInterrupt <CR>", desc = "Task: send interrupt (current) [Rmux]" },
      { "<Leader>rI", "<Cmd> RmuxSendInterruptAll <CR>", desc = "Task: send interrupt (all panes) [Rmux]" },

      { "<Leader>rC", "<Cmd> RmuxKillAllPanes <CR>", desc = "Task: kill all panes [Rmux]" },

      { "<a-R>", "<Cmd> RmuxGrepBuf <CR>", desc = "Task: open single find err [Rmux]" },

      {
        "<Leader>rf",
        function()
          local task_cmds = {
            ["Task - Run task with Rmux"] = function()
              vim.cmd "RmuxRunFile"
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
            -- ["Refactoring - Inline variable"] = function()
            --   require("refactoring").refactor "Inline Variable"
            -- end,
            ["Refactoring - Extract"] = function()
              vim.cmd "Refactor extract"
            end,
            -- ["Refactoring - Extract variable"] = function()
            --   require("refactoring").refactor "Extract Variable"
            -- end,
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

          RUtils.fzflua.open_cmd_bulk_dock(task_cmds, { winopts = { title = RUtils.config.icons.misc.bug .. " Task" } })
        end,
        desc = "Bulk: tasks cmds",
        mode = { "n", "x", "v" },
      },
    },
    opts = {
      rmuxdirrc = RUtils.config.path.dropbox_path .. "/data.programming.forprivate/runmux/vscode",
      setnotif = false,
    },
  },
  -- MARKER-GROUPS (disabled)
  {
    "jameswolensky/marker-groups.nvim",
    enabled = false,
    events = "LazyFile",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required
      "nvim-telescope/telescope.nvim", -- Optional: for fuzzy search
    },
    config = function()
      require("marker-groups").setup {
        data_dir = RUtils.config.path.wiki_path .. "/marker/project-todo",
        keymaps = {
          enabled = true, -- Keybindings (declarative; override per entry or disable by setting to false)
          prefix = "<leader>m",
          mappings = {
            marker = {
              add = { suffix = "a", mode = { "n", "x" }, desc = "Add marker" },
              edit = { suffix = "e", desc = "Edit marker at cursor" },
              delete = { suffix = "d", desc = "Delete marker at cursor" },
              list = { suffix = "l", desc = "List markers in buffer" },
              info = { suffix = "i", desc = "Show marker at cursor" },
            },
            group = {
              create = { suffix = "gc", desc = "Create marker group" },
              select = { suffix = "gs", desc = "Select marker group" },
              list = { suffix = "gl", desc = "List marker groups" },
              rename = { suffix = "gr", desc = "Rename marker group" },
              delete = { suffix = "gd", desc = "Delete marker group" },
              info = { suffix = "gi", desc = "Show active group info" },
              -- next/prev/toggle_last/cleanup removed
              from_branch = { suffix = "gb", desc = "Create group from git branch" },
            },
            view = {
              toggle = { suffix = "x", desc = "Toggle drawer marker viewer" },
            },
            telescope = {
              groups = { suffix = "fg", desc = "Telescope: marker groups" },
              markers = { suffix = "ff", desc = "Telescope: markers in active group" },
            },
          },
        },
      }
    end,
  },
}
