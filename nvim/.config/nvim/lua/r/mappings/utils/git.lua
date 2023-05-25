local M = {}

function M.diffview(bufnr)
    require("legendary").keymaps {
        {
            itemgroup = "Git",
            keymaps = {
                {
                    "<Leader>hD",
                    "<CMD>DiffviewOpen<CR>",
                    description = "Diffview: open",
                    opts = { buffer = bufnr },
                },
                {
                    "<Leader>hd",
                    "<CMD>DiffviewFileHistory<CR>",
                    description = "Diffview: open all history",
                    opts = { buffer = bufnr },
                },
                {
                    "<Leader>hd",
                    [[:'<'>DiffviewFileHistory<CR>]],
                    description = "Diffview: file history",
                    mode = { "v" },
                    opts = { buffer = bufnr },
                },
                -- {
                --     "<Leader>hdH",
                --     "<CMD>DiffviewFileHistory %<CR>",
                --     description = "Diffview: check all commits on curbuf",
                --     opts = { buffer = bufnr },
                -- },
            },
            commands = {
                {
                    ":DiffviewLog",
                    description = "Diffview: log",
                    opts = { buffer = bufnr },
                },

                {
                    ":Gitsigns refresh",
                    description = "Gitsigns: refresh",
                    opts = { buffer = bufnr },
                },
            },
        },
    }
end

function M.gitlinker(bufnr)
    require("legendary").keymaps {
        {
            itemgroup = "Git",
            keymaps = {
                {
                    "<Leader>ho",
                    "<CMD>lua require'gitlinker'.get_buf_range_url('n', {action_callback = require'gitlinker.actions'.open_in_browser})<CR>",
                    description = "Gitlinker: check range URL repo on browser",
                    mode = { "n", "v" },
                    opts = { buffer = bufnr },
                },
                {
                    "<Leader>hO",
                    "<CMD>lua require'gitlinker'.get_repo_url({action_callback = require'gitlinker.actions'.open_in_browser})<CR>",
                    description = "Gitlinker: open URL repo",
                    opts = { buffer = bufnr },
                },
            },
        },
    }
end

function M.advanced_git_search(bufnr)
    require("legendary").keymaps {
        {
            itemgroup = "Git",
            keymaps = {
                {
                    "<Leader>hcc",
                    ":'<,'>DiffCommitLine<CR>",
                    description = "Git-advanced: compare diff commits [visual]",
                    mode = { "v" },
                    opts = { buffer = bufnr },
                },
                {
                    "<Leader>hgC",
                    function()
                        return require("advanced_git_search.fzf").search_log_content()
                    end,
                    description = "Git-advanced: search string on repo (all contents)",
                    opts = { buffer = bufnr },
                },

                {
                    "<Leader>hgc",
                    function()
                        return require("advanced_git_search.fzf").search_log_content_file()
                    end,
                    description = "Git-advanced: search string on curbuf",
                    opts = { buffer = bufnr },
                },
            },
        },
    }
end

function M.signs(bufnr, gs)
    M.advanced_git_search(bufnr)
    M.gitlinker(bufnr)
    M.diffview(bufnr)

    require("legendary").keymaps {
        {
            itemgroup = "Git",
            icon = as.ui.icons.git.logo,
            description = "Git functionality",
            keymaps = {
                {
                    "<Leader>hq",
                    function()
                        return gs.setqflist()
                    end,
                    description = "Gitsigns: collect git hunks on qf",
                    opts = { buffer = bufnr },
                },
                {
                    "<Leader>ha",
                    function()
                        return gs.stage_hunk()
                    end,
                    description = "Gitsigns: add hunk",
                    mode = { "n", "v" },
                    opts = { buffer = bufnr },
                },
                {
                    "<Leader>hA",
                    function()
                        return gs.stage_buffer()
                    end,
                    description = "Gitsigns: add all hunk curbuf",
                    mode = { "n", "v" },
                    opts = { buffer = bufnr },
                },

                {
                    "<Leader>hr",
                    function()
                        return gs.reset_hunk()
                    end,
                    description = "Gitsigns: reset hunk",
                    mode = { "n", "v" },
                    opts = { buffer = bufnr },
                },

                {
                    "<Leader>hu",
                    function()
                        return gs.undo_stage_hunk()
                    end,
                    description = "Gitsigns: undo stage hunk",
                    mode = { "n", "v" },
                    opts = { buffer = bufnr },
                },
                {
                    "<Leader>hR",
                    function()
                        return gs.reset_buffer()
                    end,
                    description = "Gitsigns: reset hunk buffer",
                    mode = { "n", "v" },
                    opts = { buffer = bufnr },
                },

                {
                    "<Leader>hP",
                    function()
                        return gs.preview_hunk()
                    end,
                    description = "Gitsigns: preview hunk",
                    opts = { buffer = bufnr },
                },
                {
                    "<Leader>hx",
                    function()
                        return gs.toggle_deleted()
                    end,
                    description = "Gitsigns: toggle deleted",
                    opts = { buffer = bufnr },
                },
                {
                    "<Leader>hh",
                    function()
                        gs.toggle_linehl()
                        gs.toggle_word_diff()
                    end,
                    description = "Gitsigns: toggle buffer highlights",
                    opts = { buffer = bufnr },
                },

                {
                    "ih",
                    ":<C-U>Gitsigns select_hunk<CR>",
                    description = "Gitsigns: select git hunk",
                    opts = { buffer = bufnr },
                    mode = { "o", "x" },
                },
                {
                    "<Leader>hb",
                    "<CMD>Gitsigns blame_line<CR>",
                    description = "Gitsigns: blame line",
                    opts = { buffer = bufnr },
                },

                {
                    "gn",
                    function()
                        if vim.wo.diff then
                            return "]c"
                        end
                        vim.schedule(function()
                            gs.next_hunk { preview = false }
                        end)
                        return "<Ignore>"
                    end,
                    description = "Gitsigns: next hunk",
                    opts = { buffer = bufnr },
                },
                {
                    "gp",
                    function()
                        if vim.wo.diff then
                            return "[c"
                        end
                        vim.schedule(function()
                            gs.prev_hunk { preview = false }
                        end)
                        return "<Ignore>"
                    end,
                    description = "Gitsigns: prev hunk",
                    opts = { buffer = bufnr },
                },

                -- FZFLUA
                {
                    "<Leader>hs",
                    "<CMD>FzfLua git_status<CR>",
                    description = "Fzflua: git status",
                    opts = { buffer = bufnr },
                },
                {
                    "<Leader>hS",
                    "<CMD>FzfLua git_stash<CR>",
                    description = "Fzflua: stash",
                    opts = { buffer = bufnr },
                },
                {
                    "<Leader>hcc",
                    "<CMD>FzfLua git_commits<CR>",
                    description = "Fzflua: all commits",
                    opts = { buffer = bufnr },
                },
                {
                    "<Leader>hcb",
                    "<CMD>FzfLua git_bcommits<CR>",
                    description = "Fzflua: buffer commits",
                    opts = { buffer = bufnr },
                },
            },
        },
    }
end

return M
