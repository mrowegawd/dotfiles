local ui = {}
local conf = require("modules.ui.config")

ui["akinsho/nvim-bufferline.lua"] = {
    config = conf.nvim_bufferline,
    requires = "kyazdani42/nvim-web-devicons"
}

ui["andymass/vim-matchup"] = {
    event = {"BufRead", "BufNewFile"}
}

ui["glepnir/zephyr-nvim"] = {
    config = conf.set_colorscheme,
    requires = {
        {"rafi/awesome-vim-colorschemes", opt = true},
        {"chriskempson/base16-vim", opt = true},
        {"flazz/vim-colorschemes", opt = true}
    }
}

-- ui['glepnir/dashboard-nvim'] = {
--   config = conf.dashboard
-- }

ui["mhinz/vim-startify"] = {
    config = conf.startify
}

ui["glepnir/galaxyline.nvim"] = {
    branch = "main",
    config = conf.galaxyline,
    requires = "kyazdani42/nvim-web-devicons"
}

-- ui['lukas-reineke/indent-blankline.nvim'] = {
--   event = 'BufRead',
--   branch = 'lua',
--   config = conf.indent_blakline
-- }

ui["kyazdani42/nvim-tree.lua"] = {
    -- cmd = {'NvimTreeToggle','NvimTreeOpen', 'NvimTreeFindFile'},
    config = conf.nvim_tree,
    requires = "kyazdani42/nvim-web-devicons"
}

ui["lewis6991/gitsigns.nvim"] = {
    event = {"BufRead", "BufNewFile"},
    config = conf.gitsigns,
    requires = {"nvim-lua/plenary.nvim", opt = true}
}

return ui
