local add = require("vim-pack").add

local ConfigPath = require("config").path
local UtilKey = require "utils.map"

add {
  {
    src = "LintaoAmons/scratch.nvim",
    lazy = true,
    opts = {
      scratch_file_dir = ConfigPath.wiki_path .. "/scratch.nvim", -- where your scratch files will be put
      filetypes = { "lua", "js", "sh", "ts", "go", "txt", "md", "rs", "org" }, -- you can simply put filetype here
      file_picker = "fzflua",
    },
  },
}

UtilKey.nnoremap("<Leader>bX", function()
  UtilKey.plugin_load_now "scratch.nvim"
  vim.cmd.Scratch()
end, { desc = "Buffer: select list scratch buffer [scratch.nvim]" })
UtilKey.nnoremap("<Leader>bx", function()
  UtilKey.plugin_load_now "scratch.nvim"
  vim.cmd.ScratchOpen()
end, { desc = "Buffer: scratch [scratch.nvim]" })
