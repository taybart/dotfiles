local chooser = {}
-- (ab)use hs.chooser as a text input with the possibility of using other options
function chooser.show(items, callback)
  local ch = nil
  ch = hs.chooser.new(function(item)
    if item then
      callback(item.text)
    end
    if ch then
      ch:delete()
    end
  end)

  -- The table of choices to present to the user. It's comprised of one empty
  -- item (which we update as the user types), and those passed in as items
  local choice_list = { { text = '' } }
  for i = 1, #items do
    choice_list[#choice_list + 1] = items[i]
  end

  ch:choices(function()
    ---@diagnostic disable-next-line: assign-type-mismatch
    choice_list[1]['text'] = ch:query()
    return choice_list
  end)

  -- Re-compute the choices every time a key is pressed, to ensure that the top
  -- choice is always the entered text:
  ch:queryChangedCallback(function()
    ch:refreshChoicesCallback()
  end)

  ch:show()
end

return chooser
