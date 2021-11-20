--
-- Sleep / awake watcher
-- https://www.hammerspoon.org/docs/hs.caffeinate.watcher.html#systemDidWake
--
logger = hs.logger.new('cafe', 5)

cafe = {}

function cafe.handler(eventType)
  --logger:d('cafe', eventType)

  -- only for work laptop?
  if (eventType == hs.caffeinate.watcher.systemDidWake) then
    logger:d("Connecting to bluetooth")
    hs.execute('$HOME/projects/osx/scripts/bluetooth.sh', true)
  elseif (eventType == hs.caffeinate.watcher.systemWillSleep) then
    hs.execute('/usr/local/bin/blueutil --power 0', true)
  end
end

cafe = hs.caffeinate.watcher.new(cafe.handler)
cafe:start()

