local Highlight = require "r.settings.highlights"

return {
  -- SNACKS
  {
    "snacks.nvim",
    optional = true,
    opts = function()
      Highlight.plugin("Snacks_highlights", {
        {
          SnacksNotifierInfo = {
            fg = { from = "DiagnosticInfo", attr = "fg", alter = 5 },
            bg = { from = "DiagnosticInfo", attr = "fg", alter = -0.7 },
            bold = true,
          },
        },
        {
          SnacksNotifierBorderInfo = {
            fg = { from = "SnacksNotifierInfo", attr = "bg", alter = 0.5 },
            bg = { from = "SnacksNotifierInfo", attr = "bg" },
          },
        },
        {
          SnacksNotifierTitleInfo = {
            fg = { from = "DiagnosticInfo", attr = "fg", alter = 0.5 },
            bg = { from = "DiagnosticInfo", attr = "fg", alter = -0.7 },
            bold = true,
          },
        },

        -- ERROR
        {
          SnacksNotifierError = {
            fg = { from = "DiagnosticError", attr = "fg", alter = 5 },
            bg = { from = "DiagnosticError", attr = "fg", alter = -0.7 },
            bold = true,
          },
        },
        {
          SnacksNotifierBorderError = {
            fg = { from = "SnacksNotifierError", attr = "bg", alter = 0.5 },
            bg = { from = "SnacksNotifierError", attr = "bg" },
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
            fg = { from = "DiagnosticWarn", attr = "fg", alter = 5 },
            bg = { from = "DiagnosticWarn", attr = "fg", alter = -0.7 },
            bold = true,
          },
        },
        {
          SnacksNotifierBorderWarn = {
            fg = { from = "SnacksNotifierWarn", attr = "bg", alter = 0.5 },
            bg = { from = "SnacksNotifierWarn", attr = "bg" },
          },
        },
        {
          SnacksNotifierTitleWarn = {
            fg = { from = "DiagnosticWarn", attr = "fg", alter = 0.5 },
            bg = { from = "DiagnosticWarn", attr = "fg", alter = -0.7 },
            bold = true,
          },
        },

        { SnacksNotifierHistory = { inherit = "NormalFloat" } },
      })

      return {
        bigfile = { enabled = true },
        notifier = { enabled = true },
        quickfile = { enabled = true },
        -- picker = {}, NOTE: jika di enable, vim.input akan terdampak behaviour nya (orgagenda juga berpengaruh)
        -- scroll = { enabled = false },
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
            [241] = { fg = "LineNr" },
            background = { fg = "Function" },
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
      ---@diagnostic disable-next-line: missing-fields
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
}
