local Highlight = require "r.settings.highlights"

local callme = 0

local function get_cmp()
  local ok_cmp, cmp = pcall(require, "cmp")
  return ok_cmp and cmp or {}
end

return {
  -- NVIM-CMP
  {
    "hrsh7th/nvim-cmp",
    version = false, -- Last release is way too old
    event = { "InsertEnter", "CmdLineEnter" },
    dependencies = {
      "davidsierradz/cmp-conventionalcommits",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-nvim-lsp",
      "FelipeLema/cmp-async-path",
      "lukas-reineke/cmp-under-comparator",
      "rcarriga/cmp-dap",
      { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
    },
    opts = function()
      Highlight.plugin("cmp_hijackcol", {
        { CmpItemAbbrDefault = { fg = { from = "CmpItemAbbr", attr = "fg" } } },
      })

      local cmp = require "cmp"
      local defaults = require "cmp.config.default"()

      local function get_lsp_completion_context(completion, source)
        local ok, source_name = pcall(function()
          return source.source.client.config.name
        end)
        if not ok then
          return nil
        end
        if source_name == "tsserver" then
          return completion.detail
        elseif source_name == "gopls" then
          return completion.detail
        elseif source_name == "rust_analyzer" then
          return completion.detail
        elseif source_name == "zls" then
          return completion.detail
        elseif source_name == "lua_ls" then
          return completion.detail
        end
      end
      return {
        auto_brackets = { "lua" }, -- Configure any filetype to auto add brackets
        enabled = function()
          local disabled = false
          disabled = disabled or (RUtils.cmd.get_option "buftype" == "prompt")
          disabled = disabled or (RUtils.cmd.get_option "buftype" == "terminal")
          disabled = disabled or (RUtils.cmd.get_option "filetype" == "")
          disabled = disabled or (vim.fn.reg_recording() ~= "")
          disabled = disabled or (vim.fn.reg_executing() ~= "")
          return not disabled
        end,
        window = {
          completion = cmp.config.window.bordered {
            winhighlight = "Normal:Pmenu,FloatBorder:CmpItemFloatBorder,CursorLine:PmenuSel,Search:None",
            col_offset = -5, -- To fit `lspkind` icon
            side_padding = 1, -- One character margin
            border = {
              { "󱐋", "CmpItemIconWarningMsg" },
              { "─", "CmpItemFloatBorder" },
              { "╮", "CmpItemFloatBorder" },
              { "│", "CmpItemFloatBorder" },
              { "╯", "CmpItemFloatBorder" },
              { "─", "CmpItemFloatBorder" },
              { "╰", "CmpItemFloatBorder" },
              { "│", "CmpItemFloatBorder" },
            },
          },
          documentation = cmp.config.window.bordered {
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
            border = {
              { "", "DiagnosticHint" },
              { "─", "FloatBorder" },
              { "╮", "FloatBorder" },
              { "│", "FloatBorder" },
              { "╯", "FloatBorder" },
              { "─", "FloatBorder" },
              { "╰", "FloatBorder" },
              { "│", "FloatBorder" },
            },
          },
        },
        completion = { completeopt = "menu,noinsert,noselect" },
        duplicates = {
          nvim_lsp = 1,
          luasnip = 1,
          buffer = 1,
          rg = 1,
          path = 1,
        },
        experimental = {
          ghost_text = true,
        },
        performance = {
          debounce = 0, -- default is 60ms
          throttle = 0, -- default is 30ms
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, item)
            local label_width = 50
            local label = item.abbr
            local truncated_label = vim.fn.strcharpart(label, 0, label_width)

            if truncated_label ~= label then
              item.abbr = truncated_label .. "…"
            elseif string.len(label) < label_width then
              local padding = string.rep(" ", label_width - string.len(label))
              item.abbr = label .. padding
            end

            -- To check `print(entry.source.name)`
            local item_kind = item.kind
            if item_kind == nil then -- Remove duplicate
              return {}
            end

            item.menu = item_kind
              .. " "
              .. (
                ({
                  obsidian = "[OBSIDIAN]",
                  obsidian_new = "[OBSIDIAN]",
                  nvim_lua = "[LUA]",
                  emoji = "[EMOJI]",
                  path = "[PATH]",
                  neorg = "[NEORG]",
                  dictionary = "[DIC]",
                  noice_popupmenu = "[Noice]",

                  spell = "[SPELL]",
                  orgmode = "[ORG]",
                  norg = "[NORG]",
                  rg = "[RG]",
                  git = "[GIT]",
                })[entry.source.name] or ""
              )

            local hlkind = ("CmpItemKind%s"):format(item_kind)
            item.menu_hl_group = hlkind

            local kind = RUtils.config.icons.kinds
            if kind[item.kind] then
              item.kind = kind[item.kind]
            end

            local completion_context = get_lsp_completion_context(entry.completion_item, entry.source)
            if completion_context ~= nil and completion_context ~= "" then
              item.menu = item.menu .. completion_context
            end

            return require("tailwindcss-colorizer-cmp").formatter(entry, item)
          end,
        },
        view = {
          entries = {
            follow_cursor = true,
          },
        },
        sorting = defaults.sorting,
        preselect = cmp.PreselectMode.None,
        mapping = {
          ["<C-j>"] = cmp.mapping(function()
            local cmps = get_cmp()
            local types = require "cmp.types"

            if cmps.visible() then
              -- if #cmps.get_entries() == 1 then
              --   cmps.confirm { select = true }
              -- else
              cmps.select_next_item {
                behavior = types.cmp.SelectBehavior.Select,
              }
              -- end
            else
              cmps.complete {}
            end
          end, { "i" }),
          ["<C-k>"] = cmp.mapping(function()
            local cmps = get_cmp()
            if cmps.visible() then
              cmps.select_prev_item { behavior = "Select" }
            end
          end, { "i" }),
          ["<C-g>"] = cmp.mapping(function()
            require("fzf-lua").complete_file {
              cmd = "rg --files --hidden",
              winopts = { preview = { hidden = "nohidden" } },
            }
          end, { "i" }),
          ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "c", "i" }),
          ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "c", "i" }),
          ["<PageDown>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "c", "i" }),
          ["<PageUp>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "c", "i" }),
          ["<CR>"] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false },
          ["<C-y>"] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true },
        },
        sources = {
          {
            name = "nvim_lsp",
            priority = 100,
            group_index = 1,
          },
          -- { name = "path", priority = 10, group_index = 9 },
          { name = "async_path", priority = 30, group_index = 5 },
          {
            name = "emoji",
            priority = 10,
            group_index = 9,
            entry_filter = function()
              if vim.bo.filetype ~= "gitcommit" then
                return false
              end
              return true
            end,
          },
          {
            name = "git",
            priority = 40,
            group_index = 4,
            entry_filter = function()
              if vim.bo.filetype ~= "gitcommit" then
                return false
              end
              return true
            end,
          },
          {
            name = "orgmode",
            priority = 40,
            group_index = 4,
            entry_filter = function()
              if vim.bo.filetype ~= "org" then
                return false
              end
              return true
            end,
          },
          { name = "vim-dadbod-completion" },
          {
            name = "buffer",
            max_item_count = 5,
            keyword_length = 2,
            priority = 50,
            group_index = 4,
            option = {
              get_bufnrs = function()
                return vim.tbl_filter(function(buf)
                  return vim.fn.buflisted(buf) == 1 and vim.fn.bufloaded(buf) == 1
                end, vim.api.nvim_list_bufs())
              end,
            },
          },
        },
      }
    end,
    main = "r.utils.cmp",
  },
  -- LUASNIP
  {
    "L3MON4D3/LuaSnip",
    event = "VeryLazy",
    build = (not RUtils.is_win())
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
      or nil,
    keys = {
      {
        "<Leader>fn",
        function()
          require("scissors").editSnippet()
        end,
        desc = "edit snippet [nvim-scissors]",
      },
      {
        "<Leader>fN",
        function()
          require("scissors").addNewSnippet()
        end,
        mode = { "n", "v" },
        desc = "add snippet [nvim-scissors]",
      },
    },
    dependencies = {
      {
        "chrisgrieser/nvim-scissors",
        opts = {
          snippetDir = RUtils.config.path.snippet_path,
        },
      },
      {
        "yioneko/nvim-cmp",
        dependencies = {
          "saadparwaiz1/cmp_luasnip",
        },
        opts = function(_, opts)
          local cmp = get_cmp()

          opts.snippet = {
            expand = function(args)
              require("luasnip").lsp_expand(args.body)
            end,
          }
          opts.mapping = vim.tbl_deep_extend("force", {}, opts.mapping, {
            ["<C-r>"] = cmp.mapping(function(_)
              if callme == 0 then
                callme = 1
                cmp.complete {}
              elseif callme == 1 then
                callme = 2
                cmp.complete {
                  config = {
                    sources = {
                      {
                        name = "buffer",
                        option = {
                          get_bufnrs = function()
                            return vim.tbl_filter(function(buf)
                              return vim.fn.buflisted(buf) == 1 and vim.fn.bufloaded(buf) == 1
                            end, vim.api.nvim_list_bufs())
                          end,
                        },
                      },
                    },
                  },
                }
              else
                callme = 0
                cmp.complete { config = { sources = { { name = "luasnip" } } } }
              end
            end, {
              "i",
              "s",
            }),
          })
          table.insert(opts.sources, {
            name = "luasnip",
            priority = 50,
            group_index = 1,
            option = { show_autosnippets = true, use_show_condition = false },
          })
        end,
      },
    },
    opts = {
      history = false,
      delete_check_events = "TextChanged",
    },
    config = function()
      local luasnip = require "luasnip"

      require("luasnip.loaders.from_vscode").lazy_load {
        paths = RUtils.config.path.snippet_path,
      }

      luasnip.filetype_extend("python", { "django" })
      luasnip.filetype_extend("django-html", { "html" })
      luasnip.filetype_extend("htmldjango", { "html" })

      luasnip.filetype_extend("javascript", { "html" })
      luasnip.filetype_extend("javascript", { "javascriptreact" })
      luasnip.filetype_extend("javascriptreact", { "html" })
      luasnip.filetype_extend("typescript", { "html" })
      luasnip.filetype_extend("typescriptreact", { "html", "react" })

      luasnip.filetype_extend("NeogitCommitMessage", { "gitcommit" })
    end,
  },
  -- NVIM-CMP Keys
  {
    "nvim-cmp",
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require "cmp"

      opts.mapping = vim.tbl_deep_extend("force", {}, opts.mapping, {
        ["<c-p>"] = cmp.mapping {
          i = function()
            if require("luasnip").expand_or_jumpable() then
              require("luasnip").jump(1)
            end
          end,
          s = function()
            if require("luasnip").expand_or_jumpable() then
              require("luasnip").jump(1)
            end
          end,
        },
        ["<c-n>"] = cmp.mapping(function()
          if require("luasnip").jumpable(-1) then
            require("luasnip").jump(-1)
          end
        end, { "i", "s" }),
      })
    end,
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
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  -- LIVIT_META
  {
    -- Manage `libuv` types with lazy. Plugin will never be loaded
    "Bilal2453/luvit-meta",
    lazy = true,
  },
  {
    "yioneko/nvim-cmp",
    opts = function(_, opts)
      table.insert(opts.sources, { name = "lazydev", group_index = 0 })
    end,
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
    enabled = vim.fn.has "nvim-0.10" == 1,
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
        "<Localleader>oS",
        "<CMD>Scratch<CR>",
        desc = "Misc: select filetype for scratch buffer [scratch]",
      },
      {
        "<Localleader>os",
        "<CMD>ScratchOpen<CR>",
        desc = "Misc: open scratch buffer [scratch]",
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
    keys = {
      {
        "rr",
        function()
          return vim.cmd "OverseerToggle!"
        end,
        desc = "Tasks: toggle [overseer]",
      },
      {
        "rf",
        function()
          return vim.cmd "OverseerRun"
        end,
        desc = "Tasks: run [overseer]",
      },
      {
        "rd",
        function()
          return vim.cmd "OverseerDebugParser"
        end,
        desc = "Tasks: run [overseer]",
      },
    },

    opts = {
      templates = { "builtin", "user" },
      actions = {
        -- How to stop horizontal scroll??
        -- relate issue https://github.com/stevearc/overseer.nvim/issues/207
        ["open tab"] = {
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
  -- RUNMUX
  {
    -- "mrowegawd/runmux",
    dir = "~/.local/src/nvim_plugins/rmux",
    cmd = { "RmuxEDITConfig" },
    dependencies = {
      "stevearc/overseer.nvim",
    },
    keys = {
      { "rF", "<Cmd> RmuxRunFile <CR>", desc = "Tasks: run task" },

      { "rl", "<Cmd> RmuxSendline <CR>", desc = "Tasks: send line" },
      { "rl", "<Cmd> RmuxSendVisualSelection <CR>", desc = "Tasks: send range line (visual)", mode = { "v" } },

      { "rC", "<Cmd> RmuxKillAllPanes <CR>", desc = "Tasks: kill all panes" },
      { "rg", "<Cmd> RmuxGrepErr <CR>", desc = "Tasks: grep problem from targeted pane" },

      { "re", "<Cmd> RmuxEDITConfig <CR>", desc = "Tasks: edit rmuxrc.json" },
      { "rE", "<Cmd> RmuxREDITConfig <CR>", desc = "Tasks: load global rmuxrc.json" },
      { "rS", "<Cmd> RmuxSHOWConfig <CR>", desc = "Tasks: show setup config" },
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
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      {
        "<leader>rs",
        function()
          require("telescope").extensions.refactoring.refactors()
        end,
        mode = "v",
        desc = "Refactor: select (visual) [refactoring]",
      },
      {
        "<leader>ri",
        function()
          require("refactoring").refactor "Inline Variable"
        end,
        mode = { "n", "v" },
        desc = "Refactor: inline variable [refactoring]",
      },
      {
        "<leader>rb",
        function()
          require("refactoring").refactor "Extract Block"
        end,
        desc = "Refactor: extract block [refactoring]",
      },
      {
        "<leader>rf",
        function()
          require("refactoring").refactor "Extract Block To File"
        end,
        desc = "Refactor: extract block to file [refactoring]",
      },
      {
        "<leader>rP",
        function()
          require("refactoring").debug.printf { below = false }
        end,
        desc = "Refactor: debug print [refactoring]",
      },
      {
        "<leader>rp",
        function()
          require("refactoring").debug.print_var { normal = true }
        end,
        desc = "Refactor: debug print variable [refactoring]",
      },
      {
        "<leader>rc",
        function()
          require("refactoring").debug.cleanup {}
        end,
        desc = "Refactor: debug cleanup [refactoring]",
      },
      {
        "<leader>rf",
        function()
          require("refactoring").refactor "Extract Function"
        end,
        mode = "v",
        desc = "Refactor: extract function [refactoring]",
      },
      {
        "<leader>rF",
        function()
          require("refactoring").refactor "Extract Function To File"
        end,
        mode = "v",
        desc = "Refactor: extract function to file (visual) [refactoring]",
      },
      {
        "<leader>rx",
        function()
          require("refactoring").refactor "Extract Variable"
        end,
        mode = "v",
        desc = "Refactor: extract variable (visual) [refactoring]",
      },
      {
        "<leader>rp",
        function()
          require("refactoring").debug.print_var {}
        end,
        mode = "v",
        desc = "Refactor: debug print variable [refactoring]",
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
