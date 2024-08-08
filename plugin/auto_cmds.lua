local Path = require('plenary.path')

-- TODO: It would be awesome to make a prompt popup to ask if it should
-- load the session
-- local persistence_ok, persistence = pcall(require, 'persistence')
-- if persistence_ok then
--   vim.api.nvim_create_autocmd('VimEnter', {
--     once = true,
--     callback = function()
--       vim.schedule(function()
--         persistence.load()
--       end)
--     end,
--   })
-- end

---@param fpath Path | nil
local function is_node_module(fpath)
  if fpath == nil then
    return false
  end

  if fpath.filename:match('node_modules/') then
    return true
  end
end

-- local buf_request_definition = function()
--   local positional_params = vim.lsp.util.make_position_params()
--   vim.lsp.buf_request_all(0, 'textDocument/definition', positional_params, function(results)
--     for _, responses in ipairs(results) do
--       for _, res in ipairs(responses.result) do
--         local uri = res.targetUri
--         local range = res.targetRange
--         local start = range.start
--         local fname = vim.uri_to_fname(uri)
--         local path = Path:new(fname)
--         if not path:is_file() then
--           return
--         end

--         print(path.filename)
--         print(path.filename)
--         print(path.filename)
--         if path.filename:match('node_modules/') then
--           require('goto-preview').goto_preview_definition()
--           return
--         end
--       end
--     end
--     vim.lsp.buf.definition()
--   end)
-- end

-- local gp_ok, gp = pcall(require, 'goto-preview')
-- if gp_ok then
--   vim.api.nvim_create_autocmd('BufEnter', {
--     pattern = '*.ts',
--     callback = function()
--       vim.keymap.set('n', 'gd', buf_request_definition, { silent = true, noremap = true, buffer = true })
--       vim.keymap.set('n', 'gc', gp.close_all_win, { silent = true, noremap = true, buffer = true })
--     end
--   })
-- end
