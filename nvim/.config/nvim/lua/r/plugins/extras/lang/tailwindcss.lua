return {
  -- NVIM-LSPCONFIG
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tailwindcss = {
          filetypes_exclude = { "markdown" },
          init_options = {
            userLanguages = {
              eelixir = "html-eex",
              eruby = "erb",
            },
          },
          on_attach = function(client, bufnr)
            if client.server_capabilities.colorProvider then
              require("lsp/utils/documentcolors").buf_attach(bufnr)
              require("colorizer").attach_to_buffer(bufnr, {
                mode = "background",
                css = true,
                names = false,
                tailwind = false,
              })
            end
          end,
          settings = {
            tailwindCSS = {
              lint = {
                cssConflict = "warning",
                invalidApply = "error",
                invalidConfigPath = "error",
                invalidScreen = "error",
                invalidTailwindDirective = "error",
                invalidVariant = "error",
                recommendedVariantOrder = "warning",
              },
              experimental = {
                classRegex = {
                  "tw`([^`]*)",
                  'tw="([^"]*)',
                  'tw={"([^"}]*)',
                  "tw\\.\\w+`([^`]*)",
                  "tw\\(.*?\\)`([^`]*)",
                  {
                    "clsx\\(([^)]*)\\)",
                    "(?:'|\"|`)([^']*)(?:'|\"|`)",
                  },
                  { "classnames\\(([^)]*)\\)", "'([^']*)'" },
                  {
                    "cva\\(([^)]*)\\)",
                    "[\"'`]([^\"'`]*).*?[\"'`]",
                  },
                },
              },
              validate = true,
            },
          },
        },
      },
      setup = {
        tailwindcss = function(_, opts)
          local tw = require "lspconfig.server_configurations.tailwindcss"

          opts.filetypes = vim.tbl_filter(function(ft)
            return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
          end, tw.default_config.filetypes)
        end,
      },
    },
  },
  -- CMP
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
    },
    opts = function(_, opts)
      -- original LazyVim kind icon formatter
      local format_kinds = opts.formatting.format
      opts.formatting.format = function(entry, item)
        format_kinds(entry, item) -- add icons
        return require("tailwindcss-colorizer-cmp").formatter(entry, item)
      end
    end,
  },
}
