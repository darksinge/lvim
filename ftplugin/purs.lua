vim.treesitter.language.register('haskell', 'purs')

local group = vim.api.nvim_create_augroup('purescript_augroup', { clear = true })

vim.api.nvim_create_autocmd('BufEnter', {
  group = group,
  pattern = '*.purs',
  callback = function()
  end,
  once = true,
})
local util = require "lspconfig/util"
local purescriptls = require('lspconfig').purescriptls

-- if not purescriptls then
--   return
-- end

local on_attach = require('lvim.lsp').common_on_attach
local on_init = require('lvim.lsp').common_on_init

purescriptls.setup({
  on_attach = on_attach,
  on_init = on_init,
  settings = {
    cmd = { 'purescript-language-server', '--stdio' },
    filetypes = { 'purescript', 'purs' },
    root_dir = util.root_pattern('spago.dhall', 'psc-package.json', 'bower.json', 'flake.nix', 'shell.nix'),
  }
})

local wk_ok, wk = pcall(require, "which-key")
if not wk_ok then
  return
end

local opts = lvim.builtin.which_key.opts

local mappings = {
  ["z"] = {
    name = " logShow",
  },
}

wk.register(mappings, opts)
