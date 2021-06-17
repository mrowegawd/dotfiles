local config = {}

function config.galaxyline()
  require('modules.ui.eviline')
end

function config.nvim_bufferline()
  require('bufferline').setup{
    options = {
      modified_icon = '✥',
      buffer_close_icon = '',
      mappings = true,
      always_show_bufferline = false,
    }
  }
end

function config.dashboard()
  local home = os.getenv('HOME')
  vim.g.dashboard_footer_icon = '🐬 '
  vim.g.dashboard_preview_command = 'cat'
  vim.g.dashboard_preview_pipeline = 'lolcat -F 0.2'
  vim.g.dashboard_preview_file = home .. '/.config/nvim/static/neovim.cat'
  vim.g.dashboard_preview_file_height = 15
  vim.g.dashboard_preview_file_width = 80
  vim.g.dashboard_default_executive = 'telescope'
  vim.g.dashboard_custom_section = {
    last_session = {
      description = {'  Recently laset session                 SPC s l'},
      command =  'SessionLoad'},
    find_history = {
      description = {'  Recently opened files                  SPC f h'},
      command =  'DashboardFindHistory'},
    find_file  = {
      description = {'  Find  File                             SPC f f'},
      command = 'Telescope find_files find_command=rg,--hidden,--files'},
    new_file = {
      description = {'  File Browser                           SPC f b'},
      command =  'Telescope file_browser'},
    find_word = {
      description = {'  Find  word                             SPC f w'},
      command = 'DashboardFindWord'},
    find_dotfiles = {
      description = {'  Open Personal dotfiles                 SPC f d'},
      command = 'Telescope dotfiles path=' .. home ..'/.dotfiles'},
  }
end

function config.set_colorscheme()
  vim.cmd('colorscheme base16-gruvbox-dark-hard')
end

function config.startify()
  local startify_header = {
      '',
      '      ▐▀▄      ▄▀▌   ▄▄▄▄▄▄▄',
      '      ▌▒▒▀▄▄▄▄▄▀▒▒▐▄▀▀▒██▒██▒▀▀▄',
      '     ▐▒▒▒▒▀▒▀▒▀▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▀▄',
      '     ▌▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▄▒▒▒▒▒▒▒▒▒▒▒▒▀▄',
      '   ▀█▒▒▒█▌▒▒█▒▒▐█▒▒▒▀▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▌',
      '   ▀▌▒▒▒▒▒▒▀▒▀▒▒▒▒▒▒▀▀▒▒▒▒▒▒▒▒▒▒▒▒▒▒▐   ▄▄',
      '   ▐▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▌▄█▒█',
      '   ▐▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▒█▀',
      '   ▐▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▀',
      '   ▐▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▌',
      '    ▌▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▐',
      '     ▐▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▌',
      '      ▐▄▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▄▌',
  }

  vim.g.startify_files_number           = 5
  vim.g.startify_update_oldfiles        = 1
  vim.g.startify_session_autoload       = 1
  vim.g.startify_session_persistence    = 1 -- autoupdate sessions
  vim.g.startify_session_delete_buffers = 1 -- delete all buffers when loading or closing a session, ignore unsaved buffers
  vim.g.startify_change_to_dir          = 0 -- when opening a file or bookmark, change to its directory
  vim.g.startify_fortune_use_unicode    = 1 -- beautiful symbols
  vim.g.startify_padding_left           = 3 --the number of spaces used for left padding
  vim.g.startify_session_remove_lines   = {'setlocal', 'winheight'} -- lines matching any of the patterns in this list, will be removed from the session file
  vim.g.startify_session_sort           = 1 -- sort sessions by alphabet or modification time

  vim.g.startify_custom_indices         = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18'} -- MRU indices

  vim.g.startify_custom_header          = startify_header
  vim.g.startify_session_dir            = os.getenv("HOME") .. '/.cache/vim/sessions/'

  vim.g.startify_commands = {
    {['pu'] = {'Update plugins',':PackerSync'}},
    {['ps'] = {'Plugins status', ':PackerStatus'}},
    {['h'] =  {'Help', ':help'}}
  }

  vim.g.startify_lists = {
    {
      ['type'] = 'dir',
      ['header'] = { string.format("   Current Files in %s", vim.fn.getcwd())},
    },
    {
      ['type'] = 'files',
      ['header'] = {[[   History]]}
    },
    {
      ['type'] = 'sessions',
      ['header'] = {[[   Sessions]]}
    },
    {
      ['type'] = 'bookmarks',
      ['header'] = {[[   Bookmarks]]}
    },
    {
      ['type'] = 'commands',
      ['header'] = {[[ גּ  Commands]]}
    }
  }

end

