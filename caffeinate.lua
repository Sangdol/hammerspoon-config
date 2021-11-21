--
-- Sleep / awake watcher
-- https://www.hammerspoon.org/docs/hs.caffeinate.watcher.html#systemDidWake
--
bt = require('bluetooth_lib')

logger = hs.logger.new('cafe', 5)

cafe = {}

function cafe.handler(eventType)
  --logger:d('cafe', eventType)

  if (eventType == hs.caffeinate.watcher.systemDidWake) then
    bt.connect()

    -- Sometimes Redshift doesn't work well after restarting
    -- e.g., Redshift: still on when it shouldn't / one monitor doesn't have a warm color
    --       (a similar issue https://github.com/Hammerspoon/hammerspoon/issues/1197)
    --       appWatcher doesn't work (even after reload() if there's no timer.
    hs.timer.doAfter(5, hs.reload)
  elseif (eventType == hs.caffeinate.watcher.systemWillSleep) then
    bt.turnOff()
  end
end

cafe = hs.caffeinate.watcher.new(cafe.handler)
cafe:start()

