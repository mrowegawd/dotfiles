------@param is_left? boolean
------@return string,boolean
---local function is_expand_win_bak(is_left)
---  is_left = is_left or false
---
---  local left_or_right = is_left and "left" or "right"
---  local resize_win = left_or_right == "right" and "+5" or "-5"
---
---  local exclude_win = RUtils.cmd.windows_is_opened { "aerial", "Outline", "neo-tree", "codecompanion" }
---  if exclude_win.found then
---    if vim.api.nvim_win_get_number(0) == 1 then
---      resize_win = left_or_right == "right" and "+5" or "-5"
---    end
---    return resize_win, true
---  end
---
---  return resize_win, false
---end

local function debug_win_pos()
  local wins = vim.api.nvim_tabpage_list_wins(0)
  local normal_wins = {}
  for _, w in ipairs(wins) do
    local cfg = vim.api.nvim_win_get_config(w)
    if cfg.relative == "" then
      normal_wins[#normal_wins + 1] = w
    end
  end

  local cur_win = vim.api.nvim_get_current_win()
  for i, w in ipairs(normal_wins) do
    local mark = w == cur_win and " <-- current" or ""
    RUtils.info(string.format("pos=%d win=%d%s", i, w, mark))
  end
end

---@param is_right? boolean
---@return string, boolean
local function is_expand_win(is_right)
  is_right = is_right or false

  local exclude_win = RUtils.cmd.windows_is_opened { "aerial", "Outline", "neo-tree", "codecompanion" }
  if not exclude_win.found then
    return nil, false
  end

  local wins = vim.api.nvim_tabpage_list_wins(0)
  local normal_wins = {}
  for _, w in ipairs(wins) do
    if vim.api.nvim_win_get_config(w).relative == "" then
      normal_wins[#normal_wins + 1] = w
    end
  end

  table.sort(normal_wins, function(a, b)
    return vim.api.nvim_win_get_position(a)[2] < vim.api.nvim_win_get_position(b)[2]
  end)

  local cur_win = vim.api.nvim_get_current_win()
  local cur_pos = nil
  for i, w in ipairs(normal_wins) do
    if w == cur_win then
      cur_pos = i
      break
    end
  end

  local total = #normal_wins
  local amount = 5

  -- Middle window: moving left boundary requires resizing the neighbor
  if cur_pos > 1 and cur_pos < total and not is_right then
    local left_win = normal_wins[cur_pos - 1]
    vim.api.nvim_set_current_win(left_win)
    vim.cmd("vertical resize -" .. amount)
    vim.api.nvim_set_current_win(cur_win)
    return nil, true -- nil = already handled
  end

  local resize_win = is_right and ("+" .. amount) or ("-" .. amount)
  return resize_win, true
end

local function get_status_stacked()
  local Stack = require "overlook.stack"
  if not Stack.empty() then
    return true
  end
  return false
end

return {
  -- STICKYBUF.NVIM
  {
    "stevearc/stickybuf.nvim",
    event = "BufReadPost",
    cmd = { "PinBuffer", "PinBuftype", "PinFiletype" },
    keys = {
      {
        "<Leader>wP",
        function()
          local pinbuf = require "stickybuf"
          if pinbuf.is_pinned() then
            vim.cmd "Unpin"
          else
            vim.cmd "PinBuffer"
          end
        end,
        desc = "Buffer: pin buffer [stickybuf.nvim]",
      },
    },
    config = function()
      require("stickybuf").setup {
        get_auto_pin = function(buf)
          if vim.bo[buf].filetype == "toggleterm" then
            return nil
          end
          if vim.tbl_contains({ "Outline", "aerial", "trouble", "octo", "codecompanion" }, vim.bo[buf].filetype) then
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
  -- SMART-SPLITS
  {
    "mrjones2014/smart-splits.nvim",
    event = "LazyFile",
    -- enabled = not vim.tbl_contains({ "wezterm" }, os.getenv "TERMINAL"),
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

        -- RESIZE WINDOW
        {
          "<a-H>",
          function()
            if get_status_stacked() then
              vim.cmd "vertical resize -8"
              return
            end

            local resize_win, is_resize = is_expand_win()
            if is_resize then
              if resize_win then
                vim.cmd("vertical resize " .. resize_win)
              end
              return
            end

            require("smart-splits").resize_left()
          end,
          desc = "Window: resize window left [smart-splits]",
        },
        {
          "<a-J>",
          function()
            if get_status_stacked() then
              vim.cmd "resize +8"
              return
            end

            require("smart-splits").resize_down()
          end,
          desc = "Window: resize window down [smart-splits]",
        },
        {
          "<a-K>",
          function()
            if get_status_stacked() then
              vim.cmd "resize -8"
              return
            end
            require("smart-splits").resize_up()
          end,
          desc = "Window: resize window up [smart-splits]",
        },
        {
          "<a-L>",
          function()
            if get_status_stacked() then
              vim.cmd "vertical resize +8"
              return
            end

            local resize_win, is_resize = is_expand_win()
            if is_resize then
              if resize_win then
                vim.cmd("vertical resize " .. resize_win)
              end
              return
            end

            require("smart-splits").resize_right()
          end,
          desc = "Window: resize window right [smart-splits]",
        },
      }
    end,
    opts = {
      ignored_filetypes = { "nofile", "quickfix", "prompt" },
      ignored_buftypes = { "NvimTree" },
      default_amount = 5,
      move_cursor_same_row = false,
      cursor_follows_swapped_bufs = false,
      disable_multiplexer_nav_when_zoomed = true,
      kitty_password = nil,
    },
    config = function(_, opts)
      require("smart-splits").setup(opts)
    end,
  },
  -- MULTIPLEXER (disabled)
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
