local M = {}

function M.handle_data(data)
  if not data then
    return nil
  end
  if data[#data] == '' then
    table.remove(data, #data)
  end
  if #data < 1 then
    return nil
  end
  return data
end

function M.run(cmd, args, opts)
  local ret
  require('plenary.job')
    :new({
      command = cmd,
      args = args,
      on_exit = function(j, return_val)
        if return_val ~= 0 then
          print('issue running command', vim.inspect(j.result()), vim.inspect(return_val))
        end
        if opts.return_all then
          ret = j:result()
        else
          ret = j:result()[1]
        end
      end,
    })
    :sync(opts.timeout)
  return ret
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

  require('utils/job').run(opener, args)
end

return M
