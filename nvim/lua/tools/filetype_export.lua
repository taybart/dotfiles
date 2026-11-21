-- Record every vim.filetype.add() and vim.treesitter.language.register() call
-- (from this config and from plugins' plugin/ files) and write the
-- string-valued mappings to stdpath('state')/filetypes.json on startup. Tools that run a minimal nvim
-- (the yazi tree-sitter previewer) load that file, so custom filetypes only
-- need to be registered in one place.
--
-- Must be required before lazy.setup() so it sees every call.

local M = {}

M.path = vim.fn.stdpath('state') .. '/filetypes.json'

local recorded = { extension = {}, filename = {}, pattern = {} }

-- Keep only values that survive JSON: 'ft' or { 'ft', { priority = n } }.
-- Function mappings are skipped.
local function plain(v)
  if type(v) == 'string' then return v end
  if type(v) == 'table' and type(v[1]) == 'string' then
    local opts = type(v[2]) == 'table' and { priority = tonumber(v[2].priority) } or nil
    return { v[1], opts }
  end
end

local add = vim.filetype.add
---@diagnostic disable-next-line: duplicate-set-field -- intentional wrapper
vim.filetype.add = function(filetypes)
  for kind, entries in pairs(filetypes or {}) do
    if recorded[kind] and type(entries) == 'table' then
      for k, v in pairs(entries) do
        recorded[kind][k] = plain(v)
      end
    end
  end
  return add(filetypes)
end

-- Also record which tree-sitter parser each custom filetype uses
-- (e.g. rest.nvim: language.register('hcl', 'rest')).
local languages = {} -- filetype -> parser lang
local register = vim.treesitter.language.register
---@diagnostic disable-next-line: duplicate-set-field -- intentional wrapper
vim.treesitter.language.register = function(lang, filetype)
  for _, ft in ipairs(type(filetype) == 'table' and filetype or { filetype }) do
    if type(ft) == 'string' then languages[ft] = lang end
  end
  return register(lang, filetype)
end

local function write()
  local ok, json = pcall(vim.json.encode, { filetype = recorded, treesitter = languages })
  if not ok then return end
  local f = io.open(M.path, 'r')
  local old = f and f:read('*a')
  if f then f:close() end
  if old == json then return end
  vim.fn.mkdir(vim.fn.fnamemodify(M.path, ':h'), 'p')
  f = io.open(M.path, 'w')
  if f then
    f:write(json)
    f:close()
  end
end

vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  desc = 'export custom filetypes for external previewers',
  callback = function() vim.schedule(write) end,
})

return M
