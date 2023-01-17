return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'theHamsta/nvim-dap-virtual-text',
      'rcarriga/nvim-dap-ui',
      'leoluz/nvim-dap-go',
    },
    cmd = { 'DapContinue', 'DapToggleBreakpoint' },
    config = function()
      local dap, dapui = require('dap'), require('dapui')
      dapui.setup()
      require('dap-go').setup()
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end
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

  { 'eandrju/cellular-automaton.nvim', cmd = { 'CellularAutomaton' } },

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
}
