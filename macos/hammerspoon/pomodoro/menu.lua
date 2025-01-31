local menu = {}

local function toggle_paused(app)
  if not app.has_pomo then
    return
  end
  app.pomo.paused = not app.pomo.paused
  app:update_ui()
end

function init(app)
  local m = hs.menubar.new()
  ---@diagnostic disable-next-line: undefined-field
  m:setMenu(function()
    local completed_count = #(log.get_completed_today())

    local pause_play = {
      title = 'Start',
      fn = function()
        self:start_new()
      end,
    }
    local stop = nil
    if self.has_pomo then
      pause_play = {
        title = 'Pause',
        fn = toggle_paused,
      }
      if self.pomo.paused then
        pause_play.title = 'Resume'
      end
      stop = {
        title = 'Stop',
        fn = function()
          self:stop()
        end,
      }
    end
    return {
      { title = completed_count .. ' pomos completed today', disabled = true },
      pause_play,
      stop,
    }
  end)
end

return menu
