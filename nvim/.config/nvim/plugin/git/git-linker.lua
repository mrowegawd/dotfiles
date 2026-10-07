local add = require("vim-pack").add

local UtilKey = require "utils.map"

add {
  {
    src = "linrongbin16/gitlinker.nvim",
    lazy = true,

    opts = function()
      return {
        router = {
          browse = {
            ["^github%.palantir%.build"] = require("gitlinker.routers").github_browse,
          },
          blame = {
            ["^github%.palantir%.build"] = require("gitlinker.routers").github_blame,
          },
        },
      }
    end,
  },
}

UtilKey.noremap({ "n", "x" }, "<Leader>gy", function()
  UtilKey.plugin_load_now "gitlinker.nvim"
  vim.cmd.GitLink()
end, { desc = "Git: browse [gitlinker]" })

UtilKey.noremap({ "n", "x" }, "<Leader>gb", function()
  UtilKey.plugin_load_now "gitlinker.nvim"
  vim.cmd "GitLink! blame"
end, { desc = "Git: blame [gitlinker]" })
