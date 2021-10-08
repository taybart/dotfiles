local go = {}

require('tb/utils').create_augroups({
  go_lsp = {
    -- TODO add fuzzy finder from history list with no arguments
    { 'FileType', 'go', 'command! -nargs=+ GoTags lua require("tb/lsp/go").set_build_tags(<f-args>)' },
    { 'FileType', 'go', 'command! -nargs=* GoAddTags lua require("tb/lsp/go").add_tags(<f-args>)' },
    { 'FileType', 'go', 'command! -nargs=? Run lua require("tb/lsp/go").run(<f-args>)' },
    { 'BufWritePre', '*.go', 'lua require("tb/lsp/go").on_save()' },
  },
})


function go.install_deps()
  vim.fn.jobstart('go install github.com/fatih/gomodifytags@latest')
  vim.fn.jobstart('go install github.com/jstemmer/gotags@latest')
end


function go.add_tags(tag_types, format)
  tag_types = tag_types or "json"

  if format == "camelcase" then
    format = "fieldName={field}"
  elseif format == "lispcase" then
    format = "field-name={field}"
  elseif format == "pascalcase" then
    format = "FieldName={field}"
  else -- default snake
    format = "field_name={field}"
  end
  local query = [[
  ((type_declaration
  (type_spec name:(type_identifier) @struct.name
  type: (struct_type))) @struct.declaration)
  (field_declaration name:(field_identifier) @definition.struct (struct_type))
  ]]

  local ns = require('tb/utils/ts').nodes_at_cursor(query)
  if ns == nil then
    error("struct not found")
  end

  local struct_name = ns[#ns].name
  local modify = {
    "gomodifytags",
    "-format", "json",
    "-file", vim.fn.expand("%"),
    "-struct", struct_name,
    "-add-tags", tag_types,
    "-add-options", tag_types.."=omitempty",
    -- "-template", format,
    "--skip-unexported",
  }
  vim.fn.jobstart(modify, {
    on_stdout = function(_, data)
      data = require('tb/utils/job').handle_data(data)
      if not data then
        return
      end
      local tagged = vim.fn.json_decode(data)
      if tagged.errors ~= nil or
        tagged.lines == nil or
        tagged["start"] == nil or
        tagged["start"] == 0 then
        print("failed to set tags" .. vim.inspect(tagged))
      end
      vim.api.nvim_buf_set_lines(0,
      tagged["start"] - 1, tagged["start"] - 1 + #tagged.lines,
      false, tagged.lines)
      vim.cmd("write")
    end
  })
end

function go.run(file_name)
  if not file_name then
    file_name = '*.go'
  end
  vim.api.nvim_command('!go run '..file_name)
end

function go.set_build_tags(tags)
  local go_config = require('tb/lsp/config').go

  go_config.settings.gopls.buildFlags = {"-tags="..tags}

  require('tb/lsp').update_config("go", go_config)
end

function go.on_save()
  local params = vim.lsp.util.make_range_params()
  params.context = {only = {"source.organizeImports"}}
  local action = "textDocument/codeAction"
  local result = vim.lsp.buf_request_sync(0, action, params, 500)
  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit)
      else
        vim.lsp.buf.execute_command(r.command)
      end
    end
  end
  vim.lsp.buf.formatting_sync()
end

return go
