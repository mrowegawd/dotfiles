local telescope = require("telescope")
local utils = require("telescope.utils")
local conf = require("telescope._extensions.conf")

local fn = vim.fn

local grepcword = function(opts)
    opts = opts or {}
    require("telescope.builtin").grep_string(
        {
            vimgrep_arguments = conf.custom_vimgrep_arguments,
            word_match = "-w",
            search = fn.expand("<cword>"),
            path_display = utils.get_default(opts.path_display, "hidden"),
            prompt_title = "Find Current Word"
        }
    )
end

return telescope.register_extension {exports = {grepcword = grepcword}}
