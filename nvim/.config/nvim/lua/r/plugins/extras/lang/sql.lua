local sql_ft = { "sql", "mysql", "plsql" }

return {
  recommended = function()
    return RUtils.extras.wants {
      ft = sql_ft,
    }
  end,

  {
    "kndndrj/nvim-dbee",
    dependencies = { "MadKuntilanak/nui.nvim" },
    event = "VeryLazy",
    build = function()
      require("dbee").install()
    end,
    config = function(_, opts)
      require("dbee").setup(opts)
    end,
    opts = {
      drawer = {
        -- disable_help = true,
        -- window_options = {
        --   number = true,
        --   relativenumber = true,
        -- },
        mappings = {
          { key = "<C-r>", mode = "n", action = "refresh" },
          { key = "o", mode = "n", action = "action_1" }, -- open
          { key = "r", mode = "n", action = "action_2" }, -- rename
          { key = "d", mode = "n", action = "action_3" }, -- delete/remove
          { key = "zc", mode = "n", action = "collapse" },
          { key = "zo", mode = "n", action = "expand" },
          { key = "<CR>", mode = "n", action = "menu_confirm" },
          { key = "<Esc>", mode = "i", action = "menu_close" },
        },
        candies = {
          source = {
            icon_highlight = "dbee_source",
            text_highlight = "dbee_source",
          },
          connection = {
            icon_highlight = "dbee_connection",
          },
          note = {
            icon_highlight = "dbee_note",
          },
        },
      },
      editor = {
        mappings = {
          { key = "<F7>", mode = "n", action = "run_file" },
          { key = "<F7>", mode = "v", action = "run_selection" },
        },
      },
      result = {
        mappings = {
          { key = "<C-c>", mode = "", action = "cancel_call" },
        },
      },
      call_log = {
        mappings = {
          { key = "<C-c>", mode = "", action = "cancel_call" },
        },
      },
      -- sources = {
      --   -- Json file entries should have the following form:
      --   -- "first": {
      --   --     "id": "1",
      --   --     "name": "docker-postgres",
      --   --     "type": "postgres",
      --   --     "url": "postgres://postgres:passwd@localhost:5432?sslmode=disable"
      --   -- }
      --   require("dbee.sources").FileSource:new(vim.fs.joinpath(vim.env.HOME, ".config", ".dbee_connections.json")),
      -- },
      extra_helpers = {
        ["postgres"] = {
          ["Count"] = "SELECT count(*) FROM {{ .Table }}",
          ["Head"] = "SELECT * FROM {{ .Table }} LIMIT 10",
        },
      },
    },
  },

  {
    "tpope/vim-dadbod",
    cmd = "DB",
  },

  {
    "kristijanhusak/vim-dadbod-completion",
    dependencies = "vim-dadbod",
    ft = sql_ft,
  },

  {
    "kristijanhusak/vim-dadbod-ui",
    -- cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    dependencies = "vim-dadbod",
    keys = {
      {
        "<Leader>od",
        function()
          RUtils.layout.toggle_sidebar("dbui", function()
            vim.cmd "DBUIToggle"
          end)
        end,
        desc = "Open: toggle DBUI",
      },
    },
    init = function()
      local data_path = vim.fn.stdpath "data"

      vim.g.db_ui_auto_execute_table_helpers = 1
      vim.g.db_ui_save_location = data_path .. "/dadbod_ui"
      vim.g.db_ui_show_database_icon = true
      vim.g.db_ui_tmp_query_location = data_path .. "/dadbod_ui/tmp"
      vim.g.db_ui_use_nerd_fonts = true
      vim.g.db_ui_use_nvim_notify = true

      -- NOTE: The default behavior of auto-execution of queries on save is disabled
      -- this is useful when you have a big query that you don't want to run every time
      -- you save the file running those queries can crash neovim to run use the
      -- default keymap: <leader>S
      vim.g.db_ui_execute_on_save = false
    end,
  },

  -- Arborist
  {
    "arborist-ts/arborist.nvim",
    optional = true,
    opts = { ensure_installed = { "sql" } },
  },

  -- Edgy integration
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      opts.right = opts.right or {}
      table.insert(opts.right, {
        title = "Database",
        ft = "dbui",
        pinned = true,
        width = 0.3,
        open = function()
          vim.cmd "DBUI"
        end,
      })

      opts.bottom = opts.bottom or {}
      table.insert(opts.bottom, {
        title = "DB Query Result",
        ft = "dbout",
      })
    end,
  },

  -- blink.cmp integration
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      sources = {
        per_filetype = {
          sql = { "snippets", "dadbod", "buffer" },
        },
        providers = {
          dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
        },
      },
    },
    dependencies = {
      "kristijanhusak/vim-dadbod-completion",
    },
  },

  -- Linters & formatters
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "sqlfluff" } },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      for _, ft in ipairs(sql_ft) do
        opts.linters_by_ft[ft] = opts.linters_by_ft[ft] or {}
        table.insert(opts.linters_by_ft[ft], "sqlfluff")
      end
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters.sqlfluff = {
        args = { "format", "--dialect=ansi", "-" },
      }
      for _, ft in ipairs(sql_ft) do
        opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
        table.insert(opts.formatters_by_ft[ft], "sqlfluff")
      end
    end,
  },
}
