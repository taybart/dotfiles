local config = require('pomodoro/config')
local db = require('pomodoro/db')

local state = {
  sync_timer = nil,
  pomo_timer = nil,

  pomo = { running = false, name = '', paused = false, time = 0 },
  take_break = { running = false, time = 0, paused = false },
  can_recover = false,
  -- old state recovered from db
  last = {},
  current_pomo_id = nil,
}

function state.init()
  db:setup_tables()
  state.load()

  -- Separate sync timer for database saves (frequent) from UI timer (minute-based)
  state.sync_timer = hs.timer.doEvery(5, function() -- Sync every 5 seconds for database
    local should_sync = (state.pomo.running and not state.pomo.paused) or state.take_break.running
    print(
      string.format(
        'DEBUG: sync check - pomo.running=%s, pomo.paused=%s, take_break.running=%s, should_sync=%s',
        tostring(state.pomo.running),
        tostring(state.pomo.paused),
        tostring(state.take_break.running),
        tostring(should_sync)
      )
    )

    if should_sync then
      print('DEBUG: syncing to database')
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
      time = current.time,
    }
    state.last.take_break = {
      running = current.break_running,
      time = current.break_time,
      paused = (current.paused and current.break_running) or false,
    }
    print(
      string.format(
        'DEBUG: loaded state - break_running=%s, break_time=%d, break_paused=%s',
        tostring(current.break_running),
        current.break_time,
        tostring(state.last.take_break.paused)
      )
    )
    state.current_pomo_id = current.id
    state.can_recover = true
  else
    print('no saved pomo state found')
  end
end

function state.save()
  if state.current_pomo_id then
    print(
      string.format(
        'DEBUG: saving state - pomo.running=%s, pomo.paused=%s, pomo.time=%d, break_running=%s, break_time=%d, current_pomo_id=%s',
        tostring(state.pomo.running),
        tostring(state.pomo.paused),
        state.pomo.time,
        tostring(state.take_break.running),
        state.take_break.time,
        tostring(state.current_pomo_id)
      )
    )

    local stmt = assert(db.conn:prepare([[
      UPDATE pomos
      SET running = :running, paused = :paused, time = :time,
          break_running = :break_running, break_time = :break_time
      WHERE id = :id
    ]]))
    stmt:bind_names({
      running = state.pomo.running,
      paused = (state.take_break.running and state.take_break.paused)
          or (state.pomo.running and state.pomo.paused),
      time = state.pomo.time,
      break_running = state.take_break.running,
      break_time = state.take_break.time,
      id = state.current_pomo_id,
    })
    stmt:step()
    stmt:finalize()
    print('DEBUG: database save completed')
  else
    print('DEBUG: no current_pomo_id, skipping save')
  end
end

function state:start(name, tick)
  print('DEBUG: state:start() called')
  if self.pomo_timer then
    print('DEBUG: stopping existing pomo_timer')
    self.pomo_timer:stop()
  end
  self.pomo = { running = true, time = config.POMO_LENGTH, name = name }
  self.take_break = { running = false, time = 0, paused = false } -- Reset break state too
  self.pomo_timer = hs.timer.doEvery(config.INTERVAL_SECONDS, tick)
  print('DEBUG: created new pomo_timer:', tostring(self.pomo_timer))

  -- Create new pomo in database
  db:add_pomo(self.pomo)
  local latest = db:get_latest_pomos(1)
  if #latest > 0 then self.current_pomo_id = latest[1].id end
end

function state:recover(tick)
  print('RECOVERING OLD STATE')
  print(
    string.format(
      'DEBUG: recover() before - pomo.running=%s, take_break.running=%s',
      tostring(self.last.pomo.running),
      tostring(self.last.take_break.running)
    )
  )

  self.pomo = self.last.pomo
  self.take_break = self.last.take_break

  -- Make sure we don't have multiple timers running
  if self.pomo_timer then
    print('DEBUG: stopping existing timer before recovery')
    self.pomo_timer:stop()
  end

  self.pomo_timer = hs.timer.doEvery(config.INTERVAL_SECONDS, tick)
  print('DEBUG: recovered with pomo_timer:', tostring(self.pomo_timer))
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
  print('DEBUG: toggle_paused() called, current pomo.paused =', self.pomo.paused)
  self.pomo.paused = not self.pomo.paused
  print('DEBUG: toggle_paused() after, pomo.paused =', self.pomo.paused)
end

function state:break_time()
  print('🌴 Starting break time...')
  print(
    string.format(
      'DEBUG: break_time() before - pomo.running=%s, take_break.running=%s, pomo_timer=%s',
      tostring(self.pomo.running),
      tostring(self.take_break.running),
      tostring(self.pomo_timer)
    )
  )

  -- IMPORTANT: Keep the timer running! Don't stop it during break transition
  -- Only reset pomo state, keep timer alive
  self.pomo = { running = false, name = '', paused = false, time = 0 }
  self.take_break = { running = true, time = config.BREAK_LENGTH, paused = false }

  print(
    string.format(
      'DEBUG: break_time() after - pomo.running=%s, take_break.running=%s, pomo_timer=%s',
      tostring(self.pomo.running),
      tostring(self.take_break.running),
      tostring(self.pomo_timer)
    )
  )

  -- Save immediately and aggressively during break transition
  self:save()
  print('DEBUG: break_time() save completed')

  -- Force an immediate second sync to ensure break state is saved
  print('DEBUG: forcing immediate second sync after break transition')
  self:save()
end

function state:done()
  print('DEBUG: done() called')
  self.take_break = { running = false, time = 0, paused = false }

  -- Only stop the timer when completely done (not just transitioning from pomo to break)
  if self.pomo_timer and not self.pomo.running and not self.take_break.running then
    print('DEBUG: stopping pomo_timer - completely done')
    self.pomo_timer:stop()
    self.pomo_timer = nil -- Clear the reference
  else
    print('DEBUG: NOT stopping pomo_timer - either pomo or break still running')
  end

  if self.current_pomo_id then
    db:mark_complete(self.current_pomo_id)
    self.current_pomo_id = nil
  end
end

return state
