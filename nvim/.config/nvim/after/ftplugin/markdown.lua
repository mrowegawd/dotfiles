local keymap, opt = vim.keymap, vim.opt_local

keymap.set("n", "<Leader>ri", "<CMD>ImgInsert<CR>", { buffer = true, desc = "Markdown: insert image" })
-- vim.cmd [[:%s/^#\+/\=repeat('*', len(submatch(0)))/]]

keymap.set("n", "<Leader>rf", function()
  local opts = {
    winopts = {
      title = RUtils.fzflua.format_title("Buffers", "󰈙"),
      width = 0.60,
      height = 0.25,
      col = 0.50,
      row = 0.50,
      backdrop = 60,
    },
  }

  opts.actions = vim.tbl_extend("keep", {
    ["default"] = function(selected, _)
      local sel = selected[1]
      if sel == "MarkdownPreviewToggle" then
        local notif_msg = ""
        if vim.g.is_preview_markdown_off then
          vim.g.is_preview_markdown_off = false
          notif_msg = "turn ON the preview"
        else
          vim.g.is_preview_markdown_off = true
          notif_msg = "turn OFF the preview"
        end

        RUtils.info(notif_msg, { title = "Tasks" })
        --       local lang_conf = {}
        --       lang_conf["markdown"] = { "```", "```" }
        --       lang_conf["vimwiki"] = { "{{{", "}}}" }
        --       lang_conf["norg"] = { "@code", "@end" }
        --       lang_conf["org"] = { "#+BEGIN_SRC", "#+END_SRC" }
        --       lang_conf["markdown.pandoc"] = { "```", "```" }
        --
        --       local function code_block_start()
        --         return lang_conf[vim.bo.filetype][1]
        --       end
        --
        --       local function code_block_end()
        --         return lang_conf[vim.bo.filetype][2]
        --       end
        --
        --       local linenr_from = vim.fn.search(code_block_start() .. ".\\+$", "bnW")
        --       local linenr_until = vim.fn.search(code_block_end() .. ".*$", "nW")
        --
        --       vim.cmd("normal! " .. linenr_from + 1 .. "G")
        --       vim.cmd "normal! V"
        --       vim.cmd("normal! " .. linenr_until - 1 .. "G")
        --       RUtils.map.feedkey("<Leader>rf", "v")

        vim.cmd(selected[1])
      end

      if sel == "Sniprun" then
        RUtils.map.feedkey("<Plug>SnipRun", "n")
      end
    end,
  }, {})

  require("fzf-lua").fzf_exec({ "MarkdownPreviewToggle", "Sniprun", "ImgInsert" }, opts)
end, { buffer = true, desc = "Tasks: runner" })

opt.wrap = false
opt.list = false
function _G.Mardownfoldtext()
  local line = vim.api.nvim_buf_get_lines(0, vim.v.foldstart - 1, vim.v.foldstart, true)[1]
  local idx = vim.v.foldstart + 1
  while string.find(line, "^%s*@") or string.find(line, "^%s*$") do
    line = vim.api.nvim_buf_get_lines(0, idx - 1, idx, true)[1]
    idx = idx + 1
  end
  local icon = " "
  local padding = string.rep(" ", string.find(line, "[^%s]") - 1)
  return string.format("%s%s %s   %d", padding, icon, line, vim.v.foldend - vim.v.foldstart + 1)
end

-- opt.foldtext = "v:lua.Mardownfoldtext()"
-- opt.foldtext = ""
-- opt.foldexpr = "nvim_treesitter#foldexpr()"
-- opt.foldmethod = "expr"
-- opt.foldlevel = 99

-- local function markdown_sugar()
--   local augroup = vim.api.nvim_create_augroup("markdown", {})
--   vim.api.nvim_create_autocmd("BufEnter", {
--     pattern = "*.md",
--     group = augroup,
--     callback = function()
--       vim.api.nvim_set_hl(0, "Conceal", { bg = "NONE", fg = "#00cf37" })
--       vim.api.nvim_set_hl(0, "todoCheckbox", { link = "Todo" })
--       -- vim.bo.conceallevel = 1
--
--       vim.cmd [[
--         syn match todoCheckbox '\v(\s+)?(-|\*)\s\[\s\]'hs=e-4 conceal cchar=
--         syn match todoCheckbox '\v(\s+)?(-|\*)\s\[x\]'hs=e-4 conceal cchar=
--         syn match todoCheckbox '\v(\s+)?(-|\*)\s\[-\]'hs=e-4 conceal cchar=󰅘
--         syn match todoCheckbox '\v(\s+)?(-|\*)\s\[\.\]'hs=e-4 conceal cchar=⊡
--         syn match todoCheckbox '\v(\s+)?(-|\*)\s\[o\]'hs=e-4 conceal cchar=⬕
--       ]]
--     end,
--   })
-- end

-- markdown_sugar()
