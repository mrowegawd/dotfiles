local telescope = require("telescope")
local conf = require("telescope._extensions._configs")

local fn = vim.fn

local grep_mypromptword = function(opts)
    opts = opts or {}
    require("telescope.builtin").grep_string(
        {
            vimgrep_arguments = conf.custom_vimgrep_arguments,
            word_match = "-w",
            shorten_path = true,
            search = fn.expand("<cword>")
        }
    )
end

return telescope.register_extension {exports = {grep_mypromptword = grep_mypromptword}}
