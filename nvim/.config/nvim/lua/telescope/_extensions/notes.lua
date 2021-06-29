local telescope = require("telescope")
local conf = require("telescope._extensions.conf")

local wiki_path = vim.g.vimwiki_list[1]["path"]

local notes = function(opts)
    opts =
        {
        vimgrep_arguments = conf.custom_vimgrep_arguments,
        shorten_path = true,
        search_dirs = {wiki_path},
        prompt_title = "Find Notes",
        results_title = "My Notes"
    } or opts

    require("telescope.builtin").live_grep(opts)
end

return telescope.register_extension {exports = {notes = notes}}
