local keymap, api = vim.keymap, vim.api

vim.opt.buflisted = false

-- Disable ctrl-i and ctrl-o
keymap.set("n", "<c-i>", "<Nop>", {
  buffer = api.nvim_get_current_buf(),
})
keymap.set("n", "<c-o>", "<Nop>", {
  buffer = api.nvim_get_current_buf(),
})

keymap.set("n", "o", function()
  RUtils.map.feedkey("<CR>", "n")
  -- vim.schedule(function()
  --   if vim.bo[0].filetype ~= "qf" then
  --     vim.cmd "wincmd p"
  --   end
  -- end)
end, {
  buffer = api.nvim_get_current_buf(),
})

RUtils.cmd.augroup("ColorQuickFixLine", {
  event = { "BufRead", "WinEnter", "FocusGained", "VimEnter", "BufEnter" },
  command = function()
    if vim.bo.filetype ~= "qf" then
      vim.cmd [[execute 'hi! link QuickFixLine LeaveCursorLine' ]]
      vim.cmd [[execute 'hi! link CursorLine CursorLine' ]]
    elseif vim.bo.filetype == "qf" then
      vim.cmd [[execute 'hi! link CursorLine MyQuickFixLineEnter' ]]
      vim.cmd [[execute 'hi! link QuickFixLine MyQuickFixLine' ]]
    end
  end,
})
