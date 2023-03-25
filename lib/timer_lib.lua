--
-- Hammerspoon timer wrapper
-- https://www.hammerspoon.org/docs/hs.timer.html
--

local timer = {}

local DEFAULT_MAX_TRIAL = 10
local logger = hs.logger.new('timer', 'info')

function timer.sleep(seconds)
  hs.timer.usleep(seconds * 1000 * 1000)
end

-- This is a Hammerspoon timer wrapper that has a maxTrial parameter.
local function safeTimer(timerFn, predicateFn, actionFn, failtureFn, maxTrial, checkInterval)
  logger:d('SafeTimer', timerFn)

  maxTrial = maxTrial or DEFAULT_MAX_TRIAL
  checkInterval = checkInterval or 1

  local waitCounter = 0

  timerFn(function()
    if waitCounter < maxTrial then
      logger:d('SafeTimer waitCounter:', waitCounter)

      waitCounter = waitCounter + 1
      return predicateFn()
    else
      failtureFn()
      return true
    end
  end, actionFn)
end

function timer.safeDoUntil(predicateFn, actionFn, failtureFn, maxTrial, checkInterval)
  safeTimer(hs.timer.doUntil, predicateFn, actionFn, failtureFn, checkInterval, maxTrial)
end

function timer.safeWaitUntil(predicateFn, actionFn, failtureFn, maxTrial, checkInterval)
  safeTimer(hs.timer.waitUntil, predicateFn, actionFn, failtureFn, maxTrial, checkInterval)
end

return timer
