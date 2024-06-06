---@type string
local xdg_config = vim.env.XDG_CONFIG_HOME or vim.env.HOME .. "/.config"

---@param path string
local function have(path)
  return vim.uv.fs_stat(xdg_config .. "/" .. path) ~= nil
end

return {
  -- TREESITTER
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
      { "<c-space>", desc = "Misc: increment selection [treesitter]" },
      { "<bs>", desc = "Misc: iecrement selection (xmode) [treesitter]", mode = "x" },
    },
    opts = {
      ensure_installed = {
        "c",
        -- "comment", -- comments are slowing down TS bigtime, so disable for now

        "dockerfile",
        "rasi",

        "cpp",
        "diff",
        "gitignore",
        "graphql",
        "java",
        "bash",
        "jsdoc",
        "latex",
        "dart",
        "meson",
        "ninja",
        "nix",
        "norg",
        "org",
        "php",
        "query",
        "regex",

        "fish",

        "yaml",

        "kotlin",
        "kdl", -- zellij

        "json",
        "jsonc",
        "ini",
        "ssh_config",

        "sql",
        "svelte",
        "teal",
        "vhs",
        "vim",
        "vue",
        "ruby",
        "wgsl",

        "cmake",
        "make",

        "javascript",
        "typescript",
        "tsx",

        "go",
        "gomod",
        "gowork",
        "gosum",

        "lua",
        "luadoc",
        "luap",

        "python",
        "ninja",
        "rst",

        "css",
        "html",
        "http",
        "scss",

        "yuck",

        "ron",
        "rust",
        "toml",

        "markdown",
        "markdown_inline",

        "xml",
        "vimdoc",
      },

      highlight = {
        enable = true,
        -- disable = function(ft)
        --   return vim.tbl_contains({ "tex", "latex" }, ft)
        -- end,
        additional_vim_regex_highlighting = { "markdown", "org" },
      },

      indent = {
        enable = true,
        -- disable = function(ft)
        --   return vim.tbl_contains({ "markdown", "tex", "latex" }, ft)
        -- end,
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

      -- nvim-treesitter-textobjects
      textobjects = {
        select = {
          -- disable = buf_is_large,
          enable = false,
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
      },
    },
    config = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        opts.ensure_installed = RUtils.dedup(opts.ensure_installed)
      end

      local function add(lang)
        if type(opts.ensure_installed) == "table" then
          table.insert(opts.ensure_installed, lang)
        end
      end

      vim.filetype.add {
        extension = { rasi = "rasi", rofi = "rasi", wofi = "rasi" },
        filename = {
          ["vifmrc"] = "vim",
        },
        pattern = {
          [".*/waybar/config"] = "jsonc",
          [".*/mako/config"] = "dosini",
          [".*/kitty/.+%.conf"] = "bash",
          [".*/hypr/.+%.conf"] = "hyprlang",
          ["%.env%.[%w_.-]+"] = "sh",
        },
      }

      add "git_config"

      if have "hypr" then
        add "hyprlang"
      end

      if have "fish" then
        add "fish"
      end

      if have "rofi" or have "wofi" then
        add "rasi"
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
    opts = function()
      local Highlight = require "r.settings.highlights"
      Highlight.plugin("treesitter-context", {
        theme = {
          ["*"] = {
            { TreesitterContext = { bg = { from = "Normal", attr = "bg", alter = -0.2 } } },
            {
              TreesitterContextSeparator = {
                bg = { from = "TreesitterContext" },
                fg = { from = "WinSeparator", attr = "fg" },
              },
            },
            {
              TreesitterContextLineNumber = {
                fg = { from = "LineNr", attr = "fg", alter = 0.1 },
                bg = { from = "TreesitterContext" },
              },
            },
          },
          ["catppuccin-latte"] = {
            { TreesitterContextLineNumber = { fg = { from = "LineNr", attr = "fg", alter = -0.3 } } },
          },
        },
      })
      return {
        multiline_threshold = 4,
        separator = "▁", -- alternatives: ▁ ─ ▄
        opts = { mode = "cursor", max_lines = 8 },
        ---@diagnostic disable-next-line: unused-local
        on_attach = function(buf)
          local tbl_winsplits = {}
          local win_amount = vim.api.nvim_tabpage_list_wins(0)

          for _, winnr in ipairs(win_amount) do
            if not vim.tbl_contains({ "incline" }, vim.fn.getwinvar(winnr, "&syntax")) then
              local winbufnr = vim.fn.winbufnr(winnr)

              if winbufnr > 0 then
                local winft = vim.api.nvim_get_option_value("filetype", { buf = winbufnr })
                if not vim.tbl_contains({ "notify" }, winft) and #winft > 0 then
                  table.insert(tbl_winsplits, winft)
                end
              end
            end
          end

          if #tbl_winsplits < 4 then
            -- check split or no split (`leaf`, `col` , `row`)
            local layout = vim.fn.winlayout()
            if layout[1] == "col" then -- a split window
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
