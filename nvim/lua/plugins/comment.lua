local M = {}
function M.configure()
  require('Comment').setup({
    ignore = '^$',
    pre_hook = function(ctx)
      local u = require('Comment.utils')

      local ft = vim.bo.filetype
      if ft == 'typescriptreact' or ft == 'javascriptreact' then
        local type = ctx.ctype == u.ctype.line and '__default' or '__multiline'
        local location = nil
        local tsutils = require('ts_context_commentstring.utils')
        if ctx.ctype == u.ctype.block then
          location = tsutils.get_cursor_location()
        elseif ctx.cmotion == u.cmotion.v or ctx.cmotion == u.cmotion.V then
          location = tsutils.get_visual_start_location()
        end
        local tsinternals = require('ts_context_commentstring.internal')
        return tsinternals.calculate_commentstring({
          key = type,
          location = location,
        })
      end
    end,
  })
end
return M
