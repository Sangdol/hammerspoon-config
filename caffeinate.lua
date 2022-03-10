--
-- Caffeinate for better sleep
--

local bt = require('lib/bluetooth_lib')
local wf = require('lib/wifi_lib')
local timer = require('lib/timer_lib')
local no = require('lib/notification_lib')
local dnd = require('lib/dnd_lib')
local logger = hs.logger.new('watchers', 'info')

Cafe = {}

-- https://www.hammerspoon.org/docs/hs.caffeinate.watcher.html#systemDidWake
function Cafe.cafeHandler(eventType)
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

    -- Add delay to avoid race condition
    hs.timer.doAfter(3, function()
      dnd.conditionallyTurnOnOff()
    end)

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

Cafe.watcher = hs.caffeinate.watcher.new(Cafe.cafeHandler)
Cafe.watcher:start()

