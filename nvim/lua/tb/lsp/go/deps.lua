local M = {}

local uv = vim.loop
local DIR_SEP = package.config:sub(1, 1)

local url = {
  gomodifytags = "github.com/fatih/gomodifytags",
}

local function is_installed(bin)
  local env_path = os.getenv("PATH")
  local base_paths = vim.split(env_path, ":", true)

  for _, value in pairs(base_paths) do
    if uv.fs_stat(value .. DIR_SEP .. bin) then
      return true
    end
  end
  return false
end

function M.install(pkg)
  if not is_installed(pkg) then
    print("installing " .. pkg)
    local u = url[pkg]
    if u == nil then
      print("command " .. pkg .. " not supported, please update install.lua, or manually install it")
      return
    end

    u = u .. "@latest"
    local setup = {"go", "install", u}

    vim.fn.jobstart(setup, {
      on_stdout = function(_, data, _)
        print(data)
      end
    })
  end
end

return M
