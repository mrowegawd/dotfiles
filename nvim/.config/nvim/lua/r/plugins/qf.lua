return {
  -- QUICKER
  { -- bisa menggunakan range -> %s/, jangan lupa di 'write' setelah delete range
    "stevearc/quicker.nvim",
    event = "VeryLazy",
    ft = "qf",
    opts = {
      opts = {
        number = true,
        signcolumn = "yes",
      },

      borders = {
        vert = "│",

        -- Strong headers (antar file)
        strong_header = "─",
        strong_cross = "┼",
        strong_end = "┤",

        -- Soft headers (dalam file)
        soft_header = "┄", -- dashed light
        soft_cross = "┼",
        soft_end = "┤",
      },
    },
  },
  -- QFBOOKMARK
  {
    -- dir = "~/.local/src/nvim_plugins/qfbookmark",
    "MadKuntilanak/qfbookmark",
    event = "LazyFile",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      save_dir = RUtils.config.path.wiki_path .. "/orgmode/nvim-plugin/qfbookmark",
      picker = "fzf-lua",
      -- window = {
      --   note = {
      --     -- open_cmd = "botright vsplit",
      --     -- size_split = 12,
      --     -- size_vsplit = 50,
      --     filetype = "markdown", -- Ex: "orgmode" "norg", "markdown", "text"
      --     file_ext = "md", -- Ex: "org" "norg" "md" "txt"
      --   },
      -- },
      keymaps = {
        disable_all = false,
        open_item = {
          default = { keys = { "o", "<CR>" }, auto_close = false },
        },
        integrations = {
          cmdline_strings = {
            commands = {
              -- 🔍 Debug / Inspect
              {
                key = "<Leader>mO",
                cmd = function(qftbl)
                  RUtils.info(vim.inspect(qftbl))
                end,
                desc = "Output items current quickfix/loclist",
                buffer = true,
              },

              -- 🔧 Filter & Update (Quickfix)
              {
                key = "<Leader>mQ",
                cmd = "Cfilter /\\\\v\\|[^\\|]*\\|s\\*/",
                desc = "Run Cfilter update",
                buffer = true,
              },
              {
                key = "<Leader>mqd",
                cmd = "cdo %s/status//gi | update",
                desc = "Run cdo status update (quickfix)",
                buffer = true,
              },
              {
                key = "<Leader>mqD",
                cmd = "cfdo %s/WinNav/Winav/g",
                desc = "Run cfdo replace",
                buffer = true,
              },
              {
                key = "<Leader>mql",
                cmd = "cfdo %s/WinNav/Winav/g | update",
                desc = "Run cfdo replace & update",
                buffer = true,
              },

              -- 🧩 Filter & Update (Loclist)
              {
                key = "<Leader>mL",
                cmd = "Lfilter / /",
                desc = "Run Lfilter update",
                buffer = true,
              },
              {
                key = "<Leader>mld",
                cmd = "ldo %s/status//gi | update",
                desc = "Run ldo status update (loclist)",
                buffer = true,
              },
              {
                key = "<Leader>mlD",
                cmd = "lfdo %s/WinNav/Winav/g",
                desc = "Run lfdo replace",
                buffer = true,
              },
              {
                key = "<Leader>mlR",
                cmd = "lfdo %s/WinNav/Winav/g | update",
                desc = "Run lfdo replace & update",
                buffer = true,
              },
            },
          },
        },
      },
    },
  },
}
