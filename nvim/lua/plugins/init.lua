return {
  { 'taybart/rest.nvim', config = true },
  -- { dir = '~/dev/taybart/rest.nvim', config = true },

  {
    'taybart/b64.nvim',
    config = function()
      require('utils/maps').mode_group('v', {
        { '<leader>bd', require('b64').decode },
        { '<leader>be', require('b64').encode },
      }, { noremap = true, silent = true })
    end,
  },

  { -- required with tmux
    'christoomey/vim-tmux-navigator',
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
    config = function()
      require('utils/maps').mode_group('n', {
        { '<c-f><left>', ':TmuxNavigateLeft<cr>' },
        { '<c-f><down>', ':TmuxNavigateDown<cr>' },
        { '<c-f><up>', ':TmuxNavigateUp<cr>' },
        { '<c-f><right>', ':TmuxNavigateRight<cr>' },
      }, { noremap = true, silent = true })
    end,
  },

  { 'tweekmonster/startuptime.vim', cmd = { 'StartupTime' } },

  { 'eandrju/cellular-automaton.nvim', cmd = { 'CellularAutomaton' } },

  --[==================[
  -- Probation
  --]==================]
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'theHamsta/nvim-dap-virtual-text',
      'rcarriga/nvim-dap-ui',
      'leoluz/nvim-dap-go',
    },
    -- cmd = { 'DapContinue', 'DapToggleBreakpoint' },
    config = function()
      local dap, dapui = require('dap'), require('dapui')
      dapui.setup()
      require('dap-go').setup()
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close({})
      end
      require('nvim-dap-virtual-text').setup({
        commented = true,
      })
    end,
  },

  { 'pest-parser/pest.vim', ft = 'pest' },

  {
    'phaazon/mind.nvim',
    branch = 'v2.2',
    cmd = { 'MindOpenMain', 'MindOpenProject', 'MindOpenSmartProject' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = true,
  },

  {
    'jiaoshijie/undotree',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = true,
    keys = {
      {
        '<leader>u',
        function()
          require('undotree').toggle()
        end,
        { noremap = true, silent = true },
      },
    },
  },
  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local alpha = require('alpha')
      local dashboard = require('alpha.themes.dashboard')

      dashboard.section.header.opts.hl = 'Include'
      dashboard.section.header.val = {
        -- [[             o\                                                                   ]],
        -- [[   _________/__\__________                                                        ]],
        -- [[  |                  - (  |                                                       ]],
        -- [[ ,'-.                 . `-|    ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ]],
        -- [[(____".       ,-.    '   ||    ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ]],
        -- [[  |          /\,-\   ,-.  |    ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ]],
        -- [[  |      ,-./     \ /'.-\ |    ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ]],
        -- [[  |     /-.,\      /     \|    ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ]],
        -- [[  |    /     \    ,-.     \    ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ]],
        -- [[  |___/_______\__/___\_____\                                                      ]],

        [[             o\                                                   ]],
        [[   _________/__\__________                                        ]],
        [[  |                  - (  |                                       ]],
        [[ ,'-.                 . `-|    _   _                 _            ]],
        [[(____".       ,-.    '   ||   | \ | | ___  _____   _(_)_ __ ___   ]],
        [[  |          /\,-\   ,-.  |   |  \| |/ _ \/ _ \ \ / / | '_ ` _ \  ]],
        [[  |      ,-./     \ /'.-\ |   | |\  |  __/ (_) \ V /| | | | | | | ]],
        [[  |     /-.,\      /     \|   |_| \_|\___|\___/ \_/ |_|_| |_| |_| ]],
        [[  |    /     \    ,-.     \                                       ]],
        [[  |___/_______\__/___\_____\                                      ]],
      }
      dashboard.section.buttons.val = {
        dashboard.button('i', '  Scratch', ':ene <BAR> startinsert <CR>'),
        dashboard.button('l', '  Lazy', ':Lazy<CR>'),
        dashboard.button('m', '  Mason', ':Mason<CR>'),
        dashboard.button('s', '  Config', ':e $MYVIMRC | :cd %:p:h | pwd<CR>'),
        dashboard.button('q', '  Quit NVIM', ':qa<CR>'),
      }
      alpha.setup(dashboard.config)
    end,
  },
}
