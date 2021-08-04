-- local utils = require("go.utils")

local tags = {}
-- support -add-tags, --add-options, -remove-tags, -remove-options, clear-tags, clear-options
-- for struct and line range
-- gomodifytags -file demo.go -struct Server -add-tags json
-- gomodifytags -file demo.go -struct Server -add-tags json -w
-- gomodifytags -file demo.go -struct Server -add-tags json,xml
-- gomodifytags -file demo.go -struct Server -add-tags json,xml -transform camelcase
-- gomodifytags -file demo.go -line 8,11 -clear-tags xml

local handle_job_data = function(data)
  if not data then
    return nil
  end
  -- Because the nvim.stdout's data will have an extra empty line at end on some OS (e.g. maxOS), we should remove it.
  if data[#data] == '' then
    table.remove(data, #data)
  end
  if #data < 1 then
    return nil
  end
  return data
end

local opts = {
  "-add-tags", "-add-options", "-remove-tags", "-remove-options", "-clear-tags", "-clear-options"
}
local gomodify = "gomodifytags"
local transform = _GO_NVIM_CFG.tag_transfer
tags.modify = function(...)
  require("go.install").install(gomodify)
  local fname = vim.fn.expand("%") -- %:p:h ? %:p
  local row, col = table.unpack(vim.api.nvim_win_get_cursor(0))
  local ns = require("go.ts.go").get_struct_node_at_pos(row, col)
  if ns == nil or ns == {} then
    return
  end

  -- print("parnode" .. vim.inspect(ns))
  local struct_name = ns.name
  local rs, re = ns.dim.s.r, ns.dim.e.r
  setup = {gomodify, "-format", "json", "-file", fname, "-struct", struct_name, '-w'}
  if transform then
    table.insert(setup.args, "-transform")
    table.insert(setup.args, transform)
  end
  local arg = {...}
  for i, v in ipairs(arg) do
    table.insert(setup, v)
  end

  if #arg == 1 and arg[1] ~= "clear-tags" then
    table.insert(setup, "json")
  end
  -- print(vim.inspect(setup))
  local j = vim.fn.jobstart(setup, {
    on_stdout = function(jobid, data, event)
      data = handle_job_data(data)
      if not data then
        return
      end
      local tagged = vim.fn.json_decode(data)
      -- print(vim.inspect(tagged))
      -- print(tagged["start"], tagged["end"], tagged.lines)
      if tagged.errors ~= nil or tagged.lines == nil or tagged["start"] == nil or tagged["start"]
          == 0 then
        print("failed to set tags" .. vim.inspect(tagged))
      end
      vim.api.nvim_buf_set_lines(0, tagged["start"] - 1, tagged["start"] - 1 + #tagged.lines, false,
                                 tagged.lines)
      vim.cmd("write")
      print("struct updated ")
    end
  })
end

tags.add = function(...)
  local cmd = {"-add-tags"}
  local arg = {...}
  for _, v in ipairs(arg) do
    table.insert(cmd, v)
  end
  local _, csrow, _, _ = table.unpack(vim.fn.getpos('.'))
  table.insert(cmd, '-line')
  table.insert(cmd, csrow)
  tags.modify(table.unpack(cmd))
end

tags.rm = function(...)
  local cmd = {"-remove-tags"}
  local arg = {...}
  for _, v in ipairs(arg) do
    table.insert(cmd, v)
  end
  tags.modify(table.unpack(cmd))
end

tags.clear = function()
  local cmd = {"-clear-tags"}
  tags.modify(table.unpack(cmd))
end

return tags
