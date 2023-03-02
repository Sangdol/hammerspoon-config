--
-- Enable / disable Do Not Disturb and Bluetooth based on conditions
--

local dndApps = {'IINA'}
local logger = hs.logger.new('dnd', 'debug')

local function isWorkingHours()
  local hour = tonumber(os.date('%H'))
  local day = tonumber(os.date('%w'))
  return (hour >= 9) and (hour < 18) and (day ~= 0) and (day ~= 6)
end

local function appWatcherHandler(appName, eventType)
  if (not tl.isInList(dndApps, appName)) and isWorkingHours() then
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
