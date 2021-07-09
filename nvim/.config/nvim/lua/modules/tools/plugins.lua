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

tools["tpope/vim-fugitive"] = {
    event = "BufRead",
    opt = true,
    config = conf.fugitive,
    requires = {
        {"tpope/vim-rhubarb", opt = true}
    }
}

tools["sindrets/diffview.nvim"] = {
    event = "BufRead",
    cmd = "DiffviewOpen",
    opt = true
}

-- tools["TimUntersberger/neogit"] = {
--     event = "BufRead",
--     config = function()
--         require("neogit").setup {
--             disable_signs = false,
--             disable_context_highlighting = true,
--             signs = {
--                 -- { CLOSED, OPENED }
--                 section = {"", ""},
--                 item = {"+", "-"},
--                 hunk = {"", ""}
--             },
--             integrations = {
--                 diffview = true
--             }
--         }
--     end,
--     requires = {
--         "sindrets/diffview.nvim",
--         cmd = {"DiffViewOpen"},
--         opt = true,
--         module = "diffview"
--     }
-- }

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
    config = conf.orgmode_nvim
}

return tools
