return {
  -- OTHER.NVIM
  {
    "rgroli/other.nvim",
    -- enabled = false,
    -- lazy = false, -- Important
    keys = {
      { "<Leader>AA", "<CMD>Other<CR>", desc = "Alternate: edit [other]" },
      { "<Leader>AV", "<Cmd>OtherVSplit`<CR>", desc = "Alternate: vsplit [other]" },
      { "<Leader>AS", "<Cmd>OtherSplit<CR>", desc = "Alternate: split test [other]" },
      { "<Leader>AT", "<Cmd>OtherTabNew<CR>", desc = "Alternate: tab test [other]" },
    },
    config = function()
      require("other-nvim").setup {
        mappings = {
          {
            pattern = "/src/(.*)/(.*).py$",
            target = "/tests/test_%2.py",
            context = "source", -- optional
          },
          {
            pattern = "/tests/(.*).py$",
            target = "/src/*/%1.py",
            context = "tests",
          },
        },
      }
    end,
  },
  -- NVIM-ALTERNATE (disabled)
  {
    "dkendal/nvim-alternate",
    enabled = false,
    lazy = false, -- Important
    keys = {
      { "<Leader>AA", "<Plug>(alternate-edit)", desc = "Alternate: edit [nvim-alternate]" },
      { "<Leader>AV", "<Cmd>AV<CR>", desc = "Alternate: vsplit [nvim-alternate]" },
      { "<Leader>AS", "<Cmd>AS<CR>", desc = "Alternate: split test [nvim-alternate]" },
      { "<Leader>AT", "<Cmd>AT<CR>", desc = "Alternate: tab test [nvim-alternate]" },
    },
    opts = {
      rules = {
        -- Python
        { glob = { "src/*.py", "tests/test_%1.py" } },

        -- Simple pairs (source and test)
        -- { "lua/*.lua", "tests/*_spec.lua" },
        --
        -- -- Example for specific file types
        -- { "src/components/*.tsx", "src/components/*.test.tsx" },
        -- { "src/lib/*.ts", "tests/lib/*.test.ts" },
        --
        -- -- Python
        -- { "src/*/*.py", "tests/test_*.py" },
        --
        -- -- GO
        -- -- { "*.go", "tests/lib/*.test.go" },
        --
        -- -- Custom pairing with advanced matching
        -- { { "*/models/*.rb" }, "(.+)/models/(.+).rb", "%1/spec/models/%2_spec.rb" },
      },
    },
  },
  -- PROJECTIONIST (disabled)
  {
    "tpope/vim-projectionist",
    enabled = false,
    -- event = "LazyFile",
    lazy = false,
    keys = {
      { "<Leader>AA", "<Cmd>A<CR>", desc = "Alternate: edit [projectionist]" },
      { "<Leader>AV", "<Cmd>AV<CR>", desc = "Alternate: vsplit [projectionist]" },
      { "<Leader>AS", "<Cmd>AS<CR>", desc = "Alternate: split test [projectionist]" },
      { "<Leader>AT", "<Cmd>AT<CR>", desc = "Alternate: tab test [projectionist]" },
    },
    config = function()
      vim.g.projectionist_heuristics = {
        -- ["*.py"] = {
        --   ["src/*.py"] = {
        --     alternate = "tests/test_{}.py",
        --     type = "source",
        --   },
        --   ["tests/test_*.py"] = {
        --     alternate = "src/{}.py",
        --     type = "test",
        --   },
        -- },
        ["*"] = {
          -- +------------------------------------------+
          -- GO
          -- +------------------------------------------+
          ["*.go"] = {
            alternate = "{}_test.go",
            type = "source",
            template = {
              "package {basename|camelcase}",
            },
          },
          ["*_test.go"] = {
            alternate = "{}.go",
            type = "test",
            template = {
              "package {basename|camelcase}",
            },
          },
          -- +------------------------------------------+
          -- JS/TSX Configs
          -- +------------------------------------------+
          ["*.cjs"] = {
            alternate = {
              "tsconfig.json",
              "vite.config.ts",
            },
            type = "source",
          },
          ["tsconfig.json"] = {
            alternate = {
              "vite.config.ts",
              ".eslintrc.cjs",
            },
            type = "source",
          },
          ["vite.config.ts"] = {
            alternate = {
              "tailwind.config.cjs",
              ".prettier.cjs",
            },
            type = "source",
          },
          ["tailwind.config.cjs"] = {
            alternate = {
              "package.json",
              ".prettierrc.cjs",
            },
            type = "source",
          },
          ["package.json"] = {
            alternate = {
              ".eslintrc.cjs",
              ".prettierrc.cjs",
            },
            type = "source",
          },
        },
        --  ╒══════════════════════════════════════════════════════════╕
        --  │                          REACT                           │
        --  ╘══════════════════════════════════════════════════════════╛
        ["pyproject.toml"] = {
          ["src/*/*.py"] = {
            alternate = "tests/test_{}.py",
            type = "source",
            template = {},
          },
          ["tests/*.py"] = {
            alternate = "src/{*}/{}.py",
            type = "test",
            template = {},
          },
        },
        -- ["src/"] = {
        -- ["*.py"] = {
        --   alternate = "tests/test_{}.py",
        --   type = "source",
        --   template = {},
        -- },
        -- ["*.tsx"] = {
        --   alternate = "{}.test.tsx",
        --   type = "source",
        --   template = {
        --     "import type React, {open} FC {close} from 'react';",
        --     "",
        --     "type {basename|camelcase|capitalize}Props = {open}",
        --     "  property?: unknown;",
        --     "{close};",
        --     "",
        --     "const {basename|camelcase|capitalize}: FC<{basename|camelcase|capitalize}Props> = _props => {",
        --     "  return <div>{basename|camelcase|capitalize}</div>;",
        --     "};",
        --     "",
        --     "export default {basename|camelcase|capitalize};",
        --   },
        -- },
        -- ["*.test.tsx"] = {
        --   alternate = "{}.tsx",
        --   type = "test",
        --   template = {
        --     "import {open} render {close} from '@/test-utils';",
        --     "import {basename|camelcase|capitalize} from '@/{dirname}/{basename}';",
        --     "",
        --     "describe('{basename|camelcase|capitalize}', () => {open}",
        --     "  it('matches snapshot', () => {open}",
        --     "    const {open} asFragment {close} = render(<{basename|camelcase|capitalize} />, {open}{close});",
        --     "    expect(asFragment()).toMatchSnapshot();",
        --     "   {close});",
        --     "{close});",
        --   },
        -- },
        -- ["*.ts"] = {
        --   alternate = "{}.test.ts",
        --   type = "source",
        -- },
        -- ["*.test.ts"] = {
        --   alternate = "{}.ts",
        --   type = "test",
        --   template = {
        --     "import {basename|camelcase|capitalize} from '@/{dirname}/{basename}';",
        --     "",
        --     "describe('{basename|camelcase|capitalize}', () => {open}",
        --     "  it('works', () => {open}",
        --     "    expect(true).toBe(true);",
        --     "   {close});",
        --     "{close});",
        --   },
        -- },
        -- },
        -- ["src/routes/*"] = {
        --   ["*.svelte"] = {
        --     alternate = { "{}.server.ts", "{}.ts" },
        --     type = "view",
        --   },
        --   ["*.server.ts"] = {
        --     alternate = { "{}.svelte", "{}.ts" },
        --     type = "server",
        --     template = {
        --       "import type { PageServerLoad } from './$types';",
        --       "import { redirect } from '@sveltejs/kit';",
        --       "",
        --       "export const load: PageServerLoad = async ({ url, locals: { getSession } }) => {",
        --       "const session = await getSession();",
        --       "// TODO: hard part's done",
        --       "};",
        --     },
        --   },
        --   ["*.ts"] = {
        --     alternate = { "{}.svelte" },
        --     type = "client",
        --   },
        -- },
        --  ╒══════════════════════════════════════════════════════════╕
        --  │                           DART                           │
        --  ╘══════════════════════════════════════════════════════════╛
        -- ["lib/*.dart"] = {
        --   ["lib/screens/*.dart"] = {
        --     alternate = "lib/view_models/{}_view_model.dart",
        --     type = "view",
        --   },
        --   ["lib/view_models/*_view_model.dart"] = {
        --     alternate = { "lib/screens/{}.dart", "lib/widgets/{}.dart" },
        --     type = "model",
        --     template = { "class {camelcase|capitalize}ViewModel extends BaseViewModel {", "}" },
        --   },
        --   ["test/view_models/*_view_model_test.dart"] = {
        --     alternate = "lib/view_models/{}_view_model.dart",
        --     type = "test",
        --     template = {
        --       "import 'package:test/test.dart';",
        --       "",
        --       "void main() async {",
        --       "  group('TODO', () {",
        --       "    // TODO:",
        --       "  })",
        --       "}",
        --     },
        --   },
        --   ["test/services/*_test.dart"] = {
        --     alternate = "lib/services/{}.dart",
        --     type = "test",
        --     template = {
        --       "import 'package:test/test.dart';",
        --       "",
        --       "void main() async {",
        --       "  group('TODO', () {",
        --       "    // TODO:",
        --       "  })",
        --       "}",
        --     },
        --   },
        --   ["test/widget/*_test.dart"] = {
        --     alternate = "lib/screens/{}.dart",
        --     type = "test",
        --     template = {
        --       "import 'package:test/test.dart';",
        --       "",
        --       "void main() async {",
        --       "  group('TODO', () {",
        --       "    // TODO:",
        --       "  })",
        --       "}",
        --     },
        --   },
        -- },
      }
    end,
  },
}
