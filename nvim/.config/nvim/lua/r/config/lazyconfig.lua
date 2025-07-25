local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim
    .system({
      "git",
      "clone",
      "--filter=blob:none",
      lazyrepo,
      lazypath,
    }, { text = true })
    :wait()
  if out.code ~= 0 then
    vim.notify("Failed to clone lazy.nvim: " .. (out.stderr or ""), vim.log.levels.ERROR)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup {
  lockfile = vim.fn.stdpath "data" .. "/lazy-lock.json",
  concurrency = 20,
  spec = {
    { import = "r.plugins" },
    { import = "r.plugins.extras.ai" },
    { import = "r.plugins.extras.dab" },
    { import = "r.plugins.extras.linting" },
    { import = "r.plugins.extras.formatter" },
    { import = "r.plugins.extras.lang" },

    { import = "r.plugins.extras.editor" },
    { import = "r.plugins.extras.coding.blink" },
    -- { import = "r.plugins.extras.coding.nvimcmp" },
    -- { import = "r.plugins.extras.coding.luasnip" },
    -- { import = "r.plugins.extras.editor.fzf" },
    -- { import = "r.plugins.extras.editor.telescope" },
    -- { import = "r.plugins.extras.text" },
  },
  change_detection = { notify = false },
  ui = { border = "rounded", backdrop = 100 },
  checker = { enabled = true, notify = false }, --   automatically check for plugin updates
  performance = {
    rtp = {
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
  rocks = {
    hererocks = false,
    enabled = false,
  },
}
