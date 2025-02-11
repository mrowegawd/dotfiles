local keymap, api, opt = vim.keymap, vim.api, vim.opt_local
local fzf_lua = RUtils.cmd.reqcall "fzf-lua"

opt.buflisted = false
opt.winfixheight = true
opt.cursorline = true
opt.listchars:append "trail: "

keymap.set("n", "<c-i>", "<Nop>", {
  buffer = api.nvim_get_current_buf(),
})

keymap.set("n", "<c-o>", "<Nop>", {
  buffer = api.nvim_get_current_buf(),
})

keymap.set("n", "o", function()
  RUtils.map.feedkey("<CR>", "n")
end, {
  buffer = api.nvim_get_current_buf(),
  desc = "QF: open item",
})

keymap.set("n", "<Leader>ff", function()
  fzf_lua.quickfix {
    prompt = RUtils.fzflua.default_title_prompt(),
    winopts = { title = RUtils.fzflua.format_title("Select Item QF List", "󰈙") },
  }
end, {
  buffer = api.nvim_get_current_buf(),
  desc = "QF: select items [fzflua]",
})

keymap.set("n", "<Leader>fg", function()
  local path = require "fzf-lua.path"
  local qf_items = vim.fn.getqflist()

  local qf_ntbl = {}
  for _, qf_item in pairs(qf_items) do
    table.insert(qf_ntbl, path.normalize(vim.api.nvim_buf_get_name(qf_item.bufnr), vim.uv.cwd()))
  end

  local pcmd = [[rg --column --line-number -i --hidden --no-heading --color=always --smart-case ]]
    .. table.concat(qf_ntbl, " ")
    .. " -e "

  return fzf_lua.live_grep_glob {
    prompt = RUtils.fzflua.default_title_prompt(),
    winopts = { title = RUtils.fzflua.format_title("Grep QF List", "") },
    cmd = pcmd,
  }
end, {
  buffer = api.nvim_get_current_buf(),
  desc = "QF: live grep items [fzflua]",
})
