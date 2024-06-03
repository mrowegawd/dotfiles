local fmt, cmd = string.format, vim.cmd

local M = {}

function M.neorg_mappings_ft(bufnr)
  local mappings = {
    ["n"] = {
      ["ri"] = {
        function()
          return RUtils.maim.insert()
        end,
        "Note: insert image",
      },
      ["<Localleader>sT"] = {
        function()
          return require("fzf-lua").grep {
            prompt = "   ",
            cwd = RUtils.config.path.wiki_path,
            search = "^#.*",
            rg_glob = false,
            no_esc = true,
            file_ignore_patterns = { "%.norg$", "%.json$", "%.org$" },
            rg_opts = [[--column --hidden --no-heading --ignore-case --smart-case --color=always --max-columns=4096 -g "*.md" ]],
            winopts = {
              fullscreen = true,
              title = RUtils.fzflua.format_title(
                "Obsidian > Search Global Note Titles",
                RUtils.cmd.strip_whitespace(RUtils.config.icons.misc.code),
                "GitSignsChange"
              ),
            },
          }
        end,
        desc = "Note: search title global [obsidian]",
      },
      ["<Localleader>st"] = {
        function()
          -- FIX: ini masih error
          local fullname = vim.fn.fnamemodify(vim.fn.bufname(0), ":.")
          return require("fzf-lua").grep {
            prompt = "   ",
            -- cwd = fullname,
            search = "^#.*",
            rg_glob = false,
            no_esc = true,
            file_ignore_patterns = { "%.norg$", "%.json$", "%.org$" },
            rg_opts = [[--column --hidden --no-heading --ignore-case --smart-case --color=always --max-columns=4096 -g "*.md" ]]
              .. fullname,
            winopts = {
              fullscreen = true,
              title = RUtils.fzflua.format_title(
                "Obsidian > Search Note Titles",
                RUtils.cmd.strip_whitespace(RUtils.config.icons.misc.code),
                "GitSignsChange"
              ),
            },
          }
        end,
        desc = "Note: search title global [obsidian]",
      },
      ["<leader>sT"] = {
        function()
          RUtils.todocomments.search_global_note {
            title = "Todo Note Global",
          }
        end,
        "Note: search todo global note [fzflua]",
      },
      ["<leader>st"] = {
        function()
          RUtils.todocomments.search_local {
            title = "Todo Note Curbuf",
          }
        end,
        "Note: search todo local note [fzflua]",
      },
      ["<Localleader>oa"] = {
        function()
          if vim.bo[0].filetype == "neorg" then
            RUtils.tiling.force_win_close({ "OverseerList", "toggleterm", "termlist", "undotree", "aerial" }, true)
            cmd "Neorg toc right"
            local vim_width = vim.o.columns
            vim_width = math.floor(vim_width / 2 - 10)
            cmd(fmt("vertical resize %s", vim_width))
          else
            vim.cmd [[AerialToggle]]
          end
        end,
        "Note: open toc",
      },
      ["gD"] = {
        function()
          vim.cmd "vsplit | ObsidianFollowLink"
        end,
        "Note: followlink vertical split",
      },
    },

    ["i"] = {
      ["c<cr>"] = {
        function()
          local note_ext = "norg"
          if vim.bo[0].filetype == "markdown" then
            note_ext = "md"
          end

          if note_ext == "md" then
            local opts = {
              prompt = "  ",
              winopts = {
                -- split = "belowright new | wincmd J | resize 40",
                title = RUtils.fzflua.format_title("Note: insert categories", ""),
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

            return require("fzf-lua").fzf_exec(RUtils.neorg.find_by_categories(), opts)
          end
        end,
        "Note: insert categories (curbuf)",
      },
      ["l<cr>"] = {
        function()
          local opts = {
            prompt = "  ",
            winopts = {
              -- split = "belowright new | wincmd J | resize 40",
              title = RUtils.fzflua.format_title("Note: link curbuf", ""),
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

          return require("fzf-lua").fzf_exec(RUtils.neorg.finder_sitelinkable(), opts)
        end,
        "Note: insert link (curbuf)",
      },
      ["t<cr>"] = {
        function()
          local opts = {
            prompt = "  ",
            winopts = {
              title = RUtils.fzflua.format_title("Note: title curbuf", ""),
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

          return require("fzf-lua").fzf_exec(RUtils.neorg.finder_linkable(), opts)
        end,
        "Note: insert title (curbuf)",
      },
      ["T<cr>"] = {
        function()
          local note_ext = "norg"
          if vim.bo[0].filetype == "markdown" then
            note_ext = "md"
          end

          local opts = {
            prompt = "  ",
            winopts = {
              title = RUtils.fzflua.format_title("Note: title global", ""),
            },
            actions = {
              ["default"] = function(selected, _)
                local selection = selected[1]

                if note_ext == "norg" then
                  local link_path = selection:match "[^%s]+"

                  local title = selection:match "*.+$"
                  local trim_title = string.gsub(title, "*", "")

                  vim.api.nvim_put({
                    "[" .. trim_title .. "]" .. "{:$/" .. link_path .. ":" .. title .. "}",
                  }, "c", false, true)
                else
                  local parts = vim.split(selection, ".md")
                  local path_name = vim.split(parts[1], "/")
                  local path_file = path_name[#path_name]

                  local path_heading = vim.split(parts[2], "#")
                  -- remove space
                  local path_linkheading = string.gsub(path_heading[#path_heading], "^%s", "")

                  local path_str = RUtils.fzflua.__strip_str(path_file)
                  if path_str == nil then
                    return
                  end
                  vim.api.nvim_put({
                    "[[" .. path_str .. "#" .. path_linkheading .. "]]",
                  }, "c", false, true)
                end
              end,
            },
          }

          if note_ext == "neorg" then
            opts.fzf_opts = {
              ["--preview"] = require("fzf-lua").shell.preview_action_cmd(function(items)
                local selection = items[1]:match "[^%s]+" .. "." .. note_ext
                selection = os.getenv "HOME" .. "/Dropbox/neorg/" .. selection

                return "cat " .. selection
              end),
            }
          end

          if note_ext == "md" then
            opts.search = [[^#.*]]
            opts.cwd = RUtils.config.path.wiki_path
            opts.rg_opts =
              [[--column --hidden --no-heading --ignore-case --smart-case --color=always --max-columns=4096 -g "*.md" -e ]]
          end

          opts.rg_glob = false
          opts.no_esc = true
          if note_ext == "norg" then
            return require("fzf-lua").fzf_exec(RUtils.neorg.finder_linkableGlobal(), opts)
          else
            return require("fzf-lua").grep(opts)
          end
        end,
        "Note: insert title (global)",
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
