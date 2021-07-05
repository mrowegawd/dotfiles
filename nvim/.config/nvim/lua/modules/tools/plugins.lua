local tools = {}
local conf = require("modules.tools.config")

tools["kristijanhusak/vim-dadbod-ui"] = {
    cmd = {"DBUIToggle", "DBUIAddConnection", "DBUI", "DBUIFindBuffer", "DBUIRenameBuffer"},
    config = conf.vim_dadbod_ui,
    requires = {{"tpope/vim-dadbod", opt = true}}
}

tools["editorconfig/editorconfig-vim"] = {
    ft = {"go", "typescript", "javascript", "vim", "rust", "zig", "c", "cpp"}
}

tools["windwp/nvim-autopairs"] = {
    requires = "tpope/vim-commentary"
}

tools["simrat39/symbols-outline.nvim"] = {
    cmd = "SymbolsOutline",
    opt = true
}

tools["windwp/nvim-spectre"] = {
    module = "spectre",
    wants = {"plenary.nvim", "popup.nvim"},
    config = conf.nvim_spectre,
    requires = {
        "nvim-lua/popup.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim"
    }
}

-- tools["tpope/vim-fugitive"] = {
--     event = "BufRead"
-- }

tools["TimUntersberger/neogit"] = {
    event = "BufRead",
    config = function()
        require("neogit").setup {
            disable_signs = false,
            disable_context_highlighting = true,
            signs = {
                -- { CLOSED, OPENED }
                section = {"", ""},
                item = {"+", "-"},
                hunk = {"", ""}
            },
            integrations = {
                diffview = true
            }
        }
    end,
    requires = {
        "sindrets/diffview.nvim",
        cmd = {"DiffViewOpen"},
        module = "diffview"
    }
}

tools["voldikss/vim-floaterm"] = {
    cmd = "FloatermToggle",
    opt = true,
    config = conf.vim_floaterm
}

tools["iamcco/markdown-preview.nvim"] = {
    ft = "markdown",
    run = function()
        vim.fn["mkdp#util#install"]()
    end,
    config = function()
        vim.g.mkdp_auto_start = 0
    end
}

-- tools["vimwiki/vimwiki"] = {
--     cmd = {"VimwikiIndex"},
--     opt = true
-- }

tools["fcpg/vim-waikiki"] = {
    ft = "markdown"
}

tools["ethanholz/nvim-lastplace"] = {
    config = function()
        require "nvim-lastplace".setup {
            lastplace_ignore_buftype = {"quickfix", "nofile", "help", "Outline"},
            lastplace_ignore_filetype = {"gitcommit", "gitrebase", "svn", "hgcommit", "NvimTree"},
            lastplace_open_folds = true
        }
    end
}

tools["tweekmonster/startuptime.vim"] = {
    cmd = {"StartupTime"}
}

tools["szw/vim-maximizer"] = {
    config = function()
        vim.g.maximizer_set_default_mapping = 0
    end
}

tools["folke/todo-comments.nvim"] = {
    cmd = {"TodoQuickFix"},
    config = conf.todo_comments,
    opt = true,
    require = {
        {"nvim-lua/plenary.nvim", opt = true}
    }
}

tools["kristijanhusak/orgmode.nvim"] = {
    event = "BufRead",
    config = function()
        require("orgmode").setup(
            {
                org_agenda_files = {"~/MrKampang/vimwiki/org/*"},
                org_default_notes_file = "~/MrKampang/vimwiki/org/refile.org",
                org_todo_keywords = {"TODO", "NEXT", "|", "DONE", "DELEGATED"},
                org_todo_keyword_faces = {
                    NEXT = ":background #0000ff :weight bold",
                    DELEGATED = ":background #FFFFFF :slant italic :underline on"
                },
                mappings = {
                    disable_all = false,
                    global = {
                        org_agenda = "<Leader>oa",
                        org_capture = "<Leader>oc"
                    },
                    agenda = {
                        org_agenda_later = "f",
                        org_agenda_earlier = "b",
                        org_agenda_goto_today = "~",
                        org_agenda_day_view = "vd",
                        org_agenda_week_view = "vw",
                        org_agenda_month_view = "vm",
                        org_agenda_year_view = "vy",
                        org_agenda_quit = "q",
                        org_agenda_switch_to = "<CR>",
                        org_agenda_goto = {"<TAB>"},
                        org_agenda_goto_date = "J",
                        org_agenda_redo = "r",
                        org_agenda_show_help = "?"
                    },
                    capture = {
                        org_capture_finalize = "<C-c>",
                        org_capture_refile = "<Leader>or",
                        org_capture_kill = "q",
                        org_capture_show_help = "?"
                    },
                    org = {
                        org_refile = "<Leader>or",
                        org_increase_date = "<C-a>",
                        org_decrease_date = "<C-x>",
                        org_change_date = "cid",
                        org_todo = "cit",
                        org_todo_prev = "ciT",
                        org_toggle_checkbox = "<C-c>",
                        org_open_at_point = "<Leader>oo",
                        org_cycle = "<TAB>",
                        org_global_cycle = "<S-TAB>",
                        org_archive_subtree = "<Leader>o$",
                        org_set_tags_command = "<Leader>ot",
                        org_toggle_archive_tag = "<Leader>oA",
                        org_do_promote = "<<",
                        org_do_demote = ">>",
                        org_promote_subtree = "<s",
                        org_demote_subtree = ">s",
                        org_meta_return = "<Leader><CR>", -- Add headling, item or row
                        org_insert_heading_respect_content = "<Leader>oih", -- Add new headling after current heading block with same level
                        org_insert_todo_heading = "<Leader>oiT", -- Add new todo headling right after current heading with same level
                        org_insert_todo_heading_respect_content = "<Leader>oit", -- Add new todo headling after current heading block on same level
                        org_move_subtree_up = "<Leader>oK",
                        org_move_subtree_down = "<Leader>oJ",
                        org_show_help = "?"
                    }
                }
            }
        )

        -- map <silent>gO :e ~/Dropbox/vimwiki/org/todo.org<CR>
        vim.cmd([[command! -nargs=0 NGrep grep! ".*" ~/MrKampang/vimwiki/org/*]])
    end
}

return tools
