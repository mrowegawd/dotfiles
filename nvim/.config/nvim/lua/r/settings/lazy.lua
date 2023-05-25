local fn, opt = vim.fn, vim.opt

local data = fn.stdpath "data"
local lazypath = data .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    }
end

opt.rtp:prepend(lazypath)

require("lazy").setup {
    spec = {
        { import = "r.plugins" },
        { import = "r.plugins.extras.notes" },
        { import = "r.plugins.extras.db" },
        { import = "r.plugins.extras.ui" },
        { import = "r.plugins.extras.misc" },
    },
    defaults = { lazy = true, version = nil },
    change_detection = { notify = false },
    install = {
        missing = true,
        colorscheme = { "catppuccin", "habamax" },
    },
    checker = {
        enabled = true,
        notify = false,
        frequency = 900,
    },
    diff = {
        cmd = "terminal_git",
    },
    performance = {
        rtp = {
            disabled_plugins = {
                -- "gzip",
                -- "matchit",
                -- "matchparen",
                -- -- "netrwPlugin",
                -- "tarPlugin",
                -- "tohtml",
                -- "tutor",
                -- "zipPlugin",
            },
        },
    },
    lockfile = data .. "/lazy-lock.json",
    debug = false,
}
