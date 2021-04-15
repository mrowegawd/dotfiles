local lsp = require("lspconfig")
local lsp_mappings = require("modules.lsp._mappings")
local lsp_status = require("lsp-status")
local is_cfg_present = require("modules._util").is_cfg_present
local util = require("lspconfig/util")
local fn = vim.fn

local indicator_error = ""
local indicator_warn = ""
local indicator_info = ""
local indicator_hint = ""
local indicator_ok = ""

-- lsp-status ---------------------------------------------------------
-----------------------------------------------------------------------

local select_symbol = function(cursor_pos, symbol)
  if symbol.valueRange then
    local value_range = {
      ["start"] = {
        character = 0,
        line = fn.byte2line(symbol.valueRange[1]),
      },
      ["end"] = {
        character = 0,
        line = fn.byte2line(symbol.valueRange[2]),
      },
    }

    return require("lsp-status.util").in_range(cursor_pos, value_range)
  end
end

local lsp_status_active = function()
  lsp_status.config({
    select_symbol = select_symbol,

    indicator_errors = indicator_error,
    indicator_warnings = indicator_warn,
    indicator_info = indicator_info,
    indicator_hint = indicator_hint,
    indicator_ok = indicator_ok,
    spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },
  })

  lsp_status.register_progress()
end

lsp_status_active()

-- lsp-saga -----------------------------------------------------------
-----------------------------------------------------------------------

require("lspsaga").init_lsp_saga({
  error_sign = indicator_error,
  warn_sign = indicator_warn,
  hint_sign = indicator_hint,
  infor_sign = indicator_info,
  code_action_prompt = {
    enable = false,
    sign = true,
    sign_priority = 20,
    virtual_text = false,
  },

  finder_action_keys = {
    open = 'o', vsplit = 'v',split = 's',quit = 'q',
    scroll_down = '<C-j>',scroll_up = '<C-k>'
  },

  -- 1: thin border | 2: rounded border | 3: thick border
  border_style = "round",
})


-- lsp-config ---------------------------------------------------------
-----------------------------------------------------------------------

local custom_on_attach = function(client)
  lsp_status.on_attach(client)          -- attach lsp_status
  lsp_mappings.lsp_mappings()
end

local custom_on_init = function(client)
  -- print("Language Server Protocol started!")

  if client.config.flags then
    client.config.flags.allow_incremental_sync = true
  end
end

local custom_capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  return capabilities
end

-- lsp-diagnostic -----------------------------------------------------
-----------------------------------------------------------------------

require("modules.lsp._diagnostic")
-- use eslint if the eslint config file present
local is_using_eslint = function(_, _, result, client_id)
  if is_cfg_present("/.eslintrc.json") or is_cfg_present("/.eslintrc.js") then
    return
  end

  return vim.lsp.handlers["textDocument/publishDiagnostics"](_, _, result, client_id)
end

-- local flake8 = {
--     LintCommand = "flake8 --ignore=E501 --stdin-display-name ${INPUT} -",
--     lintStdin = true,
--     lintFormats = {"%f:%l:%c: %m"}
-- }
local isort = { formatCommand = "isort --quiet -", formatStdin = true }
local yapf = { formatCommand = "yapf --quiet", formatStdin = true }
-- lua
local luaFormat = {
  -- formatCommand = "lua-format -i --no-keep-simple-function-one-line --column-limit=120",
  formatCommand = "stylua --config-path ~/.config/nvim/.stylua -",
  formatStdin = true,
}
-- JavaScript/React/TypeScript
local prettier = {
  formatCommand = "./node_modules/.bin/prettier --stdin-filepath ${INPUT}",
  formatStdin = true,
}

local prettier_global = {
  formatCommand = "prettier --stdin-filepath ${INPUT}",
  formatStdin = true,
}

-- local eslint = {
--     lintCommand = "./node_modules/.bin/eslint -f unix --stdin --stdin-filename ${INPUT}",
--     lintIgnoreExitCode = true,
--     lintStdin = true,
--     lintFormats = {"%f:%l:%c: %m"},
--     formatCommand = "./node_modules/.bin/eslint --fix-to-stdout --stdin --stdin-filename=${INPUT}",
--     formatStdin = true
-- }

local shellcheck = {
  LintCommand = "shellcheck -f gcc -x",
  lintFormats = {
    "%f:%l:%c: %trror: %m",
    "%f:%l:%c: %tarning: %m",
    "%f:%l:%c: %tote: %m",
  },
}

local shfmt = { formatCommand = "shfmt -ci -s -bn", formatStdin = true }

local markdownlint = {
  -- TODO default to global lintrc
  lintCommand = "markdownlint -s -c ~/.config/efm-langserver/markdown.yaml",
  lintStdin = true,
  lintFormats = { "%f:%l %m", "%f:%l:%c %m", "%f: %l: %m" },
}

-- local markdownPandocFormat = {
--   formatCommand = "pandoc -f markdown -t gfm -sp --tab-stop=2",
--   formatStdin = true,
-- }

local root_pattern = util.root_pattern("package.json")

-- lsp-servers --------------------------------------------------------
-----------------------------------------------------------------------

