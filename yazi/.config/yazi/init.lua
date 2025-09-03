-- [plugins] - yazi-rs/git.yazi
-- show git status right after directory
th.git = th.git or {}
th.git.modified_sign = ""
th.git.added_sign = "✚"
th.git.untracked_sign = ""
th.git.ignored_sign = ""
th.git.deleted_sign = "✖"
th.git.updated_sign = ""
require("git"):setup {
  order = 500, -- order to show directory list. if 1500, gitsign go to rightmost
}
