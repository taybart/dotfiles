local config = require('pomodoro/config')
-- local db = require('pomodoro/db')

local state = {
  _file_path = os.getenv('HOME') .. '/.pomo_state',

  sync_timer = nil,
  pomo_timer = nil,

  pomo = { running = false, name = '', paused = false, time = 0 },
  take_break = { running = false, time = 0 },
  can_recover = false,
  -- old state recovered from file
  last = {},
}

function state.init()
  -- db:setup_tables()
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
  -- local unfinished = db:unfinished()
  -- if unfinished then
  --   state.last.pomo = unfinished.pomo
  --   state.last.take_break = db:get_break()
  --   state.can_recover = true
  -- end
  local file = assert(io.open(state._file_path, 'r'))
  if file then
    local content = assert(file:read('*a'))
    file:close()
    print('content', content)
    if not content or content == '' then
      return
    end
    local decoded = assert(hs.json.decode(content))
    state.last.pomo = decoded.pomo
    state.last.take_break = decoded.take_break
    if state.last.pomo.running or state.last.take_break.running then
      state.can_recover = true
    end
  else
    print('no saved pomo state found')
  end
end

function state.save()
  local file = assert(io.open(state._file_path, 'w'))
  if file then
    local encoded = assert(hs.json.encode({
      pomo = state.pomo,
      take_break = state.take_break,
    }))
    file:write(encoded)
    file:close()
  else
    print('unable to save state')
  end
end

function state:start(name, tick)
  if self.pomo_timer then
    self.pomo_timer:stop()
  end
  self.pomo = { running = true, time = config.POMO_LENGTH, name = name }
  self.pomo_timer = hs.timer.doEvery(config.INTERVAL_SECONDS, tick)
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
  self:save() -- save that we are fully done
end

return state
