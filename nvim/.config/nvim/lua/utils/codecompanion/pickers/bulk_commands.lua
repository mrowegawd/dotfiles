local lazy = require("utils.plugin").require_lazy

local M = {}

local ConfigPath = lazy("config").path
local UtilCmd = lazy "utils.cmd"

local IconMisc = lazy("icons").misc

local Fzflua = lazy "fzf-lua"
local UtilFzflua = lazy "utils.fzflua"

local Log = lazy "utils.log"

local codecompanion = lazy "codecompanion"
local slash_commands = lazy "utils.codecompanion.slash_commands"
local chat_helpers = lazy("utils.codecompanion.helpers").chat
local window_helpers = lazy("utils.codecompanion.helpers").window

local state_helpers = lazy("utils.codecompanion.helpers").state

-- CodeCompanion chat filetype-local mapping callbacks
local function show_adapter_info(chat_obj)
  local adapter = chat_obj.adapter
  local model = state_helpers.get_adapter_model(adapter)
  local params = adapter.type == "acp" and adapter.defaults or chat_obj.settings
  local adapter_info = {
    { "type", adapter.type },
    { "name", adapter.name },
    { "model", model },
    { "model_params", params },
  }
  local lines = vim
    .iter(adapter_info)
    :map(function(item)
      ---@diagnostic disable-next-line: missing-return-value
      return string.format("%s = %s", item[1], vim.inspect(item[2]))
    end)
    :totable()
  Log.info(string.format("Adapter Info\n%s", table.concat(lines, "\n")))
end

