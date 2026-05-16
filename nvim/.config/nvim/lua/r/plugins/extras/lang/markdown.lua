local is_render_markdown = true

return {
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["markdown"] = { "prettier", "markdownlint-cli2", "markdown-toc", "injected" },
        ["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc", "injected" },

        ["norg"] = { "trim_whitespace", "trim_newlines", "injected" },
        ["org"] = { "trim_whitespace", "trim_newlines", "injected" },
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
        ["markdownlint-cli2"] = {
          condition = function(_, ctx)
            local diag = vim.tbl_filter(function(d)
              return d.source == "markdownlint"
            end, vim.diagnostic.get(ctx.buf))
            return #diag > 0
          end,
        },

        -- NOTE: cbfmt is no longer used
        -- since we can use `injected` instead
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
    opts = { ensure_installed = { "markdownlint-cli2", "markdown-toc", "cspell" } },
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
    ft = { "markdown", "rmd", "codecompanion", "octo", "noice" },
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
        ft = { "markdown", "neorg", "org", "rmd", "octo" },
        mode = { "n", "x" },
        desc = "ActionLSP: toggle render markdown [render-markdown]",
      },
    },
    opts = function()
      local H = require "r.settings.highlights"
      vim.schedule(function()
        RUtils.map.augroup("HiMarkdownRender", {
          event = "FileType",
          pattern = "codecompanion",
          command = function(ctx)
            if vim.bo[ctx.buf].filetype == "codecompanion" then
              H.plugin("RenderMarkdownH2", {
                { RenderMarkdownH1Bg = { inherit = "@markup.heading.1.markdown_ai" } },
                { RenderMarkdownH2Bg = { inherit = "@markup.heading.2.markdown_ai" } },
                { RenderMarkdownH3Bg = { inherit = "@markup.heading.3.markdown_ai" } },
                { RenderMarkdownH4Bg = { inherit = "@markup.heading.4.markdown_ai" } },
                { RenderMarkdownH5Bg = { inherit = "@markup.heading.5.markdown_ai" } },
                { RenderMarkdownH6Bg = { inherit = "@markup.heading.6.markdown_ai" } },
              })
              return
            end
          end,
        })
      end)

      return {
        bullet = { icons = { "", "•", "", "-", "-" } },
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
        dash = {
          width = 80,
        },
        heading = {
          enabled = true,
          sign = false,
          width = "full", -- full, block
          left_pad = 1,
          right_pad = 0,
          position = "inline",
          -- icons = {
          --   "",
          --   "",
          --   "",
          --   "",
          --   "",
          --   "",
          -- },
          icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
          -- icons = { "󰪥 ", "󰺕 ", " ", " ", " ", "" },
          -- icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
          signs = {
            "󰉫 ", -- H1
            "󰉬 ", -- H2
            "󰉭 ", -- H3
            "󰉮 ", -- H4
            "󰉯 ", -- H5
            "󰉰 ", -- H6
            "󰉱 ", -- H7
          },
        },
        quote = { icon = "▐" },
        pipe_table = { cell = "raw" },
        latex = { enabled = false },
        html = { comment = { conceal = false } },
        overrides = {
          filetype = {
            noice = {},
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
  -- Reset priority outline for markdown
  {
    "MadKuntilanak/outline.nvim",
    ft = "markdown",
    opts = {
      providers = {
        priority = { "markdown", "lsp", "norg" },
      },
    },
  },
}
