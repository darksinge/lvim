local Popup = require('nui.popup')
local Path = require('plenary.path')
local _ = require('neodash')

local function open(filename, lnum, col)
  print('filename:' .. vim.inspect(filename))
  local bufnr = vim.api.nvim_create_buf(false, true)

  local popup = Popup({
    bufnr = bufnr,
    position = "50%",
    size = {
      width = 80,
      height = 40,
    },
    enter = true,
    focusable = true,
    zindex = 50,
    relative = "editor",
    border = {
      padding = {
        top = 2,
        bottom = 2,
        left = 3,
        right = 3,
      },
      style = "rounded",
      text = {
        top = " I am top title ",
        top_align = "center",
        bottom = "I am bottom title",
        bottom_align = "left",
      },
    },
    buf_options = {
      modifiable = true,
      readonly = false,
    },
    win_options = {
      winblend = 10,
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
    },
  })

  assert(popup.bufnr == bufnr)
  popup:mount()

  if true then return end
  vim.schedule(function()
    local winid = vim.api.nvim_get_current_win()
    -- local name = vim.api.nvim_buf_get_name(bufnr)
    -- print('name:' .. vim.inspect(name))
    vim.api.nvim_set_current_buf(bufnr)
    vim.bo[bufnr].buftype = 'nowrite'
    vim.api.nvim_buf_set_option(bufnr, 'modifiable', true)

    local file_path = vim.api.nvim_get_runtime_file(filename, false)[1]
    -- print('filename:' .. vim.inspect(filename))
    -- print('file_path:' .. vim.inspect(file_path))
    vim.api.nvim_command("$read " .. file_path)
    -- vim.api.nvim_buf_set_option(0, 'modifiable', true)

    vim.api.nvim_win_set_cursor(winid, { lnum - 1, col })
  end)
end

vim.keymap.set('n', '<leader>d', function()
  -- local positional_params = vim.lsp.util.make_position_params()
  local positional_params = {
    position = {
      character = 25,
      line = 1
    },
    textDocument = {
      uri = "file:///Users/craig.blackburn/.config/lvim/plugin/goto-def-improved.lua"
    }
  }
  vim.lsp.buf_request_all(0, 'textDocument/definition', positional_params, function(results)
    local responses = results[1]
    if results then return end
    for _, inner in ipairs(responses) do
      for _, v in ipairs(inner.result) do
        local uri = v.targetUri
        local range = v.targetRange
        local start = range.start
        local fname = vim.uri_to_fname(uri)
        local file = Path:new(fname)
        if file:is_file() then
          open(file:make_relative(), start.line, start.character)
        end
        return
      end
    end


    -- { {
    --     originSelectionRange = {
    --       ["end"] = {
    --         character = 25,
    --         line = 71
    --       },
    --       start = {
    --         character = 10,
    --         line = 71
    --       }
    --     },
    --     targetRange = {
    --       ["end"] = {
    --         character = 28,
    --         line = 2001
    --       },
    --       start = {
    --         character = 13,
    --         line = 2001
    --       }
    --     },
    --     targetSelectionRange = {
    --       ["end"] = {
    --         character = 28,
    --         line = 2001
    --       },
    --       start = {
    --         character = 13,
    --         line = 2001
    --       }
    --     },
    --     targetUri = "file:///Users/craig.blackburn/.local/opt/nvim-0.9/share/nvim/runtime/lua/vim/lsp.lua"
    --   } }

    -- if err then
    --   return print('Error: ', err)
    -- end

    -- if result == nil or vim.tbl_isempty(result) then
    --   return print('No definition found')
    -- end
    -- -- {
    -- --   bufnr = 39,
    -- --   client_id = 1,
    -- --   method = "textDocument/definition",
    -- --   params = {
    -- --     position = {
    -- --       character = 4,
    -- --       line = 3
    -- --     },
    -- --     textDocument = {
    -- --       uri = "file:///Users/craig.blackburn/.config/lvim/plugin/keymaps.lua"
    -- --     }
    -- --   }
    -- -- }
    -- local bufnr = result.bufnr
    -- local params = result.params
    -- local pos = params.position
    -- local uri = params.textDocument.uri
    -- local lnum = pos.line
    -- local col = pos.character
    -- print('(' .. lnum .. ',' .. col .. ')')

    -- local fname = vim.uri_to_fname(uri)
    -- local file = Path.new(fname)
    -- if file:is_file() then
    --   print(string.format('File: %s, Line: %d', file.filename, lnum + 1))
    --   open(file:make_relative(), lnum, col)
    -- end
  end)
end, { silent = true, noremap = false })
