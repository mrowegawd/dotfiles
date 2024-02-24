return {
  -- OPENBROWSER
  {
    {
      "sontungexpt/url-open",
      enabled = false,
      cmd = "URLOpenUnderCursor",
      opts = {},
      -- keys = {
      --   {
      --     "<Leader>oo",
      --     "<CMD>URLOpenUnderCursor<CR>",
      --     mode = { "n", "v" },
      --     desc = "Misc: open on browser",
      --   },
      -- },
    },
  },

  -- FIRENVIM
  -- {
  --   "glacambre/firenvim", -- embed neovim in browsers
  --   lazy = false,
  --   build = function()
  --     vim.fn["firenvim#install"](0)
  --   end,
  --   init = function()
  --     if vim.g.started_by_firenvim then
  --       vim.g.firenvim_config = {
  --         localSettings = {
  --           [".*"] = {
  --             cmdline = "none",
  --           },
  --         },
  --       }
  --       vim.opt.laststatus = 0
  --       vim.api.nvim_create_autocmd("UIEnter", {
  --         once = true,
  --         callback = function()
  --           vim.go.lines = 20
  --         end,
  --       })
  --       -- vim.cmd([[au BufEnter github.com_*.txt set filetype=markdown]])
  --     end
  --   end,
  -- },
}
