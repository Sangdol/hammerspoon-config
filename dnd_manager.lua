--
-- Enable / disable DND based on conditions
-- using https://github.com/Sangdol/do-not-disturb-timer-jxa
--
bt = require('bluetooth_lib')
tl = require('table_lib')
no = require('notification_lib')

dnd = {}

logger = hs.logger.new('dnd_manager', 5)

apps = {'Melodics', 'Movist'}

function dnd.appWatcherHandler(appName, eventType, appObject)
  if (not tl.isInList(apps, appName)) then
    return
  end

  if (eventType == hs.application.watcher.launched) and
    (tl.isInList(apps, appName)) then
    logger:d('DND On', appName)
    dnd.onOff(true)
    bt.turnOff()
  elseif (eventType == hs.application.watcher.terminated) then
    logger:d('DND Off', appName)
    dnd.onOff(false)
    bt.conditionallyConnect()
  end
end

function dnd.onOff(on)
  -- https://github.com/Sangdol/do-not-disturb-timer-jxa
  local prefix = '/usr/local/bin/node $HOME/projects/do-not-disturb-timer-jxa/onoff.js'

  if (on) then
    no.alert('DND On')
    hs.execute(prefix .. ' ' .. 'on', true)
  else
    no.alert('DND Off')
    hs.execute(prefix .. ' ' .. 'off', true)
  end
end

dnd.appWatcher = hs.application.watcher.new(dnd.appWatcherHandler)
dnd.appWatcher:start()
