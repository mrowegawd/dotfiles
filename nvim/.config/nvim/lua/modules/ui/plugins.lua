local ui = {}
local conf = require('modules.ui.config')

ui['glepnir/zephyr-nvim'] = {
  config = [[vim.cmd('colorscheme base16-gruvbox-dark-hard')]],
  requires = {
    {"rafi/awesome-vim-colorschemes", opt=true},
    {"chriskempson/base16-vim", opt=true},
    {"flazz/vim-colorschemes", opt=true}
  }
}

-- ui['glepnir/dashboard-nvim'] = {
--   config = conf.dashboard
-- }

ui['mhinz/vim-startify'] = {
  config = conf.startify
}

ui['glepnir/galaxyline.nvim'] = {
  branch = 'main',
  config = conf.galaxyline,
  requires = 'kyazdani42/nvim-web-devicons'
}

ui['lukas-reineke/indent-blankline.nvim'] = {
  event = 'BufRead',
  branch = 'lua',
  config = conf.indent_blakline
}

ui['akinsho/nvim-bufferline.lua'] = {
  config = conf.nvim_bufferline,
  requires = 'kyazdani42/nvim-web-devicons'
}

ui['kyazdani42/nvim-tree.lua'] = {
  -- cmd = {'NvimTreeToggle','NvimTreeOpen', 'NvimTreeFindFile'},
  config = conf.nvim_tree,
  requires = 'kyazdani42/nvim-web-devicons'
}

ui['lewis6991/gitsigns.nvim'] = {
  event = {'BufRead','BufNewFile'},
  config = conf.gitsigns,
  requires = {'nvim-lua/plenary.nvim',opt=true}
}

return ui
