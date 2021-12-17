--
-- Sleep / awake watcher
-- https://www.hammerspoon.org/docs/hs.caffeinate.watcher.html#systemDidWake
--
bt = require('bluetooth_lib')
wf = require('wifi_lib')

logger = hs.logger.new('cafe', 5)

cafe = {}

function cafe.handler(eventType)
  --logger:d('cafe', eventType)

  if (eventType == hs.caffeinate.watcher.systemDidWake) then
    logger:d('=== Hallo Hallo ===')

    hs.wifi.setPower(true)

    if wf.isSecond() then
      logger:d('Connecting to bluetooth...')
      bt.connect()
    else
      logger:d('Skipping connecting to bluetooth...')
    end

    -- Sometimes Redshift doesn't work well after restarting
    -- e.g., Redshift: still on when it shouldn't / one monitor doesn't have a warm color
    --       (a similar issue https://github.com/Hammerspoon/hammerspoon/issues/1197)
    hs.reload()

  elseif (eventType == hs.caffeinate.watcher.systemWillSleep) then
    hs.wifi.setPower(false)
    bt.turnOff()

    logger:d('=== Bis Bald ===')
  end
end

cafe = hs.caffeinate.watcher.new(cafe.handler)
cafe:start()

