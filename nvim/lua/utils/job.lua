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

function M.run_job(cmd, args, takeAll)
  local ret
  require('plenary.job')
    :new({
      command = cmd,
      args = args,
      on_exit = function(j, return_val)
        if return_val ~= 0 then
          print('could not get remote url')
        end
        if takeAll then
          ret = j:result()
        else
          ret = j:result()[1]
        end
      end,
    })
    :sync()
  return ret
end

return M
