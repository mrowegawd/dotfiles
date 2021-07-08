local telescope = require("telescope")
local conf = require("telescope._extensions.conf")

local fn = vim.fn

local grepcword = function(opts)
    opts = opts or {}
    require("telescope.builtin").grep_string(
        {
            vimgrep_arguments = conf.custom_vimgrep_arguments,
            word_match = "-w",
            search = fn.expand("<cword>"),
            path_display = {"tail"},
            prompt_title = "Find Current Word"
        }
    )
end

return telescope.register_extension {exports = {grepcword = grepcword}}
