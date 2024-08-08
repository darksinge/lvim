local Job = require('plenary.job')
local Path = require('plenary.path')

local M = {}

---@param lines string[]
---@return {filename: string; lnum: number; col: number; text: number}[]
local function parse_lines(lines)
  local failed_count = 0
  local qflist = {}
  local file = nil
  for _, line in ipairs(lines) do
    local path = Path:new(line)
    if path:exists() then
      file = line
    else
      local lnum, col, level, text = line:match('^%s+(%d+):(%d+)%s+(%w+)(%s+.*)$')
      if file and lnum and col and level and text then
        if level == 'error' then
          failed_count = failed_count + 1
          table.insert(qflist, { filename = file, lnum = lnum, col = col, text = level .. text })
        end
      end
    end
  end

  return qflist
end

---@param lines string[]
local function create_qflist(lines)
  local qflist = parse_lines(lines)
  if #qflist > 0 then
    vim.fn.setqflist(qflist)
    vim.cmd('copen')
  end
end

---@param dir string | nil
M.run = function(dir)
  local args = { 'eslint', '.' }
  if dir then
    args[2] = dir
  end

  print('running linter...')
  local lines = {}
  Job:new({
    command = 'npx',
    args = args,
    detached = true,
    on_stdout = function(_, line)
      table.insert(lines, line)
    end,
    on_exit = function()
      local message = 'done linting project'
      if dir then
        message = message .. ' in directory ' .. dir
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
        e = { ":lua require('user.eslint-checker').run()<cr>", " ESLint" }
      }
    }
  end

  vim.api.nvim_create_user_command('ESLintCheck', function(command)
    -- local ws
    -- if #command.args ~= 0 then
    --   ws = vim.fn.split(command.args, ' ')[1]
    -- end
    -- require('user.eslint-checker').run(ws)
    require('user.eslint-checker').run(command)
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

  -- lvim.keys.normal_mode['<leader>E'] = ":lua require('user.typecheck-ts').run()<cr>"
end

return M
