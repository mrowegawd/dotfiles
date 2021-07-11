local telescope = require("telescope")

local fn = vim.fn

local grepword = function(opts)
    opts = opts or {}
    require("telescope.builtin").grep_string(
        {
            vimgrep_arguments = O.default.vimgrep_arguments,
            word_match = "-w",
            path_display = {"tail"},
            search = fn.input("Grep String > ")
        }
    )
end

return telescope.register_extension {exports = {grepword = grepword}}
