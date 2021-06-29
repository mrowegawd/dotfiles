local M = {}

M.custom_vimgrep_arguments = {
    "rg",
    "--hidden",
    "--follow",
    "--no-ignore-vcs",
    "-g",
    "!{node_modules,.git,__pycache__,.pytest_cache}",
    "--no-heading",
    "--with-filename",
    "--line-number",
    "--column",
    "--smart-case"
}

return M
