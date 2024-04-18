local fzf_lua = RUtils.cmd.reqcall "fzf-lua"

local M = {}

local function gitfzflua(opts)
  RUtils.map.nnoremap("<Leader>gfs", fzf_lua.git_status, { desc = "Git(fzflua): git status" })
  RUtils.map.nnoremap("<Leader>gfS", fzf_lua.git_stash, { desc = "Git(fzflua): git stash" })
  RUtils.map.nnoremap("<Leader>gfB", fzf_lua.git_commits, { desc = "Git(fzflua): open commits repos" })
  RUtils.map.nnoremap("<Leader>gfb", fzf_lua.git_bcommits, { desc = "Git(fzflua): open commits buffer" })

  RUtils.map.nnoremap("<Leader>gff", function()
    local col, row = RUtils.fzflua.rectangle_win_pojokan()
    RUtils.fzflua.send_cmds(
      vim.tbl_deep_extend("force", {
        diffview_open = function()
          vim.cmd [[DiffviewOpen]]
        end,
        diffview_filehistory_repo = function()
          vim.cmd [[DiffviewFileHistory]]
        end,
        diffview_filehistory_curbuf = function()
          vim.cmd [[DiffviewFileHistory --follow %]]
        end,
        diffview_filehistory_line = function()
          vim.cmd [[.DiffviewFileHistory --follow]]
        end,
        diffview_windo_this = function()
          vim.cmd [[windo diffthis]]
        end,
        neogit = function()
          vim.cmd [[Neogit]]
        end,
        git_worktree_create = function()
          vim.cmd [[lua require("telescope").extensions.git_worktree.create_git_worktrees()]]
        end,
        git_worktree_manage = function()
          vim.cmd [[lua require("telescope").extensions.git_worktree.git_worktrees()]]
        end,
        git_fzflua_stash = function()
          vim.cmd [[FzfLua git_stash]]
        end,
        git_conflict_collect_qf = function()
          vim.cmd [[GitConflictListQf]]
        end,
        git_conflict_pilih_current_ours = function()
          RUtils.info("Choosing ours (current)", { title = "GitConflict" })
          vim.cmd [[GitConflictChooseOurs]]
        end,
        git_conflict_pilih_theirs = function()
          RUtils.info("Choosing theirs (incoming)", { title = "GitConflict" })
          vim.cmd [[GitConflictChooseTheirs]]
        end,
        git_conflict_pilih_none = function()
          RUtils.info("Choosing none of them (deleted)", { title = "GitConflict" })
          vim.cmd [[GitConflictChooseNone]]
        end,
        git_blame = function()
          vim.cmd [[BlameToggle]]
        end,
      }, opts),
      { winopts = { title = RUtils.config.icons.git.branch .. "Git ", row = row, col = col } }
    )
  end, { desc = "Git(fzflua): list of cmds" })
end

-- Create a new scratch buffer
vim.api.nvim_create_user_command("Ns", function()
  vim.cmd [[
		execute 'vsplit | enew'
		setlocal buftype=nofile
		setlocal bufhidden=hide
		setlocal noswapfile
	]]
end, { nargs = 0 })

-- Compare the clipboard to the current buffer
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

-- Compare the clipboard to a visual selection
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
    " alternative: diffview
		windo diffthis 
	]]
end, {
  nargs = 0,
  range = true,
})

local function exit_visual_mode()
  -- Exit visual mode, otherwise `getpos` will return postion of the last visual selection
  local ESC_FEEDKEY = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
  vim.api.nvim_feedkeys(ESC_FEEDKEY, "n", true)
  vim.api.nvim_feedkeys("gv", "x", false)
  vim.api.nvim_feedkeys(ESC_FEEDKEY, "n", true)
end

local function get_visual_selection_info()
  exit_visual_mode()

  local _, start_row, start_col, _ = unpack(vim.fn.getpos "'<")
  local _, end_row, end_col, _ = unpack(vim.fn.getpos "'>")
  start_row = start_row - 1
  end_row = end_row - 1

  return {
    start_row = start_row,
    start_col = start_col,
    end_row = end_row,
    end_col = end_col,
  }