local servers = {
  efm = {
    on_attach = function(client)
      client.resolved_capabilities.rename = false
      client.resolved_capabilities.hover = false
      client.resolved_capabilities.document_formatting = true
      client.resolved_capabilities.completion = false
    end,
    on_init = custom_on_init,
    filetypes = {
      "lua",
      "python",
      "javascriptreact",
      "typescript",
      "javascript",
      "sh",
      "html",
      "css",
      "json",
      "yaml",
      "markdown",
    },

    root_dir = function(fname)
      return root_pattern(fname) or vim.loop.os_homedir()
    end,
    settings = {
      languages = {
        lua = { luaFormat },
        python = { isort, yapf },
        -- javascriptreact = {prettier, eslint},
        -- javascript = {prettier, eslint},
        javascriptreact = { prettier },
        javascript = { prettier_global },
        typescript = { prettier_global },
        sh = { shellcheck, shfmt },
        html = { prettier_global },
        css = { prettier_global },
        json = { prettier_global },
        yaml = { prettier_global },
        markdown = { markdownlint },
      },
    },
  },
  bashls = {},
  cssls = {},
  intelephense = {},
  dockerls = {},
  gopls = {},
  html = {},
  kotlin_language_server = {},
  pyright = {},
  svelte = {
    on_attach = function(client)
      lsp_mappings.lsp_mappings()

      client.server_capabilities.completionProvider.triggerCharacters = {
        ".",
        "\"",
        "'",
        "`",
        "/",
        "@",
        "*",
        "#",
        "$",
        "+",
        "^",
        "(",
        "[",
        "-",
        ":",
      }
    end,
    handlers = {
      ["textDocument/publishDiagnostics"] = is_using_eslint,
    },
    on_init = custom_on_init,
    filetypes = { "svelte" },
    settings = {
      svelte = {
        plugin = {
          html = {
            completions = {
              enable = true,
              emmet = false,
            },
          },
          svelte = {
            completions = {
              enable = true,
              emmet = false,
            },
          },
          css = {
            completions = {
              enable = true,
              emmet = false,
            },
          },
        },
      },
    },
  },
  -- tailwindcss = {}, TODO: check binary lsp for tailwindcss, this not working
  -- denols = {},
  tsserver = {},
  vimls = {},
  sumneko_lua = {
    -- https://github.com/sumneko/lua-language-server/issues/60
    cmd = {
      "/home/mr00x/Downloads/lua-language-server/bin/Linux/lua-language-server",
      "-E",
      "-e",
      "LANG=en",
      "/home/mr00x/Downloads/lua-language-server/main.lua",
    },
    settings = {
      Lua = {
        completion = {
          keywordSnippet = "Disable",
        },
        runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
        diagnostics = {
          globals = {
            "vim",
            "use",
            "imap",
            "nmap",
            "vmap",
            "tmap",
            "inoremap",
            "nnoremap",
            "vnoremap",
            "tnoremap",
          },
        },
        workspace = {
          library = {
            [fn.expand("$VIMRUNTIME/lua")] = true,
            -- [fn.expand("$VIMRUNTIME/lua")] = true,
            [fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
            [fn.expand("~/Downloads/neovim/src/nvim/lua")] = true,
          },
        },
      },
    },
  },

  yamlls = {
    settings = {
      yaml = {
        schemas = {
          ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}",
          ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
          ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
          ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
          ["http://json.schemastore.org/eslintrc"] = ".eslintrc.{yml,yaml}",
          ["http://json.schemastore.org/babelrc"] = ".babelrc.{yml,yaml}",
          ["http://json.schemastore.org/stylelintrc"] = ".stylelintrc.{yml,yaml}",
          ["http://json.schemastore.org/circleciconfig"] = ".circleci/**/*.{yml,yaml}",
          ["https://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
          ["https://json.schemastore.org/cloudbuild"] = "*cloudbuild.{yml,yaml}",
        },
      },
    },
  },

  jsonls = {
    settings = {
      json = {
        schemas = {
          {
            description = "TypeScript compiler configuration file",
            fileMatch = { "tsconfig.json", "tsconfig.*.json" },
            url = "http://json.schemastore.org/tsconfig",
          },
          {
            description = "Lerna config",
            fileMatch = { "lerna.json" },
            url = "http://json.schemastore.org/lerna",
          },
          {
            description = "Babel configuration",
            fileMatch = { ".babelrc.json", ".babelrc", "babel.config.json" },
            url = "http://json.schemastore.org/lerna",
          },
          {
            description = "ESLint config",
            fileMatch = { ".eslintrc.json", ".eslintrc" },
            url = "http://json.schemastore.org/eslintrc",
          },
          {
            description = "Bucklescript config",
            fileMatch = { "bsconfig.json" },
            url = "https://bucklescript.github.io/bucklescript/docson/build-schema.json",
          },
          {
            description = "Prettier config",
            fileMatch = { ".prettierrc", ".prettierrc.json", "prettier.config.json" },
            url = "http://json.schemastore.org/prettierrc",
          },
          {
            description = "Vercel Now config",
            fileMatch = { "now.json", "vercel.json" },
            url = "http://json.schemastore.org/now",
          },
          {
            description = "Stylelint config",
            fileMatch = {
              ".stylelintrc",
              ".stylelintrc.json",
              "stylelint.config.json",
            },
            url = "http://json.schemastore.org/stylelintrc",
          },
        },
      },
    },
  },
}

for server, opts in pairs(servers) do
  local client = lsp[server]
  client.setup({
    cmd = opts.cmd or client.cmd,
    filetypes = opts.filetypes or client.filetypes,
    on_attach = opts.on_attach or custom_on_attach,
    on_init = opts.on_init or custom_on_init,
    handlers = opts.handlers or client.handlers,
    root_dir = client.root_dir or opts.root_dir,
    capabilities = opts.capabilities or custom_capabilities(),
    settings = opts.settings or client.settings,

  })
end
