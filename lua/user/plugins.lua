reload("user.options").setup({
  -- colorscheme = "gruvbox_material",
  colorscheme = "lunar",
})

lvim.plugins = {
  -- -- Copilot is configured at the bottom of this file!
  -- -- DO NOT UNCOMMENT THIS BLOCK
  -- {
  --   "zbirenbaum/copilot.lua",
  --   cmd = "Copilot",
  --   event = "InsertEnter",
  --   config = function()
  --     require("copilot").setup({
  --       enabled = false,
  --       panel = { enabled = false },
  --       suggestions = { enabled = false },
  --     })
  --   end,
  -- },

  {
    "jose-elias-alvarez/typescript.nvim",
  },

  { "morhetz/gruvbox" },
  { "sainnhe/gruvbox-material" },
  { "luisiacc/gruvbox-baby" },

  { "sainnhe/sonokai" },
  { "sainnhe/edge" },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    config = function()
      require("todo-comments").setup()
    end,
  },

  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    config = function()
      require("persistence").setup({
        -- dir = vim.fn.expand(vim.fn.stdpath "state" .. "/sessions/"),
        -- options = { "buffers", "curdir", "tabpages", "winsize" }
      })
    end,
  },

  -- {
  --   "christoomey/vim-tmux-navigator",
  --   config = function()
  --     vim.cmd [[let g:tmux_navigator_no_mappings = 1]]
  --     -- vim.g.tmux_navigator_no_mappings = 1
  --     vim.keymap.set('n', '<C-h>', ':TmuxNavigateLeft<cr>', { silent = true, noremap = true })
  --     vim.keymap.set('n', '<C-j>', ':TmuxNavigateDown<cr>', { silent = true, noremap = true })
  --     vim.keymap.set('n', '<C-k>', ':TmuxNavigateUp<cr>', { silent = true, noremap = true })
  --     vim.keymap.set('n', '<C-l>', ':TmuxNavigateRight<cr>', { silent = true, noremap = true })
  --   end,
  -- },

  {
    "alexghergh/nvim-tmux-navigation",
    config = function()
      local tnav = require("nvim-tmux-navigation")
      tnav.setup({})
      vim.keymap.set("n", "<C-h>", tnav.NvimTmuxNavigateLeft, { silent = true })
      vim.keymap.set("n", "<C-j>", tnav.NvimTmuxNavigateDown, { silent = true })
      vim.keymap.set("n", "<C-k>", tnav.NvimTmuxNavigateUp, { silent = true })
      vim.keymap.set("n", "<C-l>", tnav.NvimTmuxNavigateRight, { silent = true })
    end,
  },

  -- { "tpope/vim-surround" },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  },
  { "felipec/vim-sanegx",   event = "BufRead" },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  { "lunarvim/horizon.nvim" },
  { "tomasr/molokai" },
  { "ayu-theme/ayu-vim" },
  { "tpope/vim-repeat" },

  -- TODO: Learn what this plugin does
  {
    "windwp/nvim-spectre",
    event = "BufRead",
    config = function()
      require("spectre").setup()
    end,
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- {
  --   'phaazon/hop.nvim',
  --   branch = 'v2',
  --   config = function()
  --     -- see :h hop-config
  --     require('hop').setup()
  --   end
  -- },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    config = function()
      require("user.flash")
    end,
  },

  {
    "nvim-lua/lsp-status.nvim",
  },

  -- {
  --   'nvim-telescope/telescope-frecency.nvim',
  --   dependencies = { 'nvim-telescope/telescope.nvim', 'kkharji/sqlite.lua' },
  --   config = function()
  --     local ok, tele = pcall(require, 'user.telescope')
  --     if ok then
  --       tele.config()
  --     end
  --     require('user.telescope').config()
  --   end
  -- },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      require("rose-pine").setup({
        dark_variant = "moon",
        disable_italics = true,
      })
      if vim.g.colors_name == "rose-pine" then
        vim.cmd("colorscheme rose-pine")
      end
    end,
  },

  -- {
  --   'AckslD/nvim-trevJ.lua',
  --   config = 'require("trevj").setup()',
  --   init = function()
  --     vim.keymap.set('n', '<leader>j', function()
  --       require('trevj').format_at_cursor()
  --     end)
  --   end,
  -- },

  {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter" },
    config = function()
      require("treesj").setup({
        use_default_keymaps = false,
        max_join_length = 1000,
      })
      vim.keymap.set("n", "<leader>j", ":TSJToggle<cr>")
    end,
  },

  "lunarvim/lunar.nvim",

  -- -- { "tzachar/cmp-tabnine", event = "InsertEnter", build = "./install.sh", },
  -- {
  --   'LukasPietzschmann/telescope-tabs',
  --   dependencies = { 'nvim-telescope/telescope.nvim' },
  --   config = function()
  --     require 'telescope-tabs'.setup {}
  --   end
  -- },

  {
    "lvimuser/lsp-inlayhints.nvim",
    config = function()
      require("user.inlay-hints")
    end,
  },

  {
    "nvim-treesitter/playground",
    event = "BufRead",
  },

  {
    "junegunn/fzf",
    build = function()
      vim.fn["fzf#install"]()
    end,
  },

  -- {
  --   'rmagatti/goto-preview',
  --   config = function()
  --     require('goto-preview').setup({})
  --   end
  -- },

  { "kevinhwang91/nvim-bqf" },

  { "nathom/filetype.nvim" },

  {
    -- upstream
    "MunifTanjim/nui.nvim",

    -- -- local
    -- dir = vim.env.HOME .. '/projects/personal/nui.nvim'

    -- -- downstream
    -- 'darksinge/nui.nvim',
    -- branch = 'develop',
  },

  {
    dir = vim.env.HOME .. "/projects/personal/nui-popup",
  },

  { "darksinge/neodash.nvim" },

  -- {
  --   dir = vim.env.HOME .. '/projects/personal/plink.nvim',
  --   dependencies = {
  --     'MunifTanjim/nui.nvim',
  --     'nvim-lua/plenary.nvim',
  --     'darksinge/neodash.nvim',
  --   }
  -- },

  {
    "darksinge/plink.nvim",
    commit = "f8148f9",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "darksinge/neodash.nvim",
      "MunifTanjim/nui.nvim",
    },
  },

  -- {
  --   -- 'darksinge/noice.nvim',
  --   'folke/noice.nvim',
  --   -- dir = vim.env.HOME .. '/projects/git/noice.nvim',
  --   event = 'VeryLazy',
  --   dependencies = {
  --     -- 'darksinge/nui.nvim',
  --     'rcarriga/nvim-notify',
  --   },
  --   config = function()
  --     require('noice').setup({
  --       messages = {
  --         enabled = false, -- enables the Noice messages UI
  --         -- view = "notify",           -- default view for messages
  --         -- view = 'mini',
  --         view = 'cmdline',
  --         -- view_error = "mini",       -- view for errors
  --         -- view_warn = "mini",        -- view for warnings
  --         -- view_history = "messages", -- view for :messages
  --         -- view_search = false,       -- view for search count messages. Set to `false` to disable
  --       },
  --       views = {
  --         cmdline_popup = {
  --           position = {
  --             row = 25,
  --             col = "50%",
  --           },
  --           size = {
  --             width = 60,
  --             height = "auto",
  --           },
  --         },
  --         popupmenu = {
  --           relative = "editor",
  --           position = {
  --             row = 28,
  --             col = "50%",
  --           },
  --           size = {
  --             width = 60,
  --             height = 10,
  --           },
  --           border = {
  --             style = "rounded",
  --             padding = { 0, 1 },
  --           },
  --           win_options = {
  --             winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
  --           },
  --         },
  --       },
  --     })

  --     require('telescope').load_extension('noice')
  --   end,
  -- },

  -- {
  --   'folke/neodev.nvim',
  --   opts = {
  --     library = {
  --       enabled = true,
  --       plugins = { 'nui' },
  --     },
  --   },
  -- },

  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
      require("nvim-treesitter.configs").setup({
        autotag = {
          enable = true,
        },
      })
    end,
  },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "marilari88/neotest-vitest",
    },
    config = function()
      require("user.neotest")
    end,
  },

  -- {
  --   'nvim-treesitter/nvim-treesitter-textobjects',
  --   dependencies = { 'nvim-treesitter/nvim-treesitter' },
  --   config = function()
  --     require('user.treesitter-textobjects')
  --   end
  -- },

  -- NOTE: couldn't get this to work, but want to try later
  -- {
  --   'mg979/vim-visual-multi',
  --   config = function()
  --     vim.g.VM_maps =.popup {}
  --     vim.g.VM_maps['Find Under'] = '<C-m>'
  --     vim.g.VM_maps['Find Subword Under'] = '<C-m>'
  --   end
  -- },

  -- This plugin looks promising, but doesn't have good support for mongodb,
  -- which is my main use case. Should revisit this later and see what I can do
  -- to add support for mongodb.
  -- {
  --   'kristijanhusak/vim-dadbod-ui',
  --   dependencies = {
  --     { 'tpope/vim-dadbod', lazy = true },
  --     {
  --       'kristijanhusak/vim-dadbod-completion',
  --       ft = { 'sql', 'mysql', 'plsql', 'js' },
  --       lazy = true,
  --     },
  --   },
  --   cmd = {
  --     'DBUI',
  --     'DBUIToggle',
  --     'DBUIAddConnection',
  --     'DBUIFindBuffer',
  --   },
  --   init = function()
  --     -- Your DBUI configuration
  --     vim.g.db_ui_use_nerd_fonts = 1
  --   end,
  -- }
  {
    "rmagatti/goto-preview",
    config = function()
      local gp = require("goto-preview")
      gp.setup({
        default_mappings = false,
        height = 120,
        opacity = 5,
        stack_floating_preview_windows = false,
        post_open_hook = function(bufnr)
          vim.keymap.set({ "n" }, "q", gp.close_all_win, { buffer = bufnr, noremap = true, silent = true })
          vim.api.nvim_create_autocmd({ "WinLeave" }, {
            buffer = bufnr,
            callback = function(props)
              if bufnr == props.buf then
                pcall(gp.close_all_win)
                return true
              end
            end,
          })
        end,
      })
    end,
  },

  {
    "David-Kunz/gen.nvim",
    opts = {
      model = "llama3",    -- The default model to use.
      host = "localhost",  -- The host running the Ollama service.
      --   port = "11434",      -- The port on which the Ollama service is listening.
      quit_map = "q",      -- set keymap for close the response window
      retry_map = "<c-r>", -- set keymap to re-send the current prompt
      --   init = function(options) pcall(io.popen, "ollama serve > /dev/null 2>&1 &") end,
      --   -- Function to initialize Ollama
      --   command = function(options)
      --     local body = { model = options.model, stream = true }
      --     return "curl --silent --no-buffer -X POST http://" .. options.host .. ":" .. options.port .. "/api/chat -d $body"
      --   end,
      --   -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
      --   -- This can also be a command string.
      --   -- The executed command must return a JSON object with { response, context }
      --   -- (context property is optional).
      --   -- list_models = '<omitted lua function>', -- Retrieves a list of model names
      --   display_mode = "float", -- The display mode. Can be "float" or "split".
      --   show_prompt = false,    -- Shows the prompt submitted to Ollama.
      show_model = false, -- Displays which model you are using at the beginning of your chat session.
      --   no_auto_close = false,  -- Never closes the window automatically.
      --   debug = false           -- Prints errors and the command which is run.
    },
    config = function()
      require("user.gen")
    end,
  },

  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    opts = {
      chat = {
        keymaps = {
          close = "<C-c>",
          yank_last = "<C-y>",
          yank_last_code = "<C-k>",
          scroll_up = "<C-u>",
          scroll_down = "<C-d>",
          new_session = "<C-m>",
          cycle_windows = "<Tab>",
          cycle_modes = "<C-f>",
          next_message = "<C-j>",
          prev_message = "<C-k>",
          select_session = "<Space>",
          rename_session = "r",
          delete_session = "d",
          draft_message = "<C-r>",
          edit_message = "e",
          delete_message = "d",
          toggle_settings = "<C-o>",
          toggle_sessions = "<C-p>",
          toggle_help = "<C-h>",
          toggle_message_role = "<C-r>",
          toggle_system_role_open = "<C-s>",
          stop_generating = "<C-x>",
        },
        openai_params = {
          model = "gpt-4-turbo",
          frequency_penalty = 0,
          presence_penalty = 0,
          max_tokens = 300,
          temperature = 0,
          top_p = 1,
          n = 1,
        },
        openai_edit_params = {
          model = "gpt-4-turbo",
          frequency_penalty = 0,
          presence_penalty = 0,
          temperature = 0,
          top_p = 1,
          n = 1,
        },
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },

  {
    "tpope/vim-unimpaired",
  },

  {
    -- `:Gwrite[!]`: write the current file to the index
    --      `:only`: close all windows apart from the current one
    --         `]c`: jump to next hunk
    --         `]n`: jump to next conflict marker
    "tpope/vim-fugitive",
    cmd = {
      "G",
      "Git",
      "Gdiffsplit",
      "Gread",
      "Gwrite",
      "Ggrep",
      "GMove",
      "GDelete",
      "GBrowse",
      "GRemove",
      "GRename",
      "Glgrep",
      "Gedit",
    },
    ft = { "fugitive" },
  },

  -- {
  --   'tummetott/unimpaired.nvim',
  --   event = 'VeryLazy',
  --   opts = {
  --     -- add options here if you wish to override the default settings
  --   },
  -- }

  {
    "jiaoshijie/undotree",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
    keys = {
      -- { "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
    },
  },

  { "akinsho/git-conflict.nvim", version = "*", config = true },

  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      -- provider = 'openai',
      provider = "claude",
      auto_suggestions_provider = "copilot",
      claude = {
        api_key_name = { "pass", "show", "craig/anthropic/api-key/avante.nvim" },
      },
      -- debug = true,
      -- system_prompt = "Always respond in English. Act like you don't know any other languages such as French.\n" ..
      --     "Be concise in your responses. Do not over explain.\n" ..
      --     default_config.system_prompt
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    -- NOTE: It's not that I WANT to build from source, but this stupid plugin doesn't work unless I do
    build = "make BUILD_FROM_SOURCE=true",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      -- "zbirenbaum/copilot.lua",      -- for providers='copilot'
      -- {
      --   -- support for image pasting
      --   "HakonHarnes/img-clip.nvim",
      --   event = "VeryLazy",
      --   opts = {
      --     -- recommended settings
      --     default = {
      --       embed_image_as_base64 = false,
      --       prompt_for_file_name = false,
      --       drag_and_drop = {
      --         insert_mode = true,
      --       },
      --       -- required for Windows users
      --       use_absolute_path = true,
      --     },
      --   },
      -- },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },

    -- config = function()
    --   require('avante').setup()

    --   -- require('avante').setup({
    --   --   provider = "claude",
    --   --   claude = {
    --   --     api_key_name = { "pass", "show", "craig/anthropic/api-key/avante.nvim" },
    --   --   },
    --   -- })

    --   --   local default_config = require('avante.config').defaults
    --   --   print('default_config:' .. vim.inspect(default_config))
    --   -- require("user.avante").setup({
    --   --   -- provider = 'openai',
    --   --   provider = "claude",
    --   --   -- auto_suggestions_provider = "copilot",
    --   --   claude = {
    --   --     api_key_name = { "pass", "show", "craig/anthropic/api-key/avante.nvim" },
    --   --   },
    --   --   -- debug = true,
    --   --   -- system_prompt = "Always respond in English. Act like you don't know any other languages such as French.\n" ..
    --   --   --     "Be concise in your responses. Do not over explain.\n" ..
    --   --   --     default_config.system_prompt
    --   -- })
    -- end,
  },

  {
    "mxsdev/nvim-dap-vscode-js",
    dependencies = {
      "mfussenegger/nvim-dap",
      {
        "microsoft/vscode-js-debug",
        build = "npm install && npx gulp vsDebugServerBundle && rm -rf out && mv dist out",
      },
    },
  },
}

