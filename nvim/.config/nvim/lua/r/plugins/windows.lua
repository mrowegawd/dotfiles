return {
  -- STICKYBUF.NVIM
  {
    "stevearc/stickybuf.nvim",
    event = "VeryLazy",
    cmd = { "PinBuffer", "PinBuftype", "PinFiletype" },
    opts = {},
  },
  -- SMART-SPLITS
  {
    "mrjones2014/smart-splits.nvim",
    event = "LazyFile",
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
      -- resize_mode = {
      --   -- key to exit persistent resize mode
      --   quit_key = "<ESC>",
      --   -- keys to use for moving in resize mode
      --   -- in order of left, down, up' right
      --   resize_keys = { "h", "j", "k", "l" },
      --   -- set to true to silence the notifications
      --   -- when entering/exiting persistent resize mode
      --   silent = false,
      --   -- must be functions, they will be executed when
      --   -- entering or exiting the resize mode
      --   hooks = {
      --     on_enter = nil,
      --     on_leave = nil,
      --   },
      -- },
      -- ignore these autocmd events (via :h eventignore) while processing
      -- smart-splits.nvim computations, which involve visiting different
      -- buffers and windows. These events will be ignored during processing,
      -- and un-ignored on completed. This only applies to resize events,
      -- not cursor movement events.
      -- ignored_events = {
      --   "BufEnter",
      --   "WinEnter",
      -- },
      -- enable or disable a multiplexer integration;
      -- automatically determined, unless explicitly disabled or set,
      -- by checking the $TERM_PROGRAM environment variable,
      -- and the $KITTY_LISTEN_ON environment variable for Kitty
      -- multiplexer_integration = "wezterm",
      -- disable multiplexer navigation if current multiplexer pane is zoomed
      -- this functionality is only supported on tmux and Wezterm due to kitty
      -- not having a way to check if a pane is zoomed
      disable_multiplexer_nav_when_zoomed = true,
      -- Supply a Kitty remote control password if needed,
      -- or you can also set vim.g.smart_splits_kitty_password
      -- see https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.remote_control_password
      kitty_password = nil,
    },
    config = function(_, opts)
      require("smart-splits").setup(opts)

      local TMUX = os.getenv "TMUX"
      if TMUX then
        local nav = {
          ["a-h"] = function()
            require("smart-splits").move_cursor_left()
          end,
          ["a-j"] = function()
            require("smart-splits").move_cursor_down()
          end,
          ["a-k"] = function()
            require("smart-splits").move_cursor_up()
          end,
          ["a-l"] = function()
            require("smart-splits").move_cursor_right()
          end,
          ["a-H"] = function()
            local exclude_win = RUtils.cmd.windows_is_opened { "aerial" }
            if exclude_win.found then
              return vim.cmd "vertical resize +5 "
            end
            require("smart-splits").resize_left()
          end,
          ["a-J"] = function()
            require("smart-splits").resize_down()
          end,
          ["a-K"] = function()
            require("smart-splits").resize_up()
          end,
          ["a-L"] = function()
            local exclude_win = RUtils.cmd.windows_is_opened { "aerial" }
            if exclude_win.found then
              return vim.cmd "vertical resize -5 "
            end
            require("smart-splits").resize_right()
          end,
        }
        for key, func in pairs(nav) do
          vim.keymap.set("n", "<" .. key .. ">", func)
        end
      else
        local nav = {
          ["a-h"] = "Left",
          ["a-j"] = "Down",
          ["a-k"] = "Up",
          ["a-l"] = "Right",
        }
        local nav2 = {
          ["a-H"] = "Left",
          ["a-J"] = "Down",
          ["a-K"] = "Up",
          ["a-L"] = "Right",
        }

        local navVim = {
          ["a-h"] = "h",
          ["a-j"] = "j",
          ["a-k"] = "k",
          ["a-l"] = "l",
        }

        local function detect_opened_windows()
          -- local is_resize = 2 > tbl_length(vim.fn.win_findbuf(vim.fn.bufnr "%"))

          local tbl_nc = {}
          for _, winnr in ipairs(vim.fn.range(1, vim.fn.winnr "$")) do
            if not vim.tbl_contains({ "incline" }, vim.fn.getwinvar(winnr, "&syntax")) then
              -- print(vim.fn.getwinvar(winnr, "&syntax"))
              local winbufnr = vim.fn.winbufnr(winnr)

              if winbufnr > 0 then
                local winft = vim.api.nvim_get_option_value("filetype", { buf = winbufnr })
                if not vim.tbl_contains({ "notify" }, winft) and #winft > 0 then
                  table.insert(tbl_nc, winft)
                end
              end
            end
          end

          if #tbl_nc > 1 then
            return false
          end
          return true
        end

        local function navigate(dir, is_resize)
          is_resize = is_resize or false
          return function()
            local winn = vim.api.nvim_get_current_win()

            if not is_resize then
              vim.cmd.wincmd(navVim[dir])
              -- return
            end

            local pane_dir2 = nav2[dir]
            local pane_dir = nav[dir]

            local pane = vim.env.WEZTERM_PANE
            if pane and winn == vim.api.nvim_get_current_win() then
              if not is_resize then
                vim.system({ "wezterm", "cli", "activate-pane-direction", pane_dir }, { text = true }, function(p)
                  if p.code ~= 0 then
                    vim.notify(
                      "Failed to move to pane " .. pane_dir .. "\n" .. p.stderr,
                      vim.log.levels.ERROR,
                      { title = "Wezterm" }
                    )
                  end
                end)
              end

              if is_resize then
                if detect_opened_windows() then
                  vim.system(
                    { "wezterm", "cli", "adjust-pane-size", "--amount", "5", pane_dir2 },
                    { text = true },
                    function(p)
                      if p.code ~= 0 then
                        vim.notify(
                          "Failed to resize pane " .. pane_dir2 .. "\n" .. p.stderr,
                          vim.log.levels.ERROR,
                          { title = "Wezterm" }
                        )
                      end
                    end
                  )
                else
                  local commands = string.format([[require("smart-splits").resize_%s()]], pane_dir2:lower())
                  vim.cmd(" lua " .. commands)
                end
              end
            else
              if pane_dir2 then
                local commands = string.format([[require("smart-splits").resize_%s()]], pane_dir2:lower())
                vim.cmd(" lua " .. commands)
              end
            end
          end
        end

        -- Move to window using the movement keys
        for key, _ in pairs(nav) do
          vim.keymap.set("n", "<" .. key .. ">", navigate(key))
        end

        for key, _ in pairs(nav2) do
          if key == "a-H" then
            vim.keymap.set("n", "<" .. key .. ">", function()
              local exclude_win = RUtils.cmd.windows_is_opened { "aerial" }
              if exclude_win.found then
                return vim.cmd "vertical resize +5 "
              end
              navigate(key, true)()
            end)
          elseif key == "a-L" then
            vim.keymap.set("n", "<" .. key .. ">", function()
              local exclude_win = RUtils.cmd.windows_is_opened { "aerial" }
              if exclude_win.found then
                return vim.cmd "vertical resize -5 "
              end
              navigate(key, true)()
            end)
          else
            vim.keymap.set("n", "<" .. key .. ">", navigate(key, true))
          end
        end
      end
    end,
  },
}
