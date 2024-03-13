return {
  -- HEIRLINE
  {
    "rebelot/heirline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "LazyFile",
    config = function()
      local comp = require "r.plugins.colorthemes.heirline.components"
      require("heirline").setup {
        statusline = {
          comp.Mode,
          comp.Git,
          comp.FilePath,
          comp.FilePathQF,
          comp.FileIcon,
          comp.FileFlags,
          { provider = "%=" },
          comp.Dap,
          comp.LSPActive,
          comp.Diagnostics,
          comp.SearchCount, -- this func make nvim slow!
          comp.Sessions,
          comp.BufferCwd,
          comp.Ruler,
        },
      }

      local group = vim.api.nvim_create_augroup("Heirline", { clear = true })
      -- vim.cmd [[au Heirline FileType * if index(['wipe', 'delete'], &bufhidden) >= 0 | set nobuflisted | endif]]

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
