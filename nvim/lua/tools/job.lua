local M = {}

function M.handle_data(data)
  if not data then return nil end
  if data[#data] == '' then table.remove(data, #data) end
  if #data < 1 then return nil end
  return data
end

function M.run(cmd, args, opts)
  opts = opts or {}

  local result = vim
      .system(vim.list_extend({ cmd }, args), { text = true }, function(obj)
        if obj.code ~= 0 then
          print('issue running command')
          if obj.stdout ~= '' then vim.print('stdout:', obj.stdout) end
          if obj.stderr ~= '' then vim.print('stderr:', obj.stderr) end
          vim.print('exit code:', obj.code)
        end
      end)
      :wait(opts.timeout or 30000)

  if result.code ~= 0 then return nil end

  local output = vim.split(result.stdout, '\n', { trimempty = true })
  return opts.return_all and output or output[1]
end

function M.open(args)
  local opener = ''
  if vim.fn.has('mac') == 1 then
    opener = 'open'
  elseif vim.fn.has('unix') then
    opener = 'xdg-open'
  else
    print('unknown os')
    return
  end

  require('tools/job').run(opener, args)
end

return M
