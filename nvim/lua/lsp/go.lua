local go = {}

local run_job = require('utils/job').run_job

require('utils').create_augroups({
	go_lsp = {
		-- TODO add fuzzy finder from history list with no arguments
		{ 'FileType', 'go', 'command! -nargs=+ BuildTags lua require("lsp/go").set_build_tags(<f-args>)' },
		{ 'FileType', 'go', 'command! -nargs=+ BuildTagsAdd lua require("lsp/go").add_build_tags(<f-args>)' },
		{ 'FileType', 'go', 'command! -nargs=* StructTags lua require("lsp/go").add_tags(<f-args>)' },
		{ 'FileType', 'go', 'command! -nargs=? Run lua require("lsp/go").run(<f-args>)' },
		{ 'BufWritePre', '*.go', 'lua require("lsp/go").on_save()' },
	},
})

function go.install_deps()
	run_job('go', { 'install', 'github.com/fatih/gomodifytags@latest' })
	run_job('go', { 'install', 'github.com/jstemmer/gotags@latest' })
end

function go.add_tags(tag_types, format)
	tag_types = tag_types or 'json'
	format = format or 'snakecase'

	local query = [[
  ((type_declaration
  (type_spec name:(type_identifier) @struct.name
  type: (struct_type))) @struct.declaration)
  (field_declaration name:(field_identifier) @definition.struct (struct_type))
  ]]

	local ns = require('utils/treesitter').nodes_at_cursor(query)
	if ns == nil then
		error('struct not found')
	end

	local struct_name = ns[#ns].name
	local data = require('utils/job').run_job('gomodifytags', {
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
	}, true)
	local tagged = vim.fn.json_decode(data)
	if tagged.errors ~= nil or tagged.lines == nil or tagged['start'] == nil or tagged['start'] == 0 then
		print('failed to set tags' .. vim.inspect(tagged))
		return
	end
	vim.api.nvim_buf_set_lines(0, tagged['start'] - 1, tagged['end'], false, tagged.lines)
	vim.cmd('write')
end

function go.run(file_name)
	if not file_name then
		file_name = '.'
	end
	vim.api.nvim_command('!go run ' .. file_name)
end

function go.add_build_tags(tags)
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

function go.set_build_tags(tags)
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
				vim.lsp.util.apply_workspace_edit(r.edit)
			else
				vim.lsp.buf.execute_command(r.command)
			end
		end
	end
	vim.lsp.buf.formatting_sync()
end

return go
