local add = require("vim-pack").add

local icons = require "icons"
local UtilKey = require "utils.map"
local UtilFzfDiffiew = require "utils.fzf_diffview"

local Log = require "utils.log"

local fd_opts = "--color never "
  .. "--type f "
  .. "--hidden "
  .. "--follow "
  .. "--exclude .git --exclude '*.pyc' --exclude '*.pytest_cache'"

-- Register the fzf-lua picker as the vim.ui.select handler. The override
-- defers requiring fzf-lua until the first call, by which point the plugin
-- is loaded.
---@diagnostic disable-next-line: duplicate-set-field
vim.ui.select = function(items, opts, on_choice)
  local ui_select = require "fzf-lua.providers.ui_select"

  if not ui_select.is_registered() then
    ui_select.register(function(ui_opts)
      if ui_opts.kind == "luasnip" then
        ui_opts.prompt = "Snippet choice: "
        ui_opts.winopts = {
          relative = "cursor",
          height = 0.35,
          width = 0.3,
        }
      elseif ui_opts.kind == "color_presentation" then
        ui_opts.winopts = {
          relative = "cursor",
          height = 0.35,
          width = 0.3,
        }
      else
        ui_opts.winopts = { height = 0.5, width = 0.4 }
      end

      -- Use the kind (if available) to set the previewer's title.
      if ui_opts.kind then
        ui_opts.winopts.title = string.format(" %s ", ui_opts.kind)
      end

      -- Ensure that there's a space at the end of the prompt.
      if ui_opts.prompt and not vim.endswith(ui_opts.prompt, " ") then
        ui_opts.prompt = ui_opts.prompt .. " "
      end

      return ui_opts
    end)
  end

  -- Don't show the picker if there's nothing to pick.
  if #items > 0 then
    return vim.ui.select(items, opts, on_choice)
  end
end

local path_normalize = function(path_str)
  local path = vim.uv.cwd() .. "/" .. require("utils.cmd").__strip_str(path_str) or path_str
  return vim.fs.normalize(path)
end

