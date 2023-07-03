vim.treesitter.language.register('haskell', 'purs')

local group = vim.api.nvim_create_augroup('purescript_augroup', { clear = true })

vim.api.nvim_create_autocmd('BufEnter', {
  group = group,
  pattern = '*.purs',
  callback = function()
    -- I can't get this to work for the life of me...
    print('entering purescript file')

    local util = require "lspconfig/util"
    local purescriptls = require('lspconfig').purescriptls

    if not purescriptls then
      return
    end

    local on_attach = require('lvim.lsp').common_on_attach
    local on_init = require('lvim.lsp').common_on_init

    purescriptls.setup({
      cmd = { 'purescript-language-server', '--stdio' },
      filetypes = { 'purescript', 'purs' },
      on_attach = on_attach,
      on_init = on_init,
      root_dir = util.root_pattern('spago.dhall', 'psc-package.json', 'bower.json', 'flake.nix', 'shell.nix'),
    })
  end,
})
