local add = require("vim-pack").add

local lazy = require("utils.plugin").require_lazy

local UtilKey = lazy "utils.map"

add {
  {
    src = "LudoPinelli/comment-box.nvim",
    lazy = true,
    opts = {
      box_width = 80,
      line_width = 80,
    },
  },
}

local load_comment_box = function()
  lazy("vim-pack").load_now "comment-box.nvim"
end

UtilKey.noremap({ "n", "x" }, "<Leader>cbb", function()
  load_comment_box()
  vim.cmd "CBlcbox5"
end, { desc = "Action: comment box no 5" })

UtilKey.noremap({ "n", "x" }, "<Leader>cbB", function()
  load_comment_box()
  vim.cmd "CBlcbox9"
end, { desc = "Action: comment box no 9" })

UtilKey.noremap({ "n", "x" }, "<Leader>cbl", function()
  load_comment_box()
  vim.cmd "CBlcbox21"
end, { desc = "Action: comment box no 21" })

UtilKey.noremap({ "n", "x" }, "<Leader>cbe", function()
  load_comment_box()
  vim.cmd "CBllbox10"
end, { desc = "Action: comment line garis tipis 10" })

UtilKey.noremap({ "n", "x" }, "<Leader>cbE", function()
  load_comment_box()
  vim.cmd "CBlcbox10"
end, { desc = "Action: comment line garis tipis center 10" })

UtilKey.noremap({ "n", "x" }, "<Leader>cba", function()
  load_comment_box()
  vim.cmd "CBlcline10"
end, { desc = "Action: comment line 10" })

UtilKey.noremap({ "n", "x" }, "<Leader>cby", function()
  load_comment_box()
  vim.cmd "CBllline6"
end, { desc = "Action: comment line left 6" })

UtilKey.noremap({ "n", "x" }, "<Leader>cbA", function()
  load_comment_box()
  vim.cmd "CBlcline13"
end, { desc = "Action: comment line 13" })

UtilKey.nnoremap("<Leader>cbf", function()
  load_comment_box()
  vim.cmd "CBcatalog"
end, { desc = "Action: open catalogs" })
