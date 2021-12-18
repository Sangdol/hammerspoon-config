--
-- Watchers
--
bt = require('bluetooth_lib')
wf = require('wifi_lib')
timer = require('timer_lib')

logger = hs.logger.new('watchers', 5)

w = {}

-- https://www.hammerspoon.org/docs/hs.caffeinate.watcher.html#systemDidWake
function w.cafeHandler(eventType)
  --logger:d('cafe', eventType)

  if (eventType == hs.caffeinate.watcher.systemDidWake) then
    logger:d('=== Hallo Hallo ===')

    wf.turnOn()

    timer.safeWaitUntil(function()
      return wf.isOn()
    end, function()
      if wf.isSecond() then
        bt.connect()
      else
        logger:d('Skipping connecting to bluetooth')
      end

      -- Sometimes Redshift doesn't work well after restarting
      -- e.g., Redshift: still on when it shouldn't / one monitor doesn't have a warm color
      --       (a similar issue https://github.com/Hammerspoon/hammerspoon/issues/1197)
      --
      -- This has to run after timer is done
      -- since timer doesn't work if this is called
      -- before a timer is ended for some reason.
      hs.reload()
    end, 15, 'connecting to Wifi')

  elseif (eventType == hs.caffeinate.watcher.systemWillSleep) then
    -- Turning it off to avoid wake it up for reminders.
    wf.turnOff()
    bt.turnOff()

    logger:d('=== Bis Bald ===')
  end
end

cafe = hs.caffeinate.watcher.new(w.cafeHandler)
cafe:start()

