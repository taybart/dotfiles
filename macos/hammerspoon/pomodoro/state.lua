local config = require('pomodoro/config')
local db = require('pomodoro/db')

local state = {
  sync_timer = nil,
  pomo_timer = nil,

  pomo = { running = false, name = '', paused = false, time = 0 },
  take_break = { running = false, time = 0 },
  can_recover = false,
  -- old state recovered from db
  last = {},
  current_pomo_id = nil,
}

function state.init()
  db:setup_tables()
  state.load()

  state.sync_timer = hs.timer.doEvery(config.INTERVAL_SECONDS, function()
    if state.pomo.running and not state.pomo.paused or state.take_break.running then
      state:save()
    end
  end)
  return state
end

function state.load()
  print('loading pomo state')
  local unfinished = db:unfinished()
  if unfinished and #unfinished > 0 then
    local current = unfinished[1]
    state.last.pomo = {
      running = current.running,
      name = current.name,
      paused = current.paused,
      time = current.time
    }
    state.last.take_break = {
      running = current.break_running,
      time = current.break_time
    }
    state.current_pomo_id = current.id
    state.can_recover = true
  else
    print('no saved pomo state found')
  end
end

function state.save()
  if state.current_pomo_id then
    local stmt = assert(db.conn:prepare([[
      UPDATE pomos 
      SET running = :running, paused = :paused, time = :time,
          break_running = :break_running, break_time = :break_time
      WHERE id = :id
    ]]))
    stmt:bind_names({
      running = state.pomo.running,
      paused = state.pomo.paused,
      time = state.pomo.time,
      break_running = state.take_break.running,
      break_time = state.take_break.time,
      id = state.current_pomo_id
    })
    stmt:step()
    stmt:finalize()
  end
end

function state:start(name, tick)
  if self.pomo_timer then
    self.pomo_timer:stop()
  end
  self.pomo = { running = true, time = config.POMO_LENGTH, name = name }
  self.pomo_timer = hs.timer.doEvery(config.INTERVAL_SECONDS, tick)
  
  -- Create new pomo in database
  db:add_pomo(self.pomo)
  local latest = db:get_latest_pomos(1)
  if #latest > 0 then
    self.current_pomo_id = latest[1].id
  end
end

function state:recover(tick)
  print('RECOVERING OLD STATE')
  self.pomo = self.last.pomo
  self.take_break = self.last.take_break
  self.pomo_timer = hs.timer.doEvery(config.INTERVAL_SECONDS, tick)
end

function state:stop()
  self.pomo = { running = false, name = '', paused = false, time = 0 }
  self.take_break = { running = false, time = 0 }
  if self.current_pomo_id then
    db:mark_complete(self.current_pomo_id)
    self.current_pomo_id = nil
  end
end

function state:toggle_paused()
  self.pomo.paused = not self.pomo.paused
end

function state:break_time()
  self.pomo = { running = false, name = '', paused = false, time = 0 }
  self.take_break = { running = true, time = config.BREAK_LENGTH }
end

function state:done()
  if self.pomo_timer then
    self.pomo_timer:stop()
  end
  self.take_break = { running = false, time = 0 }
  if self.current_pomo_id then
    db:mark_complete(self.current_pomo_id)
    self.current_pomo_id = nil
  end
end

return state
