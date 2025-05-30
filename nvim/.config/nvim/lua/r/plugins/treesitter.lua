return {
  -- TREESITTER
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = { "LazyFile" },
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    -- init = function(plugin)
    --   -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
    --   -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
    --   -- no longer trigger the **nvim-treesitter** module to be loaded in time.
    --   -- Luckily, the only things that those plugins need are the custom queries, which we make available
    --   -- during startup.
    --   require("lazy.core.loader").add_to_rtp(plugin)
    --   require "nvim-treesitter.query_predicates"
    -- end,
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
      { "<space><space>", desc = "Misc: increment selection [treesitter]", unique = true },
      { "<bs>", desc = "Misc: decrement selection (xmode) [treesitter]", mode = "x" },
      { "<cr>", desc = "Misc: increment selection (xmode) [treesitter]", mode = "x" },
    },
    opts_extend = { "ensure_installed" },
    ---@type TSConfig
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      -- Ensure to ignore "org"
      -- Recommend config from: https://github.com/nvim-orgmode/orgmode?tab=readme-ov-file#installation
      ignore_install = { "org" },
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "graphql",
        "html",
        "http",
        "ini",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "latex",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "norg",
        "printf",
        "python",
        "query",
        "regex",
        "ssh_config",
        "toml",
        "tsx",
        "typescript",
        "typst",
        "vim",
        "vimdoc",
        "xml",
        "xresources",
        "yaml",
        "zathurarc",
        "zsh",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-a>",
          node_incremental = "<C-a>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
        },
      },
    },
    config = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        opts.ensure_installed = RUtils.dedup(opts.ensure_installed)
      end
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  -- NVIM-TREESITTER-TEXTOBJECTS
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "VeryLazy",
    config = function()
      -- If treesitter is already loaded, we need to run config again for textobjects
      if RUtils.is_loaded "nvim-treesitter" then
        local opts = RUtils.opts "nvim-treesitter"
        ---@diagnostic disable-next-line: missing-fields
        require("nvim-treesitter.configs").setup { textobjects = opts.textobjects }
      end
      -- When in diff mode, we want to use the default
      -- vim text objects c & C instead of the treesitter ones.
      local move = require "nvim-treesitter.textobjects.move" ---@type table<string,fun(...)>
      local configs = require "nvim-treesitter.configs"
      for name, fn in pairs(move) do
        if name:find "goto" == 1 then
          move[name] = function(q, ...)
            if vim.wo.diff then
              local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
              for key, query in pairs(config or {}) do
                if q == query and key:find "[%]%[][cC]" then
                  vim.cmd("normal! " .. key)
                  return
                end
              end
            end
            return fn(q, ...)
          end
        end
      end
    end,
  },
  -- NVIM-TREESITTER-CONTEXT
  {
    "mrowegawd/nvim-treesitter-context",
    event = "BufReadPost",
    keys = {
      {
        "<leader>ut",
        function()
          local tsc = require "treesitter-context"
          tsc.toggle()
          if RUtils.inject.get_upvalue(tsc.toggle, "enabled") then
            RUtils.info("Enabled Treesitter Context", { title = "Option" })
          else
            RUtils.warn("Disabled Treesitter Context", { title = "Option" })
          end
        end,
        desc = "Toggle: treesitter context",
      },
    },
    opts = function()
      local Highlight = require "r.settings.highlights"

      local rose_pine = {
        ["rose-pine-dawn"] = {
          { TreesitterContext = { bg = { from = "TabLine", attr = "bg" } } },
          {
            TreesitterContextSeparator = {
              fg = { from = "TreesitterContext", attr = "bg" },
              bg = { from = "TreesitterContext" },
            },
          },
          {
            TreesitterContextLineNumber = {
              fg = { from = "LineNr", attr = "fg", alter = -0.1 },
              bg = { from = "TreesitterContext" },
            },
          },
          {
            TreesitterContextLineNumberBottom = {
              fg = { from = "TreesitterContextLineNumber", attr = "fg", alter = -0.3 },
              underline = false,
              undercurl = false,
              sp = "NONE",
            },
          },
        },
      }
      Highlight.plugin("treesitter-context", {
        theme = {
          ["*"] = {
            { TreesitterContext = { bg = { from = "TabLine", attr = "bg" } } },
            {
              TreesitterContextSeparator = {
                fg = { from = "TreesitterContext", attr = "bg" },
                bg = { from = "TreesitterContext", attr = "bg" },
              },
            },
            {
              TreesitterContextLineNumber = {
                fg = { from = "TreesitterContext", attr = "bg", alter = 0.7 },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumberBottom = {
                fg = { from = "TreesitterContextLineNumber", attr = "fg", alter = 1.3 },
                underline = false,
                undercurl = false,
                sp = "NONE",
              },
            },
          },
          ["base46-jellybeans"] = {
            { TreesitterContext = { bg = { from = "TabLine", attr = "bg" } } },
            {
              TreesitterContextSeparator = {
                fg = { from = "TreesitterContext", attr = "bg" },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumber = {
                fg = { from = "TreesitterContext", attr = "bg", alter = 0.8 },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumberBottom = {
                fg = { from = "TreesitterContextLineNumber", attr = "fg", alter = 1.8 },
                underline = false,
                undercurl = false,
                sp = "NONE",
              },
            },
          },
          ["base46-material-darker"] = {
            { TreesitterContext = { bg = { from = "TabLine", attr = "bg" } } },
            {
              TreesitterContextSeparator = {
                fg = { from = "TreesitterContext", attr = "bg" },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumber = {
                fg = { from = "TreesitterContext", attr = "bg", alter = 0.7 },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumberBottom = {
                fg = { from = "TreesitterContextLineNumber", attr = "fg", alter = 1.8 },
                underline = false,
                undercurl = false,
                sp = "NONE",
              },
            },
          },
          ["base46-rosepine"] = {
            { TreesitterContext = { bg = { from = "TabLine", attr = "bg" } } },
            {
              TreesitterContextSeparator = {
                fg = { from = "TreesitterContext", attr = "bg" },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumber = {
                fg = { from = "TreesitterContext", attr = "bg", alter = 0.8 },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumberBottom = {
                fg = { from = "TreesitterContextLineNumber", attr = "fg", alter = 1.8 },
                underline = false,
                undercurl = false,
                sp = "NONE",
              },
            },
          },
          ["base46-horizon"] = {
            { TreesitterContext = { bg = { from = "TabLine", attr = "bg" } } },
            {
              TreesitterContextSeparator = {
                fg = { from = "TreesitterContext", attr = "bg" },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumber = {
                fg = { from = "TreesitterContext", attr = "bg", alter = 0.8 },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumberBottom = {
                fg = { from = "TreesitterContextLineNumber", attr = "fg", alter = 1.8 },
                underline = false,
                undercurl = false,
                sp = "NONE",
              },
            },
          },
          ["base46-seoul256_dark"] = {
            { TreesitterContext = { bg = { from = "TabLine", attr = "bg" } } },
            {
              TreesitterContextSeparator = {
                fg = { from = "TreesitterContext", attr = "bg" },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumber = {
                fg = { from = "TreesitterContext", attr = "bg", alter = 0.37 },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumberBottom = {
                fg = { from = "TreesitterContextLineNumber", attr = "fg", alter = 1.8 },
                underline = false,
                undercurl = false,
                sp = "NONE",
              },
            },
          },
          ["base46-default-dark"] = {
            { TreesitterContext = { bg = { from = "TabLine", attr = "bg" } } },
            {
              TreesitterContextSeparator = {
                fg = { from = "TreesitterContext", attr = "bg" },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumber = {
                fg = { from = "TreesitterContext", attr = "bg", alter = 0.85 },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumberBottom = {
                fg = { from = "TreesitterContextLineNumber", attr = "fg", alter = 1.8 },
                underline = false,
                undercurl = false,
                sp = "NONE",
              },
            },
          },
          ["base46-wombat"] = {
            { TreesitterContext = { bg = { from = "TabLine", attr = "bg" } } },
            {
              TreesitterContextSeparator = {
                fg = { from = "TreesitterContext", attr = "bg" },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumber = {
                fg = { from = "TreesitterContext", attr = "bg", alter = 0.9 },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumberBottom = {
                fg = { from = "TreesitterContextLineNumber", attr = "fg", alter = 1.8 },
                underline = false,
                undercurl = false,
                sp = "NONE",
              },
            },
          },
          ["base46-zenburn"] = {
            { TreesitterContext = { bg = { from = "TabLine", attr = "bg" } } },
            {
              TreesitterContextSeparator = {
                fg = { from = "TreesitterContext", attr = "bg" },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumber = {
                fg = { from = "TreesitterContext", attr = "bg", alter = 0.4 },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumberBottom = {
                fg = { from = "TreesitterContextLineNumber", attr = "fg", alter = 1.8 },
                underline = false,
                undercurl = false,
                sp = "NONE",
              },
            },
          },
          ["lackluster"] = {
            { TreesitterContext = { bg = { from = "TabLine", attr = "bg" } } },
            {
              TreesitterContextSeparator = {
                fg = { from = "TreesitterContext", attr = "bg" },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumber = {
                fg = { from = "TreesitterContext", attr = "bg", alter = 0.95 },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumberBottom = {
                fg = { from = "TreesitterContextLineNumber", attr = "fg", alter = 1.8 },
                underline = false,
                undercurl = false,
                sp = "NONE",
              },
            },
          },
          ["ashen"] = {
            { TreesitterContext = { bg = { from = "TabLine", attr = "bg" } } },
            {
              TreesitterContextSeparator = {
                fg = { from = "TreesitterContext", attr = "bg" },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumber = {
                fg = { from = "TreesitterContext", attr = "bg", alter = 0.9 },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumberBottom = {
                fg = { from = "TreesitterContextLineNumber", attr = "fg", alter = 1.8 },
                underline = false,
                undercurl = false,
                sp = "NONE",
              },
            },
          },
          ["darkearth"] = {
            { TreesitterContext = { bg = { from = "TabLine", attr = "bg" } } },
            {
              TreesitterContextSeparator = {
                fg = { from = "TreesitterContext", attr = "bg" },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumber = {
                fg = { from = "TreesitterContext", attr = "bg", alter = 0.8 },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumberBottom = {
                fg = { from = "TreesitterContextLineNumber", attr = "fg", alter = 1.8 },
                underline = false,
                undercurl = false,
                sp = "NONE",
              },
            },
          },
          ["kanso"] = {
            { TreesitterContext = { bg = { from = "TabLine", attr = "bg" } } },
            {
              TreesitterContextSeparator = {
                fg = { from = "TreesitterContext", attr = "bg" },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumber = {
                fg = { from = "TreesitterContext", attr = "bg", alter = 1.2 },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumberBottom = {
                fg = { from = "TreesitterContextLineNumber", attr = "fg", alter = 1.8 },
                underline = false,
                undercurl = false,
                sp = "NONE",
              },
            },
          },
          ["rose-pine"] = rose_pine[RUtils.config.colorscheme],
          ["tokyonight-night"] = {
            { TreesitterContext = { bg = { from = "TabLine", attr = "bg" } } },
            {
              TreesitterContextSeparator = {
                fg = { from = "TreesitterContext", attr = "bg" },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumber = {
                fg = { from = "TreesitterContext", attr = "bg", alter = 1.2 },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumberBottom = {
                fg = { from = "TreesitterContextLineNumber", attr = "fg", alter = 1.5 },
                underline = false,
                undercurl = false,
                sp = "NONE",
              },
            },
          },
          ["tokyonight-storm"] = {
            { TreesitterContext = { bg = { from = "TabLine", attr = "bg" } } },
            {
              TreesitterContextSeparator = {
                fg = { from = "TreesitterContext", attr = "bg" },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumber = {
                fg = { from = "TreesitterContext", attr = "bg", alter = 0.7 },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumberBottom = {
                fg = { from = "TreesitterContextLineNumber", attr = "fg", alter = 1.8 },
                underline = false,
                undercurl = false,
                sp = "NONE",
              },
            },
          },
          ["vscode_modern"] = {
            { TreesitterContext = { bg = { from = "TabLine", attr = "bg" } } },
            {
              TreesitterContextSeparator = {
                fg = { from = "TreesitterContext", attr = "bg" },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumber = {
                fg = { from = "TreesitterContext", attr = "bg", alter = 1 },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumberBottom = {
                fg = { from = "TreesitterContextLineNumber", attr = "fg", alter = 1.5 },
                underline = false,
                undercurl = false,
                sp = "NONE",
              },
            },
          },
        },
      })
      return {
        multiline_threshold = 4,
        separator = "▁", -- alternatives: ▁ ─ ▄
        opts = { mode = "cursor", max_lines = 8 },
        ---@diagnostic disable-next-line: unused-local
        on_attach = function(buf)
          if vim.wo.diff or vim.fn.winheight(0) < 20 then
            return false
          end

          local min_window_popup = 4
          local tbl_winsplits = RUtils.cmd.get_total_wins()
          if min_window_popup > #tbl_winsplits then
            return true
          end
          return false
        end,
      }
    end,
  },
  -- NVIM-TS-AUTOTAG
  {
    "windwp/nvim-ts-autotag", -- Autoclose and autorename HTML and Vue tags
    event = "LazyFile",
    ft = {
      "html",
      "xml",
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "svelte",
      "vue",
      "tsx",
      "jsx",
      "rescript",
      "php",
      "glimmer",
      "handlebars",
      "hbs",
      "markdown",
    },
    -- disabled here because I have it overridden somewhere else in order to
    -- achieve compatibility with luasnip
    opts = { enable_close_on_slash = false },
  },
}
