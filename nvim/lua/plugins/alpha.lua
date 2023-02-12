return {
  'goolord/alpha-nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local alpha = require('alpha')
    local dashboard = require('alpha.themes.dashboard')

    dashboard.section.header.opts.hl = 'Include'
    dashboard.section.header.val = {
      [[ ,'-.                                                            ]],
      [[(____".      ,-.                                                 ]],
      [[            /\,-\   ,-.       _   _                 _            ]],
      [[        ,-./     \ /'.-\     | \ | | ___  _____   _(_)_ __ ___   ]],
      [[       /-.,\      /     \    |  \| |/ _ \/ _ \ \ / / | '_ ` _ \  ]],
      [[      /     \    ,-.     \   | |\  |  __/ (_) \ V /| | | | | | | ]],
      [[_____/_______\__/___\_____\__|_| \_|\___|\___/ \_/ |_|_| |_| |_| ]],
    }
    local function greeting()
      local tableTime = os.date('*t')
      local hour = tableTime.hour
      local greetStr
      if hour == 23 or hour < 7 then
        greetStr = '  Sleep well'
      elseif hour < 12 then
        greetStr = '  Good morning'
      elseif hour >= 12 and hour < 18 then
        greetStr = '  Good afternoon'
      elseif hour >= 18 and hour < 21 then
        greetStr = '  Good evening'
      elseif hour >= 21 then
        greetStr = '望 Good night'
      end
      return {
        type = 'text',
        val = greetStr .. ' tay',
        opts = {
          position = 'center',
          hl = 'String',
        },
      }
    end

    dashboard.section.buttons.val = {
      dashboard.button('i', '  Scratch', ':ene<CR>'),
      dashboard.button('l', '  Lazy', ':Lazy<CR>'),
      dashboard.button('m', '  Mason', ':Mason<CR>'),
      dashboard.button('s', '  Settings', ':e $MYVIMRC | :cd %:p:h | pwd<CR>'),
      dashboard.button('q', '  Quit NVIM', ':qa<CR>'),
    }
    local section = dashboard.section
    dashboard.config.layout = {
      { type = 'padding', val = 2 },
      section.header,
      { type = 'padding', val = 2 },
      greeting(),
      { type = 'padding', val = 2 },
      section.buttons,
      section.footer,
    }
    alpha.setup(dashboard.config)
  end,
}