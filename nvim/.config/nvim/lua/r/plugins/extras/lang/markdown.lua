local is_render_markdown = true

return {
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
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "markdownlint-cli2", "markdown-toc", "codespell" } },
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
  --
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
  -- TABULARIZE
  {
    "godlygeek/tabular", -- tabularize lines of code
    cmd = "Tabularize",
  },
  -- RENDER-MARKDOWN
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
    keys = {
      {
        "<Leader>uR",
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
    opts = function()
      vim.cmd [[hi RenderMarkdownH1Bg guibg=NONE]] -- disable the background color for H1bg
      local H = require "r.settings.highlights"
      H.plugin("RenderMarkdownHi", {
        { RenderMarkdownH1Bg = { fg = "NONE", bg = "NONE", reverse = false } },
        { RenderMarkdownH2Bg = { fg = "NONE", bg = "NONE", reverse = false } },
        { RenderMarkdownH3Bg = { fg = "NONE", bg = "NONE", reverse = false } },
        { RenderMarkdownH4Bg = { fg = "NONE", bg = "NONE", reverse = false } },
        { RenderMarkdownH5Bg = { fg = "NONE", bg = "NONE", reverse = false } },
        { RenderMarkdownH6Bg = { fg = "NONE", bg = "NONE", reverse = false } },
      })
      return {
        bullet = { icons = { "", "•", "", "-", "-" } },
        code = {
          sign = false,
          width = "block",
          position = "right",
          inline_left = "",
          inline_right = "",
          inline_pad = 1,
          right_pad = 1,
          left_pad = 1,
        },
        -- render_modes = { "n", "c", "t", "i" },
        render_modes = true,
        anti_conceal = {
          ignore = {
            bullet = { "n" },
            callout = { "n" },
            check_icon = { "n" },
            check_scope = { "n" },
            code_language = { "n" },
            dash = { "n" },
            head_icon = { "n" },
            link = { "n" },
            quote = { "n" },
            table_border = { "n" },
          },
        },
        heading = {
          enabled = true,
          sign = true,
          -- icons = {},
          icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
          -- icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
        },
        quote = { icon = "▐" },
        pipe_table = { cell = "raw" },
        latex = { enabled = false },
        html = { comment = { conceal = false } },
        overrides = {
          filetype = {
            -- CodeCompanion
            codecompanion = {
              heading = {
                icons = { "󰪥 ", "  ", " ", " ", " ", "" },
                custom = {
                  codecompanion_input = {
                    pattern = "^## Me$",
                    icon = " ",
                    background = "CodeCompanionInputHeader",
                  },
                },
              },
              html = {
                tag = {
                  buf = {
                    icon = "󰌹 ",
                    highlight = "Comment",
                  },
                  image = {
                    icon = "󰥶 ",
                    highlight = "Comment",
                  },
                  file = {
                    icon = "󰨸 ",
                    highlight = "Comment",
                  },
                  url = {
                    icon = " ",
                    highlight = "Comment",
                  },
                },
              },
            },
          },
        },
      }
    end,
  },
}
