---@class r.utils.cmp
local M = {}

---@alias lazyvim.util.cmp.Action fun():boolean?
---@type table<string, lazyvim.util.cmp.Action>
M.actions = {
  -- Native Snippets
  snippet_forward = function()
    if vim.snippet.active { direction = 1 } then
      vim.schedule(function()
        vim.snippet.jump(1)
      end)
      return true
    end
  end,
  snippet_stop = function()
    if vim.snippet then
      vim.snippet.stop()
    end
  end,
}

---@param actions string[]
---@param fallback? string|fun()
function M.map(actions, fallback)
  return function()
    for _, name in ipairs(actions) do
      if M.actions[name] then
        local ret = M.actions[name]()
        if ret then
          return true
        end
      end
    end
    return type(fallback) == "function" and fallback() or fallback
  end
end

---@alias Placeholder {n:number, text:string}

---@param snippet string
---@param fn fun(placeholder:Placeholder):string
---@return string
function M.snippet_replace(snippet, fn)
  return snippet:gsub("%$%b{}", function(m)
    local n, name = m:match "^%${(%d+):(.+)}$"
    return n and fn { n = n, text = name } or m
  end) or snippet
end

-- This function resolves nested placeholders in a snippet.
---@param snippet string
---@return string
function M.snippet_preview(snippet)
  local ok, parsed = pcall(function()
    return vim.lsp._snippet_grammar.parse(snippet)
  end)
  return ok and tostring(parsed)
    or M.snippet_replace(snippet, function(placeholder)
      return M.snippet_preview(placeholder.text)
    end):gsub("%$0", "")
end

-- This function replaces nested placeholders in a snippet with LSP placeholders.
function M.snippet_fix(snippet)
  local texts = {} ---@type table<number, string>
  return M.snippet_replace(snippet, function(placeholder)
    texts[placeholder.n] = texts[placeholder.n] or M.snippet_preview(placeholder.text)
    return "${" .. placeholder.n .. ":" .. texts[placeholder.n] .. "}"
  end)
end

---@param entry cmp.Entry
function M.auto_brackets(entry)
  local cmp = require "cmp"
  local Kind = cmp.lsp.CompletionItemKind
  local item = entry:get_completion_item()
  if vim.tbl_contains({ Kind.Function, Kind.Method }, item.kind) then
    local cursor = vim.api.nvim_win_get_cursor(0)
    local prev_char = vim.api.nvim_buf_get_text(0, cursor[1] - 1, cursor[2], cursor[1] - 1, cursor[2] + 1, {})[1]
    if prev_char ~= "(" and prev_char ~= ")" then
      local keys = vim.api.nvim_replace_termcodes("()<left>", false, false, true)
      vim.api.nvim_feedkeys(keys, "i", true)
    end
  end
end

-- This function adds missing documentation to snippets.
-- The documentation is a preview of the snippet.
---@param window cmp.CustomEntriesView|cmp.NativeEntriesView
function M.add_missing_snippet_docs(window)
  local cmp = require "cmp"
  local Kind = cmp.lsp.CompletionItemKind
  local entries = window:get_entries()
  for _, entry in ipairs(entries) do
    if entry:get_kind() == Kind.Snippet then
      local item = entry:get_completion_item()
      if not item.documentation and item.insertText then
        item.documentation = {
          kind = cmp.lsp.MarkupKind.Markdown,
          value = string.format("```%s\n%s\n```", vim.bo.filetype, M.snippet_preview(item.insertText)),
        }
      end
    end
  end
end

function M.visible()
  ---@module 'cmp'
  local cmp = package.loaded["cmp"]
  return cmp and cmp.core.view:visible()
end

-- This is a better implementation of `cmp.confirm`:
--  * check if the completion menu is visible without waiting for running sources
--  * create an undo point before confirming
-- This function is both faster and more reliable.
---@param opts? {select: boolean, behavior: cmp.ConfirmBehavior}
function M.confirm(opts)
  local cmp = require "cmp"
  opts = vim.tbl_extend("force", {
    select = true,
    behavior = cmp.ConfirmBehavior.Insert,
  }, opts or {})
  return function(fallback)
    if cmp.core.view:visible() or vim.fn.pumvisible() == 1 then
      RUtils.create_undo()
      if cmp.confirm(opts) then
        return
      end
    end
    return fallback()
  end
end

function M.expand(snippet)
  -- Native sessions don't support nested snippet sessions.
  -- Always use the top-level session.
  -- Otherwise, when on the first placeholder and selecting a new completion,
  -- the nested session will be used instead of the top-level session.
  -- See: https://github.com/LazyVim/LazyVim/issues/3199
  local session = vim.snippet.active() and vim.snippet._session or nil

  local ok, err = pcall(vim.snippet.expand, snippet)
  if not ok then
    local fixed = M.snippet_fix(snippet)
    ok = pcall(vim.snippet.expand, fixed)

    local msg = ok and "Failed to parse snippet,\nbut was able to fix it automatically."
      or ("Failed to parse snippet.\n" .. err)

    RUtils[ok and "warn" or "error"](
      ([[%s
```%s
%s
```]]):format(msg, vim.bo.filetype, snippet),
      { title = "vim.snippet" }
    )
  end

  -- Restore top-level session when needed
  if session then
    vim.snippet._session = session
  end
end

---@param opts cmp.ConfigSchema | {auto_brackets?: string[]}
function M.setup(opts)
  local cmp = require "cmp"
  cmp.setup(opts)

  local behavior_insert = { behavior = cmp.SelectBehavior.Insert }
  -- cmp.setup.filetype("dap-repl", {
  --   sources = cmp.config.sources(vim.tbl_deep_extend("force", {}, tbl_custom_sources, { { name = "dap" } })),
  -- })
  --
  -- cmp.setup.filetype("gitcommit", {
  --   sources = cmp.config.sources(vim.tbl_deep_extend("force", {}, tbl_custom_sources, { { name = "emoji" } })),
  -- })
  -- cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
  --   sources = {
  --     { name = "vim-dadbod-completion" },
  --     { name = "buffer" },
  --   },
  -- })

  local cmd_mapping = {
    -- ["<C-e>"] = { c = cmp.mapping.abort() },
    ["<C-y>"] = {
      c = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      },
    },

    ["<C-n>"] = {
      c = function()
        if cmp.visible() then
          cmp.select_next_item(behavior_insert)
        else
          cmp.complete {}
        end
      end,
    },
    ["<C-p>"] = {
      c = function()
        if cmp.visible() then
          cmp.select_prev_item(behavior_insert)
        end
      end,
    },
  }

  cmp.setup.filetype("gitcommit", {
    mapping = cmd_mapping,
  })

  cmp.setup.filetype({ "org", "rgflow" }, {
    sources = cmp.config.sources({
      { name = "emoji" },
      { name = "path" },
      { name = "luasnip" },
      { name = "orgmode" },
    }, {
      { name = "cmdline" },
      { name = "buffer" },
    }),
  })

  cmp.setup.cmdline(":", {
    mapping = cmd_mapping,
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }),
  })

  cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmd_mapping,
    sources = cmp.config.sources {
      { name = "buffer" },
    },
  })
end

return M
