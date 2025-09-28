local go = {}

local job = require('utils/job')
local cmds = require('utils/commands')

function go.get_struct_name()
  local query = [[(
  (type_declaration
    (type_spec name:(type_identifier) @struct.name type: (struct_type))
  ) @struct.declaration)
  (field_declaration name:(field_identifier) @definition.struct (struct_type)
  )]]

  local ns = require('utils/treesitter').nodes_at_cursor(query)
  if ns == nil then
    error('struct not found')
  end
  return ns[#ns].name
end

function go.add_tags(args)
  local format = args.fargs[1]
  if not format or format == '' then
    format = 'snakecase'
  end
  local tag_types = args.fargs[2]
  if not tag_types or tag_types == '' then
    tag_types = 'json'
  end

  local struct_name = go.get_struct_name()
  local job_args = {
    '-format',
    'json',
    '-file',
    vim.fn.expand('%'),
    '-struct',
    struct_name,
    '-add-tags',
    tag_types,
    -- '-add-options',
    -- tag_types .. '=omitempty',
    '-transform',
    format,
    '--skip-unexported',
  }
  if tag_types == 'json' then
    table.insert(job_args, '-add-options')
    table.insert(job_args, tag_types .. '=omitempty')
  end

  local data = job.run('gomodifytags', job_args, { return_all = true })
  local tagged = vim.fn.json_decode(data)
  if
      tagged == nil
      or tagged.errors ~= nil
      or tagged.lines == nil
      or tagged['start'] == nil
      or tagged['start'] == 0
  then
    print('failed to set tags' .. vim.inspect(tagged))
    return
  end
  vim.api.nvim_buf_set_lines(0, tagged['start'] - 1, tagged['end'], false, tagged.lines)
  vim.cmd('write')
end

function go.clear_tags()
  local struct_name = go.get_struct_name()
  local job_args = {
    '-format',
    'json',
    '-file',
    vim.fn.expand('%'),
    '-struct',
    struct_name,
    '-clear-tags',
  }

  local data = job.run('gomodifytags', job_args, { return_all = true })
  local tagged = vim.fn.json_decode(data)
  if
      tagged == nil
      or tagged.errors ~= nil
      or tagged.lines == nil
      or tagged['start'] == nil
      or tagged['start'] == 0
  then
    print('failed to set tags' .. vim.inspect(tagged))
    return
  end
  vim.api.nvim_buf_set_lines(0, tagged['start'] - 1, tagged['end'], false, tagged.lines)
  vim.cmd('write')
end

function go.run(args)
  local cmd = '!go run . '
  for _, v in ipairs(args.fargs) do
    cmd = cmd .. v .. ' '
  end
  vim.api.nvim_command(cmd)
end

function go.test(args)
  local file_name = args.fargs[1]
  if file_name == '' then
    file_name = '.'
  end
  vim.api.nvim_command('!LOG_PLAIN=true go test -count=1 -v ' .. file_name)
end

function go.add_build_tags(args)
  local tags = args.fargs[1]
  local go_config = require('languages/configs').gopls
  local current_tags = go_config.settings.gopls.buildFlags[1]
  if not current_tags or current_tags == '' then
    current_tags = '-tags='
  elseif tags:sub(1, 1) ~= ',' then
    tags = ',' .. tags
  end
  go_config.settings.gopls.buildFlags = { current_tags .. tags }

  require('languages').update_config('gopls', go_config)
end

function go.set_build_tags(args)
  -- local tags = vim.tbl_flatten(args.fargs[1])
  local tags = args.fargs[1]
  local go_config = require('languages/configs').gopls

  go_config.settings.gopls.buildFlags = { '-tags=' .. tags }

  require('languages').update_config('gopls', go_config)
end

function go.organize_imports()
  local params = vim.lsp.util.make_range_params(0, 'utf-16')
  params['context'] = { only = { 'source.organizeImports' } }
  -- buf_request_sync defaults to a 1000ms timeout. Depending on your
  -- machine and codebase, you may want longer. Add an additional
  -- argument after params if you find that you have to write the file
  -- twice for changes to be saved.
  -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
  local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, 2000)
  for cid, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        local enc = (vim.lsp.get_client_by_id(cid) or {})['offset_encoding'] or 'utf-16'
        vim.lsp.util.apply_workspace_edit(r.edit, enc)
      end
    end
  end
  vim.lsp.buf.format({ async = false })
end

cmds.set_run(go.run)
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.go',
  callback = go.organize_imports,
})
cmds.add({
  { 'BuildTags',    { cmd = go.set_build_tags, opts = { nargs = '+' } } },
  { 'BuildTagsAdd', { cmd = go.add_build_tags, opts = { nargs = '+' } } },
  { 'StructTags',   go.add_tags },
  { 'Test',         { cmd = go.test, { nargs = '?' } } },
  { 'Tidy',         { cmd = '!go mod tidy', { nargs = '?' } } },
  { 'R',            'LspRestart gopls' },
  { 'Imports',      go.organize_imports },
})

return go
