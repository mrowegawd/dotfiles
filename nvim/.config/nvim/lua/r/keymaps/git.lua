local fzf_lua = RUtils.cmd.reqcall "fzf-lua"

local M = {}

local function gitfzflua(opts)
  opts = opts or {}
  RUtils.map.nnoremap("<Leader>gfs", fzf_lua.git_status, { desc = "Git: show git status [fzflua]" })
  RUtils.map.nnoremap("<Leader>gfS", fzf_lua.git_stash, { desc = "Git: show git stash [fzflua]" })
  RUtils.map.nnoremap("<Leader>gfC", fzf_lua.git_commits, { desc = "Git: list commits repos [fzflua]" })
  RUtils.map.nnoremap("<Leader>gfc", fzf_lua.git_bcommits, { desc = "Git: list commits buffer [fzflua]" })

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
  end, { desc = "Git: list commands of git" })
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
    "<Leader>gvV",
    "<esc><cmd>CompareClipboardSelection<cr>",
    { desc = "Git: compare diff with selection clipboard (visual)" }
  )

  RUtils.map.nnoremap("<leader>gvv", function()
    local current_line = vim.fn.line "."
    local file = vim.fn.expand "%"
    -- DiffviewFileHistory --follow -L{current_line},{current_line}:{file}
    local cmd = string.format("DiffviewFileHistory --follow -L%s,%s:%s", current_line, current_line, file)
    vim.cmd(cmd)
  end, { desc = "Git: line hash history [diffview]" })

  RUtils.map.vnoremap("<Leader>gvv", function()
    local v = get_visual_selection_info()
    local file = vim.fn.expand "%"
    -- DiffviewFileHistory --follow -L{range_start},{range_end}:{file}
    local cmd = string.format("DiffviewFileHistory --follow -L%s,%s:%s", v.start_row + 1, v.end_row + 1, file)
    vim.cmd(cmd)
  end, { desc = "Git: line range hash history (visual) [diffview]" })
end

local is_gitsigns_attach = true

local function visual_operation(operator)
  local visual_range = { start_pos = vim.fn.line "v", end_pos = vim.fn.line "." }
  if visual_range.start_pos > visual_range.end_pos then
    local tmp = visual_range.start_pos
    visual_range.start_pos = visual_range.end_pos
    visual_range.end_pos = tmp
    require("gitsigns")[operator] { visual_range.start_pos, visual_range.end_pos }
  end
end

local function lazygit()
  RUtils.map.nnoremap("<Leader>gb", RUtils.lazygit.blame_line, { desc = "Git: blame line [lazygit]" })
  RUtils.map.nnoremap("<Leader>gB", function()
    local git_path = vim.api.nvim_buf_get_name(0)
    RUtils.lazygit { args = { "-f", vim.trim(git_path) } }
  end, { desc = "Git: lazygit current file history [lazygit]" })
end

function M.gitsigns()
  local gs = require "gitsigns"

  RUtils.map.vnoremap("<Leader>gha", function()
    visual_operation "stage_hunk"
  end, { desc = "Git: stage hunk (visual) [gitsigns]" })
  RUtils.map.nnoremap("<Leader>gha", gs.stage_hunk, { desc = "Git: stage hunk [gitsigns]" })
  RUtils.map.nnoremap("<Leader>ghA", gs.stage_buffer, { desc = "Git: stage hunk buffer [gitsigns]" })
  RUtils.map.nnoremap("<Leader>ghr", gs.reset_hunk, { desc = "Git: reset hunk [gitsigns]" })
  RUtils.map.nnoremap("<Leader>ghu", gs.undo_stage_hunk, { desc = "Git: undo stage hunk [gitsigns]" })
  RUtils.map.vnoremap("<Leader>ghu", function()
    visual_operation "undo_stage_hunk"
  end, { desc = "Git: undo stage hunk (visual) [gitsigns]" })
  RUtils.map.nnoremap("<Leader>ghP", gs.preview_hunk_inline, { desc = "Git: preview hunk [gitsigns]" })
  RUtils.map.nnoremap("<Leader>gq", gs.setqflist, { desc = "Git: select all hunks and send to qf [gitsigns]" })
  RUtils.map.nnoremap(
    "<Leader>gul",
    gs.toggle_current_line_blame,
    { desc = "Git: toggle line blame (gitlens) [gitsigns]" }
  )
  RUtils.map.nnoremap("<Leader>gud", function()
    gs.diffthis "~"
  end, { desc = "Git: toggle diffthis '~' [gitsigns]" })
  RUtils.map.nnoremap("<Leader>guw", function()
    gs.toggle_word_diff()
  end, { desc = "Git: toggle word diff [gitsigns]" })
  RUtils.map.nnoremap("<Leader>guD", function()
    gs.toggle_deleted()
  end, { desc = "Git: toggle deleted [gitsigns]" })
  RUtils.map.nnoremap("<Leader>guL", function()
    gs.toggle_linehl()
  end, { desc = "Git: toggle linehl [gitsigns]" })
  RUtils.map.nnoremap("<Leader>gub", function()
    vim.cmd "BlameToggle"
  end, { desc = "Git: toggle line blame  [blame.nvim]" })
  RUtils.map.nnoremap("<Leader>gus", function()
    vim.cmd "Gitsigns toggle_signs"
  end, { desc = "Git: toggle signs [gitsigns]" })
  RUtils.map.xnoremap("ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Git: select git hunk [gitsigns]" })
  RUtils.map.onoremap("ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Git: select git hunk [gitsigns]" })

  RUtils.map.nnoremap("gn", function()
    if vim.wo.diff then
      return "]c"
    end
    vim.schedule(function()
      gs.nav_hunk "next"
    end)
    return "<Ignore>"
  end, { desc = "Git: next hunk [gitsigns]" })

  RUtils.map.nnoremap("gN", function()
    if vim.wo.diff then
      return ""
    end
    vim.schedule(function()
      gs.nav_hunk "last"
    end)
    return "<Ignore>"
  end, { desc = "Git: last hunk [gitsigns]" })

  RUtils.map.nnoremap("gp", function()
    if vim.wo.diff then
      return "[c"
    end
    vim.schedule(function()
      gs.nav_hunk "prev"
    end)
    return "<Ignore>"
  end, { desc = "Git: prev hunk [gitsigns]" })

  -- TODO: bentrok dengan mapping lsp, 'gP'
  -- RUtils.map.nnoremap("gP", function()
  --   if vim.wo.diff then
  --     return ""
  --   end
  --   vim.schedule(function()
  --     gs.nav_hunk "first"
  --   end)
  --   return "<Ignore>"
  -- end, { desc = "git: first hunk [gitsigns]" })

  gitdiffview()
  lazygit()
  gitfzflua {
    toggle_gitsign_attach = function()
      if is_gitsigns_attach then
        gs.detach()
        is_gitsigns_attach = false
      else
        gs.attach()
        is_gitsigns_attach = true
      end
    end,
    git_browse = function()
      RUtils.lazygit.browse()
    end,
    -- gitsign_add_hunk_all = function()
    --   gs.stage_buffer()
    -- end,
    -- gitsign_collect_hunk_qf = function()
    --   gs.setqflist()
    -- end,
  }
end

function M.minigit()
  gitdiffview()
  gitfzflua()
  lazygit()
end

return M
