local fmt, api = string.format, vim.api
local uv = vim.uv or vim.loop

local Config = require "r.config"
local Util = require "r.utils"
local Highlight = require "r.settings.highlights"

local fzf_lua = Util.cmd.reqcall "fzf-lua"

return {
  -- NEORG
  {
    "nvim-neorg/neorg",
    cmd = "Neorg",
    ft = "norg",
    build = ":Neorg sync-parsers", -- This is the important bit!
    -- keys = {
    -- {
    --   "<Localleader>fL",
    --   function()
    --     Util.maim.insert "test.png"
    --   end,
    -- },
    -- {
    --   "<Localleader>fo",
    --   function()
    --     if vim.bo.filetype == "norg" then
    --       return cmd [[Neorg return]]
    --     else
    --       return cmd [[Neorg workspace wiki]]
    --     end
    --   end,
    --   desc = "Note(neorg): open neorg workspace",
    -- },
    -- {
    --   "<Localleader>ff",
    --   function()
    --     cmd [[Lazy load neorg]]
    --
    --     return fzf_lua.files {
    --       prompt = "  ",
    --       cwd = Config.path.wiki_path,
    --       rg_glob = true,
    --       file_ignore_patterns = { "%.md$", "%.json$", "%.org$" },
    --       winopts = {
    --         -- fullscreen = true,
    --         title = Util.fzflua.format_title("[Neorg] Files", " "),
    --       },
    --     }
    --   end,
    --   desc = "Note(fzflua): find neorg files",
    -- },
    -- {
    --   "<Localleader>fg",
    --   function()
    --     cmd [[Lazy load neorg]]
    --     return fzf_lua.live_grep_glob {
    --       prompt = "  ",
    --       cwd = Config.path.wiki_path,
    --       rg_opts = [[--column --hidden --no-heading --ignore-case --smart-case --color=always  --max-columns=4096 -g "*.norg" ]],
    --       winopts = {
    --         title = Util.fzflua.format_title("[Neorg] Grep", " "),
    --       },
    --     }
    --   end,
    --   desc = "Note(fzflua): live grep neorg files",
    -- },
    -- },
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-neorg/neorg-telescope",
      "nvim-treesitter/nvim-treesitter",
      "ibhagwan/fzf-lua",
      "nvim-lua/plenary.nvim",
      "laher/neorg-exec",
    },
    config = function(_, opts)
      Util.cmd.augroup("ManageNoteMappingNeorg", {
        event = { "FileType" },
        pattern = { "norg" },
        command = function()
          require("r.keymaps.note").neorg_mappings_ft(api.nvim_get_current_buf())
        end,
      })

      Util.cmd.augroup("SetNorgFoldLevel", {
        event = { "FileType" },
        pattern = { "norg" },
        command = "setlocal foldlevel=0",
      })
      require("neorg").setup(opts)

      -- local path_img = "test.png"
      --
      -- local invoke_screenshot_to_neorg = function(output_path, title)
      --   title = title or "image"
      --   local maim = require "maim"
      --
      --   local command_output = maim.invoke_screenshot(path_img)
      --   -- invoke_screenshot(output_path)
      --   -- local image_markdown = "![" .. title .. "](" .. output_path .. ")"
      --   local image_neorg = ".image" .. command_output
      --
      --   if next(command_output) ~= nil then
      --     vim.notify("Could not write to " .. output_path)
      --     vim.notify(command_output)
      --     return
      --   end
      --
      --   if not vim.fn.exists(output_path) then
      --     vim.notify("could not locate " .. output_path .. " but the command looked successful")
      --     return
      --   end
      --
      --   vim.cmd("normal A" .. image_neorg)
      -- end
      --
      -- Util.cmd.create_command("MaimNeorg", invoke_screenshot_to_neorg(), { desc = "Maim: put image (neorg)" })
    end,
    opts = function()
      -- local invoke_screenshot = function(output_path)
      --   assert(output_path ~= nil, "output_path must be a provided")
      --   assert(type(output_path) == "string", "output_path must be a string")
      --
      --   local executable = "maim"
      --   local file_options = "-s"
      --
      --   local current_buffer = vim.api.nvim_buf_get_name(0)
      --   local current_directory = vim.fs.dirname(current_buffer)
      --   output_path = utils.get_current_buffer_directory(output_path, current_buffer, current_directory)
      --
      --   local command = executable .. " " .. file_options .. " " .. output_path
      --   -- vim.notify(command, 'debug')
      --
      --   return vim.fn.systemlist(command)
      -- end

      return {
        load = {
          ["core.defaults"] = {},
          ["core.concealer"] = {
            config = {
              init_open_folds = "never", -- dont let neorg set the fold
              icons = {
                code_block = {
                  width = "content",
                  conceal = true,
                },
              },
            },
          },
          ["core.ui"] = {},
          ["core.summary"] = {},
          ["external.exec"] = {
            config = {
              -- default_metadata = {
              --   enabled = false,
              --   env = {
              --     NEORG: "rocks"
              --   },
              lang_cmds = {
                rust = {
                  cmd = "rustc ${0} -o ./a.out && ./a.out && rm ./a.out",
                  type = "compiled",
                  main_wrap = [[
                ${1}
                ]],
                },
                go = {
                  cmd = "goimports -w ${0} && NO_COLOR=1 go run ${0}",
                  type = "compiled",
                  main_wrap = [[
                ${1} ]],
                },
              },
            },
          },
          ["core.highlights"] = {
            config = {
              highlights = {
                markup = {
                  bold = { [""] = "+Boolean" },
                  verbatim = { [""] = "+CodeLine1", delimiter = "+NonText" },
                },
              },
              dim = {
                tags = {
                  ranged_verbatim = {
                    code_block = {
                      reference = "CodeBlock1",
                      affect = "background",
                    },
                  },
                },
                markup = {
                  verbatim = {
                    reference = "CodeLine1",
                  },
                },
              },
            },
          },
          ["core.export"] = {},
          ["core.export.markdown"] = { config = { extensions = "all" } },
          ["core.dirman"] = {
            config = {
              workspaces = {
                gtd = fmt("%s/gtd", Config.path.wiki_path),
                wiki = Config.path.wiki_path,
              },
            },
          },
          ["core.esupports.metagen"] = {
            config = {
              type = "auto",
            },
          },
          ["core.completion"] = {
            config = {
              engine = "nvim-cmp",
              name = "[Norg]",
            },
          },
          ["core.integrations.nvim-cmp"] = {},
          -- ["core.integrations.telescope"] = {},
          ["core.keybinds"] = {
            config = {
              default_keybinds = false,
              hook = function(keybinds)
                -- EXAMPLE ================================================
                -- Unmaps any Neorg key from the `norg` mode
                -- keybinds.unmap("norg", "n", "gtd")

                -- Binds the `gtd` key in `norg` mode to execute `:echo 'Hello'`
                -- keybinds.map("norg", "n", "gtd", "<cmd>echo 'Hello!'<CR>")

                -- Want to move one keybind into the other? `remap_key` moves the data of the
                -- first keybind to the second keybind, then unbinds the first keybind.
                -- keybinds.remap_key("norg", "n", "<C-c>", "<Leader>t")

                -- Remap unbinds the current key then rebinds it to have a different action
                -- associated with it.
                -- The following is the equivalent of the `unmap` and `map` calls you saw above:
                --
                -- Sometimes you may simply want to rebind the Neorg action something is bound to
                -- versus remapping the entire keybind. This remap is essentially the same as if you
                -- did `keybinds.remap("norg", "n", "<C-c>, "<cmd>Neorg keybind norg core.norg.qol.todo_items.todo.task_done<CR>")
                -- keybinds.remap_event(
                --     "norg",
                --     "n",
                --     "<C-c>",
                --     "core.norg.qol.todo_items.todo.task_done"
                -- )
                -- ========================================================

                keybinds.remap_event("norg", "n", "<Leader>oo", "core.esupports.hop.hop-link")
                -- keybinds.remap_event("norg", "n", "<M-CR>", "core.esupports.hop.hop-link", "vsplit")

                -- go next heading fold
                keybinds.remap_event("norg", "n", "<a-n>", "core.integrations.treesitter.next.heading")
                -- go prev heading fold
                keybinds.remap_event("norg", "n", "<a-p>", "core.integrations.treesitter.previous.heading")

                keybinds.remap_event("norg", "n", "<C-c>", "core.qol.todo_items.todo.task_cycle")

                -- keybinds.remap_event("norg", "n", "<right>", "core.promo.promote")
                -- keybinds.remap_event("norg", "n", "<left>", "core.promo.demote")
                keybinds.map("norg", "n", "<right>", "<cmd>Neorg keybind norg core.promo.promote nested<CR>", {})
                keybinds.map("norg", "n", "rl", "<cmd>Neorg exec cursor<CR>", {})
                keybinds.map("norg", "n", "<left>", "<cmd>Neorg keybind norg core.promo.demote nested<CR>", {})
                --
              end,
            },
          },
        },
      }
    end,
  },
  -- ORGMODE
  {
    "nvim-orgmode/orgmode",
    event = "LazyFile",
    -- ft = "org",
    keys = {
      {
        "<Localleader>fA",
        function()
          return require("r.utils").neorg.open_orgagenda_paths()
        end,
        desc = "Note(orgmode): open orgmode paths",
      },
      "<Localleader>fc",
      "<Localleader>fa",
    },
    dependencies = {
      "hrsh7th/nvim-cmp",
      {
        "akinsho/org-bullets.nvim",
        config = function()
          require("org-bullets").setup {
            concealcursor = true, -- If false then when the cursor is on a line underlying characters are visible
            symbols = {
              headlines = { "◉", "○", "✸", "✿" },
              checkboxes = {
                half = { "", "OrgTSCheckboxHalfChecked" },
                done = { "✓", "OrgDone" },
                todo = { "˟", "OrgTODO" },
              },
            },
          }
        end,
      },
    },
    opts = {
      ui = {
        menu = {
          handler = function(data)
            local items = vim
              .iter(data.items)
              :map(function(i)
                return (i.key and not i.label:lower():match "quit") and i or nil
              end)
              :totable()

            vim.ui.select(items, {
              prompt = fmt(Config.icons.misc.fire .. " %s ", data.prompt),
              kind = "pojokan",
              format_item = function(item)
                return fmt("%s → %s", item.key, item.label)
              end,
            }, function(choice)
              if not choice then
                return
              end
              if choice.action then
                choice.action()
              end
            end)
          end,
        },
      },
      org_agenda_files = {
        fmt("%s/orgmode/gtd/*", Config.path.wiki_path),
        fmt("%s/orgmode/bookmarks/*", Config.path.wiki_path),
        fmt("%s/orgmode/habit/*", Config.path.wiki_path),
        fmt("%s/orgmode/day-to-remember/*", Config.path.wiki_path),
        fmt("%s/orgmode/project-todo/**/*", Config.path.wiki_path),
      },
      org_default_notes_file = fmt("%s/orgmode/gtd/refile.org", Config.path.wiki_path),
      org_todo_keywords = {
        "TODO(t)",
        "HOLD(h)", -- task yang ditangguhkan, no hint to continue
        "INPROGRESS(i)", -- task yang sedang dikerjakan
        "CHECK(c)", -- task yang boleh dikerjakan saat free-time
        "HBD(b)",
        "|",
        "DONE(d)",
        "",
      },
      org_todo_keyword_faces = {
        CHECK = ":foreground royalblue :weight bold :slant",
        TODO = ":foreground pink :weight bold :slant",
        INPROGRESS = ":foreground magenta :weight bold :slant italic",
        UNTASK = ":foreground deeppink :weight bold",
        HBD = ":foreground magenta :weight bold :slant",
        HOLD = ":foreground gray :weight bold :slant",
        DONE = ":foreground green :weight bold :slant",
        -- NEXT = ":foreground orange :weight bold",
      },
      org_agenda_skip_scheduled_if_done = true,
      org_hide_emphasis_markers = true,
      org_capture_templates = {
        t = {
          description = "Todo",
          template = "* TODO %? \n  SCHEDULED: %T",
          target = Config.path.wiki_path .. "/orgmode/gtd/refile.org",
        },
        i = {
          description = "Inbox me (Inbox)",
          -- template = "* %?",
          template = "* CHECK %? \n  SCHEDULED: %t",
          target = Config.path.wiki_path .. "/orgmode/gtd/inbox.org",
        },
        l = {
          description = "Link (Inbox)",
          -- template = "\n* CHECK %?\n  SCHEDULED: %t\n  %a\n\n",
          template = "* CHECK %?\n  SCHEDULED: %t\n  %a\n\n",
          target = Config.path.wiki_path .. "/orgmode/gtd/inbox.org",
        },
        u = {
          description = "URL bookmarks",
          template = "* RAPIKAN: %? \n  SCHEDULED: %t",
          target = Config.path.wiki_path .. "/orgmode/bookmarks/urls.org",
        },
        -- j = {
        --     description = "Journal",
        --     template = "\n** %<%Y-%m-%d> %<%A>\n*** %U\n\n%?",
        --     target = Config.path.wiki_path.. "/orgmode/gtd/journal.org",
        -- },
        -- k = {
        --     description = "Markdown",
        --     template = "\n* TODO %? \n  SCHEDULED: %t",
        --     target = Config.path.wiki_path .. "/orgmode/gtd/base.md",
        --     filetype = "markdown",
        -- },
      },
      win_split_mode = function(name)
        local bufnr = vim.api.nvim_create_buf(false, true)
        --- Setting buffer name is required
        vim.api.nvim_buf_set_name(bufnr, name)
        local fill = 0.4
        local width = math.floor((vim.o.columns * fill))
        local height = math.floor((vim.o.lines * fill))
        local row = math.floor((((vim.o.lines - height) / 2) - 1))
        local col = math.floor(((vim.o.columns - width) / 2))
        vim.api.nvim_open_win(bufnr, true, {
          relative = "editor",
          width = width,
          height = height,
          row = row,
          col = col,
          style = "minimal",
          border = "rounded",
        })
      end,
      mappings = {
        disable_all = false,
        prefix = "<Leader>o",
        global = {
          org_capture = "<Localleader>fc",
          org_agenda = "<Localleader>fa",
        },
        agenda = {
          org_agenda_later = "f",
          org_agenda_earlier = "b",
          org_agenda_goto_today = "@",
          org_agenda_day_view = "vd",
          org_agenda_week_view = "vw",
          org_agenda_month_view = "vm",
          org_agenda_year_view = "vy",
          org_agenda_quit = "q",
          org_agenda_switch_to = nil,
          org_agenda_goto = "<TAB>",
          org_agenda_show_help = "?",
          org_agenda_redo = "r",
          org_agenda_goto_date = "cd",
          org_agenda_todo = "ct",
          org_agenda_clock_goto = "<prefix>xj",
          org_agenda_set_effort = "<prefix>xe",
          org_agenda_clock_in = "<prefix>I",
          org_agenda_clock_out = "<prefix>O",
          org_agenda_clock_cancel = "<prefix>C",
          org_agenda_clockreport_mode = "R",
          org_agenda_priority = "<prefix>1",
          org_agenda_priority_up = "<c-Up>",
          org_agenda_priority_down = "<c-Down>",
          org_agenda_archive = "<prefix>$",
          org_agenda_toggle_archive_tag = "<leader>T",
          org_agenda_set_tags = "<leader>t",
          org_agenda_deadline = "<leader>d",
          org_agenda_schedule = "<leader>s",
          org_agenda_filter = "/",
        },
        capture = {
          org_capture_finalize = "<C-c>",
          org_capture_refile = "<Leader>or",
          org_capture_kill = { "q", "<ESC>" },
          org_capture_show_help = "?",
        },
        org = {
          org_refile = "<prefix>r",
          org_timestamp_up = "<c-a>",
          org_timestamp_down = "<c-x>",
          org_change_date = "cid",
          org_todo = "cit",
          org_toggle_checkbox = "<C-c>",
          org_open_at_point = "<prefix>o",
          org_meta_return = "<F12>", -- Add heading, item or row
          org_return = "<F11>",
          -- org_global_cycle = "<a-o>",
          -- org_cycle = "<BS>",
          -- org_cycle = "<TAB>",
          org_cycle = "<BS>",
          org_global_cycle = "<S-TAB>",
          org_archive_subtree = "<prefix>$",
          org_set_tags_command = "<Leader>t",
          org_toggle_archive_tag = "<Leader>T",
          org_next_visible_heading = "<a-n>",
          org_previous_visible_heading = "<a-p>",
          org_toggle_heading = "<leader>o*",
          org_show_help = "?",
          org_timestamp_up_day = "<PageUp>",
          org_timestamp_down_day = "<PageDown>",
          org_priority = "<prefix>,",
          org_priority_up = "<c-Up>",
          org_priority_down = "<c-Down>",
          org_todo_prev = "ciT",
          org_edit_special = [[<prefix>']],
          org_do_promote = "<<",
          org_do_demote = ">>",
          org_promote_subtree = "<left>",
          org_demote_subtree = "<right>",
          org_insert_heading_respect_content = "<prefix>ih", -- Add new headling after current heading block with same level
          org_insert_todo_heading = "<prefix>iT", -- Add new todo headling right after current heading with same level
          org_insert_todo_heading_respect_content = "<prefix>it", -- Add new todo headling after current heading block on same level
          org_move_subtree_up = "<S-UP>",
          org_move_subtree_down = "<S-DOWN>",
          org_export = "<leader>a",
          org_forward_heading_same_level = "]]",
          org_backward_heading_same_level = "[[",
          outline_up_heading = "g{",
          org_time_stamp = "<prefix>it",
          org_time_stamp_inactive = "<prefix>iT",
          org_deadline = "<leader>d",
          org_schedule = "<leader>s",
          org_clock_in = "<prefix>I",
          org_clock_out = "<prefix>O",
          org_clock_cancel = "<prefix>C",
          org_clock_goto = "<prefix>xj",
          org_set_effort = "<prefix>xe",
        },
      },
    },
    config = function(_, opts)
      Highlight.plugin("Org_HiCus", {
        theme = {
          ["miasma"] = {
            { OrgAgendaScheduled = { fg = { from = "LineNr", attr = "fg", alter = 1 } } },
          },
        },
      })

      local orgmode = require "orgmode"
      -- orgmode.setup_ts_grammar()
      orgmode.setup(opts)
    end,
  },
  -- CALENDAR-VIM
  {
    "renerocksai/calendar-vim",
    cmd = "Calendar",
    config = true,
  },
  -- IMAGE.NVIM
  {
    "3rd/image.nvim",
    ft = { "markdown", "norg", "oil" },
    enabled = function()
      if vim.g.neovide then
        return false
      end
      return true
    end,
    build = function()
      -- Requirements (linux):
      -- sudo apt-get install libmagickwand-dev
      -- sudo apt-get install libgraphicsmagick1-dev
      local has_magick = pcall(require, "magick")
      if not has_magick and vim.fn.executable "luarocks" == 1 then
        local is_mac = uv.os_uname().sysname == "Darwin"
        if is_mac then
          vim.fn.system "luarocks --lua-dir=$(brew --prefix)/opt/lua@5.1 --lua-version=5.1 install magick"
        else
          vim.fn.system "luarocks --local --lua-version=5.1 install magick"
        end
        if vim.v.shell_error ~= 0 then
          vim.notify("Error installing magick with luarocks", vim.log.levels.WARN)
        end
      end
    end,
    opts = {
      backend = "ueberzug",
      editor_only_render_when_focused = true, -- auto show/hide images when the editor gains/looses focus
      tmux_show_only_in_active_window = true,
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
        },
        neorg = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "norg" },
        },
      },
    },
    config = function(_, opts)
      -- Requirements (linux):
      -- sudo apt-get install libmagickwand-dev
      -- sudo apt-get install libgraphicsmagick1-dev
      local has_magick = pcall(require, "magick")
      if has_magick then
        require("image").setup(opts)
      end
    end,
  },
  -- OBSIDIAN.NVIM
  {
    "epwalsh/obsidian.nvim",
    event = {
      -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
      -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
      fmt("BufReadPre %s", Config.path.wiki_path),
      fmt("BufNewFile %s", Config.path.wiki_path),
    },
    cmd = {
      "ObsidianOpen",
      "ObsidianNew",
      "ObsidianQuickSwitch",
      "ObsidianFollowLink",
      "ObsidianBacklinks",
      "ObsidianToday",
      "ObsidianYesterday",
      "ObsidianTemplate",
      "ObsidianSearch",
      "ObsidianLink",
      "ObsidianLinkNew",
    },
    keys = {
      {
        "<Localleader>fg",
        function()
          return fzf_lua.live_grep_glob {
            prompt = "  ",
            cwd = Config.path.wiki_path,
            rg_opts = [[--column --hidden --no-heading --ignore-case --smart-case --color=always  --max-columns=4096 -g "*.md" ]],
            winopts = {
              title = Util.fzflua.format_title("[Obsidian] Grep", ""),
            },
          }
        end,
        desc = "Note(fzflua): obsidian search",
      },
      {
        "<Localleader>ff",
        function()
          return fzf_lua.files {
            prompt = "  ",
            cwd = Config.path.wiki_path,
            file_ignore_patterns = { "%.norg$", "%.json$", "%.org$" },
            rg_opts = [[--column --hidden --no-heading --ignore-case --smart-case --color=always  --max-columns=4096 -g "*.md" ]],

            winopts = {
              -- fullscreen = true,
              title = Util.fzflua.format_title("Note Files", ""),
            },
          }
        end,
        desc = "Note(fzflua): find neorg files",
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      dir = Config.path.wiki_path, -- no need to call 'vim.fn.expand' here

      daily_notes = {
        -- folder = "Calendar 🗓️/Days 🌄",
        folder = "Drafts",
        -- Optional, if you want to change the date format for the ID of daily notes.
        -- date_format = "%Y-%m-%d",
        -- Optional, if you want to change the date format of the default alias of daily notes.
        -- alias_format = "%B %-d, %Y",
      },

      preferred_link_style = "markdown",
      finder = "fzf-lua",

      -- Optional, alternatively you can customize the frontmatter data.
      note_frontmatter_func = function(note)
        -- This is equivalent to the default frontmatter function.
        local out = { id = note.id, aliases = note.aliases, tags = note.tags }
        -- `note.metadata` contains any manually added fields in the frontmatter.
        -- So here we just make sure those fields are kept in the frontmatter.
        if note.metadata ~= nil and require("obsidian").util.table_length(note.metadata) > 0 then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end
        return out
      end,

      -- Optional, configure key mappings. These are the defaults. If you don't want to set any keymappings this
      -- way then set 'mappings = {}'.
      mappings = {
        -- Toggle check-boxes.
        ["<c-c>"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
      },

      -- Optional, for templates (see below).
      -- templates = {
      --   subdir = "templates",
      --   date_format = "%Y-%m-%d-%a",
      --   time_format = "%H:%M",
      -- },

      follow_url_func = function(url)
        vim.fn.jobstart { "open", url }
      end,

      -- Optional, set to true if you use the Obsidian Advanced URI plugin.
      -- https://github.com/Vinzent03/obsidian-advanced-uri
      use_advanced_uri = true,

      -- Optional, set to true to force ':ObsidianOpen' to bring the app to the foreground.
      open_app_foreground = true,
    },

    config = function(_, opts)
      require("obsidian").setup(opts)

      Util.cmd.augroup("ManageNoteMappingMarkdown", {
        event = { "FileType" },
        pattern = { "markdown" },
        command = function()
          require("r.keymaps.note").neorg_mappings_ft(api.nvim_get_current_buf())
        end,
      })
    end,
  },
  -- HEADLINES.NVIM
  {
    "lukas-reineke/headlines.nvim",
    -- enabled = false,
    event = "VeryLazy",
    ft = { "markdown", "norg", "rmd", "org" },
    opts = function()
      Highlight.plugin("headlines", {
        theme = {
          ["*"] = {
            { Dash = { bg = "NONE", bold = true } },
            { CodeBlock = { bg = { from = "Normal", attr = "bg", alter = 0.2 } } },
            -- {
            --   Headline1 = {
            --     bg = "#332F46",
            --     fg = { from = "PreProc", attr = "fg", alter = 1 },
            --     bold = true,
            --   },
            -- },
            -- {
            --   Headline2 = {
            --     bg = "#3F2F46",
            --     fg = { from = "PreProc", attr = "fg", alter = 0.8 },
            --     bold = true,
            --   },
            -- },
            --
            -- {
            --   Headline3 = {
            --     bg = "#462F42",
            --     fg = { from = "PreProc", attr = "fg", alter = 0.6 },
            --     bold = true,
            --   },
            -- },
            -- {
            --
            --   Headline4 = {
            --     bg = "#462F37",
            --     fg = { from = "PreProc", attr = "fg", alter = 0.4 },
            --     bold = true,
            --   },
            -- },
            -- {
            --   Headline5 = {
            --     bg = "#46332F",
            --     fg = { from = "PreProc", attr = "fg", alter = 0.2 },
            --     bold = true,
            --   },
            -- },
            -- {
            --   Headline6 = {
            --     -- bg = { from = "Normal", attr = "bg" },
            --     bg = "#463F2F",
            --     -- bg = { from = "Normal", attr = "bg", alter = -0.2 },
            --     fg = { from = "PreProc", attr = "fg", alter = 0 },
            --     bold = true,
            --   },
            -- },
          },
        },
      })
      return {
        org = { headline_highlights = false },
        norg = { headline_highlights = false, codeblock_highlight = false },
        markdown = {
          -- headline_highlights = { "Headline1", "Headline2", "Headline3", "Headline4", "Headline5" },
          headline_highlights = false,
          -- fat_headline_lower_string = "▔",
          codeblock_highlight = "CodeBlock1",
        },
        fat_headline_lower_string = "▔",
      }
    end,
  },
}
