local parsers = require('nvim-treesitter.parsers')
local locals = require('nvim-treesitter.locals')

local ts = vim.treesitter
local api = vim.api

function p(value)
  print(vim.inspect(value))
end

function t(node)
  p(ts.get_node_text(node, 0))
end

local M = {}

M.setup = function()
  local group_id = vim.api.nvim_create_augroup('js-commenter', {
    clear = true,
  })

  vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
    group = group_id,
    pattern = { "*.js", "*.ts" },
    callback = function()
      local bufnr = api.nvim_get_current_buf()
      local lang = parsers.get_buf_lang(bufnr)
      local parser = parsers.get_parser(bufnr, lang)
      ---@type TSTree
      local tree = parser:parse()[1]
      local root = tree:root()
      local query = ts.query.parse(lang, [[
        (
          (comment) @comment
          (function_declaration
            (formal_parameters) @params) @fn
        )
      ]])
      local results = {}
      for _, matches, _ in query:iter_matches(root, bufnr, root:start(), root:end_()) do
        local comment = matches[1]
        local params = matches[2]
        local fn = matches[3]

        local comment_text = ts.get_node_text(comment, bufnr)
        local comment_start_line = comment:start()
        local comment_end_line = comment:end_()
        local fn_start_line = fn:start()

        if comment_end_line ~= fn_start_line - 1 then
          return
        end

        if not string.match(comment_text, '/%*%*.* %*/$') then
          return
        end

        local lines = { "/**" }
        local object_count = 0

        for _, param in ipairs(params:named_children()) do
          if param:type() == 'identifier' then
            table.insert(lines, " * @param {*} " .. ts.get_node_text(param, bufnr))
          end

          if param:type() == 'object_pattern' then
            local object_name = "param" .. object_count
            table.insert(lines, " * @param {Object} " .. object_name)
            object_count = object_count + 1
            for _, child in ipairs(param:named_children()) do
              local left = child:field('left')[1]
              ---@type TSNode
              local right = child:field('right')[1]
              local type = right:type()
              if type == 'true' or type == 'false' then
                type = 'boolean'
              end
              table.insert(lines,
                " * @param {" .. type .. "} " .. object_name .. "." .. ts.get_node_text(left, bufnr))
            end
          end
        end

        if #lines > 0 then
          local fn_first_line = api.nvim_buf_get_lines(bufnr, fn:start(), fn:start() + 1, false)[1]
          api.nvim_buf_set_lines(bufnr, comment_start_line, comment_end_line, false, lines)
        end
      end
      return results
    end
  })
end

M.setup()

return M
