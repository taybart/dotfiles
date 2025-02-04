local client = {}
local db = hs.sqlite3.open(os.getenv('HOME') .. '/.pomodb')

function client:setup_tables()
  -- pomo = { running = false, name = '', paused = false, time = 0 },
  -- take_break = { running = false, time = 0 },
  assert(db:exec([[
    CREATE TABLE IF NOT EXISTS pomos (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      -- pomo
      name TEXT NOT NULL,
      running BOOLEAN DEFAULT FALSE,
      paused BOOLEAN DEFAULT FALSE,
      time INTEGER NOT NULL,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      completed_at DATETIME,
      -- break
      break_running BOOLEAN DEFAULT FALSE,
      break_time INTEGER DEFAULT 0
    );
  ]]))
end

function client:get_latest_pomos(count)
  if not count then
    count = 10
  end
  local stmt = assert(db:prepare([[
  SELECT * FROM pomos
  WHERE created_at IS NOT NULL
  ORDER BY created_at DESC
  LIMIT ?
  ]]))
  stmt:bind(1, count)

  local pomos = {}
  for row in stmt:nrows() do
    table.insert(pomos, row)
  end
  return pomos
end

function client:add_pomo(pomo)
  local stmt = assert(db:prepare([[
        INSERT INTO pomos
        (name, time, running, paused) VALUES
        (:name, :time, :running, :paused)
        ]]))
  stmt:bind_names(pomo)
  stmt:step()
  stmt:finalize()
end

function client:completed_today()
  local stmt = assert(client.conn:prepare([[
    SELECT * FROM pomos
    WHERE date(created_at) = date('now')
    AND completed_at IS NOT NULL
  ]]))

  local todays_pomos = {}
  for row in stmt:nrows() do
    table.insert(todays_pomos, row)
  end
  stmt:finalize()
  return todays_pomos
end

function client:get_unfinished()
  local stmt = assert(client.conn:prepare([[
    SELECT * FROM pomos
    WHERE date(created_at) = date('now')
    AND completed_at IS NULL
    AND running=true
    OR break_running=true
  ]]))

  local todays_pomos = {}
  for row in stmt:nrows() do
    table.insert(todays_pomos, row)
  end
  stmt:finalize()
  return todays_pomos
end

return client
