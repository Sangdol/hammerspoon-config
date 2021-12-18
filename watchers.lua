--
-- Watchers
--
bt = require('bluetooth_lib')
wf = require('wifi_lib')
timer = require('timer_lib')

local logger = hs.logger.new('watchers', 5)

w = {}

-- https://www.hammerspoon.org/docs/hs.caffeinate.watcher.html#systemDidWake
function w.cafeHandler(eventType)
  --logger:d('cafe', eventType)

  if (eventType == hs.caffeinate.watcher.systemDidWake) then
    logger:d('=== Hallo Hallo ===')

    wf.turnOn()
    bt.conditionallyConnect()

    -- Sometimes Redshift doesn't work well after restarting
    -- e.g., Redshift: still on when it shouldn't / one monitor doesn't have a warm color
    --       (a similar issue https://github.com/Hammerspoon/hammerspoon/issues/1197)
    hs.reload()
  elseif (eventType == hs.caffeinate.watcher.systemWillSleep) then
    -- Turning it off to avoid wake it up for reminders.
    wf.turnOff()
    bt.turnOff()

    logger:d('=== Bis Bald ===')
  end
end

cafe = hs.caffeinate.watcher.new(w.cafeHandler)
cafe:start()

