local go = {}

vim.cmd[[
" TODO add fuzzy finder from history list with no arguments
command! -nargs=+ GoTags lua require("tb/lsp/go").set_build_tags(<f-args>)
]]

require('tb/utils').create_augroups({
  go_lsp = {
    { 'FileType', 'go', 'command! Run !go run %' },
    { 'FileType', 'go', 'command! RunAll !go run *.go' },
    {'BufWritePre', '*.go', 'lua require("tb/lsp/go").organize_imports_sync()'},
  },
})


function go.set_build_tags (tags)
  local go_config = require('tb/lsp/config').go

  go_config.settings.gopls.buildFlags = {"-tags="..tags}

  require('tb/lsp').reload("go", go_config)
end


function go.organize_imports_sync()
  local params = vim.lsp.util.make_range_params()
  params.context = {only = {"source.organizeImports"}}
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 500)
  if (result ~= nil) then
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
end

return go
