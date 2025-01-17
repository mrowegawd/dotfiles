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
    "snacks.nvim",
    optional = true,
    opts = function()
      Highlight.plugin("Snacks_highlights", {
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
            fg = { from = "SnacksNotifierInfo", attr = "bg" },
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
            fg = { from = "SnacksNotifierError", attr = "bg" },
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
            -- fg = { from = "DiagnosticWarn", attr = "fg", alter = -0.4 },
            fg = { from = "SnacksNotifierWarn", attr = "bg" },
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

      return {
        bigfile = { enabled = true },
        notifier = { enabled = true },
        quickfile = { enabled = true },
        -- NOTE: jika di enable maka vim.input akan terdampak behaviour nya.
        -- Seperti open task orgagenda, window nya jadi di tengah
        -- picker = {},
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
        lazygit = {
          theme_path = os.getenv "HOME" .. "/.config/lazygit/theme/fla.yml",
          theme = {
            [241] = { fg = "Special" },
            activeBorderColor = { fg = "Keyword", bold = true },
            cherryPickedCommitBgColor = { fg = "Identifier" },
            cherryPickedCommitFgColor = { fg = "Function" },
            defaultFgColor = { fg = "Normal" },
            optionsTextColor = { fg = "Function" },
            searchingActiveBorderColor = { fg = "MatchParen", bold = true },
            selectedLineBgColor = { bg = "LazygitselectedLineBgColor" }, -- set to `default` to have no background colour
            inactiveBorderColor = { fg = "LazygitInactiveBorderColor" },
            unstagedChangesColor = { fg = "DiagnosticError" },
          },
        },
        words = { enabled = true },
        dashboard = {
          pane_gap = 4, -- empty columns between vertical panes
          -- row = 4,
          -- col = 4,
          preset = {
            keys = {
              { icon = " ", key = "f", desc = "Find File", action = ':lua require("fzf-lua").files()' },
              { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
              { icon = " ", key = "r", desc = "Recent Files", action = ':lua require("fzf-lua").oldfiles()' },
              {
                icon = " ",
                key = "L",
                desc = "Select Session",
                action = ':lua require("r.utils.sessions").load_ses_dashboard()',
              },
              {
                icon = " ",
                key = "l",
                desc = "Restore Last Session",
                action = ':lua require("r.utils.sessions").load_ses_dashboard(true)',
              },
              -- { icon = "󱞁 ", key = "w", desc = "Obsidian Notes", action = ":ObsidianQuickSwitch" },
              -- { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
              { icon = "󰒲 ", key = "y", desc = "Lazy", action = ":Lazy" },
              { icon = " ", key = "q", desc = "Quit", action = ":qa" },
            },
            header = require("r.utils").logo(),
          },
          sections = {
            {

              { section = "header", align = "center" },
              { section = "startup", align = "center", padding = 0 },
            },
            {
              pane = 2,
              {
                { icon = " ", title = "Recent Files", section = "recent_files", limit = 4, padding = 1 },
                { section = "keys", gap = 0, padding = 1 },
                {
                  section = "terminal",
                  icon = " ",
                  title = "Git Status",
                  enabled = vim.fn.isdirectory ".git" == 1,
                  cmd = "hub diff --stat -B -M -C",
                  -- gap = 0,
                  height = 8,
                  -- padding = 1,
                  indent = 2,
                },
              },
            },
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
      -- { "gs", function() Snacks.picker.lsp_symbols() end, desc = "Snacks: profiler scratch buffer" },
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
        "<Localleader>nf",
        function()
          require("noice").cmd "pick"
        end,
        desc = "Noice: picker (telescope/fzflua)",
      },
    },
    opts = function()
      Highlight.plugin("noicehi", {
        { NoiceMini = { inherit = "MsgArea", bg = { from = "Normal" } } },
        { NoicePopupBaseGroup = { inherit = "Pmenu", fg = { from = "DiagnosticSignInfo" } } },
        { NoicePopupWarnBaseGroup = { inherit = "Pmenu", fg = { from = "Float" } } },
        { NoicePopupInfoBaseGroup = { inherit = "Pmenu", fg = { from = "Conditional" } } },
        { NoiceCmdlinePopup = { bg = { from = "Pmenu" } } },
        { NoiceCmdlinePopupBorder = { link = "FloatBorder" } },
        { NoiceCmdlinePopupTitleCmdline = { inherit = "NoicePopupBaseGroup", reverse = true } },
        { NoiceCmdlinePopupBorderCmdline = { link = "NoicePopupBaseGroup" } },
        { NoiceCmdlinePopupBorderSearch = { link = "NoicePopupWarnBaseGroup" } },
        { NoiceCmdlinePopupTitleSearch = { inherit = "NoicePopupWarnBaseGroup", reverse = true } },
        { NoiceCmdlinePopupBorderFilter = { link = "NoicePopupWarnBaseGroup" } },
        { NoiceCmdlinePopupTitleFilter = { inherit = "NoicePopupWarnBaseGroup", reverse = true } },
        { NoiceCmdlinePopupBorderHelp = { link = "NoicePopupInfoBaseGroup" } },
        { NoiceCmdlinePopupTitleHelp = { inherit = "NoicePopupInfoBaseGroup", reverse = true } },
        { NoiceCmdlinePopupBorderSubstitute = { link = "NoicePopupWarnBaseGroup" } },
        { NoiceCmdlinePopupTitleSubstitute = { inherit = "NoicePopupWarnBaseGroup", reverse = true } },
        { NoiceCmdlinePopupBorderIncRename = { link = "NoicePopupWarnBaseGroup" } },
        { NoiceCmdlinePopupTitleIncRename = { inherit = "NoicePopupWarnBaseGroup", reverse = true } },
        { NoiceCmdlinePopupBorderInput = { link = "NoicePopupBaseGroup" } },
        { NoiceCmdlinePopupBorderLua = { link = "NoicePopupBaseGroup" } },
        {
          NoiceCmdlineIconCmdline = {
            fg = { from = "NoicePopupBaseGroup", attr = "fg" },
            bg = { from = "NoiceCmdline", attr = "bg" },
          },
        },
        { NoiceCmdlineIconSearch = { link = "NoicePopupWarnBaseGroup" } },
        { NoiceCmdlineIconFilter = { link = "NoicePopupWarnBaseGroup" } },
        { NoiceCmdlineIconHelp = { link = "NoicePopupInfoBaseGroup" } },
        { NoiceCmdlineIconIncRename = { link = "NoicePopupWarnBaseGroup" } },
        { NoiceCmdlineIconSubstitute = { link = "NoicePopupWarnBaseGroup" } },
        { NoiceCmdlineIconInput = { link = "NoicePopupBaseGroup" } },
        { NoiceCmdlineIconLua = { link = "NoicePopupBaseGroup" } },
        { NoiceConfirm = { bg = { from = "Pmenu" } } },
        { NoiceConfirmBorder = { link = "NoicePopupBaseGroup" } },
      })

      return {
        -- debug = true,
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        cmdline = { view = "cmdline" },
        views = {
          cmdline_popup = { position = { row = -2, col = "1%" } },
          cmdline_popupmenu = {
            position = { row = -2, col = "1%" },
            size = { width = "auto", height = "auto" },
            win_options = { winhighlight = { Normal = "Pmenu", FloatBorder = "CmpItemFloatBorder" } },
          },
          popupmenu = {
            border = {},
            relative = "editor",
            position = { row = "55%", col = "50%" },
            size = { width = 60, height = 12 },
            win_options = {
              winblend = 0,
              winhighlight = { Normal = "FloatNormal", FloatBorder = "DiagnosticInfo" },
            },
          },
        },
        routes = {
          {
            filter = {
              event = "msg_show",
              any = {
                { find = "%d+ change" },
                { find = "%d+ line" },
                { find = "%d+ lines, %d+ bytes" },
                { find = "%d+ more line" },
                { find = "%d+L, %d+B" },
                { find = "%d+L, %d+B" },
                { find = "; after #%d+" },
                { find = "; before #%d+" },
                { find = "^Hunk %d+ of %d" },
                { find = "written" },
                { kind = "search_count" },
                { kind = "line %d+ of %d+" },
              },
            },
            view = "mini",
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          lsp_doc_border = true, -- add a border to hover docs and signature help
        },
      }
    end,
    config = function(_, opts)
      -- HACK: noice shows messages from before it was enabled,
      -- but this is not ideal when Lazy is installing plugins,
      -- so clear the messages in this case.
      if vim.o.filetype == "lazy" then
        vim.cmd [[messages clear]]
      end
      require("noice").setup(opts)
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
  -- BLOCK.NVIM
  {
    "HampusHauffman/block.nvim",
    cmd = { "BlockOn", "BlockOff", "Block" },
    opts = true,
  },
  -- BEACON
  {
    -- flash cursor when jumps or moves between windows.
    "rainbowhxch/beacon.nvim",
    event = "LazyFile",
    cond = vim.g.neovide == nil,
    opts = function()
      Highlight.plugin("beaconHiC", {
        -- Sama kan dengan terminal cursor color
        theme = {
          ["*"] = {
            { ["BeaconDefault"] = { bg = "red" } },
          },
          ["carbonfox"] = {
            { ["BeaconDefault"] = { bg = "#6d32c9" } },
          },
          ["neomodern"] = {
            { ["BeaconDefault"] = { bg = "#bbbac1" } },
          },
          ["evangelion"] = {
            { ["BeaconDefault"] = { bg = "#18b530" } },
          },
          ["horizon"] = {
            { ["BeaconDefault"] = { bg = "#b3276f" } },
          },
          ["kanagawa"] = {
            { ["BeaconDefault"] = { bg = "#c8c093" } },
          },
          ["lackluster"] = {
            { ["BeaconDefault"] = { bg = "#deeeed" } },
          },
          ["selenized"] = {
            { ["BeaconDefault"] = { bg = "#ee5396" } },
          },
          ["sonokai"] = {
            { ["BeaconDefault"] = { bg = "#9e0e06" } },
          },
          ["tokyonight-storm"] = {
            { ["BeaconDefault"] = { bg = "#b3276f" } },
          },
        },
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
  -- TABBY
  {
    "nanozuki/tabby.nvim",
    event = "VeryLazy",
    config = function()
      local theme = {
        fill = "Normal",
        -- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
        head = "Normal",
        separator = "Normal",
        current_tab = {
          bg = Highlight.get("KeywordNC", "bg"),
          fg = Highlight.get("KeywordNC", "fg"),
        },
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
                tab.is_current() and "" or "󰆣",
                tab.number(),
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
    event = "UIEnter",
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
                prompt = "   ",
                winopts = {
                  title = opts.prompt,
                  relative = "editor",
                  col = col,
                  row = row,
                  width = math.floor(math.min(60, vim.o.columns / 2)),
                  height = 15,
                },
              },
            }
          end
          return {
            backend = "fzf_lua",
            fzf_lua = RUtils.fzflua.dropdown {
              winopts = { title = opts.prompt },
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