end

local function gitdiffview()
  RUtils.map.vnoremap(
    "<Leader>gvc",
    "<esc><cmd>CompareClipboardSelection<cr>",
    { desc = "Git(diff): compare selection (visual) with clipboard " }
  )

  RUtils.map.nnoremap("gvv", function()
    local current_line = vim.fn.line "."
    local file = vim.fn.expand "%"
    -- DiffviewFileHistory --follow -L{current_line},{current_line}:{file}
    local cmd = string.format("DiffviewFileHistory --follow -L%s,%s:%s", current_line, current_line, file)
    vim.cmd(cmd)
  end, { desc = "Git(diffview): line history" })

  -- RUtils.map.nnoremap(
  --   "<Leader>gvv",
  --   [[:'<'>DiffviewFileHistory --follow<CR>]],
  --   { desc = "Git(diffview): view the history diff of the selection (visual)" }
  -- )

  RUtils.map.vnoremap("<Leader>gvv", function()
    local v = get_visual_selection_info()
    local file = vim.fn.expand "%"
    -- DiffviewFileHistory --follow -L{range_start},{range_end}:{file}
    local cmd = string.format("DiffviewFileHistory --follow -L%s,%s:%s", v.start_row + 1, v.end_row + 1, file)
    vim.cmd(cmd)
  end, { desc = "Git(diffview): range history" })
end

local is_gitsigns_attach = true

function M.gitsigns()
  local gs = require "gitsigns"

  RUtils.map.vnoremap("<Leader>gha", gs.stage_hunk, { desc = "Git(gitsigns): stage hunk (visual)" })
  RUtils.map.nnoremap("<Leader>gha", gs.stage_hunk, { desc = "Git(gitsigns): stage hunk" })
  RUtils.map.nnoremap("<Leader>ghA", gs.stage_buffer, { desc = "Git(gitsigns): stage hunk buffer" })
  RUtils.map.nnoremap("<Leader>ghr", gs.reset_hunk, { desc = "Git(gitsigns): reset hunk" })
  RUtils.map.nnoremap("<Leader>ghu", gs.undo_stage_hunk, { desc = "Git(gitsigns): undo stage hunk" })
  RUtils.map.nnoremap("<Leader>ghP", gs.preview_hunk_inline, { desc = "Git(gitsigns): preview hunk" })
  RUtils.map.nnoremap("<Leader>gq", gs.setqflist, { desc = "Git(gitsigns): send to qf" })
  RUtils.map.nnoremap("<Leader>ghd", gs.diffthis, { desc = "Git(gitsigns): diffthis" })
  RUtils.map.nnoremap(
    "<Leader>gtb",
    gs.toggle_current_line_blame,
    { desc = "Git(gitsigns): toggle line blame (gitlens)" }
  )
  RUtils.map.nnoremap("<Leader>ghD", function()
    gs.diffthis "~"
  end, { desc = "Git(gitsigns): diffthis '~'" })
  RUtils.map.nnoremap("<Leader>gtB", function()
    vim.cmd "BlameToggle"
  end, { desc = "Git(fugitive): open blame buffer" })
  RUtils.map.xnoremap("ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Git(gitsigns): select git hunk" })
  RUtils.map.onoremap("ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Git(gitsigns): select git hunk" })

  RUtils.map.nnoremap("gn", function()
    if vim.wo.diff then
      return "]c"
    end
    vim.schedule(function()
      gs.next_hunk { preview = false }
    end)
    return "<Ignore>"
  end, { desc = "Git(gitsigns): next hunk" })
  RUtils.map.nnoremap("gp", function()
    if vim.wo.diff then
      return "[c"
    end
    vim.schedule(function()
      gs.prev_hunk { preview = false }
    end)
    return "<Ignore>"
  end, { desc = "Git(gitsigns): prev hunk" })

  gitdiffview()

  gitfzflua {
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
  }
end

return M