lvim.builtin.lualine.on_config_done = function(lualine)
  local noice_ok, noice = pcall(require, "noice")
  if noice_ok then
    local config = lualine.get_config()
    table.insert(config.sections.lualine_c, {
      noice.api.statusline.mode.get,
      cond = noice.api.statusline.mode.has,
      color = { fg = "#ff9e64" },
    })
    lualine.setup(config)
  end
end

lvim.lazy.opts.dev = {
  path = "~/projects/personal",
  fallback = false,
}

table.insert(lvim.plugins, {
  "zbirenbaum/copilot-cmp",
  event = "InsertEnter",
  dependencies = { "zbirenbaum/copilot.lua" },
  config = function()
    vim.defer_fn(function()
      require("copilot").setup({
        -- enabled = false,
        -- panel = { enabled = false },
        -- suggestions = { enabled = false },
      })
      local has_words_before = function()
        if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
          return false
        end
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0
            and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
      end
      local cmp = require("copilot_cmp")
      cmp.setup({
        mapping = {
          ["<Tab>"] = vim.schedule_wrap(function(fallback)
            if cmp.visible() and has_words_before() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
              fallback()
            end
          end),
        },
      })
    end, 100)
  end,
})

table.insert(lvim.plugins, 1, {
  "folke/neoconf.nvim",
  -- priority = 9999,
  -- init = function()
  --   require('neoconf').setup()
  -- end
})

lvim.builtin.telescope.on_config_done = function(telescope)
  pcall(telescope.load_extension, "frecency")
end
