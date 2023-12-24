local fmt, cmd, fn = string.format, vim.cmd, vim.fn
local Util = require "r.utils"

local M = {}

function M.neorg_mappings_ft(bufnr)
  local neorg = require "neorg"
  local fzf_lua = require "fzf-lua"

  local mappings = {
    ["n"] = {
      ["<Localleader>oa"] = {
        function()
          Util.tiling.force_win_close({ "OverseerList", "toggleterm", "termlist", "undotree", "aerial" }, true)
          cmd "Neorg toc right"
          local vim_width = vim.o.columns
          vim_width = math.floor(vim_width / 2 - 10)
          cmd(fmt("vertical resize %s", vim_width))
        end,
        "Note(neorg): open toc sidebar",
      },
      ["tt"] = {
        function()
          -- Util.tiling.force_win_close({ "OverseerList", "toggleterm", "termlist", "undotree", "aerial" }, true)
          -- cmd "Neorg toc right"
          -- local vim_width = vim.o.columns
          -- vim_width = math.floor(vim_width / 2 - 10)
          -- cmd(fmt("vertical resize %s", vim_width))

          return Util.neorg_notes.check_broken_links(neorg)
        end,
        "Note(neorg): open toc right(curbuf)",
      },
      ["ri"] = {
        function()
          return Util.maim.insert()
        end,
        "Note(neorg): insert image",
      },
      ["rf"] = {
        function()
          local Job = require "plenary.job"
          -- async
          local data = {}
          Job:new({
            command = "obsidian",
            -- args = { "-a" },
            on_stdout = function(_, line)
              table.insert(data, line)
            end,
            on_exit = function()
              print "done"
            end,
          }):start()
          -- sync
          -- local ls = Job:new({ command = "ls", args = { "-a" } }):sync()
          -- for i, _ in ipairs(ls) do
          --   assert(ls[i] == data[i])
          -- end

          -- print(fn.expand "%:p")
          -- cmd [[MarkdownPreviewToggle]]
        end,
      },
      ["<Localleader>ff"] = {
        function()
          local col, row = Util.fzflua.rectangle_win_pojokan()
          Util.fzflua.send_cmds({
            grep_string_note = function()
              cmd [[Lazy load neorg]]
              return require("fzf-lua").live_grep_glob {
                prompt = "  ",
                cwd = require("r.config").path.wiki_path,
                rg_opts = [[--column --hidden --no-heading --ignore-case --smart-case --color=always  --max-columns=4096 -g "*.norg" ]],
                winopts = {
                  title = Util.fzflua.format_title("[Neorg] Grep", " "),
                },
              }
            end,
            find_norg_files = function()
              cmd [[Lazy load neorg]]

              return require("fzf-lua").files {
                prompt = "  ",
                cwd = require("r.config").path.wiki_path,
                rg_glob = true,
                file_ignore_patterns = { "%.md$", "%.json$", "%.org$" },
                winopts = {
                  -- fullscreen = true,
                  title = Util.fzflua.format_title("[Neorg] Files", " "),
                },
              }
            end,
            find_site_links = function()
              -- Karena use grep utk curbuf, agar bisa menggunakan regex
              -- pakai `lgrep_curbuf`
              require("fzf-lua").grep_curbuf {
                prompt = "  ",
                search = [[(\{:\$|\{http)]],
                no_esc = true,
                fzf_opts = { ["--layout"] = "reverse" },
                winopts = {
                  title = Util.fzflua.format_title("[Neorg] site links", " "),
                },
              }
            end,

            find_link_friends = function()
              cmd "normal yi}"
              local title = vim.fn.getreg '"0'
              local title_trim = title:gsub([[^:%$]], [[:\$]])

              require("fzf-lua").grep {
                prompt = "  ",
                cwd = require("r.config").path.wiki_path,
                no_esc = true,
                search = title_trim,
                fzf_opts = { ["--layout"] = "reverse" },
                winopts = {
                  title = Util.fzflua.format_title("[Neorg] Link Friends", " "),
                },
              }
            end,
            find_title_curbuf = function()
              require("fzf-lua").grep_curbuf {
                prompt = "  ",
                search = [[^(\*|\*\*|\*\*\*|\*\*\*\*).*$]],
                no_esc = true,
                fzf_opts = { ["--layout"] = false },
                winopts = {
                  title = Util.fzflua.format_title("[Neorg] Title Curbuf", " "),
                },
              }
            end,
            find_title_global = function()
              require("fzf-lua").grep {
                prompt = "  ",
                cwd = require("r.config").path.wiki_path,
                no_esc = true,
                search = [[^(\*|\*\*|\*\*\*|\*\*\*\*).*$]],
                fzf_opts = { ["--layout"] = false },

                winopts = {
                  title = Util.fzflua.format_title("[Neorg] Title Global", " "),
                },
              }
            end,
            find_categories_links = function()
              local opts = {
                prompt = "  ",
                winopts = {
                  title = Util.fzflua.format_title("[Neorg] find by categories", " "),
                  preview = {
                    hidden = "hidden",
                    vertical = "up:55%",
                    horizontal = "right:60%",
                    layout = "vertical",
                  },
                },
                actions = {
                  ["default"] = function(selected, _)
                    local selection = selected[1]
                    print(selection)
                  end,
                },
              }
              return require("fzf-lua").fzf_exec(Util.neorg_notes.find_by_categories(), opts)
            end,
            find_todo_curbuf = function()
              cmd(fmt("TodoQuickFix cwd=%s", fn.expand "%:p"))
            end,
            find_todo_global = function()
              cmd(fmt([[TodoQuickFix cwd=%s]], require("r.config").path.wiki_path))
            end,
          }, {
            winopts = { title = require("r.config").icons.misc.list .. " Neorg", col = col, row = row },
          })
        end,
        "Note(neorg): list of cmds",
      },
    },

    ["i"] = {
      ["c<cr>"] = {
        function()
          local opts = {
            prompt = "  ",
            winopts = {
              -- split = "belowright new | wincmd J | resize 40",
              title = Util.fzflua.format_title("[Neorg] Link Curbuf", " "),
              preview = {
                hidden = "hidden",
                vertical = "up:55%",
                horizontal = "right:60%",
                layout = "vertical",
              },
            },
            actions = {
              ["default"] = function(selected, _)
                local selection = selected[1]
                -- local str_path = selection:match "%[(.*)%]"

                vim.api.nvim_put({ selection }, "c", false, true)
              end,
            },
          }

          return require("fzf-lua").fzf_exec(Util.neorg_notes.find_by_categories(), opts)
        end,
        "Note(fzflua): insert categories (curbuf)",
      },
      ["l<cr>"] = {
        function()
          local opts = {
            prompt = "  ",
            winopts = {
              -- split = "belowright new | wincmd J | resize 40",
              title = Util.fzflua.format_title("[Neorg] Link Curbuf", " "),
              preview = {
                hidden = "hidden",
                vertical = "up:55%",
                horizontal = "right:60%",
                layout = "vertical",
              },
            },
            actions = {
              ["default"] = function(selected, _)
                local selection = selected[1]
                local str_path = selection:match "%[(.*)%]"

                vim.api.nvim_put({
                  "[" .. str_path .. "]",
                }, "c", false, true)
              end,
            },
          }

          return require("fzf-lua").fzf_exec(Util.neorg_notes.finder_sitelinkable(neorg), opts)
        end,
        "Note(fzflua): insert link (curbuf)",
      },
      ["t<cr>"] = {
        function()
          local opts = {
            prompt = "  ",
            winopts = {
              title = Util.fzflua.format_title("[Neorg] Title Curbuf", " "),
            },
            actions = {
              ["default"] = function(selected, _)
                local selection = selected[1]
                local str_path = string.gsub(selection:match "|.*$", "| ", "")

                -- print(str_path)

                vim.api.nvim_put({
                  "{" .. str_path .. "}",
                }, "c", false, true)
              end,
            },
          }

          return require("fzf-lua").fzf_exec(Util.neorg_notes.finder_linkable(neorg), opts)
        end,
        "Note(fzflua): insert title (curbuf)",
      },
      ["T<cr>"] = {
        function()
          local opts = {
            prompt = "  ",
            winopts = {
              title = Util.fzflua.format_title("[Neorg] Title Global", " "),
            },
            fzf_opts = {
              ["--preview"] = fzf_lua.shell.preview_action_cmd(function(items)
                local selection = items[1]:match "[^%s]+" .. ".norg"
                selection = os.getenv "HOME" .. "/Dropbox/neorg/" .. selection

                return "cat " .. selection
              end),
            },

            actions = {
              ["default"] = function(selected, _)
                local selection = selected[1]

                local link_path = selection:match "[^%s]+"

                local title = selection:match "*.+$"
                local trim_title = string.gsub(title, "*", "")

                vim.api.nvim_put({
                  "[" .. trim_title .. "]" .. "{:$/" .. link_path .. ":" .. title .. "}",
                }, "c", false, true)
              end,
            },
          }

          return require("fzf-lua").fzf_exec(Util.neorg_notes.finder_linkableGlobal(neorg), opts)
        end,
        "Note(fzflua): insert title (global)",
      },
    },
  }

  -- local resuffle = {}
  for i, x in pairs(mappings) do
    if i == "i" then
      for g, gg in pairs(x) do
        vim.keymap.set(i, g, gg[1], { desc = gg[2], buffer = bufnr })
      end
    else
      for j, jj in pairs(x) do
        vim.keymap.set(i, j, jj[1], { desc = jj[2], buffer = bufnr })
      end
    end
  end
end

return M
