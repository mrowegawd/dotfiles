local lang = {}
local conf = require("modules.lang.config")

lang["nvim-treesitter/nvim-treesitter"] = {
    event = "BufRead",
    after = "telescope.nvim",
    config = conf.nvim_treesitter,
    require = {
        "nvim-treesitter/playground"
    }
}

lang["nvim-treesitter/nvim-treesitter-textobjects"] = {
    after = "nvim-treesitter"
}

lang["Glench/Vim-Jinja2-Syntax"] = {
    event = "BufRead",
    ft = "jinja",
    after = "nvim-treesitter"
}

return lang
