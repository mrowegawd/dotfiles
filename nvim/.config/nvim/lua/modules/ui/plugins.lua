local ui = {}
local conf = require("modules.ui.config")

ui["akinsho/nvim-bufferline.lua"] = {
    config = conf.nvim_bufferline,
    event = "BufWinEnter",
    requires = "kyazdani42/nvim-web-devicons"
}

-- matching tag even better
ui["andymass/vim-matchup"] = {
    cmd = {"DoMatchParen"},
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

ui["glepnir/dashboard-nvim"] = {
    event = "BufWinEnter",
    config = conf.dashboard,
    disable = not true
}

-- ui["mhinz/vim-startify"] = {
--     config = conf.startify
-- }

-- ui["glepnir/galaxyline.nvim"] = {
--     branch = "main",
--     config = conf.galaxyline,
--     requires = "kyazdani42/nvim-web-devicons"
-- }

ui["hoob3rt/lualine.nvim"] = {
    config = conf.lualine,
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
    event = "BufRead",
    config = conf.gitsigns,
    requires = {"nvim-lua/plenary.nvim", opt = true}
}

return ui
