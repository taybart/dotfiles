local M = {}

local api = vim.api


-- https://github.com/norcalli/nvim_utils
local function create_augroups(definitions)
  for group_name, definition in pairs(definitions) do
    vim.api.nvim_command('augroup '..group_name)
    vim.api.nvim_command('autocmd!')
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
      vim.api.nvim_command(command)
    end
    vim.api.nvim_command('augroup END')
  end
end

create_augroups({
  nvim = {
    { 'InsertEnter', '*', 'set timeoutlen=100' },
    { 'InsertLeave', '*', 'set timeoutlen=1000' },
  },

  looks = {
    { 'BufEnter,FocusGained,InsertLeave', '*', 'lua require("tb/looks").toggle_num(true)' },
    { 'BufLeave,FocusLost,InsertEnter', '*', 'lua require("tb/looks").toggle_num(false)' },
  },
  nvim_tree = {
    { 'BufEnter NvimTree set cursorline' },
  },

  language_autocmd = {
    { 'BufRead,BufNewFile', '*.tmpl', 'setfiletype gohtmltmpl' },
  },

  commentary = {
    { 'FileType helm setlocal commentstring=# %s' },
    { 'FileType svelte setlocal commentstring=<!-- %s -->' },
    { 'FileType gomod setlocal commentstring=// %s' },
  },

})


function M.goyo_enter()
  vim.b.quitting = 0
  vim.b.quitting_bang = 0
  api.nvim_command('autocmd QuitPre <buffer> let b:quitting = 1')
  api.nvim_command('cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!')

  vim.opt.relativenumber=false
  vim.opt.number=false
  vim.opt.showmode=false
  vim.opt.showcmd=false
  vim.opt.scrolloff=999

  vim.g.goyo_mode = 1
end

function M.goyo_leave()
  vim.opt.showmode=true
  vim.opt.showcmd=true
  vim.opt.scrolloff=5

  vim.g.goyo_mode = 0

  -- Quit Vim if this is the only remaining buffer
  if vim.b.quitting then
    local windows = api.nvim_list_wins()
    local curtab = api.nvim_get_current_tabpage()
    local wins_in_tabpage = vim.tbl_filter(function(w)
      return api.nvim_win_get_tabpage(w) == curtab
    end, windows)
    if #windows == 1 then

    if vim.b.quitting_bang then
      api.nvim_command(':silent qa!')
    else
      api.nvim_command(':silent qa')
    end
    elseif #wins_in_tabpage == 1 then
      api.nvim_command(':tabclose')
    end
  end
end
vim.api.nvim_command('au! User GoyoEnter nested lua require("tb/autocmds").goyo_enter()')
vim.api.nvim_command('au! User GoyoLeave nested lua require("tb/autocmds").goyo_leave()')

return M
