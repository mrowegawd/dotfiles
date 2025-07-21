local keymap, opt = vim.keymap, vim.opt_local
local fzf_lua = RUtils.cmd.reqcall "fzf-lua"

keymap.set("n", "<Leader>ri", "<CMD>ImgInsert<CR>", { buffer = true, desc = "Markdown: insert image" })

local notif_msg = ""
local command_markdown = {
  MarkdownPreviewToggle = { cmd = "MarkdownPreviewToggle" },
  SnipRun = { cmd = "SnipRun" },
  ImgInsert = { cmd = "ImgInsert" },
}

keymap.set("n", "<Leader>rf", function()
  local opts = {
    winopts = {
      border = RUtils.config.icons.border.rectangle,
      col = 0.50,
      fullscreen = false,
      height = 0.25,
      row = 0.50,
      title = RUtils.fzflua.format_title("Task Runner", "󰈙"),
      width = 0.60,
    },
  }

  opts.actions = vim.tbl_extend("keep", {
    ["default"] = function(selected, _)
      local sel = selected[1]
      for i, x in pairs(command_markdown) do
        if i == sel then
          if sel == "MarkdownPreviewToggle" then
            if vim.g.is_preview_markdown_off then
              vim.g.is_preview_markdown_off = false
              notif_msg = "turn ON the preview"
            else
              vim.g.is_preview_markdown_off = true
              notif_msg = "turn OFF the preview"
            end

            ---@diagnostic disable-next-line: undefined-field
            RUtils.info(notif_msg, { title = "Tasks" })
          end
          vim.cmd(x.cmd)
        end
      end
    end,
  }, {})

  local tbl_cmds = {}
  for i, _ in pairs(command_markdown) do
    tbl_cmds[#tbl_cmds + 1] = i
  end

  fzf_lua.fzf_exec(tbl_cmds, opts)
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
