local remap = vim.api.nvim_set_keymap

vim.g.vsnip_snippet_dir = os.getenv("HOME")
  .. "/Dropbox/data.programming.forprivate/vsnip"

vim.lsp.protocol.CompletionItemKind = {
  " text",
  " method",
  " function",
  " constructor",
  "ﰠ field",
  " variable",
  " class",
  " interface",
  " module",
  " property",
  " unit",
  " value",
  " enum",
  " key",
  "﬌ snippet",
  " color",
  " file",
  " reference",
  " folder",
  " enum member",
  " constant",
  " struct",
  "⌘ event",
  " operator",
  "♛ type",
}

require("compe").setup({
  enabled = true,
  debug = false,
  min_length = 2,
  preselect = "always",
  source_timeout = 200,
  incomplete_delay = 400,
  allow_prefix_unmatch = false,
  max_abbr_width = 100,
  max_menu_width = 100,
  max_kind_width = 100,

  source = {
    path = { kind = " " },
    buffer = { kind = " " },
    calc = { kind = "  " },
    vsnip = { kind = " " },
    nvim_lsp = { kind = " " },
    nvim_lua = { kind = " " },
    spell = { kind = " " },
    tags = false,
    snippets_nvim = { kind = " " },
    treesitter = { kind = " " },
    -- emoji = { kind = " ﲃ " },
    -- for emoji press : (idk if that in compe tho)
  },
})

-- TODO: make this function work
-- local npairs = require('nvim-autopairs')
-- Util.trigger_completion = function()
--   if vim.fn.pumvisible() ~= 0  then
--     if vim.fn.complete_info()["selected"] ~= -1 then
--       return vim.fn["compe#confirm"]()
--     end

--     vim.fn.nvim_select_popupmenu_item(0 , false , false ,{})
--     P(vim.fn["compe#confirm"]())
--     return vim.fn["compe#confirm"]()
--   end

--   return npairs.check_break_line_char()
-- end

Util.trigger_completion = function()
  if vim.fn.pumvisible() ~= 0 then
    if vim.fn.complete_info()["selected"] ~= -1 then
      return vim.fn["compe#confirm"]()
    end
  end

  local prev_col, next_col = vim.fn.col(".") - 1, vim.fn.col(".")
  local prev_char = vim.fn.getline("."):sub(prev_col, prev_col)
  local next_char = vim.fn.getline("."):sub(next_col, next_col)

  -- minimal autopairs-like behaviour
  if prev_char == "{" and next_char == "" then
    return Util.t("<CR>}<C-o>O")
  end
  if prev_char == "[" and next_char == "" then
    return Util.t("<CR>]<C-o>O")
  end
  if prev_char == "(" and next_char == "" then
    return Util.t("<CR>)<C-o>O")
  end
  if prev_char == ">" and next_char == "<" then
    return Util.t("<CR><C-o>O")
  end -- html indents
  return Util.t("<CR>")
end

-- keymap: [plugin][compe][completion][insert] confirm selected completion
remap(
  "i",
  "<CR>",
  "v:lua.Util.trigger_completion()",
  { expr = true, silent = true }
)

-- keymap: [plugin][compe][completion][insert] select next the item
remap(
  "i",
  "<C-n>",
  table.concat({
    "pumvisible() ? \"<C-n>\" : v:lua.Util.check_backspace()",
    "? \"<C-n>\" : compe#confirm()",
  }),
  { silent = true, noremap = true, expr = true }
)

-- keymap: [plugin][compe][completion][insert] select prev the item
remap(
  "i",
  "<C-p>",
  "pumvisible() ? \"<C-p>\" : \"<C-p>\"",
  { noremap = true, expr = true }
)

-- keymap: [plugin][compe][completion][insert] trigger completion
remap(
  "i",
  "<C-Space>",
  "compe#complete()",
  { noremap = true, expr = true, silent = true }
)
