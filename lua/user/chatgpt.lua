local ok, chatgpt = pcall(require, 'chatgpt')
-- if not ok then
--   return
-- end

local wk = require('which-key')

wk.register({
  ["G"] = {
    name = 'ChatGPT',
    G = { ':ChatGPT<CR>', 'Open ChatGPT Window' }
  }
}, {
  mode = 'n',
  prefix = '<leader>'
})
