local dap_ok, dap = pcall(require, 'dap')
if not dap_ok then
  return
end

require("dap-vscode-js").setup({
  -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
  debugger_path = "/Users/craig.blackburn/.local/share/lunarvim/site/pack/lazy/opt/vscode-js-debug", -- Path to vscode-js-debug installation.
  -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
  adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },       -- which adapters to register in nvim-dap
  -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
  -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
  -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
})

for _, language in ipairs({ "typescript", "javascript" }) do
  dap.configurations[language] = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach",
      processId = require 'dap.utils'.pick_process,
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Debug Vitest Tests",
      -- trace = true, -- include debugger info
      runtimeExecutable = "node",
      runtimeArgs = {
        "./node_modules/.bin/vitest",
        -- "--poolOptions.threads.singleThread=true",
        "--poolOptions.threads.maxThreads=4",
      },
      rootPath = "${workspaceFolder}/test",
      cwd = "${workspaceFolder}",
      console = "integratedTerminal",
      internalConsoleOptions = "neverOpen",

    }
  }
end

-- dap.adapters.node2 = {
--   type = 'executable',
--   command = 'node',
--   args = { '/path/to/node-debug2/out/src/nodeDebug.js' }, -- adjust the path as needed
-- }

-- dap.configurations.javascript = {
--   {
--     type = 'node2',
--     request = 'attach',
--     name = 'Attach to Process',
--     processId = require('dap.utils').pick_process,
--     protocol = 'inspector',
--     port = 9229,
--   },
--   {
--     type = 'node2',
--     request = 'launch',
--     name = 'Launch Program',
--     program = '${file}',
--     cwd = vim.fn.getcwd(),
--     protocol = 'inspector',
--   },
-- }

-- Meh...
-- local dap = require('dap')
-- dap.configurations.sh = {
--   {
--     type = 'sh';
--     request = 'launch';
--     name = 'Launch file';
--     program = '${file}';
--   }
-- }
