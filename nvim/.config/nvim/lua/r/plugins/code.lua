local Util = require "r.utils"

_G.OverseerConfig = {} -- to store error formats

OverseerConfig.fnpane_run = 0
OverseerConfig.fnpane_runtest = 0
OverseerConfig.fnpane_runmisc = 0

local callme = 0

local function get_cmp()
  local ok_cmp, cmp = pcall(require, "cmp")
  return ok_cmp and cmp or {}
end
local function get_luasnip()
  local ok_luasnip, luasnip = pcall(require, "luasnip")
  return ok_luasnip and luasnip or {}
end

return {
  -- LUASNIP
  {
    "L3MON4D3/LuaSnip",
    ---@diagnostic disable-next-line: undefined-global
    build = (not jit.os:find "Windows")
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
      or nil,
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    config = function()
      local luasnip = require "luasnip"

      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load {
        paths = "~/Dropbox/friendly-snippets",
      }

      luasnip.filetype_extend("python", { "django" })
      luasnip.filetype_extend("django-html", { "html" })
      luasnip.filetype_extend("htmldjango", { "html" })

      luasnip.filetype_extend("javascript", { "html" })
      luasnip.filetype_extend("javascript", { "javascriptreact" })
      luasnip.filetype_extend("javascriptreact", { "html" })
      luasnip.filetype_extend("typescript", { "html" })
      luasnip.filetype_extend("typescriptreact", { "html", "react" })

      -- luasnip.filetype_extend("NeogitCommitMessage", { "gitcommit" })
    end,
  },
  -- VIM-MATCHUP (disabled)
  {
    "andymass/vim-matchup",
    enabled = false,
    event = "VeryLazy",
    config = function()
      vim.g.matchup_matchparen_deferred = 1 -- work async
      vim.g.matchup_matchparen_offscreen = {} -- disable status bar icon
    end,
  },
  -- CMP
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "davidsierradz/cmp-conventionalcommits",
      "dmitmel/cmp-cmdline-history",
      "hrsh7th/cmp-buffer",
      "rcarriga/cmp-dap",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-emoji",
      "petertriho/cmp-git",
      "lukas-reineke/cmp-under-comparator",
      "saadparwaiz1/cmp_luasnip",
      { "abecodes/tabout.nvim", opts = { ignore_beginning = false, completion = false } },
    },
    opts = function()
      local cmp = require "cmp"
      local luasnip = require "luasnip"
      -- local types = require "cmp.types"
      local defaults = require "cmp.config.default"()
      local MAX_INDEX_FILE_SIZE = 4000

      local function tab(fallback) -- make TAB behave like Android Studio
        local cmpx = get_cmp()
        local luasnipx = get_luasnip()

        local col = vim.fn.col "." - 1

        if cmpx.visible() then
          cmpx.confirm { select = true }
        elseif luasnipx.expand_or_jumpable() then
          luasnipx.expand_or_jump()
        elseif col == 0 or vim.fn.getline("."):sub(col, col):match "%s" then
          fallback()
        else
          fallback()
        end
      end

      local function shift_tab(fallback)
        local luasnipx = get_luasnip()
        if luasnipx.jumpable(-1) then
          luasnipx.jump(-1)
        else
          fallback()
        end
      end

      local border_opts = {
        border = require("r.config").icons.border.rectangle,
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
      }

      return {
        enabled = function()
          return vim.api.nvim_get_option_value("buftype", { buf = 0 }) ~= "prompt" or require("cmp_dap").is_dap_buffer()
        end,
        window = {
          completion = cmp.config.window.bordered(border_opts),
          documentation = cmp.config.window.bordered(border_opts),
        },

        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        mapping = {
          ["<C-y>"] = cmp.mapping(function(_)
            -- if cmp.visible() then
            --   cmp.abort()
            if callme == 0 then
              callme = 1
              cmp.complete {
                config = {
                  sources = {
                    { name = "luasnip" },
                  },
                },
              }
            elseif callme == 1 then
              callme = 2
              cmp.complete {
                config = {
                  sources = {
                    { name = "cmp_tabnine" },
                    {
                      name = "buffer",
                      option = {
                        get_bufnrs = function()
                          local bufs = {}
                          for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                            -- Don't index giant files
                            if
                              vim.api.nvim_buf_is_loaded(bufnr)
                              and vim.api.nvim_buf_line_count(bufnr) < MAX_INDEX_FILE_SIZE
                            then
                              table.insert(bufs, bufnr)
                            end
                          end
                          return bufs
                        end,
                      },
                    },
                  },
                },
              }
            else
              if callme == 2 then
                callme = 0
                cmp.complete {
                  config = {
                    sources = {
                      { name = "nvim_lsp" },
                    },
                  },
                }
              end
            end
          end, {
            "i",
            "s",
          }),
          ["<c-n>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_next_item()
            else
              cmp.complete()
            end
          end, { "i", "s" }),
          ["<c-p>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<c-q>"] = cmp.mapping.abort(),
          ["<TAB>"] = cmp.mapping(tab, { "i", "s" }),
          ["<S-TAB>"] = cmp.mapping(shift_tab, { "i", "s" }),
          ["<c-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "c", "i" }),
          ["<c-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "c", "i" }),
          ["<cr>"] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true },
        },

        experimental = { ghost_text = false },
        sorting = defaults.sorting,
        duplicates = {
          nvim_lsp = 1,
          luasnip = 1,
          cmp_tabnine = 1,
          buffer = 1,
          path = 1,
        },
        formatting = {
          fields = { "abbr", "kind", "menu" },
          format = function(_, item)
            local icons = require("r.config").icons.kinds
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end
          end,
        },

        sources = cmp.config.sources {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
          {
            name = "buffer",
            keyword_length = 4,
            options = {
              get_bufnrs = function()
                local bufs = {}
                for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                  -- Don't index giant files
                  if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_line_count(bufnr) < MAX_INDEX_FILE_SIZE then
                    table.insert(bufs, bufnr)
                  end
                end
                return bufs
              end,
            },
          },
        },
      }
    end,
    config = function(_, opts)
      local cmp = require "cmp"

      for _, source in ipairs(opts.sources) do
        source.group_index = source.group_index or 1
      end
      cmp.setup(opts)

      local tbl_custom_sources = {
        { name = "luasnip" },
        { name = "path" },
        { name = "buffer" },
        { name = "emoji" },
      }

      cmp.setup.filetype("markdown", {
        sources = cmp.config.sources(tbl_custom_sources),
      })

      cmp.setup.filetype({ "norg", "neorg" }, {
        sources = cmp.config.sources(vim.tbl_deep_extend("force", {}, tbl_custom_sources, { { name = "neorg" } })),
      })

      cmp.setup.filetype("org", {
        sources = cmp.config.sources(vim.tbl_deep_extend("force", {}, tbl_custom_sources, { { name = "orgmode" } })),
      })

      cmp.setup.filetype("dap-repl", {
        sources = cmp.config.sources { { name = "dap" }, { name = "buffer" } },
      })

      cmp.setup.filetype({ "gitcommit", "NeogitPopup", "NeogitCommitMessage" }, {
        sources = vim.tbl_deep_extend("force", {}, tbl_custom_sources, { { name = "git" } }),
      })

      cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
        sources = cmp.config.sources { { name = "vim-dadbod-completion" }, { name = "buffer" } },
      })

      cmp.setup.cmdline(":", {
        mapping = {
          ["<esc>"] = {
            c = function()
              Util.cmd.feedkey("<c-c>", "n")
            end,
          },
          ["<c-q>"] = {
            c = function(fallback)
              if cmp.visible() then
                cmp.abort()
              else
                fallback()
              end
            end,
          },
          ["<TAB>"] = {
            c = function()
              if cmp.visible() then
                cmp.select_next_item()
              else
                cmp.complete()
              end
            end,
          },
          ["<S-TAB>"] = {
            c = function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              else
                fallback()
              end
            end,
          },
        },
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
          { { name = "cmdline_history" } },
        }),
      })

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = {
          ["<esc>"] = {
            c = function()
              Util.cmd.feedkey("<c-c>", "n")
            end,
          },
          ["<c-q>"] = {
            c = function(fallback)
              if cmp.visible() then
                cmp.abort()
              else
                fallback()
              end
            end,
          },
          ["<TAB>"] = {
            c = function()
              if cmp.visible() then
                cmp.select_next_item()
              else
                cmp.complete()
              end
            end,
          },
          ["<S-TAB>"] = {
            c = function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              else
                fallback()
              end
            end,
          },
        },
        sources = cmp.config.sources {
          { name = "buffer" },
        },
      })
    end,
  },
  -- Show TabNine status in lualine
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      local icon = require("lazyvim.config").icons.kinds.TabNine
      table.insert(opts.sections.lualine_x, 2, require("lazyvim.util").lualine.cmp_source("cmp_tabnine", icon))
    end,
  },
  -- COMMENT.NVIM
  {
    "numToStr/Comment.nvim",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    keys = { { "gc", mode = { "n", "v" } }, { "gcc", mode = { "n", "v" } }, { "gbc", mode = { "n", "v" } } },
    config = function(_, _)
      local opts = {
        ignore = "^$",
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
      require("Comment").setup(opts)
    end,
  },
  -- TREESJ (disabled)
  {
    "Wansmer/treesj",
    enabled = false,
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    keys = {
      { "<leader>rj", "<cmd>TSJToggle<cr>", desc = "Misc(treesj): toggle split/join" },
    },
    config = function()
      require("treesj").setup {
        use_default_keymaps = false,
      }
    end,
  },
  -- COPILOT (disabled)
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    enabled = false,
    config = function()
      require("copilot").setup {}
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
        commands = false,
        highlights = {
          covered = { fg = "green" },
          uncovered = { fg = "red" },
        },
      }
    end,
  },
  -- OVERSEER.NVIM (disabled)
  {
    "stevearc/overseer.nvim", -- Task runner and job management
    enabled = false,
    -- cmd = {
    --   "OverseerToggle",
    --   "OverseerOpen",
    --   "OverseerInfo",
    --   "OverseerRun",
    --   "OverseerBuild",
    --   "OverseerClose",
    --   "OverseerLoadBundle",
    --   "OverseerSaveBundle",
    --   "OverseerDeleteBundle",
    --   "OverseerRunCmd",
    --   "OverseerQuickAction",
    --   "OverseerTaskAction",
    -- },
    init = function()
      -- Util.cmd.augroup("RunOverseerTasks", {
      --   event = { "FileType" },
      --   pattern = as.lspfiles,
      --   command = function()
      --     -- vim.keymap.set("n", "<F4>", function()
      --     --   local overseer = require "overseer"
      --     --   local tasks = overseer.list_tasks {
      --     --     recent_first = true,
      --     --   }
      --     --
      --     --   if vim.tbl_isempty(tasks) then
      --     --     return vim.notify("No tasks found", vim.log.levels.WARN)
      --     --   else
      --     --     return overseer.run_action(tasks[1], "restart")
      --     --   end
      --     -- end, {
      --     --   desc = "Task(overseer): run or restart the task",
      --     --   buffer = api.nvim_get_current_buf(),
      --     -- })
      --
      --     vim.keymap.set("n", "<F1>", function()
      --       if vim.bo.filetype ~= "OverseerList" then
      --         return cmd "OverseerRun"
      --       end
      --       return cmd "OverseerQuickAction"
      --     end, {
      --       desc = "Task(overseer): run quick action",
      --       buffer = api.nvim_get_current_buf(),
      --     })
      --   end,
      -- })
    end,
    -- keys = {
    --   {
    --     "rt",
    --     function()
    --       Util.tiling.force_win_close({ "neo-tree", "undotree" }, false)
    --       return cmd "OverseerToggle!"
    --     end,
    --     desc = "Task(overseer): toggle",
    --   },
    -- },
    opts = {
      templates = { "builtin", "user" },
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
        min_height = 25,
        max_height = 25,
        bindings = {
          ["<S-tab>"] = "ScrollOutputUp",
          ["<tab>"] = "ScrollOutputDown",
          ["q"] = function()
            vim.cmd "OverseerClose"
          end,
          ["<c-k>"] = false,
          ["<c-j>"] = false,
        },
      },
    },
  },
  -- LUAPAD (disabled)
  {
    "rafcamlet/nvim-luapad",
    enabled = false,
    cmd = { "Luapad" },
    config = true,
  },
  -- SCRATCH
  {
    "LintaoAmons/scratch.nvim",
    cmd = { "Scratch", "ScratchOpen" },
    keys = {
      {
        "<Localleader>oS",
        "<CMD>Scratch<CR>",
        desc = "Open(scratch): open with select language",
      },
      {
        "<Localleader>os",
        "<CMD>ScratchOpen<CR>",
        desc = "Open(scratch): open",
      },
    },
  },
  -- REST.NVIM
  {
    "rest-nvim/rest.nvim",
    ft = "http",
    keys = {
      { "<Leader>rr", "<Plug>RestNvim", desc = "Open(rest-nvim): execute HTTP request" },
    },
    opts = { skip_ssl_verification = true },
  },
  -- ULTIMATE-AUTOPAIR (disabled)
  {
    "altermo/ultimate-autopair.nvim",
    enabled = false,
    event = { "InsertEnter", "CmdlineEnter" },
    branch = "v0.6",
    opts = {},
  },
  -- NVIM-AUTOPAIRS
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    opts = {
      close_triple_quotes = true,
      check_ts = true,
      ts_config = {
        lua = { "string" },
        dart = { "string" },
        javascript = { "template_string" },
      },
      disable_filetype = {
        "TelescopePrompt",
        "spectre_panel",
        "neo-tree-popup",
        "vim",
      },

      fast_wrap = { map = "<c-g>" },
      highlight = "PmenuSel",
      highlight_grey = "LineNr",
    },
    config = function(_, opts)
      local npairs = require "nvim-autopairs"
      npairs.setup(opts)

      local cmp = require "cmp"
      local has_autopairs, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
      if has_autopairs then
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })
      end

      local handlers = require "nvim-autopairs.completion.handlers"
      cmp.event:on(
        "confirm_done",
        cmp_autopairs.on_confirm_done {
          filetypes = {
            ["*"] = {
              ["("] = {
                kind = {
                  cmp.lsp.CompletionItemKind.Function,
                  cmp.lsp.CompletionItemKind.Method,
                },
                handler = handlers["*"],
              },
            },
          },
        }
      )
    end,
  },
  -- RUNMUX
  {
    -- "mrowegawd/runmux",
    dir = "~/.local/src/nvim_plugins/runmux",
    cmd = { "RmuxEDITConfig" },
    keys = {
      { "rf", "<Cmd> RmuxRunFile <CR>" },
      { "rP", "<Cmd> RmuxSetPane <CR>" },
      { "rR", "<Cmd> RmuxREPL <CR>" },
      { "rl", "<Cmd> RmuxSendline <CR>" },
      { "rl", "<Cmd> VRemuxSendline <CR>", mode = { "v" } },
      { "ri", "<Cmd> RmuxSendInterrupt <CR>" },
      { "rI", "<Cmd> RmuxSendInterruptAll <CR>" },
      { "rt", "<Cmd> RmuxTargetPane <CR>" },

      { "rC", "<Cmd> RmuxKillAllPanes <CR>" },
      { "rA", "<Cmd> RmuxRunTaskAll <CR>" },

      { "re", "<Cmd> RmuxEDITConfig <CR>" },
      { "rE", "<Cmd> RmuxREDITConfig <CR>" },
    },
    opts = {
      base = {
        file_rc = ".rmuxrc.json",
        setnotif = true,
        auto_run_tasks = true,
        tbl_opened_panes = {},
        run_with = "tmux", -- tmux, tt
      },
    },
    config = function(_, opts)
      require("rmux").setup(opts)
    end,
  },
}
