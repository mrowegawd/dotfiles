local tools = {}
local conf = require('modules.tools.config')

tools['kristijanhusak/vim-dadbod-ui'] = {
  cmd = {'DBUIToggle','DBUIAddConnection','DBUI','DBUIFindBuffer','DBUIRenameBuffer'},
  config = conf.vim_dadbod_ui,
  requires = {{'tpope/vim-dadbod',opt = true}}
}

tools['editorconfig/editorconfig-vim'] = {
  ft = { 'go','typescript','javascript','vim','rust','zig','c','cpp' }
}

tools['windwp/nvim-autopairs'] = {
  event = 'BufReadPre',
  requires = 'tpope/vim-commentary'
}

tools['liuchengxu/vista.vim'] = {
  cmd = 'Vista',
  config = conf.vim_vista
}

tools['brooth/far.vim'] = {
  cmd = {'Far','Farp', 'Farf', 'Farr'},
  config = function ()
    vim.g['far#source'] = 'rg'
    vim.g['far#enable_undo'] = 1
  end
}

tools['tpope/vim-fugitive'] = {
  -- config = function ()
  -- end
}

tools['iamcco/markdown-preview.nvim'] = {
  ft = 'markdown',
  config = function ()
    vim.g.mkdp_auto_start = 0
  end
}

tools['vimwiki/vimwiki'] = {
  config = conf.vimwiki
}

tools['tweekmonster/startuptime.vim'] = {
  cmd = {'StartupTime'},
}

tools['szw/vim-maximizer'] = {
  config = function()
    vim.g.maximizer_set_default_mapping = 0
  end
}

tools['dhruvasagar/vim-dotoo'] = {
  config = conf.vim_dotoo
}

tools['folke/todo-comments.nvim'] = {
  cmd = {"TodoQuickFix"},
  config = conf.todo_comments,
  opt = true,
  require = {
    {'nvim-lua/plenary.nvim',opt = true},
  }

}


return tools
