local ts_config = require("nvim-treesitter.configs")

ts_config.setup({
  ensure_installed = {
    "javascript",
    "typescript",
    "tsx",
    "jsdoc",
    "cpp",
    "jsonc",
    "kotlin",
    "html",
    "css",
    "lua",
    "c",
    "rust",
    "go",
    "java",
    "query",
    "php",
    "bash",
    "python",
    "rst",
    "svelte",
  },

  highlight = {
    enable = true,
  },

  indent = {
    enable = true,
  },

  autotag = {
    enable = true,
  },

  context_commentstring = {
    enable = true,
  },

  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["ab"] = "@block.outer",
        ["ib"] = "@block.inner",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<Leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<Leader>A"] = "@parameter.inner",
      },
    },
    lsp_interop = {
      enable = true,
    },
  },
})
