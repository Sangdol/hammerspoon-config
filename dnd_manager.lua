--
-- Enable / disable DND based on conditions
-- using https://github.com/Sangdol/do-not-disturb-timer-jxa
--

logger = hs.logger.new('dnd_manager', 5)

tl = require('table_lib')
no = require('notification')

apps = {'Melodics', 'Movist'}

function wa.appWatcherHandler(appName, eventType, appObject)
  if (not tl.isin(apps, appName)) then
    return
  end

  if (eventType == hs.application.watcher.launched) and
    (tl.isin(apps, appName)) then
    logger:d('DND On', appName)
    dndOnOff(true)
  elseif (eventType == hs.application.watcher.terminated) then
    logger:d('DND Off', appName)
    dndOnOff(false)
  end
end

function dndOnOff(on)
  local prefix = '/usr/local/bin/node $HOME/projects/do-not-disturb-timer-jxa/onoff.js'

  if (on) then
    no.alert('DND On')
    hs.execute(prefix .. ' ' .. 'on', true)
  else
    no.alert('DND Off')
    hs.execute(prefix .. ' ' .. 'off', true)
  end
end

appWatcher = hs.application.watcher.new(wa.appWatcherHandler)
appWatcher:start()
