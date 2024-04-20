return {
  -- VIM-DADBOD
  {
    "tpope/vim-dadbod",
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection" },
    keys = {
      { "<Localleader>dd", "<CMD>DBUIToggle<CR>", desc = "Database: toggle UI [dadbod]" },
      -- { "<Localleader>dD", "<CMD>DBUIFindBuffer<CR>", desc = "Database: find buffer [dadbod]" },
      { "<Localleader>dr", "<CMD>DBUIRenameBuffer<cr>", desc = "Database: rename buffer [dadbod]" },
      { "<Localleader>dl", "<CMD>DBUILastQueryInfo<cr>", desc = "Database: last query info [dadbod]" },
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
