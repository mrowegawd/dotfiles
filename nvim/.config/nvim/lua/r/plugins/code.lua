local Highlight = require "r.settings.highlights"

return {
  -- Auto complete cmp
  {
    import = "r.plugins.extras.coding.nvim-cmp",
    enabled = function()
      return RUtils.cmp_engine() == "nvim-cmp"
    end,
  },
  -- Auto complete Blink
  {
    import = "r.plugins.extras.coding.blink",
    enabled = function()
      return RUtils.cmp_engine() == "blink.cmp"
    end,
  },
  -- Auto complete Torch
  {
    import = "r.plugins.extras.coding.torch",
    enabled = function()
      return RUtils.cmp_engine() == "torch"
    end,
  },
  -- LUASNIP
  {
    import = "r.plugins.extras.coding.luasnip",
  },
  -- MINI.PAIRS
  {
    "echasnovski/mini.pairs",
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
    keys = {
      {
        "<Leader>up",
        function()
          vim.g.minipairs_disable = not vim.g.minipairs_disable
          if vim.g.minipairs_disable then
            RUtils.warn("Disabled auto pairs", { title = "Option" })
          else
            RUtils.info("Enabled auto pairs", { title = "Option" })
          end
        end,
        desc = "Toggle: auto pairs [mini.pairs]",
      },
    },
  },
  -- LAZYDEV
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        -- { path = "snacks.nvim", words = { "Snacks" } },
        { path = "RUtils", words = { "RUtils" } },
      },
    },
  },
  -- COMMENTS-TS-CONTEXT
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    opts = {
      enable_autocmd = false,
    },
    init = function()
      if vim.fn.has "nvim-0.10" == 1 then
        vim.schedule(function()
          local get_option = vim.filetype.get_option
          vim.filetype.get_option = function(filetype, option)
            return option == "commentstring" and require("ts_context_commentstring.internal").calculate_commentstring()
              or get_option(filetype, option)
          end
        end)
      end
    end,
  },
  -- TS-COMMENTS
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = true,
  },
  -- MINI.AI
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
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
    event = "VeryLazy",
    cmd = { "Scratch", "ScratchOpen" },
    opts = {
      scratch_file_dir = vim.fn.stdpath "cache" .. "/scratch.nvim", -- where your scratch files will be put
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

      Highlight.plugin("coverage_hi", {
        { CoverageCovered = { bg = { from = "ColorColumn", attr = "bg" } } },
        { CoveragePartial = { bg = { from = "ColorColumn", attr = "bg" } } },
        { CoverageUncovered = { bg = { from = "ColorColumn", attr = "bg" } } },
        { CoverageSummaryFail = { bg = { from = "ColorColumn", attr = "bg" } } },
      })
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
        min_height = 15,
        max_height = 15,
        bindings = {
          ["<PageUp>"] = "ScrollOutputUp",
          ["<PageDown>"] = "ScrollOutputDown",
          ["P"] = "TogglePreview",
          ["<C-p>"] = "PrevTask",
          ["<C-n>"] = "NextTask",
          ["<C-h>"] = false, -- disabled because conflict with move_cursor window
          ["<C-l>"] = false,
          ["dd"] = "Dispose",
          ["q"] = function()
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
            ["<Tab>"] = "Next",
            ["<S-Tab>"] = "Prev",
            ["<C-n>"] = "Next",
            ["<C-p>"] = "Prev",
            ["<CR>"] = "NextOrSubmit",
            ["<C-s>"] = "Submit",
            ["<C-c>"] = "Cancel",
            ["<C-k>"] = false,
            ["<C-j>"] = false,
            ["<C-h>"] = false,
            ["<C-l>"] = false,
          },
          n = {
            ["<CR>"] = "NextOrSubmit",
            ["<Tab>"] = "Next",
            ["<S-Tab>"] = "Prev",
            ["<C-n>"] = "Next",
            ["<C-p>"] = "Prev",
            ["<C-s>"] = "Submit",
            ["<C-k>"] = false,
            ["<C-j>"] = false,
            ["<C-h>"] = false,
            ["<C-l>"] = false,
            ["q"] = "Cancel",
            ["?"] = "ShowHelp",
          },
        },
      },
    },
    config = function(_, opts)
      Highlight.plugin("overseernvim", {
        { OverseerTaskBorder = { fg = { from = "WinSeparator", attr = "fg" }, bg = "NONE" } },
      })

      require("overseer").setup(opts)

      vim.api.nvim_create_user_command("OverseerDebugParser", 'lua require("overseer").debug_parser()', {})
    end,
  },
  -- LUA-CONSOLE
  {
    "yarospace/lua-console.nvim",
    keys = { "`", "<Leader>`" },
    opts = {},
  },
  -- RUNMUX
  {
    -- "mrowegawd/runmux",
    dir = "~/.local/src/nvim_plugins/rmux",
    cmd = { "RmuxEDITConfig" },
    dependencies = {
      "stevearc/overseer.nvim",
    },
    keys = {
      { "<Leader>rf", "<Cmd> RmuxRunFile <CR>", desc = "Tasks: run task" },

      { "<Leader>rl", "<Cmd> RmuxSendline <CR>", desc = "Tasks: send line" },
      { "<Leader>rl", "<Cmd> RmuxSendVisualSelection <CR>", desc = "Tasks: send range line (visual)", mode = { "v" } },

      { "<Leader>rr", "<Cmd> RmuxKillAllPanes <CR>", desc = "Tasks: kill all panes" },
      { "<Leader>rg", "<Cmd> RmuxGrepErr <CR>", desc = "Tasks: grep problem from targeted pane" },

      { "<Leader>re", "<Cmd> RmuxEDITConfig <CR>", desc = "Tasks: edit rmuxrc.json" },
      { "<Leader>rE", "<Cmd> RmuxREDITConfig <CR>", desc = "Tasks: load global rmuxrc.json" },
      { "<Leader>rS", "<Cmd> RmuxSHOWConfig <CR>", desc = "Tasks: show setup config" },
    },
    opts = {
      base = {
        file_rc = ".rmuxrc.json",
        setnotif = true,
        auto_run_tasks = true,
        tbl_opened_panes = {},
        run_with = "auto", -- `mux, tt, wez, toggleterm`
      },
    },
    config = function(_, opts)
      require("rmux").setup(opts)
    end,
  },
  -- REFACTORING
  {
    "ThePrimeagen/refactoring.nvim",
    event = "LazyFile",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      {
        "<Localleader>rs",
        function()
          require("telescope").extensions.refactoring.refactors()
        end,
        mode = "v",
        desc = "Reactoring: select (visual) [refactoring]",
      },
      {
        "<Localleader>ri",
        function()
          require("refactoring").refactor "Inline Variable"
        end,
        mode = { "n", "v" },
        desc = "Reactoring: inline variable [refactoring]",
      },
      {
        "<Localleader>rb",
        function()
          require("refactoring").refactor "Extract Block"
        end,
        desc = "Reactoring: extract block [refactoring]",
      },
      {
        "<Localleader>rf",
        function()
          require("refactoring").refactor "Extract Block To File"
        end,
        desc = "Reactoring: extract block to file [refactoring]",
      },
      {
        "<Localleader>rP",
        function()
          require("refactoring").debug.printf { below = false }
        end,
        desc = "Reactoring: debug print [refactoring]",
      },
      {
        "<Localleader>rp",
        function()
          require("refactoring").debug.print_var { normal = true }
        end,
        desc = "Reactoring: debug print variable [refactoring]",
      },
      {
        "<Localleader>rc",
        function()
          require("refactoring").debug.cleanup {}
        end,
        desc = "Reactoring: debug cleanup [refactoring]",
      },
      {
        "<Localleader>rf",
        function()
          require("refactoring").refactor "Extract Function"
        end,
        mode = "v",
        desc = "Reactoring: extract function [refactoring]",
      },
      {
        "<Localleader>rF",
        function()
          require("refactoring").refactor "Extract Function To File"
        end,
        mode = "v",
        desc = "Reactoring: extract function to file (visual) [refactoring]",
      },
      {
        "<Localleader>rx",
        function()
          require("refactoring").refactor "Extract Variable"
        end,
        mode = "v",
        desc = "Reactoring: extract variable (visual) [refactoring]",
      },
      {
        "<Localleader>rp",
        function()
          require("refactoring").debug.print_var {}
        end,
        mode = "v",
        desc = "Reactoring: debug print variable [refactoring]",
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
}