-- Picker, finder, etc.
add {
  {
    src = "ibhagwan/fzf-lua",
    opts = function()
      local actions = require "fzf-lua.actions"
      return {
        { "border-fused", "hide" },
        -- Make stuff better combine with the editor.
        fzf_colors = {
          bg = { "bg", "Normal" },
          gutter = { "bg", "Normal" },
          info = { "fg", "Conditional" },
          scrollbar = { "bg", "Normal" },
          separator = { "fg", "Comment" },
        },
        fzf_opts = {
          ["--info"] = "default",
          ["--layout"] = "reverse-list",
        },
        keymap = {
          builtin = {
            ["<C-/>"] = "toggle-help",
            ["<C-a>"] = "toggle-fullscreen",
            ["<C-i>"] = "toggle-preview",
            ["<C-r>"] = "toggle-preview-cw",

            ["<PageDown>"] = "preview-page-down",
            ["<PageUp>"] = "preview-page-up",

            ["<C-u>"] = "preview-up",
            ["<C-d>"] = "preview-down",

            ["<C-Up>"] = "preview-up",
            ["<C-Down>"] = "preview-down",
          },
          fzf = {
            ["alt-s"] = "toggle",
            ["alt-a"] = "toggle-all",
            ["ctrl-i"] = "toggle-preview",
          },
        },
        winopts = {
          height = 0.85,
          width = 0.55,
          preview = {
            scrollbar = false,
            layout = "vertical",
            vertical = "up:40%",
          },
        },
        defaults = { git_icons = false },
        previewers = {
          codeaction = { toggle_behavior = "extend" },
        },
        files = {
          winopts = {
            preview = { hidden = true },
          },
          fd_opts = fd_opts,
          actions = {
            ["alt-y"] = actions.file_edit_or_qf,
            ["alt-q"] = {
              prefix = "select-all",
              fn = function(selected, opts)
                actions.file_sel_to_qf(selected, opts)
              end,
            },
            ["alt-Q"] = {
              fn = function(selected, opts)
                if not selected or #selected == 0 then
                  return
                end
                actions.file_sel_to_ll(selected, opts)
              end,
            },
            ["ctrl-x"] = {
              fn = function()
                require("fzf-lua").files {
                  fd_opts = [[--color=never --type d --type l --exclude .git]],
                  actions = {
                    ["default"] = function(selected, opts)
                      if not selected or #selected > 1 then
                        return
                      end

                      local path_str = path_normalize(selected[1])

                      local title_path
                      opts.cwd = path_str
                      opts.cmd = "rg --hidden --files " .. path_str
                      title_path = path_str

                      opts.winopts.title = "Path: " .. title_path .. " "
                      opts.actions = {
                        ["alt-y"] = actions.file_edit_or_qf,
                        ["enter"] = actions.file_edit_or_qf,
                      }

                      require("fzf-lua").files(opts)
                    end,
                  },
                }
              end,
              noclose = true,
              desc = "find-at-dir",
              header = "find-at-dir",
            },
            ["ctrl-o"] = {
              fn = function(...)
                local P = require "overlook.peek"
                P.peek_fzflua(...)
              end,
              noclose = false,
              desc = "peek-file",
              header = "peek-file",
            },
            ["ctrl-g"] = {
              fn = function(selected)
                if not selected then
                  return
                end

                local paths = {}
                if #selected > 1 then
                  for _, file in pairs(selected) do
                    if not require("utils.cmd").check_tbl_element(paths, file) then
                      paths[#paths + 1] = path_normalize(file)
                    end
                  end
                else
                  table.insert(paths, path_normalize(selected[1]))
                end

                UtilKey.plugin_load_now "grug-far.nvim"
                local grug = require "grug-far"
                grug.open {
                  prefills = {
                    search = "",
                    replacement = "",
                    filesFilter = "",
                    flags = "--hidden -i",
                    paths = table.concat(paths, "  "),
                  },
                }
              end,
              noclose = false,
              desc = "on-grug-far",
              header = "on-grug-far",
            },
          },
        },
        git = {
          commits = {
            fzf_opts = {
              ["--no-multi"] = false,
              ["--multi"] = true,
            },
            actions = {
              ["enter"] = {
                fn = function(selected, opts)
                  if not selected or #selected == 0 then
                    return
                  end
                  if #selected > 1 then
                    UtilFzfDiffiew.git_open_to_qf(selected, "Selected hash commit")
                    return
                  end
                  actions.git_buf_edit(selected, opts)
                end,
                header = false,
              },
              ["alt-y"] = {
                fn = function(selected, opts)
                  if not selected or #selected == 0 then
                    return
                  end
                  if #selected > 1 then
                    UtilFzfDiffiew.git_open_to_qf(selected, "Selected hash commit")
                    return
                  end
                  actions.git_buf_edit(selected, opts)
                end,
                header = false,
              },
              ["alt-q"] = {
                prefix = "select-all",
                fn = function(selected, _)
                  UtilFzfDiffiew.git_open_to_qf(selected, "Select all commits")
                end,
              },
              ["alt-Q"] = {
                fn = function(selected, _)
                  Log.info "Sent to loclist; consider quickfix"
                  UtilFzfDiffiew.git_open_to_loc(selected, "Selected hash commit")
                end,
              },
              ["alt-c"] = {
                fn = UtilFzfDiffiew.git_open_with_compare_hash(),
                desc = "compare-diff-hash",
                header = "compare-diff-hash",
              },
              ["alt-o"] = {
                fn = function(selected)
                  if not selected or #selected == 0 then
                    return
                  end
                  for _, sel in ipairs(selected) do
                    UtilFzfDiffiew.git_open_with_browser(sel)
                  end
                end,
                desc = "open-in-browser",
                header = "open-in-browser",
              },
              ["ctrl-o"] = {
                fn = function(selected)
                  UtilFzfDiffiew.git_open_with_diffview(selected)
                end,
                desc = "open-in-diffview",
                header = "open-in-diffview",
              },
              ["ctrl-x"] = {
                fn = function(selected)
                  UtilFzfDiffiew.git_open_with_fugitive(selected)
                end,
                desc = "open-in-fugitive",
                header = "open-in-fugitive",
              },
              ["ctrl-q"] = {
                fn = function(selected)
                  UtilFzfDiffiew.git_open_diff_to_head(selected)
                end,
                desc = "diff-to-the-head",
                header = "diff-to-the-head",
              },
              ["ctrl-g"] = {
                fn = UtilFzfDiffiew.git_grep_log(),
                desc = "grep-commit-log",
                header = "grep-commit-log",
              },
              ["ctrl-y"] = {
                fn = function(selected)
                  if not selected or #selected == 0 then
                    return
                  end
                  for _, sel in ipairs(selected) do
                    UtilFzfDiffiew.git_copy_to_clipboard_or_yank(sel)
                  end
                end,
                desc = "copy-commit",
                header = "copy-commit",
              },
              ["ctrl-s"] = actions.git_buf_split,
              ["ctrl-v"] = actions.git_buf_vsplit,
              ["ctrl-t"] = actions.git_buf_tabedit,
            },
          },
          bcommits = {
            fzf_opts = {
              ["--no-multi"] = false,
              ["--multi"] = true,
            },
            actions = {
              ["enter"] = {
                fn = function(selected, opts)
                  if not selected or #selected == 0 then
                    return
                  end
                  if #selected > 1 then
                    UtilFzfDiffiew.git_open_to_qf(selected, "Selected hash commit")
                    return
                  end
                  actions.git_buf_edit(selected, opts)
                end,
                header = false,
              },
              ["alt-y"] = {
                fn = function(selected, opts)
                  if not selected or #selected == 0 then
                    return
                  end
                  if #selected > 1 then
                    UtilFzfDiffiew.git_open_to_qf(selected, "Selected hash commit")
                    return
                  end
                  actions.git_buf_edit(selected, opts)
                end,
                header = false,
              },
              ["alt-q"] = {
                prefix = "select-all",
                fn = function(selected, _)
                  UtilFzfDiffiew.git_open_to_qf(selected, "Select all commits")
                end,
              },
              ["alt-Q"] = {
                fn = function(selected, _)
                  Log.info "Sent to loclist; consider quickfix"
                  UtilFzfDiffiew.git_open_to_loc(selected, "Selected hash commit")
                end,
              },
              ["alt-c"] = {
                fn = UtilFzfDiffiew.git_open_with_compare_hash(),
                desc = "compare-diff-hash",
                header = "compare-diff-hash",
              },
              ["alt-o"] = {
                fn = function(selected)
                  if not selected or #selected == 0 then
                    return
                  end
                  for _, sel in ipairs(selected) do
                    UtilFzfDiffiew.git_open_with_browser(sel)
                  end
                end,
                desc = "open-in-browser",
                header = "open-in-browser",
              },
              ["ctrl-o"] = {
                fn = function(selected)
                  UtilFzfDiffiew.git_open_with_diffview(selected)
                end,
                desc = "open-in-diffview",
                header = "open-in-diffview",
              },
              ["ctrl-x"] = {
                fn = function(selected)
                  UtilFzfDiffiew.git_open_with_fugitive(selected)
                end,
                desc = "open-in-fugitive",
                header = "open-in-fugitive",
              },
              ["ctrl-q"] = {
                fn = function(selected)
                  UtilFzfDiffiew.git_open_diff_to_head(selected)
                end,
                desc = "diff-to-the-head",
                header = "diff-to-the-head",
              },
              ["ctrl-g"] = {
                fn = UtilFzfDiffiew.git_grep_log(),
                desc = "grep-commit-log",
                header = "grep-commit-log",
              },
              ["ctrl-y"] = {
                fn = function(selected)
                  if not selected or #selected == 0 then
                    return
                  end
                  for _, sel in ipairs(selected) do
                    UtilFzfDiffiew.git_copy_to_clipboard_or_yank(sel)
                  end
                end,
                desc = "copy-commit",
                header = "copy-commit",
              },
              ["ctrl-s"] = actions.git_buf_split,
              ["ctrl-v"] = actions.git_buf_vsplit,
              ["ctrl-t"] = actions.git_buf_tabedit,
            },
          },
        },
        grep = {
          hidden = true,
          header_prefix = icons.misc.search .. " ",
          rg_opts = '--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -g "!.git" -e',
          actions = {
            ["alt-y"] = actions.file_edit_or_qf,
            ["alt-q"] = {
              prefix = "select-all",
              fn = function(selected, opts)
                actions.file_sel_to_qf(selected, opts)
              end,
            },
            ["ctrl-x"] = {
              fn = function()
                require("fzf-lua").files {
                  fd_opts = [[--color=never --type d --type l --exclude .git]],
                  actions = {
                    ["default"] = function(selected)
                      if not selected then
                        return
                      end

                      local paths = {}
                      if #selected > 1 then
                        for _, sel in pairs(selected) do
                          if #sel > 0 then
                            table.insert(paths, path_normalize(sel))
                          end
                        end
                      else
                        table.insert(paths, path_normalize(selected[1]))
                      end

                      local opts = {}
                      opts.rg_opts = "--column --line-number --hidden --no-heading --ignore-case --smart-case --color=always --max-columns=4096 "
                        .. table.concat(paths, " ")
                        .. " -e "

                      local title_path = #paths > 1 and "[ " .. table.concat(paths, ", ") .. " ]"
                        or table.concat(paths, " ")

                      opts.winopts = {}
                      opts.winopts.title = "Grep path: " .. title_path .. " "
                      opts.actions = {
                        ["alt-y"] = actions.file_edit_or_qf,
                        ["enter"] = actions.file_edit_or_qf,
                      }

                      require("fzf-lua").live_grep(opts)
                    end,
                  },
                }
              end,
              noclose = true,
              desc = "grep-at-dir",
              header = "grep-at-dir",
            },
          },
        },
        helptags = {
          actions = {
            -- Open help pages in a vertical split.
            ["enter"] = actions.help_vert,
            ["alt-y"] = actions.help_vert,
          },
        },
        lsp = {
          symbols = { symbol_icons = icons.symbol_kinds },
          code_actions = {
            winopts = {
              width = 70,
              height = 20,
              relative = "cursor",
              preview = {
                hidden = true,
                vertical = "down:50%",
              },
            },
          },
        },
        diagnostics = {
          -- Remove the dashed line between diagnostic items.
          multiline = 1,
          diag_icons = {
            icons.diagnostics.Error,
            icons.diagnostics.Warn,
            icons.diagnostics.Info,
            icons.diagnostics.Hint,
          },
          actions = {
            ["ctrl-e"] = {
              fn = function(_, opts)
                -- If not filtering by severity, show all diagnostics.
                if opts.severity_only then
                  opts.severity_only = nil
                else
                  -- Else only show errors.
                  opts.severity_only = vim.diagnostic.severity.ERROR
                end
                require("fzf-lua").resume(opts)
              end,
              noclose = true,
              desc = "toggle-all-only-errors",
              header = function(opts)
                return opts.severity_only and "show all" or "show only errors"
              end,
            },
          },
        },
        oldfiles = {
          include_current_session = true,
          winopts = { preview = { hidden = true } },
          actions = {
            ["ctrl-o"] = {
              fn = function(_, opts)
                if not opts.is_hidden then
                  opts.is_hidden = true
                else
                  opts.is_hidden = false
                end
                opts = {
                  cwd_only = false,
                  winopts = { preview = { hidden = opts.hidden } },
                }
                require("fzf-lua").oldfiles(opts)
              end,
              noclose = true,
              desc = "toggle-hidden-oldfiles",
              header = function(opts)
                return opts.is_hidden and "is hidden" or "only"
              end,
            },
          },
        },
        complete_path = {
          cmd = "fd " .. fd_opts,
          actions = {
            ["enter"] = actions.complete_insert,
            ["alt-y"] = actions.complete_insert,
          },
        },
      }
    end,
  },
}

local function search_current_buf()
  local actions = require "fzf-lua.actions"
  local opts = {
    winopts = {
      height = 0.6,
      width = 0.5,
      preview = { vertical = "up:70%" },
      -- Disable Treesitter highlighting for the matches.
      treesitter = {
        enabled = false,
        fzf_colors = { ["fg"] = { "fg", "CursorLine" }, ["bg"] = { "bg", "Normal" } },
      },
    },
    fzf_opts = {
      ["--layout"] = "reverse",
    },
    actions = {
      ["alt-q"] = {
        prefix = "select-all",
        fn = function(selected, opts)
          actions.file_sel_to_qf(selected, opts)
        end,
        header = false,
      },
    },
  }

  -- Use grep when in normal mode and blines in visual mode since the
  -- former doesn't support searching inside visual selections.
  -- See https://github.com/ibhagwan/fzf-lua/issues/2051
  local mode = vim.api.nvim_get_mode().mode
  if vim.startswith(mode, "n") then
    require("fzf-lua").lgrep_curbuf(opts)
  else
    local sel = require("utils.cmd").get_selection() or ""
    sel = vim.trim((sel:gsub("\n.*", "")))
    opts.query = sel

    vim.api.nvim_feedkeys(vim.keycode "<Esc>", "nx", false)
    require("fzf-lua").blines(opts)
  end
end

UtilKey.noremap({ "n", "x" }, "<Leader>fb", search_current_buf, { desc = "Picker: search current buffer [fzflua]" })
UtilKey.nnoremap("<Leader><Leader>", "<cmd>FzfLua files<cr>", { desc = "Picker: find files [fzflua]" })
UtilKey.nnoremap("<Leader>fc", "<cmd>FzfLua highlights<cr>", { desc = "Picker: highlights [fzfua]" })
UtilKey.nnoremap("<Leader>fC", "<cmd>FzfLua colorschemes<cr>", { desc = "Picker: colorschemes [fzfua]" })
UtilKey.nnoremap("<Leader>fA", "<cmd>FzfLua autocmds<cr>", { desc = "Picker: commands [fzfua]" })
UtilKey.nnoremap("<Leader>fm", "<cmd>FzfLua marks<cr>", { desc = "Picker: marks [fzflua]" })
UtilKey.nnoremap("<Leader>fF", function()
  local packs = vim.pack.get()

  local items = vim.tbl_map(function(pack)
    return pack.spec.name
  end, packs)

  require("fzf-lua").fzf_exec(items, {
    prompt = "Plugins> ",
    actions = {
      ["enter"] = {
        fn = function(selected)
          if not selected or #selected == 0 then
            return
          end

          local item_plugins = {}
          for _, path in pairs(selected) do
            item_plugins[#item_plugins + 1] = path
          end

          Log.info(item_plugins[1])
          local cj = vim.fn.stdpath "data" .. "/site/pack/core/opt/" .. item_plugins[1]
          require("fzf-lua").files { cwd = cj }
        end,
      },
    },
  })
end, { desc = "Picker: commands [fzfua]" })

UtilKey.nnoremap("<Leader>fz", function()
  require("fzf-lua").files {
    cwd = "~/.config/miscxrdb/xresource-theme",
    fzf_opts = { ["--header"] = "" },
    actions = {
      ["default"] = function(selected)
        local colorscheme = require("utils.cmd").__strip_str(selected[1])

        local script_path = vim.fn.expand "$HOME" .. "/.config/rofi/menu/_themes setup " .. colorscheme
        vim.cmd [[ChangeMasterTheme]]
        vim.cmd([[!bash ]] .. script_path)
      end,
    },
  }
end, { desc = "Picker: marks [fzflua]" })

-- Diagnostics
--stylua: ignore
UtilKey.nnoremap( "<Leader>fd", "<cmd>FzfLua lsp_document_diagnostics<cr>", { desc = "Diagnostics: document diagnostics" })

-- Grep
UtilKey.nnoremap("<Leader>fg", "<Cmd>FzfLua live_grep<CR>", { desc = "Picker: live grep [fzflua]" })
UtilKey.xnoremap("<Leader>fg", "<Cmd>FzfLua grep_visual<CR>", { desc = "Picker: grep visual selection [fzflua]" })

UtilKey.nnoremap("<Leader>fh", "<cmd>FzfLua command_history<cr>", { desc = "Picker: command history [fzflua]" })
UtilKey.nnoremap("<Leader>fH", "<cmd>FzfLua search_history<cr>", { desc = "Picker: search history [fzflua]" })

UtilKey.nnoremap("<Leader>fo", function()
  return require("fzf-lua").files { cwd = "~/moxconf/development/dotfiles" }
end, { desc = "Picker: dotfiles [fzflua]" })

-- Help
UtilKey.nnoremap("<Leader>hB", "<cmd>FzfLua keymaps<cr>", { desc = "Help: show global keymaps [fzflua]" })
UtilKey.nnoremap("<Leader>hm", "<cmd>FzfLua man_pages<cr>", { desc = "Help: man pages [fzflua]" })
UtilKey.nnoremap("<Leader>hh", "<cmd>FzfLua help_tags<cr>", { desc = "Help: nvim [fzflua]" })
UtilKey.xnoremap("<Leader>hh", function()
  local sel = require("utils.cmd").get_selection()
  if sel then
    local selection = require("utils.cmd").strip_whitespaces(sel)
    local _, err = pcall(function()
      vim.cmd("h " .. selection)
    end)

    if err then
      Log.warn(selection .. " -> Not found ")
    end
  end
end, { desc = "Help: nvim [fzflua]" })

UtilKey.nnoremap("<Leader>fr", "<cmd>FzfLua oldfiles<cr>", { desc = "Picker: recent files (history buffer) [fzflua]" })
UtilKey.nnoremap("<Leader>fl", "<cmd>FzfLua resume<cr>", { desc = "Picker: resume (last search) [fzfua]" })
UtilKey.nnoremap("z=", "<cmd>FzfLua spell_suggest<cr>", { desc = "Picker: spelling suggestions [fzflua]" })
UtilKey.inoremap("<C-x><C-f>", function()
  require("fzf-lua").complete_path {
    winopts = {
      height = 0.4,
      width = 0.5,
      relative = "cursor",
    },
  }
end, { desc = "Picker: fuzzy complete path [fzflua]" })

-- Git
UtilKey.nnoremap("<C-c>gs", "<cmd>FzfLua git_status<cr>", { desc = "Git: status [fzfua]" })
UtilKey.nnoremap("<C-c>gS", "<cmd>FzfLua git_stash<cr>", { desc = "Git: status [fzfua]" })
UtilKey.nnoremap("<C-c>gl", "<cmd>FzfLua git_bcommits<cr>", { desc = "Git: bcommits [fzfua]" })
UtilKey.nnoremap("<C-c>gL", "<cmd>FzfLua git_commits<cr>", { desc = "Git: commits [fzfua]" })

--stylua: ignore
UtilKey.nnoremap( "<C-c>gD", require("utils.git").trace_file_event, { desc = "Git: track commit for renamed or file deleted [fzflua]" })
--stylua: ignore
UtilKey.nnoremap( "<C-c>gf", require("utils.git").select_file_different_branch, { desc = "Git: find files branch [fzflua]" })

-- LSP
--stylua: ignore
UtilKey.nnoremap("<Leader>fs", "<cmd>FzfLua lsp_document_symbols<cr>", { desc = "LSP: symbols [fzflua]" })
--stylua: ignore
UtilKey.nnoremap( "<Leader>fS", "<cmd>FzfLua lsp_workspace_symbols<cr>", { desc = "LSP: workspaces symbols [fzflua]" })
