local ok, flash = pcall(require, 'flash')
if not ok then
  return
end

local opts = { silent = true, noremap = true }
local keymap = vim.keymap

keymap.set({ 'n', 'o', 'x' }, 's', flash.jump, opts)
keymap.set({ 'n', 'o', 'x' }, 'S', flash.treesitter, opts)
keymap.set('o', 'r', flash.remote, opts)
keymap.set({ 'o', 'x' }, 'R', flash.treesitter_search, opts)
keymap.set({ 'c' }, '<c-s>', flash.toggle, opts)

keymap.set('n', 'f', function()
  flash.jump({
    search = {
      forward = true,
      wrap = false,
      multi_window = false,
    }
  })
end, opts)

keymap.set('n', 'F', function()
  flash.jump({
    search = {
      forward = false,
      wrap = false,
      multi_window = false,
    }
  })
end, opts)

vim.keymap.set('n', '<LocalLeader>s', function() print('jfkldjkfld') end, opts)
