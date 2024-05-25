-- local buffer_dir = vim.fn.expand "%:p:h"

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.list = false

vim.b.make = "luajit"

RUtils.write_and_source(0)

-- local run_toggleterm = function()
--   vim.cmd "silent noautocmd update"
--   vim.cmd(string.format('TermExec cmd="%s %s"', "nvim -ll", vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p")))
-- end
--
-- local run_tmux_pane = function()
--   if vim.env.TMUX == nil then
--     return
--   end
--   local cwd = buffer_dir
--   local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
--   local sh_cmd = '"nvim -ll ' .. fname .. [[; read -p ''"]]
--   vim.cmd("silent! !tmux new-window -c " .. cwd .. " -n " .. fname .. " " .. sh_cmd)
-- end

-- keymap.set("n", "<Leader>dal", function()
--   require("osv").run_this()
-- end, { buffer = true, desc = "Debug: adapter lua [nlua]" })

RUtils.map.nnoremap("<Leader>dD", function()
  require("osv").launch { port = 8086 }
end, { buffer = true, desc = "Debug: launch debug lua [nlua]" })
