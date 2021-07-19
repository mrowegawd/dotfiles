local telescope = require("telescope")
local builtin = require("telescope.builtin")

local notes_browser = function(opts)
    opts =
        {
        vimgrep_arguments = O.default.vimgrep_arguments,
        path_display = {"tail"},
        cwd = O.plugin.common.wiki_path,
        prompt_title = "Notes browser",
        results_title = "My Notes"
    } or opts

    builtin.file_browser(opts)
end

return telescope.register_extension {exports = {notes_browser = notes_browser}}
