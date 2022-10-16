--
-- Caffeinate for better sleep
--

local bt = require('lib/bluetooth_lib')
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

    bt.conditionallyConnect()
    dnd.conditionallyTurnOnOff()

    -- Restart Espanso
    hs.task.new('/usr/local/bin/espanso',
      function(exitCode, stdout, stderr)
        logger:i('$ espanso restart')
        logger:i(exitCode, stdout, stderr)
      end,
      {'restart'}):start()

    -- Sometimes Redshift doesn't work well after restarting
    -- e.g., Redshift: still on when it shouldn't / one monitor doesn't have a warm color
    --       (a similar issue https://github.com/Hammerspoon/hammerspoon/issues/1197)
    --
    -- reload() distrubs timer.
    --hs.reload()
  elseif (eventType == hs.caffeinate.watcher.systemWillSleep) then
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