function config.nvim_tree()
  -- On Ready Event for Lazy Loading work
  require("nvim-tree.events").on_nvim_tree_ready(
    function()
      vim.cmd("NvimTreeRefresh")
    end
  )

  vim.g.nvim_tree_follow = 1
  vim.g.nvim_tree_hide_dotfiles = 0
  vim.g.nvim_tree_disable_netrw = 1
  vim.g.nvim_tree_hijack_netrw = 1
  vim.g.nvim_tree_indent_markers = 1
  vim.g.nvim_tree_disable_keybindings = 0
  vim.g.nvim_tree_ignore = { '.git', 'node_modules', '.cache' }

  local tree_cb = require("nvim-tree.config").nvim_tree_callback

  vim.g.nvim_tree_bindings = {
    -- ["<CR>"] = ":YourVimFunction()<cr>",
    -- ["u"] = ":lua require'some_module'.some_function()<cr>",

    -- default mappings
    ["l"] = tree_cb("edit"),
    ["o"] = tree_cb("edit"),
    ["<2-LeftMouse>"] = tree_cb("edit"),
    ["<2-RightMouse>"] = tree_cb("cd"),
    ["<C-]>"] = tree_cb("cd"),
    ["<C-v>"] = tree_cb("vsplit"),
    ["<C-s>"] = tree_cb("split"),
    ["<C-t>"] = tree_cb("tabnew"),
    ["<BS>"] = tree_cb("close_node"),
    ["<S-CR>"] = tree_cb("close_node"),
    ["<Tab>"] = tree_cb("preview"),
    ["I"] = tree_cb("toggle_ignored"),
    ["H"] = tree_cb("toggle_dotfiles"),
    ["R"] = tree_cb("refresh"),
    ["a"] = tree_cb("create"),
    ["d"] = tree_cb("remove"),
    ["r"] = tree_cb("rename"),
    ["<C-r>"] = tree_cb("full_rename"),
    ["x"] = tree_cb("cut"),
    ["c"] = tree_cb("copy"),
    ["p"] = tree_cb("paste"),
    ["-"] = tree_cb("dir_up"),
    ["q"] = tree_cb("close"),
    --       you have to set nvim_tree_show_icons.git = 1
    ["<A-UP>"] = tree_cb("prev_git_item"),
    ["<A-DOWN>"] = tree_cb("next_git_item"),
  }

  vim.g.nvim_tree_icons = {
    default =  '',
    symlink =  '',
    git = {
     unstaged = "✚",
     staged =  "✚",
     unmerged =  "≠",
     renamed =  "≫",
     untracked = "★",
    },
  }
end

function config.gitsigns()
  if not packer_plugins['plenary.nvim'].loaded then
    vim.cmd [[packadd plenary.nvim]]
  end
  require('gitsigns').setup {
    signs = {
      add = {hl = 'GitGutterAdd', text = '▋'},
      change = {hl = 'GitGutterChange',text= '▋'},
      delete = {hl= 'GitGutterDelete', text = '▋'},
      topdelete = {hl ='GitGutterDeleteChange',text = '▔'},
      changedelete = {hl = 'GitGutterChange', text = '▎'},
    },
    keymaps = {
       -- Default keymap options
       noremap = true,
       buffer = true,

       ['n <A-DOWN>'] = { expr = true, "&diff ? ']g' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'"},
       ['n <A-UP>'] = { expr = true, "&diff ? '[g' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'"},

       ['n <leader>ha'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
       ['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
       ['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
       ['n <leader>hP'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
       ['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line()<CR>',

       -- Text objects
       ['o ih'] = ':<C-U>lua require"gitsigns".text_object()<CR>',
       ['x ih'] = ':<C-U>lua require"gitsigns".text_object()<CR>'
     },
  }
end

function config.indent_blakline()
  vim.g.indent_blankline_char = "│"
  vim.g.indent_blankline_show_first_indent_level = true
  vim.g.indent_blankline_filetype_exclude = {
    "startify",
    "dashboard",
    "dotooagenda",
    "log",
    "fugitive",
    "gitcommit",
    "packer",
    "vimwiki",
    "markdown",
    "json",
    "txt",
    "vista",
    "help",
    "todoist",
    "NvimTree",
    "peekaboo",
    "git",
    "TelescopePrompt",
    "undotree",
    "flutterToolsOutline",
    "" -- for all buffers without a file type
  }
  vim.g.indent_blankline_buftype_exclude = {"terminal", "nofile"}
  vim.g.indent_blankline_show_trailing_blankline_indent = false
  vim.g.indent_blankline_show_current_context = true
  vim.g.indent_blankline_context_patterns = {
    "class",
    "function",
    "method",
    "block",
    "list_literal",
    "selector",
    "^if",
    "^table",
    "if_statement",
    "while",
    "for"
  }
  -- because lazy load indent-blankline so need readd this autocmd
  vim.cmd('autocmd CursorMoved * IndentBlanklineRefresh')
end

return config
