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
    -- keys = {
    --   {
    --     "<leader>ff", -- try it if you didn't it is a banger keybinding for a picker
    --     function()
    --       require("fff").toggle()
    --     end,
    --     desc = "Toggle FFF",
    --   },
    -- },
    opts = {},
  },
}
