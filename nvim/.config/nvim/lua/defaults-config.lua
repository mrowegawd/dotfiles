local global = {}
local home = os.getenv("HOME")
local path_sep = global.is_windows and "\\" or "/"
local _vim_path = vim.fn.stdpath("config")
local os_name = vim.loop.os_uname().sysname

O = {
    default = {
        is_mac = os_name == "Darwin",
        is_linux = os_name == "Linux",
        is_windows = os_name == "Windows",
        vim_path = _vim_path,
        cache_dir = home .. path_sep .. ".cache" .. path_sep .. "nvim" .. path_sep,
        modules_dir = _vim_path .. path_sep .. "modules",
        path_sep = path_sep,
        home = home,
        data_dir = string.format("%s/site/", vim.fn.stdpath("data")),
        colorscheme = "base16-gruvbox-dark-medium",
        vimgrep_arguments = {
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
    },
    plugin = {
        lsp = {
            completion = true
        },
        common = {
            wiki_path = os.getenv("HOME") .. "/Dropbox/wiki",
            auto_session = false
        }
    }
}
