local fmt, cmd, fn = string.format, vim.cmd, vim.fn

local M = {}

function M.neorg_mappings_ft(bufnr)
    local neorg = require "neorg"
    local fzf_lua = require "fzf-lua"

    require("legendary").keymaps {
        itemgroup = "Notes",
        keymaps = {

            {
                "<leader>tq",
                function()
                    return cmd(fmt("TODOQuickfixList cwd=%s", fn.expand "%:p"))
                end,
                opts = { buffer = bufnr },
                description = "Todocomment: find todo buffer",
            },
            {
                "<leader>tQ",
                function()
                    return cmd(fmt([[TODOQuickfixList cwd=%s]], as.wiki_path))
                end,
                opts = { buffer = bufnr },
                description = "Todocomment: find all todo",
            },
            {
                "<localleader>fw",
                function()
                    -- Karena use grep utk curbuf, agar bisa menggunakan regex
                    -- pakai `lgrep_curbuf`
                    require("fzf-lua").lgrep_curbuf {
                        prompt = "[Neorg] Linkable❯ ",
                        search = [[\{:\$]],
                        no_esc = true,
                    }
                end,
                opts = { buffer = bufnr },
                description = "FzfLua: find linkable curbuf",
            },
            {
                "<localleader>fW",
                function()
                    require("fzf-lua").lgrep_curbuf {
                        prompt = "[Neorg] Linksite❯ ",
                        search = [[http(s|)://]],
                        no_esc = true,
                    }
                end,
                opts = { buffer = bufnr },
                description = "Fzflua: find site links",
            },

            {
                "<localleader>ff",
                function()
                    require("fzf-lua").files {
                        prompt = "[Neorg] Files❯ ",
                        cmd = "rg --files --iglob=*.norg",
                        cwd = as.wiki_path,
                        winopts = { fullscreen = true },
                    }
                end,
                opts = { buffer = bufnr },
                description = "Fzflua: files",
            },
            {
                "<localleader>fT",
                function()
                    require("fzf-lua").live_grep {
                        prompt = "[Neorg] TitleAll❯ ",
                        cwd = as.wiki_path,
                        no_esc = true,
                        search = [[(^\*|\*\*).*$]],
                        -- cmd = "rg --iglob=*.norg",
                        winopts = { fullscreen = true },
                    }
                end,
                opts = { buffer = bufnr },
                description = "Fzflua: find all titles",
            },

            {
                "<localleader>ft",
                function()
                    require("fzf-lua").lgrep_curbuf {
                        prompt = "[Neorg] Title❯ ",
                        search = [[(^\*|\*\*).*$]],
                        no_esc = true,
                        winopts = {
                            relative = "cursor",
                            height = 0.40,
                            width = 0.90,
                        },
                    }
                end,
                opts = { buffer = bufnr },
                description = "Fzflua: find title buffer",
            },
            {
                "<localleader>fo",
                function()
                    cmd "normal yi}"
                    local title = vim.fn.getreg '"0'
                    local title_trim = title:gsub([[^:%$]], [[:\$]])

                    require("fzf-lua").live_grep {
                        prompt = "[Neorg] Find Friend Notes❯ ",
                        cwd = as.wiki_path,
                        no_esc = true,
                        search = title_trim,
                        winopts = {
                            fullscreen = true,
                            preview = {
                                layout = "vertical",
                            },
                        },
                    }
                end,
                opts = { buffer = bufnr },
                description = "Fzlua: find friend notes",
            },
            {
                "<c-v>",
                function()
                    local opts = {
                        prompt = "[Neorg] linkable❯ ",

                        fn_transform = function(entry)
                            vim.notify(entry[1])
                        end,

                        fzf_opts = {
                            ["--preview"] = fzf_lua.shell.preview_action_cmd(
                                function(items)
                                    local selection = items[1]:match "[^%s]+"
                                        .. ".norg"
                                    selection = os.getenv "HOME"
                                        .. "/Dropbox/neorg/"
                                        .. selection

                                    return "cat " .. selection
                                end
                            ),
                        },

                        actions = {
                            ["default"] = function(selected, _)
                                local selection = selected[1]

                                local link_path = selection:match "[^%s]+"

                                local title = selection:match "*.+$"
                                local trim_title = string.gsub(title, "*", "")

                                vim.api.nvim_put({
                                    "{:$/"
                                        .. link_path
                                        .. ":"
                                        .. title
                                        .. "}["
                                        .. trim_title
                                        .. "]",
                                }, "c", false, true)

                                vim.api.nvim_feedkeys("hf]a", "t", false)
                            end,
                        },
                    }

                    return require("fzf-lua").fzf_exec(
                        require("r.utils.neorg_notes").finder_linkable(neorg),
                        opts
                    )
                end,
                mode = { "i" },
                opts = { buffer = bufnr },
                description = "Fzflua: insert linkable",
            },
        },
    }
end

return M
