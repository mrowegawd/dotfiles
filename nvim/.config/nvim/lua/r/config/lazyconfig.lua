local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system { "git", "clone", "--filter=blob:none", lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup {
  lockfile = vim.fn.stdpath "data" .. "/lazy-lock.json",
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
    border = "rounded",
    size = { width = 0.8, height = 0.8 },
    backdrop = 100,
    wrap = false,
  },
  checker = { enabled = true }, --   automatically check for plugin updates
  defaults = {
    version = false, -- always use the latest git commit
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
