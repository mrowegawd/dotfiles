local fn = vim.fn
local Highlight = require "r.settings.highlights"

local old_notify = vim.notify

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
    event = { "LazyFile" },
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
        },
      })
      return {
        scope = { show_start = is_show_start(), show_end = false, enabled = true },
        indent = {
          char = "▏", --  │, ┊, │, ▏, ┆, ┊, , ┊, "│"
          tab_char = "▏", -- "┊" -- │, ┊, │, ▏, ┆, ┊, , ┊
          repeat_linebreak = false,
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
  -- NEOZOOM
  {
    "nyngwang/NeoZoom.lua",
    keys = {
      { "sm", "<CMD>NeoZoomToggle<CR>", desc = "View: toggle zoom [neozoom]" },
      { "<a-m>", "<CMD>NeoZoomToggle<CR>", desc = "View: toggle zoom [neozoom]", mode = { "n", "t" } },
    },
    opts = {
      scrolloff_on_enter = 7,
      exclude_buftypes = {},
    },
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
  -- NVIM-NOTIFY
  {
    "rcarriga/nvim-notify",
    init = function()
      -- when noice is not enabled, install notify on VeryLazy
      if not RUtils.has "noice.nvim" then
        RUtils.on_very_lazy(function()
          vim.notify = require "notify"
        end)
      end
    end,
    opts = function()
      Highlight.plugin("NotifyCol", {
        -- { NotifyBackground = { bg = { from = "DiagnosticWarn" } } },
        -- { NotifyERRORBorder = { bg = { from = "NormalFloat" } } },
        -- { NotifyWARNBorder = { bg = { from = "NormalFloat" } } },
        -- { NotifyINFOBorder = { bg = { from = "NormalFloat" } } },
        -- { NotifyDEBUGBorder = { bg = { from = "NormalFloat" } } },
        -- { NotifyTRACEBorder = { bg = { from = "NormalFloat" } } },
        -- { NotifyERRORBody = { link = "NormalFloat" } },
        -- { NotifyWARNBody = { link = "NormalFloat" } },

        -- INFO
        {
          NotifyINFOBody = {
            bg = { from = "DiagnosticInfo", attr = "fg", alter = -0.8 },
            fg = { from = "DiagnosticInfo", attr = "fg", alter = 5 },
            bold = true,
          },
        },
        {
          NotifyINFOBorder = {
            bg = { from = "DiagnosticInfo", attr = "fg", alter = -0.8 },
            fg = { from = "DiagnosticInfo", attr = "fg", alter = -0.6 },
          },
        },
        {
          NotifyINFOTitle = {
            bg = { from = "DiagnosticInfo", attr = "fg", alter = -0.8 },
            fg = { from = "DiagnosticInfo", attr = "fg", alter = -0.2 },
            bold = true,
          },
        },
        {
          NotifyINFOIcon = {
            bg = { from = "DiagnosticInfo", attr = "fg", alter = -0.8 },
            fg = { from = "DiagnosticInfo", attr = "fg", alter = -0.2 },
          },
        },

        -- WARN
        {
          NotifyWARNBody = {
            bg = { from = "DiagnosticWarn", attr = "fg", alter = -0.8 },
            fg = { from = "DiagnosticWarn", attr = "fg", alter = 5 },
            bold = true,
          },
        },
        {
          NotifyWARNBorder = {
            bg = { from = "DiagnosticWarn", attr = "fg", alter = -0.8 },
            fg = { from = "DiagnosticWarn", attr = "fg", alter = -0.6 },
          },
        },
        {
          NotifyWARNTitle = {
            bg = { from = "DiagnosticWarn", attr = "fg", alter = -0.8 },
            fg = { from = "DiagnosticWarn", attr = "fg", alter = -0.2 },
            bold = true,
          },
        },
        {
          NotifyWARNIcon = {
            bg = { from = "DiagnosticWarn", attr = "fg", alter = -0.8 },
            fg = { from = "DiagnosticWarn", attr = "fg", alter = -0.2 },
          },
        },

        -- ERROR
        {
          NotifyERRORBody = {
            bg = { from = "DiagnosticError", attr = "fg", alter = -0.8 },
            fg = { from = "DiagnosticError", attr = "fg", alter = 5 },
            bold = true,
          },
        },
        {
          NotifyERRORBorder = {
            bg = { from = "DiagnosticError", attr = "fg", alter = -0.8 },
            fg = { from = "DiagnosticError", attr = "fg", alter = -0.6 },
          },
        },
        {
          NotifyERRORTitle = {
            bg = { from = "DiagnosticError", attr = "fg", alter = -0.8 },
            fg = { from = "DiagnosticError", attr = "fg", alter = -0.2 },
            bold = true,
          },
        },
        {
          NotifyERRORIcon = {
            bg = { from = "DiagnosticError", attr = "fg", alter = -0.8 },
            fg = { from = "DiagnosticError", attr = "fg", alter = -0.2 },
          },
        },
      })

      return {
        stages = "static",
        timeout = 5000,
        max_width = function()
          return math.floor(vim.o.columns * 0.6)
        end,
        top_down = false,
        max_height = function()
          return math.floor(vim.o.lines * 0.8)
        end,
        -- render = function(...)
        --   local notification = select(2, ...)
        --   local style = RUtils.cmd.falsy(notification.title[1]) and "minimal" or "default"
        --   require("notify.render")[style](...)
        -- end,
        render = "wrapped-compact",
        on_open = function(win)
          vim.api.nvim_win_set_config(win, { zindex = 175 })
        end,
      }
    end,
    config = function(_, opts)
      vim.notify = old_notify
      local notify = require "notify"
      vim.notify = notify
      notify.setup(opts)

      -- Taken from: https://github.com/rcarriga/nvim-notify/issues/189#issuecomment-2225599658
      local util = require "notify.stages.util"
      local get_slot_range = util.get_slot_range
      local override = function(direction)
        local a, b = get_slot_range(direction)
        if direction == util.DIRECTION.TOP_DOWN then
          b = b - 1
        elseif direction == util.DIRECTION.BOTTOM_UP then
          a = a - 1
        end
        return a, b
      end
      util.get_slot_range = override
    end,
  },
  -- NOICE
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    keys = {
      {
        "<Localleader>nf",
        function()
          local Config = require "noice.config"
          local Manager = require "noice.message.manager"

          local messages = Manager.get(Config.options.commands.history.filter, {
            history = true,
            sort = true,
            reverse = true,
          })

          if #messages == 0 then
            print "Noice notification list is empty"
            return
          end

          require("noice").cmd "telescope"
        end,
        desc = "Noice: notification history",
      },

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
        "<Localleader>nd",
        function()
          require("noice").cmd "dismiss"
        end,
        desc = "Noice: dismiss all",
      },
      {
        "<Localleader>nl",
        function()
          require("noice").cmd "last"
        end,
        desc = "Noice: last message",
      },
      {
        "<Localleader>nh",
        function()
          require("noice").cmd "history"
        end,
        desc = "Noice: history",
      },
      {
        "<Localleader>np",
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
          -- Do not show error messages for `-32603`
          -- this will lead to an endless loop of errors
          -- remove this line after this issue gets fixed or reverting back to the last working version
          -- https://github.com/rust-lang/rust-analyzer/issues/17430
          { filter = { event = "notify", find = "-32603" }, opts = { skip = true } },
          { filter = { event = "lsp", find = "overly long loop" }, opts = { skip = true } },

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
}
