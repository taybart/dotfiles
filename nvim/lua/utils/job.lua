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

return M
