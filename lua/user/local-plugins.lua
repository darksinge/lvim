-- -- configure custom plugins

-- local plugin_dir = vim.fn.environ().HOME .. '/.config/lvim/local/lua'
-- local package_names = {
--   'vitest_utils'
-- }

-- local plugin_loader = function(module)
--   local plugin_path = string.gsub(module, "%.", "/")

--   local paths = {}
--   for _, package_name in ipairs(package_names) do
--     table.insert(paths, plugin_dir .. '/' .. package_name .. '.lua')
--     table.insert(paths, plugin_dir .. '/' .. package_name .. '/init.lua')
--   end

--   for _, path in ipairs(paths) do
--     local file = io.open(path, 'r')
--     if file then
--       io.close(file)
--       return loadfile(path)
--     end
--   end
--   return nil
-- end

-- table.insert(package.searchers or package.loaders, plugin_loader)

-- reload('vitest_utils').setup()
require('user.vitest-utils').setup()
