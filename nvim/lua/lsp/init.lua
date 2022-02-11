local M = {}

local lspconfig = require('lspconfig')

local u = require('utils/maps')

require('lsp/go')
require('lsp/lua')
require('lsp/matlab')

-- Set keymap if attached
-- local on_attach = function(client)
local on_attach = function()
	u.mode_map_group('n', {
		{ 'gD', ':lua vim.lsp.buf.declaration()<CR>' },
		{ 'gd', ':lua vim.lsp.buf.definition()<CR>' },
		{ 'gi', ':lua vim.lsp.buf.implementation()<CR>' },
		{ 'K', ':lua vim.lsp.buf.hover()<CR>' },
		{ '[d', ':lua vim.diagnostic.goto_next()<CR>' },
		{ ']d', ':lua vim.diagnostic.goto_prev()<CR>' },
		{ 'E', ':lua vim.diagnostic.open_float()<CR>' },
		{ 'ca', ':lua vim.lsp.buf.code_action()<CR>' },
	}, { noremap = true, silent = true })

	vim.cmd([[
    command! Format lua vim.lsp.buf.formatting_seq_sync()
    augroup formatting
    autocmd!
    autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
    let ftToIgnore = ['go','lua']
    autocmd BufWritePre * if index(ftToIgnore, &ft) < 0 | lua vim.lsp.buf.formatting_seq_sync()
    augroup end
    ]])
	--[[ if client.resolved_capabilities.document_formatting then
    vim.cmd(" command! Format lua vim.lsp.buf.formatting()")
  elseif client.resolved_capabilities.document_range_formatting then
    vim.cmd(" command! Format lua vim.lsp.buf.range_formatting()")
  end ]]
end

local function make_base_config()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
	return { capabilities = capabilities, on_attach = on_attach }
end

-- LSP Setup
local function setup()
	local lsp_configs = require('lsp/config')

	for lsp, lsp_config in pairs(lsp_configs) do
		local config = vim.tbl_deep_extend('force', make_base_config(), lsp_config)
		lspconfig[lsp].setup(config)
	end
end

function M.update_config(lang, update)
	local config = make_base_config()
	config = vim.tbl_deep_extend('force', config, update)
	lspconfig[lang].setup(config)
	vim.cmd('bufdo e')
end

setup()

-- LSP looks
vim.fn.sign_define('DiagnosticsSignError', { text = '✗', texthl = 'GruvboxRed' })
vim.fn.sign_define('DiagnosticsSignWarning', { text = '', texthl = 'GruvboxYellow' })
vim.fn.sign_define('DiagnosticsSignInformation', { text = '', texthl = 'GruvboxBlue' })
vim.fn.sign_define('DiagnosticsSignHint', { text = '', texthl = 'GruvboxAqua' })

vim.cmd('command! -nargs=? Rename lua require("lsp").rename(<f-args>)')
function M.rename(new_name)
	if not new_name then
		new_name = vim.fn.input('to -> ')
	end

	if vim.lsp.buf.server_ready() then
		local position_params = vim.lsp.util.make_position_params()
		position_params.newName = new_name
		vim.lsp.buf_request(0, 'textDocument/rename', position_params)
	else
		local orig = vim.fn.expand('<cword>')
		local lookahead = require('nvim-treesitter.configs').get_module('textobjects.select').lookahead
		local bufnr, to = require('nvim-treesitter.textobjects.shared').textobject_at_point(
			'@function.outer',
			nil,
			nil,
			{ lookahead = lookahead }
		)

		if to then
			local r = {}
			local lines = vim.api.nvim_buf_get_lines(0, to[1], to[3], true)
			for _, line in pairs(lines) do
				table.insert(r, vim.fn.substitute(line, orig, new_name, 'g'))
			end
			vim.api.nvim_buf_set_lines(bufnr, to[1], to[3], true, r)
		end
	end
end

return M
