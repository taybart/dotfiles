-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/taylor/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?.lua;/home/taylor/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?/init.lua;/home/taylor/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?.lua;/home/taylor/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/taylor/.cache/nvim/packer_hererocks/2.0.5/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["b64.nvim"] = {
    loaded = true,
    path = "/home/taylor/.local/share/nvim/site/pack/packer/start/b64.nvim"
  },
  ["ctrlsf.vim"] = {
    loaded = true,
    path = "/home/taylor/.local/share/nvim/site/pack/packer/start/ctrlsf.vim"
  },
  firenvim = {
    loaded = true,
    path = "/home/taylor/.local/share/nvim/site/pack/packer/start/firenvim"
  },
  ["gitsigns.nvim"] = {
    loaded = true,
    path = "/home/taylor/.local/share/nvim/site/pack/packer/start/gitsigns.nvim"
  },
  ["goyo.vim"] = {
    loaded = true,
    path = "/home/taylor/.local/share/nvim/site/pack/packer/start/goyo.vim"
  },
  gruvbox = {
    loaded = true,
    path = "/home/taylor/.local/share/nvim/site/pack/packer/start/gruvbox"
  },
  ["lsp-colors.nvim"] = {
    loaded = true,
    path = "/home/taylor/.local/share/nvim/site/pack/packer/start/lsp-colors.nvim"
  },
  neorg = {
    config = { "\27LJ\1\2Ã\2\0\2\a\0\t\0\0167\2\0\1%\3\1\0003\4\6\0002\5\5\0003\6\2\0;\6\1\0053\6\3\0;\6\2\0053\6\4\0;\6\3\0053\6\5\0;\6\4\5:\5\a\0043\5\b\0>\2\4\1G\0\1\0\1\0\2\fnoremap\2\vsilent\2\6n\1\0\0\1\3\0\0\14<C-Space>-core.norg.qol.todo_items.todo.task_cycle\1\3\0\0\bgtp/core.norg.qol.todo_items.todo.task_pending\1\3\0\0\bgtu.core.norg.qol.todo_items.todo.task_undone\1\3\0\0\bgtd,core.norg.qol.todo_items.todo.task_done\tnorg\22map_event_to_moden\1\0\4\0\5\0\b4\0\0\0%\1\1\0>\0\2\0027\1\2\0%\2\3\0001\3\4\0>\1\3\1G\0\1\0\0)core.keybinds.events.enable_keybinds\ron_event\20neorg.callbacks\frequireŠ\1\1\0\4\0\n\0\0154\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\6\0003\2\3\0002\3\0\0:\3\4\0022\3\0\0:\3\5\2:\2\a\0011\2\b\0:\2\t\1>\0\2\1G\0\1\0\thook\0\tload\1\0\0\24core.norg.concealer\18core.defaults\1\0\0\nsetup\nneorg\frequire\0" },
    loaded = true,
    path = "/home/taylor/.local/share/nvim/site/pack/packer/start/neorg"
  },
  ["nvim-colorizer.lua"] = {
    loaded = true,
    path = "/home/taylor/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua"
  },
  ["nvim-compe"] = {
    loaded = true,
    path = "/home/taylor/.local/share/nvim/site/pack/packer/start/nvim-compe"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/taylor/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-lspinstall"] = {
    loaded = true,
    path = "/home/taylor/.local/share/nvim/site/pack/packer/start/nvim-lspinstall"
  },
  ["nvim-tree.lua"] = {
    loaded = true,
    path = "/home/taylor/.local/share/nvim/site/pack/packer/start/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/home/taylor/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["nvim-ts-context-commentstring"] = {
    loaded = true,
    path = "/home/taylor/.local/share/nvim/site/pack/packer/start/nvim-ts-context-commentstring"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/taylor/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/taylor/.local/share/nvim/site/pack/packer/start/packer.nvim"
  },
  playground = {
    loaded = true,
    path = "/home/taylor/.local/share/nvim/site/pack/packer/start/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/taylor/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/home/taylor/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  ["quick-scope"] = {
    loaded = true,
    path = "/home/taylor/.local/share/nvim/site/pack/packer/start/quick-scope"
  },
  ["rest.vim"] = {
    loaded = true,
    path = "/home/taylor/.local/share/nvim/site/pack/packer/start/rest.vim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/home/taylor/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  ["vim-abolish"] = {
    loaded = true,
    path = "/home/taylor/.local/share/nvim/site/pack/packer/start/vim-abolish"
  },
  ["vim-airline"] = {
    loaded = true,
    path = "/home/taylor/.local/share/nvim/site/pack/packer/start/vim-airline"
  },
  ["vim-airline-themes"] = {
    loaded = true,
    path = "/home/taylor/.local/share/nvim/site/pack/packer/start/vim-airline-themes"
  },
  ["vim-commentary"] = {
    loaded = true,
    path = "/home/taylor/.local/share/nvim/site/pack/packer/start/vim-commentary"
  },
  ["vim-fugitive"] = {
    commands = { "Git" },
    loaded = false,
    needs_bufread = true,
    path = "/home/taylor/.local/share/nvim/site/pack/packer/opt/vim-fugitive"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/home/taylor/.local/share/nvim/site/pack/packer/start/vim-repeat"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/home/taylor/.local/share/nvim/site/pack/packer/start/vim-surround"
  },
  ["vim-tmux-navigator"] = {
    loaded = true,
    path = "/home/taylor/.local/share/nvim/site/pack/packer/start/vim-tmux-navigator"
  },
  ["vista.vim"] = {
    loaded = true,
    path = "/home/taylor/.local/share/nvim/site/pack/packer/start/vista.vim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: neorg
time([[Config for neorg]], true)
try_loadstring("\27LJ\1\2Ã\2\0\2\a\0\t\0\0167\2\0\1%\3\1\0003\4\6\0002\5\5\0003\6\2\0;\6\1\0053\6\3\0;\6\2\0053\6\4\0;\6\3\0053\6\5\0;\6\4\5:\5\a\0043\5\b\0>\2\4\1G\0\1\0\1\0\2\fnoremap\2\vsilent\2\6n\1\0\0\1\3\0\0\14<C-Space>-core.norg.qol.todo_items.todo.task_cycle\1\3\0\0\bgtp/core.norg.qol.todo_items.todo.task_pending\1\3\0\0\bgtu.core.norg.qol.todo_items.todo.task_undone\1\3\0\0\bgtd,core.norg.qol.todo_items.todo.task_done\tnorg\22map_event_to_moden\1\0\4\0\5\0\b4\0\0\0%\1\1\0>\0\2\0027\1\2\0%\2\3\0001\3\4\0>\1\3\1G\0\1\0\0)core.keybinds.events.enable_keybinds\ron_event\20neorg.callbacks\frequireŠ\1\1\0\4\0\n\0\0154\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\6\0003\2\3\0002\3\0\0:\3\4\0022\3\0\0:\3\5\2:\2\a\0011\2\b\0:\2\t\1>\0\2\1G\0\1\0\thook\0\tload\1\0\0\24core.norg.concealer\18core.defaults\1\0\0\nsetup\nneorg\frequire\0", "config", "neorg")
time([[Config for neorg]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
if vim.fn.exists(":Git") ~= 2 then
vim.cmd [[command! -nargs=* -range -bang -complete=file Git lua require("packer.load")({'vim-fugitive'}, { cmd = "Git", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
end
time([[Defining lazy-load commands]], false)

if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
