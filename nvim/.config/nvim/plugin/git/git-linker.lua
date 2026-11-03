local add = require("vim-pack").add

local lazy = require("utils.plugin").require_lazy

local UtilKey = lazy "utils.map"

add {
  {
    src = "linrongbin16/gitlinker.nvim",
    lazy = true,
    opts = function()
      return {
        router = {
          browse = {
            ["^github%.palantir%.build"] = lazy("gitlinker.routers").github_browse,
          },
          blame = {
            ["^github%.palantir%.build"] = lazy("gitlinker.routers").github_blame,
          },
        },
      }
    end,
  },
}

UtilKey.noremap({ "n", "x" }, "<Leader>gy", function()
  UtilKey.plugin_load_now "gitlinker.nvim"
  vim.cmd.GitLink()
end, { desc = "Git: copy symlink [gitlinker]" })

UtilKey.noremap({ "n", "x" }, "<Leader>gox", function()
  UtilKey.plugin_load_now "gitlinker.nvim"
  vim.cmd "GitLink! blame"
end, { desc = "Git: browse blame repo [gitlinker]" })

UtilKey.noremap({ "n", "x" }, "<C-c>gy", function()
  lazy("utils.git").copy_repo_name()
end, { desc = "Git: copy repo name" })
