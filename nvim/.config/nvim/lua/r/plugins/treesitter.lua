return {
  -- TREESITTER
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    branch = "main",
    build = ":TSUpdate",
    lazy = true,
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
    init = function() end,
    ---@param opts TSConfig
    config = function(_, opts)
      if vim.fn.executable "tree-sitter" == 0 then
        RUtils.error "**treesitter-main** requires the `tree-sitter` executable to be installed"
        return
      end
      if type(opts.ensure_installed) ~= "table" then
        error "opts.ensure_installed must be a table"
      end

      local TS = require "nvim-treesitter"
      TS.setup(opts)

      local needed = RUtils.dedup(opts.ensure_installed --[[@as string[] ]])
      local installed = TS.get_installed "parsers"
      local install = vim.tbl_filter(function(lang)
        return not vim.tbl_contains(installed, lang)
      end, needed)

      if #install > 0 then
        TS.install(install, { summary = true })
        vim.list_extend(installed, install)
      end

      -- backwards compatibility with the old treesitter config for highlight and indent
      local highlight, indent = vim.tbl_get(opts, "highlight", "enable"), vim.tbl_get(opts, "indent", "enable")
      if highlight or indent then
        vim.api.nvim_create_autocmd("FileType", {
          callback = function(ev)
            local lang = vim.treesitter.language.get_lang(ev.match)
            if not vim.tbl_contains(installed, lang) then
              return
            end
            if highlight then
              pcall(vim.treesitter.start)
            end
            if indent then
              vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
          end,
        })
      end
    end,

    --   vim.keymap.set("n", "<Leader>ui", function()
    --     vim.treesitter.inspect_tree {
    --       command = "vnew | wincmd L | vertical resize 60",
    --       title = function()
    --         return "InspectTree"
    --       end,
    --     }
    --   end, { desc = "Toggle: open Inspecttree" })
    --
    --   -- Select
    --   RUtils.map.xnoremap("if", function()
    --     require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
    --   end, { desc = "LSP: select visual inner" })
    --   RUtils.map.onoremap("if", function()
    --     require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
    --   end, { desc = "LSP: select visual inner" })
    --
    --   RUtils.map.xnoremap("af", function()
    --     require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
    --   end, { desc = "LSP: select visual outer" })
    --   RUtils.map.onoremap("af", function()
    --     require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
    --   end, { desc = "LSP: select visual outer" })
    --
    --   -- Swap
    --   RUtils.map.nnoremap("<Localleader>ww", function()
    --     require("nvim-treesitter-textobjects.swap").swap_next "@parameter.inner"
    --   end, { desc = "LSP: swap parameter next" })
    --
    --   RUtils.map.nnoremap("<Localleader>wW", function()
    --     require("nvim-treesitter-textobjects.swap").swap_previous "@parameter.inner"
    --   end, { desc = "LSP: swap parameter prev" })
    -- end,
  },
  -- NVIM-TREESITTER-TEXTOBJECTS
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
    opts = {},
    keys = function()
      local moves = {
        goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
        goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
        goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
        goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
      }
      local ret = {} ---@type LazyKeysSpec[]
      for method, keymaps in pairs(moves) do
        for key, query in pairs(keymaps) do
          local desc = query:gsub("@", ""):gsub("%..*", "")
          desc = desc:sub(1, 1):upper() .. desc:sub(2)
          desc = (key:sub(1, 1) == "[" and "Prev " or "Next ") .. desc
          desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and " End" or " Start")
          ret[#ret + 1] = {
            key,
            function()
              require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
            end,
            desc = desc,
            mode = { "n", "x", "o" },
            silent = true,
          }
        end
      end
      return ret
    end,
    config = function(_, opts)
      require("nvim-treesitter-textobjects").setup(opts)
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
            ---@diagnostic disable-next-line: undefined-field
            RUtils.info("Enabled Treesitter Context", { title = "Option" })
          else
            ---@diagnostic disable-next-line: undefined-field
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
              fg = { from = "TreesitterContext", attr = "bg", alter = -0.2 },
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
                fg = { from = "TabLine", attr = "bg", alter = 0.55 },
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
          ["base46-jellybeans"] = {
            { TreesitterContext = { bg = { from = "TabLine", attr = "bg" } } },
            {
              TreesitterContextSeparator = {
                fg = { from = "TreesitterContext", attr = "bg" },
                bg = { from = "TreesitterContext", attr = "bg" },
              },
            },
            {
              TreesitterContextLineNumber = {
                fg = { from = "TabLine", attr = "bg", alter = 0.5 },
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
          ["base46-kanagawa"] = {
            { TreesitterContext = { bg = { from = "TabLine", attr = "bg" } } },
            {
              TreesitterContextSeparator = {
                fg = { from = "TreesitterContext", attr = "bg" },
                bg = { from = "TreesitterContext", attr = "bg" },
              },
            },
            {
              TreesitterContextLineNumber = {
                fg = { from = "TabLine", attr = "bg", alter = 0.4 },
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
          ["base46-seoul256_dark"] = {
            { TreesitterContext = { bg = { from = "TabLine", attr = "bg" } } },
            {
              TreesitterContextSeparator = {
                fg = { from = "TreesitterContext", attr = "bg" },
                bg = { from = "TreesitterContext", attr = "bg" },
              },
            },
            {
              TreesitterContextLineNumber = {
                fg = { from = "TabLine", attr = "bg", alter = 0.3 },
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
          ["base46-zenburn"] = {
            { TreesitterContext = { bg = { from = "TabLine", attr = "bg" } } },
            {
              TreesitterContextSeparator = {
                fg = { from = "TreesitterContext", attr = "bg" },
                bg = { from = "TreesitterContext", attr = "bg" },
              },
            },
            {
              TreesitterContextLineNumber = {
                fg = { from = "TabLine", attr = "bg", alter = 0.3 },
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
          ["base46-melange"] = {
            { TreesitterContext = { bg = { from = "TabLine", attr = "bg" } } },
            {
              TreesitterContextSeparator = {
                fg = { from = "TreesitterContext", attr = "bg" },
                bg = { from = "TreesitterContext", attr = "bg" },
              },
            },
            {
              TreesitterContextLineNumber = {
                fg = { from = "TabLine", attr = "bg", alter = 0.45 },
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
          ["lackluster"] = {
            { TreesitterContext = { bg = { from = "TabLine", attr = "bg" } } },
            {
              TreesitterContextSeparator = {
                fg = { from = "TreesitterContext", attr = "bg" },
                bg = { from = "TreesitterContext", attr = "bg" },
              },
            },
            {
              TreesitterContextLineNumber = {
                fg = { from = "TabLine", attr = "bg", alter = 0.4 },
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
          ["rose-pine"] = rose_pine[RUtils.config.colorscheme],
        },
      })
      return {
        multiline_threshold = 5,
        separator = "▁", -- alternatives: ▁ ─ ▄
        opts = { mode = "cursor", max_lines = 8 },
        ---@diagnostic disable-next-line: unused-local
        on_attach = function(bufnr)
          --  -- Check if buffer or window is invalid
          if not vim.api.nvim_buf_is_valid(bufnr) then
            return false
          end

          -- Skip floating windows
          local win_config = vim.api.nvim_win_get_config(0)
          if win_config.relative ~= "" then
            return false
          end

          -- Skip special buffers
          local bt = vim.bo[bufnr].buftype
          if bt == "nofile" or bt == "prompt" or bt == "help" then
            return false
          end

          -- Skip certain filetypes
          local ft = vim.bo[bufnr].filetype
          local excluded_fts = { "fugitive", "gitcommit", "TelescopePrompt" }
          if vim.tbl_contains(excluded_fts, ft) then
            return false
          end

          -- Skip diff mode
          if vim.wo.diff then
            return false
          end

          -- Skip when window height is too small
          if vim.fn.winheight(0) < 30 then
            return false
          end

          return true
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
