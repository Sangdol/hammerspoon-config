--
-- Caffeinate for better sleep
--

local logger = hs.logger.new('cafe', 'info')

Cafe = {}
Cafe.isSleeping = false
Cafe.isLocked = false
Cafe.wakeUpTime = os.time()

-- https://www.hammerspoon.org/docs/hs.caffeinate.watcher.html#systemDidWake
function Cafe.cafeHandler(eventType)
  logger:d('Cafe', eventType)

  if (eventType == hs.caffeinate.watcher.systemDidWake) then
    logger:i('')
    logger:i('===================')
    logger:i('=== Hallo Hallo ===')
    logger:i('===================')

    Cafe.isSleeping = false
    Cafe.wakeUpTime = os.time()

    bt.conditionallyConnect()

    espanso.restartRetry(3)

    -- Sometimes Redshift doesn't work well after restarting
    -- e.g., Redshift: still on when it shouldn't / one monitor doesn't have a warm color
    --       (a similar issue https://github.com/Hammerspoon/hammerspoon/issues/1197)
    --
    -- reload() distrubs timer.
    --hs.reload()
  elseif (eventType == hs.caffeinate.watcher.systemWillSleep) then
    Cafe.isSleeping = true

    logger:i('================')
    logger:i('=== Bis Bald ===')
    logger:i('================')
    logger:i('')
  elseif (eventType == hs.caffeinate.watcher.screensDidUnlock) then
    Cafe.isLocked = false
  elseif (eventType == hs.caffeinate.watcher.screensDidLock) then
    Cafe.isLocked = true
  end
end

Cafe.watcher = hs.caffeinate.watcher.new(Cafe.cafeHandler)
Cafe.watcher:start()

