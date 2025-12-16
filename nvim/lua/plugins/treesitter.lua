return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    priority = 1000,
    lazy = false,
    build = ':TSUpdate',
    config = function()
      -- stylua: ignore
      require('nvim-treesitter').install({
        'astro', 'bash', 'c', 'cpp', 'css',
        'dockerfile', 'go', 'gomod', 'gotmpl',
        'hcl', 'html', 'javascript', 'json',
        'json5', 'lua', 'make', 'markdown',
        'python', 'rust', 'sql', 'tsx',
        'typescript', 'vimdoc', 'vue', 'yaml',
      })

      vim.api.nvim_create_autocmd('FileType', {
        callback = function() pcall(vim.treesitter.start) end,
      })
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    config = function()
      local function select_to(cap)
        require('nvim-treesitter-textobjects.select').select_textobject(cap, 'textobjects')
      end
      require('tools/maps').mode_group({ 'x', 'o' }, {
        { 'af', function() select_to('@function.outer') end },
        { 'if', function() select_to('@function.inner') end },
        { 'ac', function() select_to('@class.outer') end },
        { 'ic', function() select_to('@class.inner') end },
      })
    end,
  },
  { 'nvim-treesitter/nvim-treesitter-context', opts = { enable = true } },
  -- TODO: keep up to date on locals, since its a very unpolished/new package
  { 'nvim-treesitter/nvim-treesitter-locals' },
}
