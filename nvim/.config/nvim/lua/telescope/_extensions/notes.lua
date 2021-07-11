local telescope = require("telescope")

local notes = function(opts)
    opts =
        {
        vimgrep_arguments = O.default.vimgrep_arguments,
        path_display = {"tail"},
        search_dirs = {O.plugin.common.wiki_path, O.plugin.common.wiki_path .. "/org"},
        prompt_title = "Find Notes",
        results_title = "My Notes"
    } or opts

    require("telescope.builtin").live_grep(opts)
end

return telescope.register_extension {exports = {notes = notes}}
