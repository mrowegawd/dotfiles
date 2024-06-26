local Highlight = require "r.settings.highlights"

local callme = 0

return {
  -- NVIM-CMP
  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = "InsertEnter",
    dependencies = {
      "davidsierradz/cmp-conventionalcommits",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "lukas-reineke/cmp-under-comparator",
      "rcarriga/cmp-dap",
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
        auto_brackets = { "lua" }, -- configure any filetype to auto add brackets
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
          completion = cmp.config.window.bordered(styldoc()),
          documentation = cmp.config.window.bordered(styldoc(true)),
        },
        completion = { completeopt = "menuone,noinsert,noselect" },
        snippet = {
          expand = function(item)
            return RUtils.cmp.expand(item.body)
          end,
        },
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
            if item_kind == nil then -- remove duplicate
              return {}
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
                  -- codeium = "[Copilot]",
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

            local completion_context = get_lsp_completion_context(entry.completion_item, entry.source)
            if completion_context ~= nil and completion_context ~= "" then
              item.menu = item.menu .. completion_context
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
                      option = {
                        get_bufnrs = function()
                          return vim.api.nvim_list_bufs()
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
            if cmp.visible() or vim.fn.pumvisible() == 1 then
              cmp.select_next_item()
            else
              cmp.complete {}
            end
          end, { "i", "c" }),
          ["<c-k>"] = cmp.mapping(function()
            if cmp.visible() or vim.fn.pumvisible() == 1 then
              cmp.select_prev_item()
            end
          end, { "i", "c" }),
          ["<c-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<c-g>"] = cmp.mapping(function()
            require("fzf-lua").complete_file {
              cmd = "rg --files --hidden",
              winopts = { preview = { hidden = "nohidden" } },
            }
          end, { "i" }),
          ["<c-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "c", "i" }),
          ["<c-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "c", "i" }),
          ["<CR>"] = RUtils.cmp.confirm(),
          ["<c-y>"] = RUtils.cmp.confirm { behavior = cmp.ConfirmBehavior.Replace },
          ["<c-e>"] = function(fallback)
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
            name = "lazydev",
            group_index = 0, -- Set group index to 0 to skip loading LuaLS completions
          },
          { name = "path" },
          { name = "emoji" },
          { name = "orgmode" },
          { name = "vim-dadbod-completion" },
          { name = "buffer" },
        },
      }
    end,
    main = "r.utils.cmp",
  },
  -- NVIM-SNIPPETS
  {
    "nvim-cmp",
    dependencies = {
      {
        "garymjr/nvim-snippets",
        opts = {
          friendly_snippets = false,
          search_paths = { RUtils.config.path.snippet_path },
        },
      },
    },
    opts = function(_, opts)
      local cmp = require "cmp"

      -- local has_words_before = function()
      --   ---@diagnostic disable-next-line: deprecated
      --   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      --   return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
      -- end

      local function tab(fallback)
        local entry = cmp.get_selected_entry()

        if
          cmp.visible()
          and (
            entry ~= nil
            and not (entry.source.name == "spell" and entry.context.cursor_before_line:match(entry:get_word() .. "$"))
          )
        then
          cmp.confirm { select = false }
        elseif vim.snippet.active { direction = 1 } then
          vim.schedule(function()
            vim.snippet.jump(1)
          end)
        -- elseif has_words_before() then
        --   cmp.complete()
        else
          fallback()
        end
      end

      local function shift_tab(fallback)
        if vim.snippet.active { direction = -1 } then
          vim.schedule(function()
            vim.snippet.jump(-1)
          end)
        else
          fallback()
        end
      end

      opts.snippet = {
        expand = function(item)
          return RUtils.cmp.expand(item.body)
        end,
      }
      opts.mapping = vim.tbl_deep_extend("force", {}, opts.mapping, {
        ["<TAB>"] = cmp.mapping(tab, { "i", "s" }),
        ["<S-TAB>"] = cmp.mapping(shift_tab, { "i", "s" }),
      })

      if RUtils.has "nvim-snippets" then
        table.insert(opts.sources, { name = "snippets" })
      end
    end,
  },
  -- MINI.PAIRS
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {
      modes = { insert = true, command = true, terminal = false },
      -- skip autopair when next character is one of these
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      -- skip autopair when the cursor is inside these treesitter nodes
      skip_ts = { "string" },
      -- skip autopair when next character is closing pair
      -- and there are more closing pairs than opening pairs
      skip_unbalanced = true,
      -- better deal with markdown code blocks
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
        { path = "lazy.nvim", words = { "LazyVim" } },
      },
    },
  },
  -- LIVIT_META
  {
    -- Manage libuv types with lazy. Plugin will never be loaded
    "Bilal2453/luvit-meta",
    lazy = true,
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
    event = "VeryLazy",
    -- priority = 1000,
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
        min_height = 15,
        max_height = 15,
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
        run_with = "auto", -- mux, tt, wez, toggleterm
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
      { "<leader>r", "", desc = "Refactor: open", mode = { "n", "v" } },
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
          require("refactoring").debug.print_var()
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
      show_success_message = true, -- shows a message with information about the refactor on success
      -- i.e. [Refactor] Inlined 3 variable occurrences
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
