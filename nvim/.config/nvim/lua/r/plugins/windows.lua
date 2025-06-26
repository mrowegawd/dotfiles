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
    -- enabled = os.getenv "TERMINAL" == "kitty",
    enabled = false,
    dependencies = { "mrjones2014/smart-splits.nvim" },
    keys = {
      {
        "<C-h>",
        function()
          require("kitty-navigator").navigateLeft()
        end,
        desc = "Kitty-navigator: move right a split",
      },
      {
        "<C-j>",
        function()
          require("kitty-navigator").navigateDown()
        end,
        desc = "Kitty-navigator: move down a split",
      },
      {
        "<C-k>",
        function()
          require("kitty-navigator").navigateUp()
        end,
        desc = "Kitty-navigator: move up a split",
      },
      {
        "<C-l>",
        function()
          require("kitty-navigator").navigateRight()
        end,
        desc = "Kitty-navigator: move left a split",
      },
      {
        "<a-H>",
        function()
          local exclude_win = RUtils.cmd.windows_is_opened { "aerial", "Outline" }
          if exclude_win.found then
            local resizer_h = "+5"
            if vim.api.nvim_win_get_number(0) == 1 then
              resizer_h = "-5"
            end
            return vim.cmd("vertical resize " .. resizer_h)
          end
          require("smart-splits").resize_left()
        end,
        desc = "Kitty-navigator: resize right",
      },
      {
        "<a-L>",
        function()
          local exclude_win = RUtils.cmd.windows_is_opened { "aerial", "Outline" }
          if exclude_win.found then
            local resizer_l = "-5"
            if vim.api.nvim_win_get_number(0) == 1 then
              resizer_l = "+5"
            end
            return vim.cmd("vertical resize " .. resizer_l)
          end
          require("smart-splits").resize_right()
        end,
        desc = "Kitty-navigator: resize left",
      },
      {
        "<a-K>",
        function()
          require("smart-splits").resize_up()
        end,
        desc = "Kitty-navigator: resize up",
      },
      {
        "<a-J>",
        function()
          require("smart-splits").resize_down()
        end,
        desc = "Kitty-navigator: resize down",
      },
    },

    opts = {
      keybindings = {},
    },
  },
  -- SMART-SPLITS
  {
    "mrjones2014/smart-splits.nvim",
    event = "LazyFile",
    -- enabled = vim.tbl_contains({ "ghostty", "wezterm" }, os.getenv "TERMINAL"),
    keys = function()
      local resize_plus_or_mines = function(position)
        local win_position = require("smart-splits.api").win_position(position)
        local winid = vim.api.nvim_get_current_win()
        local curwinnr = vim.api.nvim_win_get_number(0)
        local ft_exclude = { "aerial", "Outline", "neo-tree" }
        local size = 7

        local function get_direction(minus_or_plus, posisi)
          if not posisi then
            return minus_or_plus
          end

          local exclude_win = RUtils.cmd.windows_is_opened(ft_exclude)
          local windows = vim.api.nvim_list_wins()
          if curwinnr > 1 then
            for _, win in ipairs(windows) do
              local config = vim.api.nvim_win_get_config(win)
              if win == winid then
                if config.split == "left" or config.split == "right" then
                  if
                    (config.split == "left" and posisi == "right") or (config.split == "right" and posisi == "left")
                  then
                    minus_or_plus = (win_position > 0) and "+" or "-"
                    if exclude_win.found and not (vim.tbl_contains(ft_exclude, vim.bo[0].filetype)) then
                      minus_or_plus = "-"
                    end
                  else
                    minus_or_plus = (win_position > 0) and "-" or "+"
                    if exclude_win.found and not (vim.tbl_contains(ft_exclude, vim.bo[0].filetype)) then
                      minus_or_plus = "+"
                    end
                  end
                end
              end
            end
          end
          return minus_or_plus
        end

        local minus_or_plus
        if position == "up" or position == "left" then
          minus_or_plus = (win_position > 0) and "+" or "-"
        elseif position == "down" or position == "right" then
          minus_or_plus = (win_position > 0) and "-" or "+"
        end

        if curwinnr > 1 then
          minus_or_plus = get_direction(minus_or_plus, position)
        end

        return minus_or_plus .. size
      end

      local check_split_or_vsplit = function()
        local bufnr = vim.api.nvim_get_current_buf()
        local winid = vim.api.nvim_get_current_win()
        if vim.bo[bufnr].filetype == "noice" then
          return true
        end

        local windows = vim.api.nvim_list_wins()
        for _, win in ipairs(windows) do
          local config = vim.api.nvim_win_get_config(win)
          if win == winid then
            if config.split == "below" then
              return true
            end
          end
        end

        return false
      end

      return {
        {
          "<C-h>",
          function()
            require("smart-splits").move_cursor_left()
          end,
          desc = "window: move cursor left [smart-splits]",
        },
        {
          "<C-j>",
          function()
            require("smart-splits").move_cursor_down()
          end,
          desc = "window: move cursor down [smart-splits]",
        },
        {
          "<C-k>",
          function()
            require("smart-splits").move_cursor_up()
          end,
          desc = "window: move cursor up [smart-splits]",
        },
        {
          "<C-l>",
          function()
            require("smart-splits").move_cursor_right()
          end,
          desc = "window: move cursor right [smart-splits]",
        },

        {
          "<a-H>",
          function()
            vim.cmd("vertical resize " .. resize_plus_or_mines "left")
          end,
          desc = "window: resize window left [smart-splits]",
        },
        {
          "<a-J>",
          function()
            if check_split_or_vsplit() then
              vim.cmd("resize " .. resize_plus_or_mines "down")
            end
          end,
          desc = "window: resize window down [smart-splits]",
        },
        {
          "<a-K>",
          function()
            if check_split_or_vsplit() then
              vim.cmd("resize " .. resize_plus_or_mines "up")
            end
          end,
          desc = "window: resize window up [smart-splits]",
        },
        {
          "<a-L>",
          function()
            vim.cmd("vertical resize " .. resize_plus_or_mines "right")
          end,
          desc = "window: resize window right [smart-splits]",
        },
      }
    end,
    opts = {
      ignored_filetypes = { "nofile", "quickfix", "prompt" },
      ignored_buftypes = { "NvimTree" },
      default_amount = 6,
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
}
