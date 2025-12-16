local go = {}

local function get_struct_name()
  local node = vim.treesitter.get_node()
  while node do
    if node:type() == 'type_spec' then
      local name_node = node:child(0)
      if name_node and name_node:type() == 'type_identifier' then
        return vim.treesitter.get_node_text(name_node, 0)
      end
    end
    node = node:parent()
  end
end

local function gomodifytags(args)
  -- stylua: ignore
  local data = require('tools/job').run('gomodifytags', vim.list_extend({
    '-format', 'json',
    '-file', vim.fn.expand('%'),
    '-struct', get_struct_name(),
  }, args or {}), { return_all = true })
  if not data then return end
  local tagged = vim.fn.json_decode(data)
  if
      tagged == nil
      or tagged.errors ~= nil
      or tagged.lines == nil
      or tagged.start == nil
      or tagged.start == 0
  then
    error('failed to set tags' .. vim.inspect(tagged))
    return
  end
  vim.api.nvim_buf_set_lines(0, tagged['start'] - 1, tagged['end'], false, tagged.lines)
  vim.cmd('write')
end

local function add_tags(args)
  if args.fargs[1] == 'clear' then return gomodifytags({ '-clear-tags' }) end

  local format = args.fargs[1] or 'snakecase'
  local tag_types = args.fargs[2] or 'json'
  -- stylua: ignore
  local valid_formats = {
    'snakecase', 'camelcase', 'lispcase',
    'pascalcase', 'titlecase', 'keep',
  }
  if not vim.tbl_contains(valid_formats, format) then
    vim.print('formats: ', valid_formats)
    return
  end

  -- stylua: ignore
  local job_args = {
    '-transform', format,
    '-add-tags', tag_types,
    '--skip-unexported',
  }

  if tag_types == 'json' then
    table.insert(job_args, '-add-options')
    table.insert(job_args, tag_types .. '=omitempty')
  end
  return gomodifytags(job_args)
end

local function run(args)
  local cmd = '!go run . '
  for _, v in ipairs(args.fargs) do
    cmd = cmd .. v .. ' '
  end
  vim.api.nvim_command(cmd)
end

local function test(args)
  local file_name = args.fargs[1]
  if file_name == '' then file_name = '.' end
  vim.api.nvim_command('!LOG_PLAIN=true go test -count=1 -v ' .. file_name)
end

local function add_build_tags(args)
  local tags = args.fargs[1]
  for _, client in ipairs(vim.lsp.get_clients({ name = 'gopls' })) do
    local current_tags = client.settings.gopls.buildFlags[1]
    if not current_tags or current_tags == '' then
      current_tags = '-tags='
    elseif tags:sub(1, 1) ~= ',' then
      tags = ',' .. tags
    end
    ---@diagnostic disable-next-line: inject-field
    client.settings.gopls.buildFlags = { current_tags .. tags }
    client:notify('workspace/didChangeConfiguration', { settings = client.settings })
  end
end

local function set_build_tags(args)
  local tags = args.fargs[1]
  for _, client in ipairs(vim.lsp.get_clients({ name = 'gopls' })) do
    ---@diagnostic disable-next-line: inject-field
    client.settings.gopls.buildFlags = { '-tags=' .. tags }
    client:notify('workspace/didChangeConfiguration', { settings = client.settings })
  end
end

local function organize_imports()
  local params = vim.lsp.util.make_range_params(0, 'utf-16')
  params['context'] = { only = { 'source.organizeImports' } }
  -- Change timeout to 5 seconds because this will only be run synchronously when conform timesout
  local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, 5000)
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

local cmds = require('tools/commands')
cmds.set_run(run)
cmds.add({
  { 'BuildTags',    { cmd = set_build_tags, opts = { nargs = '+' } } },
  { 'BuildTagsAdd', { cmd = add_build_tags, opts = { nargs = '+' } } },
  { 'StructTags',   add_tags },
  { 'Test',         { cmd = test, { nargs = '?' } } },
  { 'Tidy',         { cmd = '!go mod tidy', { nargs = '?' } } },
  { 'R',            'LspRestart gopls' },
  { 'Imports',      organize_imports },
})
