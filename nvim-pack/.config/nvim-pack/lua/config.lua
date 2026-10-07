local fmt = string.format

local PlatForm = require "utils.platform"

local M = {}

local home = os.getenv "HOME"

local dropbox_path = fmt("%s/Dropbox", home, "Dropbox")
if PlatForm.is_wsl then
  dropbox_path = "/mnt/c/Users/moxli/Dropbox"
end

M.path = {
  wiki_path = vim.fs.joinpath(dropbox_path, "neorg"),
  snippet_path = vim.fs.joinpath(dropbox_path, "/snippets-for-all"),
  dropbox_path = dropbox_path,
  home = home,
}

vim.g.lightthemes = { "dawnfox", "rose-pine-dawn", "rose-pine", "base46-material-lighter" }

return M
