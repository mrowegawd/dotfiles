local g, fn, opt, loop, env = vim.g, vim.fn, vim.opt, vim.loop, vim.env

local data = fn.stdpath "data"

if vim.loader then
    vim.loader.enable()
end

g.os = loop.os_uname().sysname
g.open_command = g.os == "Darwin" and "open" or "xdg-open"

g.dotfiles = env.DOTFILES or fn.expand "~/.dotfiles"
g.vim_dir = g.dotfiles .. "/.config/nvim"
g.projects_dir = env.PROJECTS_DIR or fn.expand "~/projects"
g.work_dir = g.projects_dir .. "/work"

-------------------------------------------------------------------------------
-- Leader bindings ------------------------------------------------------------
g.mapleader = " " -- space is the leader!
g.maplocalleader = ","

-------------------------------------------------------------------------------
-- Global namespace
-------------------------------------------------------------------------------
local namespace = {
    ui = {
        winbar = { enable = true },
        statuscolumn = { enable = true },
        foldtext = { enable = false },
    },

    -- some vim mappings require a mixture of commandline commands and function
    -- calls this table is place to store lua functions to be called in those
    -- mappings
    mappings = { enable = true },
}

-- This table is a globally accessible store to facilitating accessing
-- helper functions and variables throughout my config
_G.as = as or namespace
_G.map = vim.keymap.set
_G.P = vim.print

require "r.utils.globals"
require "r.settings.ui"
require "r.settings.highlights"

local lazypath = data .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
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
                "gzip",
                "matchit",
                "matchparen",
                -- "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },

    debug = false,
}

require "r.settings.options"()
