-- local has_neoconf, neoconf = pcall(require, 'neoconf')
-- if has_neoconf then
--   neoconf.setup()
-- end

-- Configure tsserver server manually.
-- Requires `:LvimCacheReset` to take effect
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "tsserver" })

lvim.lsp.on_attach_callback = function(client, bufnr)
  local light = vim.o.background == 'light'
  -- change coloring of errors so I can actually read them with gruvbox
  -- if lvim.colorscheme == 'gruvbox' then
  --   if light then
  --     vim.cmd(':hi DiagnosticError guifg=#de5b64 guibg=#Black')
  --     vim.cmd(':hi DiagnosticWarn guifg=darkred guibg=tan')
  --     vim.cmd(':hi DiagnosticInfo guifg=blue ctermfg=blue')
  --     vim.cmd(':hi DiagnosticHint guifg=lightblue guibg=#3a3a3a')
  --   else
  --     vim.cmd(':hi DiagnosticError guifg=#de5b64 guibg=#White')
  --     vim.cmd(':hi DiagnosticWarn guifg=DarkOrange ctermfg=DarkYellow')
  --     vim.cmd(':hi DiagnosticInfo guifg=Cyan ctermfg=Cyan')
  --     vim.cmd(':hi DiagnosticHint guifg=White ctermfg=White')
  --   end
  -- end

  -- if client.name == 'tsserver' then
  --   local hints_ok, hints = pcall(require, 'lsp-inlayhints')
  --   if hints_ok then
  --     hints.on_attach(client, bufnr)
  --   end
  -- end

  if client.name == 'purescriptls' then
    P(client)
  end
end


-- Typescript config using typescript.nvim
local capabilities = require('lvim.lsp').common_capabilities()
local on_attach = require('lvim.lsp').common_on_attach
local on_init = require('lvim.lsp').common_on_init

require('typescript').setup({
  server = {
    root_dir = require('lspconfig.util').root_pattern('.git'),
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
    settings = {
      javascript = {
        inlayHints = {
          includeInlayEnumMemberValueHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayVariableTypeHints = true,
        },
      },
      typescript = {
        inlayHints = {
          includeInlayEnumMemberValueHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayVariableTypeHints = true,
        },
      },
    },
  },
})

-- -- Keeping this here for reference
-- require("lvim.lsp.manager").setup("tsserver", {
--   root_dir = require('lspconfig.util').root_pattern('.git'),
--   on_attach = function(client, bufnr)
--     hints.on_attach(client, bufnr)
--     on_attach(client, bufnr)
--   end,
--   on_init = on_init,
--   capabilities = capabilities,
--   filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript" },
--   cmd = {
--     "typescript-language-server",
--     "--stdio",
--   },
--   settings = {
--     javascript = {
--       inlayHints = {
--         includeInlayEnumMemberValueHints = true,
--         includeInlayFunctionLikeReturnTypeHints = true,
--         includeInlayFunctionParameterTypeHints = true,
--         includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
--         includeInlayParameterNameHintsWhenArgumentMatchesName = true,
--         includeInlayPropertyDeclarationTypeHints = true,
--         includeInlayVariableTypeHints = true,
--       },
--     },
--     typescript = {
--       inlayHints = {
--         includeInlayEnumMemberValueHints = true,
--         includeInlayFunctionLikeReturnTypeHints = true,
--         includeInlayFunctionParameterTypeHints = true,
--         includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
--         includeInlayParameterNameHintsWhenArgumentMatchesName = true,
--         includeInlayPropertyDeclarationTypeHints = true,
--         includeInlayVariableTypeHints = true,
--       },
--     },
--   },
-- })

-- formatters
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup({
  {
    command = "prettierd",
    -- command = "prettier",
    filetypes = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "vue",
      "css",
      "scss",
      "less",
      "html",
      "yaml",
      "markdown",
      "markdown.mdx",
      "graphql",
      "handlebars",
      "json",
    }
  },
  -- {
  --   command = ""
  -- }
})

-- linters
local linters = require "lvim.lsp.null-ls.linters"
linters.setup({
  {
    command = "eslint_d",
    -- command = "eslint",
    filetypes = { "javascript", "typescript", "typescriptreact", "json" },
  },
})

vim.diagnostic.config({
  float = {
    max_width = 120,
    focusable = true,
  }
})

lvim.builtin.cmp.formatting.source_names["copilot"] = "(Copilot)"

