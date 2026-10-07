local add_on_file_type = require("vim-pack").add_on_file_type

local allow_ft_render_markdown = { "markdown", "octo", "noice", "eldochover", "codecompanion" }

-- Markdown preview on the browser.
add_on_file_type(allow_ft_render_markdown, {
  {
    src = "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      -- custom_handlers = {
      --   org = {
      --     parse = RUtils.rendermarkdown.parse_org,
      --   },
      -- },
      bullet = { icons = { "", "•", "", "-", "-" } },
      file_types = allow_ft_render_markdown,
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
          -- org = {
          --   -- Disable anti_conceal to prevent sign flickering in org buffers
          --   anti_conceal = { enabled = true },
          -- },
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
})
