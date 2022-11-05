--
-- Enable / disable Do Not Disturb and Bluetooth based on conditions
--

local dndApps = {'Melodics'}

local function appWatcherHandler(appName, eventType)
  if (not tl.isInList(dndApps, appName)) then
    return
  end

  if (eventType == hs.application.watcher.launched) and
    (tl.isInList(dndApps, appName)) then
    dnd.turnOn()
    bt.turnOff()
  elseif (eventType == hs.application.watcher.terminated) then
    dnd.turnOff()
    bt.conditionallyConnect()
  end
end

DndAppWatcher = hs.application.watcher.new(appWatcherHandler)
DndAppWatcher:start()
