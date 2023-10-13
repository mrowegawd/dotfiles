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

-- stylua: ignore
function M.diffview(bufnr)
  nnoremap("<Leader>gvo", "<CMD>DiffviewOpen<CR>", { desc = "Git(diffview): open", buffer = bufnr })
  nnoremap("<Leader>gvh", "<CMD>DiffviewFileHistory %<CR>", { desc = "Git(diffview): file history", buffer = bufnr })

  nnoremap("<Leader>gvH", "<CMD>DiffviewFileHistory<CR>", { desc = "Git(diffview): branch history", buffer = bufnr })
  vnoremap( "<Leader>gvH", [[:'<'>DiffviewFileHistory<CR>]], { desc = "Git(diffview): file history (visual)", buffer = bufnr })
end

function M.gitlinker(bufnr)
  nnoremap(
    "<Leader>go",
    "<CMD>lua require'gitlinker'.get_buf_range_url('n', {action_callback = require'gitlinker.actions'.open_in_browser})<CR>",
    {
      desc = "Git(gitlinker): range URL repo on browser",
      buffer = bufnr,
    }
  )
  vnoremap(
    "<Leader>go",
    "<CMD>lua require'gitlinker'.get_buf_range_url('n', {action_callback = require'gitlinker.actions'.open_in_browser})<CR>",
    {
      desc = "Git(gitlinker): range URL repo on browser (visual)",
      buffer = bufnr,
    }
  )
  nnoremap(
    "<Leader>gO",
    "<CMD>lua require'gitlinker'.get_repo_url({action_callback = require'gitlinker.actions'.open_in_browser})<CR>",
    { desc = "Git(gitlinker): open URL repo", buffer = bufnr }
  )
end

-- stylua: ignore
function M.signs(bufnr, gs)
  M.gitlinker(bufnr)
  M.diffview(bufnr)

  nnoremap("gq", gs.setqflist, { desc = "Git(gitsigns): collect git hunks on qf", buffer = bufnr })

  nnoremap("<Leader>ga", gs.stage_hunk, { desc = "Git(gitsigns): add hunk", buffer = bufnr })
  nnoremap("<Leader>gA", gs.stage_buffer, { desc = "Git(gitsigns): add hunk curbuf", buffer = bufnr })
  nnoremap("<Leader>gr", gs.reset_hunk, { desc = "Git(gitsigns): reset hunk", buffer = bufnr })
  nnoremap("<Leader>gu", gs.undo_stage_hunk, { desc = "Git(gitsigns): undo stage hunk", buffer = bufnr })
  nnoremap("<Leader>gR", gs.reset_buffer, { desc = "Git(gitsigns): reset hunk buffer", buffer = bufnr })
  nnoremap("<Leader>gP", gs.preview_hunk, { desc = "Git(gitsigns): preview hunk", buffer = bufnr })
  nnoremap("<Leader>gl", gs.blame_line, { desc = "Git(gitsigns): blame line", buffer = bufnr })

  nnoremap("<Leader>gtd", gs.toggle_deleted, { desc = "Git(gitsigns): toggle show deleted", buffer = bufnr })
  nnoremap("<Leader>gth", function() gs.toggle_linehl() gs.toggle_word_diff() end, { desc = "Git(gitsigns): toggle buffer highlights", buffer = bufnr })

  xnoremap("ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Git(gitsigns): select git hunk", buffer = bufnr })
  onoremap("ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Git(gitsigns): select git hunk", buffer = bufnr })

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
  nnoremap("<Leader>gs", "<CMD>FzfLua git_status<CR>", { desc = "Git(fzflua): git status", buffer = bufnr })
  nnoremap("<Leader>gts", "<CMD>FzfLua git_stash<CR>", { desc = "Git(fzflua): stash", buffer = bufnr })
  nnoremap("<Leader>gB", "<CMD>FzfLua git_commits<CR>", { desc = "Git(fzflua): open commits repos", buffer = bufnr })
  nnoremap("<Leader>gb", "<CMD>FzfLua git_bcommits<CR>", { desc = "Git(fzflua): open commits buffer", buffer = bufnr })
end

return M
