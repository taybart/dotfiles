return {
  {
    'taybart/rest.nvim',
    dependencies = { 'taybart/code-actions.nvim' },
    -- dir = '~/dev/taybart/rest.nvim',
    -- dependencies = { dir = '~/dev/taybart/code-actions.nvim' },
    config = true,
  },
  {
    'taybart/resurrect.nvim',
    event = 'VeryLazy',
    -- dir = '~/dev/taybart/resurrect.nvim',
    dependencies = { 'kkharji/sqlite.lua' },
    opts = { quiet = true },
  },
  {
    'taybart/serve.nvim',
    -- dir = '~/dev/taybart/serve.nvim',
    opts = {},
    -- opts = { logs = { level = 'debug', no_color = true } },
  },
  {
    'taybart/code-actions.nvim',
    -- dir = '~/dev/taybart/code-actions.nvim',
    opts = {
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
          cmd = 'Compact',
        },
      },
      servers = {
        gitsigns = {
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
            -- TODO turn this into ['preview hunk'] = { show = function(ctx)...
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
  },
  {
    'taybart/b64.nvim',
    -- dir = '~/dev/taybart/b64.nvim',
    config = function()
      require('utils/maps').mode_group('v', {
        { '<leader>bd', require('b64').decode },
        { '<leader>be', require('b64').encode },
      }, { noremap = true, silent = true })
    end,
  },
  {
    'taybart/inline.nvim',
    enabled = false,
    -- dir =  '~/dev/taybart/inline.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    -- event = 'VeryLazy',
    config = function()
      local il = require('inline').setup({
        keymaps = { enabled = false },
        signcolumn = { enabled = false },
        virtual_text = { icon = '📰' },
        popup = { width = 20, height = 4 },
      })
      vim.keymap.set('n', '<leader>N', function()
        il.notes.show(false)
      end)
      vim.api.nvim_create_user_command('EditFileNote', function()
        il.notes.show(true, true)
      end, {})
      vim.api.nvim_create_user_command('AddNote', il.notes.add, {})
      vim.api.nvim_create_user_command('ShowNote', il.notes.show, {})
    end,
  },
  {
    'taybart/vis',
    -- dir = '~/dev/taybart/vis',
  },
}
