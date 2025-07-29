-- local function is_pane_zoomed()
--   local result = vim.system({ "wezterm", "cli", "list", "--format", "json" }, { text = true }):wait()
--   if result.code ~= 0 then
--     vim.notify("Failed to get WezTerm pane list\n" .. result.stderr, vim.log.levels.ERROR, { title = "Wezterm" })
--     return false
--   end
--
--   local current_pane = vim.env.WEZTERM_PANE
--   local panes = vim.fn.json_decode(result.stdout)
--   for _, pane in ipairs(panes) do
--     if pane.pane_id == tonumber(current_pane) then
--       if pane.is_zoomed then
--         return true
--       end
--     end
--   end
--   return false
-- end

return {
  -- STICKYBUF.NVIM
  {
    "stevearc/stickybuf.nvim",
    event = "BufReadPost",
    cmd = { "PinBuffer", "PinBuftype", "PinFiletype" },
    keys = {
      {
        "<Leader>bp",
        function()
          local pinbuf = require "stickybuf"
          if pinbuf.is_pinned() then
            vim.cmd "Unpin"
          else
            vim.cmd "PinBuffer"
          end
        end,
        desc = "Buffer: pin buffer [stickybuf]",
      },
    },
    config = function()
      require("stickybuf").setup {
        get_auto_pin = function(buf)
          if vim.bo[buf].filetype == "toggleterm" then
            return nil
          end
          if
            vim.tbl_contains({ "Outline", "aerial", "trouble", "git", "octo", "codecompanion" }, vim.bo[buf].filetype)
          then
            return "filetype"
          end
          return require("stickybuf").should_auto_pin(buf)
        end,
      }
    end,
  },
  -- KITTY NAVIGATOR (disabled)
  {
    "MunsMan/kitty-navigator.nvim",
    enabled = false,
    -- enabled = os.getenv "TERMINAL" == "kitty",
    -- dependencies = { "mrjones2014/smart-splits.nvim" },
    keys = {
      {
        "<a-h>",
        function()
          require("kitty-navigator").navigateLeft()
        end,
        desc = "Window: move cursor left [kitty-navigator]",
      },
      {
        "<a-j>",
        function()
          require("kitty-navigator").navigateDown()
        end,
        desc = "Window: move cursor down [kitty-navigator]",
      },
      {
        "<a-k>",
        function()
          require("kitty-navigator").navigateUp()
        end,
        desc = "Window: move cursor up [kitty-navigator]",
      },
      {
        "<a-l>",
        function()
          require("kitty-navigator").navigateRight()
        end,
        desc = "Window: move cursor right [kitty-navigator]",
      },
      {
        "<a-H>",
        function()
          vim.cmd("vertical resize " .. RUtils.navigate_window.resize_plus_or_mines "left")
        end,
        desc = "Window: resize window left [kitty-navigator]",
      },
      {
        "<a-J>",
        function()
          if RUtils.navigate_window.check_split_or_vsplit "down" then
            vim.cmd("resize " .. RUtils.navigate_window.resize_plus_or_mines "down")
          end
        end,
        desc = "Window: resize window down [kitty-navigator]",
      },
      {
        "<a-K>",
        function()
          if RUtils.navigate_window.check_split_or_vsplit "down" then
            vim.cmd("resize " .. RUtils.navigate_window.resize_plus_or_mines "up")
          end
        end,
        desc = "Window: resize window up [kitty-navigator]",
      },
      {
        "<a-L>",
        function()
          vim.cmd("vertical resize " .. RUtils.navigate_window.resize_plus_or_mines "right")
        end,
        desc = "window: resize window right [kitty-navigator]",
      },
    },

    opts = {
      keybindings = {},
    },
  },
  -- SMART-SPLITS (disabled)
  {
    "mrjones2014/smart-splits.nvim",
    event = "LazyFile",
    -- enabled = false,
    -- enabled = vim.tbl_contains({ "ghostty", "wezterm" }, os.getenv "TERMINAL"),
    keys = function()
      return {
        {
          "<a-h>",
          function()
            require("smart-splits").move_cursor_left()
          end,
          desc = "Window: move cursor left [smart-splits]",
        },
        {
          "<a-j>",
          function()
            require("smart-splits").move_cursor_down()
          end,
          desc = "Window: move cursor down [smart-splits]",
        },
        {
          "<a-k>",
          function()
            require("smart-splits").move_cursor_up()
          end,
          desc = "Window: move cursor up [smart-splits]",
        },
        {
          "<a-l>",
          function()
            require("smart-splits").move_cursor_right()
          end,
          desc = "Window: move cursor right [smart-splits]",
        },
        {
          "<a-H>",
          function()
            require("smart-splits").resize_left()
            -- vim.cmd("vertical resize " .. RUtils.navigate_window.resize_plus_or_mines "left")
          end,
          desc = "Window: resize window left [smart-splits]",
        },
        {
          "<a-J>",
          function()
            require("smart-splits").resize_down()
            -- if RUtils.navigate_window.check_split_or_vsplit() then
            --   vim.cmd("resize " .. RUtils.navigate_window.resize_plus_or_mines "down")
            -- end
          end,
          desc = "Window: resize window down [smart-splits]",
        },
        {
          "<a-K>",
          function()
            require("smart-splits").resize_up()
            -- if RUtils.navigate_window.check_split_or_vsplit() then
            --   vim.cmd("resize " .. RUtils.navigate_window.resize_plus_or_mines "up")
            -- end
          end,
          desc = "Window: resize window up [smart-splits]",
        },
        {
          "<a-L>",
          function()
            require("smart-splits").resize_right()
            -- vim.cmd("vertical resize " .. RUtils.navigate_window.resize_plus_or_mines "right")
          end,
          desc = "Window: resize window right [smart-splits]",
        },
      }
    end,
    opts = {
      ignored_filetypes = { "nofile", "quickfix", "prompt" },
      ignored_buftypes = { "NvimTree" },
      default_amount = 5,
      at_edge = "wrap",
      move_cursor_same_row = false,
      cursor_follows_swapped_bufs = false,
      disable_multiplexer_nav_when_zoomed = true,
      kitty_password = nil,
    },
    config = function(_, opts)
      require("smart-splits").setup(opts)

      -- if vim.tbl_contains({ "ghostty", "wezterm", "st", "kitty" }, os.getenv "TERMINAL") then
      --   local TMUX = os.getenv "TMUX"
      --   if TMUX then
      --     local nav = {
      --       ["c-h"] = function()
      --         require("smart-splits").move_cursor_left()
      --       end,
      --       ["c-j"] = function()
      --         require("smart-splits").move_cursor_down()
      --       end,
      --       ["c-k"] = function()
      --         require("smart-splits").move_cursor_up()
      --       end,
      --       ["c-l"] = function()
      --         require("smart-splits").move_cursor_right()
      --       end,
      --       ["a-H"] = function()
      --         local exclude_win = RUtils.cmd.windows_is_opened { "aerial", "Outline" }
      --         if exclude_win.found then
      --           local resizer_h = "+5"
      --           if vim.api.nvim_win_get_number(0) == 1 then
      --             resizer_h = "-5"
      --           end
      --           return vim.cmd("vertical resize " .. resizer_h)
      --         end
      --         require("smart-splits").resize_left()
      --       end,
      --       ["a-J"] = function()
      --         require("smart-splits").resize_down()
      --       end,
      --       ["a-K"] = function()
      --         require("smart-splits").resize_up()
      --       end,
      --       ["a-L"] = function()
      --         local exclude_win = RUtils.cmd.windows_is_opened { "aerial", "Outline" }
      --         if exclude_win.found then
      --           local resizer_l = "-5"
      --           if vim.api.nvim_win_get_number(0) == 1 then
      --             resizer_l = "+5"
      --           end
      --           return vim.cmd("vertical resize " .. resizer_l)
      --         end
      --         require("smart-splits").resize_right()
      --       end,
      --     }
      --     for key, func in pairs(nav) do
      --       vim.keymap.set("n", "<" .. key .. ">", func)
      --     end
      --   else
      --     local nav = {
      --       ["c-h"] = "Left",
      --       ["c-j"] = "Down",
      --       ["c-k"] = "Up",
      --       ["c-l"] = "Right",
      --     }
      --     local nav2 = {
      --       ["a-H"] = "Left",
      --       ["a-J"] = "Down",
      --       ["a-K"] = "Up",
      --       ["a-L"] = "Right",
      --     }
      --
      --     local navVim = {
      --       ["c-h"] = "h",
      --       ["c-j"] = "j",
      --       ["c-k"] = "k",
      --       ["c-l"] = "l",
      --     }
      --
      --     local function detect_opened_windows()
      --       -- local is_resize = 2 > tbl_length(vim.fn.win_findbuf(vim.fn.bufnr "%"))
      --
      --       local tbl_nc = {}
      --       for _, winnr in ipairs(vim.fn.range(1, vim.fn.winnr "$")) do
      --         if not vim.tbl_contains({ "incline" }, vim.fn.getwinvar(winnr, "&syntax")) then
      --           -- print(vim.fn.getwinvar(winnr, "&syntax"))
      --           local winbufnr = vim.fn.winbufnr(winnr)
      --
      --           if winbufnr > 0 then
      --             local winft = vim.api.nvim_get_option_value("filetype", { buf = winbufnr })
      --             if not vim.tbl_contains({ "notify" }, winft) and #winft > 0 then
      --               table.insert(tbl_nc, winft)
      --             end
      --           end
      --         end
      --       end
      --
      --       if #tbl_nc > 1 then
      --         return false
      --       end
      --       return true
      --     end
      --
      --     local function navigate(dir, is_resize)
      --       is_resize = is_resize or false
      --       return function()
      --         local winn = vim.api.nvim_get_current_win()
      --
      --         if not is_resize then
      --           vim.cmd.wincmd(navVim[dir])
      --         end
      --
      --         local pane_dir2 = nav2[dir]
      --         local pane_dir = nav[dir]
      --
      --         local pane = vim.env.WEZTERM_PANE
      --         if pane and winn == vim.api.nvim_get_current_win() then
      --           if not is_resize and not is_pane_zoomed() then
      --             vim.system({ "wezterm", "cli", "activate-pane-direction", pane_dir }, { text = true }, function(p)
      --               if p.code ~= 0 then
      --                 vim.notify(
      --                   "Failed to move to pane " .. pane_dir .. "\n" .. p.stderr,
      --                   vim.log.levels.ERROR,
      --                   { title = "Wezterm" }
      --                 )
      --               end
      --             end)
      --           end
      --
      --           if is_resize then
      --             if detect_opened_windows() then
      --               vim.system(
      --                 { "wezterm", "cli", "adjust-pane-size", "--amount", "5", pane_dir2 },
      --                 { text = true },
      --                 function(p)
      --                   if p.code ~= 0 then
      --                     vim.notify(
      --                       "Failed to resize pane " .. pane_dir2 .. "\n" .. p.stderr,
      --                       vim.log.levels.ERROR,
      --                       { title = "Wezterm" }
      --                     )
      --                   end
      --                 end
      --               )
      --             else
      --               local commands = string.format([[require("smart-splits").resize_%s()]], pane_dir2:lower())
      --               vim.cmd(" lua " .. commands)
      --             end
      --           end
      --         else
      --           if pane_dir2 then
      --             local commands = string.format([[require("smart-splits").resize_%s()]], pane_dir2:lower())
      --             vim.cmd(" lua " .. commands)
      --           end
      --         end
      --       end
      --     end
      --
      --     -- Move to window using the movement keys
      --     for key, _ in pairs(nav) do
      --       vim.keymap.set("n", "<" .. key .. ">", navigate(key))
      --     end
      --
      --     for key, _ in pairs(nav2) do
      --       if key == "a-H" then
      --         vim.keymap.set("n", "<" .. key .. ">", function()
      --           local exclude_win = RUtils.cmd.windows_is_opened { "aerial", "terminal" }
      --           if exclude_win.found then
      --             return vim.cmd "vertical resize +5 "
      --           end
      --           navigate(key, true)()
      --         end)
      --       elseif key == "a-L" then
      --         vim.keymap.set("n", "<" .. key .. ">", function()
      --           local exclude_win = RUtils.cmd.windows_is_opened { "aerial", "terminal" }
      --           if exclude_win.found then
      --             return vim.cmd "vertical resize -5 "
      --           end
      --           navigate(key, true)()
      --         end)
      --       else
      --         vim.keymap.set("n", "<" .. key .. ">", navigate(key, true))
      --       end
      --     end
      --   end
      -- end
    end,
  },
  -- MULTIPLEXER (false)
  {
    "stevalkr/multiplexer.nvim",
    enabled = false,
    keys = {
      {
        "<a-h>",
        function()
          require("multiplexer").activate_pane_left()
        end,
        desc = "Window: move cursor left [multiplexer]",
      },
      {
        "<a-j>",
        function()
          require("multiplexer").activate_pane_down()
        end,
        desc = "Window: move cursor down [multiplexer]",
      },
      {
        "<a-k>",
        function()
          require("multiplexer").activate_pane_up()
        end,
        desc = "Window: move cursor up [multiplexer]",
      },
      {
        "<a-l>",
        function()
          require("multiplexer").activate_pane_right()
        end,
        desc = "Window: move cursor right [multiplexer]",
      },
      {
        "<a-H>",
        function()
          require("multiplexer").resize_pane_left(4, {})
        end,
        desc = "Window: resize window left [multiplexer]",
      },
      {
        "<a-J>",
        function()
          require("multiplexer").resize_pane_down(4, {})
        end,
        desc = "Window: resize window down [multiplexer]",
      },
      {
        "<a-K>",
        function()
          require("multiplexer").resize_pane_up(4, {})
        end,
        desc = "Window: resize window up [multiplexer]",
      },
      {
        "<a-L>",
        function()
          require("multiplexer").resize_pane_right(4, {})
        end,
        desc = "Window: resize window right [multiplexer]",
      },
    },
    opts = {},
  },
}
