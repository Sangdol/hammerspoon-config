--
-- Caffeinate
--
bt = require('lib/bluetooth_lib')
wf = require('lib/wifi_lib')
timer = require('lib/timer_lib')
no = require('lib/notification_lib')
dnd = require('lib/dnd_lib')

local logger = hs.logger.new('watchers', 'info')

w = {}

-- https://www.hammerspoon.org/docs/hs.caffeinate.watcher.html#systemDidWake
function w.cafeHandler(eventType)
  logger:d('Cafe', eventType)

  if (eventType == hs.caffeinate.watcher.systemDidWake) then
    logger:i('')
    logger:i('===================')
    logger:i('=== Hallo Hallo ===')
    logger:i('===================')

    -- Sometimes just doing wf.turnOn() doesn't work.
    -- (was it due to hs.reload()?)
    timer.safeDoUntil(function()
      return wf.isOn()
    end, function()
      wf.turnOn()
    end, function()
      no.notify('Failed to connect to Wifi.')
    end)

    bt.conditionallyConnect()

    dnd.turnOff()

    -- Sometimes Redshift doesn't work well after restarting
    -- e.g., Redshift: still on when it shouldn't / one monitor doesn't have a warm color
    --       (a similar issue https://github.com/Hammerspoon/hammerspoon/issues/1197)
    --
    -- reload() distrubs timer.
    --hs.reload()
  elseif (eventType == hs.caffeinate.watcher.systemWillSleep) then
    -- To prevent Reminder alerts wake up the laptop (hopefully)
    wf.turnOff()
    dnd.turnOn()
    bt.turnOff()

    logger:i('================')
    logger:i('=== Bis Bald ===')
    logger:i('================')
    logger:i('')
  end
end

cafe = hs.caffeinate.watcher.new(w.cafeHandler)
cafe:start()

