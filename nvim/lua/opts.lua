-- load exrc's from buffer to cwd
local exrc_loaded = {} ---@type table<string, true>
vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
  group = vim.api.nvim_create_augroup('RecursiveExrc', { clear = true }),
  callback = function(ev)
    if vim.bo[ev.buf].buftype ~= '' then return end
    local name = vim.api.nvim_buf_get_name(ev.buf)
    if name == '' then return end

    local cwd = vim.fs.normalize(vim.uv.cwd() or '/')
    local dir = vim.fs.dirname(name)
    -- only files inside the cwd
    if dir ~= cwd and not vim.startswith(dir, cwd .. '/') then return end

    local found = vim.fs.find('.nvim.lua', {
      path = vim.fs.dirname(name),
      upward = true,
      -- stop = vim.uv.os_homedir(),
      stop = vim.fs.dirname(cwd), -- `stop` is exclusive, so use the parent to include cwd itself
      limit = math.huge,
    })
    for i = #found, 1, -1 do -- outermost directory first
      local f = found[i]
      if not exrc_loaded[f] then
        exrc_loaded[f] = true
        local content = vim.secure.read(f)
        if content then
          local chunk, lerr = load(content, '@' .. f)
          if chunk then
            local ok, rerr = pcall(chunk)
            if not ok then vim.notify(f .. ': ' .. rerr, vim.log.levels.ERROR) end
          else
            vim.notify(f .. ': ' .. lerr, vim.log.levels.ERROR)
          end
        end
      end
    end
  end,
})

-- safe modelines: only whitelisted buffer options with validated values
-- (builtin 'modeline' is disabled in init.lua)
local ml_aliases = {
  ft = 'filetype', ts = 'tabstop', sw = 'shiftwidth', sts = 'softtabstop',
  et = 'expandtab', tw = 'textwidth', syn = 'syntax',
}
local ml_kinds = { ---@type table<string, 'name'|'num'|'bool'>
  filetype = 'name', syntax = 'name',
  tabstop = 'num', shiftwidth = 'num', softtabstop = 'num', textwidth = 'num',
  expandtab = 'bool',
}

---@param line string
---@return table<string, any>?
local function parse_modeline(line)
  local rest = line:match('^vim?:%s*(.*)') or line:match('%svim?:%s*(.*)')
  if not rest then return end
  local set_form = rest:match('^set%s+(.-):') or rest:match('^se%s+(.-):')
  local opts = {}
  for item in (set_form or rest):gmatch(set_form and '%S+' or '[^%s:]+') do
    local name, val = item:match('^(%w+)=(.*)$')
    if not name then
      local neg = item:match('^no(%w+)$')
      name, val = neg or item, not neg
    end
    name = ml_aliases[name] or name
    local kind = ml_kinds[name]
    if kind == 'num' and type(val) == 'string' and val:match('^%d+$') then
      opts[name] = tonumber(val)
    elseif kind == 'name' and type(val) == 'string' and val:match('^[%w_.]+$') then
      opts[name] = val
    elseif kind == 'bool' and type(val) == 'boolean' then
      opts[name] = val
    end
  end
  return opts
end

vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('SafeModeline', { clear = true }),
  callback = function(ev)
    -- defer so filetype detection + ftplugins run first and we override them
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(ev.buf) then return end
      local n = vim.api.nvim_buf_line_count(ev.buf)
      local lines = vim.api.nvim_buf_get_lines(ev.buf, 0, math.min(5, n), false)
      if n > 5 then
        vim.list_extend(lines, vim.api.nvim_buf_get_lines(ev.buf, math.max(5, n - 5), n, false))
      end
      local opts = {}
      for _, l in ipairs(lines) do
        for k, v in pairs(parse_modeline(l) or {}) do opts[k] = v end
      end
      -- filetype first, since its ftplugin may reset indent options
      if opts.filetype then
        vim.bo[ev.buf].filetype = opts.filetype
        opts.filetype = nil
      end
      for k, v in pairs(opts) do vim.bo[ev.buf][k] = v end
    end)
  end,
})
