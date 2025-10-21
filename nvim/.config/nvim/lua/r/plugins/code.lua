return {
  -- MINI.PAIRS
  {
    "nvim-mini/mini.pairs",
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
        "<Leader>oS",
        "<CMD>Scratch<CR>",
        desc = "Open: select list scratch ft [scratch]",
      },
      {
        "<Leader>os",
        "<CMD>ScratchOpen<CR>",
        desc = "Open: scratch buffer [scratch]",
      },
    },
  },
  -- NVIM-SURROUND
  {
    -- how to use it: `ysiw`, `yc<brackets>`, `yd<brackets>`
    "kylechui/nvim-surround",
    event = "VeryLazy",
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
  -- NVIM-COVERAGE
  {
    "andythigpen/nvim-coverage", -- Display test coverage information
    dependencies = "nvim-lua/plenary.nvim",
    cmd = {
      "Coverage",
      "CoverageSummary",
      "CoverageLoad",
      "CoverageShow",
      "CoverageHide",
      "CoverageToggle",
      "CoverageClear",
    },
    -- stylua: ignore
    keys = {
      { "<Leader>tcr", "<CMD>Coverage<CR>", desc = "Coverage: run" },
      { "<Leader>tcC", "<CMD>CoverageClear<CR>", desc = "Coverage: clear" },
      { "<Leader>tcc", "<CMD>CoverageToggle<CR>", desc = "Coverage: toggle" },
      { "<Leader>tcl", "<CMD>CoverageLoad<CR>", desc = "Coverage: load" },
      { "<Leader>tcs", "<CMD>CoverageSummary<CR>", desc = "Coverage: summary" },
    },
    config = function()
      require("coverage").setup {
        highlights = {
          covered = { fg = "green" },
          uncovered = { fg = "red" },
        },
      }
    end,
  },
  -- OVERSEER.NVIM
  {
    "stevearc/overseer.nvim", -- Task runner and job management
    cmd = {
      "OverseerToggle",
      "OverseerOpen",
      "OverseerInfo",
      "OverseerRun",
      "OverseerBuild",
      "OverseerClose",
      "OverseerLoadBundle",
      "OverseerSaveBundle",
      "OverseerDeleteBundle",
      "OverseerRunCmd",
      "OverseerQuickAction",
      "OverseerTaskAction",
      "OverseerDebugParser",
    },
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
        default_detail = 1,
        direction = "bottom",
        min_height = 10,
        max_height = 15,
        bindings = {
          ["<PageUp>"] = "ScrollOutputUp",
          ["<PageDown>"] = "ScrollOutputDown",

          ["<c-u>"] = "ScrollOutputUp",
          ["<c-d>"] = "ScrollOutputDown",

          ["P"] = "TogglePreview",
          ["<A-p>"] = "PrevTask",
          ["<A-n>"] = "NextTask",
          ["dd"] = "Dispose",

          ["<C-h>"] = false, -- disabled because conflict with move_cursor window
          ["<C-l>"] = false,

          ["<C-p>"] = "PrevTask",
          ["<C-n>"] = "NextTask",

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
    "mrowegawd/rmux",
    -- dir = "~/.local/src/nvim_plugins/rmux",
    dependencies = { "stevearc/overseer.nvim" },
    keys = {
      { "<Leader>rf", "<Cmd> RmuxRunFile <CR>", desc = "Task: run task" },

      { "<Leader>rl", "<Cmd> RmuxSendline <CR>", desc = "Task: send line" },
      { "<Leader>rl", "<Cmd> RmuxSendlineV <CR>", desc = "Task: send line (visual)", mode = { "x" } },
      { "<Leader>ri", "<Cmd> RmuxSendInterrupt <CR>", desc = "Task: send interrupt" },
      { "<Leader>rI", "<Cmd> RmuxSendInterruptAll <CR>", desc = "Task: send interrupt all" },

      { "<Leader>rC", "<Cmd> RmuxKillAllPanes <CR>", desc = "Task: kill all panes" },
      { "<Leader>rg", "<Cmd> RmuxGrepErr <CR>", desc = "Task: grep errors" },
      { "<Leader>rp", "<Cmd> RmuxSelectTargetPane <CR>", desc = "Task: select pane" },

      { "<a-R>", "<Cmd> RmuxGrepBuf <CR>", desc = "Task: open single find err" },

      { "<Leader>re", "<Cmd> RmuxEDITConfig <CR>", desc = "Task: edit config" },
      { "<Leader>rE", "<Cmd> RmuxSelectFilerc <CR>", desc = "Task: select filerc" },
      { "<Leader>r?", "<Cmd> RmuxSHOWConfig <CR>", desc = "Task: show config" },
    },
    opts = {
      base = {
        file_rc = ".rmuxrc.json",
        setnotif = true,
        auto_run_tasks = true,
        tbl_opened_panes = {},
        rmuxpath = RUtils.config.path.dropbox_path .. "/data.programming.forprivate/runmux/vscode",
        run_with = "auto", -- `mux, tt, wez, toggleterm`
        quickfix = {
          copen = RUtils.qf.copen,
          lopen = RUtils.qf.lopen,
        },
      },
    },
    config = function(_, opts)
      require("rmux").setup(opts)
    end,
  },
  -- REFACTORING
  {
    "ThePrimeagen/refactoring.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      {
        "<Localleader>rf",
        function()
          local refactoring = require "refactoring"
          local fzf_lua = require "fzf-lua"
          local results = refactoring.get_refactors()

          local opts = {
            prompt = "  ",
            winopts = {
              title = RUtils.fzflua.format_title("Refactoring?", ""),
              border = "rounded",
              height = #results + 3,
              width = 0.30,
              row = 1.05,
              backdrop = 100,
              relative = "cursor",
            },
            actions = {
              ["default"] = function(selected)
                refactoring.refactor(selected[1])
              end,
            },
          }
          fzf_lua.fzf_exec(results, opts)
        end,
        mode = { "n", "x" },
        desc = "Refactoring: select or pick [refactoring]",
      },

      -- Extract
      {
        "<Localleader>rei",
        function()
          return require("refactoring").refactor "Inline Variable"
        end,
        mode = { "n", "x" },
        desc = "Refactoring: inline variable [refactoring]",
        expr = true,
      },
      {
        "<Localleader>reb",
        function()
          return require("refactoring").refactor "Extract Block"
        end,
        mode = { "n", "x" },
        desc = "Refactoring: extract block [refactoring]",
        expr = true,
      },
      {
        "<Localleader>ref",
        function()
          return require("refactoring").refactor "Extract Function"
        end,
        mode = { "n", "x" },
        desc = "Refactoring:: extract function [refactoring]",
        expr = true,
      },
      {
        "<Localleader>rev",
        function()
          return require("refactoring").refactor "Extract Variable"
        end,
        mode = { "n", "x" },
        desc = "Refactoring:: extract variable [refactoring]",
        expr = true,
      },
      {
        "<Localleader>reF",
        function()
          return require("refactoring").refactor "Extract Function To File"
        end,
        mode = { "n", "x" },
        desc = "Refactoring:: extract function to file [refactoring]",
        expr = true,
      },

      -- Printout
      {
        "<Localleader>rP",
        function()
          require("refactoring").debug.printf { below = false }
        end,
        desc = "Refactoring: debug print [refactoring]",
      },
      {
        "<Localleader>rp",
        function()
          require("refactoring").debug.print_var { normal = true }
        end,
        desc = "Refactoring: debug print variable [refactoring]",
      },

      {
        "<Localleader>rC",
        function()
          require("refactoring").debug.cleanup {}
        end,
        desc = "Refactoring: debug cleanup [refactoring]",
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
  -- GITIGNORE.NVIM
  {
    "wintermute-cell/gitignore.nvim",
    ft = "gitignore",
    keys = {
      {
        "<Leader>rG",
        "<CMD>Gitignore<CR>",
        desc = "Task: select gitignore generate",
      },
    },
    config = function()
      require "gitignore"
    end,
  },
}
