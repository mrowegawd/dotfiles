local Util = require "r.utils"

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
vim.api.nvim_create_user_command("CompareClipboard", function()
  local ftype = vim.api.nvim_eval "&filetype" -- original filetype
  vim.cmd [[
		tabnew %
		Ns
		normal! P
		windo diffthis
	]]
  vim.cmd("set filetype=" .. ftype)
end, { nargs = 0 })

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

local is_gitsigns_attach = true

-- stylua: ignore
function M.signs(bufnr, gs)
 Util.map.vnoremap("<Leader>ga", gs.stage_hunk, { desc = "Git(gitsigns): stage hunk (visual)", buffer = bufnr })
 Util.map.nnoremap("<Leader>ga", gs.stage_hunk, { desc = "Git(gitsigns): stage hunk", buffer = bufnr })
 Util.map.nnoremap("<Leader>gr", gs.reset_hunk, { desc = "Git(gitsigns): reset hunk", buffer = bufnr })
 Util.map.nnoremap("<Leader>gu", gs.undo_stage_hunk, { desc = "Git(gitsigns): undo stage hunk", buffer = bufnr })
 Util.map.nnoremap("<Leader>gP", gs.preview_hunk_inline, { desc = "Git(gitsigns): preview hunk", buffer = bufnr })
 -- Util.map.nnoremap("<Leader>gl", gs.preview_hunk_inline, { desc = "Git(gitsigns): preview hunk inline", buffer = bufnr })

 Util.map.xnoremap("ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Git(gitsigns): select git hunk", buffer = bufnr })
 Util.map.onoremap("ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Git(gitsigns): select git hunk", buffer = bufnr })

 Util.map.nnoremap("gn", function()
    if vim.wo.diff then
      return "]c"
    end
    vim.schedule(function()
      gs.next_hunk { preview = false }
    end)
    return "<Ignore>"
  end, { desc = "Git(gitsigns): next hunk", buffer = bufnr })
  Util.map.nnoremap("gp", function()
    if vim.wo.diff then
      return "[c"
    end
    vim.schedule(function()
      gs.prev_hunk { preview = false }
    end)
    return "<Ignore>"
  end, { desc = "Git(gitsigns): prev hunk", buffer = bufnr })

  -- FZFLUA
  Util.map.nnoremap("<Leader>gs", "<CMD>lua require('fzf-lua').git_status()<CR>", { desc = "Git(fzflua): git status", buffer = bufnr })
  Util.map.nnoremap("<Leader>gS", "<CMD>lua require('fzf-lua').git_stash()<CR>", { desc = "Git(fzflua): git stash", buffer = bufnr })
  Util.map.nnoremap("<Leader>gB", "<CMD>lua require('fzf-lua').git_commits()<CR>", { desc = "Git(fzflua): open commits repos", buffer = bufnr })
  Util.map.nnoremap("<Leader>gb", "<CMD>lua require('fzf-lua').git_bcommits()<CR>", { desc = "Git(fzflua): open commits buffer", buffer = bufnr })

  Util.map.vnoremap(
    "<Leader>gvv",
    [[:'<'>DiffviewFileHistory --follow<CR>]],
    { desc = "Git(diffview): view the history diff of the selection (visual)", buffer = bufnr }
  )
  Util.map.vnoremap(
    "<Leader>gvc",
    "<esc><cmd>CompareClipboardSelection<cr>",
    { desc = "Git(diff): compare selection (visual) with clipboard ", buffer = bufnr }
  )

  Util.map.nnoremap("<Leader>gf", function ()
    local col, row = Util.fzflua.rectangle_win_pojokan()
    Util.fzflua.send_cmds({
      toggle_gitsigns_attach = function()
        if is_gitsigns_attach then
          gs.detach()
          is_gitsigns_attach = false
        else
          gs.attach()
          is_gitsigns_attach = true
        end
      end,
      toggle_gitsigns_deleted = function()
        gs.toggle_deleted()
      end,
      toggle_gitsign_linehl = function()
        gs.toggle_linehl()
      end,
      toggle_gitsign_word_diff = function()
        gs.toggle_word_diff()
      end,
      gitsign_show_blameline = function()
        gs.blame_line()
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
      diffview_open = function()
        vim.cmd[[DiffviewOpen]]
      end,
      diffview_filehistory_repo = function()
        vim.cmd[[DiffviewFileHistory]]
      end,
      diffview_filehistory_curbuf = function()
        vim.cmd[[DiffviewFileHistory --follow %]]
      end,
      diffview_filehistory_line = function()
        vim.cmd[[.DiffviewFileHistory --follow]]
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
      git_conflict_collect_qf = function()
        vim.cmd[[GitConflictListQf]]
      end,
      git_conflict_pilih_current_ours = function()
        Util.info("Choosing ours (current)", {title="GitConflict"})
        vim.cmd[[GitConflictChooseOurs]]
      end,
      git_conflict_pilih_theirs = function()
        Util.info("Choosing theirs (incoming)", {title="GitConflict"})
        vim.cmd[[GitConflictChooseTheirs]]
      end,
      git_conflict_pilih_none = function()
        Util.info("Choosing none of them (deleted)", {title="GitConflict"})
        vim.cmd[[GitConflictChooseNone]]
      end,
    }, { winopts = { title = require("r.config").icons.git.branch .. "Git ", row = row, col = col } }
    )

  end, { desc = "Git(fzflua): list of cmds", buffer = bufnr })

end

return M
