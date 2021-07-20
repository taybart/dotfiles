local M = {}

local builtin = require("telescope.builtin")

function M.edit_config()
  builtin.find_files({
    search_dirs = {"~/.dotfiles/nvim/lua"},
  })
end

function M.search_cword()
  local word = vim.fn.expand("<cword>")
  builtin.grep_string({search = word})
end

function M.search_selection()
  local reg_cache = vim.fn.getreg(0)
	-- Reselect the visual mode text, cut to reg b
	vim.cmd('normal! gv"0y')
  builtin.grep_string({search = vim.fn.getreg(0)})
  vim.fn.setreg(0, reg_cache)
end

return M
