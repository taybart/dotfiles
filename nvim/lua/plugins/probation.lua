return {

  --  { 'mfussenegger/nvim-dap' },

  { 'pest-parser/pest.vim', ft = 'pest' },

  {
    'phaazon/mind.nvim',
    branch = 'v2.2',
    cmd = { 'Mind' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = true,
  },

  { 'eandrju/cellular-automaton.nvim' },

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
