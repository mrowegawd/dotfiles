return {
  -- NVIM-TREESITTER
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    version = false, -- last release is way too old and doesn't work on Windows
    build = function()
      local TS = require "nvim-treesitter"
      if not TS.get_installed then
        RUtils.error "Please restart Neovim and run `:TSUpdate` to use the `nvim-treesitter` **main** branch."
        return
      end
      -- make sure we're using the latest treesitter util
      package.loaded["lazyvim.util.treesitter"] = nil
      RUtils.treesitter.build(function()
        TS.update(nil, { summary = true })
      end)
    end,
    event = { "LazyFile", "VeryLazy" },
    cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
    opts_extend = { "ensure_installed" },
    ---@alias lazyvim.TSFeat { enable?: boolean, disable?: string[] }
    ---@class lazyvim.TSConfig: TSConfig
    opts = {
      -- LazyVim config for treesitter
      indent = { enable = true }, ---@type lazyvim.TSFeat
      highlight = { enable = true }, ---@type lazyvim.TSFeat
      folds = { enable = true }, ---@type lazyvim.TSFeat
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
    ---@param opts lazyvim.TSConfig
    config = function(_, opts)
      local TS = require "nvim-treesitter"

      setmetatable(require "nvim-treesitter.install", {
        __newindex = function(_, k)
          if k == "compilers" then
            vim.schedule(function()
              RUtils.error {
                "Setting custom compilers for `nvim-treesitter` is no longer supported.",
                "",
                "For more info, see:",
                "- [compilers](https://docs.rs/cc/latest/cc/#compile-time-requirements)",
              }
            end)
          end
        end,
      })

      -- some quick sanity checks
      if not TS.get_installed then
        return RUtils.error "Please use `:Lazy` and update `nvim-treesitter`"
      elseif type(opts.ensure_installed) ~= "table" then
        return RUtils.error "`nvim-treesitter` opts.ensure_installed must be a table"
      end

      -- setup treesitter
      TS.setup(opts)
      RUtils.treesitter.get_installed(true) -- initialize the installed langs

      -- install missing parsers
      local install = vim.tbl_filter(function(lang)
        return not RUtils.treesitter.have(lang)
      end, opts.ensure_installed or {})
      if #install > 0 then
        RUtils.treesitter.build(function()
          TS.install(install, { summary = true }):await(function()
            RUtils.treesitter.get_installed(true) -- refresh the installed langs
          end)
        end)
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("lazyvim_treesitter", { clear = true }),
        callback = function(ev)
          local ft, lang = ev.match, vim.treesitter.language.get_lang(ev.match)
          if not RUtils.treesitter.have(ft) then
            return
          end

          ---@param feat string
          ---@param query string
          local function enabled(feat, query)
            local f = opts[feat] or {} ---@type lazyvim.TSFeat
            return f.enable ~= false
              and not (type(f.disable) == "table" and vim.tbl_contains(f.disable, lang))
              and RUtils.treesitter.have(ft, query)
          end

          -- highlighting
          if enabled("highlight", "highlights") then
            pcall(vim.treesitter.start, ev.buf)
          end

          -- indents
          if enabled("indent", "indents") then
            RUtils.set_default("indentexpr", "v:lua.require'r.utils'.treesitter.indentexpr()")
          end

          -- folds
          if enabled("folds", "folds") then
            if RUtils.set_default("foldmethod", "expr") then
              RUtils.set_default("foldexpr", "v:lua.require'r.utils'.treesitter.foldexpr()")
            end
          end
        end,
      })
    end,
  },
  -- NVIM-TREESITTER-TEXTOBJECTS
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
    opts = {
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        -- LazyVim extention to create buffer-local keymaps
        keys = {
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
        },
      },
    },
    config = function(_, opts)
      local TS = require "nvim-treesitter-textobjects"
      if not TS.setup then
        RUtils.error "Please use `:Lazy` and update `nvim-treesitter`"
        return
      end
      TS.setup(opts)

      local function attach(buf)
        local ft = vim.bo[buf].filetype
        if not (vim.tbl_get(opts, "move", "enable") and RUtils.treesitter.have(ft, "textobjects")) then
          return
        end
        ---@type table<string, table<string, string>>
        local moves = vim.tbl_get(opts, "move", "keys") or {}

        for method, keymaps in pairs(moves) do
          for key, query in pairs(keymaps) do
            local desc = query:gsub("@", ""):gsub("%..*", "")
            desc = desc:sub(1, 1):upper() .. desc:sub(2)
            desc = (key:sub(1, 1) == "[" and "Prev " or "Next ") .. desc
            desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and " End" or " Start")
            if not (vim.wo.diff and key:find "[cC]") then
              vim.keymap.set({ "n", "x", "o" }, key, function()
                require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
              end, {
                buffer = buf,
                desc = desc,
                silent = true,
              })
            end
          end
        end
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("lazyvim_treesitter_textobjects", { clear = true }),
        callback = function(ev)
          attach(ev.buf)
        end,
      })
      vim.tbl_map(attach, vim.api.nvim_list_bufs())
    end,
  },
  -- NVIM-TS-AUTOTAG
  {
    "windwp/nvim-ts-autotag",
    event = "LazyFile",
    opts = {},
  },
  -- NVIM-TREESITTER-CONTEXT (disabled)
  {
    "mrowegawd/nvim-treesitter-context",
    enabled = false,
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
}
