local has_npairs, npairs = pcall(require, "nvim-autopairs")

local fn = vim.fn
local api = vim.api

if not has_npairs then
  print("warn: dont forget to install nvim-autopairs!!")
  return
end

vim.g.completion_confirm_key = ""

local function utils(str)
  return api.nvim_replace_termcodes(str, true, true, true)
end

local function gmap(mode, key, result, opts)
  api.nvim_set_keymap(mode, key, result, opts)
end

npairs.setup({
  disable_filetype = { "TelescopePrompt", "fzf" },
})

local check_back_space = function()
  local col = fn.col(".") - 1
  if col == 0 or fn.getline("."):sub(col, col):match("%s") then
    return true
  else
    return false
  end
end

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

-- taken from https://github.com/windwp/nvim-autopairs#using-nvim-compe
Util.trigger_completion = function()
  if fn.pumvisible() ~= 0 then
    if fn.complete_info()["selected"] ~= -1 then
      fn["compe#confirm"]()
      return npairs.esc("<c-y>")

    else
      vim.defer_fn(
        function()
          fn["compe#confirm"]("<cr>")
        end,
        20
      )
      return npairs.esc("<c-n>")
    end
  else
    return npairs.check_break_line_char()
  end
end

Util.tab_complete = function()
  if fn.pumvisible() == 1 then
    return utils("<C-n>")
  elseif fn.call("vsnip#available", { 1 }) == 1 then
    return utils("<Plug>(vsnip-expand-or-jump)")
  elseif check_back_space() then
    return utils("<Tab>")
  else
    return fn["compe#complete"]()
  end
end

Util.s_tab_complete = function()
  if fn.pumvisible() == 1 then
    return utils("<C-p>")
  elseif fn.call("vsnip#jumpable", { -1 }) == 1 then
    return utils("<Plug>(vsnip-jump-prev)")
  else
    return utils("<S-Tab>")
  end
end

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

-- keymap: [plugin][compe][completion][insert] confirm selected completion
gmap(
  "i",
  "<CR>",
  "v:lua.Util.trigger_completion()",
  { expr = true, silent = true }
)

-- keymap: [plugin][compe][completion][insert] select next the item
gmap(
  "i",
  "<c-n>",
  "v:lua.Util.tab_complete()",
  { silent = true, noremap = true, expr = true }
)

-- keymap: [plugin][compe][completion][insert] select prev the item
gmap(
  "i",
  "<c-p>",
  "v:lua.Util.s_tab_complete()",
  { silent = true, noremap = true, expr = true }
)

-- keymap: [plugin][compe][completion][insert] trigger completion
gmap(
  "i",
  "<C-Space>",
  "compe#complete()",
  { noremap = true, expr = true, silent = true }
)
