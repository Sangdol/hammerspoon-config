--
-- Watchers
--
bt = require('bluetooth_lib')
wf = require('wifi_lib')

logger = hs.logger.new('watchers', 5)

w = {}

-- https://www.hammerspoon.org/docs/hs.caffeinate.watcher.html#systemDidWake
function cafeHandler(eventType)
  --logger:d('cafe', eventType)

  if (eventType == hs.caffeinate.watcher.systemDidWake) then
    logger:d('=== Hallo Hallo ===')

    hs.wifi.setPower(true)

    -- Sometimes Redshift doesn't work well after restarting
    -- e.g., Redshift: still on when it shouldn't / one monitor doesn't have a warm color
    --       (a similar issue https://github.com/Hammerspoon/hammerspoon/issues/1197)
    hs.reload()

  elseif (eventType == hs.caffeinate.watcher.systemWillSleep) then
    -- Turning it off to avoid wake it up for reminders.
    hs.wifi.setPower(false)
    bt.turnOff()

    logger:d('=== Bis Bald ===')
  end
end

-- https://www.hammerspoon.org/docs/hs.wifi.watcher.html#eventTypes
-- No documentation about the arguments... but a use case is here:
-- https://github.com/kalupa/dotfiles/blob/65cc156b93c66a5ae07761c91cdf7da28161b1e5/hammerspoon/.hammerspoon/wifi-status-change.lua#L75
function wifiHandler(watcher, eventType, interface)
  logger:d('wifi', eventType)

  -- The list of events: https://github.com/Hammerspoon/hammerspoon/blob/master/extensions/wifi/libwifi_watcher.m#L504
  -- There's the "powerChange" event but it's triggered before Wifi is connected.
  -- The SSIDChange event is triggered when Wifi is connected to an access point
  -- but it's not triggered when Wifi is turned off.
  if (eventType == 'SSIDChange') then
    if wf.isOn() then
      if wf.isSecond() then
        logger:d('Connecting to bluetooth...')
        bt.connect()
      else
        logger:d('Skipping connecting to bluetooth...')
      end
    end
  end
end

wfw = hs.wifi.watcher.new(wifiHandler)
wfw:watchingFor('SSIDChange')
wfw:start()

cafe = hs.caffeinate.watcher.new(cafeHandler)
cafe:start()

