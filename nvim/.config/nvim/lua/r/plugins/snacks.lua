local img_from_terminal = true
local set_number = 0 -- 0 means random number; 1–9 are fixed numbers

local function set_img_dashboard()
  local nvim_dashboard_path = vim.fs.joinpath(vim.env.HOME, "/moxconf/development/dotfiles/img/nvim-dashboard")

  local is_img = function()
    if RUtils.file.is_dir(nvim_dashboard_path) and img_from_terminal then
      return true
    end
    return false
  end

  local is_image = is_img()
  local fn_img = RUtils.logo.setup(is_image, set_number)

  local align = vim.fn.winwidth(0) > 150 and "right" or "center"

  local height = align == "center" and 20 or 25

  if is_image then
    return {
      pane = 1,
      section = "terminal",
      height = height, -- 29
      cmd = [[img2art ]]
        .. nvim_dashboard_path -- use image with size 500x500
        .. "/"
        .. fn_img
        .. " "
        .. [[--threshold 80 --scale 0.20 --with-color --alpha]],
      -- align = align,
      align = "center",
      -- padding = 8,
    }
  end

  return {
    pane = 1,
    header = fn_img,
    height = 100,
    padding = 10,
    indent = 30,
    align = align,
  }
end

-- local function section_footer()
--   -- local _indent = function()
--   --   local win_width = vim.fn.winwidth(0)
--   --   -- RUtils.info(win_width)
--   --   if win_width >= 160 then
--   --     return 60
--   --   elseif win_width <= 140 then
--   --     return 20
--   --   end
--   --   return 0
--   -- end
--   --
--   -- local indent = _indent()
--   -- RUtils.info(indent)
--
--   return {
--     section = "startup",
--     align = "left",
--     -- indent = indent,
--   }
-- end

return {
  -- SNACKS
  {
    "snacks.nvim",
    optional = true,
    opts = {
      bigfile = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = false },
      scroll = { enabled = true },
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
        --   -- dashboard = {
        --   --   wo = {
        --   --     winhighlight = "Normal:NormalFloat,NormalFloat:NormalFloat",
        --   --     wrap = false,
        --   --   },
        --   -- },
        --   notifier = {
        --     wo = {
        --       winhighlight = "Normal:NormalFloat,NormalFloat:NormalFloat",
        --       wrap = false,
        --     },
        --   },
        notification = {
          wo = {
            winhighlight = "Normal:NormalFloat,NormalFloat:NormalFloat",
          },
        },
        notification_history = {
          wo = {
            winhighlight = "Normal:NormalFloat",
          },
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
              key = "<space>",
              desc = "Find File",
              action = function()
                require("fzf-lua").files()
              end,
            },
            { icon = " ", hidden = true, key = "n", desc = "New File", action = ":ene | startinsert" },
            {
              icon = " ",
              key = "r",
              desc = "Recent Files",
              action = function()
                require("fzf-lua").oldfiles()
              end,
            },
            {
              icon = " ",
              key = "s",
              desc = "Select Session",
              action = function()
                require("r.utils.sessions").load_session_from_dashboard()
              end,
            },
            {
              icon = " ",
              key = "l",
              desc = "Restore Last Session",
              action = function()
                require("r.utils.sessions").load_session_from_dashboard(true)
              end,
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
            enabled = function()
              return (vim.fn.winheight(0) < 25)
            end,
            { section = "header" },
          },
          {
            enabled = function()
              return (vim.fn.winheight(0) >= 25)
            end,
            {
              pane = 1,
              align = "right",
              {
                set_img_dashboard(),
              },
              {
                title = "",
                padding = (vim.fn.isdirectory ".git" ~= 1 and (vim.fn.winwidth(0) > 150)) and 5 or 1,
              },
              {
                section = "keys",
                padding = 1,
                align = "left",
              },
              {
                title = " RECENT FILES",
                section = "recent_files",
                limit = 5,
                padding = 1,
                hl = "Normal",
                align = "left",
              },
              {
                enabled = (vim.fn.winwidth(0) > 150),
                {

                  section = "terminal",
                  icon = " ",
                  title = "GIT STATUS",
                  enabled = vim.fn.isdirectory ".git" == 1,
                  cmd = "git status --short --branch --renames",
                  height = 6,
                  padding = 1,
                  indent = 1,
                },
              },
              {

                enabled = (vim.fn.winwidth(0) > 130),
                {
                  section = "startup",
                  align = "left",
                },
              },
            },
          },
        },
      },
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
