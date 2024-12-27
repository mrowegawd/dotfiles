local fn = vim.fn
local Highlight = require "r.settings.highlights"

return {
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
        theme = {
          ["*"] = {
            { SnacksIndent = { fg = { from = "Normal", attr = "bg", alter = 0.5 } } },
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
          },
        },
      })

      return {
        bigfile = { enabled = true },
        notifier = { enabled = true },
        quickfile = { enabled = true },
        indent = {
          enabled = true,
          -- priority = 1,
          char = "▏", --  │, ┊, │, ▏, ┆, ┊, , ┊, "│"
          only_scope = false,
          only_current = false,
          hl = {
            "SnacksIndent1",
            "SnacksIndent2",
            "SnacksIndent3",
            "SnacksIndent4",
            "SnacksIndent5",
            "SnacksIndent6",
            "SnacksIndent7",
            "SnacksIndent8",
          },
        },
        -- statuscolumn = { enabled = false }, -- we set this in options.lua
        -- toggle = { map = LazyVim.safe_keymap_set },
        words = { enabled = true },
        dashboard = {
          preset = {
            keys = {
              { icon = " ", key = "f", desc = "Find File", action = ':lua require("fzf-lua").files()' },
              { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
              { icon = " ", key = "r", desc = "Recent Files", action = ':lua require("fzf-lua").oldfiles()' },
              {
                icon = " ",
                key = "s",
                desc = "Restore Session",
                action = ':lua require("r.utils.sessions").load_ses_dashboard()',
              },
              -- { icon = "󱞁 ", key = "w", desc = "Obsidian Notes", action = ":ObsidianQuickSwitch" },
              -- { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
              { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
              { icon = " ", key = "q", desc = "Quit", action = ":qa" },
            },
            header = require("r.utils").logo(),
          },
          sections = {
            { section = "header", padding = 1, align = "center" },
            { icon = " ", title = "Recent Files", section = "recent_files", limit = 4, padding = 1 },
            { section = "keys", gap = 1, padding = 1 },
            { section = "startup" },
            -- { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          },
        },
      }
    end,
    -- stylua: ignore
    keys = {
      -- { "<Localleader>s.", function() Snacks.scratch() end, desc = "Snacks: toggle scratch buffer" },
      -- { "<Localleader>sS", function() Snacks.scratch.select() end, desc = "Snacks: select scratch buffer" },
      -- { "<Localleader>sps", function() Snacks.profiler.scratch() end, desc = "Snacks: profiler scratch buffer" },

      { "<Localleader>sh", function() Snacks.notifier.show_history() end, desc = "Snacks: notification history" },
      { "<Localleader>sn", function() Snacks.notifier.hide() end, desc = "Snacks: dismiss all notifications" },
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
            { NoiceCmdlinePopup = { bg = { from = "NormalFloat", attr = "bg", alter = -0.15 } } },
            { NoiceCmdlineIcon = { bg = "NONE" } },

            { NotifyBackground = { bg = { from = "Normal", attr = "fg", alter = 1 } } },
            { NoicePopupBorder = { inherit = "FloatBorder" } },
          },
          ["everforest"] = {
            { NoiceCmdlineIcon = { bg = "NONE" } },
            { NoicePopupBorder = { fg = { from = "Normal", attr = "bg", alter = -0.2 } } },
          },
          ["lackluster"] = {
            { NoiceCmdlineIcon = { bg = "NONE" } },
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
          progress = { enabled = true },
          hover = { enabled = true },
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
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
        "`",
        function()
          require("fold-cycle").open()
        end,
        desc = "Fold: cycle fold [fold-cycle]",
        mode = { "v", "n" },
      },
    },
  },
  -- BEACON (disabled)
  {
    -- flash cursor when jumps or moves between windows.
    "rainbowhxch/beacon.nvim",
    event = "LazyFile",
    enabled = false,
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
  -- DRESSING
  {
    "stevearc/dressing.nvim",
    -- enabled = false,
    event = "VimEnter",
    opts = {
      input = { enabled = true },
      select = {
        -- priority: use fzf_lua first before anything else
        backend = { "fzf_lua", "builtin" },
        builtin = {
          border = RUtils.config.icons.border.line,
          min_height = 10,
          win_options = { winblend = 10 },
          mappings = { n = { ["q"] = "Close" } },
        },
        get_config = function(opts)
          opts.prompt = opts.prompt and opts.prompt:gsub(":", "")
          if opts.kind == "codeaction" then
            return {
              backend = "fzf_lua",
              fzf_lua = RUtils.fzflua.cursor_dropdown {
                prompt = "  ",
                winopts = { title = opts.prompt, relative = "cursor" },
              },
            }
          end
          if opts.kind == "orgmode" then
            return {
              backend = "nui",
              nui = {
                position = "90%",
                border = { style = RUtils.config.icons.border.line },
                min_width = math.floor(vim.o.columns / 2 - 50),
              },
            }
          end
          if opts.kind == "pojokan" then
            local col, row = RUtils.fzflua.rectangle_win_pojokan()
            return {
              backend = "fzf_lua",
              fzf_lua = RUtils.fzflua.cursor_dropdown {
                winopts = {
                  title = opts.prompt,
                  relative = "editor",
                  col = col,
                  row = row,
                },
                prompt = "  ",
              },
            }
          end
          return {
            backend = "fzf_lua",
            fzf_lua = RUtils.fzflua.dropdown {
              winopts = { title = opts.prompt, height = 0.33, row = 0.5 },
            },
          }
        end,
        nui = {
          min_height = 10,
          win_options = {
            winhighlight = table.concat({
              "Normal:Italic",
              "FloatBorder:FloatBorder",
              "FloatTitle:Title",
              "CursorLine:Visual",
            }, ","),
          },
        },
      },
      win_options = {
        winhighlight = "FloatBorder:FzfLuaBorder",
      },
    },
  },
}
