return {
  -- TREESITTER
  -- Treesitter is a new parser generator tool that we can
  -- use in Neovim to power faster and more accurate
  -- syntax highlighting.
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = { "LazyFile", "VeryLazy" },
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treesitter** module to be loaded in time.
      -- Luckily, the only things that those plugins need are the custom queries, which we make available
      -- during startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require "nvim-treesitter.query_predicates"
    end,
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
      { "<c-space>", desc = "Misc: increment selection [treesitter]", unique = true },
      { "<bs>", desc = "Misc: iecrement selection (xmode) [treesitter]", mode = "x" },
    },
    opts_extend = { "ensure_installed" },
    ---@type TSConfig
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "query",
        "regex",
        "latex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
        "http",
        "graphql",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
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
    event = "LazyFile",
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
      Highlight.plugin("treesitter-context", {
        theme = {
          ["*"] = {
            { TreesitterContext = { bg = { from = "Pmenu", attr = "bg", alter = -0.05 } } },
            {
              TreesitterContextSeparator = {
                bg = { from = "TreesitterContext" },
                fg = { from = "WinSeparator", attr = "fg", alter = 0.2 },
              },
            },
            {
              TreesitterContextLineNumber = {
                fg = { from = "LineNr", attr = "fg", alter = 0.2 },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextBottom = {
                underline = false,
                undercurl = false,
                sp = "NONE",
              },
            },
            {
              TreesitterContextLineNumberBottom = {
                fg = { from = "TreesitterContextLineNumber", attr = "fg", alter = 0.7 },
                underline = false,
                undercurl = false,
                sp = "NONE",
              },
            },
          },
          ["catppuccin-mocha"] = {
            { TreesitterContext = { bg = { from = "Pmenu", attr = "bg", alter = -0.3 } } },
            {
              TreesitterContextSeparator = {
                bg = { from = "TreesitterContext" },
                fg = { from = "WinSeparator", attr = "fg", alter = -0.05 },
              },
            },
          },
          ["gruvbox-material"] = {
            { TreesitterContext = { bg = { from = "Pmenu", attr = "bg", alter = -0.15 } } },
            {
              TreesitterContextSeparator = {
                bg = { from = "TreesitterContext" },
                fg = { from = "WinSeparator", attr = "fg", alter = -0.05 },
              },
            },
          },
          ["kanagawa"] = {
            { TreesitterContext = { bg = { from = "Normal", attr = "bg", alter = 0.15 } } },
            {
              TreesitterContextSeparator = {
                bg = { from = "TreesitterContext" },
                fg = { from = "WinSeparator", attr = "fg", alter = -0.05 },
              },
            },
          },
          ["oxocarbon"] = {
            { TreesitterContext = { bg = { from = "Normal", attr = "bg", alter = 0.2 } } },
            {
              TreesitterContextSeparator = {
                bg = { from = "TreesitterContext" },
                fg = { from = "WinSeparator", attr = "fg", alter = 0.05 },
              },
            },
            {
              TreesitterContextLineNumber = {
                fg = { from = "LineNr", attr = "fg", alter = 0.2 },
                bg = { from = "TreesitterContext" },
              },
            },
          },
          ["evangelion"] = {
            { TreesitterContext = { bg = { from = "Pmenu", attr = "bg", alter = 0.05 } } },
            {
              TreesitterContextSeparator = {
                bg = { from = "TreesitterContext" },
                fg = { from = "WinSeparator", attr = "fg", alter = 0.1 },
              },
            },
          },
          ["horizon"] = {
            { TreesitterContext = { bg = { from = "Normal", attr = "bg", alter = 0.15 } } },
            {
              TreesitterContextSeparator = {
                bg = { from = "TreesitterContext" },
                fg = { from = "WinSeparator", attr = "fg", alter = 0.1 },
              },
            },
          },
          ["farout"] = {
            { TreesitterContext = { bg = { from = "Pmenu", attr = "bg", alter = -0.2 } } },
            {
              TreesitterContextSeparator = {
                bg = { from = "TreesitterContext" },
                fg = { from = "WinSeparator", attr = "fg", alter = 0.05 },
              },
            },
            {
              TreesitterContextLineNumber = {
                fg = { from = "LineNr", attr = "fg", alter = 0.5 },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumberBottom = {
                underline = false,
                undercurl = false,
                sp = "NONE",
              },
            },
          },
          ["nightfox"] = {
            { TreesitterContext = { bg = { from = "Pmenu", attr = "bg", alter = 0.15 } } },
            {
              TreesitterContextSeparator = {
                bg = { from = "TreesitterContext" },
                fg = { from = "WinSeparator", attr = "fg", alter = -0.05 },
              },
            },
            {
              TreesitterContextLineNumber = {
                fg = { from = "LineNr", attr = "fg", alter = 0.5 },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumberBottom = {
                underline = false,
                undercurl = false,
                sp = "NONE",
              },
            },
          },
          ["vscode_modern"] = {
            { TreesitterContext = { bg = { from = "Normal", attr = "bg", alter = 0.4 } } },
            {
              TreesitterContextSeparator = {
                bg = { from = "TreesitterContext" },
                fg = { from = "WinSeparator", attr = "fg", alter = 0.15 },
              },
            },
            {
              TreesitterContextLineNumber = {
                fg = { from = "LineNr", attr = "fg", alter = 0.15 },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumberBottom = {
                underline = false,
                undercurl = false,
                sp = "NONE",
              },
            },
          },
          ["tokyonight-storm"] = {
            { TreesitterContext = { bg = { from = "Pmenu", attr = "bg", alter = 0.15 } } },
            {
              TreesitterContextSeparator = {
                bg = { from = "TreesitterContext" },
                fg = { from = "WinSeparator", attr = "fg", alter = -0.05 },
              },
            },
            {
              TreesitterContextLineNumber = {
                fg = { from = "LineNr", attr = "fg", alter = 0.5 },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumberBottom = {
                underline = false,
                undercurl = false,
                sp = "NONE",
              },
            },
          },
          ["selenized"] = {
            { TreesitterContext = { bg = { from = "Normal", attr = "bg", alter = 0.1 } } },
            {
              TreesitterContextSeparator = {
                bg = { from = "TreesitterContext" },
                fg = { from = "WinSeparator", attr = "fg", alter = -0.1 },
              },
            },
            {
              TreesitterContextLineNumber = {
                fg = { from = "LineNr", attr = "fg", alter = 0.1 },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumberBottom = {
                underline = false,
                undercurl = false,
                sp = "NONE",
              },
            },
          },
          ["dayfox"] = {
            { TreesitterContext = { bg = { from = "Normal", attr = "bg", alter = -0.05 } } },
            {
              TreesitterContextSeparator = {
                bg = { from = "TreesitterContext" },
                fg = { from = "WinSeparator", attr = "fg", alter = 0.02 },
              },
            },
            {
              TreesitterContextLineNumber = {
                fg = { from = "LineNr", attr = "fg", alter = -0.05 },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumberBottom = {
                underline = false,
                undercurl = false,
                sp = "NONE",
              },
            },
          },
          ["tokyonight-day"] = {
            { TreesitterContext = { bg = { from = "Pmenu", attr = "bg", alter = 0.15 } } },
            {
              TreesitterContextSeparator = {
                bg = { from = "TreesitterContext" },
                fg = { from = "WinSeparator", attr = "fg", alter = -0.02 },
              },
            },
            {
              TreesitterContextLineNumber = {
                fg = { from = "LineNr", attr = "fg", alter = -0.05 },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumberBottom = {
                underline = false,
                undercurl = false,
                sp = "NONE",
              },
            },
          },
          ["everforest"] = {
            { TreesitterContext = { bg = { from = "Normal", attr = "bg", alter = -0.04 } } },
            {
              TreesitterContextSeparator = {
                bg = { from = "TreesitterContext" },
                fg = { from = "WinSeparator", attr = "fg", alter = 0.04 },
              },
            },
            {
              TreesitterContextLineNumber = {
                fg = { from = "LineNr", attr = "fg", alter = -0.05 },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumberBottom = {
                underline = false,
                undercurl = false,
                sp = "NONE",
              },
            },
          },
          ["dawnfox"] = {
            { TreesitterContext = { bg = { from = "Normal", attr = "bg", alter = -0.05 } } },
            {
              TreesitterContextSeparator = {
                bg = { from = "TreesitterContext" },
                fg = { from = "WinSeparator", attr = "fg", alter = -0.01 },
              },
            },
            {
              TreesitterContextLineNumber = {
                fg = { from = "LineNr", attr = "fg", alter = -0.05 },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumberBottom = {
                underline = false,
                undercurl = false,
                sp = "NONE",
              },
            },
          },
          ["rose-pine"] = {
            { TreesitterContext = { bg = { from = "Normal", attr = "bg", alter = -0.05 } } },
            {
              TreesitterContextSeparator = {
                bg = { from = "TreesitterContext" },
                fg = { from = "WinSeparator", attr = "fg", alter = -0.01 },
              },
            },
            {
              TreesitterContextLineNumber = {
                fg = { from = "LineNr", attr = "fg", alter = -0.05 },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumberBottom = {
                underline = false,
                undercurl = false,
                sp = "NONE",
              },
            },
          },
          ["lackluster"] = {
            { TreesitterContext = { bg = { from = "Pmenu", attr = "bg", alter = 0.05 } } },
            {
              TreesitterContextSeparator = {
                bg = { from = "TreesitterContext" },
                fg = { from = "WinSeparator", attr = "fg", alter = 0.1 },
              },
            },
            {
              TreesitterContextLineNumber = {
                fg = { from = "LineNr", attr = "fg", alter = 0.5 },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumberBottom = {
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
          local tbl_winsplits = RUtils.cmd.get_total_wins()
          if #tbl_winsplits < 3 then
            -- check split or no split (`leaf`, `col` , `row`)
            local layout = vim.fn.winlayout()
            if layout[1] == "col" then -- split window
              local nwin = #layout[2]
              return nwin < 2
            end
          else
            return false
          end
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
