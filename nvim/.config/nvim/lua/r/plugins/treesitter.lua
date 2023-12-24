local function buf_is_large(_, buf)
  return vim.b[buf].buf_is_large == true
end

return {
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
    -- keys = {
    --   { "v", desc = "Increment selection" },
    --   { "V", desc = "Decrement selection", mode = "x" },
    --   { "m", [[:<C-U>lua require('tsht').nodes()<CR>]], desc = "Treesitter: jump nodes", mode = "o" },
    --   { "m", [[:<C-U>lua require('tsht').nodes()<CR>]], desc = "Treesitter: jump nodes", mode = "x" },
    -- },
    dependencies = {
      -- { "mfussenegger/nvim-treehopper" },
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
    opts = {
      ensure_installed = {
        "c",
        -- "comment", -- comments are slowing down TS bigtime, so disable for now

        "dockerfile",

        "cpp",
        "diff",
        "gitignore",
        "graphql",
        "java",
        "bash",
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

        "fish",

        "yaml",

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
        "toml",

        "css",
        "html",
        "http",
        "scss",

        "ron",
        "rust",

        "markdown",
        "markdown_inline",

        "vimdoc",
      },

      highlight = {
        enable = true, -- atm disabled it, nvim got slow
        disable = function(ft, buf)
          -- return vim.tbl_contains({ "markdown", "tex", "latex" }, ft)
          return vim.tbl_contains({ "tex", "latex" }, ft) or buf_is_large(ft, buf) or vim.fn.win_gettype() == "command"
        end,
        additional_vim_regex_highlighting = { "org" },
      },

      indent = {
        enable = true,
        disable = function(ft, buf)
          return vim.tbl_contains({ "markdown", "tex", "latex" }, ft) or buf_is_large(ft, buf)
        end,
      },
      incremental_selection = {
        enable = false,
        disable = buf_is_large,
        keymaps = {
          init_selection = false,
          node_incremental = "v",
          node_decremental = "V",
        },
      },

      -- nvim-treesitter-textobjects
      textobjects = {
        select = {
          disable = buf_is_large,
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
          disable = buf_is_large,
          peek_definition_code = {
            ["gD"] = "@function.outer",
          },
        },
      },
    },
    config = function(_, opts)
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

      local non_filetype_match_injection_language_aliases = {
        ex = "elixir",
        pl = "perl",
        bash = "sh", -- reversing these two from the treesitter source
        uxn = "uxntal",
        ts = "typescript",
      }
      local icon = nil

      local ft_conceal = function(match, _, source, pred, metadata)
        ---@cast pred integer[]
        local capture_id = pred[2]
        if not metadata[capture_id] then
          metadata[capture_id] = {}
        end

        local node = match[pred[2]]
        local node_text = vim.treesitter.get_node_text(node, source)

        local ft = vim.filetype.match { filename = "a." .. node_text }
        node_text = ft or non_filetype_match_injection_language_aliases[node_text] or node_text

        if not icon then
          icon = require("nvim-web-devicons").get_icon_by_filetype
        end
        metadata.conceal = icon(node_text) or "󰡯"
      end

      local offset_first_n = function(match, _, _, pred, metadata)
        ---@cast pred integer[]
        local capture_id = pred[2]
        if not metadata[capture_id] then
          metadata[capture_id] = {}
        end

        local range = metadata[capture_id].range or { match[capture_id]:range() }
        local offset = pred[3] or 0

        range[4] = range[2] + offset
        metadata[capture_id].range = range
      end

      vim.treesitter.query.add_directive("offset-first-n!", offset_first_n, true)

      vim.treesitter.query.add_directive("ft-conceal!", ft_conceal, true)

      require("nvim-treesitter.configs").setup(opts)
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
