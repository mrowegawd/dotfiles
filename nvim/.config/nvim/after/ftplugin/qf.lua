local keymap, api = vim.keymap, vim.api

local opt = vim.opt_local

opt.buflisted = false
opt.winfixheight = true
opt.cursorline = true
-- opt.signcolumn = "yes"
opt.listchars:append "trail: "

-- Disable ctrl-i and ctrl-o
keymap.set("n", "<c-i>", "<Nop>", {
  buffer = api.nvim_get_current_buf(),
})
keymap.set("n", "<c-o>", "<Nop>", {
  buffer = api.nvim_get_current_buf(),
})

RUtils.map.nnoremap("<leader>fq", function()
  require("fzf-lua").quickfix {
    prompt = "  ",
    winopts = {
      title = RUtils.fzflua.format_title("[QF] Select item list", "󰈙"),
    },
  }
end, {
  buffer = api.nvim_get_current_buf(),
  desc = "QF: select items [fzflua]",
})

RUtils.map.nnoremap("<leader>fg", function()
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
  desc = "QF: live grep items [fzflua]",
})

RUtils.map.nnoremap("o", function()
  RUtils.map.feedkey("<CR>", "n")
end, {
  buffer = api.nvim_get_current_buf(),
  desc = "QF: open item",
})
