local function p(mod, opts)
  if mod then return require('snacks').picker[mod](opts) end
  return require('snacks').picker
end

return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  -- stylua: ignore
  keys = {
    { '<c-p>', function()
      p('files', {
        hidden = true,
        follow = true,
        layout = 'select_tall'
      })
    end,
    },
    { '<c-s>',      function() p('grep') end },
    {
      -- grep with <cword>
      'g<c-s>',
      mode = { 'n', 'x' },
      function() p('grep_word') end
    },
    { '<c-h>',      function() p('help', { layout = 'select' }) end },
    { '<c-b>',      function() p('buffers') end },
    { '<leader>ev', function() p('files', { cwd = vim.fn.stdpath('config') }) end },
  },
  config = function()
    local s = require('snacks')
    s.setup({
      bigfile = { enabled = true },
      indent = { enabled = true, animate = { enabled = false } },
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
    -- better layouts
    local layouts = require('snacks.picker.config.layouts')
    layouts.select_tall = vim.tbl_deep_extend('keep', { layout = { height = 0.8 } }, layouts.select)

    -- see notification history
    vim.api.nvim_create_user_command('Notifications', s.notifier.show_history, {})
  end,
}
