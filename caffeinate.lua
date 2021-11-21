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
  elseif (eventType == hs.caffeinate.watcher.systemWillSleep) then
    bt.turnOff()
  end
end

cafe = hs.caffeinate.watcher.new(cafe.handler)
cafe:start()

