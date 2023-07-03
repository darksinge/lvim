local convert_schemas = reload('refactor.lib.convert_schemas')
local convert_paths = reload('refactor.lib.convert_paths')

local M = {}

M.setup = function()
  -- vim.keymap.set('n', '<leader>,', ':lua require"refactor".convert()<cr>')
  -- vim.keymap.set('n', '<leader>,,', ':luafile scripts/js-commenter/init.lua<cr>')
  vim.keymap.set('n', 'zl', 'yiwop(<esc>pa)<esc>')
  vim.keymap.set('n', 'zt', 'yiwot(<esc>pa)<esc>')
  vim.keymap.set('n', 'zs', "yiwop('<esc>pa: ' .. <esc>pa)<esc>")
end

M.convert_schemas = function()
  convert_schemas.run()
end

M.convert_paths = function()
  convert_paths.run()
end

return M
