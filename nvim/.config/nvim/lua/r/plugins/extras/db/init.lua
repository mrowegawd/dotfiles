return {
    -- VIM-DADBOD
    {
        "tpope/vim-dadbod",
        cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection" },
        init = function()
            require("legendary").keymaps {
                {
                    itemgroup = "DB",
                    description = "Database for actions!",
                    icon = as.ui.icons.misc.gear,
                    keymaps = {
                        {
                            "<Leader>Dt",
                            "<CMD>DBUIToggle<CR>",
                            description = "Dadbod toggle UI",
                        },
                        {
                            "<Leader>Df",
                            "<CMD>DBUIFindBuffer<CR>",
                            description = "Find buffer",
                        },

                        {
                            "<leader>Dr",
                            "<CMD>DBUIRenameBuffer<cr>",
                            description = "Rename Buffer",
                        },

                        {
                            "<leader>Dq",
                            "<CMD>DBUILastQueryInfo<cr>",
                            description = "Last Query Info",
                        },
                    },
                },
            }
        end,
        dependencies = {
            "kristijanhusak/vim-dadbod-ui",
            "kristijanhusak/vim-dadbod-completion",
        },
        opts = {
            db_competion = function()
                require("cmp").setup.buffer {
                    sources = { { name = "vim-dadbod-completion" } },
                }
            end,
        },
        config = function(_, opts)
            vim.g.db_ui_save_location = vim.fn.stdpath "config"
                .. require("plenary.path").path.sep
                .. "db_ui"

            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "sql",
                },
                command = [[setlocal omnifunc=vim_dadbod_completion#omni]],
            })

            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "sql",
                    "mysql",
                    "plsql",
                },
                callback = function()
                    vim.schedule(opts.db_completion)
                end,
            })
        end,
    },
}
