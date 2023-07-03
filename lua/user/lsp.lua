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
    -- settings = {
    --   javascript = {
    --     inlayHints = {
    --       includeInlayEnumMemberValueHints = true,
    --       includeInlayFunctionLikeReturnTypeHints = true,
    --       includeInlayFunctionParameterTypeHints = true,
    --       includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
    --       includeInlayParameterNameHintsWhenArgumentMatchesName = true,
    --       includeInlayPropertyDeclarationTypeHints = true,
    --       includeInlayVariableTypeHints = true,
    --     },
    --   },
    --   typescript = {
    --     inlayHints = {
    --       includeInlayEnumMemberValueHints = true,
    --       includeInlayFunctionLikeReturnTypeHints = true,
    --       includeInlayFunctionParameterTypeHints = true,
    --       includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
    --       includeInlayParameterNameHintsWhenArgumentMatchesName = true,
    --       includeInlayPropertyDeclarationTypeHints = true,
    --       includeInlayVariableTypeHints = true,
    --     },
    --   },
    -- },
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
    filetypes = { "javascript", "typescript", "typescriptreact", "json" }
  },
})

vim.diagnostic.config({
  float = {
    max_width = 120,
    focusable = true,
  }
})

lvim.builtin.cmp.formatting.source_names["copilot"] = "(Copilot)"
table.insert(lvim.builtin.cmp.sources, 1, { name = "copilot" })
