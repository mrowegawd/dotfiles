local telescope = require("telescope")
local conf = require("telescope._extensions.conf")
local utils = require("telescope.utils")

local fn = vim.fn

local grepword = function(opts)
    opts = opts or {}
    require("telescope.builtin").grep_string(
        {
            vimgrep_arguments = conf.custom_vimgrep_arguments,
            word_match = "-w",
            path_display = utils.get_default(opts.path_display, "hidden"),
            search = fn.input("Grep String > ")
        }
    )
end

return telescope.register_extension {exports = {grepword = grepword}}
