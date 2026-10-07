local add = require("vim-pack").add

add {
  {
    src = "tpope/vim-fugitive",
    setup = false,
    on_setup = function()
      local UtilAugroup = require("utils.map").augroup
      local UtilKey = require "utils.map"

      UtilAugroup("ps_fugitive", {
        event = "FileType",
        pattern = { "fugitive" }, -- gstatus
        command = function(e)
          -- Options
          vim.opt_local.winfixheight = true
          vim.opt_local.winfixbuf = true

          -- +-----------------------------------------------------------------------------+
          -- |                                 NAVIGATION                                  |
          -- +-----------------------------------------------------------------------------+
          --stylua: ignore
          UtilKey.nnoremap("<a-n>", "]m", { buffer = e.buf, remap = true, desc = "Fugitive: next item and close diff" }, true)
          --stylua: ignore
          UtilKey.nnoremap("<a-p>", "[m", { buffer = e.buf, remap = true, desc = "Fugitive: prev item and close diff" }, true)

          UtilKey.nnoremap("<Tab>", "=zt", { buffer = e.buf, remap = true, desc = "Fugitive: unfold/fold" }, true)

          UtilKey.nnoremap("<C-n>", ")", { buffer = e.buf, remap = true, desc = "Fugitive: next diff" }, true)
          UtilKey.nnoremap("<C-p>", "(", { buffer = e.buf, remap = true, desc = "Fugitive: prev diff" }, true)

          -- +-----------------------------------------------------------------------------+
          -- |                                    OPEN                                     |
          -- +-----------------------------------------------------------------------------+
          UtilKey.nnoremap("<Leader>oe", "o", { buffer = e.buf, remap = true, desc = "Fugitive: open split" }, true)
          UtilKey.nnoremap("<Leader>os", "o", { buffer = e.buf, remap = true, desc = "Fugitive: open split" }, true)
          --stylua: ignore
          UtilKey.nnoremap("<Leader>ov", "gO", { buffer = e.buf, remap = true, desc = "Fugitive: open vsplit" }, true)
          UtilKey.nnoremap("<Leader>ot", "O", { buffer = e.buf, remap = true, desc = "Fugitive: open tabnew" }, true)

          -- +-----------------------------------------------------------------------------+
          -- |                                  DIFFSPLIT                                  |
          -- +-----------------------------------------------------------------------------+
          ---->>> BAGIAN INI GABISA!

          --stylua: ignore
          -- UtilKey.nnoremap("dd", "<CMD>Gdiffsplit<CR>", { buffer = e.buf, remap = true, desc = "Fugitive: open Gdiffsplit" }, true)
          -- --stylua: ignore
          -- UtilKey.nnoremap("dv", "<CMD>Gvdiffsplit<CR>", { buffer = e.buf, remap = true, desc = "Fugitive: open Gvdiffsplit" }, true)
          -- --stylua: ignore
          -- UtilKey.nnoremap("ds", "<CMD>Ghdiffsplit<CR>", { buffer = e.buf, remap = true, desc = "Fugitive: open Gsdiffsplit" }, true)
          -- --stylua: ignore
          -- UtilKey.nnoremap( "dq", "<CMD>diffoff!<CR>", { buffer = e.buf, remap = true, desc = "Fugitive: close all diff" }, true)

          -- vim.keymap.set("n", "dd", "dd", { buffer = e.buf, remap = true, desc = "Fugitive: open Gdiffsplit" })
          -- vim.keymap.set("n", "dv", "dv", { buffer = e.buf, remap = true, desc = "Fugitive: open Gvdiffsplit" })
          -- vim.keymap.set("n", "ds", "ds", { buffer = e.buf, remap = true, desc = "Fugitive: open Gsdiffsplit" })
          -- vim.keymap.set("n", "dq", "dq", { buffer = e.buf, remap = true, desc = "Fugitive: close all diff" })

          -- +-----------------------------------------------------------------------------+
          -- |                                    MISC                                     |
          -- +-----------------------------------------------------------------------------+
          -- UtilKey.nnoremap("g?", "g?", { buffer = e.buf, remap = true, desc = "Fugitive: help" }, true)
        end,
      }, {
        event = "BufWinEnter",
        pattern = "*.git/COMMIT_EDITMSG",
        command = function()
          -- If it's a new commit, start in insert mode, otherwise start in normal mode
          if vim.fn.getline(1) == "" then
            vim.cmd "15 wincmd K"
            vim.cmd "normal! gg0"
            if vim.api.nvim_get_current_line() == "" then
              vim.cmd "startinsert"
            end
          end
        end,
      })
    end,
  },
}
