-- local tele = require('telescope')
local builtin = require('telescope.builtin')
-- local themes = require('telescope.themes')
local pickers = require "telescope.pickers"
-- local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local _utils = require('tele.utils')
local _finders = require('tele.finders')

local order_by = 'recent'

local find_project_files = function(prompt_bufnr)
  local ppath = action_state.get_selected_entry().value
  actions.close(prompt_bufnr)
  local cd_ok = _utils.change_project_dir(ppath)
  if cd_ok then
    vim.schedule(function()
      builtin.find_files({ cwd = ppath })
    end)
  end
end

-- -- our picker function: colors
-- C = function(opts)
--   opts = opts or {}
--   pickers.new(opts, {
--     finder = _finders.project_finder(opts, _utils.get_projects(order_by)),
--     -- finder = finders.new_table {
--     --   result = {
--     --     { "red", "#ff0000" },
--     --     { "green", "#00ff00" },
--     --     { "blue", "#0000ff" },
--     --   },
--     --   entry_maker = function(entry)
--     --     return {
--     --       value = entry,
--     --       display = entry[1],
--     --       ordinal = entry[1],
--     --     }
--     --   end,
--     -- },
--     sorter = conf.generic_sorter(opts),
--     -- attach_mappings = function(prompt_bufnr, map)
--     --   actions.select_default:replace(function()
--     --     actions.close(prompt_bufnr)
--     --     local selection = action_state.get_selected_entry()
--     --     -- P(selection)
--     --     vim.api.nvim_put({ selection[1] }, "", false, true)
--     --   end)
--     --   return true
--     -- end,
--     attach_mappings = function(prompt_bufnr, map)
--       map('n', 'f', find_project_files)
--       local on_project_selected = function()
--         find_project_files(prompt_bufnr)
--       end
--       actions.select_default:replace(on_project_selected)
--       return true
--     end,
--   }):find()
-- end

local c = function()
  -- opts = vim.tbl_deep_extend("force", theme_opts, opts or {})
  local opts = {}
  pickers.new(opts, {
    prompt_title = 'Select a project',
    results_title = 'Projects',
    finder = _finders.project_finder(opts, _utils.get_projects(order_by)),
    sorter = conf.file_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)

      -- local refresh_projects = function()
      --   local picker = action_state.get_current_picker(prompt_bufnr)
      --   local finder = _finders.project_finder(opts, _utils.get_projects(order_by))
      --   picker:refresh(finder, { reset_prompt = true })
      -- end

      -- Project key mappings
      map('n', 'f', find_project_files)

      local on_project_selected = function()
        find_project_files(prompt_bufnr)
      end
      actions.select_default:replace(on_project_selected)
      return true
    end
  }):find()
end

c()
