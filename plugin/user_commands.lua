local _ = require('neodash')

vim.api.nvim_create_user_command('Vitest', function(command)
  local args = command.fargs
  local cmd = args[1]
  if #args == 0 or cmd == 'run' then
    local path = args[2] or nil
    if path == '%' then
      path = vim.fn.expand(path)
    end

    local debug = args[3] == 'true' and true or false

    return require('user.vitest-utils').run({ cwd = vim.uv.cwd(), root = path, debug = true })
  end
  error('Invalid argument: ' .. vim.inspect(command.args) or 'nil')
end, { force = true, nargs = '+', bang = true })

vim.api.nvim_create_user_command('TSTypecheck', function(command)
  require('user.typecheck-ts').run()
end, { force = true })
