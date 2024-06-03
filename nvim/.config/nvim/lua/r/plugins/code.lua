local Highlight = require "r.settings.highlights"

local callme = 0

return {
  -- CRATES
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    config = true,
    -- { name = "crates" },
  },
  -- NVIM-CMP
  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "davidsierradz/cmp-conventionalcommits",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "lukas-reineke/cmp-rg",
      "lukas-reineke/cmp-under-comparator",
      "petertriho/cmp-git",
      -- "rcarriga/cmp-dap",
      { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
      --     luasnip.filetype_extend("python", { "django" })
      --     luasnip.filetype_extend("django-html", { "html" })
      --     luasnip.filetype_extend("htmldjango", { "html" })
      --
      --     luasnip.filetype_extend("javascript", { "html" })
      --     luasnip.filetype_extend("javascript", { "javascriptreact" })
      --     luasnip.filetype_extend("javascriptreact", { "html" })
      --     luasnip.filetype_extend("typescript", { "html" })
      --     luasnip.filetype_extend("typescriptreact", { "html", "react" })
      --     -- luasnip.filetype_extend("NeogitCommitMessage", { "gitcommit" })
    },
    opts = function()
      local MAX_INDEX_FILE_SIZE = 1024
      local cmp = require "cmp"
      local defaults = require "cmp.config.default"()

      local function styldoc(is_border_set)
        is_border_set = is_border_set or false

        local opts = {
          border = "",
          winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
          col_offset = -3, -- To fit lspkind icon
          side_padding = 1, -- One character margin
        }
        if is_border_set then
          opts.border = RUtils.config.icons.border.line
          opts.winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None"
        end
        return opts
      end
      return {
        auto_brackets = { "python" }, -- configure any filetype to auto add brackets
        window = {
          completion = cmp.config.window.bordered(styldoc()),
          documentation = cmp.config.window.bordered(styldoc(true)),
        },
        completion = { completeopt = "menuone,noinsert,noselect" },
        snippet = {
          expand = function(item)
            return RUtils.cmp.expand(item.body)
          end,
        },
        experimental = { ghost_text = false },
        duplicates = {
          nvim_lsp = 1,
          luasnip = 1,
          buffer = 1,
          rg = 1,
          path = 1,
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, item)
            local label_width = 30
            local label = item.abbr
            local truncated_label = vim.fn.strcharpart(label, 0, label_width)

            if truncated_label ~= label then
              item.abbr = truncated_label .. "…"
            elseif string.len(label) < label_width then
              local padding = string.rep(" ", label_width - string.len(label))
              item.abbr = label .. padding
            end

            -- print(entry.source.name)
            local item_kind = item.kind

            if item_kind == nil then
              item_kind = "x"
            end

            item.menu = item_kind
              .. " "
              .. (
                ({
                  nvim_lsp = "[LSP]",
                  obsidian = "[OBSIDIAN]",
                  obsidian_new = "[OBSIDIAN]",
                  nvim_lua = "[LUA]",
                  emoji = "[EMOJI]",
                  path = "[PATH]",
                  neorg = "[NEORG]",
                  dictionary = "[DIC]",
                  noice_popupmenu = "[Noice]",
                  buffer = "[BUF]",
                  spell = "[SPELL]",
                  orgmode = "[ORG]",
                  norg = "[NORG]",
                  rg = "[RG]",
                  cmdline = "[CMD]",
                  git = "[GIT]",
                })[entry.source.name] or ""
              )

            local hlkind = ("CmpItemKind%s"):format(item_kind)
            item.menu_hl_group = hlkind

            local kind = RUtils.config.icons.kinds
            if kind[item.kind] then
              item.kind = kind[item.kind]
            end
            return require("tailwindcss-colorizer-cmp").formatter(entry, item)
          end,
        },
        sorting = defaults.sorting,
        mapping = {
          ["<C-r>"] = cmp.mapping(function(_)
            if callme == 0 then
              callme = 1
              cmp.complete {}
            elseif callme == 1 then
              callme = 0
              cmp.complete {
                config = {
                  sources = {
                    {
                      name = "buffer",
                      keyword_length = 2,
                      options = {
                        get_bufnrs = function()
                          --- from all loaded buffers
                          local bufs = {}
                          local loaded_bufs = vim.api.nvim_list_bufs()
                          for _, bufnr in ipairs(loaded_bufs) do
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
            end
          end, {
            "i",
            "s",
          }),
          ["<c-j>"] = cmp.mapping(function()
            if cmp.core.view:visible() or vim.fn.pumvisible() == 1 then
              cmp.select_next_item()
            end
          end, { "i", "c" }),
          ["<c-k>"] = cmp.mapping(function()
            if cmp.core.view:visible() or vim.fn.pumvisible() == 1 then
              cmp.select_prev_item()
            end
          end, { "i", "c" }),
          ["<c-q>"] = cmp.mapping.abort(),
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<c-g>"] = cmp.mapping(function()
            require("fzf-lua").complete_file {
              cmd = "rg --files --hidden",
              winopts = { preview = { hidden = "nohidden" } },
            }
          end, { "i" }),
          -- ["<TAB>"] = cmp.mapping(tab, { "i", "s" }),
          -- ["<S-TAB>"] = cmp.mapping(shift_tab, { "i", "s" }),
          ["<c-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "c", "i" }),
          ["<c-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "c", "i" }),
          ["<CR>"] = RUtils.cmp.confirm(),
          ["<c-y>"] = RUtils.cmp.confirm { behavior = cmp.ConfirmBehavior.Replace },
          ["<C-e>"] = function(fallback)
            cmp.abort()
            fallback()
          end,
        },
        sources = { -- remember: do not use `group_index`,
          {
            name = "nvim_lsp",
            entry_filter = function(entry)
              return cmp.lsp.CompletionItemKind.Snippet ~= entry:get_kind()
            end,
          },
          {
            name = "rg",
            max_item_count = 10,
            option = { additional_arguments = "--hidden" },
          },
          {
            name = "buffer",
            max_item_count = 10,
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
          { name = "path" },
        },
      }
    end,

    ---@param opts cmp.ConfigSchema | {auto_brackets?: string[]}
    config = function(_, opts)
      for _, source in ipairs(opts.sources) do
        source.group_index = source.group_index or 1
      end

      local parse = require("cmp.utils.snippet").parse
      require("cmp.utils.snippet").parse = function(input)
        local ok, ret = pcall(parse, input)
        if ok then
          return ret
        end
        return RUtils.cmp.snippet_preview(input)
      end

      local cmp = require "cmp"
      cmp.setup(opts)
      cmp.event:on("confirm_done", function(event)
        if vim.tbl_contains(opts.auto_brackets or {}, vim.bo.filetype) then
          RUtils.cmp.auto_brackets(event.entry)
        end
      end)
      cmp.event:on("menu_opened", function(event)
        RUtils.cmp.add_missing_snippet_docs(event.window)
      end)

      local tbl_custom_sources = {
        { name = "nvim_lsp", max_item_count = 20 },
        { name = "buffer", max_item_count = 20 },
        { name = "snippets" },
        { name = "path", max_item_count = 20 },
        { name = "rg", max_item_count = 20 },
        { name = "emoji", max_item_count = 20 },
      }

      cmp.setup.filetype("markdown", {
        sources = cmp.config.sources(tbl_custom_sources),
      })

      cmp.setup.filetype({ "norg", "neorg" }, {
        sources = cmp.config.sources(vim.tbl_deep_extend("force", {}, tbl_custom_sources, { { name = "neorg" } })),
      })

      cmp.setup.filetype({ "org", "orgagenda" }, {
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

      cmp.setup.filetype({ "rgflow" }, {
        sources = cmp.config.sources { { name = "buffer" }, { name = "rg" }, { name = "path" } },
      })

      cmp.setup.cmdline(":", {
        mapping = {
          -- ["<C-l>"] = cmp.mapping(function()
          --   cmp.confirm { select = true }
          --   RUtils.map.feedkey("<CR>", "")
          -- end, { "c" }),
          ["<Tab>"] = cmp.mapping(function()
            cmp.confirm { select = true }
            RUtils.map.feedkey("<CR>", "")
          end, { "c" }),
          ["<c-q>"] = {
            c = function(fallback)
              if cmp.visible() then
                cmp.abort()
              else
                fallback()
              end
            end,
          },
        },
        sources = cmp.config.sources {
          { name = "path" },
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "Man", "!" },
            },
          },
        },
      })

      cmp.setup.cmdline({ "/", "?" }, {
        -- mapping = {
        --   -- ["<C-l>"] = cmp.mapping(function()
        --   --   cmp.confirm { select = true }
        --   --   RUtils.map.feedkey("<CR>", "")
        --   -- end, { "c" }),
        --   ["<Tab>"] = cmp.mapping(function()
        --     cmp.confirm { select = true }
        --     RUtils.map.feedkey("<CR>", "")
        --   end, { "c" }),
        --   ["<c-q>"] = {
        --     c = function(fallback)
        --       if cmp.visible() then
        --         cmp.abort()
        --       else
        --         fallback()
        --       end
        --     end,
        --   },
        -- },
        sources = cmp.config.sources {
          { name = "buffer" },
          { name = "registers" },
        },
      })
    end,
  },
  -- NVIM-SNIPPETS
  {
    "nvim-cmp",
    dependencies = {
      {
        "garymjr/nvim-snippets",
        opts = {
          friendly_snippets = true,
          search_paths = { RUtils.config.path.snippet_path .. "/snippets" },
        },
      },
    },
    opts = function(_, opts)
      opts.snippet = {
        expand = function(item)
          return RUtils.cmp.expand(item.body)
        end,
      }
      table.insert(opts.sources, { name = "snippets" })
    end,
    keys = {
      {
        "<Tab>",
        function()
          return vim.snippet.active { direction = 1 } and "<cmd>lua vim.snippet.jump(1)<cr>" or "<Tab>"
        end,
        expr = true,
        silent = true,
        mode = { "i", "s" },
      },
      {
        "<S-Tab>",
        function()
          return vim.snippet.active { direction = -1 } and "<cmd>lua vim.snippet.jump(-1)<cr>" or "<Tab>"
        end,
        expr = true,
        silent = true,
        mode = { "i", "s" },
      },
    },
  },
  -- MINI.PAIRS
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {
      mappings = {
        ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\`].", register = { cr = false } },
      },
    },
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
        desc = "Misc: toggle auto pairs [mini.pairs]",
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
    opts = {},
    enabled = vim.fn.has "nvim-0.10" == 1,
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
  -- SCRATCH
  {
    "LintaoAmons/scratch.nvim",
    cmd = { "Scratch", "ScratchOpen" },
    tag = "v0.13.2",
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
  -- LUAROCKS
  {
    "vhyrro/luarocks.nvim",
    priority = 1000,
    config = true,
    opts = {
      rocks = {
        "lua-utils.nvim",
        "lua-curl",
        "nvim-nio",
        "mimetypes",
        "pathlib.nvim",
        "xml2lua",
      }, -- Specify LuaRocks packages to install
    },
  },
  -- REST.NVIM
  {
    "rest-nvim/rest.nvim",
    ft = "http",
    -- keys = {
    --   { "<Leader>rr", "<Plug>RestNvim", desc = "Open(rest-nvim): execute HTTP request" },
    dependencies = { "luarocks.nvim" },
    opts = { skip_ssl_verification = true },
    config = function(_, opts)
      require("rest-nvim").setup(opts)
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
        desc = "Task: toggle [overseer]",
      },
      {
        "rf",
        function()
          return vim.cmd "OverseerRun"
        end,
        desc = "Task: run [overseer]",
      },
      {
        "rd",
        function()
          return vim.cmd "OverseerDebugParser"
        end,
        desc = "Task: run [overseer]",
      },
    },

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
    config = function(_, opts)
      require("overseer").setup(opts)

      vim.api.nvim_create_user_command("OverseerDebugParser", 'lua require("overseer").debug_parser()', {})
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
      -- { "rR", "<Cmd> RmuxRunTaskAll <CR>", desc = "Tasks: run task all" },
      -- { "rp", "<Cmd> RmuxREPL <CR>", desc = "Tasks: open pane window REPL (if the language has any)" },

      { "rl", "<Cmd> RmuxSendline <CR>", desc = "Tasks: send line" },
      { "rl", "<Cmd> RmuxSendVisualSelection <CR>", desc = "Tasks: send range line (visual)", mode = { "v" } },

      -- { "rc", "<Cmd> RmuxSendInterrupt <CR>", desc = "Tasks: send interrupt signal to targeted pane" },
      -- { "rC", "<Cmd> RmuxSendInterruptAll <CR>", desc = "Tasks: send interrupt signal to all targeted pane" },

      -- { "rt", "<Cmd> RmuxTargetPane <CR>", desc = "Tasks: change target pane" },

      { "rC", "<Cmd> RmuxKillAllPanes <CR>", desc = "Tasks: kill all panes" },
      { "rg", "<Cmd> RmuxGrepErr <CR>", desc = "Tasks: grep problem from targeted pane" },

      { "re", "<Cmd> RmuxEDITConfig <CR>", desc = "Tasks: edit rmuxrc.json" },
      { "rE", "<Cmd> RmuxREDITConfig <CR>", desc = "Tasks: load global rmuxrc.json" },
      { "rS", "<Cmd> RmuxSHOWConfig <CR>", desc = "Tasks: show setup config" },

      -- { "<a-f>", "<Cmd> RmuxToggleTerm <CR>", desc = "Tasks: open rmux toggle terminal" },
    },
    opts = {
      base = {
        file_rc = ".rmuxrc.json",
        setnotif = true,
        auto_run_tasks = true,
        tbl_opened_panes = {},
        run_with = "wez", -- mux, tt, wez, toggleterm
      },
    },
    config = function(_, opts)
      require("rmux").setup(opts)
    end,
  },
}
