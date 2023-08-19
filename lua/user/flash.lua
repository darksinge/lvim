local ok, Flash = pcall(require, 'flash')
if not ok then
  return
end

Flash.setup()

-- This doesn't turn off flash, it only disables it during regular search
Flash.toggle(false)

local opts = { silent = true, noremap = true }

vim.keymap.set({ 'n', 'o', 'x' }, 's', Flash.jump, opts)
vim.keymap.set('n', '<LocalLeader>s', Flash.treesitter, opts)
vim.keymap.set('o', 'r', Flash.remote, opts)
vim.keymap.set({ 'o', 'x' }, '<localleader>r', Flash.treesitter_search, opts)
vim.keymap.set({ 'c' }, '<c-s>', Flash.toggle, opts)
vim.keymap.set('n', 'f', function()
  Flash.jump({
    search = {
      forward = true,
      wrap = false,
      multi_window = false,
    }
  })
end, opts)
vim.keymap.set('n', 'F', function()
  Flash.jump({
    search = {
      forward = false,
      wrap = false,
      multi_window = false,
    }
  })
end, opts)
