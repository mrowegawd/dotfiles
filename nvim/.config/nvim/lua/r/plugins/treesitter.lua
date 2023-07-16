local highlight = as.highlight

return {
  -- TREESITTER- CONTEXT
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    enabled = false, -- NOTE: something wrong with this plugin, error found (disable dahulu)
    init = function()
      highlight.plugin("treesitter-context", {
        { TreesitterContextSeparator = { link = "Directory" } },
        { TreesitterContext = { inherit = "Normal" } },
        { TreesitterContextLineNumber = { inherit = "LineNr" } },
      })
    end,
    opts = {
      multiline_threshold = 2,
      separator = "─", -- alternatives: ▁ ─ ▄
      -- separator = '--',
      mode = "cursor",
    },
  },
  -- TREESITTER
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
      { "JoosepAlviste/nvim-ts-context-commentstring" },
      { "mfussenegger/nvim-treehopper" },
      { "windwp/nvim-ts-autotag", config = true },
      {
        "HiPhish/rainbow-delimiters.nvim",
        config = function()
          local rainbow_delimiters = require "rainbow-delimiters"

          vim.g.rainbow_delimiters = {
            strategy = {
              [""] = rainbow_delimiters.strategy["global"],
            },
            query = {
              [""] = "rainbow-delimiters",
            },
          }
        end,
      },
      -- {
      --   "andymass/vim-matchup",
      --   event = "BufReadPost",
      --   enabled = false,
      --   config = function()
      --     -- vim.g.matchup_matchparen_offscreen = {} -- empty = disables
      --     vim.g.matchup_matchparen_offscreen = { method = "popup" }
      --   end,
      -- },
    },
    opts = function()
      -- local disable_max_size = 200000 -- 2MB

      -- local function should_disable(_, bufnr)
      --   local size = vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr or 0))
      --   -- size will be -2 if it doesn't fit into a number
      --   if size > disable_max_size or size == -2 then
      --     return true
      --   end
      --   return false
      -- end

      return {
        ensure_installed = {
          "bash",
          "c",
          "cmake",
          -- "comment", -- comments are slowing down TS bigtime, so disable for now
          "cpp",
          "css",
          "diff",
          "gitignore",
          "graphql",
          "html",
          "http",
          "java",
          "jsdoc",
          "jsonc",
          "latex",
          "lua",
          "kotlin",
          "dart",
          "markdown",
          "markdown_inline",
          "meson",
          "ninja",
          "nix",
          "norg",
          "org",
          "php",
          "query",
          "regex",
          "make",

          "scss",
          "sql",
          "svelte",
          "teal",
          "vhs",
          "vim",
          "vue",
          "ruby",
          "wgsl",
          "yaml",
          "json",
        },

        auto_install = false,

        highlight = {
          enable = true,
          -- disable = should_disable,
          additional_vim_regex_highlighting = { "orgmode", "org", "markdown" },
        },

        indent = {
          enable = true,
          -- disable = function(lang, bufnr)
          --   return should_disable(lang, bufnr)
          -- end,
        },

        incremental_selection = {
          enable = true,
          disable = { "help" },
          keymaps = {
            init_selection = "<CR>",
            node_incremental = "<CR>",
            scope_incremental = false,
            -- node_decremental = "<M-CR>",
            node_decremental = "<bs>",
          },
        },

        query_linter = {
          enable = true,
          use_virtual_text = true,
          lint_events = { "BufWrite", "CursorHold" },
        },

        -- -- vim-matchup
        -- matchup = {
        --   enable = true,
        --   disable = should_disable,
        -- },

        -- nvim-ts-context-commentstring plugin
        context_commentstring = { enable = true },

        -- nvim-ts-autotag plugin
        autotag = { enable = true },

        -- nvim-treesitter-textobjects
        textobjects = {
          select = {
            enable = true,
            -- disable = should_disable,
            lookahead = true,
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          move = {
            enable = false,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
            },
            goto_next_end = {
              ["]F"] = "@function.outer",
              ["]C"] = "@class.outer",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
            },
            goto_previous_end = {
              ["[F"] = "@function.outer",
              ["[C"] = "@class.outer",
            },
          },
          lsp_interop = {
            enable = false,
            peek_definition_code = {
              ["gD"] = "@function.outer",
            },
          },
        },
      }
    end,
    config = function(_, opts)
      require("orgmode").setup_ts_grammar()
      require("nvim-treesitter.configs").setup(opts)
      vim.keymap.set({ "o", "x" }, "m", [[:<C-U>lua require('tsht').nodes()<CR>]], { desc = "Treesitter: jump nodes" })

      local queries = require "nvim-treesitter.query"
      local parsers = require "nvim-treesitter.parsers"

      local disable_max_size = 2000000 -- 2MB

      local function should_disable(lang, bufnr)
        local size = vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr or 0))
        -- size will be -2 if it doesn't fit into a number
        if size > disable_max_size or size == -2 then
          return true
        end
        return false
      end

      local function set_ts_win_defaults()
        local parser_name = parsers.get_buf_lang()
        if parsers.has_parser(parser_name) and not should_disable(parser_name, 0) then
          local ok, has_folds = pcall(queries.get_query, parser_name, "folds")
          if ok and has_folds then
            if vim.wo.foldmethod == "manual" then
              vim.api.nvim_win_set_var(0, "ts_prev_foldmethod", vim.wo.foldmethod)
              vim.api.nvim_win_set_var(0, "ts_prev_foldexpr", vim.wo.foldexpr)
              vim.wo.foldmethod = "expr"
              vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
            end
            return
          end
        end
        if vim.wo.foldexpr == "nvim_treesitter#foldexpr()" then
          local ok, prev_foldmethod = pcall(vim.api.nvim_win_get_var, 0, "ts_prev_foldmethod")
          if ok and prev_foldmethod then
            vim.api.nvim_win_del_var(0, "ts_prev_foldmethod")
            vim.wo.foldmethod = prev_foldmethod
          end
          local ok2, prev_foldexpr = pcall(vim.api.nvim_win_get_var, 0, "ts_prev_foldexpr")
          if ok2 and prev_foldexpr then
            vim.api.nvim_win_del_var(0, "ts_prev_foldexpr")
            vim.wo.foldexpr = prev_foldexpr
          end
        end
      end

      local aug = vim.api.nvim_create_augroup("StevearcTSConfig", {})
      vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
        desc = "Set treesitter defaults on win enter",
        pattern = "*",
        callback = set_ts_win_defaults,
        group = aug,
      })
    end,
  },
  -- ULTIMATE-AUTOPAIR
  {
    "altermo/ultimate-autopair.nvim",
    enabled = true,
    event = { "InsertEnter", "CmdlineEnter" },
    branch = "v0.6",
    opts = {},
  },
  -- NVIM-AUTOPAIRS
  {
    "windwp/nvim-autopairs",
    enabled = false,
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      local npairs = require "nvim-autopairs"
      npairs.setup {
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
      }

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
}
