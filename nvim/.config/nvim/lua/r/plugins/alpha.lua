return {
  -- DASHBOARD.NVIM
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = function()
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "DashboardLoaded",
          callback = function()
            require("lazy").show()
          end,
        })
      end
      return {
        theme = "doom",
        hide = {
          -- this is taken care of by lualine
          -- enabling this messes up the actual laststatus setting after loading a file
          statusline = false,
          number = false,
          relativenumber = false,
        },
        config = {
          header = require "r.utils.logo"(),
          center = {
            { action = [[lua require("fzf-lua").files()]], desc = " Find file", icon = " ", key = "f" },
            -- { action = "ene | startinsert", desc = " New file", icon = " ", key = "e" },
            { action = "Neorg workspace wiki", desc = " Notes", icon = " ", key = "n" },
            { action = [[lua require("fzf-lua").oldfiles()]], desc = " Recent files", icon = " ", key = "o" },
            { action = [[lua require("fzf-lua").live_grep()]], desc = " Find text", icon = " ", key = "g" },
            { action = "e $MYVIMRC", desc = " Config", icon = " ", key = "c" },
            { action = 'lua require("persistence").load()', desc = " Restore Session", icon = " ", key = "s" },
            -- { action = 'lua require("resession").load()', desc = " Restore Session", icon = " ", key = "s" },
            -- { action = [[AutoSessionRestore]], desc = " Restore Session", icon = " ", key = "s" },
            { action = "Lazy", desc = " Lazy", icon = "󰒲 ", key = "l" },
            { action = "qa", desc = " Quit", icon = " ", key = "q" },
          },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
          end,
        },
      }

      -- for _, button in ipairs(opts.config.center) do
      --   button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
      --   button.key_format = "  %s"
      -- end
    end,
  },
  -- ALPHA (disabled)
  {
    "goolord/alpha-nvim",
    enabled = false,
    event = "VimEnter",
    config = function()
      local alpha = require "alpha"

      local header = {
        type = "text",
        -- val = ascii_img[1],
        opts = {
          position = "center",
          hl = "AlphaHeader",
        },
      }

      -- io.popen 'fd --max-depth 1 . $HOME"/.local/share/nvim/lazy" | head -n -2 | wc -l | tr -d "\n" '
      -- io.popen 'fd -d 2 . $HOME"/.local/share/nvim/site/pack/deps" | head -n -2 | wc -l | tr -d "\n" '
      --
      -- local plugins = ""
      -- if handle ~= nil then
      --     plugins = handle:read "*a"
      --     handle:close()
      -- end

      local thingy = io.popen 'echo "$(date +%a) $(date +%d) $(date +%b)" | tr -d "\n"'

      local date = ""
      if thingy ~= nil then
        date = thingy:read "*a"
        thingy:close()
      end

      local function get_installed_plugins()
        local ok, lazy = pcall(require, "lazy")
        if not ok then
          return 0
        end
        return lazy.stats().count
      end

      local plugin_count = {
        type = "text",
        val = "└─  " .. get_installed_plugins() .. " plugins in total ─┘",
        opts = {
          position = "center",
          hl = "AlphaHeader",
        },
      }

      local heading = {
        type = "text",
        val = "┌─   Today is " .. date .. " ─┐",
        opts = {
          position = "center",
          hl = "AlphaHeader",
        },
      }

      local footer = {
        type = "text",
        val = "-GiTMoX-",
        opts = {
          position = "center",
          hl = "AlphaFooter",
        },
      }

      local function button(sc, txt, keybind)
        local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")

        local opts = {
          position = "center",
          text = txt,
          shortcut = sc,
          cursor = 5,
          width = 24,
          align_shortcut = "right",
          hl_shortcut = "AlphaButtons",
          hl = "AlphaButtons",
        }
        if keybind then
          opts.keymap = { "n", sc_, keybind, { noremap = true, silent = true } }
        end

        return {
          type = "button",
          val = txt,
          on_press = function()
            local key = vim.api.nvim_replace_termcodes(sc_, true, false, true)
            vim.api.nvim_feedkeys(key, "normal", false)
          end,
          opts = opts,
        }
      end

      local buttons = {
        type = "group",
        val = {
          button("o", "   Recents", "<CMD> FzfLua oldfiles <CR>"),
          button("f", "   Explore", "<CMD> FzfLua files <CR>"),
          button("g", "   Ripgrep", "<CMD> FzfLua live_grep <CR>"),
          button("l", "   Sessions", '<CMD> lua require("persistence").load() <CR>'),
          button("q", "   Quit", "<cmd> qa <CR>"),
        },
        opts = {
          spacing = 1,
        },
      }

      local section = {
        header = header,
        buttons = buttons,
        plugin_count = plugin_count,
        heading = heading,
        footer = footer,
      }

      local options = {
        layout = {
          { type = "padding", val = 1 },
          section.header,
          { type = "padding", val = 1 },
          section.heading,
          section.plugin_count,
          { type = "padding", val = 1 },
          -- section.top_bar,
          section.buttons,
          -- section.bot_bar,
          { type = "padding", val = 1 },
          section.footer,
        },
        opts = {
          margin = 20,
        },
      }

      alpha.setup(options)
    end,
  },
}
