--
-- Enable / disable DND based on conditions
-- using https://github.com/Sangdol/do-not-disturb-timer-jxa
--
bt = require('bluetooth_lib')
tl = require('table_lib')
no = require('notification_lib')

dnd = {}

local logger = hs.logger.new('dnd_manager', 5)
local DND_JS = '/usr/local/bin/node $HOME/projects/do-not-disturb-timer-jxa/onoff.js'

apps = {'Melodics', 'Movist'}

function dnd.appWatcherHandler(appName, eventType, appObject)
  if (not tl.isInList(apps, appName)) then
    return
  end

  if (eventType == hs.application.watcher.launched) and
    (tl.isInList(apps, appName)) then
    logger:d('DND On', appName)
    dnd.turnOn()
    bt.turnOff()
  elseif (eventType == hs.application.watcher.terminated) then
    logger:d('DND Off', appName)
    dnd.turnOff()
    bt.conditionallyConnect()
  end
end

function dnd.turnOn()
  no.alert('DND On')
  hs.execute(DND_JS .. ' ' .. 'on', true)
end

function dnd.turnOff()
  no.alert('DND Off')
  hs.execute(DND_JS .. ' ' .. 'off', true)
end

dnd.appWatcher = hs.application.watcher.new(dnd.appWatcherHandler)
dnd.appWatcher:start()
