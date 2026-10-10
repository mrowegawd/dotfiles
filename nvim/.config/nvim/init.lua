vim.loader.enable() -- Do not delete this line

-- local orig_create_autocmd = vim.api.nvim_create_autocmd
-- vim.api.nvim_create_autocmd = function(event, opts)
--   if opts.callback then
--     local cb = opts.callback
--     opts.callback = function(...)
--       local start = vim.uv.hrtime()
--       local ok, err = pcall(cb, ...)
--       local elapsed = (vim.uv.hrtime() - start) / 1e6
--       if elapsed > 5 then -- cuma log yang >5ms biar tidak spam
--         vim.notify(string.format("[%s] %.2fms %s", event, elapsed, debug.getinfo(cb, "S").source))
--       end
--       if not ok then
--         error(err)
--       end
--     end
--   end
--   return orig_create_autocmd(event, opts)
-- end

local colorscheme = "vscode"
vim.g.colorscheme = colorscheme

-- Disable builtins
for _, built_in in ipairs {
  "gzip",
  "matchit",
  "matchparen",
  "netrw",
  "netrwPlugin",
  "nvim_net_plugin",
  "nvim_zip_plugin",
  "tarPlugin",
  "tutor_mode_plugin",
} do
  vim.g["loaded_" .. built_in] = 1
end

require "settings"
require "colors"
require "autocmds"
require "commands"
require "keymaps"
require "lsp"

vim.schedule(function()
  vim.o.statuscolumn = [[%!v:lua.require'utils.statuscolumn'.get()]]
end)

require("vim._core.ui2").enable {}
