local function p()
  return require('snacks').picker
end

return {
  'folke/snacks.nvim',
  priority = 100,
  -- stylua: ignore
  keys = {
    -- p().smart({
    { '<c-p>', function()
      p().files({
        hidden = true,
        follow = true,
        layout = 'select_tall'
      })
    end, },

    { '<c-s>',      function() p().grep() end },
    {
      'g<c-s>',
      mode = { 'n', 'x' },
      function() p().grep_word() end
    },
    { '<c-h>',      function() p().help({ layout = 'select' }) end },
    { '<c-b>',      function() p().buffers() end },
    { '<leader>ev', function() p().files({ cwd = vim.fn.stdpath('config') }) end },
  },
  config = function()
    local s = require('snacks')
    local layouts = require('snacks.picker.config.layouts')
    s.setup({
      bigfile = { enabled = true },
      indent = {
        enabled = true,
        animate = {
          enabled = false,
          duration = {
            step = 10,
            total = 200,
          },
        },
      },
      input = { enabled = true },
      notifier = { enabled = true, timeout = 3000 },
      picker = {
        enabled = true,
        win = {
          input = {
            keys = {
              ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
            },
          },
        },
      },
      quickfile = { enabled = true },
    })
    layouts.select_tall = vim.tbl_deep_extend('keep', { layout = { height = 0.8 } }, layouts.select)
    vim.api.nvim_create_user_command('Notifications', s.notifier.show_history, {})
    vim.api.nvim_create_user_command('Sntest', function()
      require('utils/picker')('test', {
        { text = 'test1', value = 'a' },
        { text = 'test2', value = 'b' },
        { text = 'test3', value = 'c' },
      }, function(choice)
        print(choice)
      end)
    end, {})
  end,
}
