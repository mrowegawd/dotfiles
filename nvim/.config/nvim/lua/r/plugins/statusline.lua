return {
  -- HEIRLINE
  {
    "rebelot/heirline.nvim",
    event = "VeryLazy",
    opts = function()
      local comp = require "r.plugins.colorthemes.heirline.components"
      return {
        statusline = {
          comp.status_active_left,
          comp.status_not_active,
        },
      }
    end,
    config = function(_, opts)
      require("heirline").setup(opts)

      -- opts = {
      --   disable_winbar_cb = function(args)
      --     return not require("astronvim.utils.buffer").is_valid(args.buf)
      --       or status.condition.buffer_matches({
      --         buftype = { "terminal", "prompt", "nofile", "help", "quickfix" },
      --         filetype = { "NvimTree", "neo%-tree", "dashboard", "Outline", "aerial" },
      --       }, args.buf)
      --   end,
      -- },
      -- }

      local group = vim.api.nvim_create_augroup("Heirline", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "*",
        callback = function()
          local bh = vim.bo.bufhidden
          if bh == "wipe" or bh == "delete" then
            vim.bo.buflisted = false
          end
        end,
      })
    end,
  },
}
