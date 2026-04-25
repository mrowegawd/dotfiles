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

keymap.set("n", "<Leader>bs", "o", { buffer = api.nvim_get_current_buf(), remap = true })
keymap.set("n", "<Leader>be", "o", { buffer = api.nvim_get_current_buf(), remap = true })

keymap.set("n", "<Leader>bt", "O", { buffer = api.nvim_get_current_buf(), remap = true })
keymap.set("n", "<Leader>bv", "gO", { buffer = api.nvim_get_current_buf(), remap = true })

keymap.set("n", "<Leader>mY", function() -- code
  local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
  vim.cmd("GBrowse " .. fname)
end, {
  buffer = api.nvim_get_current_buf(),
  remap = true,
  desc = "Git: open this buffer commit on browser",
})
