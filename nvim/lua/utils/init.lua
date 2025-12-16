local M = {}

function M.is_root()
  local output = vim.fn.systemlist('id -u')
  return ((output[1] or '') == '0')
end

-- TODO: unused, remove
M.jumps_to_qf = function()
  local jumplist, _ = unpack(vim.fn.getjumplist())
  local qf_list = {}
  for _, v in pairs(jumplist) do
    if vim.fn.bufloaded(v.bufnr) == 1 then
      table.insert(qf_list, {
        bufnr = v.bufnr,
        lnum = v.lnum,
        col = v.col,
        text = vim.api.nvim_buf_get_lines(v.bufnr, v.lnum - 1, v.lnum, false)[1],
      })
    end
  end
  vim.fn.setqflist(qf_list, ' ')
  vim.cmd('copen')
end

return M
