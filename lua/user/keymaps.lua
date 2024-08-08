lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
vim.keymap.set('n', 'gn', ":tabe %<CR>")

lvim.lsp.buffer_mappings.normal_mode["gr"] = {
  ":lua require'telescope.builtin'.lsp_references()<cr>",
  lvim.icons.kind.Reference .. " Find references"
}

lvim.lsp.buffer_mappings.normal_mode["gd"] = {
  -- ":lua vim.lsp.buf.definition()<cr>",
  ":lua require'telescope.builtin'.lsp_definitions({ preview = true })<cr>",
  lvim.icons.kind.Reference .. " Definitions"
}

-- lvim.lsp.buffer_mappings.normal_mode["gk"] = {
--   ":lua vim.lsp.buf.type_definition()<cr>",
--   lvim.icons.kind.Reference .. " Type Definition"
-- }
vim.keymap.set('n', 'gk', function()
  local gp_ok, gp = pcall(require, 'goto-preview')
  if gp_ok then
    gp.goto_preview_type_definition()
  else
    vim.lsp.buf.type_definition()
  end
end)

-- lvim.lsp.buffer_mappings.normal_mode["gf"] = {
--   ":Telescope frecency<cr>",
--   lvim.icons.kind.Reference .. " Telescope Frecency"
-- }

-- local has_noice, _ = pcall(require, 'noice')
-- if has_noice then
--   lvim.keys.normal_mode['<C-m>'] = ":Noice<cr>"
-- else
--   vim.notify('folke/noice.nvim is not installed but you have a keymap set for it', vim.log.levels.WARN)
--   lvim.keys.normal_mode['<C-m>'] = ":messages<cr>"
-- end
lvim.keys.normal_mode['<C-m>'] = ":messages<cr>"

lvim.keys.normal_mode['<leader>.'] = ":luafile %<cr>"

lvim.keys.normal_mode['<leader>-'] = "<cmd>lua require('persistence').load()<cr>"

vim.keymap.set({ 'o', 'x' }, "a'", "2i'")
vim.keymap.set({ 'o', 'x' }, 'a"', '2i"')

local tnav_ok, tnav = pcall(require, "nvim-tmux-navigation")
if tnav_ok then
  vim.keymap.set("n", "<C-h>", tnav.NvimTmuxNavigateLeft, { silent = true })
  vim.keymap.set("n", "<C-j>", tnav.NvimTmuxNavigateDown, { silent = true })
  vim.keymap.set("n", "<C-k>", tnav.NvimTmuxNavigateUp, { silent = true })
  vim.keymap.set("n", "<C-l>", tnav.NvimTmuxNavigateRight, { silent = true })
end
