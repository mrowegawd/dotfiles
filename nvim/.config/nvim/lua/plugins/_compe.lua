local remap = vim.api.nvim_set_keymap
local has_npairs, npairs = pcall(require, "nvim-autopairs")

if not has_npairs then
  print("warn: dont forget to install nvim-autopairs!!")
  return
end

npairs.setup({
  disable_filetype = { "TelescopePrompt", "fzf" },
})

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

Util.trigger_completion = function()
  if vim.fn.pumvisible() ~= 0 then
    if vim.fn.complete_info()["selected"] ~= -1 then
      vim.fn["compe#confirm"]()
      return npairs.esc("<c-y>")

    else
      vim.defer_fn(
        function()
          vim.fn["compe#confirm"]("<cr>")
        end,
        20
      )
      return npairs.esc("<c-n>")
    end
  else
    return npairs.check_break_line_char()
  end
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
