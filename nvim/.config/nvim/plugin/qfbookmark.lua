local add_local_or_remote = require("vim-pack").add_local_or_remote

local lazy = require("utils.plugin").require_lazy

local Log = lazy "utils.log"
local ConfigPath = lazy("config").path

---@return boolean|nil
local is_filetype_is_loclist = function()
  if vim.bo.filetype ~= "qf" then
    Log.warn "Not in qf filetype"
    return nil
  end

  if lazy("utils.qf").is_loclist() then
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

add_local_or_remote {
  { src = "nvim-lua/plenary.nvim", setup = false },
  {
    src = "nvim_plugins/qfbookmark",
    opts = function()
      return {
        save_dir = ConfigPath.wiki_path .. "/orgmode/nvim-plugin/qfbookmark",
        picker = "fzf-lua",
        extmarks = {
          priority = 80,
        },
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
                  lazy("avante.api").ask { question = text }
                end,
                codecompanion = function(text)
                  local Chat = lazy "codecompanion"
                  local chat = Chat.last_chat()
                  vim.schedule(function()
                    if not chat then
                      chat = Chat.chat()

                      if not chat then
                        return Log.error "Something went wrong"
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
                  target = ConfigPath.wiki_path .. "/orgmode/gtd/refile.org",
                  description = "Remind me tomorrow",
                  templates = function()
                    return "hello"

                    --                   local Date = lazy "orgmode.objects.date"
                    --                   local scheduled_date = Date.today().tomorrow()
                    --                   return string.format(
                    --
                    --                     [[
                    -- * TODO check this later                                   :mytodo:
                    --   SCHEDULED: <%d-%s-%s %s 18:00>
                    --
                    --   #+begin_src %s
                    --   <TEXT_HERE>
                    --   #+end_src
                    -- ]],
                    --                     scheduled_date.year,
                    --                     #tostring(scheduled_date.month) == 1 and "0" .. scheduled_date.month or scheduled_date.month,
                    --                     #tostring(scheduled_date.day) == 1 and "0" .. scheduled_date.day or scheduled_date.day,
                    --                     scheduled_date.dayname,
                    --                     vim.bo.filetype
                    --                   )
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
            up = { "<a-p>", "<C-k>", "k" },
            down = { "<a-n>", "<C-j>", "j" },

            next_item = "<a-n>",
            prev_item = "<a-p>",

            quit = { "q", "<Esc>","<C-c>" },

            diselect_all = { "D" },
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
                    desc = "Qfmark: test mark",
                  },
                  {
                    key = "<LocalLeader>at",
                    cmd = function(opts)
                      opts:add_note_to "tomorrow"
                    end,
                    mode = "v",
                    desc = "Qfmark: test mark",
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
                    key = "<C-x><C-x>",
                    cmd = function(opts)
                      opts.selected:add_to "quickfix"
                    end,
                    desc = "Qfmark: add to quickfix",
                  },

                  {
                    key = "<C-x><C-d>",
                    cmd = function(opts)
                      opts.selected:add_to "DEBUG"
                    end,
                    desc = "Qfmark: add to debug mark",
                  },
                  {
                    key = "<C-x><C-n>",
                    cmd = function(opts)
                      opts.selected:add_to "NOTE"
                    end,
                    desc = "Qfmark: add to note mark",
                  },
                  {
                    key = "<C-x><C-f>",
                    cmd = function(opts)
                      opts.selected:add_to "FIX"
                    end,
                    desc = "Qfmark: add to fix mark",
                  },
                  {
                    key = "<C-x><C-x>",
                    cmd = function(opts)
                      opts.selected:add_to "MARK"
                    end,
                    desc = "Qfmark: add to mark",
                  },
                },
              },
            },
          },

          quickfix = {
            -- open_toggle_qf = "sj",
            -- open_toggle_loc = "sl",

            -- rename_title = "sT",
            --
            -- add_item_to_qf = "st",
            -- add_item_to_loc = "sy",

            integrations = {
              custom = {
                enabled = true,
                commands = {
                  {
                    key = "<C-x><C-d>",
                    cmd = function(opts)
                      opts.selected:add_to "DEBUG"
                    end,
                    desc = "Qfmark: add item to debug mark",
                  },
                  {
                    key = "<C-x><C-n>",
                    cmd = function(opts)
                      opts.selected:add_to "NOTE"
                    end,
                    desc = "Qfmark: add to note mark",
                  },
                  {
                    key = "<C-x><C-f>",
                    cmd = function(opts)
                      opts.selected:add_to "FIX"
                    end,
                    desc = "Qfmark: add to fix mark",
                  },
                  {
                    key = "<C-x><C-x>",
                    cmd = function(opts)
                      opts.selected:add_to "MARK"
                    end,
                    desc = "Qfmark: add to mark",
                  },

                  -- 🔧 Filter & Update (Quickfix)
                  {
                    key = "<C-x>Ff",
                    cmd = function()
                      local str_cmd = call_func { qf = "Cfilter", lf = "Lfilter" }
                      if str_cmd then
                        local cmd = string.format([[:%s / /]], str_cmd)
                        vim.api.nvim_feedkeys(cmd, "n", false)
                      end
                    end,
                    desc = "Qfmark: run Cfilter or Lfilter",
                  },
                  {
                    key = "<C-x>Fc",
                    cmd = function()
                      local str_cmd = call_func { qf = "cdo", lf = "ldo" }
                      if str_cmd then
                        local cmd = string.format([[:%s %%s///gi | update]], str_cmd)
                        vim.api.nvim_feedkeys(cmd, "n", false)
                      end
                    end,
                    desc = "Qfmark: run cdo or ldo",
                  },

                  {
                    key = "<C-x>Fd",
                    cmd = function()
                      local str_cmd = call_func { qf = "cfdo", lf = "lfdo" }
                      if str_cmd then
                        local cmd = string.format([[:%s %%s///gi | update]], str_cmd)
                        vim.api.nvim_feedkeys(cmd, "n", false)
                      end
                    end,
                    desc = "Qfmark: run cfdo or lfdo",
                  },
                },
              },
            },
          },

          mark = {
            add_mark = "<C-x><C-x>",
            add_fix = "<C-x><C-f>",
            add_debug = "<C-x><C-d>",
            add_mark_annotation = "<C-x><C-n>",

            move_item_down = "<C-n>",
            move_item_up = "<C-p>",

            next_mark = "gn",
            prev_mark = "gp",

            integrations = {
              custom = {
                enabled = true,
                commands = {
                  {
                    key = "<C-x><C-x>",
                    cmd = function(opts)
                      opts.selected:add_to "quickfix"
                    end,
                    desc = "Qfmark: add to debug quickfix",
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

local UtilKey = lazy "utils.map"

UtilKey.nnoremap("<Leader>qF", "<CMD>QfbookmarkPickMaster<CR>", { desc = "Qf: pick master" })
