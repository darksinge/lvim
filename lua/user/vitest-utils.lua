local Job = require('plenary.job')
local p = require('plenary.path')
local Log = require('plenary.log')

local get_level = function()
  local level = vim.fn.getenv('LOG_LEVEL')
  if level == vim.NIL then
    return 'debug'
  end
  return level
end

local log = Log.new({
  plugin = 'vitest-utils',
  level = get_level(),
})

local M = {}

local function find_line_number(file, search_text)
  if not file:is_file() then
    return nil
  end

  local line_number = 0
  for line in io.open(file.filename, 'r'):lines() do
    line_number = line_number + 1
    if line:find(search_text, 1, true) then
      return line_number
    end
  end
  return nil
end

--TODO: Clean up this mess of a function
local function create_qflist(lines, root_dir, logger)
  local root = p:new(root_dir)
  local failed_count = 0
  local qflist = {}
  for i, line in ipairs(lines) do
    local file = string.match(line, '❯%s+(.+)%s+%(%d+ tests? %| %d+ failed%)')
    if file then
      file = file:gsub('%s$', '')
      file = root:joinpath(file)
      if not file:is_file() then
        logger("skipping matched file as it doesn't appear to exist: " .. file.filename)
        goto continue
      end
      failed_count = failed_count + 1
      local test_patterns = {}
      for token in string.gmatch(lines[i + 1], '[^>]+') do
        table.insert(test_patterns, token)
      end
      local test_pattern = test_patterns[#test_patterns]
      test_pattern = test_pattern:gsub("^%s*(.-)%s*$", "%1")
      logger('file: ' .. file.filename)
      logger('test_pattern: ' .. test_pattern)
      local lnum = find_line_number(file, test_pattern)
      if not lnum then
        logger('could not find line number for test: ' .. test_pattern)
      end
      local text = lines[i + 2] or line
      table.insert(qflist, { filename = file.filename, lnum = lnum, text = text })
    end
    ::continue::
  end

  if #qflist > 0 then
    vim.fn.setqflist(qflist)
    vim.cmd('copen')
  end
end

---@param opts {root: string|nil, file: string|nil, debug: boolean|nil}|nil
M.run = function(opts)
  opts = opts or {}
  local root = p:new(opts.root)
  assert(root:is_dir(), 'root is not a directory')

  local logger = opts.debug and log.debug or log.trace

  if debug then
    logger('options = ' .. vim.inspect(opts))
  end

  local args = {
    'vitest',
    'run',
    '--no-color',
    -- 'test/libs/token.test.ts',
  }

  if type(opts.file) == 'string' then
    table.insert(args, opts.file)
  end

  logger('running tests...')
  local lines = {}
  Job:new({
    cwd = root:absolute(),
    command = 'npx',
    args = args,
    detached = true,
    on_stdout = function(_, line)
      logger(line or '')
      table.insert(lines, line)
    end,
    on_exit = function()
      logger('done')
      vim.schedule(function()
        create_qflist(lines, root, logger)
      end)
    end
  }):start()
end

function M.setup()
  lvim.keys.normal_mode['<leader>,'] = ":lua require('user.vitest-utils').run()<cr>"
end

return M
