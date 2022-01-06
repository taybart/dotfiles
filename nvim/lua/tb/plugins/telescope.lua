local M = {}

local builtin = require("telescope.builtin")

function M.setup()
  local previewers = require("telescope.previewers")
  local Job = require("plenary.job")
  local new_maker = function(filepath, bufnr, opts)
    filepath = vim.fn.expand(filepath)
    Job:new({
      command = "file",
      args = { "--mime-type", "-b", filepath },
      on_exit = function(j)
        local mime_type = vim.split(j:result()[1], "/")[1]
        if mime_type == "text" then
          previewers.buffer_previewer_maker(filepath, bufnr, opts)
        else
          -- maybe we want to write something to the buffer here
          vim.schedule(function()
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
          end)
        end
      end
    }):sync()
  end
  require('telescope').setup({
    defaults = {
      buffer_previewer_maker = new_maker,
      file_ignore_patterns = { "node_modules", ".git" },
      borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
      layout_config = {
        height = 0.9,
        preview_width = 60,
        width = 0.9,
      },
      prompt_prefix = ' ',
      selection_caret = '❯ ',
    },
    pickers = {
      find_files = { hidden = true },
    },
  })
  -- require('telescope').load_extension('fzf')
end

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
