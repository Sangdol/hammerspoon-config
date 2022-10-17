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

  -- Need to declare the function variable separately to call it recursively
  -- https://stackoverflow.com/a/48210132/524588
  local callback
  callback = function(exitCode, stdout, stderr)
    logger:i('$ espanso restart')
    logger:i(exitCode, stdout, stderr)

    if i < n and exitCode > 0  then
      i = i + 1
      restart(callback)
    elseif i == n then
      no.notify('Failed to restart espanso after retries')
    end
  end
  restart(callback)
end

return espanso
