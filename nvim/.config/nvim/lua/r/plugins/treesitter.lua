local Util = require "r.utils"

return {
  -- TREESITTER-CONTEXT (disabled)
  {
    "nvim-treesitter/nvim-treesitter-context",
    enabled = false,
    event = "LazyFile",
    opts = {
      multiline_threshold = 2,
      separator = "─", -- "─", alternatives: ▁ ─ ▄ '--',
      mode = "cursor",
      max_lines = 3,
    },
    keys = {
      {
        "<Localleader>tt",
        function()
          local tsc = require "treesitter-context"
          tsc.toggle()
          if Util.inject.get_upvalue(tsc.toggle, "enabled") then
            Util.info("Enabled Treesitter Context", { title = "Option" })
          else
            Util.warn("Disabled Treesitter Context", { title = "Option" })
          end
        end,
        desc = "Misc(treesitter-contex): toggle",
      },
    },
  },
  -- DELIMITERS (disabled)
  {
    "HiPhish/rainbow-delimiters.nvim",
    enabled = false,
    event = "VeryLazy",
    config = function()
      local rainbow_delimiters = require "rainbow-delimiters"

      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],
        },
        query = {
          [""] = "rainbow-delimiters",
        },
        highlight = {
          "TSRainbowRed",
          "TSRainbowYellow",
          "TSRainbowBlue",
          "TSRainbowOrange",
          "TSRainbowGreen",
          "TSRainbowViolet",
          "TSRainbowCyan",
        },
      }
    end,
  },
  -- NVIM-TS-COMMENTSTRING
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    opts = { enable_autocmd = false },
  },
  -- NVIM-TS-AUTOTAG
  {
    "windwp/nvim-ts-autotag",
    event = "LazyFile",
    opts = {},
  },
  -- TREESITTER
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = { "LazyFile", "VeryLazy" },
    cmd = { "TSUpdateSync", "TSUdate", "TSIntsall" },
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treeitter** module to be loaded in time.
      -- Luckily, the only thins that those plugins need are the custom queries, which we make available
      -- during startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require "nvim-treesitter.query_predicates"
    end,
    keys = {
      { "v", desc = "Increment selection" },
      { "V", desc = "Decrement selection", mode = "x" },
      { "m", [[:<C-U>lua require('tsht').nodes()<CR>]], desc = "Treesitter: jump nodes", mode = "o" },
      { "m", [[:<C-U>lua require('tsht').nodes()<CR>]], desc = "Treesitter: jump nodes", mode = "x" },
    },
    dependencies = {
      { "mfussenegger/nvim-treehopper" },
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        config = function()
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
          "c",
          -- "comment", -- comments are slowing down TS bigtime, so disable for now
          "cpp",
          "diff",
          "gitignore",
          "graphql",
          "java",
          "jsdoc",
          "latex",
          "kotlin",
          "dart",
          "meson",
          "ninja",
          "nix",
          "norg",
          "org",
          "php",
          "query",
          "regex",

          "sql",
          "svelte",
          "teal",
          "vhs",
          "vim",
          "vue",
          "ruby",
          "wgsl",
        },

        auto_install = false,

        highlight = {
          enable = false, -- atm disabled it, nvim got slow
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
            init_selection = false,
            node_incremental = "v",
            node_decremental = "V",
          },
        },

        query_linter = {
          enable = true,
          use_virtual_text = true,
          lint_events = { "BufWrite", "CursorHold" },
        },

        -- vim-matchup
        matchup = {
          enable = true,
        },

        endwise = {
          enable = true,
        },

        autotag = {
          enable = true,
        },

        -- Breaking changes, do not need to enable this setting https://github.com/JoosepAlviste/nvim-ts-context-commentstring/issues/82#issuecomment-1817659634
        -- context_commentstring = { enable = true }, --  nvim-ts-context-commentstring plugin

        -- nvim-treesitter-textobjects
        textobjects = {
          select = {
            -- disable = should_disable,
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
      if Util.has "orgmode" then
        require("orgmode").setup_ts_grammar()
      end

      if type(opts.ensure_installed) == "table" then
        ---@type table<string, boolean>
        local added = {}
        opts.ensure_installed = vim.tbl_filter(function(lang)
          if added[lang] then
            return false
          end
          added[lang] = true
          return true
        end, opts.ensure_installed)
      end
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
