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

editor['kana/vim-operator-replace'] = {
  keys = {{'x','p'}},
  config = function()
    vim.api.nvim_set_keymap("x", "p", "<Plug>(operator-replace)",{silent =true})
  end,
  requires = 'kana/vim-operator-user'
}

editor['rhysd/vim-operator-surround'] = {
  event = 'BufRead',
  requires = 'kana/vim-operator-user'
}

editor['kana/vim-niceblock']  = {
  opt = true
}

editor['vimwiki/vimwiki'] = {
  cmd = {'VimwikiIndex'},
  config = function()
    local wiki_path = os.getenv("HOME") .. '/Dropbox/vimwiki'

    vim.g.vimwiki_list           = {{
      path= wiki_path,
      index= 'home',
      auto_diary_index= 1,
      automatic_nested_syntaxes=  1,
      syntax= 'markdown',
      template_default= 'markdown',
      ext= '.md'
    }}

    -- Disable ALL Vimwiki key mappings
    -- let g:vimwiki_listsyms          = '✗○◐●✓'
    vim.g.vimwiki_key_mappings      = { all_maps = 0}
    vim.g.vimwiki_table_mappings    = 0
    vim.g.vimwiki_folding           = 'expr'
    vim.g.vimwiki_global_ext        = 0
    vim.g.vimwiki_hl_cb_checked     = 1
    vim.g.vimwiki_hl_headers        = 1
    vim.g.vimwiki_markdown_link_ext = 1
  end

}

return editor
