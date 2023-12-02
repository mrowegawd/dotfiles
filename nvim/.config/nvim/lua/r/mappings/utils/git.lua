local map = vim.keymap.set
local Util = require "r.utils"

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

-- Create a new scratch buffer
vim.api.nvim_create_user_command("Ns", function()
  vim.cmd [[
		execute 'vsplit | enew'
		setlocal buftype=nofile
		setlocal bufhidden=hide
		setlocal noswapfile
	]]
end, { nargs = 0 })

-- Compare clipboard to current buffer
-- vim.api.nvim_create_user_command("CompareClipboard", function()
--   local ftype = vim.api.nvim_eval "&filetype" -- original filetype
--   vim.cmd [[
-- 		tabnew %
-- 		Ns
-- 		normal! P
-- 		windo diffthis
-- 	]]
--   vim.cmd("set filetype=" .. ftype)
-- end, { nargs = 0 })

-- Compare clipboard to visual selection
vim.api.nvim_create_user_command("CompareClipboardSelection", function()
  vim.cmd [[
		" yank visual selection to z register
		normal! gv"zy
		" open new tab, set options to prevent save prompt when closing
		execute 'tabnew | setlocal buftype=nofile bufhidden=hide noswapfile'
		" paste z register into new buffer
		normal! V"zp
		Ns
		normal! Vp
		windo diffthis
	]]
end, {
  nargs = 0,
  range = true,
})


-- stylua: ignore
function M.signs(bufnr, gs)
  vnoremap("<Leader>ga", "<CMD> Gitsigns stage_hunk <CR>", { desc = "Git(gitsigns): stage hunk (visual)", buffer = bufnr })
  nnoremap("<Leader>ga", "<CMD> Gitsigns stage_hunk <CR>", { desc = "Git(gitsigns): stage hunk (visual)", buffer = bufnr })
  nnoremap("<Leader>gr", gs.reset_hunk, { desc = "Git(gitsigns): reset hunk", buffer = bufnr })
  nnoremap("<Leader>gu", gs.undo_stage_hunk, { desc = "Git(gitsigns): undo stage hunk", buffer = bufnr })
  nnoremap("<Leader>gP", gs.preview_hunk, { desc = "Git(gitsigns): preview hunk", buffer = bufnr })
  nnoremap("<Leader>gl", gs.preview_hunk_inline, { desc = "Git(gitsigns): preview hunk inline", buffer = bufnr })

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
  nnoremap("<Leader>gB", "<CMD>FzfLua git_commits<CR>", { desc = "Git(fzflua): open commits repos", buffer = bufnr })
  nnoremap("<Leader>gb", "<CMD>FzfLua git_bcommits<CR>", { desc = "Git(fzflua): open commits buffer", buffer = bufnr })

  vnoremap(
    "<Leader>gvh",
    [[:'<'>DiffviewFileHistory --follow<CR>]],
    { desc = "Git(diffview): diffhistory on curbuf (visual)", buffer = bufnr }
  )
  nnoremap(
    "<Leader>gvl",
    "<CMD>.DiffviewFileHistory --follow<CR>",
    { desc = "Git(diffview): diffhistory curline", buffer = bufnr }
  )
  vnoremap(
    "<Leader>gvd",
    "<esc><cmd>CompareClipboardSelection<cr>",
    { desc = "Git(diff): compare selection with diffthis (visual)" }
  )

  -- nnoremap("<Leader>gvH", "<CMD>DiffviewFileHistory<CR>", { desc = "Git(diffview): diff repo hisory", buffer = bufnr })
  -- nnoremap("<Leader>gvC", "<cmd>CompareClipboard<cr>", { desc = "Git(diff): compare clipboard", silent = true })
  -- nnoremap("<Leader>gvd", [[<CMD>windo diffthis<CR>]], { desc = "Git(diff): compare with diffthis" })
  -- nnoremap("<Leader>gA", gs.stage_buffer, { desc = "Git(gitsigns): stage entire hunk buffer", buffer = bufnr })
  -- nnoremap("<Leader>gR", gs.reset_buffer, { desc = "Git(gitsigns): reset hunk buffer", buffer = bufnr })
  -- nnoremap("<Leader>gvs", "<CMD>DiffviewOpen<CR>", { desc = "Git(diffview): git status diff", buffer = bufnr })
  -- nnoremap(
  --   "<Leader>gvh",
  --   "<CMD>DiffviewFileHistory --follow %<CR>",
  --   { desc = "Git(diffview): open diff history on curbuf", buffer = bufnr }
  -- )

  nnoremap("<Leader>gf", function ()
    Util.fzflua.send_cmds {
      gitsign_blameline = function()
        gs.blame_line()
      end,
      gitsign_toggle_deleted = function()
        gs.toggle_deleted()
      end,
      gitsign_toggle_linehl = function()
        gs.toggle_linehl()
      end,
      gitsign_toggle_word_diff = function()
        gs.toggle_word_diff()
      end,
      gitsign_reset_all = function()
        gs.reset_buffer()
      end,
      gitsign_add_hunk_all = function()
        gs.stage_buffer()
      end,
      gitsign_collect_hunk_qf = function()
        gs.setqflist()
      end,
      diffviewopen = function()
        vim.cmd[[DiffviewOpen]]
      end,
      diffviewfilehistory_on_repo = function()
        vim.cmd[[DiffviewFileHistory]]
      end,
      diffviewfilehistory_on_curbuf = function()
        vim.cmd[[DiffviewFileHistory --follow %]]
      end,
      diffview_windo_this = function()
        vim.cmd[[windo diffthis]]
      end,
      neogit = function()
        vim.cmd[[Neogit]]
      end,
      toggle_git_nvimIDE = function()
        vim.cmd[[Workspace RightPanelToggle]]
      end,
      toggle_git_nvimIDE_RESET = function()
        vim.cmd[[Workspace reset]]
      end,
      git_worktree_create = function()
        vim.cmd[[lua require("telescope").extensions.git_worktree.create_git_worktrees()]]
      end,
      git_worktree_manage = function()
        vim.cmd[[lua require("telescope").extensions.git_worktree.git_worktrees()]]
      end,
      git_fzflua_stash = function()
        vim.cmd[[FzfLua git_stash]]
      end,
    }
  end, { desc = "Git(fzflua): commnds of git", buffer = bufnr })

end

return M
