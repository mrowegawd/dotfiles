------@type LazyPicker
---local picker = {
---  name = "telescope",
---  commands = {
---    files = "find_files",
---  },
---  -- this will return a function that calls telescope.
---  -- cwd will default to lazyvim.util.get_root
---  -- for `files`, git_files or find_files will be chosen depending on .git
---  ---@param builtin string
---  ---@param opts? r.utils.pick.Opts
---  open = function(builtin, opts)
---    opts = opts or {}
---    opts.follow = opts.follow ~= false
---    if opts.cwd and opts.cwd ~= vim.uv.cwd() then
---      local function open_cwd_dir()
---        local action_state = require "telescope.actions.state"
---        local line = action_state.get_current_line()
---        LazyVim.pick.open(
---          builtin,
---          vim.tbl_deep_extend("force", {}, opts or {}, {
---            root = false,
---            default_text = line,
---          })
---        )
---      end
---      ---@diagnostic disable-next-line: inject-field
---      opts.attach_mappings = function(_, map)
---        -- opts.desc is overridden by telescope, until it's changed there is this fix
---        map("i", "<a-c>", open_cwd_dir, { desc = "Open cwd Directory" })
---        return true
---      end
---    end
---
---    require("telescope.builtin")[builtin](opts)
---  end,
---}
---if not RUtils.pick.register(picker) then
---  return {}
---end

local telescope_toggle_fullscreen = true
local telescope_layout_strategy_height = 0

local build_cmd ---@type string?
for _, cmd in ipairs { "make", "cmake", "gmake" } do
  if vim.fn.executable(cmd) == 1 then
    build_cmd = cmd
    break
  end
end

