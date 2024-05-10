local keymap, api = vim.keymap, vim.api

vim.opt.buflisted = false

-- Disable ctrl-i and ctrl-o
keymap.set("n", "<c-i>", "<Nop>", {
  buffer = api.nvim_get_current_buf(),
})
keymap.set("n", "<c-o>", "<Nop>", {
  buffer = api.nvim_get_current_buf(),
})

keymap.set("n", "<leader>fq", function()
  require("fzf-lua").quickfix {
    prompt = "  ",
    winopts = {
      title = RUtils.fzflua.format_title("[QF] Select item list", "󰈙"),
    },
  }
end, {
  buffer = api.nvim_get_current_buf(),
  desc = "Fzflua: select item list",
})

keymap.set("n", "<leader>fg", function()
  local path = require "fzf-lua.path"
  local qf_items = vim.fn.getqflist()

  local qf_ntbl = {}
  for _, qf_item in pairs(qf_items) do
    table.insert(qf_ntbl, path.normalize(vim.api.nvim_buf_get_name(qf_item.bufnr), vim.uv.cwd()))
  end

  local pcmd = [[rg --column --line-number -i --hidden --no-heading --color=always --smart-case ]]
    .. table.concat(qf_ntbl, " ")
    .. " -e "

  return require("fzf-lua").live_grep_glob {
    prompt = "  ",
    winopts = { title = RUtils.fzflua.format_title("[QF] Grep item lists", " ") },
    cmd = pcmd,
  }
end, {
  buffer = api.nvim_get_current_buf(),
  desc = "Fzflua: live grep item lists",
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
