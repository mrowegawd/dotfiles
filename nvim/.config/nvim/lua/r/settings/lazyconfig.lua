local fn, opt = vim.fn, vim.opt

local data = fn.stdpath "data"
local lazypath = data .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
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
    { import = "r.plugins.extras.db" },
    { import = "r.plugins.extras.ai" },
    { import = "r.plugins.extras.lang" },
    { import = "r.plugins.extras.linting" },
    -- { import = "r.plugins.extras.misc" },
  },
  defaults = { lazy = true, version = false },
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
  ui = {
    border = "single",
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",

        -- Do not add these plugins:
        -- "netrwPlugin",   -- we need this for orgmode (open link)
      },
    },
  },
  lockfile = data .. "/lazy-lock.json",
  -- debug = true,
}
