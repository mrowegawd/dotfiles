local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd

-- default map
local def_map = {
    -- Vim map
    ["n|Y"] = map_cmd("y$"),
    ["n|<c-e>"] = map_cmd([[(line("w$") >= line('$') ? "2j" : "4\<C-e>")]]):with_expr():with_noremap(),
    ["n|<c-y>"] = map_cmd([[(line("w0") <= 1         ? "2k" : "4\<C-y>")]]):with_expr():with_noremap(),
    ["n|J"] = map_cmd("mzJ`z"):with_noremap(),
    ["n|<space><space>"] = map_cmd("<c-^>"):with_noremap(),
    ["n|<c-f>"] = map_cmd("/\\v"):with_noremap(),
    --   ["v|<c-f>"]           = map_cmd('<Esc>/\\%V'):with_noremap(),
    ["n|]w"] = map_cu("WhitespaceNext"):with_noremap(),
    ["n|<Leader>sw"] = map_cmd(":%s///g<left><left><left>"):with_noremap(),
    ["n|<Leader>sW"] = map_cmd(":%s/<c-r><c-w>//g<left><left>"):with_noremap(),
    ["n|[w"] = map_cu("WhitespacePrev"):with_noremap(),
    ["n|<S-TAB>"] = map_cu("bp"):with_noremap():with_silent(),
    ["n|<TAB>"] = map_cu("bn"):with_noremap():with_silent(),
    ["n|<c-w>t"] = map_cu("tabnew"):with_noremap():with_silent(),
    ["n|<c-w>b"] = map_cmd("<C-w><S-t>"):with_noremap():with_silent(),
    ["n|<Leader>j"] = map_cmd(":cnext<CR>zz"):with_noremap(),
    ["n|<Leader>k"] = map_cmd(":cprev<CR>zz"):with_noremap(),
    ["n|<Space>cw"] = map_cu([[silent! keeppatterns %substitute/\s\+$//e]]):with_noremap():with_silent(),
    ["n|<C-h>"] = map_cmd("<C-w>h"):with_noremap(),
    ["n|<Leader><TAB>"] = map_cr("q"):with_noremap(),
    ["n|<C-l>"] = map_cmd("<C-w>l"):with_noremap(),
    ["n|<C-j>"] = map_cmd("<C-w>j"):with_noremap(),
    ["n|<C-k>"] = map_cmd("<C-w>k"):with_noremap(),
    ["n|<C-q>"] = map_cr("wq"),
    ["n|<a-f>"] = map_cr('lua require("core.configs").fold_toggle()'):with_noremap():with_silent(),
    ["n|vv"] = map_cmd("^vg_"):with_noremap(),
    ["n|<Leader>n"] = map_cr("nohl"),
    ["n|<Leader>p"] = map_cr("echo expand('%')"):with_noremap(),
    ["n|<Leader>P"] = map_cr("echo expand('%:p')"):with_noremap(),
    ["n|<Leader>cd"] = map_cr("cd %:p:h"):with_noremap(),
    ["n|<Leader>ss"] = map_cu("SessionSave"):with_noremap(),
    ["n|<Leader>sl"] = map_cu("SessionLoad"):with_noremap(),
    ["n|<Leader>ob"] = map_cr([[lua require("core.configs").handleURL(true)]]):with_noremap():with_silent(),
    ["v|<Leader>ob"] = map_cr([[lua require("core.configs").handleURL(false)]]):with_noremap():with_silent(),
    ["n|<Leader>q"] = map_cr('lua require("core.configs").copenloc_toggle("c")'):with_noremap():with_silent(),
    ["n|<Leader>Q"] = map_cr('lua require("core.configs").copenloc_toggle("l")'):with_noremap():with_silent(),
    ["v|<Leader>U"] = map_cmd("gU$a"):with_noremap(),
    ["v|<Leader>u"] = map_cmd("gu$a"):with_noremap(),
    -- Insert
    ["i|hh"] = map_cmd("<Esc>"):with_noremap(),
    ["i|<C-d>"] = map_cmd("<Del>"):with_noremap(),
    ["i|<C-u>"] = map_cmd("<C-G>u<C-U>"):with_noremap(),
    ["i|<C-h>"] = map_cmd("<Left>"):with_noremap(),
    ["i|<C-l>"] = map_cmd("<Right>"):with_noremap(),
    ["i|<C-a>"] = map_cmd("<ESC>^i"):with_noremap(),
    ["i|<C-j>"] = map_cmd("<Esc>o"):with_noremap(),
    ["i|<C-k>"] = map_cmd("<Esc>O"):with_noremap(),
    ["i|<C-e>"] = map_cmd([[pumvisible() ? "\<C-e>" : "\<End>"]]):with_noremap():with_expr(),
    -- Command line
    ["c|hh"] = map_cmd("<C-c>"):with_noremap(),
    ["c|<C-a>"] = map_cmd("<Home>"):with_noremap(),
    ["c|<C-e>"] = map_cmd("<End>"):with_noremap(),
    ["c|<C-d>"] = map_cmd("<Del>"):with_noremap(),
    ["c|<C-h>"] = map_cmd("<Left>"):with_noremap(),
    ["c|<C-l>"] = map_cmd("<Right>"):with_noremap(),
    ["c|<C-p>"] = map_cmd("<Up>"):with_noremap(),
    ["c|<C-n>"] = map_cmd("<Down>"):with_noremap(),
    ["c|<C-w>"] = map_cmd("<S-Right>"):with_noremap(),
    ["c|<C-b>"] = map_cmd("<S-Left>"):with_noremap(),
    ["c|<C-t>"] = map_cmd([[<C-R>=expand("%:p:h") . "/" <CR>]]):with_noremap()
}

bind.nvim_load_mapping(def_map)
