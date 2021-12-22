--
-- Watchers
--
bt = require('bluetooth_lib')
wf = require('wifi_lib')
timer = require('timer_lib')
no = require('notification_lib')
dnd = require('dnd_manager')

local logger = hs.logger.new('watchers', 'info')

w = {}

-- https://www.hammerspoon.org/docs/hs.caffeinate.watcher.html#systemDidWake
function w.cafeHandler(eventType)
  logger:d('Cafe', eventType)

  if (eventType == hs.caffeinate.watcher.systemDidWake) then
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

    -- To prevent Reminder alerts wake up the laptop
    dnd.turnOff()

    -- Sometimes Redshift doesn't work well after restarting
    -- e.g., Redshift: still on when it shouldn't / one monitor doesn't have a warm color
    --       (a similar issue https://github.com/Hammerspoon/hammerspoon/issues/1197)
    --
    -- reload() distrubs timer.
    --hs.reload()
  elseif (eventType == hs.caffeinate.watcher.systemWillSleep) then
    -- Turning it off to avoid wake it up for reminders.
    wf.turnOff()
    bt.turnOff()
    dnd.turnOn()

    logger:i('================')
    logger:i('=== Bis Bald ===')
    logger:i('================')
  end
end

cafe = hs.caffeinate.watcher.new(w.cafeHandler)
cafe:start()

