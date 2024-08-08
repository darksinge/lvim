local Job = require('plenary.job')

local M = {}

local function create_qflist(lines)
  local failed_count = 0
  local qflist = {}
  for _, line in ipairs(lines) do
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

M.run = function(workspace)
  print('checking project...')

  local args = { '--noEmit' }
  if workspace then
    table.insert(args, '-p')
    table.insert(args, workspace)
  end

  local lines = {}
  Job:new({
    command = 'tsc',
    args = args,
    detached = true,
    on_stdout = function(_, line)
      table.insert(lines, line)
    end,
    on_exit = function()
      local message = 'done checking project'
      if workspace then
        message = message .. ' in workspace ' .. workspace
      end
      print(message)
      vim.schedule(function() create_qflist(lines) end)
    end
  }):start()
end


---@param opts { mappings: table<string, table> } | nil
M.setup = function(opts)
  opts = opts or {}
  if not opts.mappings then
    opts.mappings = {
      u = {
        name = 'Utils',
        t = { ":lua require('user.typecheck-ts').run()<cr>", " Typescript Typecheck" }
      }
    }
  end

  vim.api.nvim_create_user_command('TSTypecheck', function(command)
    local ws = nil
    if #command.args ~= 0 then
      ws = vim.fn.split(command.args, ' ')[1]
    end
    require('user.typecheck-ts').run(ws)
  end, { force = true, nargs = '*', bang = true })

  local wk = lvim.builtin.which_key
  for mapping, tbl in pairs(opts.mappings) do
    if wk.mappings[mapping] == nil then
      wk.mappings[mapping] = {}
    end

    for k, v in pairs(tbl) do
      wk.mappings[mapping][k] = v
    end
  end

  -- lvim.keys.normal_mode['<leader>t'] = ":lua require('user.typecheck-ts').run()<cr>"
end

return M
