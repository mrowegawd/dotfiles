---@return boolean|nil
local is_filetype_is_loclist = function()
  if vim.bo.filetype ~= "qf" then
    RUtils.warn "Not in qf filetype"
    return nil
  end

  if RUtils.qf.is_loclist() then
    return true
  end
  return false
end

---@param cmds { qf: string, lf: string }
---@return string|nil
local call_func = function(cmds)
  local is_ok = is_filetype_is_loclist()
  if is_ok == nil then
    return
  end

  if is_ok then
    return cmds.lf
  end

  return cmds.qf
end

local get_limit_qftf = function()
  local win_width = vim.api.nvim_win_get_width(0)
  return math.floor(win_width * 20 / 100)
end

return {
  -- QUICKER (disabled)
  { -- bisa menggunakan range -> %s/, jangan lupa di 'write' setelah delete range
    "stevearc/quicker.nvim",
    enabled = false,
    event = "VeryLazy",
    ft = "qf",
    opts = {
      opts = {
        number = true,
        signcolumn = "yes",
      },
      highlight = {
        -- Use treesitter highlighting
        treesitter = true,
        -- Use LSP semantic token highlighting
        lsp = true,
        -- Load the referenced buffers to apply more accurate highlights (may be slow)
        load_buffers = false,
      },

      borders = {
        vert = "│",

        -- Strong headers (antar file)
        strong_header = "─",
        strong_cross = "┼",
        strong_end = "┤",

        -- Soft headers (dalam file)
        soft_header = "┄", -- dashed light
        soft_cross = "┼",
        soft_end = "┤",
      },
    },
  },
  -- QFBOOKMARK
  {
    dir = "~/.local/src/nvim_plugins/qfbookmark",
    -- "MadKuntilanak/qfbookmark",
    event = "LazyFile",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<Leader>bC",
        function()
          local qf = require "qfbookmark.qf"
          qf.add_mark_annotation "FIX"
        end,
        desc = "Qf: test",
        mode = { "n", "v" },
      },
      -- {
      --   "<F1>",
      --   function()
      --     local qf = require "qfbookmark.qf"
      --     qf.debug_qf()
      --   end,
      --   desc = "Qf: test",
      --   mode = { "n", "v" },
      -- },
    },
    opts = {
      save_dir = RUtils.config.path.wiki_path .. "/orgmode/nvim-plugin/qfbookmark",
      picker = "fzf-lua",
      window = {
        quickfix = {
          theme = {
            enabled = true,
            limit = get_limit_qftf(),
            highlight = true,
            maxheight = 9,
          },
          actions = {
            default = { auto_close = false },
          },
        },
        buffers = {
          actions = {
            win_resized = false,
          },
        },
        mark = {
          preview_fullscreen = false,
          context_templates = {
            separator = nil, -- or "\n\n" .. string.rep("─", 60) .. "\n\n",
            default = "ask_ai",
            handler = {
              ask_ai = {
                description = "Send to AI for analysis",
                builder = function(ctx)
                  return string.format(
                    [[
  %s

  ```%s
  %s
  ```
  ]],
                    ctx.text,
                    ctx.filetype,
                    table.concat(ctx.lines, "\n")
                  )
                end,
              },
            },
          },
          sinks = {
            default = "codecompanion", -- builtin fallback: clipboard
            handler = {
              avante = function(text)
                require("avante.api").ask { question = text }
              end,
              codecompanion = function(text)
                local Chat = require "codecompanion"
                local chat = Chat.last_chat()
                vim.schedule(function()
                  if not chat then
                    chat = Chat.chat()

                    if not chat then
                      return vim.notify("Something went wrong", vim.log.levels.ERROR)
                    end
                  end
                  chat:add_buf_message {
                    content = text,
                  }
                  chat:submit { auto_submit = true }
                end)
              end,
            },
          },
        },
        note = {
          insert_to_note = {
            enabled = true,
            line_placeholder = "<TEXT_HERE>",
            templates = {
              tomorrow = {
                target = RUtils.file.get_agenda_path "/orgmode/gtd/refile.org",
                description = "Remind me tomorrow",
                templates = function()
                  local Date = require "orgmode.objects.date"
                  local scheduled_date = Date.today().tomorrow()
                  return string.format(

                    [[
  * TODO check this later                                   :mytodo:
    SCHEDULED: <%d-%s-%s %s 18:00>

    #+begin_src %s
    <TEXT_HERE>
    #+end_src
  ]],
                    scheduled_date.year,
                    #tostring(scheduled_date.month) == 1 and "0" .. scheduled_date.month or scheduled_date.month,
                    #tostring(scheduled_date.day) == 1 and "0" .. scheduled_date.day or scheduled_date.day,
                    scheduled_date.dayname,
                    vim.bo.filetype
                  )
                end,
              },
              notice = {
                target = "global", -- "global" | "local" | "target path"
                description = "Quick notice / reminder",
                templates = string.format(
                  [[
  date: %s
  notice:
  <TEXT_HERE>
  ]],
                  os.date "%Y-%m-%d %H:%M"
                ),
              },

              error = {
                target = "local",
                description = "Capture an error / bug for this project",
                templates = string.format(
                  [[
  date: %s
  error:
  <TEXT_HERE>
  ]],
                  os.date "%Y-%m-%d %H:%M"
                ),
              },

              todo = {
                target = "local",
                description = "TODO item with source reference",
                templates = function()
                  return string.format(
                    [[
    - [ ] error ..

      #+begin_src %s
      <TEXT_HERE>
      #+end_src

        ]],
                    vim.bo.filetype
                  )
                end,
              },
            },
          },
        },
      },
      keymaps = {
        actions = { -- General actions
          next_item = "<a-n>",
          prev_item = "<a-p>",
        },

        note = {
          toggle_open_global = ",<",
          toggle_open_local = "<LocalLeader><LocalLeader>",
          layout_rotate = "<a-=>",
          integrations = {
            custom = {
              enabled = true,
              commands = {
                {
                  key = "<LocalLeader><LocalLeader>",
                  cmd = function(opts)
                    opts:add_note_to "todo"
                  end,
                  mode = "v",
                  desc = "Qf: test mark",
                },
                {
                  key = "<LocalLeader>at",
                  cmd = function(opts)
                    opts:add_note_to "tomorrow"
                  end,
                  mode = "v",
                  desc = "Qf: test mark",
                },
              },
            },
          },
        },

        buffers = {
          integrations = {
            custom = {
              enabled = true,
              commands = {
                {
                  key = "sq",
                  cmd = function(opts)
                    opts.selected:add_to "quickfix"
                  end,
                  desc = "Qf: add to quickfix",
                },

                {
                  key = "sd",
                  cmd = function(opts)
                    opts.selected:add_to "DEBUG"
                  end,
                  desc = "Qf: add to debug mark",
                },
                {
                  key = "sn",
                  cmd = function(opts)
                    opts.selected:add_to "NOTE"
                  end,
                  desc = "Qf: add to note mark",
                },
                {
                  key = "sf",
                  cmd = function(opts)
                    opts.selected:add_to "FIX"
                  end,
                  desc = "Qf: add to fix mark",
                },
                {
                  key = "ss",
                  cmd = function(opts)
                    opts.selected:add_to "MARK"
                  end,
                  desc = "Qf: add to mark",
                },
              },
            },
          },
        },

        quickfix = {
          integrations = {
            custom = {
              enabled = true,
              commands = {
                {
                  key = "sd",
                  cmd = function(opts)
                    opts.selected:add_to "DEBUG"
                  end,
                  desc = "Qf: add item to debug mark",
                },
                {
                  key = "sn",
                  cmd = function(opts)
                    opts.selected:add_to "NOTE"
                  end,
                  desc = "Qf: add to note mark",
                },
                {
                  key = "sf",
                  cmd = function(opts)
                    opts.selected:add_to "FIX"
                  end,
                  desc = "Qf: add to fix mark",
                },
                {
                  key = "ss",
                  cmd = function(opts)
                    opts.selected:add_to "MARK"
                  end,
                  desc = "Qf: add to mark",
                },

                -- 🔧 Filter & Update (Quickfix)
                {
                  key = "<LocalLeader>qf",
                  cmd = function()
                    local str_cmd = call_func { qf = "Cfilter", lf = "Lfilter" }
                    if str_cmd then
                      local cmd = string.format([[:%s / /]], str_cmd)
                      vim.api.nvim_feedkeys(cmd, "n", false)
                    end
                  end,
                  desc = "Qf: run Cfilter or Lfilter",
                },
                {
                  key = "<Localleader>qd",
                  cmd = function()
                    local str_cmd = call_func { qf = "cdo", lf = "ldo" }
                    if str_cmd then
                      local cmd = string.format([[:%s %%s///gi | update]], str_cmd)
                      vim.api.nvim_feedkeys(cmd, "n", false)
                    end
                  end,
                  desc = "Qf: run cdo or ldo",
                },

                {
                  key = "<Localleader>qD",
                  cmd = function()
                    local str_cmd = call_func { qf = "cfdo", lf = "lfdo" }
                    if str_cmd then
                      local cmd = string.format([[:%s %%s///gi | update]], str_cmd)
                      vim.api.nvim_feedkeys(cmd, "n", false)
                    end
                  end,
                  desc = "Qf: run cfdo or lfdo",
                },
              },
            },
          },
        },

        mark = {
          integrations = {
            custom = {
              enabled = true,
              commands = {
                {
                  key = "ss",
                  cmd = function(opts)
                    opts.selected:add_to "quickfix"
                  end,
                  desc = "Qf: add to debug quickfix",
                },
              },
            },
          },
        },
      },
    },
  },
}
