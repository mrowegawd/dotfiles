return {
  -- FFF.NVIM (disabled)
  {
    "dmtrKovalenko/fff.nvim",
    enabled = false,
    build = function()
      require("fff.download").download_or_build_binary()
    end,
    keys = {
      {
        "<Leader>ff", -- try it if you didn't it is a banger keybinding for a picker
        function()
          require("fff").find_files()
        end,
        desc = "picker: find files [fff.nvim]",
      },
      {
        "<Leader>fv", -- try it if you didn't it is a banger keybinding for a picker
        function()
          require("fff").live_grep()
        end,
        desc = "picker: live grep [fff.nvim]",
      },
    },
    opts = {
      layout = {
        height = 0.8,
        width = 0.9,
        prompt_position = "top", -- or 'top'
        preview_position = "right", -- or 'left', 'right', 'top', 'bottom'
        preview_size = 0.5,
        -- flex = { -- set to nil to disable flex layout
        --   size = 130, -- column threshold: if screen width >= size, use preview_position; otherwise use wrap
        --   wrap = "top", -- position to use when screen is narrower than size
        -- },
        flex = nil,
        -- Minimum list height required to render the preview. When the available
        -- list area would drop below this on small terminals, the preview is
        -- auto-hidden so the file list stays usable. Set to 0 to disable.
        min_list_height = 10,
        show_scrollbar = true, -- Show scrollbar for pagination
        -- How to shorten long directory paths in the file list:
        -- 'middle' (default): always uses dots (a/./b, a/../b, a/.../b)
        -- 'middle_number' uses dots for 1-3 hidden (a/./b, a/../b, a/.../b)
        --                 and numbers for 4+ (a/.4./b, a/.5./b)
        -- 'end': truncates from the end, keeps the start (home/user/projects)
        -- 'start': truncates from the start, keeps the end (.../parts/ai_extracted)
        path_shorten_strategy = "middle",
      },
      -- debug = {
      --   enabled = true, -- Set to true to show scores in the UI
      --   show_scores = true,
      -- },
      keymaps = {
        close = { "<Esc>", "<C-c>" },
        select = "<CR>",
        select_split = "<C-s>",
        select_vsplit = "<C-v>",
        select_tab = "<C-t>",
        move_up = { "<Up>", "<C-p>" },
        move_down = { "<Down>", "<C-n>" },
        preview_scroll_up = "<C-u>",
        preview_scroll_down = "<C-d>",
        toggle_debug = "<F2>",
      },
    },
  },
}
