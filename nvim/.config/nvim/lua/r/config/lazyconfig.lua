local fn, opt = vim.fn, vim.opt

local Data_path = fn.stdpath "data"
local Lazypath = Data_path .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(Lazypath) then
  fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    Lazypath,
  }
end

opt.rtp:prepend(Lazypath)

require("lazy").setup {
  -- debug = true,
  -- defaults = { lazy = true },
  lockfile = Data_path .. "/lazy-lock.json",
  concurrency = 20,
  spec = {
    { import = "r.plugins" },
    { import = "r.plugins.extras.ai" },
    { import = "r.plugins.extras.dab" },
    { import = "r.plugins.extras.lang" },
    { import = "r.plugins.extras.linting" },
    { import = "r.plugins.extras.formatter" },
  },
  change_detection = { notify = false },
  install = {
    colorscheme = { "terafox" },
    missing = true,
  },
  checker = {
    enabled = true,
    concurrency = 30,
    notify = false,
    frequency = 3600, -- check for updates every hour
  },
  ui = {
    wrap = true, -- wrap the lines in the ui
    border = "rounded",
  },
  git = {
    log = { "--since=3 days ago" }, -- show commits from the last 3 days
    timeout = 120, -- kill processes that take more than 2 minutes
    url_format = "https://github.com/%s.git",
  },
  performance = {
    cache = {
      enabled = true,
      path = vim.fn.stdpath "cache" .. "/lazy/cache",
      -- Once one of the following events triggers, caching will be disabled.
      -- To cache all modules, set this to `{}`, but that is not recommended.
      -- The default is to disable on:
      --  * VimEnter: not useful to cache anything else beyond startup
      --  * BufReadPre: this will be triggered early when opening a file from the command line directly
      -- disable_events = { "VimEnter", "BufReadPre" },
      -- ttl = 3600 * 24 * 5, -- keep unused modules for up to 5 days
    },
    reset_packpath = true, -- reset the package path to improve startup time
    rtp = {
      reset = true, -- reset the runtime path to $VIMRUNTIME and your config directory

      -- To fix `:changes` showing invalid, remove `netrw*` from `disabled_plugins` field
      disabled_plugins = {
        "2html_plugin",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "matchit",
        "tar",
        "tarPlugin",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
        "tutor",
        -- "rplugin", -- (cant use "UpdateRemotePlugins" if disabled)
        "syntax",
        "synmenu",
        "optwin",
        "compiler",
        "bugreport",
        "ftplugin",
      },
    },
  },
}
