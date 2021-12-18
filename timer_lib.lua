--
-- https://www.hammerspoon.org/docs/hs.timer.html
--
timer = {}

logger = hs.logger.new('timer', 5)

function timer.safeWaitUntil(predicateFn, actionFn, count, target)
  local waitCounter = 0

  hs.timer.waitUntil(function()
    if waitCounter < count then
      logger:d('Waiting for ' .. target)
      waitCounter = waitCounter + 1
      return predicateFn()
    else
      no.notify('Waited too long for ' .. target)
      return true
    end
  end, actionFn)
end

return timer
