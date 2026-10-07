local add = require("vim-pack").add

local IconMisc = require("icons").misc

local alts = {
  FIX = { "FIXME", "BUG", "FIXIT", "ISSUE", "ERROR" },
  DONE = { "DONE", "DONE!", "DONE.", "FIXED", "WONTFIX" },
  TODO = { "PLAN", "TODO", "TASK", "START", "BEGIN" },
  WARN = { "WARNING", "WARN", "HACK" },
  PREF = { "PERF", "OPTIM", "OPTIMIZE", "PERFORMANCE" },
  INFO = { "INFO" },
}

local UtilKey = require "utils.map"

add {
  {
    src = "folke/todo-comments.nvim",
    lazy = true,
    opts = {
      signs = true,
      sign_priority = 8,
      keywords = {
        FIX = { icon = IconMisc.tools, color = "error", alt = alts.FIX },
        WARN = { icon = IconMisc.bug, color = "warning", alt = alts.WARN },
        TODO = { icon = IconMisc.check_big, color = "info", alt = alts.TODO },
        NOTE = { icon = IconMisc.note, color = "hint", alt = alts.INFO },
      },
      highlight = {
        before = "", -- "fg", "bg", or empty
        keyword = "wide", -- "fg", "bg", "wide", or empty
        after = "fg", -- "fg", "bg", or empty
        pattern = [[.*<(KEYWORDS)*:]],
        comments_only = true, -- highlight only inside comments using treesitter
        max_line_len = 400, -- ignore lines longer than this
        exclude = {}, -- list of file types to exclude highlighting
      },
      colors = {
        error = { "#DC2626" },
        warning = { "#FBBF24" },
        info = { "#2563EB" },
        hint = { "#10B981" },
        default = { "#7C3AED" },
      },
      search = {
        command = "rg",
        -- pattern = [[\b(KEYWORDS):\s]], -- ripgrep regex
        search = {
          pattern = [[(?:\/\/|--(\[\[)?|\*|#\|?|%\{?|;|\{-)[\t ]*(?:(KEYWORDS):)]],
          -- https://www.reddit.com/r/neovim/comments/1qdhr3s/todocommentsnvim_reducing_amount_of_false/
          --[[
          Regex explanation:
          1. (?:...) - non-capture group for comment tokens:
            \/\/ - matches // , used in lots of languages
            --(\[\[)? - matches -- and --[[ , -- used in  SQL, Haskell, Lua,
                  Ada, AppleScript, VHDL, --[[ used in Lua multiline, also
                  matches <!-- for HTML, XML, Markdown
            \*   - matches various formats ( /* /** (* ), lines starting 
                  with * in formatted multiline comments (usually
                  after /* ), also COBOL
            #\|? - matches # and #| - lots of languages comment with # ,
                  ### used in CoffeeScript, #| in Racket and Common
                  Lisp multiline
            %\{? - matches % and %{, % used in MATLAB, Erlang, Prolog,
                  TeX/LaTeX, also %{ used in MATLAB
            ;    - used in Assembly, Lisp, Clojure, Scheme, INI files
            {-   - Haskel multiline
          2. [\t ]* - 0 or any amount of tabs and spaces
          3. (?:(KEYWORDS):) - non-capture group with keywords placeholder ending with :

          This regex does not match: Python docstrings ( """ or ''' ), Ruby
          multiline ( =begin ), Clojure comment reader macro, Batch files,
          Roxygen, Fortran, Visual Basic, VBScript, Basic, PostScript, J, M4
          ]]
        },
        args = {
          "--color=never",
          "--no-heading",
          "--follow",
          "--hidden",
          "--with-filename",
          "--line-number",
          "--column",
          "-g",
          "!node_modules/**",
          "-g",
          "!.git/**",
        },
      },
    },
  },
}

UtilKey.nnoremap("<Leader>fT", function()
  UtilKey.plugin_load_now "todo-comments.nvim"
  local UtilTodocomments = require "utils.todocomments"
  if vim.bo.filetype == "markdown" then
    UtilTodocomments.search_global_note("markdown", { title = "Todo Note Markdown Global" })
  elseif vim.bo.filetype == "org" then
    UtilTodocomments.search_global_note("org", { title = "Todo Note org Global" })
  else
    UtilTodocomments.search_global { title = "Global" }
  end

  vim.cmd "normal! zz"
end, { desc = "Picker: find todo comment global (fzflua) [todocomments]" })

UtilKey.nnoremap("<Leader>ft", function()
  UtilKey.plugin_load_now "todo-comments.nvim"
  local UtilTodocomments = require "utils.todocomments"
  UtilTodocomments.search_local { title = "Curbuf" }
  vim.cmd "normal! zz"
end, { desc = "Picker: find todo comment local (fzflua) [todocomments]" })
