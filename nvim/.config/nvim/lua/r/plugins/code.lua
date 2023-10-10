_G.OverseerConfig = {} -- to store error formats

OverseerConfig.fnpane_run = 0
OverseerConfig.fnpane_runtest = 0
OverseerConfig.fnpane_runmisc = 0

local border = as.ui.border.rectangle
local icons = as.ui.icons
local fmt = string.format

local callme = 0

return {
  -- LUASNIP
  {
    "L3MON4D3/LuaSnip",
    build = (not jit.os:find "Windows")
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
      or nil,
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    -- stylua: ignore
    keys = {
      {
        "<tab>",
        function()
          return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
        end,
        expr = true,
        silent = true,
        mode = "i",
      },
      { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
      { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
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

      luasnip.filetype_extend("NeogitCommitMessage", { "gitcommit" })
    end,
  },
  -- CMP
  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = "InsertEnter",
    dependencies = {
      "davidsierradz/cmp-conventionalcommits",
      "dmitmel/cmp-cmdline-history",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "lukas-reineke/cmp-under-comparator",
      "rcarriga/cmp-dap",
      "saadparwaiz1/cmp_luasnip",

      "hrsh7th/cmp-nvim-lsp-document-symbol",
    },
    opts = function()
      local cmp = require "cmp"
      local has_luasnip, luasnip = pcall(require, "luasnip")
      local types = require "cmp.types"

      -- Based on (private) function in LuaSnip/lua/luasnip/init.lua.
      local in_snippet = function()
        local session = require "luasnip.session"
        local node = session.current_nodes[vim.api.nvim_get_current_buf()]
        if not node then
          return false
        end
        local snippet = node.parent.snippet
        local snip_begin_pos, snip_end_pos = snippet.mark:pos_begin_end()
        local pos = vim.api.nvim_win_get_cursor(0)
        if pos[1] - 1 >= snip_begin_pos[1] and pos[1] - 1 <= snip_end_pos[1] then
          return true
        end
      end

      local check_backspace = function()
        local col = vim.fn.col "." - 1
        ---@diagnostic disable-next-line: param-type-mismatch
        return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
      end
      return {
        enabled = function()
          return vim.api.nvim_get_option_value("buftype", { buf = 0 }) ~= "prompt" or require("cmp_dap").is_dap_buffer()
        end,
        window = {
          completion = {
            border = border, --single
            scrollbar = "║",
            col_offset = -1,
            winhighlight = "Normal:Normal,FloatBorder:FzfLuaBorder,CursorLine:PmenuSel,Search:None",
            -- side_padding = -1,
          },
          documentation = {
            border = border, -- "shadow", "rounded"
            winhighlight = "Normal:Normal,FloatBorder:FzfLuaBorder,Search:None",
            scrollbar = "║",
          },
        },

        completion = {
          completeopt = "menu,menuone,noinsert,noselect",
        },

        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },

        mapping = {
          ["<c-n>"] = cmp.mapping(function()
            local c_cmp = require "cmp"
            if c_cmp.visible() then
              c_cmp.select_next_item()
            else
              require("cmp").complete()
            end
          end, { "i", "s" }),
          ["<c-p>"] = cmp.mapping(function(fallback)
            local c_cmp = require "cmp"
            if c_cmp.visible() then
              c_cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<TAB>"] = cmp.mapping(function(fallback)
            if has_luasnip and luasnip.expandable() then
              luasnip.expand()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif check_backspace() then
              fallback()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-TAB>"] = cmp.mapping(function(fallback)
            if has_luasnip and in_snippet() and luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<c-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "c", "i" }),
          ["<c-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "c", "i" }),
          ["<c-l>"] = cmp.mapping.confirm { select = false },
          ["<cr>"] = cmp.mapping.confirm { select = false },
          ["<C-space>"] = cmp.mapping(function(_)
            local c_cmp = require "cmp"
            -- if c_cmp.visible() then
            --   c_cmp.abort()
            if callme == 0 then
              callme = 1
              c_cmp.complete {
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
                    {
                      name = "buffer",
                      option = {
                        get_bufnrs = function()
                          return vim.api.nvim_list_bufs()
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
        },

        sorting = {
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            require("cmp-under-comparator").under,
            function(entry1, entry2)
              local kind1 = entry1:get_kind()
              kind1 = kind1 == types.lsp.CompletionItemKind.Text and 100 or kind1
              local kind2 = entry2:get_kind()
              kind2 = kind2 == types.lsp.CompletionItemKind.Text and 100 or kind2
              if kind1 ~= kind2 then
                if kind1 == types.lsp.CompletionItemKind.Snippet then
                  return false
                end
                if kind2 == types.lsp.CompletionItemKind.Snippet then
                  return true
                end
                local diff = kind1 - kind2
                if diff < 0 then
                  return true
                elseif diff > 0 then
                  return false
                end
              end
            end,

            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
        -- experimental = {
        --     ghost_text = {
        --         hl_group = "LspCodeLens",
        --     },
        -- },
        formatting = {
          fields = { "abbr", "kind", "menu" },

          format = function(entry, vim_item)
            local MAX = math.floor(vim.o.columns * 0.5)
            if #vim_item.abbr >= MAX then
              vim_item.abbr = vim_item.abbr:sub(1, MAX) .. icons.misc.ellipsis
            end

            local item = entry:get_completion_item()
            if item.detail then
              vim_item.menu = item.detail
            end

            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              nvim_lua = "[Lua]",
              emoji = "[Emoji]",
              path = "[Path]",
              neorg = "[Neorg]",
              luasnip = "[Snip]",
              dictionary = "[Dict]",
              treesitter = "串",
              buffer = "[Buffer]",
              spell = "[Spell]",
              cmdline = "[Cmd]",
              cmdline_history = "[Hist]",
              orgmode = "[Org]",
              rg = "[Rg]",
              git = "[Git]",
            })[entry.source.name]

            vim_item.kind = fmt("%s  %s", icons.kind[vim_item.kind], vim_item.kind)

            -- remove duplicates
            vim_item.dup = ({
              buffer = 1,
              path = 1,
              nvim_lsp = 0,
            })[entry.source.name] or 0

            return vim_item
          end,
        },
        sources = cmp.config.sources {
          {
            name = "nvim_lsp",
            -- Remove snippet from lsp, use luasnip instead
            ---@diagnostic disable-next-line: unused-local
            entry_filter = function(entry, ctx)
              if entry:get_kind() == 15 then
                return false
              end
              return true
            end,
            -- group_index = 1,
          },
          { name = "luasnip" },
          { name = "path" },
          { name = "neorg" },
          {
            name = "buffer",
            option = {
              keyword_pattern = [[\k\+]],
              -- Enable completion from all visible buffers
              get_bufnrs = function()
                local bufs = {}
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                  bufs[vim.api.nvim_win_get_buf(win)] = true
                end
                return vim.tbl_keys(bufs)
              end,
            },
          },
        },
      }
    end,
    -- config = function(_, opts)
    --   local cmp = require "cmp"

    --   cmp.setup(opts)

    --   cmp.setup.filetype("markdown", {
    --     sources = cmp.config.sources({
    --       { name = "emoji" },
    --       { name = "luasnip" },
    --       { name = "path" },
    --       -- { name = "spell", group_index = 2 },
    --     }, {
    --       { name = "buffer" },
    --     }),
    --   })

    --   cmp.setup.filetype("norg", {
    --     sources = cmp.config.sources({
    --       { name = "neorg" },
    --       { name = "luasnip" },
    --       { name = "path" },
    --     }, {
    --       { name = "buffer" },
    --     }),
    --   })

    --   cmp.setup.filetype("org", {
    --     sources = cmp.config.sources({
    --       { name = "orgmode" },
    --       { name = "luasnip" },
    --       { name = "path" },
    --     }, {
    --       { name = "buffer" },
    --     }),
    --   })

    --   cmp.setup.filetype({ "gitcommit", "NeogitPopup" }, {
    --     sources = cmp.config.sources {
    --       { name = "path" },
    --       { name = "emoji" },
    --       { name = "buffer" },
    --     },
    --   })

    --   cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
    --     sources = cmp.config.sources({
    --       { name = "vim-dadbod-completion" },
    --     }, {
    --       { name = "buffer" },
    --     }),
    --   })
    --   cmp.setup.cmdline(":", {
    --     mapping = {
    --       ["<esc>"] = {
    --         c = function()
    --           require("r.utils").feedkey("<c-c>", "n")
    --         end,
    --       },
    --       ["<c-q>"] = {
    --         c = function(fallback)
    --           if require("cmp").visible() then
    --             require("cmp").abort()
    --           else
    --             fallback()
    --           end
    --         end,
    --       },
    --       ["<TAB>"] = {
    --         c = function()
    --           if require("cmp").visible() then
    --             require("cmp").select_next_item()
    --           else
    --             require("cmp").complete()
    --           end
    --         end,
    --       },
    --       ["<S-TAB>"] = {
    --         c = function(fallback)
    --           if require("cmp").visible() then
    --             require("cmp").select_prev_item()
    --           else
    --             fallback()
    --           end
    --         end,
    --       },
    --     },
    --     sources = cmp.config.sources({
    --       { name = "path" },
    --     }, { { name = "cmdline" }, { { name = "cmdline_history" } } }),
    --   })

    --   cmp.setup.cmdline({ "/", "?" }, {
    --     mapping = {
    --       ["<esc>"] = {
    --         c = function()
    --           require("r.utils").feedkey("<c-c>", "n")
    --         end,
    --       },
    --       ["<c-q>"] = {
    --         c = function(fallback)
    --           if require("cmp").visible() then
    --             require("cmp").abort()
    --           else
    --             fallback()
    --           end
    --         end,
    --       },
    --       ["<TAB>"] = {
    --         c = function()
    --           if require("cmp").visible() then
    --             require("cmp").select_next_item()
    --           else
    --             require("cmp").complete()
    --           end
    --         end,
    --       },
    --       ["<S-TAB>"] = {
    --         c = function(fallback)
    --           if require("cmp").visible() then
    --             require("cmp").select_prev_item()
    --           else
    --             fallback()
    --           end
    --         end,
    --       },
    --     },
    --     sources = {
    --       { name = "buffer" },
    --     },
    --   })
    -- end,
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
  -- TREESJ
  {
    "Wansmer/treesj",
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
  -- MINI-SURROUND
  {
    "echasnovski/mini.surround",
    keys = function(_, keys)
      -- Populate the keys based on the user's options
      local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
      local opts = require("lazy.core.plugin").values(plugin, "opts", false)
      local mappings = {
        {
          opts.mappings.add,
          desc = "Add surrounding",
          mode = { "n", "v" },
        },
        { opts.mappings.delete, desc = "Delete surrounding" },
        { opts.mappings.find, desc = "Find right surrounding" },
        { opts.mappings.find_left, desc = "Find left surrounding" },
        { opts.mappings.highlight, desc = "Highlight surrounding" },
        { opts.mappings.replace, desc = "Replace surrounding" },
        { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
      }
      mappings = vim.tbl_filter(function(m)
        return m[1] and #m[1] > 0
      end, mappings)
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      mappings = {
        add = "gza", -- Add surrounding in Normal and Visual modes
        delete = "gzd", -- Delete surrounding
        find = "gzf", -- Find surrounding (to the right)
        find_left = "gzF", -- Find surrounding (to the left)
        highlight = "gzh", -- Highlight surrounding
        replace = "gzc", -- Replace surrounding
        update_n_lines = "gzn", -- Update `n_lines`
      },
    },
  },
  -- COPILOT (disabled)
  {
    "zbirenbaum/copilot.lua",
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
  -- OVERSEER.NVIM
  {
    "stevearc/overseer.nvim", -- Task runner and job management
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
      -- as.augroup("RunOverseerTasks", {
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
    --       require("r.utils.tiling").force_win_close({ "neo-tree", "undotree" }, false)
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
  -- LUAPAD
  {
    "rafcamlet/nvim-luapad",
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
      { "<Localleader>or", "<Plug>RestNvim", desc = "Open(rest-nvim): execute HTTP request" },
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
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                        MY PLUGINS                        │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    dir = "~/.local/src/nvim_plugins/runmux",
    keys = {
      { "rf", "<Cmd> RmuxRunFile <CR>" },
      { "rP", "<Cmd> RmuxSetPane <CR>" },
      { "rR", "<Cmd> RmuxREPL <CR>" },
      { "rl", "<Cmd> RmuxSendline <CR>" },
      { "rl", "<Cmd> VRemuxSendline <CR>", mode = { "v" } },
      { "ri", "<Cmd> RmuxSendInterrupt <CR>" },
      { "rI", "<Cmd> RmuxSendInterruptAll <CR>" },
      { "rt", "<Cmd> RmuxTargetPane <CR>" },
      { "rL", "<Cmd> RmuxLOADConfig <CR>" },
      { "rC", "<Cmd> RmuxKillAllPanes <CR>" },
      { "rA", "<Cmd> RmuxRunTaskAll <CR>" },
    },
    opts = {},
    config = function(_, opts)
      require("rmux").setup(opts)
    end,
  },
}
