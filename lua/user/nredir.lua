--
--
--
--
--
--
--
-- NOTE: This thing is completely broken
--
--
--
--
--
--
--
local M = {}

M.close = function()
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
  end
end

local function removeAscii(text)
  for k, v in pairs(text) do
    -- Remove all the ansi escape characters
    text[k] = string.gsub(v, "[\27\155][][()#;?%d]*[A-PRZcf-ntqry=><~]", "")
  end
  return text
end

local zoom_toggle = function()
  local width = vim.api.nvim_get_option("columns")
  local max_width = math.ceil(width * 0.9)
  local min_width = math.ceil(width * 0.5)
  if vim.api.nvim_win_get_width(win) ~= max_width then
    vim.api.nvim_win_set_width(win, max_width)
  else
    vim.api.nvim_win_set_width(win, min_width)
  end
end

M.wrap = function()
  vim.cmd("set wrap!")
end

local function starts_with(str, start)
  return str:sub(1, #start) == start
end

local function redraw(buf, cmd)
  local result = vim.fn.split(vim.fn.execute(cmd), "\n")
  vim.api.nvim_buf_set_option(buf, "modifiable", true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, result)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
end

local function set_mappings(buf)
  local opts = {
    nowait = true,
    noremap = true,
    silent = true,
  }

  local set_keymap = function(keymap, cb)
    vim.api.nvim_buf_set_keymap(buf, 'n', keymap, cb, opts)
  end

  set_keymap('q', M.close)
  set_keymap('<cr>', zoom_toggle)
  set_keymap('w', M.wrap)
end

local function create_win(filetype)
  filetype = (filetype == nil and "result") or filetype
  vim.api.nvim_command("botright vnew")
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()

  vim.api.nvim_buf_set_name(0, "result #" .. buf)

  vim.api.nvim_buf_set_option(0, "buftype", "nofile")
  vim.api.nvim_buf_set_option(0, "swapfile", false)
  vim.api.nvim_buf_set_option(0, "filetype", filetype)
  vim.api.nvim_buf_set_option(0, "bufhidden", "wipe")

  vim.api.nvim_command("setlocal wrap")
  vim.api.nvim_command("setlocal cursorline")

  set_mappings()

  return { win = win, buf = buf }
end

M.nredir = function(cmd, filetype)
  local result = create_win(filetype)
  redraw(result.buf, cmd)
end

return M
