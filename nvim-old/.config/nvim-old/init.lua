-- local orig_create_autocmd = vim.api.nvim_create_autocmd
-- vim.api.nvim_create_autocmd = function(event, opts)
--   if opts.callback then
--     local cb = opts.callback
--     opts.callback = function(...)
--       local start = vim.uv.hrtime()
--       local ok, err = pcall(cb, ...)
--       local elapsed = (vim.uv.hrtime() - start) / 1e6
--       if elapsed > 5 then -- cuma log yang >5ms biar tidak spam
--         -- vim.notify(string.format("[%s] %.2fms %s", event, elapsed, debug.getinfo(cb, "S").source))
--         RUtils.info(string.format("[%s] %.2fms %s", vim.inspect(event), elapsed, debug.getinfo(cb, "S").source))
--       end
--       if not ok then
--         error(err)
--       end
--     end
--   end
--   return orig_create_autocmd(event, opts)
-- end

vim.loader.enable() -- dont delete this line

require "r.config.lazyconfig"
require("r.config").setup()

vim.cmd.packadd "cfilter"
