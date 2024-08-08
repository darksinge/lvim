local M = {}

local function find_project_root(start_path)
  -- List of common project root indicators
  local root_patterns = { '.git', 'package.json', 'Cargo.toml', 'go.mod' }

  local function has_file(dir, file)
    return vim.fn.filereadable(dir .. '/' .. file) == 1
  end

  -- Start from the directory of the current file
  local current_dir = start_path or vim.fn.expand('%:p:h')

  -- Traverse up the directory tree
  while current_dir ~= '/' do
    for _, pattern in ipairs(root_patterns) do
      if has_file(current_dir, pattern) then
        return current_dir
      end
    end
    current_dir = vim.fn.fnamemodify(current_dir, ':h')
  end

  -- If no project root found, return the Neovim's current working directory
  return vim.fn.getcwd()
end

M.find_test_file = function()
  -- Get the current buffer's file name
  local current_file = vim.fn.expand('%:t:r') -- file name without extension
  local current_ext = vim.fn.expand('%:e')    -- file extension  local current_file = vim.fn.expand('%:t')

  if string.find(current_file, '%.test$') ~= nil then
    return
  end

  -- Find the project root
  local root_dir = find_project_root()

  -- Construct the test directory path
  local test_dir = root_dir .. '/test'

  -- Use vim.fn.globpath to search for the test file
  local pattern = '**/' .. current_file .. '.*.' .. current_ext
  local test_files = vim.fn.globpath(test_dir, pattern, false, 1)

  if #test_files == 0 then
    print("No test file found for " .. current_file)
  elseif #test_files == 1 then
    vim.cmd('edit ' .. test_files[1])
  else
    local pickers = require "telescope.pickers"
    local finders = require "telescope.finders"
    local conf = require("telescope.config").values
    local make_entry = require "telescope.make_entry"

    pickers.new({}, {
      prompt_title = "Test Files",
      finder = finders.new_table {
        results = test_files,
        entry_maker = function(entry)
          return make_entry.set_default_entry_mt({
            value = entry,
            display = function(entry)
              local tail = require("telescope.utils").path_tail(entry.value)
              local path = require("plenary.path"):new(entry.value)
              local parent = path:parent():make_relative(vim.loop.cwd())
              return string.format("%s\t\t%s", tail, parent)
            end,
            ordinal = entry,
          }, {})
        end,
      },
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, map)
        local action_state = require "telescope.actions.state"
        local actions = require "telescope.actions"

        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          vim.cmd('edit ' .. selection.value)
        end)
        return true
      end,
    }):find()
  end
end

M.setup = function()
  vim.api.nvim_create_user_command('FindTestFile', M.find_test_file, { force = true })
end

return M
