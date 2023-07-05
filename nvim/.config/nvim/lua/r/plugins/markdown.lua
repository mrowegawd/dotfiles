return {
    -- MKDNFLOW (disabled)
    {
        "jakewvincent/mkdnflow.nvim", -- a fluent navigation and management markdown notebooks
        ft = { "markdown" },
        enabled = false,
        rocks = "luautf8",
        opts = {},
    },
    -- NVIM FEMACO
    { "AckslD/nvim-FeMaco.lua", ft = { "markdown" }, opts = {} },
    -- MARKDOWN-PREVIEW
    {
        "iamcco/markdown-preview.nvim",
        ft = { "markdown" },
        build = "cd app && npm install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
    },
    -- VIM-MARKDOWN-TOC
    { "mzlogin/vim-markdown-toc", ft = { "markdown" } },
    -- PEEK NIVM (disabled)
    {
        "toppair/peek.nvim",
        enabled = false,
        ft = { "markdown" },
        build = "deno task --quiet build:fast",
        init = function()
            vim.api.nvim_create_user_command("Peek", function()
                local peek = require "peek"
                if peek.is_open() then
                    peek.close()
                else
                    peek.open()
                end
            end, {})
        end,
        config = true,
    },
    -- TELEKASTEN NVIM (disabled)
    {
        "renerocksai/telekasten.nvim",
        enabled = false,
        dependencies = { "nvim-telescope/telescope.nvim" },
        opts = {
            home = vim.env.HOME .. "/zettelkasten",
        },
        ft = { "markdown" },
    },
    -- OBSIDIAN NVIM (disabled)
    {
        "epwalsh/obsidian.nvim",
        enabled = false,
        ft = { "markdown" },
        opts = {
            -- dir = vim.env.HOME .. "/obsidian",
            completion = {
                nvim_cmp = true,
            },
        },
    },
    -- GLOW (disabled)
    { "ellisonleao/glow.nvim", enabled = false, cmd = "Glow", config = true },
    -- https://github.com/rockerBOO/awesome-neovim#markdown-and-latex
}
