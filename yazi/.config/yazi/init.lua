THEME.git = THEME.git or {}
-- Same icon with `nvim-neo-tree/neo-tree.nvim`
THEME.git.modified_sign = ""
THEME.git.added_sign = "✚"
THEME.git.untracked_sign = ""
THEME.git.ignored_sign = ""
THEME.git.deleted_sign = "✖"
THEME.git.updated_sign = ""
require("git"):setup()
