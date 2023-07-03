local Job = require('plenary.job')

local M = {}

local function create_qflist(lines)
  local failed_count = 0
  local qflist = {}
  for _, line in ipairs(lines) do
    -- line: ```  Object literal may only specify known properties, and 'removeEmployerRequestParams' does not exist in type 'AdminApiDeleteEmployerRequest'.```
    -- line: ```src/pages/IncompleteCompanies/components/Toolbar/FilterByState/FilterByStateSelect.tsx(28,51): error TS2554: Expected 1-2 arguments, but got 0.```
    -- line: ```src/pages/IncompleteEmployerDetails/IncompleteEmployerDetails.tsx(34,9): error TS2345: Argument of type '{ id: string; removeEmployerRequestParams: { notifyByEmail: boolean; }; }' is not assignable to parameter of type
    -- local file, lnum, col = string.match(line, '^([%a%d%p/]+%.tsx?)%((%d+),(%d+)%)')
    local file, lnum, col, text = string.match(line, '^([%a%d%p/]+%.tsx?)%((%d+),(%d+)%): (.*)$')
    if file then
      failed_count = failed_count + 1
      -- local text = lines[i + 2] or line
      table.insert(qflist, { filename = file, lnum = lnum, col = col, text = text })
    end
  end

  if #qflist > 0 then
    vim.fn.setqflist(qflist)
    vim.cmd('copen')
  end
end

-- src/pages/ReviewEmployerDetails/ReviewEmployerDetails.tsx:64:9 - error TS2345: Argument of type '{ id: string; removeEmployerRequestParams: { notifyByEmail: boolean; }; }' is not assignable to parameter of type 'AdminApiDeleteEmployerRequest'.
--   Object literal may only specify known properties, and 'removeEmployerRequestParams' does not exist in type 'AdminApiDeleteEmployerRequest'.

M.run = function()
  print('checking project...')
  local lines = {}
  Job:new({
    command = 'npx',
    args = { 'tsc', '--noEmit' },
    detached = true,
    on_stdout = function(_, line)
      table.insert(lines, line)
    end,
    on_exit = function()
      print('done')
      vim.schedule(function() create_qflist(lines) end)
    end
  }):start()
end

M.setup = function()
  lvim.keys.normal_mode['<leader>,'] = ":lua require('user.typecheck-ts').run()<cr>"
end

M.run()

return M
