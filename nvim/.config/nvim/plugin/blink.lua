local add_on_event = require("vim-pack").add_on_event

local ConfigPath = require("config").path
local Icons = require "icons"

local providers = { "lsp", "snippets", "buffer" } -- remove codeium
local idx = 1

-- Auto-completion and snippets.
add_on_event({ "CmdlineEnter", "InsertEnter" }, {
  { src = "saghen/blink.lib", setup = false },
  { src = "mikavilpas/blink-ripgrep.nvim", setup = false },
  { src = "Kaiser-Yang/blink-cmp-git", setup = false },
  {
    src = "L3MON4D3/LuaSnip",
    module_name = "luasnip",
    opts = function()
      local types = require "luasnip.util.types"
      return {
        -- Check if the current snippet was deleted.
        delete_check_events = "TextChanged",
        -- Display a cursor-like placeholder in unvisited nodes
        -- of the snippet.
        ext_opts = {
          [types.insertNode] = {
            unvisited = {
              virt_text = { { "|", "Conceal" } },
              virt_text_pos = "inline",
            },
          },
          [types.exitNode] = {
            unvisited = {
              virt_text = { { "|", "Conceal" } },
              virt_text_pos = "inline",
            },
          },
          [types.choiceNode] = {
            active = {
              virt_text = { { "(snippet) choice node", "LspInlayHint" } },
            },
          },
        },
      }
    end,
    on_setup = function()
      -- Load my custom snippets:
      require("luasnip.loaders.from_vscode").lazy_load {
        paths = ConfigPath.snippet_path,
      }

      vim.keymap.set("i", "<C-r>s", function()
        require("luasnip.extras.otf").on_the_fly "s"
      end, { desc = "Insert on-the-fly snippet" })

      -- Use <C-c> to select a choice in a snippet.
      vim.keymap.set({ "i", "s" }, "<C-c>", function()
        ---@diagnostic disable-next-line: undefined-field
        if require("luasnip").choice_active() then
          require "luasnip.extras.select_choice"()
        end
      end, { desc = "Select choice" })
    end,
  },
  {
    src = "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "none", -- 'enter', 'none' -> (disable all mappings)
        -- How to disable keymap? -> ["<C-e>"] = {},
        ["<C-f>"] = {},
        ["<C-e>"] = {},
        ["<C-b>"] = {},

        -- ["<a-y>"] = { "select_and_accept" },
        ["<a-y>"] = {
          function(cmp)
            local luasnip = require "luasnip"
            if cmp.is_visible() then
              return cmp.select_and_accept()
            elseif luasnip.expand_or_jumpable() then
              return cmp.accept()
            elseif luasnip.get_active_snip() then
              return luasnip.jump(1)
            elseif vim.snippet.active() then
              return vim.snippet.jump(1)
            end
          end,
          "fallback",
        },
        ["<Tab>"] = {
          function()
            local luasnip = require "luasnip"
            if luasnip.expand_or_jumpable() then
              return luasnip.expand_or_jump()
            elseif luasnip.get_active_snip() then
              return luasnip.jump(1)
            elseif vim.snippet.active() then
              return vim.snippet.jump(1)
            end
          end,
          "fallback",
        },
        ["<S-Tab>"] = {
          function()
            local luasnip = require "luasnip"
            if luasnip.get_active_snip() then
              return luasnip.jump(-1)
            elseif vim.snippet.active() then
              return vim.snippet.jump(-1)
            else
              local cur = vim.api.nvim_win_get_cursor(0)
              pcall(vim.api.nvim_win_set_cursor, 0, { cur[1], cur[2] - 1 })
            end
          end,
        },
        ["<C-s>"] = {
          function()
            require("luasnip").unlink_current()
          end,
        },
        ["<c-g>"] = {
          function(cmp)
            return cmp.show { providers = { "ripgrep" } }
          end,
        },
        ["<a-r>"] = {
          function(cmp)
            local current_provider = providers[idx]
            cmp.show { providers = { current_provider } }
            idx = (idx % #providers) + 1
          end,
        },
        ["<a-q>"] = { "hide" },
        ["<a-n>"] = {
          function(cmp)
            if not cmp.is_visible() then
              cmp.show {}
            else
              cmp.select_next()
            end
          end,
        },
        ["<a-p>"] = {
          function(cmp)
            if cmp.is_visible() then
              cmp.select_prev()
            end
          end,
        },

        ["<C-p>"] = { "scroll_documentation_up", "fallback" },
        ["<C-n>"] = { "scroll_documentation_down", "fallback" },
      },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        list = {
          selection = {
            preselect = function(ctx)
              return ctx.mode == "cmdline" and not require("blink.cmp").snippet_active { direction = 1 }
            end,
            auto_insert = function(ctx)
              return ctx.mode == "cmdline" and not require("blink.cmp").snippet_active { direction = 1 }
            end,
          },
          max_items = 50,
        },
        menu = {
          max_height = 20,
          border = "none",
          winhighlight = "Normal:Pmenu,FloatBorder:PmenuFloatBorder,CursorLine:PmenuSel,Search:None",
          draw = {
            treesitter = { "lsp" },
            columns = {
              { "kind_icon" },
              { "label" },
              { "source_name" },
            },
            components = {
              label = {
                width = { fill = true, max = 60 },
                text = function(ctx)
                  if ctx.kind == "Snippet" then
                    return ctx.item.label .. "_" -- add suffix `_` for snippet kind
                  end
                  return ctx.label
                end,
                highlight = function(ctx)
                  -- https://github.com/saghen/blink.cmp/blob/033fbcc7ec55546aa0c3889aa50b6e76915c3f62/doc/configuration/reference.md#completion-menu-draw
                  local highlights = {
                    {
                      0,
                      #ctx.label,
                      group = ctx.deprecated and "BlinkCmpLabelDeprecated" or "LspKind" .. ctx.kind,
                    },
                  }

                  if ctx.label_detail then
                    table.insert(highlights, { #ctx.label, #ctx.label + #ctx.label_detail, group = "Comment" })
                  end

                  for _, item_idx in ipairs(ctx.label_matched_indices) do
                    table.insert(highlights, { item_idx, item_idx + 1, group = "BlinkCmpLabelMatch" })
                  end

                  return highlights
                end,
              },
              kind_icon = {
                text = function(ctx)
                  if ctx.source_name == "Cmdline" then
                    return ""
                  end

                  local kind = ""

                  if ctx.kind == "Color" then
                    return "██"
                  end

                  if ctx.kind == "Commit" then
                    kind = Icons.git.unmerged
                  elseif ctx.source_name == "codecompanion" then
                    kind = ctx.kind_icon
                  else
                    kind = Icons.kinds[ctx.kind] or ""
                  end

                  return " " .. require("utils.cmd").strip_whitespaces(kind) .. " "
                end,
                highlight = function(ctx)
                  if ctx.deprecated then
                    return "BlinkCmpLabelDeprecated"
                  end

                  if ctx.kind == "Text" then
                    return ""
                  end

                  return "LspKind" .. ctx.kind
                end,
              },
              source_name = {
                ellipsis = false,
                width = { fill = true },
                text = function(ctx)
                  local map = {
                    buffer = "[Buffer]",
                    codecompanion = "[CodeCompanion]",
                    copilot = "[Copilot]",
                    dbee = "[dbee]",
                    emoji = "[Emoji]",
                    git = "[Git]",
                    lsp = "[LSP]",
                    luasnip = "[Snippet]",
                    path = "[Path]",
                    tmux = "[Tmux]",
                  }
                  return map[ctx.source_id]
                    or map[ctx.source_name]
                    or ("[" .. (ctx.source_name or ctx.source_id or "?") .. "]")
                end,
                highlight = function(item)
                  if item.deprecated then
                    return "BlinkCmpLabelDeprecated"
                  end
                  if item.kind == "Color" then
                    return item.kind_hl
                  end
                  return vim.tbl_contains({ "org", "markdown" }, vim.bo.filetype) and "BlinkCmpLabelKindNote"
                    or "BlinkCmpLabelKind"
                end,
              },
            },
          },
        },
        documentation = {
          auto_show = true,
          window = {
            border = Icons.border.rightsideonly, -- or "none",
            winhighlight = "Normal:BlinkDocNormal,FloatBorder:BlinkDocFloatBorder,CursorLine:PmenuSel,Search:None",
          },
          -- draw = function(opts)
          --   opts.default_implementation()
          --   vim.schedule(function()
          --     _G.LspConfig.highlight_doc_patterns(opts.window.buf)
          --     local win_id = opts.window:get_win()
          --     if win_id then
          --       require("render-markdown.core.ui").update(opts.window.buf, win_id, "BlinkDraw", true)
          --     end
          --   end)
          -- end,
        },
        ghost_text = {
          enabled = false,
        },
      },
      snippets = { preset = "luasnip" },
      -- Disable command line completion:
      cmdline = {
        completion = { menu = { auto_show = true }, ghost_text = { enabled = false } },
        keymap = {
          preset = "none",
          ["<Right>"] = false,
          ["<Left>"] = false,

          ["<a-y>"] = { "select_and_accept" },

          ["<a-j>"] = {
            function()
              local type = vim.fn.getcmdtype()
              if type == "/" or type == "?" then
                return require("utils.map").feedkey "<C-Down>"
              end
              if type == ":" or type == "@" then
                return require("utils.map").feedkey "<C-Down>"
              end
            end,
          },
          ["<a-k>"] = {
            function()
              local type = vim.fn.getcmdtype()
              if type == "/" or type == "?" then
                return require("utils.map").feedkey "<C-Up>"
              end
              if type == ":" or type == "@" then
                return require("utils.map").feedkey "<C-Up>"
              end
            end,
          },
          ["<a-n>"] = {
            function(cmp)
              if not cmp.is_visible() then
                local type = vim.fn.getcmdtype()
                if type == "/" or type == "?" then
                  return require("utils.map").feedkey "<C-Down>"
                end
                if type == ":" or type == "@" then
                  return require("utils.map").feedkey "<C-Down>"
                end
              else
                cmp.select_next()
              end
            end,
          },
          ["<a-p>"] = {
            function(cmp)
              if not cmp.is_visible() then
                local type = vim.fn.getcmdtype()
                if type == "/" or type == "?" then
                  return require("utils.map").feedkey "<C-Up>"
                end
                if type == ":" or type == "@" then
                  return require("utils.map").feedkey "<C-Up>"
                end
              else
                cmp.select_prev()
              end
            end,
          },
          ["<a-r>"] = {
            "hide",
            "cancel",
            "show",
          },
          ["<a-q>"] = {
            "hide",
            "cancel",
            function()
              if vim.fn.getcmdtype() ~= "" then
                return require("utils.map").feedkey "<C-c>"
              end
            end,
          },
        },
      },
      sources = {
        -- Disable some sources in comments and strings.
        default = function()
          local sources = { "lsp", "buffer" }
          local ok, node = pcall(vim.treesitter.get_node)

          if ok and node then
            if not vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type()) then
              table.insert(sources, "path")
            end
            if node:type() ~= "string" then
              table.insert(sources, "snippets")
            end
          end

          if vim.bo.filetype == "grug-far" then
            table.insert(sources, "path")
          end

          return sources
        end,
        per_filetype = { org = { inherit_defaults = true, "org" } },
        providers = {
          org = { name = "Org", module = "org.completion.blink" },
          git = {
            module = "blink-cmp-git",
            name = "Git",
            enabled = function()
              return vim.tbl_contains({ "octo", "gitcommit", "markdown" }, vim.bo.filetype)
            end,
            opts = {
              before_reload_cache = function() end,
            },
          },
          ripgrep = {
            name = "RG",
            module = "blink-ripgrep",
            opts = {
              project_root_marker = { "package.json", ".git" },
              backend = {
                use = "gitgrep-or-ripgrep",
              },
            },
          },
        },
      },
      appearance = {
        kind_icons = require("icons").kinds,
      },
    },
  },
})

local on_plugin_update = require("vim-pack").on_plugin_update

on_plugin_update("nvim-treesitter", function()
  ---@diagnostic disable-next-line: undefined-field
  require("blink.cmp").build():pwait()
end)
