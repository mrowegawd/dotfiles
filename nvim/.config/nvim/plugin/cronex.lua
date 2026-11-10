local add_on_file_type = require("vim-pack").add_on_file_type

local lazy = require("utils.plugin").require_lazy

add_on_file_type({ "yaml", "yml", "tf", "cfg", "config", "conf", "crontab" }, {
  {
    -- ex: (gunakan tanda kurung ya!) -> "* * * * *" bukan * * * * *
    -- dan juga format cronex adalah lewat diagnostic (or check via trouble)
    src = "fabridamicelli/cronex.nvim",
    opts = function()
      return {
        file_patterns = { "*.yaml", "*.yml", "*.tf", "*.cfg", "*.config", "*.conf", "*.crontab" },
        extractor = {
          cron_from_line = lazy("cronex.cron_from_line").cron_from_line_crontab,
          extract = lazy("cronex.extract").extract,
        },
      }
    end,
  },
})
