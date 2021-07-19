local tools = {}
local conf = require("modules.tools.config")

tools["kristijanhusak/vim-dadbod-ui"] = {
    cmd = {"DBUIToggle", "DBUIAddConnection", "DBUI", "DBUIFindBuffer", "DBUIRenameBuffer"},
    config = conf.vim_dadbod_ui,
    requires = {{"tpope/vim-dadbod", opt = true}}
}

tools["simrat39/symbols-outline.nvim"] = {
    cmd = "SymbolsOutline",
    opt = true
}

tools["windwp/nvim-spectre"] = {
    module = "spectre",
    event = "WinEnter",
    config = conf.nvim_spectre
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
    cmd = "TodoQuickFix",
    config = conf.todo_comments,
    disable = not true
}

tools["folke/trouble.nvim"] = {
    cmd = "TroubleToggle",
    disable = not true
}

-------------------------------------------------------------------------------
-- TERMINAL                                                                  --
-------------------------------------------------------------------------------

tools["voldikss/vim-floaterm"] = {
    cmd = "FloatermToggle",
    opt = true,
    config = conf.vim_floaterm
}

-------------------------------------------------------------------------------
-- GIT                                                                       --
-------------------------------------------------------------------------------

tools["tpope/vim-fugitive"] = {
    event = "BufRead",
    opt = true,
    config = conf.fugitive
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

-------------------------------------------------------------------------------
-- SESSIONS                                                                  --
-------------------------------------------------------------------------------

tools["rmagatti/auto-session"] = {
    config = conf.session
}

tools["rmagatti/session-lens"] = {
    cmd = "SearchSession",
    config = function()
        require("session-lens").setup {
            shorten_path = true,
            previewer = true
        }
    end
}

-------------------------------------------------------------------------------
-- WIKI NOTES                                                                --
-------------------------------------------------------------------------------

tools["kristijanhusak/orgmode.nvim"] = {
    -- event = "BufRead",
    -- do not use lazy loading read this
    -- https://github.com/kristijanhusak/orgmode.nvim#installation
    config = conf.orgmode_nvim
}

tools["akinsho/org-bullets.nvim"] = {
    after = "orgmode.nvim",
    config = function()
        require("org-bullets").setup {
            symbols = {"◉", "○", "✸", "✿"}
            -- or a function that receives the defaults and returns a list
            -- symbols = function(default_list)
            --   table.insert(default_list, "♥")
            --   return default_list
            -- end
        }
    end
}

tools["vhyrro/neorg"] = {
    config = function()
        require("neorg").setup {
            load = {
                ["core.defaults"] = {},
                ["core.norg.concealer"] = {}
            }
        }
    end
}

return tools
