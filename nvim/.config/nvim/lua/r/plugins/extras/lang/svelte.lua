return {
  recommended = function()
    return RUtils.extras.wants {
      ft = "svelte",
      root = {
        "svelte.config.js",
        "svelte.config.mjs",
        "svelte.config.cjs",
      },
    }
  end,

  -- depends on the typescript extra
  { import = "r.plugins.extras.lang.typescript" },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "svelte" } },
  },

  -- LSP Servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        svelte = {
          keys = {
            {
              "<leader>co",
              RUtils.lsp.action["source.organizeImports"],
              desc = "Action: organize imports",
            },
          },
          capabilities = {
            workspace = {
              didChangeWatchedFiles = vim.fn.has "nvim-0.10" == 0 and { dynamicRegistration = true },
            },
          },
        },
      },
    },
  },

  -- Configure tsserver plugin
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      RUtils.extend(opts.servers.vtsls, "settings.vtsls.tsserver.globalPlugins", {
        {
          name = "typescript-svelte-plugin",
          location = RUtils.get_pkg_path("svelte-language-server", "/node_modules/typescript-svelte-plugin"),
          enableForWorkspaceTypeScriptVersions = true,
        },
      })
    end,
  },

  {
    "conform.nvim",
    optional = true,
    opts = function(_, opts)
      if RUtils.has_extra "formatting.prettier" then
        opts.formatters_by_ft = opts.formatters_by_ft or {}
        opts.formatters_by_ft.svelte = { "prettier" }
      end
    end,
  },
}
