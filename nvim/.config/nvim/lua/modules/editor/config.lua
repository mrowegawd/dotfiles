local config = {}

function config.delimimate()
    vim.g.delimitMate_expand_cr = 0
    vim.g.delimitMate_expand_space = 1
    vim.g.delimitMate_smart_quotes = 1
    vim.g.delimitMate_expand_inside_quotes = 0
    vim.api.nvim_command('au FileType markdown let b:delimitMate_nesting_quotes = ["`"]')
end

function config.nvim_colorizer()
    require "colorizer".setup {
        css = {rgb_fn = true},
        scss = {rgb_fn = true},
        sass = {rgb_fn = true},
        stylus = {rgb_fn = true},
        vim = {names = true},
        tmux = {names = false},
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        html = {
            mode = "foreground"
        }
    }
end

function config.vim_cursorwod()
    vim.api.nvim_command("augroup user_plugin_cursorword")
    vim.api.nvim_command("autocmd!")
    vim.api.nvim_command("autocmd FileType NvimTree,lspsagafinder,dashboard,vista,qf let b:cursorword = 0")
    vim.api.nvim_command("autocmd WinEnter * if &diff || &pvw | let b:cursorword = 0 | endif")
    vim.api.nvim_command("autocmd InsertEnter * let b:cursorword = 0")
    vim.api.nvim_command("autocmd InsertLeave * let b:cursorword = 1")
    vim.api.nvim_command("augroup END")
end

function config.nvim_dap()
    require("modules.editor._dap")
    require("dapui").setup()
end

function config.vim_test()
    vim.g["test#strategy"] = "floaterm" -- vimterminal, floaterm, terminal
end

-- function config.vim_ultest()
-- vim.g['test#strategy'] = "neovim"  -- vimterminal, floaterm, terminal
-- vim.g['test#neovim#term_position'] = "vert botright"
--
-- vim.fn.has "python3" = 1
-- vim.g['test#strategy'] = "neovim"  -- vimterminal, floaterm, terminal
-- vim.g['test#neovim#term_position'] = "vert botright"

-- vim.g.ultest_use_pty = 1
-- end

function config.vim_projectionist()
    vim.g.projectionist_heuristics = {
        ["*.go"] = {
            ["*.go"] = {["alternate"] = "{}_test.go", ["type"] = "source"},
            ["*_test.go"] = {["alternate"] = "{}.go", ["type"] = "test"}
        },
        ["*.py"] = {
            ["*.py"] = {["alternate"] = "tests/test_{}.py", ["type"] = "source"},
            ["test_*.py"] = {["alternate"] = "{}.py", ["type"] = "test"}
        },
        ["lib/*.dart"] = {
            ["lib/screens/*.dart"] = {
                ["alternate"] = "lib/view_models/{}_view_model.dart",
                ["type"] = "source"
            },
            ["lib/view_models/*_view_model.dart"] = {
                ["alternate"] = "lib/screens/{}.dart",
                ["type"] = "source"
            },
            ["test/view_models/*_view_model_test.dart"] = {
                ["alternate"] = "lib/view_models/{}_view_model.dart",
                ["type"] = "test"
            }
        }
    }
end

return config