-- for _, source in ipairs(lvim.builtin.cmp.sources) do
--   if source.name == 'nvim_lsp' then
--     source.group_index = 1
--   elseif source.name == 'copilot' then
--     source.group_index = 2
--   else
--     source.group_index = 3
--   end
-- end

-- table.insert(lvim.builtin.cmp.sources, #lvim.builtin.cmp.sources + 1, { name = "copilot", group_index = 3 })

local null_ls = require("null-ls")
null_ls.register({
  method = null_ls.methods.CODE_ACTION,
  filetypes = { 'javascript', 'typescript', 'typescriptreact', 'lua' },
  generator = {
    fn = function(params)
      -- -- example of `params.lsp_params`
      -- {
      --   client_id = 2,
      --   context = {
      --     diagnostics = {},
      --     triggerKind = 1
      --   },
      --   method = "textDocument/codeAction",
      --   range = {
      --     ["end"] = <1>{
      --       character = 30,
      --       line = 272
      --     },
      --     start = <table 1>
      --   },
      --   textDocument = {
      --     uri = "file:///Users/craig.blackburn/projects/ys/CRT-3350-refactor-taxonomies-service/test/services/taxonomy.service.v2/taxonomy.service.v2.test.ts"
      --   }
      -- }

      -- -- example diagnostic object for eslint
      -- {
      --   bufnr = 9,
      --   code = "@typescript-eslint/no-unused-vars",
      --   col = 2,
      --   end_col = 35,
      --   end_lnum = 4,
      --   end_row = 5,
      --   lnum = 4,
      --   message = "'createRootNodeWithSiblingFromGrid' is defined but never used. Allowed unused vars must match /^_+$/u.",
      --   namespace = 50,
      --   row = 5,
      --   severity = 2,
      --   source = "eslint_d",
      --   user_data = {
      --     fixable = false
      --   }
      -- }

      local actions = {}

      local start_line = nil
      if params.lsp_params and params.lsp_params.range and params.lsp_params.range.start then
        start_line = params.lsp_params.range.start.line
      end


      -- -- NOTE: This used to work... then suddenly it didn't ¯\_(ツ)_/¯
      -- if not (params and params.lsp_params and params.lsp_params.context and params.lsp_params.context.diagnostics) then
      --   return actions
      -- end
      -- local diagnostics = params.lsp_params.context.diagnostics

      ---@type table<string, boolean>
      local seen = {}

      -- As noted above, I used to get diagnostics from
      -- `params.lsp_params.context.diagnostics`. I switched to using
      -- `vim.diagnotic.get` and it works using this method.
      local diagnostics = vim.diagnostic.get(params.bufnr)
      if #diagnostics == 0 then
        return actions
      end

      for _, diagnostic in ipairs(diagnostics) do
        if diagnostic.source == 'eslint' or diagnostic.source == 'eslint_d' then
          local code = diagnostic.code
          if code == nil or seen[code] or diagnostic.lnum ~= start_line then
            goto continue
          else
            seen[code] = true
          end

          table.insert(actions, {
            title = "Disable '" .. code .. "' for line " .. diagnostic.lnum,
            action = function()
              ---@type {character: number; line: number}
              -- print('diagnostic' .. vim.inspect(diagnostic))

              -- local start = diagnostic.range.start
              local start_lnum = diagnostic.lnum

              -- --@type {character: number; line: number}
              -- local end_ = diagnostic.range['end']
              local end_lnum = diagnostic.end_lnum or start_lnum + 1

              local indent = vim.fn.indent(start_lnum + 1)
              local whitespace = string.rep(' ', indent)
              local lines = { whitespace .. '// eslint-disable-next-line ' .. code }
              for _, line in ipairs(vim.api.nvim_buf_get_lines(params.bufnr, start_lnum, end_lnum, false)) do
                table.insert(lines, line)
              end

              vim.api.nvim_buf_set_lines(params.bufnr, start_lnum, end_lnum, false, lines)
            end
          })

          table.insert(actions, {
            title = "Disable '" .. code .. "' for entire file: " .. code,
            action = function()
              local lines = vim.api.nvim_buf_get_lines(params.bufnr, 0, 1, false) or ''

              local top = lines[1]
              local match = top:match('^/%*%s+eslint%-disable%s+([^%s]+)%s+%*/')
              if match then
                lines[1] = '/* eslint-disable ' .. match .. ',' .. code .. ' */'
              else
                table.insert(lines, 1, '/* eslint-disable ' .. code .. ' */')
              end

              vim.api.nvim_buf_set_lines(params.bufnr, 0, 1, false, lines)
            end
          })
          ::continue::
        end
      end

      return actions
    end,
  },
})
