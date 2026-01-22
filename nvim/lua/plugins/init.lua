-- future pack add (v0.12)
-- local/dev plugins are a problem though https://github.com/neovim/neovim/issues/34765
-- local my_plugin = require('plugins/my_plugin')
--return {
-- src = 'https://github.com/nvim-treesitter/nvim-treesitter',
-- version = 'main',
-- data = {
-- setup = function() end
-- }
-- }
-- vim.pack.add({
--   my_plugin,
-- },{
--   load = function(plug)
--     local data = plug.spec.data or {}
--     local setup = data.setup
--
--     vim.cmd.packadd(plug.spec.name)
--
--     if setup ~= nil and type(setup) == 'function' then
--       setup()
--     end
--   end
-- });

return {
  {
    -- required with tmux
    'christoomey/vim-tmux-navigator',
    init = function()
      --@diagnostic disable-next-line: inject-field
      vim.g.tmux_navigator_no_mappings = 1
    end,
    config = function()
      require('tools/maps').group({ noremap = true, silent = true }, {
        {
          'n',
          { '<c-f><left>',  ':TmuxNavigateLeft<cr>' },
          { '<c-f><down>',  ':TmuxNavigateDown<cr>' },
          { '<c-f><up>',    ':TmuxNavigateUp<cr>' },
          { '<c-f><right>', ':TmuxNavigateRight<cr>' },
        },
        {
          't',
          { '<c-f><left>',  '<c-\\><c-n>:TmuxNavigateLeft<cr>' },
          { '<c-f><down>',  '<c-\\><c-n>:TmuxNavigateDown<cr>' },
          { '<c-f><up>',    '<c-\\><c-n>:TmuxNavigateUp<cr>' },
          { '<c-f><right>', '<c-\\><c-n>:TmuxNavigateRight<cr>' },
        },
      })
    end,
  },

  --[==================[
  --===  Probation  ===
  --]==================]
}
