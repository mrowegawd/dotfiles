return {
  -- STICKYBUF.NVIM (disbaled)
  {
    "stevearc/stickybuf.nvim",
    event = "VeryLazy",
    config = function()
      require("stickybuf").setup()
    end,
  },
  -- WINDOWS NVIM (disabled)
  {
    "anuvyklack/windows.nvim",
    enabled = false,
    cmd = { "WindowsToggleAutowidth", "WindowsMaximize" },
    dependencies = { "anuvyklack/middleclass" },
    config = function()
      require("windows").setup()
    end,
  },
  -- TMUX.NVIM
  {
    "aserowy/tmux.nvim",
    keys = {
      {
        "<a-k>",
        "<cmd>lua require('tmux').move_top()<CR>",
        desc = "Tmux: Move up",
      },
      {
        "<a-j>",
        "<cmd>lua require('tmux').move_bottom()<CR>",
        desc = "Tmux: Move down",
      },
      {
        "<a-h>",
        "<cmd>lua require('tmux').move_left()<CR>",
        desc = "Tmux: Move left",
      },
      {
        "<a-l>",
        "<cmd>lua require('tmux').move_right()<CR>",
        desc = "Tmux: Move right",
      },

      -- RESIZE
      {
        "<a-K>",
        function()
          return require("tmux").resize_top()
        end,
        desc = "Windows(tmux): resize window up",
      },
      {
        "<a-J>",
        function()
          return require("tmux").resize_bottom()
        end,
        desc = "Windows(tmux): resize window down",
      },

      {
        "<a-H>",
        function()
          return require("tmux").resize_left()
        end,
        desc = "Windows(tmux): resize window left",
      },
      {
        "<a-L>",
        function()
          return require("tmux").resize_right()
        end,
        desc = "Windows(tmux): resize window right",
      },
    },
    config = function(_, opts)
      require("tmux").setup(opts)
    end,
    opts = {
      -- copy_sync = {
      -- enables copy sync. by default, all registers are synchronized.
      -- to control which registers are synced, see the `sync_*` options.
      --   enable = false,
      -- },
      navigation = {
        -- cycles to opposite pane while navigating into the border
        -- cycle_navigation = false,
        -- enables default keybindings (C-hjkl) for normal mode
        enable_default_keybindings = false,
        -- prevents unzoom tmux when navigating beyond vim border
        persist_zoom = true,
      },
      resize = {
        -- enables default keybindings (A-hjkl) for normal mode
        enable_default_keybindings = false,
        -- sets resize steps for x axis
        resize_step_x = 4,

        -- sets resize steps for y axis
        resize_step_y = 4,
      },
    },
  },
  -- SMART-SPLITS (disabled)
  {
    "mrjones2014/smart-splits.nvim",
    enabled = false,
    keys = {
      {
        "<a-k>",
        function()
          return require("smart-splits").move_cursor_up()
        end,
        desc = "Navigations(smart-splits): move up",
      },
      {
        "<a-j>",
        function()
          return require("smart-splits").move_cursor_down()
        end,
        desc = "Navigations(smart-splits): move down",
      },
      {
        "<a-h>",
        function()
          return require("smart-splits").move_cursor_left()
        end,
        desc = "Navigations(smart-splits): move left",
      },
      {
        "<a-l>",
        function()
          return require("smart-splits").move_cursor_right()
        end,
        desc = "Navigations(smart-splits): move right",
      },

      -- RESIZE
      {
        "<a-K>",
        function()
          return require("smart-splits").resize_up()
        end,
        desc = "Windows(smart-splits): resize window up",
      },
      {
        "<a-J>",
        function()
          return require("smart-splits").resize_down()
        end,
        desc = "Windows(smart-splits): resize window down",
      },

      {
        "<a-H>",
        function()
          return require("smart-splits").resize_left()
        end,
        desc = "Windows(smart-splits): resize window left",
      },
      {
        "<a-L>",
        function()
          return require("smart-splits").resize_right()
        end,
        desc = "Windows(smart-splits): resize window right",
      },
    },
    opts = {
      -- Ignored filetypes (only while resizing)
      ignored_filetypes = {
        "nofile",
        "quickfix",
        "prompt",
      },
      -- Ignored buffer types (only while resizing)
      ignored_buftypes = { "NvimTree" },
      -- the default number of lines/columns to resize by at a time
      default_amount = 6,
      -- Desired behavior when your cursor is at an edge and you
      -- are moving towards that same edge:
      -- 'wrap' => Wrap to opposite side
      -- 'split' => Create a new split in the desired direction
      -- 'stop' => Do nothing
      -- NOTE: `at_edge = 'wrap'` is not supported on Kitty terminal
      -- multiplexer, as there is no way to determine layout via the CLI
      at_edge = "wrap",
      -- when moving cursor between splits left or right,
      -- place the cursor on the same row of the *screen*
      -- regardless of line numbers. False by default.
      -- Can be overridden via function parameter, see Usage.
      move_cursor_same_row = false,
      -- whether the cursor should follow the buffer when swapping
      -- buffers by default; it can also be controlled by passing
      -- `{ move_cursor = true }` or `{ move_cursor = false }`
      -- when calling the Lua function.
      cursor_follows_swapped_bufs = false,
      -- resize mode options
      resize_mode = {
        -- key to exit persistent resize mode
        quit_key = "<ESC>",
        -- keys to use for moving in resize mode
        -- in order of left, down, up' right
        resize_keys = { "h", "j", "k", "l" },
        -- set to true to silence the notifications
        -- when entering/exiting persistent resize mode
        silent = false,
        -- must be functions, they will be executed when
        -- entering or exiting the resize mode
        hooks = {
          on_enter = nil,
          on_leave = nil,
        },
      },
      -- ignore these autocmd events (via :h eventignore) while processing
      -- smart-splits.nvim computations, which involve visiting different
      -- buffers and windows. These events will be ignored during processing,
      -- and un-ignored on completed. This only applies to resize events,
      -- not cursor movement events.
      ignored_events = {
        "BufEnter",
        "WinEnter",
      },
      -- enable or disable a multiplexer integration;
      -- automatically determined, unless explicitly disabled or set,
      -- by checking the $TERM_PROGRAM environment variable,
      -- and the $KITTY_LISTEN_ON environment variable for Kitty
      multiplexer_integration = "tmux",
      -- disable multiplexer navigation if current multiplexer pane is zoomed
      -- this functionality is only supported on tmux and Wezterm due to kitty
      -- not having a way to check if a pane is zoomed
      disable_multiplexer_nav_when_zoomed = true,
      -- Supply a Kitty remote control password if needed,
      -- or you can also set vim.g.smart_splits_kitty_password
      -- see https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.remote_control_password
      kitty_password = nil,
    },
  },
}
