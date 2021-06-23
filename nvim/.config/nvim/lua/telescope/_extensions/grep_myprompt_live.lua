local telescope = require("telescope")
local conf = require("telescope._extensions._configs")

local wiki_path = vim.g.vimwiki_list[1]["path"]

local grep_myprompt_live = function(opts)
    opts =
        require("telescope.themes").get_dropdown {
        vimgrep_arguments = conf.custom_vimgrep_arguments,
        shorten_path = true,
        search_dirs = {wiki_path},
        prompt_title = "Find Notes"
    } or {}

    require("telescope.builtin").live_grep(opts)
end

return telescope.register_extension {exports = {grep_myprompt_live = grep_myprompt_live}}
