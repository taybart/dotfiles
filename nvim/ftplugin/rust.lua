local function run(args)
  local file_name = args.fargs[1]
  if file_name == '' or file_name == nil then file_name = '.' end
  vim.api.nvim_command('!cargo run ' .. file_name)
end

local function test(args)
  local file_name = args.fargs[1]
  if file_name == '' or file_name == nil then file_name = '.' end
  vim.api.nvim_command('!cargo test ' .. file_name)
end

local function split(inputstr, sep)
  if sep == nil then sep = '%s' end
  local t = {}
  for str in string.gmatch(inputstr, '([^' .. sep .. ']+)') do
    table.insert(t, str)
  end
  return t
end

local function cfg_features(args)
  for _, client in ipairs(vim.lsp.get_clients({ name = 'rust_analyzer' })) do
    if client == nil then
      print('no rust_analyzer client found')
      return
    end
    local config = client.config.settings['rust-analyzer']
    if config == nil then config = {} end
    ---@diagnostic disable-next-line: inject-field
    if config.cargo == nil then config.cargo = {} end
    -- reset them just in case there weren't any passed
    config.cargo.features = {}

    local features = args.fargs[1]
    if features ~= nil then config.cargo.features = split(features, ',') end
    client:notify('workspace/didChangeConfiguration', { settings = config })
  end
end

local cmds = require('tools/commands')
cmds.set_run(run)
cmds.add({
  { 'Test',     { cmd = test, opts = { nargs = '?' } } },
  { 'Features', { cmd = cfg_features } },
})
