-- stylua: ignore
local ts_languages = {
  'astro', 'bash', 'c', 'cpp', 'css',
  'dockerfile', 'go', 'gomod', 'gotmpl',
  'hcl', 'html', 'javascript', 'json',
  'json5', 'lua', 'make', 'markdown',
  'python', 'rust', 'sql', 'tsx',
  'typescript', 'vimdoc', 'vue', 'yaml',
}

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    priority = 1000,
    lazy = false,
    build = ':TSUpdate',
    config = function()
      local ts = require('nvim-treesitter')
      ts.install(ts_languages)

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('TreesitterSetup', { clear = true }),
        pattern = ts_languages,
        callback = function(ev)
          local lang = vim.treesitter.language.get_lang(ev.match) or ev.match
          pcall(vim.treesitter.start, ev.buf, lang)
          -- Enable treesitter indentation
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          vim.wo[0][0].foldmethod = 'expr'
        end,
      })
      -- open folds by default
      vim.api.nvim_create_autocmd({ 'BufReadPost', 'FileReadPost' }, {
        pattern = '*',
        callback = function() vim.cmd('normal zR') end,
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
