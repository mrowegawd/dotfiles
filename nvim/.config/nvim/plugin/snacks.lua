local add = require("vim-pack").add

local img_from_terminal = true
local set_number = 0 -- 0 means random number; 1–9 are fixed numbers

local lazy = require("utils.plugin").require_lazy

local UtilKey = lazy "utils.map"
local Log = lazy "utils.log"

---@param min_height? integer
local function allow_height(min_height)
  min_height = min_height or 40
  local ui = vim.api.nvim_list_uis()[1]
  local height = math.floor(ui.height * 20 / 100)
  return (ui.height - height) > min_height
end

local function set_img_dashboard()
  local nvim_dashboard_path =
    vim.fs.joinpath(vim.env.HOME, "moxconf", "development", "dotfiles", "img", "nvim-dashboard")

  local is_img = function()
    if lazy("utils.file").is_dir(nvim_dashboard_path) and img_from_terminal then
      return true
    end
    return false
  end

  local is_image = is_img()
  local fn_img = lazy("utils.logo").setup(is_image, set_number)

  local align = allow_height() and "right" or "center"
  local height = align == "center" and 20 or 20

  if is_image then
    return {
      pane = 1,
      section = "terminal",
      height = height, -- 29
      cmd = [[img2art ]]
        .. nvim_dashboard_path -- use image with size 500x500
        .. "/"
        .. fn_img
        .. " "
        .. [[--threshold 80 --scale 0.20 --with-color --alpha]],
      align = "center",
    }
  end

  return {
    pane = 1,
    header = fn_img,
    height = 100,
    padding = 10,
    indent = 30,
    align = align,
  }
end

