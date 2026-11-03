local add = require("vim-pack").add

local lazy = require("utils.plugin").require_lazy

add {
  {
    src = "tpope/vim-rhubarb",
    lazy = true,
    setup = false,
  },
  {
    src = "tpope/vim-fugitive",
    lazy = true,
    setup = false,
  },
}

local UtilAugroup = lazy("utils.map").augroup
local UtilKey = lazy "utils.map"

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
    UtilKey.nnoremap("<a-n>", "]m", { buffer = e.buf, remap = true, desc = "Fugitive: next item and close diff", force =true })
    --stylua: ignore
    UtilKey.nnoremap("<a-p>", "[m", { buffer = e.buf, remap = true, desc = "Fugitive: prev item and close diff", force =true })

    UtilKey.nnoremap("<Tab>", "=zt", { buffer = e.buf, remap = true, desc = "Fugitive: unfold/fold", force = true })

    UtilKey.nnoremap("<C-n>", ")", { buffer = e.buf, remap = true, desc = "Fugitive: next diff", force = true })
    UtilKey.nnoremap("<C-p>", "(", { buffer = e.buf, remap = true, desc = "Fugitive: prev diff", force = true })

    -- +-----------------------------------------------------------------------------+
    -- |                                    OPEN                                     |
    -- +-----------------------------------------------------------------------------+
    UtilKey.nnoremap("<Leader>oe", "o", { buffer = e.buf, remap = true, desc = "Fugitive: open split", force = true })
    UtilKey.nnoremap("<Leader>os", "o", { buffer = e.buf, remap = true, desc = "Fugitive: open split", force = true })
    --stylua: ignore
    UtilKey.nnoremap("<Leader>ov", "gO", { buffer = e.buf, remap = true, desc = "Fugitive: open vsplit", force = true })
    UtilKey.nnoremap("<Leader>ot", "O", { buffer = e.buf, remap = true, desc = "Fugitive: open tabnew", force = true })

    -- ├───────────────────────────────┤ DIFFSPLIT ├────────────────────────────┤
    --stylua: ignore
    UtilKey.nnoremap("<C-a>d", "dd", { buffer = e.buf, remap = true, desc = "Fugitive: perform Gdiffsplit", force = true })
    --stylua: ignore
    UtilKey.nnoremap("<C-a>v", "dv", { buffer = e.buf, remap = true, desc = "Fugitive: perform Gvdiffsplit", force = true })
    --stylua: ignore
    UtilKey.nnoremap("<C-a>c", "dq", { buffer = e.buf, remap = true, desc = "Fugitive: close diff buffer", force = true })
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
