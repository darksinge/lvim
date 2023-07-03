vim.api.nvim_create_autocmd("FileType", {
  pattern = { "zsh" },
  callback = function()
    -- let treesitter use bash highlight for zsh files as well
    require("nvim-treesitter.highlight").attach(0, "bash")
  end,
})

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "cjs", "mjs" },
--   callback = function()
--     require("nvim-treesitter.highlight").attach(0, "javascript")
--   end,
-- })


vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { ".config/lvim/config.lua" },
  command = "PackerCompile",
})

-- local group = vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
-- vim.api.nvim_create_autocmd("LspAttach", {
--   group = "LspAttach_inlayhints",
--   callback = function(args)
--     if not (args.data and args.data.client_id) then
--       return
--     end

--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     require("lsp-inlayhints").on_attach(client, args.buf)
--   end,
-- })
