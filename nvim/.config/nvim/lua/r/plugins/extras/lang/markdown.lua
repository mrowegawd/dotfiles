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
        "<leader>cE",
        function()
          require("conform").format { formatters = { "cbfmt" }, timeout_ms = 5000 }
        end,
        mode = { "n", "v" },
        desc = "Format: cbfmt langs",
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
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {},
      },
    },
  },
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
  -- MARKDOWN.NVIM
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      file_types = { "markdown", "norg", "rmd", "org" },
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
        position = "right",
      },
      acknowledge_conflicts = true,
      latex = { enabled = false },
      heading = {
        enabled = false,
        sign = false,
        icons = {},
        -- icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },
      quote = {
        -- Turn on / off block quote & callout rendering
        enabled = false,
      },
    },
    keys = {
      {
        "<Leader>um",
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
        desc = "Misc: toggle render markdown [render-markdown]",
      },
    },
    ft = { "markdown", "norg", "rmd", "org" },
    config = function(_, opts)
      Highlight.plugin("rendermarkdownHi", {
        theme = {
          ["*"] = {
            { RenderMarkdownCodeInline = { bg = { from = "Normal", attr = "bg", alter = -0.05 }, bold = true } },
            { ["@markup.raw.markdown_inline"] = { bg = { from = "Normal", attr = "bg", alter = -0.05 }, bold = true } },
          },
          ["evangelion"] = {
            {
              RenderMarkdownCodeInline = {
                bg = { from = "Normal", attr = "bg", alter = 0.3 },
                fg = { from = "Keyword", attr = "fg", alter = -0.05 },
                bold = true,
              },
            },
            {
              ["@markup.raw.markdown_inline"] = {
                bg = { from = "Normal", attr = "bg", alter = 0.3 },
                fg = { from = "Keyword", attr = "fg", alter = -0.05 },
                bold = true,
              },
            },
          },
        },
      })
      require("render-markdown").setup(opts)
    end,
  },
}