add {
  {
    src = "folke/snacks.nvim",
    opts = function()
      return {
        notifier = {
          enabled = true,
          -- level = vim.log.levels.TRACE,
        },
        words = { enabled = false },
        image = {
          enabled = true,
          doc = { inline = true, float = false, max_width = 80, max_height = 60 },
        },
        indent = {
          enabled = true,
          char = "▏", --  │, ┊, │, ▏, ┆, ┊, , ┊, "│"
          -- char = "", --  │, ┊, │, ▏, ┆, ┊, , ┊, "│"
          only_scope = false,
          only_current = false,
          indent = { enabled = false },
          scope = { enabled = true },
          chunk = {
            enabled = true,
            hl = "SnacksIndentScope",
            char = {
              horizontal = "─", -- the icon is taken from hlchunks.nvim
              vertical = "│",
              corner_top = "╭",
              corner_bottom = "╰",
              arrow = ">",
            },
          },
          hl = {
            "SnacksIndent1",
            "SnacksIndent2",
            "SnacksIndent3",
            "SnacksIndent4",
            "SnacksIndent5",
            "SnacksIndent6",
            "SnacksIndent7",
            "SnacksIndent8",
          },
          -- https://github.com/folke/snacks.nvim/issues/1214#issuecomment-2661464801
          filter = function(buf)
            local bufname = vim.fn.bufname(vim.api.nvim_get_current_buf())
            if
              (bufname and bufname:match "diffview://")
              or vim.t.diffview_view_initialized
              or (vim.bo[buf].filetype == "snacks_picker_preview")
              or vim.tbl_contains({ "markdown", "org", "tmux", "ini", "toml" }, vim.bo.filetype)
              or lazy("utils.cmd").is_float()
            then
              return false
            end
            return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and vim.bo[buf].buftype == ""
          end,
        },

        dashboard = {
          pane_gap = 5, -- empty columns between vertical panes
          row = nil,
          preset = {
            keys = {
              {
                icon = " ",
                key = "f",
                desc = "Find File",
                action = function()
                  vim.schedule(function()
                    lazy("fzf-lua").files()

                    -- local profiler = require "utils.event_profiler"
                    -- profiler.start()

                    -- profiler.mark "before load"
                    -- lazy("fzf-lua").files()
                    -- lazy("fzf-lua").files { previewer = "bat" } -- atau "cat"
                    -- profiler.mark "after load"

                    -- vim.defer_fn(function()
                    --   profiler.stop()
                    -- end, 1000)
                    --
                  end)
                end,
              },
              { icon = " ", hidden = true, key = "n", desc = "New File", action = ":ene | startinsert" },
              {
                icon = " ",
                key = "r",
                desc = "Recent Files",
                action = function()
                  vim.schedule(function()
                    lazy("fzf-lua").oldfiles()
                  end)
                end,
              },
              {
                icon = " ",
                key = "L",
                desc = "Select Session",
                action = function()
                  vim.schedule(function()
                    lazy("utils.session").select_session()
                  end)
                end,
              },
              {
                icon = " ",
                key = "l",
                desc = "Restore Last Session",
                action = function()
                  vim.schedule(function()
                    -- local profiler = require "utils.event_profiler"

                    -- profiler.start()
                    -- profiler.mark "before load"

                    -- local p = require "jit.p"
                    -- p.start("vl", "/tmp/jitp.log")
                    -- lazy("resession").load(lazy("utils.session").last_session_name(), { silence_errors = true })

                    local resession = require "resession"

                    local orig_bufload = vim.fn.bufload
                    ---@diagnostic disable-next-line: duplicate-set-field
                    vim.fn.bufload = function() end -- sementara: jangan baca file saat restore

                    local ok, err = pcall(resession.load, lazy("utils.session").last_session_name()) -- argumen sama seperti pemanggilan kamu sekarang
                    vim.fn.bufload = orig_bufload -- selalu dikembalikan, walau load error

                    if not ok then
                      Log.error(tostring(err))
                    end

                    -- p.stop()
                    -- profiler.mark "after load"
                    --
                    -- vim.defer_fn(function()
                    --   profiler.stop()
                    -- end, 1000)
                  end)
                end,
              },
              -- { icon = "󰒲 ", key = "y", desc = "Lazy", action = ":Lazy" },
              { icon = " ", key = "q", desc = "Quit", action = ":qa" },
            },
          },
          formats = {
            -- key = function(item)
            --   if item.autokey then
            --     return { "" }
            --   end
            --   -- return { "" }
            --   -- print(vim.inspect(item))
            --   return {
            --     { item.key, hl = "Keyword" },
            --     { " " },
            --     -- { item.desc, hl = "NonText" },
            --     -- { item.file },
            --   }
            -- end,
            key = { "" },
            -- file = function(item)
            --   return {
            --     { item.key, hl = "Keyword" },
            --     { " " },
            --     { item.file:sub(2):match "^(.*[/])", hl = "NonText" },
            --     { item.file:match "([^/]+)$", hl = "Normal" },
            --   }
            -- end,

            -- file = function(item, ctx)
            --   -- local fname = vim.fn.fnamemodify(item.file, ":~")
            --   local fname = vim.fn.fnamemodify(item.file, ":.")
            --   fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
            --   if #fname > ctx.width then
            --     local dir = vim.fn.fnamemodify(fname, ":h")
            --     local file = vim.fn.fnamemodify(fname, ":t")
            --     if dir and file then
            --       file = file:sub(-(ctx.width - #dir - 2))
            --       fname = dir .. "/…" .. file
            --     end
            --   end
            --   local dir, file = fname:match "^(.*)/(.+)$"
            --   return dir
            --       and { { item.key, hl = "Keyword" }, { " " }, { dir .. "/", hl = "dir" }, { file, hl = "file" } }
            --     or { { fname, hl = "file" } }
            -- end,
            icon = { "" },
          },
          sections = {
            {
              enabled = function()
                return (vim.fn.winheight(0) < 25)
              end,
              { section = "header" },
            },
            {
              enabled = function()
                return (vim.fn.winheight(0) >= 25)
              end,
              {
                pane = 1,
                align = "right",
                {
                  set_img_dashboard(),
                },
                {
                  title = "",
                  padding = (vim.fn.isdirectory ".git" ~= 1 and (vim.fn.winwidth(0) > 150)) and 5 or 1,
                },
                {
                  section = "keys",
                  padding = 1,
                  align = "left",
                },
                {
                  enabled = allow_height(),
                  align = "center",
                  {
                    title = " RECENT FILES",
                    section = "recent_files",
                    limit = 5,
                    padding = 1,
                    hl = "Normal",
                  },
                },
                {
                  enabled = allow_height(),
                  {
                    section = "terminal",
                    icon = " ",
                    title = "GIT STATUS",
                    enabled = vim.fn.isdirectory ".git" == 1,
                    cmd = "git status --short --branch --renames",
                    height = 6,
                    padding = 1,
                    indent = 1,
                  },
                },
                -- {
                --   enabled = allow_height(10),
                --   {
                --     section = "startup",
                --     align = "left",
                --   },
                -- },
              },
            },
          },
        },
        picker = {
          layout = "ivy",
          hidden = "true",
          win = {
            input = {
              keys = {
                ["<a-c>"] = { "toggle_cwd", mode = { "n", "i" } },
                ["<c-o>"] = { "toggle_hidden", mode = { "i", "n" } },
                ["<F5>"] = { "toggle_preview", mode = { "i", "n" } },
                ["<F4>"] = { "cycle_win", mode = { "i", "n" } },
                ["<F3>"] = { "toggle_maximize", mode = { "i", "n" } },

                ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
                ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
                ["<a-q>"] = { "qflist", mode = { "i", "n" } },
              },
            },
            list = {
              keys = {
                ["<F4>"] = "cycle_win",
                ["<F3>"] = "toggle_maximize",

                ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
                ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
              },
            },
            preview = {
              keys = {
                ["<F4>"] = "cycle_win",
              },
            },
          },
          sources = {
            files = {
              finder = "files",
              format = "file",
              show_empty = true,
              hidden = true,
              ignored = false,
              follow = false,
              supports_live = true,
            },
            command_history = { layout = { preset = "ivy" } },
            smart = {
              layout = {
                preset = "ivy",
              },
            },
            grep = {
              layout = {
                layout = {
                  box = "vertical",
                  width = 0.85,
                  min_width = 0.6,
                  height = 0.85,
                  { win = "preview", title = "{preview}", border = "rounded" },
                  {
                    { win = "input", height = 1, border = "bottom" },
                    box = "vertical",
                    border = "rounded",
                    title = "{title} {live} {flags}",
                    { win = "list", border = "none" },
                  },
                },
              },
            },
          },
        },
      }
    end,
    on_setup = function()
      local Snacks = lazy "snacks"

      Snacks.toggle.option("wrap", { name = "Wrap" }):map "<Leader>uw"
      Snacks.toggle.zen():map "<Leader>uz"

      UtilKey.nnoremap("<Leader>ii", function()
        Snacks.picker.icons()
      end)

      ---@param is_bottom boolean?
      local function __jump_scope(is_bottom)
        is_bottom = is_bottom or false

        local exclude_win = { "codecompanion", "pdfview" }
        if vim.tbl_contains(exclude_win, vim.bo.filetype) then
          return
        end
        vim.fn.win_execute(vim.api.nvim_get_current_win(), "normal! m'")
        Snacks.scope.jump { bottom = is_bottom }
      end

      ---@param is_prev boolean?
      local function __jump_lsp_mark_githunk(is_prev)
        is_prev = is_prev or false

        local key = {
          hilist = is_prev and "Hi{" or "Hi}",
          snack_word = is_prev and -vim.v.count1 or vim.v.count1,
          neogidiffview = is_prev and "}" or "{",
          wo_diff = is_prev and "[c" or "]c",
          gs_hunk = is_prev and "prev" or "next",
        }

        local ok, _ = pcall(vim.fn.HiList)
        if ok then
          local hilist = vim.fn.HiList()
          if hilist and #hilist > 0 then
            return vim.cmd(key.hilist)
          end
        end

        if vim.g.snacks_word_highlight then
          Snacks.words.jump(key.snack_word, true)
          return
        end

        if vim.bo.filetype == "NeogitDiffView" then
          UtilKey.feedkey(key.neogidiffview, "m")
          return
        end

        if vim.wo.diff then
          vim.cmd.normal { key.wo_diff, bang = true }
        else
          local gs = package.loaded.gitsigns
          vim.schedule(function()
            gs.nav_hunk(key.gs_hunk, { navigation_message = false, foldopen = true })
          end)
        end
      end

      UtilKey.nnoremap("<C-j>", function()
        __jump_scope(true)
      end)
      UtilKey.nnoremap("<C-k>", function()
        __jump_scope()
      end)

      UtilKey.nnoremap("<Localleader>nw", function()
        lazy("snacks.notifier").show_history {
          filter = function(n)
            local lvl = vim.log.levels[n.level:upper()] -- only show -> WARN and ERROR
            return lvl >= vim.log.levels.WARN
          end,
        }
      end, { desc = "Notify: show WARN/ERROR history [snacks.nvim]" })

      UtilKey.nnoremap("<Localleader>nd", function()
        lazy("snacks.notifier").hide()
      end, { desc = "Notify: dismiss all notifications [snacks.nvim]" })

      UtilKey.nnoremap("<Localleader>nl", function()
        lazy("snacks.notifier").show_history {
          -- filter = function(n)
          --   return vim.log.levels[n.level:upper()] >= vim.log.levels.TRACE
          -- end,
        }
      end, { desc = "Notify: show notification history [snacks.nvim]" })

      UtilKey.nnoremap("<c-n>", function()
        __jump_lsp_mark_githunk()
      end, { desc = "LSP: next -> snack scope, mark, githunk, highlighter" })

      UtilKey.nnoremap("<c-p>", function()
        __jump_lsp_mark_githunk(true)
      end, { desc = "LSP:prev -> snack scope, mark, githunk, highlighter" })

      local is_set_toggle_words = false
      local function toggle_words()
        local is_enabled = Snacks.words.enabled

        if is_enabled and is_set_toggle_words then
          Snacks.words.disable()
          is_set_toggle_words = false
        else
          Snacks.words.enable()
          is_set_toggle_words = true
        end
        Log.info(tostring(not is_enabled))
      end

      UtilKey.nnoremap("<Leader>lh", function()
        toggle_words()
        if vim.g.snacks_word_highlight then
          vim.g.snacks_word_highlight = false
          return
        end
        vim.g.snacks_word_highlight = true
      end, { desc = "LSP: toggle word references" })
    end,
  },
}
