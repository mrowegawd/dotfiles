local fmt, api = string.format, vim.api
local uv = vim.uv

local fzf_lua = RUtils.cmd.reqcall "fzf-lua"

local Highlight = require "r.settings.highlights"

return {
  -- ORGMODE
  {
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    ft = { "org", "orgagenda" },
    keys = {
      {
        "<Localleader>aN",
        function()
          return RUtils.notes.open_agenda_file_lists()
        end,
        desc = "Note: open agenda file list [orgmode]",
      },
      {
        "<Localleader>ac",
        function()
          require("orgmode").action "capture.prompt"
        end,
        desc = "Note: capture note [orgmode]",
      },
      {
        "<Localleader>an",
        function()
          require("orgmode").action "agenda.prompt"
        end,
        desc = "Note: open agenda orgmode [orgmode]",
      },
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "akinsho/org-bullets.nvim",
    },
    opts = function()
      local done_hi = Highlight.get("Comment", "fg")
      local bg_hi = Highlight.darken(Highlight.get("Normal", "bg"), 0.5, Highlight.get("Error", "fg"))
      local todo_fg = Highlight.get("Error", "fg")
      return {
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
                prompt = fmt(RUtils.config.icons.misc.fire .. " %s ", data.prompt),
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
          -- Mobilephone
          -- fmt("%s/orgmode/gym/*", RUtils.config.path.wiki_path),
          -- fmt("%s/orgmode/habit/*", RUtils.config.path.wiki_path),

          -- PC / Laptop
          fmt("%s/orgmode/gtd/*", RUtils.config.path.wiki_path),
          fmt("%s/orgmode/bookmarks/*", RUtils.config.path.wiki_path),
          fmt("%s/orgmode/day-to-remember/*", RUtils.config.path.wiki_path),
          fmt("%s/orgmode/project-todo/**/*", RUtils.config.path.wiki_path),
        },
        org_default_notes_file = fmt("%s/orgmode/gtd/refile.org", RUtils.config.path.wiki_path),
        org_todo_keywords = {
          "TODO(t)",
          "LEARNING(l)", -- task untuk jadwal learning
          "PROGRESS(p)", -- task yang sedang dikerjakan
          "CHECK(c)", -- task yang boleh dikerjakan saat free-time
          "HBD(b)",
          "STATUS(s)", -- task yang dikerjakan tapi bukan project, seperti belajar, baca buku, dsb
          "|",
          "DONE(d)",
        },
        org_todo_keyword_faces = {
          CHECK = ":foreground royalblue :weight bold :slant",
          TODO = ":foreground " .. todo_fg .. " :weight bold :slant",
          PROGRESS = ":foreground white :background " .. bg_hi .. " :weight bold :slant italic",
          HBD = ":foreground pink :weight bold :slant",
          STATUS = ":foreground black :background magenta :weight bold :slant",
          LEARNING = ":foreground yellow :weight bold :slant",
          DONE = ":foreground " .. done_hi .. " :weight bold :slant",
        },
        org_agenda_skip_scheduled_if_done = true,
        org_hide_emphasis_markers = true,
        org_capture_templates = {
          t = {
            description = "Todo",
            template = "* TODO %? \n  SCHEDULED: %T\n\n\tDescribe:\n\n\tCode Error:\n\n\tExpected:\n",
            target = RUtils.config.path.wiki_path .. "/orgmode/gtd/refile.org",
          },
          i = {
            description = "Inbox",
            template = "* CHECK %? \n  SCHEDULED: %t\n\n\tDescribe:\n",
            target = RUtils.config.path.wiki_path .. "/orgmode/gtd/inbox.org",
          },
          l = {
            description = "Link",
            template = "* CHECK %?\n  SCHEDULED: %t\n  %a\n\n\tDescribe:\n",
            target = RUtils.config.path.wiki_path .. "/orgmode/gtd/inbox.org",
          },
          u = {
            description = "URL bookmarks",
            template = "* RAPIKAN: %? \n  SCHEDULED: %t\n\n\tWhat about this URL:\n\n\tURL:\n",
            target = RUtils.config.path.wiki_path .. "/orgmode/bookmarks/urls.org",
          },
          j = {
            description = "Journal",
            template = "\n** %<%Y-%m-%d> %<%A>\n*** %U\n\n%?",
            target = RUtils.config.path.wiki_path .. "/orgmode/journal/journal.org",
          },
          -- k = {
          --     description = "Markdown",
          --     template = "\n* TODO %? \n  SCHEDULED: %t",
          --     target = RUtils.config.path.wiki_path .. "/orgmode/gtd/base.md",
          --     filetype = "markdown",
          -- },
        },
        win_split_mode = { "float", 0.6 },
        mappings = {
          disable_all = false,
          prefix = "<Leader>g",
          global = {
            org_capture = "<Localleader>ac",
            org_agenda = "<Localleader>an",
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
            org_agenda_switch_to = "<TAB>",
            org_agenda_goto = "<CR>",
            org_agenda_goto_date = "<prefix>d",
            org_agenda_redo = "r",
            org_agenda_todo = "ct",
            org_agenda_clock_goto = "<prefix>xj",
            org_agenda_set_effort = "<prefix>e",
            org_agenda_clock_in = "<prefix>i",
            org_agenda_clock_out = "<prefix>o",
            org_agenda_clock_cancel = "<prefix>C",
            org_agenda_clockreport_mode = "<prefix>R",
            org_agenda_priority = "<prefix>,",
            org_agenda_priority_up = "<S-UP>",
            org_agenda_priority_down = "<S-DOWN>",
            org_agenda_archive = "<prefix>$",
            org_agenda_toggle_archive_tag = "<leader>T",
            org_agenda_set_tags = "<Leader>t",
            org_agenda_deadline = "<Leader>d",
            org_agenda_schedule = "<Leader>s",
            org_agenda_filter = "/",
            org_agenda_refile = "<prefix>r",
            org_agenda_add_note = "<prefix>a",
            org_agenda_show_help = "?",
          },
          capture = {
            org_capture_finalize = "<C-c>",
            org_capture_refile = "<Leader>or",
            org_capture_kill = { "q", "<ESC>" },
            org_capture_show_help = "?",
          },
          note = {
            org_note_finalize = "<C-c>",
            org_note_kill = "<prefix>k",
          },
          org = {
            org_refile = "<prefix>r",
            org_timestamp_up_day = "<UP>",
            org_timestamp_down_day = "<DOWN>",
            org_timestamp_up = "<C-a>",
            org_timestamp_down = "<C-x>",
            org_priority = "<prefix>,",
            org_priority_up = "<S-UP>",
            org_priority_down = "<S-DOWN>",
            org_todo = "ct",
            org_todo_prev = "ciT",
            org_change_date = "<prefix>d",
            org_toggle_checkbox = "<C-c>",
            org_toggle_heading = "<prefix>*",
            org_open_at_point = "<Leader>oo",
            org_edit_special = [[<prefix>']],
            org_cycle = "<BS>",
            org_global_cycle = "<S-TAB>",
            org_archive_subtree = "<prefix>$",
            org_set_tags_command = "<Leader>t",
            org_toggle_archive_tag = "<Leader>T",
            org_do_promote = "<<",
            org_do_demote = ">>",
            org_promote_subtree = "<left>",
            org_demote_subtree = "<right>",
            org_meta_return = "<Leader><CR>", -- Add heading, item or row (context-dependent)
            org_return = "<F11>",
            org_insert_heading_respect_content = "<prefix>ih", -- Add new headling after current heading block with same level
            org_insert_todo_heading = "<prefix>iT", -- Add new todo headling right after current heading with same level
            org_insert_todo_heading_respect_content = "<prefix>it", -- Add new todo headling after current heading block on same level
            org_move_subtree_up = "<S-UP>",
            org_move_subtree_down = "<S-DOWN>",
            org_export = "<Leader>a",
            org_next_visible_heading = "<c-n>",
            org_previous_visible_heading = "<c-p>",
            org_forward_heading_same_level = "]]",
            org_backward_heading_same_level = "[[",
            outline_up_heading = "g{",
            org_deadline = "<Leader>d",
            org_schedule = "<Leader>s",
            org_time_stamp = "<prefix>t",
            org_time_stamp_inactive = "<prefix>T",
            org_toggle_timestamp_type = "<prefix>d!",
            org_insert_link = "<prefix>li",
            org_store_link = "<prefix>ls",
            org_clock_in = "<prefix>i",
            org_clock_out = "<prefix>o",
            org_clock_cancel = "<prefix>C",
            org_clock_goto = "<prefix>xj",
            org_set_effort = "<prefix>e",
            org_show_help = "?",
            org_babel_tangle = "<prefix>bt",
          },
        },
      }
    end,

    config = function(_, opts)
      local orgmode = require "orgmode"
      orgmode.setup(opts)
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
  -- IMAGE
  {
    "3rd/image.nvim",
    ft = { "markdown", "norg", "oil", "octo" },
    enabled = function()
      if vim.g.neovide then
        return false
      end
      return true
    end,
    build = function()
      local has_magick = pcall(require, "magick")
      if not has_magick and vim.fn.executable "luarocks" == 1 then
        local is_mac = uv.os_uname().sysname == "Darwin"
        if is_mac then
          vim.fn.system "luarocks --lua-dir=$(brew --prefix)/opt/lua@5.1 --lua-version=5.1 install magick"
        else
          -- Requirements for linux:
          -- sudo apt-get install libmagickwand-dev libgraphicsmagick1-dev
          -- juga run command ini:
          vim.fn.system "luarocks --local --lua-version=5.1 install magick"
        end
        if vim.v.shell_error ~= 0 then
          vim.notify("Error installing magick with luarocks", vim.log.levels.WARN)
        end
      end
    end,
    opts = {
      backend = "kitty",
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
        html = {
          enabled = false,
        },
        css = {
          enabled = false,
        },
      },
      max_width = nil,
      max_height = nil,
      max_width_window_percentage = nil,
      max_height_window_percentage = 50,
      window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
      editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
      tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
      hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
      -- })

      -- editor_only_render_when_focused = true, -- auto show/hide images when the editor gains/looses focus
      -- tmux_show_only_in_active_window = true,
      -- integrations = {
      --   markdown = {
      --     enabled = true,
      --     clear_in_insert_mode = false,
      --     download_remote_images = true,
      --     only_render_image_at_cursor = false,
      --     filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
      --   },
      --   neorg = {
      --     enabled = true,
      --     clear_in_insert_mode = false,
      --     download_remote_images = true,
      --     only_render_image_at_cursor = false,
      --     filetypes = { "norg" },
      --   },
      -- },
    },
    config = function(_, opts)
      local has_magick = pcall(require, "magick")
      if has_magick then
        require("image").setup(opts)
      end
    end,
  },
  -- OBSIDIAN.NVIM
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    cmd = { "ObsidianDailies" },
    keys = {
      {
        "<Localleader>ag",
        function()
          return fzf_lua.live_grep_glob {
            prompt = RUtils.fzflua.default_title_prompt(),
            cwd = RUtils.config.path.wiki_path,
            rg_opts = [[--column --hidden --line-number --no-heading --ignore-case --smart-case --color=always  --max-columns=4096 -g "*.md" ]],
            winopts = {
              title = RUtils.fzflua.format_title(
                "Obsidian > Grep",
                RUtils.cmd.strip_whitespace(RUtils.config.icons.misc.telescope3)
              ),
            },
          }
        end,
        desc = "Note: live grep notes [obsidian]",
      },
      {
        "<Localleader>ag",
        function()
          local viz = RUtils.cmd.get_visual_selection { strict = true }
          if viz then
            return fzf_lua.grep {
              prompt = RUtils.fzflua.default_title_prompt(),
              query = string.format("%s", viz.selection),
              -- no_esc = true,
              rg_glob = true,
              cwd = RUtils.config.path.wiki_path,
              rg_opts = [[--column --line-number --hidden --ignore-case --smart-case -g "*.md" ]],
              winopts = {
                title = RUtils.fzflua.format_title(
                  "Obsidian > Grep",
                  RUtils.cmd.strip_whitespace(RUtils.config.icons.misc.telescope3)
                ),
              },
            }
          end
        end,
        desc = "Note: live grep notes (visual) [obsidian]",
        mode = "v",
      },
      {
        "<Localleader>af",
        function()
          return fzf_lua.files {
            prompt = RUtils.fzflua.default_title_prompt(),
            cwd = RUtils.config.path.wiki_path,
            file_ignore_patterns = { "%.norg$", "%.json$", "%.org$", "%.png$" },
            rg_opts = [[--column --type=md --hidden --no-heading --ignore-case --smart-case --color=always --max-columns=4096 ]],

            winopts = {
              -- fullscreen = true,
              title = RUtils.fzflua.format_title(
                "Obsidian > Note files",
                RUtils.cmd.strip_whitespace(RUtils.config.icons.misc.bookmark)
              ),
            },
          }
        end,
        desc = "Note: find note files [obsidian]",
      },
      {
        "<Localleader>aa",
        ":ObsidianNew ",
        desc = "Note: create new note [obsidian]",
      },
      {
        "<Localleader>ad",
        "<CMD>ObsidianDailies<CR>",
        desc = "Note: open and select daily note [obsidian]",
      },
      {
        "<Localleader>al",
        function()
          RUtils.markdown.find_note_by_tag()
        end,
        desc = "Note: find note by tags [obsidian]",
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "3rd/image.nvim",
    },
    opts = {
      dir = RUtils.config.path.wiki_path, -- no need to call 'vim.fn.expand' here
      workspaces = {
        {
          name = "obsidian",
          date_format = "%d-%m-%Y %A",
          time_format = "%H:%M",
          path = "~/Dropbox/neorg",
        },

        {
          name = "work",
          path = "~/Dropbox/neorg/work",
        },
      },
      daily_notes = {
        folder = "Drafts",
        -- Optional, if you want to change the date format for the ID of daily notes.
        date_format = "%d-%m-%Y",
        -- date_format = "%Y-%m-%d",
        -- Optional, if you want to change the date format of the default alias of daily notes.
        -- alias_format = "%B %-d, %Y",
      },
      note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
        -- In this case a note with the title 'My new note' will be given an ID that looks
        -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
        local suffix = ""
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        local time = os.date("%Y-%m-%d", os.time() - 86400)
        return tostring(time) .. "_" .. suffix
      end,
      picker = {
        name = "fzf-lua",
        mappings = {
          new = "<C-x>",
          insert_link = "<C-l>",
        },
      },
      preferred_link_style = "markdown",
      note_frontmatter_func = function(note)
        -- Add the title of the note as an alias.
        if note.title then
          note:add_alias(note.title)
        end

        local out = {
          id = note.id,
          aliases = note.aliases,
          tags = note.tags,
        }

        -- add date only on init
        local getDate = function(metadata)
          local date = os.date "%Y-%m-%d %H:%M"
          if metadata == nil then
            return date
          end

          return metadata.create_at
        end

        -- local getHubs = function(metadata)
        --   local hubs = "[[]]"
        --   if metadata == nil then
        --     return hubs
        --   end
        --   return metadata.hubs
        -- end
        --
        -- local getRefs = function(metadata)
        --   local refs = "[[]]"
        --   if metadata == nil then
        --     return refs
        --   end
        --   return metadata.refs
        -- end

        note.metadata = {
          create_at = getDate(note.metadata),
          last_edited = os.date "%Y-%m-%d %H:%M",
          -- hubs = getHubs(note.metadata),
          -- refs = getRefs(note.metadata),
        }
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end
        return out
      end,
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },
      ui = {
        enable = false, -- set to false to disable all additional syntax features
      },
      mappings = {
        ["<c-c>"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        -- ["<cr>"] = {
        --   action = function()
        --     return require("obsidian").util.smart_action()
        --   end,
        --   opts = { buffer = true, expr = true },
        -- },
      },
      follow_url_func = function(url)
        vim.fn.jobstart { "open", url }
      end,
    },

    config = function(_, opts)
      require("obsidian").setup(opts)

      RUtils.cmd.augroup("ManageNoteMappingMarkdown", {
        event = { "FileType" },
        pattern = { "markdown" },
        command = function()
          require("r.keymaps.note").neorg_mappings_ft(api.nvim_get_current_buf())
        end,
      })
    end,
  },
  -- SNIPRUN
  {
    "michaelb/sniprun", -- task runner for code blocks
    event = "VeryLazy",
    build = "bash install.sh",
    cmd = { "SnipRun" },
    opts = {
      display = { "Terminal" },
      live_display = { "VirtualTextOk", "TerminalOk" },
      -- selected_interpreters = { "Python3_fifo" },
      -- repl_enable = { "Python3_fifo" },
    },
    keys = {
      {
        "<Leader>rr",
        "<Plug>SnipClose",
        ft = { "markdown", "neorg", "org" },
        desc = "Misc: close [sniprun]",
      },
    },
  },
  -- org blink source
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = { "nvim-orgmode/orgmode", "saghen/blink.compat" },
    opts = {
      sources = {
        per_filetype = {
          -- disable codeium for org
          org = { "buffer", "path", "orgmode", "snippets" },
        },
        providers = {
          orgmode = {
            name = "Orgmode",
            module = "orgmode.org.autocompletion.blink",
            fallbacks = { "buffer" },
          },
        },
      },
    },
  },
  -- obsidian blink source
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = { "epwalsh/obsidian.nvim", "saghen/blink.compat" },
    opts = {
      sources = {
        compat = { "obsidian", "obsidian_new", "obsidian_tags" },
      },
    },
  },
}
