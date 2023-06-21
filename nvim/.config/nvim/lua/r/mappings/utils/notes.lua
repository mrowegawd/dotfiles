local fmt, cmd, fn = string.format, vim.cmd, vim.fn

local M = {}

function M.neorg_mappings_ft(bufnr)
    local neorg = require "neorg"
    local fzf_lua = require "fzf-lua"

    local mappings = {
        ["n"] = {
            ["<leader>tq"] = {

                function()
                    return cmd(fmt("TODOQuickfixList cwd=%s", fn.expand "%:p"))
                end,
                "Todocomment: find todo buffer",
            },
            ["<leader>tQ"] = {
                function()
                    return cmd(fmt([[TODOQuickfixList cwd=%s]], as.wiki_path))
                end,
                "Todocomment: find all todo",
            },
            ["f<CR>"] = {
                function()
                    require("fzf-lua").files {
                        prompt = "[Neorg] Files❯ ",
                        cmd = "rg --files --iglob=*.norg",
                        cwd = as.wiki_path,
                        winopts = { fullscreen = true },
                    }
                end,
                "Fzflua: files",
            },
            ["T<CR>"] = {
                function()
                    require("fzf-lua").live_grep {
                        prompt = "[Neorg] TitleGlobal❯ ",
                        cwd = as.wiki_path,
                        no_esc = true,
                        search = [[^(\*|\*\*|\*\*\*|\*\*\*\*).*$]],
                        fzf_opts = { ["--layout"] = "reverse" },
                        winopts = {
                            fullscreen = true,
                            preview = {
                                layout = "vertical",
                                vertical = "up:55%",
                            },
                        },
                    }
                end,
                "Fzflua: find all titles",
            },
            ["t<CR>"] = {
                function()
                    require("fzf-lua").lgrep_curbuf {
                        prompt = "[Neorg] Title❯ ",
                        search = [[^(\*|\*\*|\*\*\*|\*\*\*\*).*$]],
                        no_esc = true,
                        split = "belowright new | wincmd J | resize 40",
                        winopts = {
                            -- relative = "cursor",
                            -- height = 0.40,
                            -- width = 0.90,
                            preview = {
                                layout = "vertical",
                                vertical = "up:55%",
                            },
                        },
                    }
                end,
                "Fzflua: find title buffer",
            },
            ["g<CR>"] = {
                function()
                    cmd "normal yi}"
                    local title = vim.fn.getreg '"0'
                    local title_trim = title:gsub([[^:%$]], [[:\$]])

                    vim.notify("find: " .. title_trim)

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
                "Fzlua: find friend notes",
            },
            ["l<CR>"] = {
                function()
                    -- Karena use grep utk curbuf, agar bisa menggunakan regex
                    -- pakai `lgrep_curbuf`
                    require("fzf-lua").lgrep_curbuf {
                        prompt = "[Neorg] Linkable❯ ",
                        search = [[(\{:\$|\{http)]],
                        no_esc = true,
                        winopts = {
                            split = "belowright new | wincmd J | resize 40",
                            fullscreen = true,
                            preview = {
                                layout = "vertical",
                                vertical = "up:55%",
                            },
                        },
                    }
                end,
                "FzfLua: find linkable",
            },

            ["lb"] = {
                function()
                    require("r.utils.neorg_notes").get_check_linkdir(neorg)
                end,
                "Fzflua: search local broken link",
            },
            ["lB"] = {
                function()
                    print "searching global broken link: not implemented yet"
                end,
                "Fzflua: search global broken link",
            },
        },

        ["i"] = {
            ["l<cr>"] = {
                function()
                    local opts = {
                        prompt = "[Neorg] InsertSitelinkable❯ ",
                        actions = {
                            ["default"] = function(selected, _)
                                local selection = selected[1]
                                local str_path = selection:match "%[(.*)%]"

                                vim.api.nvim_put({
                                    "[" .. str_path .. "]",
                                }, "c", false, true)

                                vim.api.nvim_feedkeys("hf]a", "t", false)
                            end,
                        },
                    }

                    return require("fzf-lua").fzf_exec(
                        require("r.utils.neorg_notes").finder_sitelinkable(
                            neorg
                        ),
                        opts
                    )
                end,

                "Fzflua: insert sitelinkable curbuf",
            },
            ["t<cr>"] = {
                function()
                    local opts = {
                        prompt = "[Neorg] InsertLinkable❯ ",
                        actions = {
                            ["default"] = function(selected, _)
                                local selection = selected[1]
                                local str_path = string.gsub(
                                    selection:match "|.*$",
                                    "| ",
                                    ""
                                )

                                -- print(str_path)

                                vim.api.nvim_put({
                                    "{" .. str_path .. "}",
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

                "Fzflua: insert linkable curbuf",
            },

            ["T<cr>"] = {
                function()
                    local opts = {
                        -- fn_transform = function(entry)
                        --     vim.notify(entry[1])
                        -- end,
                        prompt = "[Neorg] InsertLinkableGlobal❯ ",
                        winopts = {
                            split = "belowright new | wincmd J | resize 40",
                            preview = {
                                layout = "vertical",
                                vertical = "up:55%",
                            },
                        },
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
                                    "["
                                        .. trim_title
                                        .. "]"
                                        .. "{:$/"
                                        .. link_path
                                        .. ":"
                                        .. title
                                        .. "}",
                                }, "c", false, true)

                                vim.api.nvim_feedkeys("hf]a", "t", false)
                            end,
                        },
                    }

                    return require("fzf-lua").fzf_exec(
                        require("r.utils.neorg_notes").finder_linkableGlobal(
                            neorg
                        ),
                        opts
                    )
                end,
                "Fzflua: insert linkable global",
            },
        },
    }

    local resuffle = {}
    for i, x in pairs(mappings) do
        if i == "i" then
            for g, gg in pairs(x) do
                table.insert(resuffle, {
                    g,
                    gg[1],
                    description = gg[2],
                    mode = { "i" },
                    opts = { buffer = bufnr },
                })
            end
        else
            for j, jj in pairs(x) do
                table.insert(resuffle, {
                    j,
                    jj[1],
                    description = jj[2],
                    opts = { buffer = bufnr },
                })
            end
        end
    end

    require("legendary").keymaps {
        itemgroup = "Notes",
        keymaps = resuffle,
    }
end

return M