function M.select_custom_prompt_and_commands()
  local git_ft_stuff = { "fugitive", "NeogitCommitMessage", "gitcommit" }
  local prompt_cmds = {
    -- +-----------------------------------------------------------------------------+
    -- |                                  Ai STUFF                                   |
    -- +-----------------------------------------------------------------------------+

    -- ├─────────────────────────────┤ EXPLAIN STUFF ├──────────────────────────┤
    ["Code - explain to me"] = {
      cmd = function()
        slash_commands.explain_selection "explain_code"
      end,
      mode = "V",
      ft = {},
    },

    -- ├─────────────┤ FIX, CORRECT, IMPROVE THE EN OR IDN SENTENCE. ├──────────┤
    ["Correct - eng sentence"] = { cmd = "CodeCompanion /correct_sentence_en", ft = {} },
    ["Correct - todo sentence"] = { cmd = "CodeCompanion /correct_todo_sentence", ft = {} },
    ["Correct - wiki sentence"] = { cmd = "CodeCompanion /correct_wiki_sentence", ft = {} },

    -- ├──────────────────────────────────┤ GIT ├───────────────────────────────┤
    ["_Git - commit"] = {
      cmd = function()
        chat_helpers.run_slash_command "conventional_commit"
      end,
      mode = "n",
      ft = git_ft_stuff,
    },
    ["_Git - fix or rewrote commit"] = { cmd = "CodeCompanion /commit", ft = {} },

    -- ├───────────────────────────────┤ WRITE DOC ├────────────────────────────┤
    ["Doc - write for inline doc codes"] = { cmd = "CodeCompanion /inline_doc", ft = {} },
    ["Doc - write for func docs"] = { cmd = "CodeCompanion /doc", ft = {} },

    -- +-----------------------------------------------------------------------------+
    -- |                                  TRANSLATE                                  |
    -- +-----------------------------------------------------------------------------+
    ["Translator - eng id"] = {
      cmd = function()
        slash_commands.explain_selection "translate_this_line_to_ind"
      end,
      mode = "V",
      ft = {},
    },

    -- +-----------------------------------------------------------------------------+
    -- |                                    SHOW                                     |
    -- +-----------------------------------------------------------------------------+
    ["ChatBuffer - info adapter"] = {
      cmd = function()
        local bufnr = vim.api.nvim_get_current_buf()
        local chat_obj = codecompanion.buf_get_chat(bufnr)
        show_adapter_info(chat_obj)
      end,
      mode = "n",
      ft = { "codecompanion" },
    },

    ["ChatBuffer - info system role"] = {
      cmd = function()
        vim.cmd.stopinsert()
        local system_role = state_helpers.get_current_system_role_prompt()
        if not system_role or system_role == "" then
          return
        end
        ---@diagnostic disable-next-line: undefined-field
        Log.info(system_role)
      end,
      mode = "n",
      ft = { "codecompanion" },
    },
    ["ChatBuffer - zoom"] = {
      cmd = function()
        window_helpers.toggle_chat_zoom()
      end,
      mode = "n",
      ft = { "codecompanion" },
    },

    -- +-----------------------------------------------------------------------------+
    -- |                                    NOTE                                     |
    -- +-----------------------------------------------------------------------------+
    ["Note - fix note global"] = { cmd = "CodeCompanion /writer_and_reformat_note_id" },
    ["Note - fix note Org"] = { cmd = "CodeCompanion /writer_and_reformat_note_id_org" },

    -- +-----------------------------------------------------------------------------+
    -- |                                   CODING                                    |
    -- +-----------------------------------------------------------------------------+
    -- Programming stuff
    ["Refactor - Inline code"] = { cmd = "CodeCompanion /refactor", ft = {} },
    ["Refactor - Avoid side effect from code"] = { cmd = "CodeCompanion /refactor_side_effect", ft = {} },
    ["Refactor - Rewrite naming variable"] = { cmd = "CodeCompanion /naming", ft = {} },
    ["Refactor - Seggest better naming variable"] = { cmd = "CodeCompanion /better_naming", ft = {} },

    -- +-----------------------------------------------------------------------------+
    -- |                                COMMAND OPEN                                 |
    -- +-----------------------------------------------------------------------------+
    ["Chat - ask ai"] = {
      cmd = function()
        window_helpers.focus_or_toggle_chat { startinsert = false }
      end,
      mode = "n",
      ft = {},
    },
    ["Chat - new"] = { cmd = "CodeCompanionChat", mode = "n", ft = {} },
    ["Chat - history"] = { cmd = "CodeCompanionHistory", mode = "n", ft = {} },
    ["Chat - actions"] = { cmd = "CodeCompanionActions", mode = "n", ft = {} },
    ["Chat - edit prompts"] = {
      cmd = function()
        return Fzflua.files {
          cwd = ConfigPath.prompt_dir,
          no_header = false,
          no_header_i = true, -- hide interactive header?
          fzf_opts = { ["--header"] = [[^x:delete  ^r:rename]] },
          cmd = "fd -d 1 -e md --exec stat --format '%Z %n' {} | sort -nr | cut -d' ' -f2- | sed 's/.json$//' | sed 's/\\.\\///'",
          winopts = { title = "Edit Prompts", preview = { hidden = false } },
        }
      end,
      mode = "n",
      ft = {},
    },
    ["Chat - CodeCompanionListChat"] = {
      cmd = function()
        local function get_items()
          local registry = lazy "codecompanion.interactions.shared.registry"
          local items = {}
          for _, entry in ipairs(registry.list()) do
            table.insert(items, {
              name = entry.name,
              interaction = entry.interaction,
              description = entry.description,
              bufnr = entry.bufnr,
              callback = entry.open,
            })
          end
          return items
        end

        local items = get_items()
        if #items == 0 then
          vim.cmd.CodeCompanionActions()
          return
        end

        local context = lazy("codecompanion.utils.context").get(vim.api.nvim_get_current_buf())
        return lazy("codecompanion.action_palette").launch_picker(items, {
          columns = { "name", "description" },
          context = context,
          title = "List actions",
        })
      end,
      mode = "n",
      ft = {},
    },
  }

  local results_formats = function()
    local width_cmd = 1

    for idx, _ in pairs(prompt_cmds) do
      local str_x = vim.split(idx, " ")
      if width_cmd < #str_x[1] then
        width_cmd = #str_x[1]
      end
    end

    local results = {}
    local mode = vim.api.nvim_get_mode().mode

    for idx, x in pairs(prompt_cmds) do
      if x.ft and #x.ft > 0 and vim.tbl_contains(x.ft, vim.bo.filetype) then
        if x.mode and x.mode == mode then
          local str_x = vim.split(idx, "-")
          local str_x_hl = Fzflua.utils.ansi_from_hl("GitSignsAdd", str_x[1])
          results[#results + 1] = string.format("%-" .. (width_cmd + 25) .. "s - %s", str_x_hl, str_x[2])
        end
        goto continue
      end

      -- An empty `x.ft` would be included in the results,
      -- so we need to ensure length `x.ft` is `0`.
      if x.ft and #x.ft > 0 then
        goto continue
      end

      local str_x = vim.split(idx, "-")
      local str_x_hl = Fzflua.utils.ansi_from_hl("GitSignsAdd", str_x[1])
      if x.mode and x.mode == mode then
        results[#results + 1] = string.format("%-" .. (width_cmd + 25) .. "s - %s", str_x_hl, str_x[2])
      end

      ::continue::
    end

    table.sort(results)

    return results
  end

  local opts = UtilFzflua.open_center_small_wide {
    winopts = {
      title = string.format("Select Prompt Ai [CodeCompanion]", IconMisc.ai),
      height = 0.4,
      width = 0.5,
    },
    actions = {
      ["default"] = function(selected, _)
        if not selected then
          return
        end

        local sel = selected[1]

        local display_str = Fzflua.utils.strip_ansi_coloring(sel)
        local display_str_split = vim.split(display_str, "-")

        local build_idx_cmd = UtilCmd.strip_whitespaces(display_str_split[1])
          .. " - "
          .. UtilCmd.strip_whitespaces(display_str_split[2])

        local prompt = prompt_cmds[build_idx_cmd]
        if not prompt then
          Log.error(string.format("Prompt indexing failed for build_idx_cmd: %s", build_idx_cmd))
          return
        end

        if type(prompt.cmd) == "string" then
          vim.cmd(prompt.cmd)
          return
        end

        if type(prompt.cmd) == "function" then
          prompt.cmd()
          return
        end
      end,
    },
  }

  local results = results_formats()
  Fzflua.fzf_exec(results, opts)
end

return M
