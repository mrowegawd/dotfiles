vim.opt_local.wrap = false
vim.opt_local.list = false
vim.opt_local.textwidth = 70
local listchars = vim.deepcopy(vim.opt.listchars:get())
listchars.tab = "  "
vim.opt_local.listchars = listchars

local lazy = require("utils.plugin").require_lazy

local UtilKey = lazy "utils.map"

local Log = lazy "utils.log"

local fzf_lua = function()
  return lazy("utils.plugin").reqcall "fzf-lua"
end

vim.g.is_preview_markdown_off = true

UtilKey.nnoremap("<Leader>ri", function()
  vim.cmd.ImgInsert()
end, {
  desc = "Note: insert image",
  buffer = vim.api.nvim_get_current_buf(),
  remap = true,
  force = true,
})

local is_render_markdown

UtilKey.noremap({ "n", "x" }, "<Leader>uR", function()
  local m = lazy "render-markdown"
  if not is_render_markdown then
    m.enable()
    is_render_markdown = true
  else
    m.disable()
    is_render_markdown = false
  end
end, {
  desc = "Toggle: render markdown [render-markdown]",
  buffer = vim.api.nvim_get_current_buf(),
  remap = true,
  force = true,
})

local mappings = {
  MarkdownPreviewToggle = { cmd = "MarkdownPreviewToggle" },
  SnipRun = { cmd = "SnipRun" },
  ImgInsert = { cmd = "ImgInsert" },
}

UtilKey.nnoremap("<Leader>rn", function()
  local opts = {
    winopts = {
      title = " Task Markdown Extend Commands ",
      col = 0.50,
      fullscreen = false,
      height = 0.25,
      row = 0.50,
      width = 0.60,
    },
  }

  opts.actions = vim.tbl_extend("keep", {
    ["default"] = {
      fn = function(selected, _)
        if not selected or #selected == 0 then
          return
        end

        local sel = selected[1]
        local msg = ""

        for i, x in pairs(mappings) do
          if i ~= sel then
            goto continue
          end

          if sel ~= "MarkdownPreviewToggle" then
            goto continue
          end

          if vim.g.is_preview_markdown_off then
            vim.g.is_preview_markdown_off = false
            msg = "turn ON the preview"
          else
            vim.g.is_preview_markdown_off = true
            msg = "turn OFF the preview"
          end

          Log.info(msg)
          vim.cmd(x.cmd)

          ::continue::
        end
      end,
    },
  }, {})

  local tbl_cmds = {}
  local pad = 0
  for i, _ in pairs(mappings) do
    tbl_cmds[#tbl_cmds + 1] = i
    if pad < #i then
      pad = #i
    end
  end

  opts.winopts.width = pad / 0.5

  fzf_lua().fzf_exec(tbl_cmds, opts)
end, { buffer = true, desc = "Task: run live/img/sniprun" })

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