return {
  -- TELESCOPE
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false, -- telescope did only one release, so use HEAD for now
    dependencies = {
      { "jmacadie/telescope-hierarchy.nvim" },
      { "trevarj/telescope-tmux.nvim" },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = (build_cmd ~= "cmake") and "make"
          or "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        enabled = build_cmd ~= nil,
        config = function(plugin)
          RUtils.on_load("telescope.nvim", function()
            local ok, err = pcall(require("telescope").load_extension, "fzf")
            if not ok then
              local lib = plugin.dir .. "/build/libfzf." .. (RUtils.is_win() and "dll" or "so")
              if not vim.uv.fs_stat(lib) then
                RUtils.warn "`telescope-fzf-native.nvim` not built. Rebuilding..."
                require("lazy").build({ plugins = { plugin }, show = false }):wait(function()
                  RUtils.info "Rebuilding `telescope-fzf-native.nvim` done.\nPlease restart Neovim."
                end)
              else
                RUtils.error("Failed to load `telescope-fzf-native.nvim`:\n" .. err)
              end
            end
          end)
        end,
      },
      "nvim-telescope/telescope-symbols.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
      "benfowler/telescope-luasnip.nvim",
      "fdschmidt93/telescope-corrode.nvim",
    },
    keys = {
      -- { "<Leader>ff", "<cmd>Telescope corrode<cr>", desc = "Telescope: find files", mode = { "n", "v" } },
      -- { "df", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Diagnostic: document diagnostics [telescope]" },
      -- { "dF", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostic: workspace diagnostics [telescope]" },
      -- { "<Leader>fg", "<cmd>Telescope live_grep_args<cr>", desc = "Telescope: live grep" },
      -- { "<Leader>fF", "<cmd>Telescope lazy<cr>", desc = "Telescope: plugin files" },
      -- {
      --   "gs",
      --   function()
      --     require("telescope.builtin").lsp_document_symbols {
      --       symbols = RUtils.config.get_kind_filter(),
      --     }
      --   end,
      --   desc = "Telescope (lsp): goto symbol",
      -- },
      -- {
      --   "gS",
      --   function()
      --     require("telescope.builtin").lsp_dynamic_workspace_symbols {
      --       symbols = RUtils.config.get_kind_filter(),
      --     }
      --   end,
      --   desc = "Telescope(lsp): goto symbol (Workspace)",
      -- },
      -- { "sf", "<CMD>Telescope buffers<CR>", desc = "Telescope: find buffers" },
      -- { "<Leader>fk", "<CMD>Telescope keymaps<CR>", desc = "Telescope: keymaps", mode = { "n", "v" } },
      -- {
      --   "<Leader>sn",
      --   function()
      --     require("telescope").extensions.luasnip.luasnip {}
      --   end,
      --   desc = "Telescope: luasnip list",
      -- },
      -- { "<Localleader>ff", "<CMD>Telescope find_files<CR>", desc = "Telescope: files", mode = { "n", "v" } },
      -- { "<Leader>bg", "<CMD>Telescope current_buffer_fuzzy_find<CR>", desc = "Telescope: live_grep on buffers" },
      -- { "<Leader>bo", "<CMD>Telescope oldfiles<CR>", desc = "Telescope: oldfiles" },
      -- { "<Leader>fh", "<CMD>Telescope help_tags<CR>", desc = "Telescope: help tags" },
      -- { "<Leader>fC", "<CMD>Telescope commands<CR>", desc = "Telescope: commands" },
      -- { "<Localleader>fL", "<CMD>Telescope resume<CR>", desc = "Telescope: resume (last search)" },
      -- { "<Leader>f=", "<CMD>Telescope spell_suggest theme=get_cursor<CR>", desc = "Telescope: spell suggest" },
      -- { "<Leader>fF", "<CMD>Telescope lazy theme=ivy<CR>", desc = "Telescope: plugins files" },
      -- {
      --   "<Leader>ff",
      --   function()
      --     return require("telescope").extensions.menufacture.find_files()
      --   end,
      --   desc = "Telescope: find files",
      -- },
      -- {
      --   "<Leader>fg",
      --   function()
      --     return require("telescope").extensions.menufacture.live_grep()
      --   end,
      --   desc = "Telescope-manufacture: live_grep",
      -- },
      -- {
      --   "<Leader>fg",
      --   function()
      --     return require("telescope").extensions.menufacture.grep_string()
      --   end,
      --   desc = "Telescope-manufacture: live_grep (visual)",
      --   mode = { "v" },
      -- },
      --
      -- {
      --   "<Leader>bg",
      --   function(opts)
      --     local builtin = require "telescope.builtin"
      --
      --     opts = opts or {}
      --
      --     local opt = require("telescope.themes").get_ivy {
      --       cwd = opts.dir,
      --       prompt_title = "Live Grep for all Buffers",
      --       grep_open_files = true,
      --       shorten_path = true,
      --       -- sorter = require("telescope.sorters").get_substr_matcher {},
      --     }
      --     return builtin.live_grep(opt)
      --   end,
      --   description = "Telescope: live_grep on buffers",
      -- },
      --
      --         -- {
      --         --     "<Leader>fF",
      --         --     function()
      --         --         local plugins_directory = vim.fn.stdpath "data"
      --         --             .. "/lazy"
      --         --         return require("telescope.builtin").find_files {
      --         --             cwd = plugins_directory,
      --         --             prompt_title = "Find plugin files",
      --         --         }
      --         --     end,
      --         --     description = "Find plugin files",
      --         -- },
      --
      --         -- TELESCOPE-LAZY
      --         {
      --             "<Leader>fF",
      --             "<CMD>Telescope lazy theme=ivy<CR>",
      --             desc = "Telescope-lazy: check plugins dir",
      --         },
      --         -- TELESCOPE-MENUFACTURE
      --         {
      --             "<Leader>ff",
      --             function()
      --                 return require("telescope").extensions.menufacture.find_files()
      --             end,
      --             desc = "Telescope-manufacture: find files",
      --         },
      --
      --
      --         -- TELESCOPE-GREPQF
      --         {
      --             "<Leader>fq",
      --             "<CMD> Telescope grepqf theme=ivy<CR>",
      --             desc = "Telescope-grepqf: live_grep qf items",
      --         },
      --
      --         -- TELESCOPE-SYMBOLS
      --         {
      --             "<Leader>f1",
      --             "<CMD> Telescope symbols theme=ivy<CR>",
      --             desc = "Telescope-symbol: emoji",
      --         },
      --
      --         -- CONDUCT-NVIM
      --         {
      --             "<Leader>fp",
      --             "<CMD>Telescope conduct projects theme=ivy<CR>",
      --             desc = "Telescope-conductt: projects",
      --         },
    },
    opts = function()
      -- local trouble = require "trouble.providers.telescope"
      local actions = require "telescope.actions"
      local themes = require "telescope.themes"

      local layout_actions = require "telescope.actions.layout"

      -- local foldMaps = function(_, _)
      --     require("telescope.actions.set").select:enhance {
      --         post = function()
      --             vim.cmd.normal { args = { "zx" }, bang = true }
      --         end,
      --     }
      --     return true
      -- end

      ---@param opts table
      local function dropdown(opts)
        return require("telescope.themes").get_dropdown(vim.tbl_extend("keep", opts or {}, {
          borderchars = {
            { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
            prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
            results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
            preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
          },
        }))
      end

      -- Telescope issue: kadang fold nya nge-bug, untuk sementara solusinya check the issue di github
      -- Taken from https://github.com/nvim-telescope/telescope.nvim/issues/559#issuecomment-1311441898
      local function stopinsert(callback)
        return function(prompt_bufnr)
          vim.cmd.stopinsert()
          vim.schedule(function()
            callback(prompt_bufnr)
          end)
        end
      end

      -- local function stopinsert_fb(callback, callback_dir)
      --     return function(prompt_bufnr)
      --         local entry =
      --             require("telescope.actions.state").get_selected_entry()
      --         if entry and not entry.Path:is_dir() then
      --             stopinsert(callback)(prompt_bufnr)
      --         elseif callback_dir then
      --             callback_dir(prompt_bufnr)
      --         end
      --     end
      -- end

      return {
        defaults = {
          get_selection_window = function()
            local wins = vim.api.nvim_list_wins()
            table.insert(wins, 1, vim.api.nvim_get_current_win())
            for _, win in ipairs(wins) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].buftype == "" then
                return win
              end
            end
            return 0
          end,
          vimgrep_arguments = {
            "rg",
            "--hidden",
            "--follow",
            "--color=never",
            "--column",
            "--line-number",
            "--with-filename",
            "--no-heading",
            "--smart-case",
            "--trim", -- remove indentation
          },
          file_ignore_patterns = {
            "%.jpg",
            "%.jpeg",
            "%.png",
            "%.otf",
            "%.ttf",
            "%.DS_Store",
            "^.git/",
            "node%_modules/.*",
            "^site-packages/",
            "%.yarn/.*",
          },
          scroll_strategy = "cycle",
          sorting_strategy = "ascending",
          theme = "ivy",
          layout_config = {
            -- height = 35,
            horizontal = { preview_width = 0.55 },
          },
          layout_strategy = "bottom_pane",
          prompt_prefix = " ",
          selection_caret = " ",
          cycle_layout_list = { -- digunakan ketika use <c-l>
            "flex",
            "horizontal",
            "vertical",
            "bottom_pane",
            "center",
          },
          borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
          mappings = {
            i = {
              ["<ESC>"] = actions.close,

              ["<C-down>"] = actions.cycle_history_next,
              ["<C-up>"] = actions.cycle_history_prev,

              ["<a-n>"] = actions.results_scrolling_up,
              ["<a-p>"] = actions.results_scrolling_down,

              ["<PageUp>"] = actions.preview_scrolling_up,
              ["<PageDown>"] = actions.preview_scrolling_down,

              ["<a-a>"] = actions.toggle_all,
              ["<a-Q>"] = actions.send_to_qflist + actions.open_qflist,

              ["<CR>"] = stopinsert(actions.select_default),
              ["<C-s>"] = stopinsert(actions.select_horizontal),
              ["<C-v>"] = stopinsert(actions.select_vertical),
              ["<C-t>"] = stopinsert(actions.select_tab),

              ["<C-r>"] = actions.to_fuzzy_refine,

              ["<F1>"] = actions.which_key, -- keys from pressing <C-/>
              ["<F4>"] = layout_actions.cycle_layout_next,
              ["<F5>"] = layout_actions.toggle_preview,
              ["<F3>"] = function(prompt_bufnr)
                local action_state = require "telescope.actions.state"
                local picker = action_state.get_current_picker(prompt_bufnr)
                picker.layout_config = picker.layout_config or {}
                picker.layout_config[picker.layout_strategy] = picker.layout_config[picker.layout_strategy] or {}

                if telescope_layout_strategy_height == 0 then
                  telescope_layout_strategy_height = picker.layout_config[picker.layout_strategy].height
                end

                if telescope_toggle_fullscreen then
                  picker.layout_config[picker.layout_strategy].height = 90
                  telescope_toggle_fullscreen = false
                else
                  picker.layout_config[picker.layout_strategy].height = telescope_layout_strategy_height
                  telescope_toggle_fullscreen = true
                end

                picker:full_layout_update()
              end,
            },
            n = {
              ["<ESC>"] = actions.close,
              ["q"] = actions.close,

              ["<C-down>"] = actions.cycle_history_next,
              ["<C-up>"] = actions.cycle_history_prev,

              ["<PageUp>"] = actions.preview_scrolling_up,
              ["<PageDown>"] = actions.preview_scrolling_down,

              ["<C-n>"] = actions.move_selection_next,
              ["<C-p>"] = actions.move_selection_previous,

              ["<a-n>"] = actions.results_scrolling_up,
              ["<a-p>"] = actions.results_scrolling_down,

              ["<F5>"] = layout_actions.toggle_preview,
              ["<F1>"] = actions.which_key, -- keys from pressing <C-/>
            },
          },
        },
        pickers = {
          highlights = themes.get_ivy {},
          buffers = themes.get_ivy {
            sort_mru = true,
            sort_lastused = true,
            show_all_buffers = true,
            ignore_current_buffer = true,
            previewer = false,
            mappings = {
              i = { ["<c-x>"] = "delete_buffer" },
              n = { ["<c-x>"] = "delete_buffer" },
            },
          },
          oldfiles = dropdown {},
          builtin = themes.get_ivy {},
          filetypes = themes.get_ivy {},
          find_files = themes.get_ivy { hidden = true },
          help_tags = { theme = "ivy" },
          live_grep = themes.get_ivy {
            file_ignore_patterns = { ".git/", "%.svg", "%.lock" },
            max_results = 2000,
          },
          -- current_buffer_fuzzy_find = dropdown {
          --   previewer = false,
          --   shorten_path = false,
          -- },
          diagnostics = dropdown {},
          colorscheme = { enable_preview = true },
          keymaps = dropdown {
            layout_config = { height = 50, width = 0.8 },
          },

          lsp_definitions = themes.get_ivy {},
          lsp_references = {
            sorting_strategy = "descending",
            layout_strategy = "vertical", -- ivy, cursor, dropdown
            theme = "dropdown",
            preview_title = false,
            path_display = { "shorten" },
            prompt_title = "References",
            layout_config = {
              width = 0.80,
              height = 0.80,
              -- preview_width = 0.70,
            },
          },
        },
        extensions = {
          lazy = themes.get_ivy {},
          octo = themes.get_ivy {},
          -- dap = themes.get_ivy {}, -- not working
          live_grep_args = themes.get_ivy {
            auto_quoting = false, -- enable/disable auto-quoting
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require "telescope"
      telescope.setup(opts)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("TelescopeSetMap", { clear = true }),
        desc = "Set terminal mappings in telescope buffer.",
        pattern = "TelescopePrompt",
        callback = function(bufn)
          vim.keymap.set("i", "<F2>", function()
            vim.cmd "Telescope builtin"
          end, { buffer = bufn.buf })
          vim.keymap.set("t", "<a-x>", "<a-x>", { buffer = bufn.buf })
        end,
      })
      ---@diagnostic disable-next-line: undefined-field
      telescope.load_extension "corrode"
      ---@diagnostic disable-next-line: undefined-field
      telescope.load_extension "fzf"
      ---@diagnostic disable-next-line: undefined-field
      telescope.load_extension "grepqf"
      ---@diagnostic disable-next-line: undefined-field
      telescope.load_extension "live_grep_args"

      telescope.load_extension "tmux"

      telescope.load_extension "hierarchy"

      -----@diagnostic disable-next-line: undefined-field
      --telescope.load_extension "luasnip"

      local corrode_cfg = require "telescope._extensions.corrode.config"
      corrode_cfg.values = { theme = "ivy" }
    end,
  },
}
