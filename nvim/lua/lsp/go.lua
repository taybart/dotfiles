local go = {}

local job = require('utils/job')

function go.install_deps()
  job.run('go', { 'install', 'github.com/fatih/gomodifytags@latest' })
  job.run('go', { 'install', 'github.com/jstemmer/gotags@latest' })
end

function go.add_tags(args)
  local tag_types = args.fargs[1]
  if not tag_types or tag_types == '' then
    tag_types = 'json'
  end
  local format = args.fargs[2]
  if not format or format == '' then
    format = 'snakecase'
  end

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

  local struct_name = ns[#ns].name
  local data = job.run('gomodifytags', {
    '-format',
    'json',
    '-file',
    vim.fn.expand('%'),
    '-struct',
    struct_name,
    '-add-tags',
    tag_types,
    '-add-options',
    tag_types .. '=omitempty',
    '-transform',
    format,
    '--skip-unexported',
  }, { return_all = true })
  local tagged = vim.fn.json_decode(data)
  if
    tagged.errors ~= nil
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
  local file_name = args.fargs[1]
  if file_name == '' then
    file_name = '.'
  end
  vim.api.nvim_command('!go run ' .. file_name)
end

function go.test(args)
  local file_name = args.fargs[1]
  if file_name == '' then
    file_name = '.'
  end
  vim.api.nvim_command('!LOG_PLAIN=true go test -count=1 -v ' .. file_name)
end

function go.add_build_tags(args)
  local tags = vim.tbl_flatten(args.fargs)
  local go_config = require('lsp/config').gopls
  local current_tags = go_config.settings.gopls.buildFlags[1]
  if not current_tags or current_tags == '' then
    current_tags = '-tags='
  elseif tags:sub(1, 1) ~= ',' then
    tags = ',' .. tags
  end
  go_config.settings.gopls.buildFlags = { current_tags .. tags }

  require('lsp').update_config('gopls', go_config)
end

function go.set_build_tags(args)
  local tags = vim.tbl_flatten(args.fargs)
  local go_config = require('lsp/config').gopls

  go_config.settings.gopls.buildFlags = { '-tags=' .. tags }

  require('lsp').update_config('gopls', go_config)
end

function go.on_save()
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { 'source.organizeImports' } }
  local action = 'textDocument/codeAction'
  local result = vim.lsp.buf_request_sync(0, action, params, 500)
  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit, 'UTF-8')
      else
        vim.lsp.buf.execute_command(r.command)
      end
    end
  end
  vim.lsp.buf.formatting_sync()
end

require('utils').create_augroups({
  go_lsp = {
    {
      event = 'BufWritePre',
      pattern = '*.go',
      callback = go.on_save,
    },
    {
      event = 'FileType',
      pattern = 'go',
      callback = function()
        vim.api.nvim_create_user_command('BuildTags', go.set_build_tags, { nargs = '+' })
        vim.api.nvim_create_user_command('BuildTagsAdd', go.add_build_tags, { nargs = '+' })
        vim.api.nvim_create_user_command('StructTags', go.add_tags, { nargs = '*' })
        vim.api.nvim_create_user_command('Run', go.run, { nargs = '?' })
        vim.api.nvim_create_user_command('Test', go.test, { nargs = '?' })
        vim.api.nvim_create_user_command('Tidy', function()
          vim.api.nvim_command('!go mod tidy')
        end, { nargs = '?' })
      end,
    },
  },
})

return go
