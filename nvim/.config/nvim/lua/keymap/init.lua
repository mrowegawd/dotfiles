local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_args = bind.map_args
require("keymap.config")

local plug_map = {
    ["i|<TAB>"] = map_cmd("v:lua.tab_complete()"):with_expr():with_silent(),
    ["i|<S-TAB>"] = map_cmd("v:lua.s_tab_complete()"):with_silent():with_expr(),
    ["i|<CR>"] = map_cmd([[compe#confirm({ 'keys': "\<Plug>delimitMateCR", 'mode': '' })]]):with_noremap():with_expr():with_nowait(

    ),
    ["i|<c-space>"] = map_cmd([[compe#complete()]]):with_noremap():with_expr():with_nowait(),
    -- person keymap
    ["n|mf"] = map_cr("<cmd>lua require('internal.fsevent').file_event()<CR>"):with_silent():with_nowait():with_noremap(

    ),
    ["n|gb"] = map_cr("BufferLinePick"):with_noremap():with_silent(),
    ["n|<Leader>O"] = map_cmd("<cmd>lua require('internal.util').buf_only()<CR>"):with_noremap():with_silent(),
    -- Packer
    ["n|<Leader>pu"] = map_cr("PackerUpdate"):with_silent():with_noremap():with_nowait(),
    ["n|<Leader>pi"] = map_cr("PackerInstall"):with_silent():with_noremap():with_nowait(),
    ["n|<Leader>pc"] = map_cr("PackerCompile"):with_silent():with_noremap():with_nowait(),
    -- LSP map work when insertenter and lsp start
    ["n|<Leader>li"] = map_cr("LspInfo"):with_noremap():with_silent():with_nowait(),
    ["n|<Leader>ll"] = map_cr("LspLog"):with_noremap():with_silent():with_nowait(),
    ["n|<Leader>lr"] = map_cr("LspRestart"):with_noremap():with_silent():with_nowait(),
    ["n|K"] = map_cmd("<cmd>lua vim.lsp.buf.hover()<CR>"):with_noremap():with_silent(),
    -- ["n|ga"] = map_cr("Lspsaga code_action"):with_noremap():with_silent(),
    -- ["v|ga"] = map_cu("Lspsaga range_code_action"):with_noremap():with_silent(),
    -- ["n|gA"] = map_cmd("<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>"):with_silent():with_noremap():with_nowait(),
    ["n|gP"] = map_cmd("<cmd>lua require('keymap._test').preview_definition()<cr>"):with_noremap():with_silent(),
    ["n|gs"] = map_cmd("<cmd>lua vim.lsp.buf.signature_help()<CR>"):with_noremap():with_silent(),
    ["n|gR"] = map_cmd("<cmd>lua vim.lsp.buf.rename()<CR>"):with_noremap():with_silent(),
    ["n|gd"] = map_cr("<cmd>lua vim.lsp.buf.definition()<CR>"):with_noremap():with_silent(),
    ["n|gD"] = map_cr("<cmd>vsplit | lua vim.lsp.buf.definition()<CR>"):with_noremap():with_silent(),
    ["n|gr"] = map_cmd("<cmd>Telescope lsp_references<CR>"):with_noremap():with_silent(),
    ["n|gI"] = map_cmd("<cmd>lua vim.lsp.buf.implementation()<CR>"):with_noremap():with_silent(),
    ["n|gt"] = map_cmd("<cmd>lua vim.lsp.buf.type_definition()<CR>"):with_noremap():with_silent(),
    ["n|gw"] = map_cmd("<cmd>lua vim.lsp.buf.workspace_symbol()<CR>"):with_noremap():with_silent(),
    ["n|<S-UP>"] = map_cr("<cmd>lua vim.lsp.diagnostic.goto_prev { popup_opts = {show_header = false} }<CR>"):with_noremap(

    ):with_silent(),
    ["n|<S-DOWN>"] = map_cr("<cmd>lua vim.lsp.diagnostic.goto_next { popup_opts = {show_header = false} }<CR>"):with_noremap(

    ):with_silent(),
    ["n|<Leader>ct"] = map_args("Template"),
    -- Plugin vim-dap
    ["n|<Leader>da"] = map_cr("<cmd>lua require'modules.editor._dap'.attachDebug()<CR>"):with_noremap():with_silent(),
    ["n|<Leader>db"] = map_cr("<cmd>lua require'dap'.toggle_breakpoint()<CR>"):with_noremap():with_silent(),
    ["n|<Leader>dn"] = map_cr("<cmd>lua require'dap'.continue()<CR>"):with_noremap():with_silent(),
    ["n|<Leader>dq"] = map_cr("<cmd>lua require'dap'.stop()<CR>"):with_noremap():with_silent(),
    -- Plugin nvim-tree
    ["n|<Leader>e"] = map_cr("NvimTreeToggle"):with_noremap():with_silent(),
    ["n|<Leader>E"] = map_cr("NvimTreeFindFile"):with_noremap():with_silent(),
    -- Plugin todo-comments
    ["n|<Leader>D"] = map_cr("TodoQuickFix"):with_noremap():with_silent(),
    -- Plugin MarkdownPreview
    ["n|<Leader>om"] = map_cu("MarkdownPreview"):with_noremap():with_silent(),
    -- Plugin DadbodUI
    ["n|<Leader>od"] = map_cr("DBUIToggle"):with_noremap():with_silent(),
    -- Plugin Vim-floaterm
    ["n|<leader>tt"] = map_cu("FloatermToggle"):with_noremap():with_silent(),
    ["t|<leader>tt"] = map_cu([[<C-\><C-n>:FloatermToggle<CR>]]):with_noremap():with_silent(),
    -- Plugin Telescope
    ["n|<Leader>fT"] = map_cu("Telescope builtin"):with_noremap():with_silent(),
    ["n|<Leader>fb"] = map_cu("Telescope buffers"):with_noremap():with_silent(),
    ["n|<Leader>fk"] = map_cu("Telescope keymaps"):with_noremap():with_silent(),
    ["n|<Leader>ff"] = map_cu("Telescope find_myfiles"):with_noremap():with_silent(),
    ["n|<Leader>fg"] = map_cu("Telescope git_status"):with_noremap():with_silent(),
    ["n|<Leader>fh"] = map_cu("Telescope oldfiles"):with_noremap():with_silent(),
    ["n|<Leader>fn"] = map_cu("Telescope notes"):with_noremap():with_silent(),
    ["n|<Leader>fN"] = map_cr(
        [[<cmd>lua require('telescope.builtin').file_browser({cwd="~/MrKampang/vimwiki", prompt_title="Browse Notes"})<CR>]]
    ):with_noremap():with_silent(),
    ["n|<Leader>fQ"] = map_cu("Telescope loclist"):with_noremap():with_silent(),
    ["n|<Leader>fq"] = map_cu("Telescope quickfix"):with_noremap():with_silent(),
    ["n|<Leader>ft"] = map_cu("Telescope help_tags"):with_noremap():with_silent(),
    ["n|<Leader>fW"] = map_cu("Telescope grepcword"):with_noremap():with_silent(),
    ["n|<Leader>fw"] = map_cu("Telescope grepword"):with_noremap():with_silent(),
    ["n|<Leader>fz"] = map_cu("Telescope grepzettel"):with_noremap():with_silent(),
    ["n|<Leader>fd"] = map_cu("Telescope dotfiles path=" .. os.getenv("HOME") .. "/moxconf/dotfiles"):with_noremap():with_silent(

    ),
    -- Plugin vim-projectionist
    ["n|<Localleader>av"] = map_cu("AV"):with_noremap():with_silent(),
    ["n|<Localleader>aa"] = map_cu("A"):with_noremap():with_silent(),
    -- Plugin vim-test
    ["n|tf"] = map_cu("TestFile"):with_noremap():with_silent(),
    ["n|tn"] = map_cu("TestNearest -strategy=basic"):with_noremap():with_silent(),
    ["n|ts"] = map_cu("TestNearest --verbose"):with_noremap():with_silent(),
    ["n|tl"] = map_cu("TestLast"):with_noremap():with_silent(),
    ["n|tg"] = map_cu("TestVisit"):with_noremap():with_silent(),
    -- Plugin acceleratedjk
    -- ["n|j"]              = map_cmd('v:lua.enhance_jk_move("j")'):with_silent():with_expr(),
    -- ["n|k"]              = map_cmd('v:lua.enhance_jk_move("k")'):with_silent():with_expr(),
    -- Plugin QuickRun
    ["n|<Leader>r"] = map_cr("<cmd> lua require'internal.quickrun'.run_command()"):with_noremap():with_silent(),
    -- Plugin Neogit
    ["n|<Leader>hs"] = map_cu("Neogit"):with_noremap():with_silent(),
    -- Plugin Fugitive
    -- ["n|<Leader>hs"] = map_cr("Git"):with_noremap():with_silent(),
    ["n|<Leader>hS"] = map_cmd(":Gvdiffsplit<CR><c-w>w"):with_noremap():with_silent(),
    ["n|<Leader>hq"] = map_cmd("<c-w>h<c-w>c"):with_noremap():with_silent(),
    ["n|<Leader>hl"] = map_cr("Gclog"):with_noremap():with_silent(),
    ["n|<Leader>hv"] = map_cr([[lua require("internal.diffview").diffview()]]):with_noremap():with_silent(),
    ["n|<Leader>hc"] = map_cr("Gclog -- %"):with_noremap():with_silent(),
    ["n|<Leader>hb"] = map_cr("Gblame"):with_noremap():with_silent(),
    ["n|<Leader>hf"] = map_cr("0Gclog"):with_noremap():with_silent(),
    -- Plugin Maximizer
    ["n|<c-p>"] = map_cr("MaximizerToggle"):with_noremap():with_silent(),
    -- Plugin SymbolsOutline
    ["n|<Leader>v"] = map_cu("SymbolsOutline"):with_noremap():with_silent(),
    -- Plugin Vim-operator-surround
    ["n|sa"] = map_cmd("<Plug>(operator-surround-append)"):with_silent(),
    ["n|sd"] = map_cmd("<Plug>(operator-surround-delete)"):with_silent(),
    ["n|sr"] = map_cmd("<Plug>(operator-surround-replace)"):with_silent(),
    -- Plugin hrsh7th/vim-eft
    ["n|;"] = map_cmd("v:lua.enhance_ft_move(';')"):with_expr(),
    ["x|;"] = map_cmd("v:lua.enhance_ft_move(';')"):with_expr(),
    ["n|f"] = map_cmd("v:lua.enhance_ft_move('f')"):with_expr(),
    ["x|f"] = map_cmd("v:lua.enhance_ft_move('f')"):with_expr(),
    ["o|f"] = map_cmd("v:lua.enhance_ft_move('f')"):with_expr(),
    ["n|F"] = map_cmd("v:lua.enhance_ft_move('F')"):with_expr(),
    ["x|F"] = map_cmd("v:lua.enhance_ft_move('F')"):with_expr(),
    ["o|F"] = map_cmd("v:lua.enhance_ft_move('F')"):with_expr(),
    -- Plugin Vim_niceblock
    ["x|I"] = map_cmd("v:lua.enhance_nice_block('I')"):with_expr(),
    ["x|gI"] = map_cmd("v:lua.enhance_nice_block('gI')"):with_expr(),
    ["x|A"] = map_cmd("v:lua.enhance_nice_block('A')"):with_expr(),
    -- Plugin Obvious
    ["n|<A-S-k>"] = map_cu("ObviousResizeUp"):with_silent(),
    ["n|<A-S-j>"] = map_cu("ObviousResizeDown"):with_silent(),
    ["n|<A-S-h>"] = map_cu("ObviousResizeLeft"):with_silent(),
    ["n|<A-S-l>"] = map_cu("ObviousResizeRight"):with_silent(),
    -- Plugin Vimwiki
    ["n|<Localleader>ww"] = map_cu("VimwikiIndex"):with_silent(),
    -- Plugin Spectre
    ["n|<Localleader>f"] = map_cr("<cmd>lua require('spectre').open()<CR>"):with_noremap():with_silent(),
    ["v|<Localleader>f"] = map_cr("<cmd>lua require('spectre').open_visual()<CR>"):with_noremap():with_silent()
}

bind.nvim_load_mapping(plug_map)
