local config = {}

function config.nvim_treesitter()
    -- vim.api.nvim_command("set foldmethod=expr")
    -- vim.api.nvim_command("set foldexpr=nvim_treesitter#foldexpr()")
    local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()

    parser_configs.norg = {
        install_info = {
            url = "https://github.com/vhyrro/tree-sitter-norg",
            files = {"src/parser.c"},
            branch = "main"
        }
    }

    require "nvim-treesitter.configs".setup {
        ensure_installed = "maintained",
        highlight = {enable = true},
        textobjects = {
            select = {
                enable = true,
                keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner"
                }
            }
        }
    }
end

return config
