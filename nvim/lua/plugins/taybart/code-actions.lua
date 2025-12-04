return {
  'taybart/code-actions.nvim',
  -- dir = '~/dev/taybart/code-actions.nvim',
  dependencies = { 'folke/snacks.nvim' },
  opts = {
    register_keymap = true,
    -- stylua: ignore
    actions = {
      {
        command = 'Expand',
        show = { ft = { 'json' } },
        fn = function() vim.cmd([[Expand]]) end,
      },
      {
        command = 'Compact',
        show = { ft = { 'json' } },
        fn = function() vim.cmd([[Compact]]) end,
      },
    },
    servers = {
      git = {
        ctx = {
          action_exists = function(name)
            local actions = require('gitsigns').get_actions()
            return actions ~= nil and actions[name] ~= nil
          end,
          get_action = function(name)
            local actions = require('gitsigns').get_actions()
            if actions ~= nil and actions[name] ~= nil then
              return actions[name]
            end
            return function() end
          end,
        },
        -- stylua: ignore
        actions = {
          {
            command = 'Preview hunk',
            show = function(ctx) return ctx.g.action_exists('preview_hunk') end,
            fn = function(a) a.ctx.g.get_action('preview_hunk')() end,
          },
          {
            command = 'Reset hunk',
            show = function(ctx) return ctx.g.action_exists('reset_hunk') end,
            fn = function(a) a.ctx.g.get_action('reset_hunk')() end,
          },
          {
            command = 'Select hunk',
            show = function(ctx) return ctx.g.action_exists('select_hunk') end,
            fn = function(a) a.ctx.g.get_action('select_hunk')() end,
          },
          {
            command = 'Stage hunk',
            show = function(ctx) return ctx.g.action_exists('stage_hunk') end,
            fn = function(a) a.ctx.g.get_action('stage_hunk')() end,
          },
        },
      },
    },
  },
}
