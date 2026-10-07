local keymap, api, opt = vim.keymap, vim.api, vim.opt_local

opt.foldexpr = ""
opt.foldmethod = "syntax"

keymap.set("n", "<Tab>", function()
  vim.schedule(function()
    local _, err = pcall(function()
      vim.fn.execute "normal! za"
    end)

    if err and (string.match(err, "E510") or string.match(err, "E490")) then
      local msg = string.format "No fold found"
      ---@diagnostic disable-next-line: undefined-field
      RUtils.warn(msg, { title = "Folds" })
    end
  end)
end, { buffer = api.nvim_get_current_buf() })

RUtils.map.nnoremap("<Leader>oe", "o", { buffer = api.nvim_get_current_buf(), remap = true }, true)
RUtils.map.nnoremap("<Leader>ot", "O", { buffer = api.nvim_get_current_buf(), remap = true }, true)
RUtils.map.nnoremap("<Leader>ov", "gO", { buffer = api.nvim_get_current_buf(), remap = true }, true)

RUtils.map.nnoremap("<C-n>", ")", { buffer = api.nvim_get_current_buf(), remap = true }, true)
RUtils.map.nnoremap("<C-p>", "(", { buffer = api.nvim_get_current_buf(), remap = true }, true)
