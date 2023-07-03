lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "custom"

local header = {
  type = "text",
  val = require("user.banners").dashboard(),
  opts = {
    position = "center",
    hl = "Comment",
  },
}

local plugins = ""
local date = ""
if vim.fn.has "linux" == 1 or vim.fn.has "mac" == 1 then
  -- local handle = io.popen 'fd -d 2 . $HOME"/.local/share/lunarvim/site/pack/packer" | grep pack | wc -l | tr -d "\n" '
  -- plugins = handle:read "*a"
  -- handle:close()

  local thingy = io.popen 'echo "$(date +%a) $(date +%d) $(date +%b)" | tr -d "\n"'
  date = thingy:read "*a"
  thingy:close()
  plugins = plugins:gsub("^%s*(.-)%s*$", "%1")
else
  plugins = "N/A"
  date = "  whatever "
end

local plugin_count = {
  type = "text",
  val = "└─ " .. lvim.icons.kind.Module .. " " .. plugins .. " plugins in total ─┘",
  opts = {
    position = "center",
    hl = "String",
  },
}

local heading = {
  type = "text",
  val = "┌─ " .. lvim.icons.ui.Calendar .. " Today is " .. date .. " ─┐",
  opts = {
    position = "center",
    hl = "String",
  },
}

local fortune = require "alpha.fortune" ()
-- fortune = fortune:gsub("^%s+", ""):gsub("%s+$", "")
local footer = {
  type = "text",
  val = fortune,
  opts = {
    position = "center",
    hl = "Comment",
    hl_shortcut = "Comment",
  },
}

local function button(sc, txt, keybind)
  local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")

  local opts = {
    position = "center",
    text = txt,
    shortcut = sc,
    cursor = 5,
    width = 24,
    align_shortcut = "right",
    hl_shortcut = "Number",
    hl = "Function",
  }
  if keybind then
    opts.keymap = { "n", sc_, keybind, { noremap = true, silent = true } }
  end

  return {
    type = "button",
    val = txt,
    on_press = function()
      local key = vim.api.nvim_replace_termcodes(sc_, true, false, true)
      vim.api.nvim_feedkeys(key, "normal", false)
    end,
    opts = opts,
  }
end

local buttons = {
  type = "group",
  val = {
    button("f", " " .. lvim.icons.kind.Folder .. " Explore", ":Telescope find_files<CR>"),
    button("e", " " .. lvim.icons.kind.File .. " New file", ":ene <BAR> startinsert <CR>"),
    button("s", " " .. lvim.icons.ui.History .. " Restore", ":lua require('persistence').load()<cr>"),
    button(
      "g",
      " " .. lvim.icons.git.Branch .. " Git Status",
      ":lua require('lvim.core.terminal')._exec_toggle({cmd = 'lazygit', count = 1, direction = 'float'})<CR>"
    ),
    button("r", " " .. lvim.icons.ui.History .. " Recents", ":Telescope oldfiles<CR>"),
    button("c", " " .. lvim.icons.ui.Gear .. " Config", ":e ~/.config/lvim/config.lua<CR>"),
    button("C", " " .. lvim.icons.kind.Color .. " Colorscheme Config", ":e ~/.config/lvim/lua/user/colorscheme.lua<CR>"),
    button("q", " " .. lvim.icons.ui.SignOut .. " Quit", ":q<CR>"),
  },
  opts = {
    spacing = 1,
  },
}

local section = {
  header = header,
  buttons = buttons,
  plugin_count = plugin_count,
  heading = heading,
  footer = footer,
}

lvim.builtin.alpha.custom = {
  config = {
    layout = {
      { type = "padding", val = 1 },
      section.header,
      { type = "padding", val = 2 },
      section.heading,
      section.plugin_count,
      { type = "padding", val = 1 },
      section.buttons,
      section.footer,
    },
    opts = {
      margin = 5,
    },
  }
}
