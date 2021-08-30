
vim.cmd [[ autocmd! CursorHold,CursorHoldI * lua require('tb/plugins/lightbulb').update() ]]

return {
  setup = function()
  end,
  update = function()
    require('nvim-lightbulb').update_lightbulb({
      sign = {enable = false},
      float = {enable = false},
      virtual_text = {enable = true},
    })
  end,
}
