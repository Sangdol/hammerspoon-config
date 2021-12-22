--
-- https://www.hammerspoon.org/docs/hs.timer.html
--
timer = {}

local DEFAULT_TRIAL = 10
local logger = hs.logger.new('timer', 'info')

function safeTimer(timerFn, predicateFn, actionFn, failtureFn, count)
  logger:d('SafeTimer', timerFn)

  count = count or DEFAULT_TRIAL

  local waitCounter = 0

  timerFn(function()
    if waitCounter < count then
      logger:d('SafeTimer waitCounter:', waitCounter)

      waitCounter = waitCounter + 1
      return predicateFn()
    else
      failtureFn()
      return true
    end
  end, actionFn)
end

function timer.safeDoUntil(predicateFn, actionFn, failtureFn, count)
  safeTimer(hs.timer.doUntil, predicateFn, actionFn, failtureFn, count)
end

function timer.safeWaitUntil(predicateFn, actionFn, failtureFn, count)
  safeTimer(hs.timer.waitUntil, predicateFn, actionFn, failtureFn, count)
end

return timer
