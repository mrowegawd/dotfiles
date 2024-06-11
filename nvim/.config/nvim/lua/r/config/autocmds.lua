local cmd = vim.cmd

RUtils.cmd.augroup("WrapSpell", {
  event = { "FileType" },
  pattern = { "gitcommit", "NeogitCommitMessage" },
  command = function()
    vim.opt_local.spell = true
    vim.opt_local.wrap = true
    vim.opt_local.spelllang = { "en_us", "id" }
    vim.opt_local.conceallevel = 2
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
  end,
})

-- NOTE: It seems this fix error invalid window from `resession.nvim'`
RUtils.cmd.augroup("ForceCloseQFToAvoidSessionError", {
  event = { "VimLeavePre", "VimLeave" },
  command = function()
    local is_qf_opened = RUtils.cmd.windows_is_opened { "qf" }
    if is_qf_opened.found then
      vim.cmd [[cclose]]
    end
  end,
})

RUtils.cmd.augroup("WrapFt", {
  event = { "FileType" },
  pattern = { "typescriptreact", "typescript" },
  command = function()
    vim.opt_local.wrap = true
  end,
})

RUtils.cmd.augroup("LargeFileSettings", {
  event = { "BufRead" },
  desc = "Set settings for large files.",
  command = function(ctx)
    local buf = ctx.buf

    if RUtils.buf.is_big_file(ctx.buf) then
      vim.b[buf].is_big_file = true
      vim.b[buf].copilot_enabled = false
      vim.b[buf].autoformat_disable = true
      vim.b[buf].minicursorword_disable = true
      vim.b[buf].diagnostic_disable = true
      vim.b[buf].lsp_disable = true

      vim.opt_local.spell = false
      vim.opt_local.swapfile = false
      vim.opt_local.undofile = false
      vim.opt_local.breakindent = false
      vim.opt_local.colorcolumn = ""
      vim.opt_local.statuscolumn = ""
      vim.opt_local.signcolumn = "no"
      vim.opt_local.foldcolumn = "0"
      vim.opt_local.winbar = ""

      vim.api.nvim_create_augroup("disable_syntax_on_buf_" .. buf, { clear = true })
      vim.api.nvim_create_autocmd("BufReadPost", {
        group = "disable_syntax_on_buf_" .. buf,
        buffer = buf,
        once = true,
        callback = vim.schedule_wrap(function()
          local current_buf = vim.api.nvim_get_current_buf()
          if current_buf == buf then
            vim.bo[buf].syntax = ""
          end
        end),
      })
    end
  end,
})

RUtils.cmd.augroup("SetNopaste", {
  event = { "InsertLeave" },
  pattern = "*",
  command = "set nopaste",
})

RUtils.cmd.augroup("DisableJsonConceal", {
  event = { "FileType" },
  pattern = { "json", "jsonc" },
  command = function()
    vim.opt_local.conceallevel = 0
  end,
})

