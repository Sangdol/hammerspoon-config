--
-- Enable / disable Do Not Disturb and Bluetooth based on conditions
--

local dndApps = {'IINA'}
local logger = hs.logger.new('dnd', 'debug')

local function appWatcherHandler(appName, eventType)
  if (not tl.isInList(dndApps, appName)) then
    return
  else 
    logger:d('DND is starting. App Name: ', appName)
  end

  if (eventType == hs.application.watcher.launched) and
    (tl.isInList(dndApps, appName)) then
    dnd.turnOn()
  elseif (eventType == hs.application.watcher.terminated) then
    dnd.turnOff()
  end
end

DndAppWatcher = hs.application.watcher.new(appWatcherHandler)
DndAppWatcher:start()
