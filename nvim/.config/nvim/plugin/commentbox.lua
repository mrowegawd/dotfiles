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

local cb = function(suffix, cmd, desc, modes)
  UtilKey.noremap(modes or { "n", "x" }, "<Leader>cb" .. suffix, function()
    load_comment_box()
    vim.cmd(cmd)
  end, { desc = "CommentBox: " .. desc })
end

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                                  BOX TITLE                                  ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛
cb("tj", "CBlcbox5", "box title center 5")
cb("th", "CBllbox5", "box title left 5")

-- ┌─────────────────────────────────────────────────────────────────────────────┐
--                                 BOX BIG COMMEN
-- └─────────────────────────────────────────────────────────────────────────────┘
cb("Tj", "CBlcbox20", "box for big comment center 20")
cb("Th", "CBllbox20", "box for big comment left 20")

-- ╒═════════════════════════════════════════════════════════════════════════════╕
--                                  BOX MISC SUB
-- ╘═════════════════════════════════════════════════════════════════════════════╛
cb("sj", "CBlcbox21", "box title sub center 21")
cb("sh", "CBllbox21", "box title sub left 21")

-- ── Line1 ──────────────────────────────────────────────────────────────────
cb("L1", "CBclline1", "line 1")
-- ─[ line2 ]─────────────────────────────────────────────────────────────────
cb("L2", "CBclline6", "line 6")
-- ─< line3 >─────────────────────────────────────────────────────────────────
cb("L3", "CBclline8", "line 8")
-- ━━ line4 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
cb("L4", "CBclline9", "line 9 (hard)")

-- Line only
-- ────────────────────────────────────────────────────────────────────────────────
cb("l1", "CBlline1", "line hard 1")
-- ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
cb("l2", "CBlline11", "line hard 11 (hard)")
-- +---------------------------------------------------------------------------+
cb("l3", "CBlline17", "line dot 17")
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
cb("l4", "CBlline9", "line dot 9 (hard)")

UtilKey.noremap("n", "<Leader>cbB", function()
  load_comment_box()
  vim.cmd "CBcatalog"
end, { desc = "CommentBox: open catalog" })
