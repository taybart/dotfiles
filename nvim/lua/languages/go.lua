local go = {}

local job = require('utils/job')
local au = require('utils/augroup')

function go.install_deps()
  job.run('go', { 'install', 'github.com/fatih/gomodifytags@latest' })
  job.run('go', { 'install', 'github.com/jstemmer/gotags@latest' })
end

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
  -- local file_name = args.fargs[1]
  -- if file_name == '' or file_name == nil then
  --   file_name = '.'
  -- end
  -- vim.api.nvim_command('!go run ' .. file_name)
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
  local go_config = require('languages/lspconfig').gopls
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
  local go_config = require('languages/lspconfig').gopls

  go_config.settings.gopls.buildFlags = { '-tags=' .. tags }

  require('languages').update_config('gopls', go_config)
end

function go.organize_imports()
  -- pcall(function()
  --   vim.lsp.buf.format()
  --   vim.lsp.buf.code_action({
  --     context = {
  --       only = { 'source.organizeImports' },
  --     },
  --     apply = true,
  --   })
  -- end)
  -- have to check if we need to organize imports to prevent "No Code Actions Available" notification spam
  vim.lsp.buf.format()

  -- Check for organize imports code action
  local params = vim.lsp.util.make_range_params(0, 'utf-8')
  ---@diagnostic disable-next-line: inject-field
  params.context = {
    only = { 'source.organizeImports' },
    diagnostics = {},
  }

  local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, 1000)
  if result then
    for _, res in pairs(result) do
      if res.result and #res.result > 0 then
        for _, action in pairs(res.result) do
          -- Check if the action is source.organizeImports
          if
              action.kind == 'source.organizeImports'
              or (action.title and action.title:match('organize imports'))
          then
            vim.lsp.buf.code_action({
              context = {
                only = { 'source.organizeImports' },
              },
              apply = true,
            })
            return
          end
        end
      end
    end
  end
end

au.create({
  go_lsp = {
    {
      event = 'BufWritePre',
      pattern = '*.go',
      callback = go.organize_imports,
    },
    au.ft_cmd('gomod', {
      callback = function()
        vim.bo.commentstring = '// %s'
      end,
    }),
    au.ft_cmd('go', {
      run_cmd = go.run,
      commands = {
        { name = 'BuildTags',    cmd = go.set_build_tags,  opts = { nargs = '+' } },
        { name = 'BuildTagsAdd', cmd = go.add_build_tags,  opts = { nargs = '+' } },
        { name = 'StructTags',   cmd = go.add_tags },
        { name = 'Test',         cmd = go.test,            { nargs = '?' } },
        { name = 'Tidy',         cmd = '!go mod tidy',     { nargs = '?' } },
        { name = 'R',            cmd = 'LspRestart gopls' },
        { name = 'Imports',      cmd = go.organize_imports },
      },
    }),
  },
})

return go
