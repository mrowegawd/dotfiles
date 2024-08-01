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
  lockfile = Data_path .. "/lazy-lock.json",
  concurrency = 20,
  spec = {
    { import = "r.plugins" },
    { import = "r.plugins.extras.ai" },
    { import = "r.plugins.extras.dab" },
    { import = "r.plugins.extras.linting" },
    { import = "r.plugins.extras.formatter" },
    { import = "r.plugins.extras.lang" },
    -- { import = "r.plugins.extras.text" },
  },
  change_detection = { notify = false },
  install = {
    missing = true,
  },
  ui = {
    wrap = true, -- Wrap the lines in the ui
    border = "rounded",
  },
  performance = {
    reset_packpath = true, -- Reset the package path to improve startup time
    rtp = {
      reset = true, -- Reset the runtime path to `$VIMRUNTIME` and your configuration directory

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
