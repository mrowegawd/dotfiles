local is_render_markdown = true

return {
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        -- ["markdown"] = { "prettier", "markdownlint-cli2", "markdown-toc", "cbfmt" },
        -- ["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc", "cbfmt" },

        ["markdown"] = { "prettier", "markdownlint-cli2", "cbfmt" },
        ["markdown.mdx"] = { "prettier", "markdownlint-cli2", "cbfmt" },

        ["norg"] = { "trim_whitespace", "trim_newlines", "cbfmt" },
        ["org"] = { "trim_whitespace", "trim_newlines", "cbfmt" },
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
        },

        -- NOTE: cbfmt is no longer used since we can use `injected` instead
        cbfmt = { -- use for markdown, org, norg
          cwd = require("conform.util").root_file {
            vim.env.HOME .. "/.config/linters/.cbfmt.toml",
          },
        },

        -- NOTE: orgfmt works as expected, but it applies indentation
        -- to all lines, including those inside code blocks
        orgfmt = {
          format = function(_, ctx, lines, callback)
            local view = vim.fn.winsaveview()
            local out_lines = vim.deepcopy(lines)

            vim.api.nvim_buf_call(ctx.buf, function()
              if ctx.range then
                vim.cmd(string.format("%d,%d=", ctx.range.start[1], ctx.range["end"][1]))
              else
                vim.cmd "normal! gg=G"
              end
            end)

            vim.fn.winrestview(view)
            callback(nil, out_lines)
          end,
        },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "markdownlint-cli2", "markdown-toc", "cspell", "cbfmt" } },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        markdown = { "markdownlint-cli2" },
        -- NOTE: untuk sementara waktu, tidak menggunakan `cspell`, karena
        -- terkendala install indonesian-dict dan juga cara konfigurasi nya
        -- markdown = { "markdownlint-cli2", "cspell" },
        -- norg = { "cspell" },
        -- org = { "cspell" },
      },

      linters = {
        ["markdownlint-cli2"] = {
          args = { "--config", vim.env.HOME .. "/.config/linters/.markdownlint.json" },
        },
        -- codespell = {
        --   args = { "--config=" .. vim.env.HOME .. "/.config/linters/cspell.json" },
        -- },
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
    ft = { "markdown", "rmd", "codecompanion", "octo", "noice", "org" },
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
        mode = { "n", "x" },
        desc = "Toggle: render markdown [render-markdown]",
      },
    },
    opts = {
      custom_handlers = {
        org = {
          parse = RUtils.rendermarkdown.parse_org,
        },
      },
      bullet = { icons = { "", "•", "", "-", "-" } },
      file_types = { "markdown", "codecompanion", "octo", "org", "eldochover" },
      code = {
        sign = false,
        border = "thin",
        position = "right",
        width = "block",
        above = "▁",
        below = "▔",
        language_left = "█",
        language_right = "█",
        language_border = "▁",
        left_pad = 1,
        right_pad = 1,
      },
      render_modes = true,
      link = {
        wiki = {
          icon = " ",
        },
      },
      anti_conceal = {
        ignore = {
          sign = { "n" },
          virtual_lines = { "n" },

          bullet = { "n" },
          callout = { "n" },
          check_icon = { "n" },
          check_scope = { "n" },
          code_language = { "n" },
          dash = { "n" },

          link = { "n" },
          quote = { "n" },
          table_border = { "n" },

          -- for header
          head_icon = { "n" }, -- hanya di Normal mode
          head_background = { "n" },
          head_border = { "n" },
        },
      },
      dash = {
        width = 80,
      },
      heading = {
        enabled = true,
        sign = true,
        width = "full", -- full, block
        left_pad = 0,
        right_pad = 0,
        position = "inline",
        signs = { "1", "2", "3", "4", "5", "6", "7" },
        -- signs = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 ", "󰉱 " },
        icons = { "", "", "", "", "", "", "" },
        -- icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
        -- icons = { "󰪥 ", "󰺕 ", " ", " ", " ", "" },
        -- icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
        -- icons = { "", "", "", "", "", "", },
      },
      quote = {
        icon = "▐",
        highlight = {
          "RenderMarkdownQuote1",
          "RenderMarkdownQuote2",
          "RenderMarkdownQuote3",
          "RenderMarkdownQuote4",
          "RenderMarkdownQuote5",
          "RenderMarkdownQuote6",
        },
      },
      pipe_table = { cell = "padded" },
      latex = { enabled = false },
      html = { comment = { conceal = false } },
      overrides = {
        filetype = {
          org = {
            -- Disable anti_conceal to prevent sign flickering in org buffers
            anti_conceal = { enabled = false },
          },
          noice = {},
          codecompanion = {
            heading = {
              icons = { "󰪥 ", "  ", " ", " ", " ", "" },
              custom = {
                codecompanion_input = {
                  pattern = "^%#%#%sMe",
                  icon = " ",
                  background = "@markup.heading.2.markdown_ai_person",
                },
              },
            },
            html = {
              tag = {
                buf = {
                  icon = "󰌹 ",
                  highlight = "Boolean",
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
    },
  },
}
