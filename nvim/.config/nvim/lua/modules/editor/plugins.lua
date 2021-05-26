local editor = {}
local conf = require('modules.editor.config')

editor['Raimondi/delimitMate'] = {
  event = 'InsertEnter',
  config = conf.delimimate,
}

editor['norcalli/nvim-colorizer.lua'] = {
  ft = { 'html','css','sass','vim','typescript','typescriptreact'},
  config = conf.nvim_colorizer
}

editor['itchyny/vim-cursorword'] = {
  event = {'BufReadPre','BufNewFile'},
  config = conf.vim_cursorwod
}

editor['hrsh7th/vim-eft'] = {
  opt = true,
  config = function()
    vim.g.eft_ignorecase = true
  end
}

editor['AndrewRadev/splitjoin.vim'] = {
  event = 'BufRead',
  opt = true
}

editor['kana/vim-operator-replace'] = {
  keys = {{'x','p'}},
  config = function()
    vim.api.nvim_set_keymap("x", "p", "<Plug>(operator-replace)",{ silent = true })
  end,
  requires = 'kana/vim-operator-user'
}

editor['rhysd/vim-operator-surround'] = {
  event = 'BufRead',
  requires = 'kana/vim-operator-user'
}

-- editor['kana/vim-niceblock']  = {
--   opt = true
-- }

editor['mfussenegger/nvim-dap'] = {
  event = 'BufReadPre',
  config = conf.nvim_dap,
  opt = true,
  requires = {
    {'mfussenegger/nvim-dap-python', opt=true},
    {'theHamsta/nvim-dap-virtual-text', opt= true},
  }
}

editor['vim-test/vim-test'] = {
  cmd = {'TestFile', 'TestNearest', 'TestSuite'},
  opt = true,
  config = conf.vim_test
}

editor['tpope/vim-projectionist'] = {
  ft = { 'html','css','sass','typescript','typescriptreact', 'python', 'golang'},
  config = conf.vim_projectionist
}


editor['mg979/vim-visual-multi']  = { }

return editor
