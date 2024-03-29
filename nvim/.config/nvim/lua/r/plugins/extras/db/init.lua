return {
  -- VIM-DADBOD
  {
    "tpope/vim-dadbod",
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection" },
    keys = {
      { "<Localleader>dd", "<CMD>DBUIToggle<CR>", desc = "Database(dadbod): toggle UI" },
      -- { "<Localleader>dD", "<CMD>DBUIFindBuffer<CR>", desc = "Database(dadbod): find buffer" },
      { "<Localleader>dr", "<CMD>DBUIRenameBuffer<cr>", desc = "Database(dadbod): rename buffer" },
      { "<Localleader>dl", "<CMD>DBUILastQueryInfo<cr>", desc = "Database(dadbod): last query info" },
    },
    dependencies = {
      "kristijanhusak/vim-dadbod-ui",
      "kristijanhusak/vim-dadbod-completion",
    },
    opts = {
      db_competion = function()
        require("cmp").setup.buffer {
          sources = { { name = "vim-dadbod-completion" } },
        }
      end,
    },
    config = function(_, opts)
      vim.g.db_ui_save_location = vim.fn.stdpath "config" .. require("plenary.path").path.sep .. "db_ui"

      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "sql",
        },
        command = [[setlocal omnifunc=vim_dadbod_completion#omni]],
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "sql",
          "mysql",
          "plsql",
        },
        callback = function()
          vim.schedule(opts.db_completion)
        end,
      })
    end,
  },
}
