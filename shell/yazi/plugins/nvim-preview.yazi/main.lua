--- @since 26.8.15
-- Tree-sitter previewer: renders text files with Neovim's highlighting via
-- ~/.config/yazi/nvim-preview/yazi-nvim-preview.sh, and falls back to yazi's
-- built-in `code` previewer when nvim has no parser for the file, the file is
-- too big, or anything goes wrong.

local M = {}

local MAX_BYTES = 512 * 1024 -- bigger files go straight to `code`
local EXIT_UNSUPPORTED = 3 -- dump.lua: no parser/highlights query

local function script()
	local dir = os.getenv("YAZI_CONFIG_HOME") or (os.getenv("HOME") .. "/.config/yazi")
	return dir .. "/nvim-preview/yazi-nvim-preview.sh"
end

local function theme()
	local light = rt.term.light()
	return light == true and "light" or light == false and "dark" or ""
end

local function fallback(job) return require("code"):peek(job) end

function M:peek(job)
	local len = job.file.cha and job.file.cha.len
	if len and len > MAX_BYTES then
		return fallback(job)
	end

	local out, err = Command(script())
		:arg({ tostring(job.file.path) })
		:env("NVIM_PREVIEW_BG", theme())
		:stdout(Command.PIPED)
		:stderr(Command.PIPED)
		:output()

	if not out then
		ya.dbg("nvim-preview: spawn failed: " .. tostring(err))
		return fallback(job)
	elseif not out.status.success then
		if out.status.code ~= EXIT_UNSUPPORTED then
			ya.dbg("nvim-preview: exit " .. tostring(out.status.code) .. ": " .. out.stderr)
		end
		return fallback(job)
	end

	local limit = job.area.h
	local i, lines = 0, {}
	for line in out.stdout:gmatch("[^\n]*\n") do
		i = i + 1
		if i > job.skip then
			lines[#lines + 1] = line
		end
		if i >= job.skip + limit then
			break
		end
	end

	if job.skip > 0 and i < job.skip + limit then
		-- scrolled past the end: snap back to the last full page
		ya.emit("peek", { math.max(0, i - limit), only_if = job.file.url, upper_bound = true })
	else
		local s = table.concat(lines):gsub("\t", string.rep(" ", rt.preview.tab_size))
		ya.preview_widget(job, ui.Text.parse(s):area(job.area))
	end
end

function M:seek(job) require("code"):seek(job) end

return M
