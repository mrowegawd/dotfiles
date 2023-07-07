local map = vim.keymap.set

local nnoremap = function(...)
    map("n", ...)
end
local xnoremap = function(...)
    map("x", ...)
end
local vnoremap = function(...)
    map("v", ...)
end
local onoremap = function(...)
    map("o", ...)
end

local M = {}

function M.diffview(bufnr)
    nnoremap(
        "<Leader>hD",
        "<CMD>DiffviewOpen<CR>",
        { desc = "Git(diffview): open", buffer = bufnr }
    )
    nnoremap(
        "<Leader>hd",
        "<CMD>DiffviewFileHistory<CR>",
        { desc = "Git(diffview): open all history", buffer = bufnr }
    )
    vnoremap(
        "<Leader>hd",
        [[:'<'>DiffviewFileHistory<CR>]],
        { desc = "Git(diffview): file history", buffer = bufnr }
    )
    -- {
    --     "<Leader>hdH",
    --     "<CMD>DiffviewFileHistory %<CR>",
    --     description = "Diffview: check all commits on curbuf",
    --     opts = { buffer = bufnr },
    -- },
    --
    -- commands = {
    --     {
    --         ":DiffviewLog",
    --         description = "Diffview: log",
    --         opts = { buffer = bufnr },
    --     },
    --
    --     {
    --         ":Gitsigns refresh",
    --         description = "Gitsigns: refresh",
    --         opts = { buffer = bufnr },
    --     },
end

function M.gitlinker(bufnr)
    nnoremap(
        "<Leader>ho",
        "<CMD>lua require'gitlinker'.get_buf_range_url('n', {action_callback = require'gitlinker.actions'.open_in_browser})<CR>",
        {
            desc = "Git(gitlinker): check range URL repo on browser",
            buffer = bufnr,
        }
    )

    vnoremap(
        "<Leader>ho",
        "<CMD>lua require'gitlinker'.get_buf_range_url('n', {action_callback = require'gitlinker.actions'.open_in_browser})<CR>",
        {
            desc = "Git(gitlinker): check range URL repo on browser",
            buffer = bufnr,
        }
    )
    nnoremap(
        "<Leader>hO",
        "<CMD>lua require'gitlinker'.get_repo_url({action_callback = require'gitlinker.actions'.open_in_browser})<CR>",
        { desc = "Git(gitlinker): open URL repo", buffer = bufnr }
    )
end

function M.signs(bufnr, gs)
    M.gitlinker(bufnr)
    M.diffview(bufnr)

    nnoremap("<Leader>hq", function()
        return gs.setqflist()
    end, { desc = "Git(gitsigns): collect git hunks on qf", buffer = bufnr })

    nnoremap(
        "<Leader>ha",
        gs.stage_hunk,
        { desc = "Git(gitsigns): add hunk", buffer = bufnr }
    )
    vnoremap(
        "<Leader>ha",
        gs.stage_hunk,
        { desc = "Git(gitsigns): add hunk", buffer = bufnr }
    )

    nnoremap("<Leader>hA", function()
        return gs.stage_buffer()
    end, { desc = "Git(gitsigns): add all hunk curbuf", buffer = bufnr })
    vnoremap("<Leader>hA", function()
        return gs.stage_buffer()
    end, { desc = "Git(gitsigns): add all hunk curbuf", buffer = bufnr })

    nnoremap("<Leader>hr", function()
        return gs.reset_hunk()
    end, { desc = "Git(gitsigns): reset hunk", buffer = bufnr })
    vnoremap("<Leader>hr", function()
        return gs.reset_hunk()
    end, { desc = "Git(gitsigns): reset hunk", buffer = bufnr })

    nnoremap("<Leader>hu", function()
        return gs.undo_stage_hunk()
    end, { desc = "Git(gitsigns): undo stage hunk", buffer = bufnr })
    vnoremap("<Leader>hu", function()
        return gs.undo_stage_hunk()
    end, { desc = "Git(gitsigns): undo stage hunk", buffer = bufnr })

    nnoremap("<Leader>hR", function()
        return gs.reset_buffer()
    end, { desc = "Git(gitsigns): reset hunk buffer", buffer = bufnr })
    vnoremap("<Leader>hR", function()
        return gs.reset_buffer()
    end, { desc = "Git(gitsigns): reset hunk buffer", buffer = bufnr })

    nnoremap("<Leader>hP", function()
        return gs.preview_hunk()
    end, { desc = "Git(gitsigns): preview hunk", buffer = bufnr })

    nnoremap("<Leader>hx", function()
        return gs.toggle_deleted()
    end, { desc = "Git(gitsigns): toggle show deleted", buffer = bufnr })

    nnoremap("<Leader>hh", function()
        gs.toggle_linehl()
        gs.toggle_word_diff()
    end, { desc = "Git(gitsigns): toggle buffer highlights", buffer = bufnr })

    xnoremap(
        "ih",
        ":<C-U>Gitsigns select_hunk<CR>",
        { desc = "Git(gitsigns): select git hunk", buffer = bufnr }
    )
    onoremap(
        "ih",
        ":<C-U>Gitsigns select_hunk<CR>",
        { desc = "Git(gitsigns): select git hunk", buffer = bufnr }
    )
    nnoremap(
        "<Leader>hb",
        "<CMD>Gitsigns blame_line<CR>",
        { desc = "Git(gitsigns): blame line", buffer = bufnr }
    )

    nnoremap("gn", function()
        if vim.wo.diff then
            return "]c"
        end
        vim.schedule(function()
            gs.next_hunk { preview = false }
        end)
        return "<Ignore>"
    end, { desc = "Git(gitsigns): next hunk", buffer = bufnr })

    nnoremap("gp", function()
        if vim.wo.diff then
            return "[c"
        end
        vim.schedule(function()
            gs.prev_hunk { preview = false }
        end)
        return "<Ignore>"
    end, { desc = "Git(gitsigns): prev hunk", buffer = bufnr })

    -- FZFLUA
    nnoremap(
        "<Leader>hs",
        "<CMD>FzfLua git_status<CR>",
        { desc = "Git(fzflua): git status", buffer = bufnr }
    )

    nnoremap(
        "<Leader>hS",
        "<CMD>FzfLua git_stash<CR>",
        { desc = "Git(fzflua): stash", buffer = bufnr }
    )
    nnoremap(
        "<Leader>hcc",
        "<CMD>FzfLua git_commits<CR>",
        { desc = "Git(fzflua): all commits", buffer = bufnr }
    )
    nnoremap(
        "<Leader>hcb",
        "<CMD>FzfLua git_bcommits<CR>",
        { desc = "Git(fzflua): buffer commits", buffer = bufnr }
    )
end

return M
