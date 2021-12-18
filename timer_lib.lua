--
-- https://www.hammerspoon.org/docs/hs.timer.html
--
timer = {}

local logger = hs.logger.new('timer', 5)

function timer.safeWaitUntil(predicateFn, actionFn, failtureFn, count)
  local waitCounter = 0

  hs.timer.waitUntil(function()
    if waitCounter < count then
      waitCounter = waitCounter + 1
      return predicateFn()
    else
      failtureFn()
      return true
    end
  end, actionFn)
end

return timer
