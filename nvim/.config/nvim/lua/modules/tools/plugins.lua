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
    event = "BufReadPre",
    requires = "tpope/vim-commentary"
}

tools["simrat39/symbols-outline.nvim"] = {
    cmd = "SymbolsOutline",
    config = function()
    end
}

tools["windwp/nvim-spectre"] = {
    module = "spectre",
    wants = {"plenary.nvim", "popup.nvim"},
    requires = {"nvim-lua/popup.nvim", "nvim-lua/plenary.nvim"},
    config = function()
        require("spectre").setup(
            {
                find_engine = {
                    -- rg is map with finder_cmd
                    ["rg"] = {
                        cmd = "rg",
                        -- default args
                        args = {
                            "--hidden",
                            "--follow",
                            "--no-ignore-vcs",
                            "-g",
                            "!{node_modules,.git,__pycache__,.pytest_cache}",
                            "--no-heading",
                            "--with-filename",
                            "--line-number",
                            "--column",
                            "--smart-case"
                        }
                    }
                }
            }
        )
    end
}

tools["tpope/vim-fugitive"] = {}

tools["voldikss/vim-floaterm"] = {
    cmd = "FloatermToggle",
    opt = true,
    config = conf.vim_floaterm
}

tools["iamcco/markdown-preview.nvim"] = {
    ft = "markdown",
    config = function()
        vim.g.mkdp_auto_start = 0
    end
}

-- tools["vimwiki/vimwiki"] = {
--     cmd = {"VimwikiIndex"},
--     opt = true
-- }

tools["tweekmonster/startuptime.vim"] = {
    cmd = {"StartupTime"}
}

tools["szw/vim-maximizer"] = {
    config = function()
        vim.g.maximizer_set_default_mapping = 0
    end
}

-- tools["dhruvasagar/vim-dotoo"] = {
--     event = {"BufRead", "BufNewFile"},
--     config = conf.vim_dotoo
-- }

tools["folke/todo-comments.nvim"] = {
    cmd = {"TodoQuickFix"},
    config = conf.todo_comments,
    opt = true,
    require = {
        {"nvim-lua/plenary.nvim", opt = true}
    }
}

tools["sindrets/diffview.nvim"] = {
    cmd = {"DiffviewOpen"},
    opt = true,
    config = conf.diffview
}

return tools
