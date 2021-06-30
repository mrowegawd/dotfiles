local config = {}

function config.galaxyline()
    require("modules.ui.galaxyline")
end

function config.lualine()
    require("modules.ui.lualine")
end

function config.nvim_bufferline()
    require("bufferline").setup {
        options = {
            modified_icon = "✥",
            buffer_close_icon = "",
            mappings = true,
            always_show_bufferline = true
        }
    }
end

function config.dashboard()
    local home = os.getenv("HOME")
    vim.g.dashboard_footer_icon = "🐬 "
    vim.g.dashboard_preview_command = "cat"
    vim.g.dashboard_preview_pipeline = "lolcat -F 0.2"
    vim.g.dashboard_preview_file = home .. "/.config/nvim/static/neovim.cat"
    vim.g.dashboard_preview_file_height = 15
    vim.g.dashboard_preview_file_width = 80
    vim.g.dashboard_default_executive = "telescope"
    vim.g.dashboard_custom_section = {
        last_session = {
            description = {"  Recently laset session                 SPC s l"},
            command = "SessionLoad"
        },
        find_history = {
            description = {"  Recently opened files                  SPC f h"},
            command = "DashboardFindHistory"
        },
        find_file = {
            description = {"  Find  File                             SPC f f"},
            command = "Telescope find_files find_command=rg,--hidden,--files"
        },
        new_file = {
            description = {"  File Browser                           SPC f b"},
            command = "Telescope file_browser"
        },
        find_word = {
            description = {"  Find  word                             SPC f w"},
            command = "DashboardFindWord"
        },
        find_dotfiles = {
            description = {"  Open Personal dotfiles                 SPC f d"},
            command = "Telescope dotfiles path=" .. home .. "/.dotfiles"
        }
    }
end

function config.set_colorscheme()
    vim.cmd("colorscheme base16-gruvbox-dark-hard")
end

