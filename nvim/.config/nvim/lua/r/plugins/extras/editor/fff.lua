return {
  -- FFF.NVIM (disabled)
  {
    "dmtrKovalenko/fff.nvim",
    enabled = false,
    build = function()
      -- this will download prebuild binary or try to use existing rustup toolchain to build from source
      -- (if you are using lazy you can use gb for rebuilding a plugin if needed)
      require("fff.download").download_or_build_binary()
    end,
    keys = {
      {
        "<leader>ff", -- try it if you didn't it is a banger keybinding for a picker
        function()
          require("fff").find_files()
        end,
        desc = "picker: find files [fff.nvim]",
      },
    },
    opts = {
      debug = {
        enabled = true, -- Set to true to show scores in the UI
        show_scores = true,
      },
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
