return {
  -- VIM-HIGHLIGHTER
  {
    "azabiong/vim-highlighter",
    -- https://github.com/t9md/vim-quickhl (alternatif??)
    keys = {
      {
        "<leader>uh",
        function()
          local mode = vim.api.nvim_get_mode().mode
          if mode == "v" or mode == "V" then
            local word = RUtils.get_visual_selection()
            if word then
              vim.cmd(":Hi + " .. word.selection)
            end
            return
          end
          vim.cmd ":Hi + "
        end,
        desc = "Misc: highlight word on cursor [vim-highlighter]",
        mode = { "n", "v" },
      },
      {
        "<Leader>uH",
        "<CMD>Hi clear<CR>",
        desc = "Misc: clear all highlights [vim-highlighter]",
      },
    },
  },
  -- BLOAT
  {
    "dundalek/bloat.nvim",
    cmd = "Bloat",
  },
  -- STARTUPTIME
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },
  -- COMMENT-BOX
  {
    "LudoPinelli/comment-box.nvim",
    event = "InsertEnter",
    keys = {
      { "<Leader>cb", "", desc = "comment-box" },
      { "<Leader>cbb", "<cmd>CBlcbox5<cr>", desc = "Misc: comment box no 5" },
      { "<Leader>cbB", "<cmd>CBlcbox9<cr>", desc = "Misc: comment box no 9" },
      { "<Leader>cbe", "<cmd>CBlcbox10<cr>", desc = "Misc: comment box garis tips 10" },
      { "<Leader>cbl", "<cmd>CBlcbox21<cr>", desc = "Misc: comment box no 21" },
      { "<Leader>cba", "<cmd>CBlcline10<cr>", desc = "Misc: comment line no 10" },
      { "<Leader>cbA", "<cmd>CBlcline13<cr>", desc = "Misc: comment line no 13" },
      { "<Leader>cbg", "<cmd>CBcatalog<cr>", desc = "Misc: CBcatalog" },
    },
    opts = {
      box_width = 80,
      line_width = 80,
    },
  },
  -- NREDIR
  {
    -- Redirect output of vim or external command into scratch buffer,
    "sbulav/nredir.nvim",
    cmd = { "Nredir" },
    opts = {},
  },
  -- HAWTKEYS (disabled)
  {
    "tris203/hawtkeys.nvim", -- use only when necessary.
    enabled = false,
    cmd = { "Hawtkeys", "HawtkeysDupes" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = true,
  },
  -- CRONEX (disabled) gunakan saat diperlukan saja
  {
    -- ex: (gunakan tanda kurung ya!) -> "* * * * *" bukan * * * * *
    -- dan juga format cronex adalah lewat diagnostic (or check via trouble)
    "fabridamicelli/cronex.nvim",
    enabled = false,
    ft = { "yaml", "yml", "tf", "cfg", "config", "conf", "crontab" },
    config = function()
      require("cronex").setup {
        -- Add *.crontab to supported file patterns
        file_patterns = { "*.yaml", "*.yml", "*.tf", "*.cfg", "*.config", "*.conf", "*.crontab" },

        -- Use custom extractor to support unquoted cron expressions
        extractor = {
          cron_from_line = require("cronex.cron_from_line").cron_from_line_crontab,
          extract = require("cronex.extract").extract,
        },
      }
    end,
  },
}
