--
-- Enable / disable DND and Bluetooth based on conditions
--

bt = require('bluetooth_lib')
tl = require('table_lib')
no = require('notification_lib')
st = require('string_lib')

dnd = {}

local logger = hs.logger.new('dnd_manager', 5)

apps = {'Melodics', 'Movist'}

function dnd.appWatcherHandler(appName, eventType, appObject)
  if (not tl.isInList(apps, appName)) then
    return
  end

  if (eventType == hs.application.watcher.launched) and
    (tl.isInList(apps, appName)) then
    dnd.turnOn()
    bt.turnOff()
  elseif (eventType == hs.application.watcher.terminated) then
    dnd.turnOff()
    bt.conditionallyConnect()
  end
end

function dnd.isOn()
  local command = 'defaults read com.apple.controlcenter "NSStatusItem Visible FocusModes"'

  -- 1: on, 0: off
  local result = hs.execute('defaults read com.apple.controlcenter "NSStatusItem Visible FocusModes"')
  result = st.trim(result)

  return result == '1'
end

local function dndKeyStroke()
  hs.eventtap.keyStroke({'ctrl', 'alt', 'cmd', 'shift'}, 'z')
end

function dnd.turnOn()
  logger:d('DND On')
  no.alert('DND On')

  if not dnd.isOn() then
    dndKeyStroke()
  end
end

function dnd.turnOff()
  logger:d('DND Off')
  no.alert('DND Off')

  if dnd.isOn() then
    dndKeyStroke()
  end
end

dnd.appWatcher = hs.application.watcher.new(dnd.appWatcherHandler)
dnd.appWatcher:start()

return dnd
