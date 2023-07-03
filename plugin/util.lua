function P(value)
  return print(vim.inspect(value))
end

function ReloadModule(...)
  return require('plenary.reload').reload_module(...)
end

function R(name)
  ReloadModule(name)
  return require(name)
end

function Dump(input)
  vim.cmd("put =execute('" .. input.args .. "')")
end
