local Highlight = require "r.settings.highlights"

local is_render_markdown = true
return {
  recommended = function()
    return RUtils.extras.wants {
      ft = "markdown",
      root = "README.md",
    }
  end,
  {
    "stevearc/conform.nvim",
    optional = true,
    keys = {
      {
        "<Leader>cE",
        function()
          require("conform").format { formatters = { "cbfmt" }, timeout_ms = 5000 }
        end,
        mode = { "n", "v" },
        desc = "Action: cbfmt langs",
      },
    },
    opts = {
      formatters_by_ft = {
        ["markdown"] = { "prettier", "markdownlint-cli2", "markdown-toc", "cbfmt" },
        ["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc", "cbfmt" },
      },
      formatters = {
        ["markdown-toc"] = {
          condition = function(_, ctx)
            for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
              if line:find "<!%-%- toc %-%->" then
                return true
              end
            end
          end,

          ["markdownlint-cli2"] = {
            condition = function(_, ctx)
              local diag = vim.tbl_filter(function(d)
                return d.source == "markdownlint"
              end, vim.diagnostic.get(ctx.buf))
              return #diag > 0
            end,
          },
        },
        cbfmt = {
          prepend_args = { "--config=" .. vim.env.HOME .. "/.config/linters/.cbfmt.toml" },
        },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "markdownlint-cli2", "markdown-toc", "cbfmt", "codespell" } },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        markdown = { "markdownlint-cli2", "codespell" },
        norg = { "codespell" },
        org = { "codespell" },
      },

      linters = {
        ["markdownlint-cli2"] = {
          args = { "--config", vim.env.HOME .. "/.config/linters/.markdownlint.json" },
        },
        codespell = {
          args = { "--config=" .. vim.env.HOME .. "/.config/linters/cspell.json" },
        },
      },
    },
  },
  -- NOTE: disable marksman, it makes the file markdown ft too slow
  -- { "neovim/nvim-lspconfig", opts = { servers = { marksman = {} } } },
  -- MARKDOWN-PREVIEW
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function()
      require("lazy").load { plugins = { "markdown-preview.nvim" } }
      vim.fn["mkdp#util#install"]()
    end,
    config = function()
      vim.cmd [[do FileType]]
    end,
  },
  -- RENDER-MARKDOWN
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "norg", "rmd", "org" },
    keys = {
      {
        "<Localleader>nr",
        function()
          local m = require "render-markdown"
          if not is_render_markdown then
            m.enable()
            is_render_markdown = true
          else
            m.disable()
            is_render_markdown = false
          end
        end,
        ft = { "markdown", "neorg", "org", "rmd" },
        mode = { "v", "n" },
        desc = "Note: toggle render markdown [render-markdown]",
      },
    },
    opts = {
      bullet = {
        enabled = true,
      },
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
        position = "right",
      },
      acknowledge_conflicts = true,
      latex = { enabled = false },
      heading = {
        enabled = true,
        sign = false,
        -- icons = {},
        icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
        -- icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },
      quote = {
        -- Turn on / off block quote & callout rendering
        enabled = false,
      },
    },
    config = function(_, opts)
      local rose_pine = {
        ["rose-pine-dawn"] = {
          { RenderMarkdownCode = { bg = { from = "Normal", attr = "bg", alter = 0.15 } } },
        },
        ["rose-pine-main"] = {
          { RenderMarkdownCode = { bg = { from = "Normal", attr = "bg", alter = -0.15 } } },
        },
      }

      Highlight.plugin("rendermarkdownHi", {
        theme = {
          ["*"] = {
            { RenderMarkdownCode = { bg = { from = "Normal", attr = "bg", alter = -0.1 } } },
            {
              RenderMarkdownCodeInline = {
                fg = { from = "Keyword", attr = "fg", alter = 0.2 },
                bg = { from = "Normal", attr = "bg", alter = 0.5 },
                bold = true,
              },
            },
            {
              ["@markup.raw.markdown_inline"] = {
                fg = { from = "Keyword", attr = "fg", alter = 0.2 },
                bg = { from = "Normal", attr = "bg", alter = 0.6 },
                bold = true,
              },
            },

            {
              RenderMarkdownH1Bg = {
                fg = "NONE",
                bg = { from = "Normal", attr = "bg", alter = 0.2 },
                reverse = false,
              },
            },
            {
              RenderMarkdownH2Bg = {
                fg = "NONE",
                bg = { from = "Normal", attr = "bg", alter = 0.2 },
                reverse = false,
              },
            },
            {
              RenderMarkdownH3Bg = {
                fg = "NONE",
                bg = { from = "Normal", attr = "bg", alter = 0.2 },
                reverse = false,
              },
            },
            {
              RenderMarkdownH4Bg = {
                fg = "NONE",
                bg = { from = "Normal", attr = "bg", alter = 0.2 },
                reverse = false,
              },
            },
            {
              RenderMarkdownH5Bg = {
                fg = "NONE",
                bg = { from = "Normal", attr = "bg", alter = 0.2 },
                reverse = false,
              },
            },
            {
              RenderMarkdownH6Bg = {
                fg = "NONE",
                bg = { from = "Normal", attr = "bg", alter = 0.2 },
                reverse = false,
              },
            },
          },
          ["jellybeans"] = {
            { RenderMarkdownCode = { bg = { from = "Normal", attr = "bg", alter = 0.3 } } },
            {
              ["@markup.raw.markdown_inline"] = {
                fg = { from = "@Boolean", attr = "fg", alter = -0.1 },
                bg = { from = "Normal", attr = "bg", alter = 0.8 },
                bold = true,
              },
            },
            {
              ["@markup.link.label.markdown_inline"] = {
                fg = { from = "@Boolean", attr = "fg", alter = -0.1 },
                bg = { from = "Normal", attr = "bg", alter = 0.8 },
                bold = true,
              },
            },
            {
              ["@markup.quote.markdown"] = {
                fg = { from = "Boolean", attr = "fg", alter = 0.1 },
                bg = { from = "Boolean", attr = "fg", alter = -0.8 },
                italic = true,
              },
            },
            {
              ["@markup.strong.markdown_inline"] = {
                fg = { from = "@Boolean", attr = "fg", alter = -0.1 },
                bg = "NONE",
                bold = true,
              },
            },
            {
              ["@markup.italic.markdown_inline"] = {
                fg = { from = "@Boolean", attr = "fg", alter = -0.1 },
                bg = "NONE",
                bold = false,
                italic = true,
              },
            },
            {
              ["@markup.raw.markdown_inline"] = {
                fg = { from = "Boolean", attr = "fg" },
                bg = { from = "Normal", attr = "bg" },
                reverse = false,
              },
            },
            {
              ["@punctuation.special.markdown"] = {
                fg = { from = "@markup.quote.markdown", attr = "fg" },
              },
            },

            {
              RenderMarkdownCodeInline = {
                fg = { from = "@Boolean", attr = "fg", alter = -0.1 },
                bg = { from = "Normal", attr = "bg", alter = 0.8 },
                bold = true,
              },
            },
          },
          ["ashen"] = {
            { RenderMarkdownCode = { bg = { from = "Normal", attr = "bg", alter = 0.4 } } },

            {
              ["@markup.raw.markdown_inline"] = {
                fg = { from = "WarningMsg", attr = "fg", alter = -0.1 },
                bg = { from = "Normal", attr = "bg", alter = 0.8 },
                bold = true,
              },
            },
            {
              ["@markup.link.label.markdown_inline"] = {
                fg = { from = "WarningMsg", attr = "fg", alter = -0.1 },
                bg = { from = "Normal", attr = "bg", alter = 0.8 },
                bold = true,
              },
            },
            {
              ["@markup.quote.markdown"] = {
                fg = { from = "Boolean", attr = "fg", alter = 0.1 },
                bg = { from = "Boolean", attr = "fg", alter = -0.8 },
                italic = true,
              },
            },
            {
              ["@markup.strong.markdown_inline"] = {
                fg = { from = "WarningMsg", attr = "fg", alter = -0.1 },
                bg = "NONE",
                bold = true,
              },
            },
            {
              ["@markup.italic.markdown_inline"] = {
                fg = { from = "WarningMsg", attr = "fg", alter = -0.1 },
                bg = "NONE",
                bold = false,
                italic = true,
              },
            },
            {
              ["@markup.raw.markdown_inline"] = {
                fg = { from = "Boolean", attr = "fg" },
                bg = { from = "Normal", attr = "bg" },
                reverse = false,
              },
            },
            {
              ["@punctuation.special.markdown"] = {
                fg = { from = "@markup.quote.markdown", attr = "fg" },
              },
            },

            {
              RenderMarkdownCodeInline = {
                fg = { from = "WarningMsg", attr = "fg", alter = -0.1 },
                bg = { from = "Normal", attr = "bg", alter = 0.8 },
                bold = true,
              },
            },
          },
          ["rose-pine"] = rose_pine[RUtils.config.colorscheme],
          ["nord"] = {
            {
              RenderMarkdownCodeInline = {
                fg = { from = "Keyword", attr = "fg", alter = 0.2 },
                bg = { from = "Keyword", attr = "fg", alter = -0.6 },
              },
            },
          },
          ["oxocarbon"] = { { RenderMarkdownCode = { bg = { from = "Normal", attr = "bg", alter = 0.15 } } } },
          ["tokyonight-storm"] = { { ["@markup.raw.markdown_inline"] = { bg = "NONE" } } },
          ["vscode_modern"] = { { ["@markup.raw.markdown_inline"] = { bg = "NONE" } } },
          ["lackluster"] = {
            { RenderMarkdownCode = { bg = { from = "Normal", attr = "bg", alter = 0.4 } } },

            {
              ["@markup.raw.markdown_inline"] = {
                fg = { from = "@markup.heading.5.markdown", attr = "fg", alter = -0.1 },
                bg = { from = "Normal", attr = "bg", alter = 0.8 },
                bold = true,
              },
            },
            {
              ["@markup.link.label.markdown_inline"] = {
                fg = { from = "@markup.heading.5.markdown", attr = "fg", alter = -0.1 },
                bg = { from = "Normal", attr = "bg", alter = 0.8 },
                bold = true,
              },
            },
            {
              ["@markup.quote.markdown"] = {
                fg = { from = "@markup.heading.1.markdown", attr = "fg", alter = 0.1 },
                bg = { from = "@markup.heading.1.markdown", attr = "fg", alter = -0.8 },
                italic = true,
              },
            },
            {
              ["@markup.strong.markdown_inline"] = {
                fg = { from = "@markup.heading.5.markdown", attr = "fg", alter = -0.1 },
                bg = "NONE",
                bold = true,
              },
            },
            {
              ["@markup.italic.markdown_inline"] = {
                fg = { from = "@markup.heading.5.markdown", attr = "fg", alter = -0.1 },
                bg = "NONE",
                bold = false,
                italic = true,
              },
            },
            {
              ["@markup.raw.markdown_inline"] = {
                fg = { from = "@markup.heading.1.markdown", attr = "fg" },
                bg = { from = "Normal", attr = "bg" },
                reverse = false,
              },
            },
          },
          ["zenburned"] = {
            {
              RenderMarkdownCodeInline = {
                fg = { from = "Keyword", attr = "fg", alter = 0.2 },
                bg = { from = "Keyword", attr = "fg", alter = -0.6 },
              },
            },
          },
        },
      })
      require("render-markdown").setup(opts)
    end,
  },
}
