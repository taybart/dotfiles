-- golines A golang formatter that fixes long lines
-- golines + gofumports(stricter gofmt + goimport)
local api = vim.api
local max_len = _GO_NVIM_CFG.max_len or 120

local goimport_args = _GO_NVIM_CFG.goimport_args and _GO_NVIM_CFG.goimport_args
                          or {"--max-len=" .. tostring(max_len), "--base-formatter=" .. goimport}

local run = function(args, from_buffer)

  if not from_buffer then
    table.insert(args, api.nvim_buf_get_name(0))
    print('formatting... ' .. api.nvim_buf_get_name(0) .. vim.inspect(args))
  end

  local old_lines = api.nvim_buf_get_lines(0, 0, -1, true)
  table.insert(args, 1, "golines")
end

local M = {}
M.OrgImports = function(wait_ms)
  local params = vim.lsp.util.make_range_params()
  params.context = {only = {"source.organizeImports"}}
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit)
      else
        vim.lsp.buf.execute_command(r.command)
      end
    end
  end
  vim.lsp.buf.formatting()
end

M.goimport = function(buf)
  if _GO_NVIM_CFG.goimport == 'gopls' then
    M.OrgImports(1000)
    return
  end
  buf = buf or false
  require("go.install").install(goimport)
  require("go.install").install("golines")
  local a = {}
  utils.copy_array(goimport_args, a)
  run(a, buf)
end

return M
