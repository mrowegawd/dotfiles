local keymap, opt = vim.keymap, vim.opt_local

local fzf_lua = RUtils.cmd.reqcall "fzf-lua"

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
        vim.cmd [[SnipRun]]
      end
    end,
  }, {})

  fzf_lua.fzf_exec({ "MarkdownPreviewToggle", "Sniprun", "ImgInsert" }, opts)
end, { buffer = true, desc = "Tasks: runner" })

opt.wrap = false
opt.list = false
opt.foldlevel = 0 -- using ufo provider need a large value, feel free to decrease the value

local function has_surrounding_fencemarks(lnum)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local inside_fence = false

  for i = 1, lnum - 1 do
    if lines[i]:match "^```" then
      inside_fence = not inside_fence
    end
  end
  return inside_fence
end

-- NOTE:
-- Folded style, pada markdown bisa di set sebagai `vim.g.markdown_folding=1`
-- tapi color hi nya conflict dengan plugin lain, cuman malas debug jadi
-- `vim.g.markdown_folding` ini disabled.
-- (https://github.com/nvim-treesitter/nvim-treesitter/issues/2145#issuecomment-997935467)
-- Dengan alasan inilah `Markdown_fold()` ini dibuat:
function _G.Markdown_fold()
  local line = vim.fn.getline(vim.v.lnum)

  -- Fold headers (#) dan pastikan ada fence marks?
  if line:match "^#+ " and not has_surrounding_fencemarks(vim.v.lnum) then
    return ">" .. line:find " "
  end

  -- Fold underlined headers
  local nextline = vim.fn.getline(vim.v.lnum + 1)
  if line:match "^.+$" and nextline:match "^=+$" and not has_surrounding_fencemarks(vim.v.lnum) then
    return ">2"
  end

  return "="
end

vim.opt_local.foldexpr = "v:lua.Markdown_fold()"
