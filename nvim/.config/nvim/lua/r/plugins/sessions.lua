local cmd, fn = vim.cmd, vim.fn

vim.g.ssession = false

return {
    -----------------------------------------------------------------------
    -- SESSION
    -----------------------------------------------------------------------
    -- PERSISTED NVIM (disabled)
    {
        "olimorris/persisted.nvim",
        enabled = function()
            if as.use_search_telescope then
                return true
            end
            return false
        end,
        lazy = false,
        init = function()
            -- as.command("ListSessions", "Telescope persisted")
            as.augroup("PersistedEvents", {
                event = "User",
                pattern = "PersistedTelescopeLoadPre",
                command = function()
                    vim.schedule(function()
                        cmd "%bd"
                    end)
                end,
            }, {
                event = "User",
                pattern = "PersistedSavePre",
                -- Arguments are always persisted in a session and can't be removed using 'sessionoptions'
                -- so remove them when saving a session
                command = function()
                    cmd "%argdelete"
                end,
            })

            require("legendary").keymaps {
                {
                    itemgroup = "Sessions",
                    icon = as.ui.icons.misc.pencil,
                    description = "Handling sessions",
                    commands = {
                        {
                            ":Sessions",
                            function()
                                return vim.cmd [[Telescope persisted]]
                            end,
                            description = "Persisted: list sessions",
                        },
                        {
                            ":SessionSave",
                            description = "Persisted: save the session",
                        },

                        {
                            ":SessionStop",
                            description = "Persisted: stop the current session",
                        },
                        {
                            ":SessionDelete",
                            description = "Persisted: delete the current session",
                        },
                    },
                    keymaps = {
                        {
                            "<Leader>sl",
                            function()
                                return cmd.SessionLoadLast()
                            end,
                            description = "Persisted: load a session",
                        },
                        {
                            "<Leader>ss",
                            function()
                                cmd.SessionStart()
                                return vim.notify "Sessions persisted: Started.."
                            end,
                            description = "Persisted: start a session",
                        },
                    },
                },
            }
        end,
        opts = {
            save_dir = fn.expand(fn.stdpath "data" .. "/sessions/"), -- directory where session files are saved
            autoload = true,
            use_git_branch = true,
            allowed_dirs = {
                vim.g.dotfiles,
                vim.g.work_dir,
                vim.g.projects_dir .. "/personal",
            },
            ignored_dirs = { fn.stdpath "data" },

            -- on_autoload_no_session = function()
            --     vim.schedule(function()
            --         cmd.Alpha()
            --     end)
            -- end,
            --
            -- should_autosave = function()
            --     return vim.bo.filetype ~= "alpha"
            --         or vim.bo.filetype == "oil"
            --         or vim.bo.filetype == "lazy"
            -- end,
        },
    },
    -- FOLKE-PERSISTENCE (disabled)
    {
        "folke/persistence.nvim",
        enabled = false,
        event = "BufReadPre",
        opts = {
            options = { "buffers", "curdir", "tabpages", "winsize", "help" },
        },
        keys = {
            {
                "<leader>qs",
                function()
                    require("persistence").load()
                end,
                desc = "Restore Session",
            },
            {
                "<leader>ql",
                function()
                    require("persistence").load { last = true }
                end,
                desc = "Restore Last Session",
            },
            {
                "<leader>qS",
                function()
                    require("persistence").stop()
                end,
                desc = "Don't Save Current Session",
            },
        },
    },
    -- NVIM-POSSESSION
    {
        "gennaro-tedesco/nvim-possession",
        -- event = "VeryLazy",
        dependencies = {
            "ibhagwan/fzf-lua",
        },
        enabled = true,

        config = function()
            require("nvim-possession").setup {
                autoload = false, -- whether to autoload sessions in the cwd at startup
                autosave = true, -- whether to autosave loaded sessions before quitting
                autoswitch = {
                    enable = true, -- default false
                },
            }
        end,
        init = function()
            require("legendary").keymaps {
                {
                    itemgroup = "Sessions",
                    icon = as.ui.icons.misc.pencil,
                    description = "Handling sessions",
                    keymaps = {
                        {
                            "<Leader>sl",
                            function()
                                local possession = require "nvim-possession"
                                return possession.list()
                            end,
                            description = "Possession: load a session",
                        },
                        {
                            "<Leader>ss",
                            function()
                                local possession = require "nvim-possession"
                                return possession.new()
                            end,
                            description = "Possession: start or save a session name",
                        },
                        {
                            "<Leader>su",
                            function()
                                local possession = require "nvim-possession"
                                return possession.update()
                            end,
                            description = "Possession: save a new session or overwrite it",
                        },
                    },
                },
            }
        end,
    },
    -- RESESSION (disabled)
    {
        "stevearc/resession.nvim",
        dependencies = {
            "stevearc/aerial.nvim",
            "stevearc/overseer.nvim",
            -- "stevearc/three.nvim",
            "stevearc/oil.nvim",
        },
        event = "VeryLazy",
        enabled = false,
        -- enabled = function()
        --     if as.use_search_telescope then
        --         return false
        --     end
        --     return true
        -- end,
        init = function()
            require("legendary").keymaps {
                {
                    itemgroup = "Sessions",
                    icon = as.ui.icons.misc.pencil,
                    description = "Handling sessions",
                    keymaps = {
                        {
                            "<Leader>sl",
                            function()
                                local resession = require "resession"
                                return resession.load(nil, { reset = false })
                            end,
                            description = "Possession: load a session",
                        },
                        {
                            "<Leader>ss",
                            function()
                                local resession = require "resession"
                                return resession.save()
                            end,
                            description = "Possession: start a session",
                        },
                        {
                            "<Leader>su",
                            function()
                                local possession = require "nvim-possession"
                                return possession.update()
                            end,
                            description = "Possession: save a new session or overwrite it",
                        },
                    },
                },
            }
        end,
        config = function()
            local resession = require "resession"

            -- local aug = vim.api.nvim_create_augroup("StevearcResession", {})

            local visible_buffers = {}

            resession.setup {
                autosave = {
                    enabled = true,
                    notify = false,
                },
                tab_buf_filter = function(tabpage, bufnr)
                    local dir = vim.fn.getcwd(
                        -1,
                        vim.api.nvim_tabpage_get_number(tabpage)
                    )
                    return vim.startswith(vim.api.nvim_buf_get_name(bufnr), dir)
                end,
                buf_filter = function(bufnr)
                    if not resession.default_buf_filter(bufnr) then
                        return false
                    end
                    return visible_buffers[bufnr]
                        or require("three").is_buffer_in_any_tab(bufnr)
                end,
                extensions = {
                    aerial = {},
                    overseer = {},
                    quickfix = {},
                    three = {},
                    config_local = {},
                    -- oil = {},
                },
            }

            --     resession.add_hook("pre_save", function()
            --         visible_buffers = {}
            --         for _, winid in ipairs(vim.api.nvim_list_wins()) do
            --             if vim.api.nvim_win_is_valid(winid) then
            --                 visible_buffers[vim.api.nvim_win_get_buf(winid)] = winid
            --             end
            --         end
            --     end)
            --
            --     vim.keymap.set(
            --         "n",
            --         "<leader>ss",
            --         resession.save,
            --         { desc = "[S]ession [S]ave" }
            --     )
            --     vim.keymap.set("n", "<leader>st", function()
            --         resession.save_tab()
            --     end, { desc = "[S]ession save [T]ab" })
            --     vim.keymap.set(
            --         "n",
            --         "<leader>so",
            --         resession.load,
            --         { desc = "[S]ession [O]pen" }
            --     )
            --     vim.keymap.set("n", "<leader>sl", function()
            --         resession.load(nil, { reset = false })
            --     end, { desc = "[S]ession [L]oad without reset" })
            --     vim.keymap.set(
            --         "n",
            --         "<leader>sd",
            --         resession.delete,
            --         { desc = "[S]ession [D]elete" }
            --     )
            --     vim.api.nvim_create_user_command("SessionDetach", function()
            --         resession.detach()
            --     end, {})
            --     vim.keymap.set("n", "ZZ", function()
            --         resession.save("__quicksave__", { notify = false })
            --         vim.cmd "wa"
            --         vim.cmd "qa"
            --     end)
            --
            --     if vim.tbl_contains(resession.list(), "__quicksave__") then
            --         vim.defer_fn(function()
            --             resession.load("__quicksave__", { attach = false })
            --             local ok, err = pcall(resession.delete, "__quicksave__")
            --             if not ok then
            --                 vim.notify(
            --                     string.format(
            --                         "Error deleting quicksave session: %s",
            --                         err
            --                     ),
            --                     vim.log.levels.WARN
            --                 )
            --             end
            --         end, 50)
            --     end
            --
            --     vim.api.nvim_create_autocmd("VimLeavePre", {
            --         group = aug,
            --         callback = function()
            --             resession.save "last"
            --         end,
            --     })
        end,
    },
    -----------------------------------------------------------------------
    -- PROJECTS
    -----------------------------------------------------------------------
    -- PROJECTS.NVIM
    {
        "ahmedkhalf/project.nvim",
        enabled = true,
        event = "BufReadPre",
        init = function()
            require("legendary").keymaps {
                {
                    itemgroup = "Misc",
                    keymaps = {
                        -- Provide fzf-lua integration
                        -- taken from: https://github.com/ahmedkhalf/project.nvim/issues/99
                        {
                            "<leader>fp",
                            function()
                                local contents =
                                    require("project_nvim").get_recent_projects()
                                local reverse = {}
                                for i = #contents, 1, -1 do
                                    reverse[#reverse + 1] = contents[i]
                                end
                                return require("fzf-lua").fzf_exec(reverse, {
                                    actions = {
                                        ["default"] = function(e)
                                            vim.cmd.cd(e[1])
                                        end,
                                        ["ctrl-d"] = function(x)
                                            local choice = vim.fn.confirm(
                                                "Delete '"
                                                    .. #x
                                                    .. "' projects? ",
                                                "&Yes\n&No",
                                                2
                                            )
                                            if choice == 1 then
                                                local history =
                                                    require "project_nvim.utils.history"
                                                for _, v in ipairs(x) do
                                                    history.delete_project(v)
                                                end
                                            end
                                        end,
                                    },
                                })
                            end,
                            description = "Projects: open list [FZF-LUA]",
                        },
                    },
                },
            }
        end,

        config = function()
            require("project_nvim").setup {
                -- Manual mode doesn't automatically change your root directory, so you have
                -- the option to manually do so using `:ProjectRoot` command.
                manual_mode = true,

                -- Methods of detecting the root directory. **"lsp"** uses the native neovim
                -- lsp, while **"pattern"** uses vim-rooter like glob pattern matching. Here
                -- order matters: if one is not detected, the other is used as fallback. You
                -- can also delete or rearangne the detection methods.
                detection_methods = { "pattern" },

                -- All the patterns used to detect root dir, when **"pattern"** is in
                -- detection_methods
                patterns = {
                    -- ".git",
                    -- "_darcs",
                    -- ".hg",
                    -- ".bzr",
                    -- ".svn",
                    -- "Makefile",
                    -- "package.json",
                },

                -- When set to false, you will get a message when project.nvim changes your
                -- directory.
                silent_chdir = false,
            }
        end,
    },
}
