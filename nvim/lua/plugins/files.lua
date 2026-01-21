-- only format changed bits
local function format_hunks()
  local ignore_filetypes = { 'lua' }
  if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
    vim.notify('range formatting for ' .. vim.bo.filetype .. ' not working properly.')
    return
  end

  local hunks = require('gitsigns').get_hunks(0)
  if hunks == nil then return end

  local format = require('conform').format

  local function format_range()
    if next(hunks) == nil then
      vim.notify('done formatting git hunks', vim.log.levels.INFO, { title = 'formatting' })
      return
    end
    local hunk = nil
    while next(hunks) ~= nil and (hunk == nil or hunk.type == 'delete') do
      hunk = table.remove(hunks)
    end

    if hunk ~= nil and hunk.type ~= 'delete' then
      local start = hunk.added.start
      local last = start + hunk.added.count
      -- nvim_buf_get_lines uses zero-based indexing -> subtract from last
      local last_hunk_line = vim.api.nvim_buf_get_lines(0, last - 2, last - 1, true)[1]
      local range = { start = { start, 0 }, ['end'] = { last - 1, last_hunk_line:len() } }
      format({ range = range, async = true, lsp_fallback = true }, function()
        vim.defer_fn(function() format_range() end, 1)
      end)
    end
  end

  format_range()
end

return {
  {
    'folke/ts-comments.nvim',
    opts = {},
    event = 'VeryLazy',
  },
  {
    'stevearc/aerial.nvim',
    dependencies = { 'folke/snacks.nvim' },
    keys = {
      { '<F8>', '<cmd>AerialToggle<cr>', noremap = true },
      {
        '<leader>j',
        function() require('aerial').snacks_picker() end,
      },
    },
    opts = {},
  },
  {
    'rmagatti/goto-preview',
    event = 'BufEnter',
    opts = {
      default_mappings = true,
      height = 25,
      width = 105,
      post_open_hook = function(buf, win)
        -- necessary as per https://github.com/rmagatti/goto-preview/issues/64#issuecomment-1159069253
        vim.api.nvim_set_option_value('winhighlight', 'Normal:', { win = win })
        -- https://github.com/rmagatti/goto-preview/issues/112#issuecomment-1878942159
        local orig_state = vim.api.nvim_get_option_value('modifiable', { buf = buf })
        vim.api.nvim_set_option_value('modifiable', false, { buf = buf })
        vim.api.nvim_create_autocmd({ 'WinLeave' }, {
          buffer = buf,
          callback = function()
            vim.api.nvim_win_close(win, false)
            vim.api.nvim_set_option_value('modifiable', orig_state, { buf = buf })
            return true
          end,
        })
      end,
    },
  },
  {
    'stevearc/conform.nvim',
    opts = {
      -- format_on_save = format_hunks,
      formatters = {
        prettier = {
          prepend_args = { '--no-semi', '--single-quote' },
        },
        stylua = {
          -- stylua: ignore
          prepend_args = {
            '--column-width', '100',
            '--indent-width', '2',
            '--quote-style', 'AutoPreferSingle',
            '--collapse-simple-statement', 'Always',
          },
        },
      },
      format_on_save = { lsp_format = 'fallback' },
      formatters_by_ft = {
        lua = { 'stylua' },
        rust = { 'rustfmt', lsp_format = 'fallback' },
        go = { 'goimports', timeout_ms = 3000 }, -- 3s becaue big projects take forever
        javascript = { 'biome', 'prettier', stop_after_first = true },
        typescript = { 'biome', 'prettier', stop_after_first = true },
        sh = { 'shfmt' },
        css = { 'prettier' },
        html = { 'prettier' },
        rest = { 'injected' },
      },
    },
  },
  { 'stevearc/quicker.nvim', ft = 'qf', opts = {} },
}