RUtils.cmd.augroup("SmartClose", {
  event = { "FileType" },
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "DressingSelect",
    "filetree",
    "qf",
    "query",
    "noice",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
  },
  command = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

RUtils.cmd.augroup("TextYankHighlight", {
  event = { "TextYankPost" },
  command = function()
    vim.highlight.on_yank {
      timeout = 200,
      on_visual = true,
      higroup = "NvimInternalError",
    }
  end,
})

RUtils.cmd.augroup("LocateLastPosition", {
  -- Go to last loc when opening a buffer
  event = { "BufReadPost" },
  command = function(args)
    local exclude = { "gitcommit", "gitrebase", "svn", "hgcommit", "NeogitCommitMessage", "qf" }
    local buf = args.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

RUtils.cmd.augroup("WindowBehaviours", {
  event = { "FileType" },
  pattern = {
    "orgagenda",
    "capture",
    "gitcommit",
    "qf",
    "NeogitCommitMessage",
    "NeogitPopup",
    -- "help",
    -- "Trouble",
  },
  command = function()
    cmd "wincmd J"
    if vim.bo[0].filetype == "NeogitCommitMessage" then
      cmd [[resize 20]]
    end
  end,
}, {
  event = { "FileType" },
  pattern = { "gitcommit", "NeogitCommitMessage" },
  command = function()
    vim.opt_local.spell = true
    vim.opt_local.wrap = true
    vim.opt_local.spelllang = { "en_us", "id" }
    vim.opt_local.conceallevel = 2
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
  end,
}, {
  event = { "BufEnter", "BufRead" },
  pattern = "*",
  command = function()
    if vim.bo.filetype == "" and (vim.bo.buftype == "terminal" or vim.bo.filetype == "toggleterm") then
      vim.cmd.startinsert()
      RUtils.map.tnoremap("<esc><esc>", "<C-\\><C-n>", { desc = "Terminal: normal mode" })
      RUtils.map.tnoremap("qq", "<C-\\><C-n>", { desc = "Terminal: normal mode" })
      RUtils.map.tnoremap("<a-x>", function()
        -- RUtils.map.feedkey("<C-\\><C-n>:q!<CR>", "t")
        local buf = vim.api.nvim_get_current_buf()
        require("bufdelete").bufdelete(buf, true)
      end, { desc = "Terminal: close terminal" })

      -- TODO: pilih kandidat prefix mapping dan get familiar dengan nya, utk mapping terminal #low #created:2024-06-05

      -- ATTEMPT 1: prefix mod `arrow keys` = gagal! (jari tangan kriting)
      -- RUtils.map.tnoremap("<Right>", "<cmd>wincmd h<cr>", { desc = "Terminal: left window" })
      -- RUtils.map.tnoremap("<Left>", "<cmd>wincmd l<cr>", { desc = "Terminal: right window" })
      -- RUtils.map.tnoremap("<Up>", "<cmd>wincmd k<cr>", { desc = "Terminal: up window" })
      -- RUtils.map.tnoremap("<Down>", "<cmd>wincmd j<cr>", { desc = "Terminal: down window" })

      -- ATTEMPT 2: prefix mod `<c-w>` = gagal! (bikin ganggu fzf-lua, <c-w> untuk delete text line!)
      -- RUtils.map.tnoremap("<c-w>h", "<cmd>wincmd h<cr>", { desc = "Terminal: left window" })
      -- RUtils.map.tnoremap("<c-w>l", "<cmd>wincmd l<cr>", { desc = "Terminal: right window" })
      -- RUtils.map.tnoremap("<c-w>k", "<cmd>wincmd k<cr>", { desc = "Terminal: up window" })
      -- RUtils.map.tnoremap("<c-w>j", "<cmd>wincmd j<cr>", { desc = "Terminal: down window" })
      -- RUtils.map.tnoremap("<c-w>L", function()
      --   RUtils.map.feedkey("<C-\\><C-n>tL", "t")
      -- end, { desc = "Terminal: next tab" })
      -- RUtils.map.tnoremap("<c-w>H", function()
      --   RUtils.map.feedkey("<C-\\><C-n>th", "t")
      -- end, { desc = "Terminal: prev tab" })
      -- RUtils.map.tnoremap("<c-w>f", function()
      --   RUtils.map.feedkey("<C-\\><C-n><c-w>f", "t")
      -- end, { desc = "Terminal: create new terminal from terminal mode" })

      -- ATTEMPT 3: prefix mod `<c-a>` = gagal! (<c-a> di terminal, go to first line)

      -- ATTEMPT 4: prefix mod `<c-hjkl>` = gagal! (bikin ganggu fzf-lua, <c-l/h> next/prev char)

      -- >>> ATTEMPT 5: prefix mod `<a-w>` = ?? (get familiar with this bindings maybe for some couple days?) <<<
      RUtils.map.tnoremap("<a-w>h", "<cmd>wincmd h<cr>", { desc = "Terminal: left window" })
      RUtils.map.tnoremap("<a-w>l", "<cmd>wincmd l<cr>", { desc = "Terminal: right window" })
      RUtils.map.tnoremap("<a-w>k", "<cmd>wincmd k<cr>", { desc = "Terminal: up window" })
      RUtils.map.tnoremap("<a-w>j", "<cmd>wincmd j<cr>", { desc = "Terminal: down window" })
      RUtils.map.tnoremap("<a-w>f", function()
        require("fzf-lua").tabs()
      end, { desc = "Terminal: down window" })
      RUtils.map.tnoremap("<a-w>L", function()
        RUtils.map.feedkey("<C-\\><C-n>tl", "t")
      end, { desc = "Terminal: next tab" })
      RUtils.map.tnoremap("<a-w>H", function()
        RUtils.map.feedkey("<C-\\><C-n>th", "t")
      end, { desc = "Terminal: prev tab" })
      RUtils.map.tnoremap("<a-w>n", function()
        RUtils.map.feedkey("<C-\\><C-n><c-w>f", "t")
      end, { desc = "Terminal: create new terminal from terminal mode" })

      -- ========================
      -- Do not delete these line!
      -- ========================

      RUtils.map.tnoremap("<a-f>", function()
        RUtils.map.feedkey("<C-\\><C-n><a-f>", "t")
      end, { desc = "Terminal: new term split" })
      RUtils.map.tnoremap("<a-N>", function()
        RUtils.map.feedkey("<C-\\><C-n><a-N>", "t")
      end, { desc = "Terminal: new tabterm" })
    end
  end,
})

RUtils.cmd.augroup("ConvertNorg", {
  event = { "BufWritePost" },
  pattern = { "*.norg" },
  command = function()
    RUtils.neorg.convert_norg_to_markdown()
  end,
})

RUtils.cmd.augroup("CheckOutsideTime", {
  -- automatically check for changed files outside vim
  event = { "FocusGained", "TermClose", "TermLeave" },
  command = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd "checktime"
    end
  end,
})

-- Copy/Paste when using ssh on a remote server
-- Only works on Neovim >= 0.10.0
if vim.clipboard and vim.clipboard.osc52 then
  RUtils.cmd.augroup("SSH_clipboard", {
    event = { "VimEnter" },
    command = function()
      if vim.env.SSH_CONNECTION and vim.clipboard.osc52 then
        vim.g.clipboard = {
          name = "OSC 52",
          copy = {
            ["+"] = require("vim.clipboard.osc52").copy,
            ["*"] = require("vim.clipboard.osc52").copy,
          },
          paste = {
            ["+"] = require("vim.clipboard.osc52").paste,
            ["*"] = require("vim.clipboard.osc52").paste,
          },
        }
      end
    end,
  })
end

vim.cmd [[
  " :autocmd BufEnter *.png,*.jpg,*gif exec "!sxiv -a ".expand("%") | :bw
  :autocmd BufEnter *.png,*.jpg,*gif exec "!bspc rule -a \\* -o state=tiled focus=true && sxiv -a ///".expand("%") | :bw
]]