function config.startify()
    local startify_header = {
        "",
        "      ▐▀▄      ▄▀▌   ▄▄▄▄▄▄▄",
        "      ▌▒▒▀▄▄▄▄▄▀▒▒▐▄▀▀▒██▒██▒▀▀▄",
        "     ▐▒▒▒▒▀▒▀▒▀▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▀▄",
        "     ▌▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▄▒▒▒▒▒▒▒▒▒▒▒▒▀▄",
        "   ▀█▒▒▒█▌▒▒█▒▒▐█▒▒▒▀▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▌",
        "   ▀▌▒▒▒▒▒▒▀▒▀▒▒▒▒▒▒▀▀▒▒▒▒▒▒▒▒▒▒▒▒▒▒▐   ▄▄",
        "   ▐▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▌▄█▒█",
        "   ▐▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▒█▀",
        "   ▐▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▀",
        "   ▐▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▌",
        "    ▌▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▐",
        "     ▐▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▌",
        "      ▐▄▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▄▌"
    }

    vim.g.startify_files_number = 5
    vim.g.startify_update_oldfiles = 1
    vim.g.startify_session_autoload = 1
    vim.g.startify_session_persistence = 1 -- autoupdate sessions
    vim.g.startify_session_delete_buffers = 1 -- delete all buffers when loading or closing a session, ignore unsaved buffers
    vim.g.startify_change_to_dir = 0 -- when opening a file or bookmark, change to its directory
    vim.g.startify_fortune_use_unicode = 1 -- beautiful symbols
    vim.g.startify_padding_left = 3 --the number of spaces used for left padding
    vim.g.startify_session_remove_lines = {"setlocal", "winheight"} -- lines matching any of the patterns in this list, will be removed from the session file
    vim.g.startify_session_sort = 1 -- sort sessions by alphabet or modification time

    vim.g.startify_custom_indices = {
        "1",
        "2",
        "3",
        "4",
        "5",
        "6",
        "7",
        "8",
        "9",
        "10",
        "11",
        "12",
        "13",
        "14",
        "15",
        "16",
        "17",
        "18"
    } -- MRU indices

    vim.g.startify_custom_header = startify_header
    vim.g.startify_session_dir = os.getenv("HOME") .. "/.cache/vim/sessions/"

    vim.g.startify_commands = {
        {["pu"] = {"Update plugins", ":PackerSync"}},
        {["ps"] = {"Plugins status", ":PackerStatus"}},
        {["h"] = {"Help", ":help"}}
    }

    vim.g.startify_lists = {
        {
            ["type"] = "dir",
            ["header"] = {string.format("   Current Files in %s", vim.fn.getcwd())}
        },
        {
            ["type"] = "files",
            ["header"] = {[[   History]]}
        },
        {
            ["type"] = "sessions",
            ["header"] = {[[   Sessions]]}
        },
        {
            ["type"] = "bookmarks",
            ["header"] = {[[   Bookmarks]]}
        },
        {
            ["type"] = "commands",
            ["header"] = {[[ גּ  Commands]]}
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

    vim.g.nvim_tree_follow = 0
    vim.g.nvim_tree_hide_dotfiles = 0
    vim.g.nvim_tree_disable_netrw = 1
    vim.g.nvim_tree_hijack_netrw = 1
    vim.g.nvim_tree_indent_markers = 1
    vim.g.nvim_tree_disable_keybindings = 0
    vim.g.nvim_tree_ignore = {".git", "node_modules", ".cache"}

    local tree_cb = require("nvim-tree.config").nvim_tree_callback

    vim.g.nvim_tree_bindings = {
        {key = {"<CR>", "o", "<2-LeftMouse>", "l"}, cb = tree_cb("edit")},
        {key = {"<2-RightMouse>", "<C-}>"}, cb = tree_cb("cd")},
        {key = "<C-v>", cb = tree_cb("vsplit")},
        {key = "<C-s>", cb = tree_cb("split")},
        {key = "<C-t>", cb = tree_cb("tabnew")},
        {key = "<", cb = tree_cb("prev_sibling")},
        {key = ">", cb = tree_cb("next_sibling")},
        {key = "P", cb = tree_cb("parent_node")},
        {key = "<BS>", cb = tree_cb("close_node")},
        {key = "<S-CR>", cb = tree_cb("close_node")},
        {key = "<Tab>", cb = tree_cb("preview")},
        {key = "K", cb = tree_cb("first_sibling")},
        {key = "J", cb = tree_cb("last_sibling")},
        {key = "I", cb = tree_cb("toggle_ignored")},
        {key = "H", cb = tree_cb("toggle_dotfiles")},
        {key = "R", cb = tree_cb("refresh")},
        {key = "a", cb = tree_cb("create")},
        {key = "d", cb = tree_cb("remove")},
        {key = "r", cb = tree_cb("rename")},
        {key = "<C->", cb = tree_cb("full_rename")},
        {key = "x", cb = tree_cb("cut")},
        {key = "c", cb = tree_cb("copy")},
        {key = "p", cb = tree_cb("paste")},
        {key = "y", cb = tree_cb("copy_name")},
        {key = "Y", cb = tree_cb("copy_path")},
        {key = "gy", cb = tree_cb("copy_absolute_path")},
        {key = "-", cb = tree_cb("dir_up")},
        {key = "q", cb = tree_cb("close")},
        {key = "g?", cb = tree_cb("toggle_help")},
        {key = "<A-UP>", cb = tree_cb("prev_git_item")},
        {key = "<A-DOWN>", cb = tree_cb("next_git_item")}
        -- ["<CR>"] = ":YourVimFunction()<cr>",
        -- ["u"] = ":lua require'some_module'.some_function()<cr>",
    }

    vim.g.nvim_tree_icons = {
        default = "",
        symlink = "",
        git = {
            unstaged = "✚",
            staged = "✚",
            unmerged = "≠",
            renamed = "≫",
            untracked = "★"
        }
    }
end

function config.gitsigns()
    if not packer_plugins["plenary.nvim"].loaded then
        vim.cmd [[packadd plenary.nvim]]
    end
    require("gitsigns").setup {
        signs = {
            -- add = {hl = "GitGutterAdd", text = "▋"},
            -- change = {hl = "GitGutterChange", text = "▋"},
            -- delete = {hl = "GitGutterDelete", text = "▋"},
            -- topdelete = {hl = "GitGutterDeleteChange", text = "▔"},
            -- changedelete = {hl = "GitGutterChange", text = "▎"}

            add = {hl = "GitSignsAdd", text = "▍", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn"},
            change = {
                hl = "GitSignsChange",
                text = "▍",
                numhl = "GitSignsChangeNr",
                linehl = "GitSignsChangeLn"
            },
            delete = {
                hl = "GitSignsDelete",
                text = "▸",
                numhl = "GitSignsDeleteNr",
                linehl = "GitSignsDeleteLn"
            },
            topdelete = {
                hl = "GitSignsDelete",
                text = "▾",
                numhl = "GitSignsDeleteNr",
                linehl = "GitSignsDeleteLn"
            },
            changedelete = {
                hl = "GitSignsChange",
                text = "▍",
                numhl = "GitSignsChangeNr",
                linehl = "GitSignsChangeLn"
            }
        },
        numhl = false,
        linehl = false,
        keymaps = {
            -- Default keymap options
            noremap = true,
            buffer = true,
            ["n <A-DOWN>"] = {expr = true, '&diff ? \']g\' : \'<cmd>lua require"gitsigns".next_hunk()<CR>\''},
            ["n <A-UP>"] = {expr = true, '&diff ? \'[g\' : \'<cmd>lua require"gitsigns".prev_hunk()<CR>\''},
            ["n <leader>ha"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
            ["n <leader>hu"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
            ["n <leader>hr"] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
            ["n <leader>hP"] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
            ["n <leader>hb"] = '<cmd>lua require"gitsigns".blame_line()<CR>',
            -- Text objects
            ["o ih"] = ':<C-U>lua require"gitsigns".text_object()<CR>zz',
            ["x ih"] = ':<C-U>lua require"gitsigns".text_object()<CR>zz'
        },
        watch_index = {interval = 1000},
        sign_priority = 6,
        update_debounce = 200,
        status_formatter = nil, -- Use default
        use_decoration_api = false
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
    vim.cmd("autocmd CursorMoved * IndentBlanklineRefresh")
end

return config
