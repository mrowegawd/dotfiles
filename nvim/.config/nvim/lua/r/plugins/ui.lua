return {
  -- HELPVIEW.NVIM
  {
    "OXY2DEV/helpview.nvim",
    event = { "BufReadPost" },
  },
  -- VIM-MATCHUP (disabled)
  {
    "andymass/vim-matchup",
    enabled = false,
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
  -- NOICE
  {
    "folke/noice.nvim",
    event = "BufReadPost",
    dependencies = { "MunifTanjim/nui.nvim" },
    keys = {
      {
        "<S-CR>",
        function()
          require("noice").redirect(vim.fn.getcmdline())
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
      -- local Highlight = require "r.settings.highlights"
      --
      -- Highlight.plugin("noicehi", {
      --   { NoiceMini = { inherit = "MsgArea", bg = { from = "Normal" } } },
      --   { NoicePopupBaseGroup = { inherit = "FloatBorder", fg = { from = "DiagnosticSignInfo" } } },
      --   { NoicePopupWarnBaseGroup = { inherit = "Pmenu", fg = { from = "Float" } } },
      --   { NoicePopupInfoBaseGroup = { inherit = "Pmenu", fg = { from = "Conditional" } } },
      --   -- { NoiceCmdlinePopup = { bg = { from = "Pmenu" } } },
      --   { NoiceCmdlinePopupBorder = { link = "FloatBorder" } },
      --   { NoiceCmdlinePopupTitleCmdline = { inherit = "NoicePopupBaseGroup", reverse = true } },
      --   { NoiceCmdlinePopupBorderCmdline = { link = "NoicePopupBaseGroup" } },
      --   { NoiceCmdlinePopupBorderSearch = { link = "NoicePopupWarnBaseGroup" } },
      --   { NoiceCmdlinePopupTitleSearch = { inherit = "NoicePopupWarnBaseGroup", reverse = true } },
      --   { NoiceCmdlinePopupBorderFilter = { link = "NoicePopupWarnBaseGroup" } },
      --   { NoiceCmdlinePopupTitleFilter = { inherit = "NoicePopupWarnBaseGroup", reverse = true } },
      --   { NoiceCmdlinePopupBorderHelp = { link = "NoicePopupInfoBaseGroup" } },
      --   { NoiceCmdlinePopupTitleHelp = { inherit = "NoicePopupInfoBaseGroup", reverse = true } },
      --   { NoiceCmdlinePopupBorderSubstitute = { link = "NoicePopupWarnBaseGroup" } },
      --   { NoiceCmdlinePopupTitleSubstitute = { inherit = "NoicePopupWarnBaseGroup", reverse = true } },
      --   { NoiceCmdlinePopupBorderIncRename = { link = "NoicePopupWarnBaseGroup" } },
      --   { NoiceCmdlinePopupTitleIncRename = { inherit = "NoicePopupWarnBaseGroup", reverse = true } },
      --   { NoiceCmdlinePopupBorderInput = { link = "NoicePopupBaseGroup" } },
      --   { NoiceCmdlinePopupBorderLua = { link = "NoicePopupBaseGroup" } },
      --   {
      --     NoiceCmdlineIconCmdline = {
      --       fg = { from = "NoicePopupBaseGroup", attr = "fg" },
      --       bg = { from = "NoiceCmdline", attr = "bg" },
      --     },
      --   },
      --   {
      --     NoiceCmdlineIconSearch = {
      --       inherit = "NoicePopupWarnBaseGroup",
      --       bg = { from = "NoiceCmdline", attr = "bg" },
      --     },
      --   },
      --   {
      --     NoiceCmdlineIconFilter = {
      --       inherit = "NoicePopupWarnBaseGroup",
      --       bg = { from = "NoiceCmdline", attr = "bg" },
      --     },
      --   },
      --   {
      --     NoiceCmdlineIconHelp = {
      --       inherit = "NoicePopupInfoBaseGroup",
      --       bg = { from = "NoiceCmdline", attr = "bg" },
      --     },
      --   },
      --   {
      --     NoiceCmdlineIconIncRename = {
      --       inherit = "NoicePopupWarnBaseGroup",
      --       bg = { from = "NoiceCmdline", attr = "bg" },
      --     },
      --   },
      --   { NoiceCmdlineIconSubstitute = { link = "NoicePopupWarnBaseGroup" } },
      --   { NoiceCmdlineIconInput = { link = "NoicePopupBaseGroup" } },
      --   { NoiceCmdlineIconLua = { link = "NoicePopupBaseGroup" } },
      --   { NoiceConfirm = { bg = { from = "Pmenu" } } },
      --   { NoiceConfirmBorder = { link = "NoicePopupBaseGroup" } },
      --
      --   -- NOTE: this line contains color markup modified by Noice,
      --   -- so it needs to be manually re-colored
      --   { ["@markup.raw.markdown_inline"] = { bg = "NONE" } },
      -- })

      return {
        -- debug = true,
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
          signature = { enabled = false },
          progress = { enabled = true },
        },
        cmdline = { view = "cmdline" },
        views = {
          cmdline_popup = { position = { row = -2, col = "1%" } },
          cmdline_popupmenu = {
            position = { row = -2.1, col = "1%" },
            size = { width = "auto", height = "auto" },
            win_options = { winhighlight = { Normal = "Pmenu", FloatBorder = "CmpItemFloatBorder" } },
          },
          popupmenu = {
            border = {},
            relative = "editor",
            position = { row = "55%", col = "50%" },
            size = { width = 60, height = 12 },
            win_options = { winblend = 0, winhighlight = { Normal = "Pmenu", FloatBorder = "DiagnosticInfo" } },
          },
          hover = { win_options = { winhighlight = { Normal = "CmpDocNormal", FloatBorder = "CmpDocFloatBorder" } } },
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
                -- { find = "%d+L, %d+B" },
                { find = "; after #%d+" },
                { find = "; before #%d+" },
                { find = "^Hunk %d+ of %d" },
                { find = "written" },
                { kind = "line %d+ of %d+" },
                { kind = "search_count" },
              },
            },
            view = "mini",
          },
          {
            opts = { skip = true },
            filter = {
              any = {
                { event = "msg_show", find = "written" },
                { event = "msg_show", find = "%d+ lines, %d+ bytes" },
                { event = "msg_show", kind = "search_count" },
                { event = "msg_show", find = "%d+L, %d+B" },
                { event = "msg_show", find = "^Hunk %d+ of %d" },
                { event = "msg_show", find = "%d+ change" },
                { event = "msg_show", find = "%d+ line" },
                { event = "msg_show", find = "%d+ more line" },
              },
            },
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
    keys = {
      {
        "<a-u>",
        function()
          require("fold-cycle").open()
        end,
        desc = "Fold: cycle fold [fold-cycle.nvim]",
        mode = { "v", "n" },
      },
    },
    opts = true,
  },
  -- SMEAR-CURSOR (disabled)
  {
    "sphamba/smear-cursor.nvim", -- disabled karena slow
    event = "LazyFile",
    enabled = false,
    cond = vim.g.neovide == nil and (os.getenv "TERMINAL" ~= "kitty"),
    opts = {},
  },
  -- BLOCK.NVIM
  {
    "HampusHauffman/block.nvim",
    cmd = { "BlockOn", "BlockOff", "Block" },
    keys = {
      {
        "<Leader>ub",
        function()
          vim.cmd [[Block]]
        end,
        desc = "Toggle: block color [block]",
      },
    },
    opts = {},
  },
  -- BEACON
  {
    "rainbowhxch/beacon.nvim", -- (alternative smear-cursor)
    event = "LazyFile",
    cond = vim.g.neovide == nil and (os.getenv "TERMINAL" ~= "kitty"),
    opts = function()
      local Highlight = require "r.settings.highlights"
      Highlight.plugin(
        "beaconHiC",
        { theme = { ["*"] = { { ["BeaconDefault"] = { bg = { from = "Cursor", attr = "bg" } } } } } }
      )
      return {
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
    event = "BufReadPost",
  },
  -- TABBY
  {
    "nanozuki/tabby.nvim",
    event = "BufReadPost",
    config = function()
      local function get_hl_as_hex(opts, ns)
        ns, opts = ns or 0, opts or {}
        opts.link = opts.link ~= nil and opts.link or false
        local hl = vim.api.nvim_get_hl(ns, opts)
        hl.fg = hl.fg and ("#%06x"):format(hl.fg)
        hl.bg = hl.bg and ("#%06x"):format(hl.bg)
        return hl
      end

      local function h(name)
        return get_hl_as_hex { name = name }
      end

      local theme = {
        fill = "Normal", -- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
        head = "Normal",
        separator = "Normal",
        current_tab = { fg = h("Keyword").fg, bg = h("TabLine").bg },
        tab = { fg = h("TabLine").fg, bg = h("TabLine").bg },
        win = { fg = h("TabLine").fg, bg = h("TabLine").bg },
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
            -- line.spacer(),
            -- line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
            --   return {
            --     line.sep("", theme.win, theme.separator),
            --     win.is_current() and "" or "",
            --     win.buf_name(),
            --     line.sep("", theme.win, theme.separator),
            --     hl = theme.win,
            --     margin = " ",
            --   }
            -- end),
            -- {
            --   line.sep("", theme.tail, theme.fill),
            --   { "  ", hl = theme.tail },
            -- },
            hl = theme.fill,
          }
        end,
      }
    end,
  },
}
