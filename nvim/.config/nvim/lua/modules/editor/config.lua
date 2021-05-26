local config = {}

function config.delimimate()
  vim.g.delimitMate_expand_cr = 0
  vim.g.delimitMate_expand_space = 1
  vim.g.delimitMate_smart_quotes = 1
  vim.g.delimitMate_expand_inside_quotes = 0
  vim.api.nvim_command('au FileType markdown let b:delimitMate_nesting_quotes = ["`"]')
end

function config.nvim_colorizer()
  require 'colorizer'.setup {
    css = { rgb_fn = true; };
    scss = { rgb_fn = true; };
    sass = { rgb_fn = true; };
    stylus = { rgb_fn = true; };
    vim = { names = true; };
    tmux = { names = false; };
    'javascript';
    'javascriptreact';
    'typescript';
    'typescriptreact';
    html = {
      mode = 'foreground';
    }
  }
end

function config.vim_cursorwod()
  vim.api.nvim_command('augroup user_plugin_cursorword')
  vim.api.nvim_command('autocmd!')
  vim.api.nvim_command('autocmd FileType NvimTree,lspsagafinder,dashboard,vista,qf let b:cursorword = 0')
  vim.api.nvim_command('autocmd WinEnter * if &diff || &pvw | let b:cursorword = 0 | endif')
  vim.api.nvim_command('autocmd InsertEnter * let b:cursorword = 0')
  vim.api.nvim_command('autocmd InsertLeave * let b:cursorword = 1')
  vim.api.nvim_command('augroup END')
end

function config.nvim_dap()

  vim.fn.sign_define(
    "DapBreakpoint",
    { text = "綠", texthl = "", linehl = "", numhl = "" }
  )
  vim.fn.sign_define(
    "DapStopped",
    { text = "->", texthl = "", linehl = "", numhl = "" }
  )

  -- DEBUGGER --------------------------------------------------------------- {{{

  -- nnoremap({
  --   "<leader>da",
  --   "<cmd>lua require'plugins._dap'.attachDebug()<CR>",
  --   { silent = true },
  -- })

  -- nnoremap({
  --   "<leader>db",
  --   "<cmd>lua require'dap'.toggle_breakpoint()<CR>",
  --   { silent = true },
  -- })

  -- nnoremap({
  --   "<leader>de",
  --   "<cmd>lua require'dap'.set_exception_breakpoints({'all'})()<CR>",
  --   { silent = true },
  -- })

  -- nnoremap({
  --   "<leader>dB",
  --   "<cmd>lua require'dap'.list_breakpoints()<CR>",
  --   { silent = true },
  -- })

  -- nnoremap({
  --   "<leader>di",
  --   "<cmd>lua require'dap.ui.variables'.hover(function () return vim.fn.expand('<cexpr>') end)<CR>",
  --   { silent = true },
  -- })

  -- vnoremap({
  --   "<leader>di",
  --   "<cmd>lua require'dap.ui.variables'.visual_hover()<CR>",
  --   { silent = true },
  -- })

  -- nnoremap({
  --   "<leader>d?",
  --   "<cmd>lua require'dap.ui.variables'.scopes()<CR>",
  --   { silent = true },
  -- })

  -- nnoremap({
  --   "<leader>dn",
  --   "<cmd>lua require'dap'.continue()<CR>",
  --   { silent = true },
  -- })
  -- nnoremap({
  --   "<leader>d_",
  --   "<cmd>lua require'dap'.run_last()<CR>",
  --   { silent = true },
  -- })

  -- nnoremap({
  --   "<leader>dr",
  --   "<cmd>lua require'dap'.repl.open({}, 'vsplit')<CR><C-w>l",
  --   { silent = true },
  -- })

  -- -- STEP_OVER, STEP_OUT, STEP_INTO

  -- nnoremap({
  --   "<a-n>",
  --   "<cmd>lua require'dap'.step_over()<CR>",
  --   { silent = true },
  -- })

  -- nnoremap({
  --   "<a-p>",
  --   "<cmd>lua require'dap'.step_into()<CR>",
  --   { silent = true },
  -- })

  -- nnoremap({
  --   "<a-o>",
  --   "<cmd>lua require'dap'.step_out()<CR>",
  --   { silent = true },
  -- })
  -- }}}

  -- return {
  --   debugJest = debugJest,
  --   attachDebug = attachDebug,
  -- }

end

function config.vim_test()
  vim.g['test#strategy'] = "neovim"  -- vimterminal, floaterm, terminal
  vim.g['test#neovim#term_position'] = "vert botright"
end

function config.vim_projectionist()

  vim.g.projectionist_heuristics = {
    ["*.go"] =  {
      ["*.go"] = { ["alternate"] =  "{}_test.go", ["type"] = "source" },
      ["*_test.go"] = { ["alternate" ] =  "{}.go", ["type"] = "test" },
    },
    ["*.py"] =  {
      ["*.py"] = { ["alternate"] = "tests/test_{}.py", ["type"] = "source" },
      ["test_*.py"] = { ["alternate" ] = "{}.py", ["type"] = "test" },
    },
    ["lib/*.dart"] = {
      ["lib/screens/*.dart"] = {
        ["alternate"] = "lib/view_models/{}_view_model.dart",
        ["type"] = "source",
      },
      ["lib/view_models/*_view_model.dart"] = {
        ["alternate"] = "lib/screens/{}.dart",
        ["type"] = "source",
      },
      ["test/view_models/*_view_model_test.dart" ] = {
        ["alternate"] = "lib/view_models/{}_view_model.dart",
        ["type"] = "test",
      }
    }
  }
end

return config
