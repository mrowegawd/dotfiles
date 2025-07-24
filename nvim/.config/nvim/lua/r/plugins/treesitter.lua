return {
  -- TREESITTER
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    branch = "main",
    dependencies = { { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" } },
    event = { "LazyFile" },
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "graphql",
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
      },
    },
    config = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        opts.ensure_installed = RUtils.dedup(opts.ensure_installed)
      end
      require("nvim-treesitter").setup()
      require("nvim-treesitter-textobjects").setup()
      require("nvim-treesitter").install(opts.ensure_installed)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "c",
          "cpp",
          "diff",
          "dockerfile",
          "gitdiff",
          "gitignore",
          "go",
          "graphql",
          "javascript",
          "javascriptreact",
          "lua",
          "markdown",
          "mysql",
          "pgsql",
          "php",
          "python",
          "ruby",
          "sh",
          "sql",
          "terraform",
          "toml",
          "typescript",
          "typescriptreact",
          "vim",
          "yaml",
          "copilot-chat",
        },
        group = vim.api.nvim_create_augroup("nvim-treesitter-fts", { clear = true }),
        callback = function(args)
          vim.treesitter.start(args.buf)
        end,
      })

      -- Select
      RUtils.map.xnoremap("if", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
      end, { desc = "LSP: select visual inner" })
      RUtils.map.onoremap("if", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
      end, { desc = "LSP: select visual inner" })

      RUtils.map.xnoremap("af", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
      end, { desc = "LSP: select visual outer" })
      RUtils.map.onoremap("af", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
      end, { desc = "LSP: select visual outer" })

      -- Swap
      RUtils.map.nnoremap("<Localleader>ww", function()
        require("nvim-treesitter-textobjects.swap").swap_next "@parameter.inner"
      end, { desc = "LSP: swap parameter next" })

      RUtils.map.nnoremap("<Localleader>wW", function()
        require("nvim-treesitter-textobjects.swap").swap_previous "@parameter.inner"
      end, { desc = "LSP: swap parameter prev" })
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
      {
        "<Leader>jc",
        function()
          require("treesitter-context").go_to_context()
          vim.cmd "normal! zt" -- move the cursor line to the top of the window
        end,
        desc = "JumpTo: treesitter context and align to top",
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
                fg = { from = "TreesitterContext", attr = "bg", alter = 0.45 },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumberBottom = {
                fg = { from = "Keyword", attr = "fg" },
                underline = false,
                undercurl = false,
                sp = "NONE",
              },
            },
          },
          ["base46-everforest"] = {
            { TreesitterContext = { bg = { from = "TabLine", attr = "bg" } } },
            {
              TreesitterContextSeparator = {
                fg = { from = "TreesitterContext", attr = "bg" },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumber = {
                fg = { from = "TreesitterContext", attr = "bg", alter = 0.45 },
                bg = { from = "TreesitterContext" },
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
                fg = { from = "TreesitterContext", attr = "bg", alter = 0.45 },
                bg = { from = "TreesitterContext" },
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
                fg = { from = "TreesitterContext", attr = "bg", alter = 0.35 },
                bg = { from = "TreesitterContext" },
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
                fg = { from = "TreesitterContext", attr = "bg", alter = 0.5 },
                bg = { from = "TreesitterContext" },
              },
            },
          },
          ["base46-vscode_dark"] = {
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
                fg = { from = "TreesitterContext", attr = "bg", alter = 0.35 },
                bg = { from = "TreesitterContext" },
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
                fg = { from = "TreesitterContext", attr = "bg", alter = 0.5 },
                bg = { from = "TreesitterContext" },
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
          },
          ["base46-oxocarbon"] = {
            { TreesitterContext = { bg = { from = "TabLine", attr = "bg" } } },
            {
              TreesitterContextSeparator = {
                fg = { from = "TreesitterContext", attr = "bg" },
                bg = { from = "TreesitterContext" },
              },
            },
            {
              TreesitterContextLineNumber = {
                fg = { from = "TreesitterContext", attr = "bg", alter = 0.45 },
                bg = { from = "TreesitterContext" },
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
                fg = { from = "TreesitterContext", attr = "bg", alter = 0.4 },
                bg = { from = "TreesitterContext" },
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
                fg = { from = "TreesitterContext", attr = "bg", alter = 0.52 },
                bg = { from = "TreesitterContext" },
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
                fg = { from = "TreesitterContext", attr = "bg", alter = 0.75 },
                bg = { from = "TreesitterContext" },
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
                fg = { from = "TreesitterContext", attr = "bg", alter = 0.4 },
                bg = { from = "TreesitterContext" },
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
                fg = { from = "TreesitterContext", attr = "bg", alter = 0.5 },
                bg = { from = "TreesitterContext" },
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
                fg = { from = "TreesitterContext", attr = "bg", alter = 0.5 },
                bg = { from = "TreesitterContext" },
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
