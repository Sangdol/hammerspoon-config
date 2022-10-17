--
-- Espanso
--

local logger = hs.logger.new('watchers', 'info')
local no = require('lib/notification_lib')

local espanso = {}

local function restart(callback)
  hs.task.new('/usr/local/bin/espanso', callback, {'restart'}):start()
end

function espanso.restartRetry(n)
  local i = 0

  EspansoCallback = function(exitCode, stdout, stderr)
    logger:i('$ espanso restart')
    logger:i(exitCode, stdout, stderr)

    if i < n and exitCode > 0  then
      i = i + 1
      restart(EspansoCallback)
    elseif i == n then
      no.notify('Failed to restart espanso after retries')
    end
  end
  restart(EspansoCallback)
end

return espanso
