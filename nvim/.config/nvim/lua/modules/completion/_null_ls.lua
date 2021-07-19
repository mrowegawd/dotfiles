local null_ls = require("null-ls")
-- local h = require("null-ls.helpers")
-- local methods = require("null-ls.methods")
-- local b = null_ls.builtins

local M = {}

M.setup = function()
    null_ls.config(
        {
            debounce = 150,
            -- save_after_format = false,
            sources = {
                null_ls.builtins.diagnostics.shellcheck,
                null_ls.builtins.diagnostics.markdownlint,
                null_ls.builtins.diagnostics.selene
            }
        }
    )
end

return M
