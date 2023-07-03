local Job = require('plenary.job')

local M = {}

local function find_line_number(filename, search_text)
  local line_number = 0
  for line in io.open(filename, 'r'):lines() do
    line_number = line_number + 1
    if line:find(search_text, 1, true) then
      return line_number
    end
  end
  return nil -- Text not found in the file
end

local function create_qflist(lines)
  local failed_count = 0
  local qflist = {}
  for i, line in ipairs(lines) do
    local file = string.match(line, '❯%s+(.+)%s+%(%d+ tests? %| %d+ failed%)')
    if file then
      file = file:gsub('%s$', '')
      failed_count = failed_count + 1
      local test_patterns = {}
      for token in string.gmatch(lines[i + 1], '[^>]+') do
        table.insert(test_patterns, token)
      end
      local test_pattern = test_patterns[#test_patterns]
      test_pattern = test_pattern:gsub("^%s*(.-)%s*$", "%1")
      local lnum = find_line_number(file, test_pattern)
      local text = lines[i + 2] or line
      table.insert(qflist, { filename = file, lnum = lnum, text = text })
    end
  end

  if #qflist > 0 then
    vim.fn.setqflist(qflist)
    vim.cmd('copen')
  end
end

M.run = function()
  print('running tests...')
  local lines = {}
  Job:new({
    command = 'npx',
    args = { 'vitest', 'run', '--no-color', 'api/test/libs/token.test.ts' },
    detached = true,
    on_stdout = function(_, line)
      print(line)
      table.insert(lines, line)
    end,
    on_exit = function()
      print('done')
      vim.schedule(function()
        create_qflist(lines)
      end)
    end
  }):start()
end

M.setup = function()
  lvim.keys.normal_mode['<leader>,'] = ":lua require('vitest-utils').run()<cr>"
end

return M
