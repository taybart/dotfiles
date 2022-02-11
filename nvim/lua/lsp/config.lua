local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

return {
	clangd = {},
	gopls = {
		settings = {
			gopls = {
				buildFlags = { '-tags=' },
				analyses = {
					unusedparams = true,
				},
				staticcheck = true,
			},
		},
	},
	rust_analyzer = {},
	tsserver = {},
	sumneko_lua = require('lua-dev').setup({
		lspconfig = {
			cmd = { vim.fn.stdpath('data') .. '/lua-language-server/bin/lua-language-server' },
			settings = {
				Lua = {
					runtime = {
						version = 'LuaJIT',
						path = runtime_path,
					},
					telemetry = {
						enable = false,
					},
					diagnostics = {
						globals = { 'vim', 'hs' },
					},
					workspace = {
						library = {
							[vim.fn.stdpath('config') .. '/lua'] = true,
							[vim.fn.stdpath('config') .. '/lua/vim/lsp'] = true,
							['/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/'] = true,
							[vim.fn.expand('$HOME/.hammerspoon/Spoons/EmmyLua.spoon/annotations')] = true,
						},
					},
				},
			},
		},
	}),
}
