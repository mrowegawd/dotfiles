local fn = vim.fn
local Highlight = require "r.settings.highlights"

local is_show_start = function()
  if vim.tbl_contains(vim.g.lightthemes, vim.g.colorscheme) then
    return false
  end
  return true
end

return {
  -- INDENT-BLANKLINE
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VimEnter",
    main = "ibl",
    opts = function()
      Highlight.plugin("ibl_indentline", {
        theme = {
          ["*"] = {
            { ["@ibl.indent.char.1"] = { fg = { from = "Normal", attr = "bg", alter = 0.25 } } },
            { ["@ibl.scope.char.1"] = { fg = { from = "Normal", attr = "bg", alter = 1.2 } } },
          },
          ["selenized"] = {
            { ["@ibl.indent.char.1"] = { fg = { from = "Normal", attr = "bg", alter = 0.2 } } },
            { ["@ibl.scope.char.1"] = { fg = { from = "Normal", attr = "bg", alter = 1 } } },
          },
          ["farout"] = {
            { ["@ibl.indent.char.1"] = { fg = { from = "Normal", attr = "bg", alter = 1.5 } } },
            { ["@ibl.scope.char.1"] = { fg = { from = "Normal", attr = "bg", alter = 4 } } },
          },
          ["neomodern"] = {
            { ["@ibl.indent.char.1"] = { fg = { from = "Normal", attr = "bg", alter = 0.4 } } },
            { ["@ibl.scope.char.1"] = { fg = { from = "Normal", attr = "bg", alter = 1.5 } } },
          },
          ["lackluster"] = {
            { ["@ibl.indent.char.1"] = { fg = { from = "Normal", attr = "bg", alter = 0.8 } } },
            { ["@ibl.scope.char.1"] = { fg = { from = "Normal", attr = "bg", alter = 2 } } },
          },
          ["everforest"] = {
            { ["@ibl.indent.char.1"] = { fg = { from = "Normal", attr = "bg", alter = -0.05 } } },
            { ["@ibl.scope.char.1"] = { fg = { from = "Normal", attr = "bg", alter = -0.4 } } },
          },
          ["tender"] = {
            { ["@ibl.indent.char.1"] = { fg = { from = "Normal", attr = "bg", alter = 0.2 } } },
            { ["@ibl.scope.char.1"] = { fg = { from = "Normal", attr = "bg", alter = 1 } } },
          },
          ["horizon"] = {
            { ["@ibl.indent.char.1"] = { fg = { from = "Normal", attr = "bg", alter = 0.3 } } },
            { ["@ibl.scope.char.1"] = { fg = { from = "Normal", attr = "bg", alter = 1.2 } } },
          },
          ["dawnfox"] = {
            { ["@ibl.indent.char.1"] = { fg = { from = "Normal", attr = "bg", alter = -0.05 } } },
            { ["@ibl.scope.char.1"] = { fg = { from = "Normal", attr = "bg", alter = -0.3 } } },
          },
          ["dayfox"] = {
            { ["@ibl.indent.char.1"] = { fg = { from = "Normal", attr = "bg", alter = -0.05 } } },
            { ["@ibl.scope.char.1"] = { fg = { from = "Normal", attr = "bg", alter = -0.1 } } },
          },
          ["catppuccin-latte"] = {
            { ["@ibl.indent.char.1"] = { fg = { from = "Normal", attr = "bg", alter = -0.05 } } },
            { ["@ibl.scope.char.1"] = { fg = { from = "Normal", attr = "bg", alter = -0.1 } } },
          },
          ["tokyonight-day"] = {
            { ["@ibl.indent.char.1"] = { fg = { from = "Normal", attr = "bg", alter = -0.03 } } },
            { ["@ibl.scope.char.1"] = { fg = { from = "Normal", attr = "bg", alter = -0.1 } } },
          },
          ["evangelion"] = {
            { ["@ibl.indent.char.1"] = { fg = { from = "Normal", attr = "bg", alter = 0.3 } } },
            { ["@ibl.scope.char.1"] = { fg = { from = "Normal", attr = "bg", alter = 1 } } },
          },
          ["rose-pine"] = {
            { ["@ibl.indent.char.1"] = { fg = { from = "Normal", attr = "bg", alter = -0.05 } } },
            { ["@ibl.scope.char.1"] = { fg = { from = "Normal", attr = "bg", alter = -0.4 } } },
          },
        },
      })
      return {
        scope = { show_start = is_show_start(), show_end = false, enabled = true },
        indent = {
          char = "▏", --  │, ┊, │, ▏, ┆, ┊, , ┊, "│"
          tab_char = "▏", -- "┊" -- │, ┊, │, ▏, ┆, ┊, , ┊
        },
        exclude = {
          filetypes = {
            "NvimTree",
            "dashboard",
            "dbout",
            "flutterToolsOutline",
            "fzf",
            "fzflua",
            "git",
            "gitcommit",
            "help",
            "log",
            "man",
            "markdown",
            "neo-tree",
            "neo-tree-popup",
            "norg",
            "calendar",
            "org",
            "orgagenda",
            "sagafinder",
            "trouble",
            "txt",
            "undotree",
            "",
          },
        },
      }
    end,
  },
  -- MINI.ICONS
  {
    "echasnovski/mini.icons",
    lazy = true,
    opts = {
      file = {
        [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
        ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
      },
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
      },
    },

    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  -- HELPVIEW.NVIM
  {
    "OXY2DEV/helpview.nvim",
    ft = "help",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  -- VIM-MATCHUP (disabled)
  {
    "andymass/vim-matchup",
    enabled = false,
    event = { "BufReadPost" },
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
  -- SNACKS
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = function()
      Highlight.plugin("NotifyCol", {
        -- INFO
        {
          SnacksNotifierInfo = {
            bg = { from = "DiagnosticInfo", attr = "fg", alter = -0.7 },
            fg = { from = "DiagnosticInfo", attr = "fg", alter = 5 },
            bold = true,
          },
        },
        {
          SnacksNotifierBorderInfo = {
            bg = { from = "DiagnosticInfo", attr = "fg", alter = -0.7 },
            fg = { from = "DiagnosticInfo", attr = "fg", alter = -0.4 },
          },
        },
        {
          SnacksNotifierTitleInfo = {
            bg = { from = "DiagnosticInfo", attr = "fg", alter = -0.7 },
            fg = { from = "DiagnosticInfo", attr = "fg", alter = 0.5 },
            bold = true,
          },
        },

        -- ERROR
        {
          SnacksNotifierError = {
            bg = { from = "DiagnosticError", attr = "fg", alter = -0.7 },
            fg = { from = "DiagnosticError", attr = "fg", alter = 5 },
            bold = true,
          },
        },
        {
          SnacksNotifierBorderError = {
            bg = { from = "DiagnosticError", attr = "fg", alter = -0.7 },
            fg = { from = "DiagnosticError", attr = "fg", alter = -0.4 },
          },
        },
        {
          SnacksNotifierTitleError = {
            bg = { from = "DiagnosticError", attr = "fg", alter = -0.7 },
            fg = { from = "DiagnosticError", attr = "fg", alter = 0.5 },
            bold = true,
          },
        },

        -- WARN
        {
          SnacksNotifierWarn = {
            bg = { from = "DiagnosticWarn", attr = "fg", alter = -0.7 },
            fg = { from = "DiagnosticWarn", attr = "fg", alter = 5 },
            bold = true,
          },
        },
        {
          SnacksNotifierBorderWarn = {
            bg = { from = "DiagnosticWarn", attr = "fg", alter = -0.7 },
            fg = { from = "DiagnosticWarn", attr = "fg", alter = -0.4 },
          },
        },
        {
          SnacksNotifierTitleWarn = {
            bg = { from = "DiagnosticWarn", attr = "fg", alter = -0.7 },
            fg = { from = "DiagnosticWarn", attr = "fg", alter = 0.5 },
            bold = true,
          },
        },
      })

      -- Toggle the profiler
      Snacks.toggle.profiler():map "<leader>pp"
      -- Toggle the profiler highlights
      Snacks.toggle.profiler_highlights():map "<leader>ph"

      return {
        bigfile = { enabled = true },
        notifier = { enabled = true },
        quickfile = { enabled = true },
        -- statuscolumn = { enabled = false }, -- we set this in options.lua
        -- toggle = { map = LazyVim.safe_keymap_set },
        words = { enabled = true },
      }
    end,
    -- stylua: ignore
    keys = {
      { "<Leader>.",  function() Snacks.scratch() end, desc = "Misc: toggle scratch buffer [snacks]" },
      { "<Leader>S",  function() Snacks.scratch.select() end, desc = "Misc: select scratch buffer [snacks]" },
      { "<Leader>ps", function() Snacks.profiler.scratch() end, desc = "Misc: profiler scratch buffer [snacks]" },
      { "<Leader>FC", function() Snacks.notifier.show_history() end, desc = "Misc: notification history [snacks]" },
      { "<Leader>un", function() Snacks.notifier.hide() end, desc = "Misc: dismiss all notifications [snacks]" },
    },
    config = function(_, opts)
      local notify = vim.notify
      require("snacks").setup(opts)
      -- HACK: restore vim.notify after snacks setup and let noice.nvim take over
      -- this is needed to have early notifications show up in noice history
      if RUtils.has "noice.nvim" then
        vim.notify = notify
      end
    end,
  },
  -- NOICE
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    keys = {
      {
        "<S-CR>",
        ---@diagnostic disable-next-line: param-type-mismatch
        function()
          require("noice").redirect(fn.getcmdline())
        end,
        mode = "c",
        desc = "Noice: redirect cmdline",
      },
      {
        "<Localleader>Nd",
        function()
          require("noice").cmd "dismiss"
        end,
        desc = "Noice: dismiss all",
      },
      {
        "<Localleader>Nl",
        function()
          require("noice").cmd "last"
        end,
        desc = "Noice: last message",
      },
      {
        "<Localleader>Nh",
        function()
          require("noice").cmd "history"
        end,
        desc = "Noice: history",
      },
      {
        "<Localleader>Nf",
        function()
          require("noice").cmd "pick"
        end,
        desc = "Noice: picker (telescope/fzflua)",
      },
    },
    config = function(_, opts)
      -- HACK: noice shows messages from before it was enabled,
      -- but this is not ideal when Lazy is installing plugins,
      -- so clear the messages in this case.
      if vim.o.filetype == "lazy" then
        vim.cmd [[messages clear]]
      end
      require("noice").setup(opts)
    end,
    opts = function()
      Highlight.plugin("notify", {
        theme = {
          ["*"] = {
            { NoiceCmdlinePopupBorder = { fg = { from = "FloatBorder", bg = { from = "NormalFloat" } } } },
            { NoiceCmdlinePopupTitle = { fg = { from = "FzfLuaTitle", attr = "fg" } } },
            { NoiceCmdlinePopupTitleLua = { fg = { from = "FzfLuaTitle", attr = "fg" } } },
            { NoiceCmdlinePopupTitleCmdline = { fg = { from = "FzfLuaTitle", attr = "fg" } } },
            { NoiceCmdlinePopup = { inherit = "NormalFloat" } },
            { NoiceCmdlineIcon = { bg = { from = "NormalFloat", attr = "bg" } } },

            { NotifyBackground = { bg = { from = "Normal", attr = "fg", alter = 1 } } },
            { NoicePopupBorder = { inherit = "FloatBorder" } },
          },
          ["everforest"] = {
            { NoiceCmdlineIcon = { bg = { from = "NormalFloat", attr = "bg" } } },
            { NoicePopupBorder = { fg = { from = "Normal", attr = "bg", alter = -0.2 } } },
          },
          ["lackluster"] = {
            { NoiceCmdlineIcon = { bg = { from = "NormalFloat", attr = "bg" } } },
            { NoicePopupBorder = { fg = { from = "Normal", attr = "bg", alter = -0.2 } } },
          },
        },
      })

      return {
        -- debug = true,
        lsp = {
          documentation = {
            opts = {
              border = { style = "rounded" },
              position = { row = 2 },
            },
          },
          progress = { enabled = false },
          hover = { enabled = true },
          signature = { auto_open = { enabled = true }, enabled = false },
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        redirect = { view = "popup", filter = { event = "msg_show" } },
        views = {
          cmdline_popup = {
            position = {
              row = -2,
              col = "1%",
            },
          },
          cmdline_popupmenu = {
            position = {
              row = -5,
              col = "1%",
            },
          },
          popupmenu = {
            border = {},
            relative = "editor",
            position = {
              row = "55%",
              col = "50%",
            },
            size = {
              width = 60,
              height = 12, --you can set this to any height, even "auto", depending on your preference
            },
            win_options = {
              winblend = 0,
              winhighlight = {
                Normal = "Normal",
                FloatBorder = "DiagnosticInfo",
              },
            },
          },
        },
        routes = {
          { filter = { event = "lsp", find = "overly long loop" }, opts = { skip = true } },
          { filter = { event = "notify", find = "position_encoding" }, opts = { skip = true } },

          {
            opts = { skip = true },
            filter = {
              any = {
                -- { find = "%d+L, %d+B" },
                -- { find = "; after #%d+" },
                -- { find = "; before #%d+" },
                { event = "msg_show", find = "written" },
                { event = "msg_show", find = "%d+ lines, %d+ bytes" },
                { event = "msg_show", kind = "search_count" },
                { event = "msg_show", find = "%d+L, %d+B" },
                { event = "msg_show", find = "^Hunk %d+ of %d" },
                { event = "msg_show", find = "%d+ change" },
                { event = "msg_show", find = "%d+ line" },
                { event = "msg_show", find = "%d+ more line" },

                -- Avoid show message from lsp_signature
                { event = "msg_show", find = "lsp_signatur" },

                -- { event = "msg_show", find = "error list" },
              },
            },
          },
          {
            view = "mini",
            filter = {
              any = {
                { event = "msg_show", find = "^E486:" },
                -- { event = "notify", max_height = 1 },
              },
            }, -- minimise pattern not found messages
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
        },
      }
    end,
  },
  -- FOLD CYCLE
  {
    "jghauser/fold-cycle.nvim",
    opts = true,
    keys = {
      {
        "<S-TAB>",
        function()
          require("fold-cycle").open()
        end,
        desc = "Fold: cycle fold [fold-cycle]",
      },
    },
  },
  -- BEACON
  {
    "rainbowhxch/beacon.nvim",
    event = "LazyFile",
    cond = vim.g.neovide == nil,
    opts = function()
      Highlight.plugin("beaconHiC", {
        { ["BeaconDefault"] = { bg = "red" } },
      })

      return {
        minimal_jump = 50,
        ignore_buffers = { "terminal", "nofile", "neorg://Quick Actions" },
        ignore_filetypes = {
          "qf",
          "dap_watches",
          "dap_scopes",
          -- "neo-tree",
          "fzf",
          "lazy",
          "NeogitCommitMessage",
          "NeogitPopup",
          "NeogitStatus",
        },
      }
    end,
  },
  -- BUFDELETE
  {
    "famiu/bufdelete.nvim",
    lazy = true,
  },
  -- FIX-AUTO-SCROLL
  {
    "BranimirE/fix-auto-scroll.nvim",
    config = true,
    event = "VeryLazy",
  },
  -- TABBY
  {
    "nanozuki/tabby.nvim",
    event = "VeryLazy",
    config = function()
      local theme = {
        fill = "Normal",
        -- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
        head = "TabLine",
        separator = { fg = Highlight.get("TabLine", "bg"), bg = "NONE" },
        current_tab = "TabLineSel",
        tab = "TabLine",
        win = "TabLine",
        tail = "TabLine",
      }
      require("tabby").setup {
        line = function(line)
          return {
            -- {
            --   { "  ", hl = theme.head },
            --   line.sep("", theme.head, theme.fill),
            -- },
            line.tabs().foreach(function(tab)
              local hl = tab.is_current() and theme.current_tab or theme.tab
              return {
                line.sep("", hl, theme.separator),
                -- " ",
                tab.is_current() and "" or "󰆣",
                tab.number(),
                -- tab.name(),
                -- " ",
                -- -- tab.close_btn "",
                line.sep("", hl, theme.separator),
                hl = hl,
                margin = " ",
              }
            end),
            line.spacer(),
            line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
              return {
                line.sep("", theme.win, theme.separator),
                win.is_current() and "" or "",
                win.buf_name(),
                line.sep("", theme.win, theme.separator),
                hl = theme.win,
                margin = " ",
              }
            end),
            {
              line.sep("", theme.tail, theme.fill),
              { "  ", hl = theme.tail },
            },
            hl = theme.fill,
          }
        end,
        -- option = {}, -- setup modules' option,
      }
    end,
  },
  -- MINI.ICONS
  {
    "echasnovski/mini.icons",
    lazy = true,
    opts = {
      file = {
        [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
        ["CODEOWNERS"] = { glyph = "", hl = "MiniIconsGreen" },
        ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
      },
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
      },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
}
