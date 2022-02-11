----------------------------------
------------- Looks --------------
----------------------------------

local M = {}

vim.opt.background = 'dark' -- or "light" for light mode
vim.g.gruvbox_italic = 1
vim.g.gruvbox_sign_column = 'bg0'
vim.cmd('colorscheme gruvbox')

vim.g.markdown_fenced_languages = {
	'html',
	'python',
	'sh',
	'bash=sh',
	'shell=sh',
	'go',
	'javascript',
	'js=javascript',
	'typescript',
	'ts=typescript',
	'py=python',
}

vim.cmd([[
hi! link TelescopePromptBorder GruvboxBg4
hi! link TelescopeResultsBorder GruvboxBg4
hi! link TelescopePreviewBorder GruvboxBg4
]])

function M.toggle_num(rel_on)
	if vim.bo.ft == '' then
		return
	end

	local re = vim.regex('tagbar\\|NvimTree\\|vista\\|packer')
	if re:match_str(vim.bo.ft) then
		vim.opt.number = false
		return
	end

	vim.opt.number = true
	vim.opt.relativenumber = rel_on
end

return M
