local completion = {}
local conf = require('modules.completion.config')

completion['neovim/nvim-lspconfig'] = {
  event = 'BufReadPre',
  config = conf.nvim_lsp,
  opt=true,
  requires = {
    {'ray-x/lsp_signature.nvim', opt=true},
    -- {'jose-elias-alvarez/null-ls.nvim'}
    -- {'folke/lsp-colors.nvim', opt=true}
  }
}

completion['glepnir/lspsaga.nvim'] = {
  cmd = 'Lspsaga'
}
--
-- completion['jose-elias-alvarez/null-ls.nvim'] = {
--   config = function()
--     require("null-ls").setup {}
--   end,
-- }

completion['hrsh7th/nvim-compe'] = {
  event = 'InsertEnter',
  config = conf.nvim_compe,
}

completion['hrsh7th/vim-vsnip'] = {
  event = 'InsertCharPre',
  config = conf.vim_vsnip
}

completion['nvim-telescope/telescope.nvim'] = {
  cmd = 'Telescope',
  config = conf.telescope,
  requires = {
    {'nvim-lua/popup.nvim', opt = true},
    {'nvim-lua/plenary.nvim',opt = true},
    {'nvim-telescope/telescope-fzy-native.nvim',opt = true},
  }
}

-- completion['glepnir/smartinput.nvim'] = {
--   ft = 'go',
--   config = conf.smart_input
-- }

-- completion['mattn/vim-sonictemplate'] = {
--   cmd = 'Template',
--   ft = {'go','typescript','lua','javascript','vim','rust','markdown'},
--   config = conf.vim_sonictemplate,
-- }

-- completion['mattn/emmet-vim'] = {
--   event = 'InsertEnter',
--   ft = {'html','css','javascript','javascriptreact','vue','typescript','typescriptreact'},
--   config = conf.emmet,
-- }

return completion
