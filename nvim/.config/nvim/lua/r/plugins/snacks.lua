local function set_img_dashboard()
  local nvim_dashboard_path = vim.fs.joinpath(vim.env.HOME, "/moxconf/development/dotfiles/img/nvim-dashboard")
  local is_img = RUtils.file.is_dir(nvim_dashboard_path) and true or false

  ---@diagnostic disable-next-line: undefined-field
  local fn_img = RUtils.logo(is_img)
  return [[img2art ]]
    .. nvim_dashboard_path
    .. "/"
    .. fn_img
    .. " "
    .. [[--threshold 80 --scale 0.20 --with-color --alpha --with-color]]
end

return {
  -- SNACKS
  {
    "snacks.nvim",
    optional = true,
    opts = {
      bigfile = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scroll = { enabled = false },
      input = {
        -- https://github.com/folke/snacks.nvim/blob/bc0630e43be5699bb94dadc302c0d21615421d93/lua/snacks/input.lua#L53
        enabled = true,
        icon = " ",
        win = { style = { row = -20 } },
      },
      indent = {
        enabled = true,
        char = "▏", --  │, ┊, │, ▏, ┆, ┊, , ┊, "│"
        -- char = "", --  │, ┊, │, ▏, ┆, ┊, , ┊, "│"
        only_scope = false,
        indent = { enabled = false },
        only_current = false,
        scope = { enabled = false },
        chunk = {
          enabled = true,
          hl = "SnacksIndentScope",
          char = {
            horizontal = "─", -- the icon is taken from hlchunks.nvim
            vertical = "│",
            corner_top = "╭",
            corner_bottom = "╰",
            arrow = ">",
          },
        },
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
        -- https://github.com/folke/snacks.nvim/issues/1214#issuecomment-2661464801
        filter = function(buf)
          local bufname = vim.fn.bufname(vim.api.nvim_get_current_buf())
          if
            (bufname and bufname:match "diffview://")
            or vim.t.diffview_view_initialized
            or (vim.bo[buf].filetype == "snacks_picker_preview")
            or vim.tbl_contains({ "markdown" }, vim.bo.filetype)
          then
            return false
          end
          return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and vim.bo[buf].buftype == ""
        end,
      },
      lazygit = {
        theme_path = os.getenv "HOME" .. "/.config/lazygit/theme/fla.yml",
        theme = {
          [241] = { fg = "LineNr" },
          background = { fg = "Function", bg = "Normal" },
          activeBorderColor = { fg = "Keyword", bold = true },
          cherryPickedCommitBgColor = { fg = "Identifier" },
          cherryPickedCommitFgColor = { fg = "Function" },
          defaultFgColor = { fg = "Normal" },
          optionsTextColor = { fg = "Function" },
          searchingActiveBorderColor = { fg = "MatchParen", bold = true },
          selectedLineBgColor = { bg = "LazygitselectedLineBgColor" }, -- set to `default` to have no background colour
          inactiveBorderColor = { fg = "InactiveBorderColorLazy" },
          unstagedChangesColor = { fg = "DiagnosticError" },
        },
      },
      words = { enabled = false },
      styles = {
        snacks_image = {
          relative = "editor",
          col = -1,
        },
      },
      image = {
        enabled = true,
        doc = { inline = false, float = true, max_width = 80, max_height = 60 },
      },
      dashboard = {
        pane_gap = 5, -- empty columns between vertical panes
        row = nil,
        preset = {
          keys = {
            {
              icon = " ",
              key = "f",
              desc = "Find File",
              action = ':lua require("fzf-lua").files()',
            },
            { icon = " ", hidden = true, key = "n", desc = "New File", action = ":ene | startinsert" },
            {
              icon = " ",
              key = "r",
              desc = "Recent Files",
              action = ':lua require("fzf-lua").oldfiles()',
            },
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
            { icon = "󰒲 ", key = "y", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        formats = {
          -- key = function(item)
          --   if item.autokey then
          --     return { "" }
          --   end
          --   -- return { "" }
          --   -- print(vim.inspect(item))
          --   return {
          --     { item.key, hl = "Keyword" },
          --     { " " },
          --     -- { item.desc, hl = "NonText" },
          --     -- { item.file },
          --   }
          -- end,
          key = { "" },
          -- file = function(item)
          --   return {
          --     { item.key, hl = "Keyword" },
          --     { " " },
          --     { item.file:sub(2):match "^(.*[/])", hl = "NonText" },
          --     { item.file:match "([^/]+)$", hl = "Normal" },
          --   }
          --
          -- end,

          file = function(item, ctx)
            -- local fname = vim.fn.fnamemodify(item.file, ":~")
            local fname = vim.fn.fnamemodify(item.file, ":.")
            fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
            if #fname > ctx.width then
              local dir = vim.fn.fnamemodify(fname, ":h")
              local file = vim.fn.fnamemodify(fname, ":t")
              if dir and file then
                file = file:sub(-(ctx.width - #dir - 2))
                fname = dir .. "/…" .. file
              end
            end
            local dir, file = fname:match "^(.*)/(.+)$"
            return dir and { { item.key, hl = "Keyword" }, { " " }, { dir .. "/", hl = "dir" }, { file, hl = "file" } }
              or { { fname, hl = "file" } }
          end,
          icon = { "" },
        },
        sections = {
          {
            {
              -- { section = "header", align = "center" },
              pane = 1,
              section = "terminal",
              cmd = set_img_dashboard(),
              height = 28,
              align = "center",
            },
          },
          {
            pane = 2,
            {
              { title = "", padding = 1 },
              { section = "keys", gap = 0, padding = 2, align = "left" },
              {
                icon = " ",
                title = "RECENT FILES",
                section = "recent_files",
                limit = 5,
                padding = 2,
                hl = "Normal",
              },
              {
                section = "terminal",
                icon = " ",
                title = "GIT STATUS",
                enabled = vim.fn.isdirectory ".git" == 1,
                cmd = "hub diff --stat -B -M -C",
                -- cmd = "git status --short --branch --renames",
                height = 8,
              },
            },
          },
          { section = "startup", align = "center", indent = 60 },
        },
      },
    },
    -- stylua: ignore
    keys = {
      -- { "<Localleader>s.", function() Snacks.scratch() end, desc = "Snacks: toggle scratch buffer" },
      { "<Leader>jd", function() Snacks.scope.jump({bottom= true}) end, desc = "JumpTo: scope above [snacks]" },
      { "<Leader>ju", function() Snacks.scope.jump({bottom= false}) end, desc = "JumpTo: scope bottom [snacks]" },
      -- { "<Localleader>sS", function() Snacks.scratch.select() end, desc = "Snacks: select scratch buffer" },
      -- { "<Localleader>sps", function() Snacks.profiler.scratch() end, desc = "Snacks: profiler scratch buffer" },
      -- { "gs", function() Snacks.picker.lsp_symbols() end, desc = "Snacks: profiler scratch buffer" },
      { "gK", function() Snacks.image.hover() end, desc = "Snackspicker: hover image" },

      -- { "<Localleader>nh", function() Snacks.notifier.show_history() end, desc = "Snackspicker: notification history" },
      { "<Localleader>nd", function() Snacks.notifier.hide() end, desc = "Notification: dismiss all notifications [snacks]" },
      { "<Localleader>nF", function() Snacks.picker.notifications() end, desc = "Notification: show notification [snacks]" },
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
